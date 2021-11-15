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

class Index extends BaseController
{
    public function index()
    {
        $menu = get_admin_menus();
        View::assign('menu', $menu);
        return View();
    }

    public function main()
    {
        $install = false;
        if (file_exists(CMS_ROOT . 'app/install')) {
            $install = true;
        }
        $adminCount = Db::name('Admin')->where('status', '1')->count();
        $articleCount = Db::name('Article')->where('status', '1')->count();
        $scheduleCount = Db::name('Schedule')->where('status', '1')->count();
        View::assign('install', $install);
        View::assign('adminCount', $adminCount);
        View::assign('articleCount', $articleCount);
        View::assign('scheduleCount', $scheduleCount);
        return View();
    }

    public function errorShow()
    {
        echo '错误';
    }

}
