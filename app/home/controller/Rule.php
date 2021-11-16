<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\validate\RuleCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Rule extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $rule = Db::name('adminRule')->order('create_time asc')->select();
            return to_assign(0, '', $rule);
        } else {
            return view();
        }
    }

    //添加
    public function add()
    {
        $param = get_params();
        if (request()->isAjax()) {
            if ($param['id'] > 0) {
                $data[$param['field']] = $param['value'];
                $data['id'] = $param['id'];
                if (!empty($data['title'])) {
                    try {
                        validate(RuleCheck::class)->scene('edit_title')->check($data);
                    } catch (ValidateException $e) {
                        // 验证失败 输出错误信息
                        return to_assign(1, $e->getError());
                    }
                }
                if (!empty($data['src'])) {
                    try {
                        validate(RuleCheck::class)->scene('edit_src')->check($data);
                    } catch (ValidateException $e) {
                        // 验证失败 输出错误信息
                        return to_assign(1, $e->getError());
                    }
                }
                Db::name('AdminRule')->strict(false)->field(true)->update($data);
                add_log('edit', $param['id'], $data);
            } else {
                try {
                    validate(RuleCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $rid = Db::name('AdminRule')->strict(false)->field(true)->insertGetId($param);
                //自动为系统所有者管理组分配新增的节点
                $group = Db::name('AdminGroup')->find(1);
                if (!empty($group)) {
                    $newGroup['id'] = 1;
                    $newGroup['rules'] = $group['rules'] . ',' . $rid;
                    Db::name('AdminGroup')->strict(false)->field(true)->update($newGroup);
                    add_log('add', $rid, $param);
                }
            }
            // 删除后台节点缓存
            clear_cache('adminRules');
            return to_assign();
        } else {
            $pid = empty($param['pid']) ? 0 : $param['pid'];
            View::assign('pid', $pid);
            return view();
        }
    }
    //删除
    public function delete()
    {
        $id = get_params("id");
        $count = Db::name('AdminRule')->where(["pid" => $id])->count();
        if ($count > 0) {
            return to_assign(1, "该节点下还有子节点，无法删除");
        }
        if (Db::name('AdminRule')->delete($id) !== false) {
            clear_cache('adminRules');
            add_log('delete', $id, []);
            return to_assign(0, "删除节点成功");
        } else {
            return to_assign(1, "删除失败");
        }
    }
}
