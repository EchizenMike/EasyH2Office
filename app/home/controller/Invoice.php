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
                $item->income_month = empty($item->income_month) ? '-' : date('Y-m', $item->income_month);
                $item->expense_time = empty($item->expense_time) ? '-' : date('Y-m-d', $item->expense_time);
                $item->user_name = Db::name('Admin')->where(['id' => $item->uid])->value('name');
                $item->admin_name = Db::name('Admin')->where(['id' => $item->admin_id])->value('name');
                $item->department = Db::name('Department')->where(['id' => $item->did])->value('title');
                $item->check_name = Db::name('Admin')->where(['id' => $item->check_admin_id])->value('name');
                $item->check_time = empty($item->check_time) ? '-' : date('Y-m-d H:i', $item->check_time);
                $item->pay_name = Db::name('Admin')->where(['id' => $item->pay_admin_id])->value('name');
                $item->pay_time = empty($item->pay_time) ? '-' : date('Y-m-d H:i', $item->pay_time);
            });
        return $expense;
    }

    public function detail($id = 0)
    {
        $invoice = Db::name('Invoice')->where(['id' => $id])->find();
        if ($invoice) {
            $invoice['income_month'] = empty($invoice['income_month']) ? '-' : date('Y-m', $invoice['income_month']);
            $invoice['expense_time'] = empty($invoice['expense_time']) ? '-' : date('Y-m-d', $invoice['expense_time']);
            $invoice['user_name'] = Db::name('Admin')->where(['id' => $invoice['uid']])->value('name');
            $invoice['department'] = Db::name('Department')->where(['id' => $invoice['did']])->value('title');
            if ($invoice['check_admin_id'] > 0) {
                $invoice['check_admin'] = Db::name('Admin')->where(['id' => $invoice['check_admin_id']])->value('name');
                $invoice['check_time'] = date('Y-m-d H:i:s', $invoice['check_time']);
            }
            if ($invoice['pay_admin_id'] > 0) {
                $invoice['pay_admin'] = Db::name('Admin')->where(['id' => $invoice['pay_admin_id']])->value('name');
                $invoice['pay_time'] = date('Y-m-d H:i:s', $invoice['pay_time']);
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

    //添加
    public function add()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
        if ($id > 0) {
            $detail = $this->detail($id);
            View::assign('detail', $detail);
        }
        View::assign('user', get_admin($this->uid));
        View::assign('id', $id);
        return view();
    }

    //提交添加
    public function post_submit()
    {
        $admin_id = $this->uid;
        $dbRes = false;
        $param = get_params();
        $param['admin_id'] = $admin_id;
        $param['income_month'] = isset($param['income_month']) ? strtotime(urldecode($param['income_month'])) : 0;
        $param['expense_time'] = isset($param['expense_time']) ? strtotime(urldecode($param['expense_time'])) : 0;
        $param['check_status'] = 1;
        if (!empty($param['id']) && $param['id'] > 0) {
            try {
                validate(ExpenseCheck::class)->scene('edit')->check($param);
            } catch (ValidateException $e) {
                // 验证失败 输出错误信息
                return to_assign(1, $e->getError());
            }
            $param['update_time'] = time();
            Db::startTrans();
            try {
                $res = ExpenseList::where('id', $param['id'])->strict(false)->field(true)->update($param);
                if ($res !== false) {
                    $exid = $param['id'];
                    //相关内容多个数组;
                    $amountData = isset($param['amount']) ? $param['amount'] : '';
                    $remarksData = isset($param['remarks']) ? $param['remarks'] : '';
                    $cateData = isset($param['cate_id']) ? $param['cate_id'] : '';
                    $idData = isset($param['expense_id']) ? $param['expense_id'] : 0;
                    if ($amountData) {
                        foreach ($amountData as $key => $value) {
                            if (!$value) {
                                continue;
                            }

                            $data = [];
                            $data['id'] = $idData[$key];
                            $data['exid'] = $exid;
                            $data['admin_id'] = $admin_id;
                            $data['amount'] = $amountData[$key];
                            $data['cate_id'] = $cateData[$key];
                            $data['remarks'] = $remarksData[$key];
                            if ($data['amount'] == 0) {
                                Db::rollback();
                                return to_assign(1, '第' . ($key + 1) . '条报销金额不能为零');
                            }
                            if ($data['id'] > 0) {
                                $data['update_time'] = time();
                                $resa = Db::name('ExpenseInterfix')->strict(false)->field(true)->update($data);
                            } else {
                                $data['create_time'] = time();
                                $eid = Db::name('ExpenseInterfix')->strict(false)->field(true)->insertGetId($data);
                            }
                        }
                    }
                    add_log('edit', $exid, $param);
                    Db::commit();
                    $dbRes = true;
                } else {
                    Db::rollback();
                }
            } catch (\Exception $e) { ##这里参数不能删除($e：错误信息)
            Db::rollback();
                return to_assign(1, $e->getMessage());
            }
        } else {
            try {
                validate(ExpenseCheck::class)->scene('add')->check($param);
            } catch (ValidateException $e) {
                // 验证失败 输出错误信息
                return to_assign(1, $e->getError());
            }
            $param['create_time'] = time();
            Db::startTrans();
            try {
                $exid = ExpenseList::strict(false)->field(true)->insertGetId($param);
                if ($exid) {
                    //相关内容多个数组;
                    $amountData = isset($param['amount']) ? $param['amount'] : '';
                    $remarksData = isset($param['remarks']) ? $param['remarks'] : '';
                    $cateData = isset($param['cate_id']) ? $param['cate_id'] : '';
                    if ($amountData) {
                        foreach ($amountData as $key => $value) {
                            if (!$value) {
                                continue;
                            }

                            $data = [];
                            $data['exid'] = $exid;
                            $data['admin_id'] = $admin_id;
                            $data['amount'] = $amountData[$key];
                            $data['cate_id'] = $cateData[$key];
                            $data['remarks'] = $remarksData[$key];
                            $data['create_time'] = time();
                            if ($data['amount'] == 0) {
                                Db::rollback();
                                return to_assign(1, '第' . ($key + 1) . '条报销金额不能为零');
                            }
                            $eid = Db::name('ExpenseInterfix')->strict(false)->field(true)->insertGetId($data);
                        }
                    }
                    add_log('add', $exid, $param);
                    Db::commit();
                    $dbRes = true;
                } else {
                    Db::rollback();
                }
            } catch (\Exception $e) { ##这里参数不能删除($e：错误信息)
            Db::rollback();
                return to_assign(1, $e->getMessage());
            }
        }
        if ($dbRes == true) {
            return to_assign();
        } else {
            return to_assign(1, '保存失败');
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
        $expense = $this->detail($id);
        if ($expense['check_status'] == 2) {
            return to_assign(1, "已审核的报销记录不能删除");
        }
        if ($expense['check_status'] == 3) {
            return to_assign(1, "已打款的报销记录不能删除");
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
            if ($param['check_status'] == 2 || $param['check_status'] == 0) {
                $param['check_admin_id'] = $this->uid;
                $param['check_time'] = time();
            }
            if ($param['check_status'] == 3) {
                $param['pay_admin_id'] = $this->uid;
                $param['pay_time'] = time();
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
