<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\validate\MenuCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Menu extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $menu = Db::name('AdminMenu')->order('sort asc')->select();
            return to_assign(0, '', $menu);
        } else {
            return view();
        }
    }

    //添加菜单页面
    public function add()
    {
        $param = get_params();
        if (request()->isAjax()) {
            if ($param['id'] > 0) {
                try {
                    validate(MenuCheck::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['update_time'] = time();
                Db::name('AdminMenu')->strict(false)->field(true)->update($param);
                add_log('edit', $param['id'], $param);
            } else {
                try {
                    validate(MenuCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['create_time'] = time();
                $mid = Db::name('AdminMenu')->strict(false)->field(true)->insertGetId($param);
                //自动为系统所有者管理组分配新增的菜单
                $group = Db::name('AdminGroup')->find(1);
                if (!empty($group)) {
                    $newGroup['id'] = 1;
                    $newGroup['menus'] = $group['menus'] . ',' . $mid;
                    Db::name('AdminGroup')->strict(false)->field(true)->update($newGroup);
                    add_log('add', $mid, $param);
                }
            }
            // 删除后台菜单缓存
            clear_cache('adminMenu');
            return to_assign();
        } else {
            $id = isset($param['id']) ? $param['id'] : 0;
            $pid = isset($param['pid']) ? $param['pid'] : 0;
            if($id>0){
                $detail = Db::name('AdminMenu')->where('id',$id)->find();
                View::assign('detail', $detail);
            }
            View::assign('id', $id);
            View::assign('pid', $pid);
            return view();
        }
    }

    //删除
    public function delete()
    {
        $id = get_params('id');
        $count = Db::name('AdminMenu')->where(['pid' => $id])->count();
        if ($count > 0) {
            return to_assign(1, '该菜单下还有子菜单，无法删除');
        }
        if (Db::name('AdminMenu')->delete($id) !== false) {
            // 删除后台菜单缓存
            clear_cache('adminMenu');
            add_log('delete', $id, []);
            return to_assign(0, '删除菜单成功');
        } else {
            return to_assign(1, '删除失败');
        }
    }
}
