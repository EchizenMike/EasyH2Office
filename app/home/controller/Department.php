<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\validate\DepartmentCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Department extends BaseController
{
    public function index()
    { 
        if (request()->isAjax()) {
            $list = Db::name('Department')->order('create_time asc')->select();
            return to_assign(0, '', $list);
        } else {
            return view();
        }
    }

    //添加部门
    public function add()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
        $pid = empty(get_params('pid')) ? 0 : get_params('pid');
		$department = set_recursion(d_department());
        if($id > 0) {
            $detail = Db::name('Department')->where(['id' => $id])->find();
            View::assign('detail', $detail);
        }
        View::assign('department', $department);
        View::assign('pid', $pid);
        View::assign('id', $id);
        return view();
    }

    public function post_submit()
    {
        if (request()->isAjax()) {
            $param = get_params();
            if ($param['id'] > 0) {
				try {
					validate(DepartmentCheck::class)->scene('edit')->check($param);
				} catch (ValidateException $e) {
					// 验证失败 输出错误信息
					return to_assign(1, $e->getError());
				}
				$param['update_time'] = time();
                Db::name('Department')->strict(false)->field(true)->update($param);
                add_log('edit', $param['id'], $param);
            } else {
                try {
                    validate(DepartmentCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $did = Db::name('Department')->strict(false)->field(true)->insertGetId($param);
                add_log('add', $did, $param);
            }
            return to_assign();
        }
    }

    //提交添加
    public function save()
    {
    	if($this->request->isPost()){
            $param = vae_get_param();
			if($param['id']>0){
				$result = $this->validate($param, 'app\home\validate\Department.edit');
				if ($result !== true) {
					return vae_assign(0,$result);
				} else {
					$param['update_time'] = time();
					$department_array=[];
					$department_cate = vae_get_department();
					$department_ids=get_data_node($department_cate,$param['id']);
					$department_array = array_column($department_ids, 'id');
					$department_array[]=$param['id'];
					if (in_array($param['pid'], $department_array)){
						return vae_assign(0,'上级部门不能是该部门本身或其下属部门');
					}
					else{
						$res = \think\loader::model('Department')->strict(false)->field(true)->update($param);
                        if($res) add_log('edit',$param['id'],$param);
					}					
				}
			}else{
				$result = $this->validate($param, 'app\home\validate\Department.add');
				if ($result !== true) {
					return vae_assign(0,$result);
				} else {
					$param['create_time'] = time();
					$mid = \think\loader::model('Department')->strict(false)->field(true)->insertGetId($param);					
				}
			}
			return vae_assign();
    	}
    }

    //删除
    public function delete()
    {
        $id = get_params("id");
        $count = Db::name('Department')->where(["pid" => $id,'status'=>['egt',0]])->count();
		$users = Db::name('Admin')->where(["did" => $id,'status'=>['egt',0]])->count();
        if ($count > 0) {
            return to_assign(1,"该部门下还有子部门，无法删除");
        }
        if ($users > 0) {
            return to_assign(1,"该部门下还有员工，无法删除");
        }
        if (Db::name('Department')->delete($id) !== false) {
            add_log('delete',$id);
            return to_assign(0,"删除部门成功");
        } else {
            return to_assign(1,"删除失败");
        }
    }
}
