<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\model\InvoiceSubject;
use app\home\model\Invoice as InvoiceList;
use app\home\validate\InvoiceSubjectCheck;
use app\home\validate\InvoiceCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Invoice extends BaseController
{
    public function subject()
    {
        if (request()->isAjax()) {
            $subject = Db::name('InvoiceSubject')->order('create_time asc')->select();
            return to_assign(0, '', $subject);
        } else {
            return view();
        }
    }
    //提交保存分类
    public function subject_add()
    {
        if (request()->isAjax()) {
            $param = get_params();
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(InvoiceSubjectCheck::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $data['update_time'] = time();
                $res = InvoiceSubject::strict(false)->field(true)->update($param);
                if ($res) {
                    add_log('edit', $param['id'], $param);
                }
                return to_assign();
            } else {
                try {
                    validate(InvoiceSubjectCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['create_time'] = time();
                $insertId = InvoiceSubject::strict(false)->field(true)->insertGetId($param);
                if ($insertId) {
                    add_log('add', $insertId, $param);
                }
                return to_assign();
            }
        }
    }

    public function get_list($param = [], $where = [])
    {
        $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
        $expense = InvoiceList::where($where)
            ->order('create_time asc')
            ->paginate($rows, false, ['query' => $param])
            ->each(function ($item, $key) {
                $item->user = Db::name('Admin')->where(['id' => $item->admin_id])->value('name');
                $item->department = Db::name('Department')->where(['id' => $item->did])->value('title');
                $item->check_name = Db::name('Admin')->where(['id' => $item->check_admin_id])->value('name');
                $item->check_time = empty($item->check_time) ? '-' : date('Y-m-d H:i', $item->check_time);
                $item->open_name = Db::name('Admin')->where(['id' => $item->open_admin_id])->value('name');
                $item->open_time = empty($item->open_time) ? '-' : date('Y-m-d H:i', $item->open_time);
            });
        return $expense;
    }

    public function detail($id = 0)
    {
        $invoice = Db::name('Invoice')->where(['id' => $id])->find();
        if ($invoice) {
            $invoice['user'] = Db::name('Admin')->where(['id' => $invoice['admin_id']])->value('name');
            $invoice['department'] = Db::name('Department')->where(['id' => $invoice['did']])->value('title');
            if ($invoice['check_admin_id'] > 0) {
                $invoice['check_admin'] = Db::name('Admin')->where(['id' => $invoice['check_admin_id']])->value('name');
                $invoice['check_time'] = empty($invoice['check_time']) ? '0' : date('Y-m-d H:i', $invoice['check_time']);
            }
            if ($invoice['open_admin_id'] > 0) {
                $invoice['open_name'] = Db::name('Admin')->where(['id' => $invoice['open_admin_id']])->value('name');
                $invoice['open_time'] = empty($invoice['open_time']) ? '0' : date('Y-m-d H:i', $invoice['open_time']);
            }
        }
        return $invoice;
    }

    public function index()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = [];
            $where[] = ['status', '=', 1];
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime(urldecode($param['start_time'])) : 0;
            $end_time = isset($param['end_time']) ? strtotime(urldecode($param['end_time'])) : 0;
            if ($start_time > 0 && $end_time > 0) {
                $where[] = ['expense_time', 'between', [$start_time, $end_time]];
            }
            $invoice = $this->get_list($param, $where);
            return table_assign(0, '', $invoice);
        } else {
            return view();
        }
    }

    //添加&编辑
    public function add()
    {
        $param = get_params();
        if (request()->isAjax()) {
            //人类型判断
            if ($param['type'] == 2) {
                if (!$param['invoice_tax']) {
                    return to_assign(1, '纳税人识别号不能为空');
                }
                if (!$param['invoice_bank']) {
                    return to_assign(1, '开户银行不能为空');
                }
                if (!$param['invoice_account']) {
                    return to_assign(1, '银行账号不能为空');
                }
                if (!$param['invoice_banking']) {
                    return to_assign(1, '银行营业网点不能为空');
                }
                if (!$param['invoice_address']) {
                    return to_assign(1, '银地址不能为空');
                }
            }
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(InvoiceCheck::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['update_time'] = time();
                $res = InvoiceList::where('id', $param['id'])->strict(false)->field(true)->update($param);
                if ($res !== false) {
                    return to_assign();   
                } else {
                    return to_assign(1, '操作失败');
                }
            } else {
                try {
                    validate(InvoiceCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $admin_id = $this->uid;
                $param['admin_id'] = $admin_id;
                $param['did'] = get_login_admin('did');
                $param['create_time'] = time();
                $exid = InvoiceList::strict(false)->field(true)->insertGetId($param);
                if ($exid) {
                    return to_assign();   
                } else {
                     return to_assign(1, '操作失败');
                }
            }
        } else {
            $id = isset($param['id']) ? $param['id'] : 0;
            if ($id > 0) {
                $detail = $this->detail($id);
                View::assign('detail', $detail);
            }
            View::assign('user', get_admin($this->uid));
            View::assign('id', $id);
            return view();
        }
    }

    //查看
    public function view()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
        $detail = $this->detail($id);
        View::assign('uid', $this->uid);
        View::assign('detail', $detail);
        return view();
    }

    //删除
    public function delete()
    {
        $id = get_params("id");
        $detail = $this->detail($id);
        if ($detail['invoice_status'] == 2) {
            return to_assign(1, "已审核的发票不能删除");
        }
        if ($detail['invoice_status'] == 3) {
            return to_assign(1, "已开具的发票不能删除");
        }
        $data['status'] = '-1';
        $data['id'] = $id;
        $data['update_time'] = time();
        if (Db::name('Invoice')->update($data) !== false) {
            add_log('delete', $id);
            return to_assign(0, "删除成功");
        } else {
            return to_assign(1, "删除失败");
        }
    }
    //设置
    public function check()
    {
        $param = get_params();
        if (request()->isAjax()) {
            if ($param['invoice_status'] == 2 || $param['invoice_status'] == 0) {
                $param['check_time'] = time();
            }
            if ($param['check_status'] == 3) {
                $param['open_time'] = time();
            }
            if ($param['check_status'] == 10) {
                $param['update_time'] = time();
            }
            $res = InvoiceList::where('id', $param['id'])->strict(false)->field(true)->update($param);
            if ($res !== false) {
                return to_assign();
            } else {
                return to_assign(1, "操作失败");
            }
        }
    }
}
