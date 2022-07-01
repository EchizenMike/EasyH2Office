<?php
/**
 * @copyright Copyright (c) 2022 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */
declare (strict_types = 1);
namespace app\contract\controller;

use app\api\BaseController;
use app\contract\model\ContractLog;
use think\facade\Db;
use think\facade\View;

class Api extends BaseController
{
	//获取项目概况数据
	public function get_contract()
    {
        $param = get_params();
		$where = array();
		if (!empty($param['keywords'])) {
			$where[] = ['id|name', 'like', '%' . $param['keywords'] . '%'];
		}
		$where[] = ['delete_time', '=', 0];
        $list = Db::name('Contract')->field('id,name,sign_uid,sign_time')->order('end_time asc')->where($where)->select()->toArray();
        if (!empty($list)) {
            foreach ($list as $k => &$v) {
                $v['sign_name'] = Db::name('Admin')->where('id',$v['sign_uid'])->value('name');
                $v['sign_time'] = date('Y-m-d', $v['sign_time']);
            }
        }
        to_assign(0, '', $list);
    }

    //添加附件
    public function add_file()
    {
        $param = get_params();
        $param['create_time'] = time();
        $param['admin_id'] = $this->uid;
        $fid = Db::name('ContractFile')->strict(false)->field(true)->insertGetId($param);
        if ($fid) {
            $log_data = array(
                'field' => 'file',
                'action' => 'upload',
                'contract_id' => $param['contract_id'],
                'admin_id' => $param['admin_id'],
                'old_content' => '',
                'new_content' => $param['file_name'],
                'create_time' => time(),
            );
            Db::name('ContractLog')->strict(false)->field(true)->insert($log_data);
            return to_assign(0, '上传成功', $fid);
        }
    }
    
    //删除
    public function delete_file()
    {
        if (request()->isDelete()) {
			$id = get_params("id");
			$data['id'] = $id;
			$data['delete_time'] = time();
			if (Db::name('ContractFile')->update($data) !== false) {
				$detail = Db::name('ContractFile')->where('id', $id)->find();
				$file_name = Db::name('File')->where('id', $detail['file_id'])->value('name');
                $log_data = array(
                    'field' => 'file',
                    'action' => 'delete',
                    'contract_id' => $detail['contract_id'],
                    'admin_id' => $this->uid,
                    'new_content' => $file_name,
                    'create_time' => time(),
                );
                Db::name('ContractLog')->strict(false)->field(true)->insert($log_data);
				return to_assign(0, "删除成功");
			} else {
				return to_assign(1, "删除失败");
			}
        } else {
            return to_assign(1, "错误的请求");
        }
    } 

	//审核等操作
    public function check()
    {
        if (request()->isPost()) {
			$params = get_params();
			if($params['status'] == 3){
				$params['check_uid'] = $this->uid;
				$params['check_time'] = time();
				$params['check_remark'] = $params['mark'];
			}
			if($params['status'] == 4){
				$params['stop_uid'] = $this->uid;
				$params['stop_time'] = time();
				$params['stop_remark'] = $params['mark'];
			}
			if($params['status'] == 5){
				$params['void_uid'] = $this->uid;
				$params['void_time'] = time();
				$params['void_remark'] = $params['mark'];
			}
			$old =  Db::name('Contract')->where('id', $params['id'])->find();
			if (Db::name('Contract')->strict(false)->update($params) !== false) {
                $log_data = array(
                    'field' => 'status',
                    'contract_id' => $params['id'],
                    'admin_id' => $this->uid,
                    'new_content' => $params['status'],
                    'old_content' => $old['status'],
                    'create_time' => time(),
                );
                Db::name('ContractLog')->strict(false)->field(true)->insert($log_data);
				return to_assign(0, "操作成功");
			} else {
				return to_assign(1, "操作失败");
			}
        } else {
            return to_assign(1, "错误的请求");
        }
    }

	//归档等操作
    public function archive()
    {
        if (request()->isPost()) {
			$params = get_params();
			$old = 1;
			if($params['archive_status'] == 1){
				$params['archive_uid'] = $this->uid;
				$params['archive_time'] = time();
				$old = 0;
			}
			$old =  Db::name('Contract')->where('id', $params['id'])->find();
			if (Db::name('Contract')->strict(false)->update($params) !== false) {
                $log_data = array(
                    'field' => 'archive_status',
                    'contract_id' => $params['id'],
                    'admin_id' => $this->uid,
                    'new_content' => $params['archive_status'],
                    'old_content' => $old['archive_status'],
                    'create_time' => time(),
                );
                Db::name('ContractLog')->strict(false)->field(true)->insert($log_data);
				return to_assign(0, "操作成功");
			} else {
				return to_assign(1, "操作失败");
			}
        } else {
            return to_assign(1, "错误的请求");
        }
    }
	
	//合同操作日志列表
    public function contract_log()
    {
		$param = get_params();
		$list = new ContractLog();
		$content = $list->contract_log($param);
		return to_assign(0, '', $content);
    }

}
