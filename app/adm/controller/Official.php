<?php
/**
+-----------------------------------------------------------------------------------------------
* GouGuOPEN [ 左手研发，右手开源，未来可期！]
+-----------------------------------------------------------------------------------------------
* @Copyright (c) 2021~2024 http://www.gouguoa.com All rights reserved.
+-----------------------------------------------------------------------------------------------
* @Licensed 勾股OA，开源且可免费使用，但并不是自由软件，未经授权许可不能去除勾股OA的相关版权信息
+-----------------------------------------------------------------------------------------------
* @Author 勾股工作室 <hdm58@qq.com>
+-----------------------------------------------------------------------------------------------
*/
 
declare (strict_types = 1);

namespace app\adm\controller;

use app\base\BaseController;
use app\adm\model\OfficialDocs;
use app\adm\validate\CarValidate;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Official extends BaseController
{
	/**
     * 构造函数
     */
	protected $model;
    public function __construct()
    {
		parent::__construct(); // 调用父类构造函数
        $this->model = new OfficialDocs();
    }
	
    /**
    * 数据列表
    */
    public function datalist()
    {
		$param = get_params();
        if (request()->isAjax()) {
			$where=[];
			$where[]=['delete_time','=',0];
			if (!empty($param['tab'])) {
                //$where[] = [];
            }
            if (!empty($param['keywords'])) {
                $where[] = ['id|title', 'like', '%' . $param['keywords'] . '%'];
            }
            $list = $this->model->datalist($where, $param);
            return table_assign(0, '', $list);
        }
        else{
			View::assign('secrets', $this->model::$Secrets);
			View::assign('urgency', $this->model::$Urgency);
            return view();
        }
    }
	
    /**
    * 添加/编辑
    */
    public function add()
    {
		$param = get_params();	
        if (request()->isAjax()) {
			if (isset($param['draft_time'])) {
                $param['draft_time'] = strtotime($param['draft_time']);
            }	
            if (!empty($param['id']) && $param['id'] > 0) {
				$this->model->edit($param);
            } else {
				$param['admin_id'] = $this->uid;
                $this->model->add($param);
            }	 
        }else{
			$id = isset($param['id']) ? $param['id'] : 0;
			if ($id>0) {
				$detail = $this->model->getById($id);
				if(!empty($detail['file_ids'])){
					$file_array = Db::name('File')->where('id','in',$detail['file_ids'])->select();
					$detail['file_array'] = $file_array;
				}
                View::assign('detail', $detail);
				return view('edit');
			}
			return view();
		}
    }
	
    /**
    * 查看
    */
    public function view($id)
    {
		$detail = $this->model->getById($id);
		if (!empty($detail)) {
			if(!empty($detail['file_ids'])){
				$file_array = Db::name('File')->where('id','in',$detail['file_ids'])->select();
				$detail['file_array'] = $file_array;
			}
			View::assign('detail', $detail);
			return view();
		}
		else{
			return view(EEEOR_REPORTING,['warning'=>'找不到页面']);
		}
    }
	
   /**
    * 删除
    */
    public function del($id)
    {
		if (request()->isDelete()) {
			$this->model->delById($id);
		} else {
            return to_assign(1, "错误的请求");
        }
    }  
	
	//待审公文列表
    public function pending()
    {
        if (request()->isAjax()) {
			$param = get_params();
			$where = [];
			if (!empty($param['keywords'])) {
                $where[] = ['c.title', 'like', '%' . $param['keywords'] . '%'];
            }
			if (!empty($param['diff_time'])) {
				$diff_time =explode('~', $param['diff_time']);
                $where[] = ['cr.repair_time', 'between', [strtotime(urldecode($diff_time[0])),strtotime(urldecode($diff_time[1]))]];
            }
			$where[] = ['cr.types','=',1];
			$where[] = ['cr.delete_time','=',0];
            $model = new Car();
			$list = $this->model->repairlist($where, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }
	
	//已审公文列表
    public function reviewed()
    {
        if (request()->isAjax()) {
			$param = get_params();
			$where = [];
			if (!empty($param['keywords'])) {
                $where[] = ['cf.title|c.title', 'like', '%' . $param['keywords'] . '%'];
            }
			if (!empty($param['diff_time'])) {
				$diff_time =explode('~', $param['diff_time']);
                $where[] = ['cf.fee_time', 'between', [strtotime(urldecode($diff_time[0])),strtotime(urldecode($diff_time[1]))]];
            }
			if (!empty($param['types'])) {
                $where[] = ['cf.types','=',$param['types']];
            }
			$where[] = ['cf.delete_time','=',0];
			$list = $this->model->feelist($where, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }
}
