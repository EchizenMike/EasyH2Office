<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\contract\controller;

use app\base\BaseController;
use app\contract\model\Contract as ContractList;
use app\contract\validate\ContractCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Index extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            $whereOr = array();
            if (!empty($param['keywords'])) {
                $where[] = ['a.id|a.name|c.title', 'like', '%' . $param['keywords'] . '%'];
            }
            if (!empty($param['cate_id'])) {
                $where[] = ['a.cate_id', '=', $param['cate_id']];
            }
			if (!empty($param['type'])) {
                $where[] = ['a.type', '=', $param['type']];
            }
			if (!empty($param['status'])) {
                $where[] = ['a.status', '=', $param['status']];
            }
            $where[] = ['a.delete_time', '=', 0];
            $where[] = ['a.archive_status', '=', 0];
			
			$uid = $this->uid;
			$auth = contract_auth($uid);
			if($auth==0){
				$whereOr[] =['a.admin_id|a.prepared_uid|a.sign_uid|a.keeper_uid', '=', $uid];
				$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',a.share_ids)")];
			}
			
            $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
            $content = ContractList::where($where)
				->where(function ($query) use($whereOr) {
					$query->whereOr($whereOr);
				})
                ->field('a.*,c.title as cate_title,d.title as sign_department')
                ->alias('a')
                ->join('contract_cate c', 'a.cate_id = c.id')
                ->join('department d', 'a.sign_did = d.id','LEFT')
                ->order('a.create_time desc')
                ->paginate($rows, false, ['query' => $param])
				->each(function ($item, $key) {
                    $item->keeper_name = Db::name('Admin')->where(['id' => $item->keeper_uid])->value('name');
                    $item->sign_name = Db::name('Admin')->where(['id' => $item->sign_uid])->value('name');
                    $item->sign_time = date('Y-m-d', $item->sign_time);
                    $item->interval_time = date('Y-m-d', $item->start_time) . ' 至 ' . date('Y-m-d', $item->end_time);
                    $item->type_name = ContractList::$Type[(int) $item->type];
                    $item->status_name = ContractList::$Status[(int) $item->status];
                    $item->chack_status_name = ContractList::$Status[(int) $item->CheckStatus];
					if($item->cost == 0){
						$item->cost = '-';
					}
				});
            return table_assign(0, '', $content);
        } else {
            return view();
        }
    }

    public function archive()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            $whereOr = array();
            if (!empty($param['keywords'])) {
                $where[] = ['a.id|a.name|c.title', 'like', '%' . $param['keywords'] . '%'];
            }
            if (!empty($param['cate_id'])) {
                $where[] = ['a.cate_id', '=', $param['cate_id']];
            }
			if (!empty($param['cate_id'])) {
                $where[] = ['a.cate_id', '=', $param['cate_id']];
            }
			if (!empty($param['type'])) {
                $where[] = ['a.type', '=', $param['type']];
            }
            $where[] = ['a.delete_time', '=', 0];
            $where[] = ['a.archive_status', '=', 1];
			
			$uid = $this->uid;
			$auth = contract_auth($uid);
			if($auth==0){
				$whereOr[] =['a.admin_id|a.prepared_uid|a.sign_uid|a.keeper_uid', '=', $uid];
				$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',a.share_ids)")];
			}
			
            $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
            $content = ContractList::where($where)
				->where(function ($query) use($whereOr) {
					$query->whereOr($whereOr);
				})
                ->field('a.*,c.title as cate_title,d.title as sign_department')
                ->alias('a')
                ->join('contract_cate c', 'a.cate_id = c.id')
                ->join('department d', 'a.sign_did = d.id','LEFT')
                ->order('a.create_time desc')
                ->paginate($rows, false, ['query' => $param])
				->each(function ($item, $key) {
                    $item->keeper_name = Db::name('Admin')->where(['id' => $item->keeper_uid])->value('name');
                    $item->sign_name = Db::name('Admin')->where(['id' => $item->sign_uid])->value('name');
                    $item->sign_time = date('Y-m-d', $item->sign_time);
                    $item->interval_time = date('Y-m-d', $item->start_time) . ' 至 ' . date('Y-m-d', $item->end_time);
                    $item->type_name = ContractList::$Type[(int) $item->type];
                    $item->status_name = ContractList::$Status[(int) $item->status];
                    $item->chack_status_name = ContractList::$Status[(int) $item->CheckStatus];
					if($item->cost == 0){
						$item->cost = '-';
					}
				});
            return table_assign(0, '', $content);
        } else {
            return view();
        }
    }

    //文章添加&&编辑
    public function add()
    {
        $param = get_params();
        if (request()->isAjax()) {
			if (isset($param['sign_time'])) {
                $param['sign_time'] = strtotime($param['sign_time']);
            }
			if (isset($param['start_time'])) {
                $param['start_time'] = strtotime($param['start_time']);
            }
            if (isset($param['end_time'])) {
                $param['end_time'] = strtotime($param['end_time']);
				if ($param['end_time'] <= $param['start_time']) {
					return to_assign(1, "结束时间需要大于开始时间");
				}
            }
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(ContractCheck::class)->scene($param['scene'])->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['update_time'] = time();
				$old = Db::name('Contract')->where(['id' => $param['id']])->find();
				$auth = contract_auth($this->uid);
				if($this->uid!=$old['admin_id'] && $auth==0 && $old['status'] == 1){
					return to_assign(1, "只有录入人员和合同管理员有权限操作");
				}
				if($auth==0 && $old['status'] > 1){
					return to_assign(1, "只有合同管理员有权限操作");
				}
				$res = contractList::strict(false)->field(true)->update($param);
				if ($res) {
					add_log('edit', $param['id'], $param);
					to_log($this->uid,$param,$old);
					return to_assign();
				} else {
					return to_assign(1, '操作失败');
				}
            } else {
                try {
                    validate(ContractCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['create_time'] = time();
                $param['admin_id'] = $this->uid;
				$aid = ContractList::strict(false)->field(true)->insertGetId($param);
				if ($aid) {
					add_log('add', $aid, $param);
					$log_data = array(
						'field' => 'new',
						'action' => 'add',
						'contract_id' => $aid,
						'admin_id' => $param['admin_id'],
						'create_time' => time(),
					);
					Db::name('ContractLog')->strict(false)->field(true)->insert($log_data);
					return to_assign();
				} else {
					return to_assign(1, '操作失败');
				}                
            }
        } else {
            $id = isset($param['id']) ? $param['id'] : 0;
            $type = isset($param['type']) ? $param['type'] : 0;
            $pid = isset($param['pid']) ? $param['pid'] : 0;
            View::assign('id', $id);
            View::assign('type', $type);
            View::assign('pid', $pid);
			View::assign('auth', contract_auth($this->uid));
            if ($id > 0) {
                $detail = (new ContractList())->detail($id);
				if($detail['status']>1){
					echo '<div style="text-align:center;color:red;margin-top:20%;">当前状态不开放编辑，请联系合同管理员</div>';exit;
				}
                View::assign('detail', $detail);
                return view('edit');
            }
			if($pid>0){
				$p_contract = Db::name('Contract')->where(['id' => $pid])->find();
                View::assign('p_contract', $p_contract);
			}
            return view();
        }
    }

    //查看文章
    public function view()
    {
        $id = get_params("id");
        $detail = (new ContractList())->detail($id);
		$auth = contract_auth($this->uid);
		
		$auth_array=[];
		if(!empty($detail['share_ids'])){
			$auth_array = explode(",",$detail['share_ids']);
		}		
		array_push($auth_array,$detail['admin_id'],$detail['prepared_uid'],$detail['sign_uid'],$detail['keeper_uid']);
		
		if($auth==0 && !in_array($this->uid,$auth_array)){
			echo '<div style="text-align:center;color:red;margin-top:20%;">你无权限查看该合同</div>';exit;
		}
        View::assign('auth', $auth);
        View::assign('detail', $detail);
        return view();
    }
    //删除文章
    public function delete()
    {
		if (request()->isDelete()) {
			$id = get_params("id");
			$data['id'] = $id;
			$data['delete_time'] = time();
			if (Db::name('Contract')->update($data) !== false) {
				add_log('delete', $id);
				$log_data = array(
					'field' => 'del',
					'action' => 'delete',
					'contract_id' => $id,
					'admin_id' => $this->uid,
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
}
