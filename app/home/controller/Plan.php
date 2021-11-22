<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\model\Plan as PlanList;
use schedule\Schedule as ScheduleIndex;
use think\facade\Db;
use think\facade\View;

class Plan extends BaseController
{
    function index() {
        if (request()->isAjax()) {
            $param = get_params();
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime($param['start_time']) : 0;
            $end_time = isset($param['end_time']) ? strtotime($param['end_time']) : 0;
            $where = [];
            if ($start_time > 0 && $end_time > 0) {
                $where[] = ['a.start_time', 'between', [$start_time, $end_time]];
            }
            if (!empty($param['keywords'])) {
                $where[] = ['a.title', 'like', '%' . trim($param['keywords']) . '%'];
            }
            if (!empty($param['uid'])) {
                $where[] = ['a.admin_id', '=', $param['uid']];
            } else {
                $where[] = ['a.admin_id', '=', $this->uid];
            }
            $where[] = ['a.status', '=', 1];
            $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
            $plan = PlanList::where($where)
                ->field('a.*,u.name as create_admin')
                ->alias('a')
                ->join('admin u', 'u.id = a.admin_id', 'LEFT')
                ->order('a.id desc')
                ->paginate($rows, false)
                ->each(function ($item, $key) {
                    $item->start_time = empty($item->start_time) ? '' : date('Y-m-d H:i', $item->start_time);
                    //$item->end_time = empty($item->end_time) ? '': date('Y-m-d H:i', $item->end_time);
                    $item->end_time = empty($item->end_time) ? '' : date('H:i', $item->end_time);
                });
            return table_assign(0, '', $plan);
        } else {
            return view();
        }
    }

    //工作记录
    public function calendar()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $uid = $this->uid;
            if (!empty($param['uid'])) {
                $uid = $param['uid'];
            }
            $where = [];
            $where[] = ['start_time', '>=', strtotime($param['start'])];
            $where[] = ['end_time', '<=', strtotime($param['end'])];
            $where[] = ['admin_id', '=', $uid];
            $where[] = ['status', '=', 1];
            $schedule = Db::name('Plan')->where($where)->field('id,title,color,start_time,end_time')->select()->toArray();
            $events = [];
            foreach ($schedule as $k => $v) {
                $v['backgroundColor'] = $v['color'];
                $v['borderColor'] = $v['color'];
                $v['title'] = $v['title'];
                $v['start'] = date('Y-m-d H:i', $v['start_time']);
                $v['end'] = date('Y-m-d H:i', $v['end_time']);
                unset($v['start_time']);
                unset($v['end_time']);
                $events[] = $v;
            }
            $input_arrays = $events;
            $range_start = parseDateTime($param['start']);
            $range_end = parseDateTime($param['end']);
            $timeZone = null;
            if (isset($_GET['timeZone'])) {
                $timeZone = new DateTimeZone($_GET['timeZone']);
            }

            // Accumulate an output array of event data arrays.
            $output_arrays = array();
            foreach ($input_arrays as $array) {
                // Convert the input array into a useful Event object
                $event = new ScheduleIndex($array, $timeZone);
                // If the event is in-bounds, add it to the output
                if ($event->isWithinDayRange($range_start, $range_end)) {
                    $output_arrays[] = $event->toArray();
                }
            }
            return json($output_arrays);
        } else {
            return view();
        }
    }

    //保存日志数据
    public function add()
    {
        $param = get_params();
        $admin_id = $this->uid;
        if ($param['id'] == 0) {
            if (isset($param['start_time'])) {
                $param['start_time'] = strtotime($param['start_time'] . '' . $param['start_time_1']);
            }
            if (isset($param['end_time'])) {
                $param['end_time'] = strtotime($param['end_time'] . '' . $param['end_time_1']);
            }
            if ($param['end_time'] <= $param['start_time']) {
                return to_assign(1, "结束时间需要大于开始时间");
            }
            $where1[] = ['status', '=', 1];
            $where1[] = ['admin_id', '=', $admin_id];
            $where1[] = ['start_time', 'between', [$param['start_time'], $param['end_time'] - 1]];

            $where2[] = ['status', '=', 1];
            $where2[] = ['admin_id', '=', $admin_id];
            $where2[] = ['start_time', '<=', $param['start_time']];
            $where2[] = ['start_time', '>=', $param['end_time']];

            $where3[] = ['status', '=', 1];
            $where3[] = ['admin_id', '=', $admin_id];
            $where3[] = ['end_time', 'between', [$param['start_time'] + 1, $param['end_time']]];

            $record = Db::name('Plan')
                ->where(function ($query) use ($where1) {
                    $query->where($where1);
                })
                ->whereOr(function ($query) use ($where2) {
                    $query->where($where2);
                })
                ->whereOr(function ($query) use ($where3) {
                    $query->where($where3);
                })
                ->count();
            if ($record > 0) {
                return to_assign(1, "您所选的时间区间已有日程安排，请重新选时间");
            }
            $param['admin_id'] = $admin_id;
            $param['did'] = get_admin($admin_id)['did'];
            $param['create_time'] = time();
            $addid = Db::name('Plan')->strict(false)->field(true)->insertGetId($param);
            if ($addid > 0) {
                add_log('add', $addid, $param);
                return to_assign(0, '操作成功');
            } else {
                return to_assign(0, '操作失败');
            }
        } else {
            $param['update_time'] = time();
            $res = Db::name('Plan')->strict(false)->field(true)->update($param);
            if ($res !== false) {
                add_log('edit', $addid, $param);
                return to_assign(0, '操作成功');
            } else {
                return to_assign(0, '操作失败');
            }
        }
    }

    //删除工作记录
    public function delete()
    {
        $id = get_params("id");
        $data['status'] = '-1';
        $data['id'] = $id;
        $data['update_time'] = time();
        if (Db::name('Plan')->update($data) !== false) {
            add_log('delete', $data['id'], $data);
            return to_assign(0, "删除成功");
        } else {
            return to_assign(1, "删除失败");
        }
    }

    public function detail($id)
    {
        $id = get_params('id');
        $schedule = Db::name('Plan')->where(['id' => $id])->find();
        if (!empty($schedule)) {
            $schedule['start_time'] = date('Y-m-d H:i', $schedule['start_time']);
            $schedule['end_time'] = date('Y-m-d H:i', $schedule['end_time']);
            $schedule['create_time'] = date('Y-m-d H:i:s', $schedule['create_time']);
            $schedule['user'] = Db::name('Admin')->where(['id' => $schedule['admin_id']])->value('name');
        }
        if (request()->isAjax()) {
            return to_assign(0, "", $schedule);
        } else {
            return $schedule;
        }
    }

    //读取日程弹层详情
    public function view()
    {
        $id = get_params('id');
        $schedule = $this->detail($id);
        if ($schedule) {
            View::assign('schedule', $schedule);
            return view();
        } else {
            echo '该日程安排不存在';
        }
    }

}
