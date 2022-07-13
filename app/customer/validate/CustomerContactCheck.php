<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\customer\validate;

use think\Validate;

class CustomerContactCheck extends Validate
{
    protected $rule = [
        'name' => 'require',
        'mobile' => 'require|unique:customer_contact',
        'id' => 'require',
    ];

    protected $message = [
        'name.require' => '联系人姓名不能为空',
        'mobile.unique' => '同样的手机号码已经存在',
        'id.require' => '缺少更新条件',
    ];

    protected $scene = [
        'add' => ['name','mobile'],
        'edit' => ['id', 'name','mobile'],
    ];
}
