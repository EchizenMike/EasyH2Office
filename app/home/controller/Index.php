<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\base\BaseController;
use think\facade\Db;
use think\facade\View;

class Index extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $admin_id = $this->uid;
            //发票待审核统计
            $invoice_map_check[] = ['check_time','=',0];
            $invoice_map_check[] = ['check_admin_id','=',$admin_id];
            $invoice_map_check[] = ['status','=',1];
            $invoice_count_check = Db::name('Invoice')->where($invoice_map_check)->count();
            $statistics['invoice_html_check'] = '<a data-id="41" data-title="待审核发票" data-src="/home/invoice/index.html" class="site-menu-active"> 您有<font style="color:#FF0000">'.$invoice_count_check.'</font>条发票申请待审核</a>';
            //$statistics['invoice_count_check'] = $invoice_count_check;            
            if($invoice_count_check==0){
                $statistics['invoice_html_check'] = '';
            }

            //发票待开具统计
            $invoice_map_open[] = ['open_time','=',0];
            $invoice_map_open[] = ['open_admin_id','=',$admin_id];
            $invoice_map_open[] = ['status','=',1];
            $invoice_count_open = Db::name('Invoice')->where($invoice_map_open)->count();
            $statistics['invoice_html_open'] = '<a data-id="41" data-title="待开具发票" data-src="/home/invoice/index.html" class="site-menu-active"> 您有<font style="color:#FF0000">'.$invoice_count_open.'</font>条发票待开具</a>';
           // $statistics['invoice_count_open'] = $invoice_count_open;            
            if($invoice_count_open==0){
                $statistics['invoice_html_open'] = '';
            }

            //待审核的报销统计
            $expense_map_check[] = ['check_time','=',0];
            $expense_map_check[] = ['check_admin_id','=',$admin_id];
            $expense_map_check[] = ['status','=',1];
            $expense_count_check =  Db::name('Expense')->where($expense_map_check)->count();
            $statistics['expense_html_check'] = '<a data-id="40" data-title="报销管理" data-src="/home/expense/index.html" class="site-menu-active"> 您有<font style="color:#FF0000">'.$expense_count_check.'</font>条报销单待审核</a>';
           // $statistics['expense_count_check'] = $expense_count_check;            
            if($expense_count_check==0){
                $statistics['expense_html_check'] = '';
            }

            //未读消息统计
            $msg_map[] = ['to_uid','=',$admin_id];
            $msg_map[] = ['read_time','=',0];
            $msg_map[] = ['status','=',1];
            $msg_count = Db::name('Message')->where($msg_map)->count();
            $statistics['msg_html'] = '<a data-id="27" data-title="收件箱" data-src="/home/message/inbox.html" class="site-menu-active"> 您有<font style="color:#FF0000">'.$msg_count.'</font>条未读消息</a>';
            $statistics['msg_num'] = $msg_count;            
            if($msg_count==0){
                $statistics['msg_html'] = '';
            }

            foreach ($statistics as $key => $value) {
                if (!$value ) unset($statistics[$key]); 
            }
            return to_assign(0,'ok',$statistics);
        }
        else{
            $menu = get_admin_menus();
            View::assign('menu', $menu);
            return View();
        }
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
