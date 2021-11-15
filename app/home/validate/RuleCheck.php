<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\home\validate;

use think\Validate;

class RuleCheck extends Validate
{
    protected $rule = [
        'title' => 'require|unique:admin_rule',
        'src' => 'unique:admin_rule',
        'id' => 'require',
    ];

    protected $message = [
        'title.require' => '节点名称不能为空',
        'title.unique' => '同样的节点名称已经存在',
        'src.unique' => '同样的节点规则已经存在',
        'id.require' => '缺少更新条件',
        'filed.require' => '缺少要更新的字段名',
    ];

    protected $scene = [
        'add' => ['title','src'],
        'edit_title' => ['id', 'title'],
        'edit_src' => ['id', 'src'],
    ];
}
