<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\home\validate;

use think\Validate;

class MenuCheck extends Validate
{
    protected $rule = [
        'title' => 'require|unique:admin_menu',
        'id' => 'require',
    ];

    protected $message = [
        'title.require' => '菜单名称不能为空',
        'title.unique' => '同样的菜单名称已经存在',
        'id.require' => '缺少更新条件',
    ];

    protected $scene = [
        'add' => ['title'],
        'edit' => ['id','title'],
    ];
}
