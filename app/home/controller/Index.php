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
            $invoice_map_check[] = ['check_status', '<', 2];
            $invoice_map_check[] = ['', 'exp', Db::raw("FIND_IN_SET('{$admin_id}',check_admin_ids)")];
            $invoice_map_check[] = ['delete_time', '=', 0];
            $invoice_count_check = Db::name('Invoice')->where($invoice_map_check)->count();
            $statistics['invoice_html_check'] = '<a data-id="130" class="side-menu-item" data-href="/finance/invoice/list" class="menu-active"> 您有<font style="color:#FF0000">' . $invoice_count_check . '</font>条发票申请待审核</a>';
            if ($invoice_count_check == 0) {
                $statistics['invoice_html_check'] = '';
            }

            //发票待开具统计
            $invoice_map_open[] = ['open_time', '=', 0];
            $invoice_map_open[] = ['open_admin_id', '=', $admin_id];
            $invoice_map_open[] = ['delete_time', '=', 0];
            $invoice_count_open = Db::name('Invoice')->where($invoice_map_open)->count();
            $statistics['invoice_html_open'] = '<a data-id="131" class="side-menu-item" data-href="/finance/invoice/checkedlist">您有<font style="color:#FF0000">' . $invoice_count_open . '</font>条发票待开具</a>';
            if ($invoice_count_open == 0) {
                $statistics['invoice_html_open'] = '';
            }

            //待审核的报销统计
            $expense_map_check[] = ['check_status', '<', 2];
            $expense_map_check[] = ['', 'exp', Db::raw("FIND_IN_SET('{$admin_id}',check_admin_ids)")];
            $expense_map_check[] = ['delete_time', '=', 0];
            $expense_count_check = Db::name('Expense')->where($expense_map_check)->count();
            $statistics['expense_html_check'] = '<a data-id="121" class="side-menu-item" data-title="待我审批的报销" data-href="/finance/expense/list">您有<font style="color:#FF0000">' . $expense_count_check . '</font>条报销单待审核</a>';
            if ($expense_count_check == 0) {
                $statistics['expense_html_check'] = '';
            }

            //未读消息统计
            $msg_map[] = ['to_uid', '=', $admin_id];
            $msg_map[] = ['read_time', '=', 0];
            $msg_map[] = ['status', '=', 1];
            $msg_count = Db::name('Message')->where($msg_map)->count();
            $statistics['msg_html'] = '<a data-id="78" class="side-menu-item" data-title="消息中心" data-href="/message/index/inbox" >您有<font style="color:#FF0000">' . $msg_count . '</font>条未读消息</a>';
            $statistics['msg_num'] = $msg_count;
            if ($msg_count == 0) {
                $statistics['msg_html'] = '';
            }

            foreach ($statistics as $key => $value) {
                if (!$value) {
                    unset($statistics[$key]);
                }

            }
            return to_assign(0, 'ok', $statistics);
        } else {
            $admin = get_login_admin();
            if (get_cache('menu' . $admin['id'])) {
                $list = get_cache('menu' . $admin['id']);
            } else {
                $adminGroup = Db::name('PositionGroup')->where(['pid' => $admin['position_id']])->column('group_id');
                $adminMenu = Db::name('AdminGroup')->where('id', 'in', $adminGroup)->column('rules');
                $adminMenus = [];
                foreach ($adminMenu as $k => $v) {
                    $v = explode(',', $v);
                    $adminMenus = array_merge($adminMenus, $v);
                }
                $menu = Db::name('AdminRule')->where(['menu' => 1, 'status' => 1])->where('id', 'in', $adminMenus)->order('sort asc')->select()->toArray();
                $list = list_to_tree($menu);
                \think\facade\Cache::tag('adminMenu')->set('menu' . $admin['id'], $list);
            }
            View::assign('menu', $list);
            return View();
        }
    }

    public function main()
    {
        $install = false;
        if (file_exists(CMS_ROOT . 'app/install')) {
            $install = true;
        }
        $total = [];
        $adminCount = Db::name('Admin')->where('status', '1')->count();
        $approveCount = Db::name('Approve')->count();
        $expenseCount = Db::name('Expense')->where('delete_time', '0')->count();
        $invoiceCount = Db::name('Invoice')->where('delete_time', '0')->count();
        $total[] = array(
            'name' => '员工',
            'num' => $adminCount,
        );
        $total[] = array(
            'name' => '审批',
            'num' => $approveCount,
        );
        $total[] = array(
            'name' => '报销',
            'num' => $expenseCount,
        );
        $total[] = array(
            'name' => '发票',
            'num' => $invoiceCount,
        );
		
		$handle=[
			'approve'=>Db::name('Approve')->where([['', 'exp', Db::raw("FIND_IN_SET('{$this->uid}',check_admin_ids)")]])->count(),
			'expenses'=>Db::name('Expense')->where([['', 'exp', Db::raw("FIND_IN_SET('{$this->uid}',check_admin_ids)")],['delete_time', '=', 0]])->count(),
			'invoice'=>Db::name('Invoice')->where([['', 'exp', Db::raw("FIND_IN_SET('{$this->uid}',check_admin_ids)")],['delete_time', '=', 0]])->count(),
			'income'=>Db::name('Invoice')->where([['is_cash', '<', 2],['admin_id','=',$this->uid],['check_status', '=', 5],['delete_time', '=', 0]])->count(),
			'contract'=>0,
			'task'=>0
		];
		
        $module = Db::name('AdminModule')->column('name');
        if (in_array('customer', $module)) {
            $customerCount = Db::name('Customer')->where([['delete_time', '=', 0]])->count();
            $total[] = array(
                'name' => '客户',
                'num' => $customerCount,
            );
        }
        if (in_array('contract', $module)) {
            $contractCount = Db::name('Contract')->where([['delete_time', '=', 0]])->count();
            $total[] = array(
                'name' => '合同',
                'num' => $contractCount,
            );
			$handle['contract'] = Db::name('Contract')->where([['', 'exp', Db::raw("FIND_IN_SET('{$this->uid}',check_admin_ids)")],['delete_time', '=', 0]])->count();
        }
        if (in_array('project', $module)) {
            $projectCount = Db::name('Project')->where([['delete_time', '=', 0]])->count();
            $taskCount = Db::name('ProjectTask')->where([['delete_time', '=', 0]])->count();
            $total[] = array(
                'name' => '项目',
                'num' => $projectCount,
            );
            $total[] = array(
                'name' => '任务',
                'num' => $taskCount,
            );
			$handle['task'] = Db::name('ProjectTask')->where([['director_uid', '=', $this->uid],['delete_time', '=', 0]])->count();
        }
        if (in_array('article', $module)) {
            $articleCount = Db::name('Article')->where([['delete_time', '=', 0]])->count();
            $total[] = array(
                'name' => '文章',
                'num' => $articleCount,
            );
        }
        View::assign('total', $total);
        View::assign('handle', $handle);
        View::assign('install', $install);
        View::assign('TP_VERSION', \think\facade\App::version());
        return View();
    }
	
	//通讯录
	public function mail_list()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            if (!empty($param['keywords'])) {
                $where[] = ['id|username|name|nickname|mobile|desc', 'like', '%' . $param['keywords'] . '%'];
            }
            $where[] = ['status', '<', 2];
            if (isset($param['status']) && $param['status']!='') {
                $where[] = ['status', '=', $param['status']];
            }
            if (!empty($param['did'])) {
                $department_array = get_department_son($param['did']);
                $where[] = ['did', 'in', $department_array];
            }
            $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
            $admin = \app\user\model\Admin::where($where)
                ->order('id desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
                    $item->department = Db::name('Department')->where(['id' => $item->did])->value('title');
                    $item->position = Db::name('Position')->where(['id' => $item->position_id])->value('title');
                    $item->entry_time = empty($item->entry_time) ? '-' : date('Y-m-d', $item->entry_time);
                });
            return table_assign(0, '', $admin);
        } else {
            return view();
        }
    }
}
