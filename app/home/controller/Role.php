<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\model\AdminGroup;
use app\home\validate\GroupCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Role extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            if (!empty($param['keywords'])) {
                $where[] = ['id|title|desc', 'like', '%' . $param['keywords'] . '%'];
            }
            $rows = empty($param['limit']) ? get_config(app . page_size) : $param['limit'];
            $group = AdminGroup::where($where)
                ->order('create_time asc')
                ->paginate($rows, false, ['query' => $param]);
            return table_assign(0, '', $group);
        } else {
            return view();
        }
    }

    //添加&编辑
    public function add()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
		$menu = get_admin_menu();
		$rule = get_admin_rule();
        if($id > 0) {
			$group = get_admin_group_info($id);
			$role_menu = create_tree_list(0, $menu, $group['menus']);
			$role_rule = create_tree_list(0, $rule, $group['rules']);
            $role = Db::name('AdminGroup')->where(['id' => $id])->find();
            View::assign('role', $role);
        }
		else{
			$role_menu = create_tree_list(0, $menu, []);
			$role_rule = create_tree_list(0, $rule, []);
		}
        View::assign('role_menu', $role_menu);
        View::assign('role_rule', $role_rule);
        View::assign('id', $id);
        return view();
    }

    //提交保存
    public function post_submit()
    {
        if (request()->isAjax()) {
            $param = get_params();
			$menuData = isset($param['menu']) ? $param['menu'] : 0;
			$ruleData = isset($param['rule']) ? $param['rule'] : 0;
			//sort($menuData);
			//sort($ruleData);
			$param['menus'] = implode(',',$menuData);
			$param['rules'] = implode(',',$ruleData);
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(GroupCheck::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                //为了系统安全id为1的系统所有者管理组不允许修改
                if ($param['id'] == 1) {
                    return to_assign(1, '为了系统安全,该管理组不允许修改');
                }
                Db::name('AdminGroup')->where(['id' => $param['id']])->strict(false)->field(true)->update($param);
                add_log('edit', $param['id'], $param);
            } else {
                try {
                    validate(GroupCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $gid = Db::name('AdminGroup')->strict(false)->field(true)->insertGetId($param);
                add_log('add', $gid, $param);
            }
            //清除菜单\权限缓存
            clear_cache('adminMenu');
            clear_cache('adminRules');
            return to_assign();
        }
    }

    //删除
    public function delete()
    {
        $id = get_params("id");
        if ($id == 1) {
            return to_assign(1, "该组是系统所有者，无法删除");
        }
        if (Db::name('AdminGroup')->delete($id) !== false) {
            add_log('delete', $id, []);
            return to_assign(0, "删除角色成功");
        } else {
            return to_assign(1, "删除失败");
        }
    }
}
