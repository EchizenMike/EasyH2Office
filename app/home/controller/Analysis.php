<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use think\facade\Db;
use think\facade\View;

class Analysis extends BaseController
{
    public function index()
    {
        return View();
    }

    public function errorShow()
    {
        echo '错误';
    }

}
