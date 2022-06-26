<?php
/**
 * @copyright Copyright (c) 2022 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */
declare (strict_types = 1);
namespace app\project\controller;

use app\api\BaseController;
use app\oa\model\Schedule as ScheduleList;
use app\project\model\ProjectLog;
use app\project\model\ProjectComment;
use think\facade\Db;
use think\facade\View;

class Api extends BaseController
{
	//获取项目概况数据
	public function get_chart_data()
    {
        $param = get_params();
        $tasks = Db::name('ProjectTask')->field('id,plan_hours,end_time,flow_status,over_time')->order('end_time asc')->where([['project_id', '=', $param['project_id']], ['delete_time', '=', 0]])->select()->toArray();

        $task_count = count($tasks);
        $task_count_ok = Db::name('ProjectTask')->where([['project_id', '=', $param['project_id']], ['delete_time', '=', 0],['flow_status', '>', 2]])->count();
        $task_delay = 0;
        if ($task_count > 0) {
            foreach ($tasks as $k => $v) {
                if (($v['flow_status'] < 3) && ($v['end_time'] < time() - 86400)) {
                    $task_delay++;
                }
                if (($v['flow_status'] == 3) && ($v['end_time'] < $v['over_time'] - 86400)) {
                    $task_delay++;
                }
            }
        }
        $task_pie = [
            'count' => $task_count,
            'count_ok' => $task_count_ok,
            'delay' => $task_delay,
            'ok_lv' => $task_count == 0 ? 100 : round($task_count_ok * 100 / $task_count, 2),
            'delay_lv' => $task_count == 0 ? 100 : round($task_delay * 100 / $task_count, 2),
        ];

        $date_tasks = [];
        if ($tasks) {
            $date_tasks = plan_count($tasks);
        }

        $tasks_ok = Db::name('ProjectTask')->field('id,over_time as end_time')->order('over_time asc')->where([['over_time', '>', 0], ['delete_time', '=', 0], ['project_id', '=', $param['project_id']]])->select()->toArray();
        $date_tasks_ok = [];
        if ($tasks_ok) {
            $date_tasks_ok = plan_count($tasks_ok);
        }
        $tids = Db::name('ProjectTask')->where(['delete_time' => 0, 'project_id' => $param['project_id']])->column('id');
        $schedules = Db::name('Schedule')->where([['tid', 'in', $tids], ['delete_time', '=', 0]])->select()->toArray();
        $date_schedules = [];
        if ($schedules) {
            $date_schedules = hour_count($schedules);
        }

        $res['task_pie'] = $task_pie;
        $res['date_tasks'] = $date_tasks;
        $res['date_tasks_ok'] = $date_tasks_ok;
        $res['date_schedules'] = $date_schedules;
        to_assign(0, '', $res);
    }

    //添加附件
    public function add_file()
    {
        $param = get_params();
        $param['create_time'] = time();
        $param['admin_id'] = $this->uid;
        $fid = Db::name('ProjectFile')->strict(false)->field(true)->insertGetId($param);
        if ($fid) {
            $log_data = array(
                'module' => $param['module'],
                'field' => 'file',
                'action' => 'upload',
                $param['module'] . '_id' => $param['topic_id'],
                'admin_id' => $this->uid,
                'old_content' => '',
                'new_content' => $param['file_name'],
                'create_time' => time(),
            );
            Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);
            return to_assign(0, '', $fid);
        }
    }
    
    //删除
    public function delete_file()
    {
        if (request()->isDelete()) {
            $id = get_params("id");
            $detail = Db::name('ProjectFile')->where('id', $id)->find();
            if (Db::name('ProjectFile')->where('id', $id)->delete() !== false) {
                $file_name = Db::name('File')->where('id', $detail['file_id'])->value('name');
                $log_data = array(
                    'module' => $detail['module'],
                    'field' => 'file',
                    'action' => 'delete',
                    $detail['module'] . '_id' => $detail['topic_id'],
                    'admin_id' => $this->uid,
                    'new_content' => $file_name,
                    'create_time' => time(),
                );
                Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);
                return to_assign(0, "删除成功");
            } else {
                return to_assign(0, "删除失败");
            }
        } else {
            return to_assign(1, "错误的请求");
        }
    }	
	
    //工作记录列表
    public function schedule()
    {
		$param = get_params();
		$task_ids = Db::name('ProjectTask')->where(['delete_time' => 0, 'project_id' => $param['tid']])->column('id');
		$where = array();
		if (!empty($param['keywords'])) {
			$where[] = ['a.title', 'like', '%' . $param['keywords'] . '%'];
		}
		if (!empty($param['uid'])) {
			$where[] = ['a.admin_id', '=', $param['uid']];
		}
		if (!empty($task_ids)) {
			$where[] = ['a.tid', 'in', $task_ids];
		}
		$where[] = ['a.delete_time', '=', 0];
		$rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
		$list = ScheduleList::where($where)
			->field('a.*,u.name,d.title as department,t.title as task,p.name as project,w.title as work_cate')
			->alias('a')
			->join('Admin u', 'a.admin_id = u.id', 'LEFT')
			->join('Department d', 'u.did = d.id', 'LEFT')
			->join('ProjectTask t', 'a.tid = t.id', 'LEFT')
			->join('WorkCate w', 'w.id = t.cate', 'LEFT')
			->join('Project p', 't.project_id = p.id', 'LEFT')
			->order('a.end_time desc')
			->paginate($rows, false, ['query' => $param])
			->each(function ($item, $key) {
				$item->start_time_a = empty($item->start_time) ? '' : date('Y-m-d', $item->start_time);
				$item->start_time_b = empty($item->start_time) ? '' : date('H:i', $item->start_time);
				$item->end_time_a = empty($item->end_time) ? '' : date('Y-m-d', $item->end_time);
				$item->end_time_b = empty($item->end_time) ? '' : date('H:i', $item->end_time);

				$item->start_time = empty($item->start_time) ? '' : date('Y-m-d H:i', $item->start_time);
				$item->end_time = empty($item->end_time) ? '' : date('H:i', $item->end_time);
			});
		return table_assign(0, '', $list);
    }
	
    //查看工作记录详情
    public function schedule_detail($id)
    {
        $id = get_params('id');
        $schedule = ScheduleList::where(['id' => $id])->find();
        if (!empty($schedule)) {
            $schedule['start_time_1'] = date('H:i', $schedule['start_time']);
            $schedule['end_time_1'] = date('H:i', $schedule['end_time']);
            $schedule['start_time'] = date('Y-m-d', $schedule['start_time']);
            $schedule['end_time'] = date('Y-m-d', $schedule['end_time']);
            // $schedule['create_time'] = date('Y-m-d H:i:s', $schedule['create_time']);
            $schedule['user'] = Db::name('Admin')->where(['id' => $schedule['admin_id']])->value('name');
            $schedule['department'] = Db::name('Department')->where(['id' => $schedule['did']])->value('title');
        }
        if (request()->isAjax()) {
            return to_assign(0, "", $schedule);
        } else {
            return $schedule;
        }
    }

    //任务的工作记录列表
    public function task_schedule()
    {
        $param = get_params();
        $where = array();
        $where['a.tid'] = $param['tid'];
        $where['a.delete_time'] = 0;
        $list = Db::name('Schedule')
            ->field('a.*,u.name')
            ->alias('a')
            ->join('Admin u', 'u.id = a.admin_id')
            ->order('a.create_time desc')
            ->where($where)
            ->select()->toArray();
        foreach ($list as $k => $v) {
            $list[$k]['start_time'] = empty($v['start_time']) ? '' : date('Y-m-d H:i', $v['start_time']);
            $list[$k]['end_time'] = empty($v['end_time']) ? '' : date('H:i', $v['end_time']);
        }
        return to_assign(0, '', $list);
    }


	public function project_user()
    {
        $param = get_params();
		$project = Db::name('Project')->where(['id' => $param['tid']])->find();
		$users = Db::name('ProjectUser')
				->field('pu.*,a.name,a.mobile,p.title as position,d.title as department')
				->alias('pu')
				->join('Admin a', 'pu.uid = a.id', 'LEFT')
				->join('Department d', 'a.did = d.id', 'LEFT')
				->join('Position p', 'a.position_id = p.id', 'LEFT')
				->order('pu.id asc')
				->where(['pu.project_id' => $param['tid']])
				->select()->toArray();
		if(!empty($users)){
			foreach ($users as $k => &$v) {
				$v['role'] = 0; //普通项目成员
				if ($v['uid'] == $project['admin_id']) {
					$v['role'] = 1; //项目创建人
				}
				if ($v['uid'] == $project['director_uid']) {
					$v['role'] = 2; //项目负责人
				}

				$v['create_time'] = date('Y-m-d', (int) $v['create_time']);
				if($v['delete_time'] > 0){
					$v['delete_time'] = date('Y-m-d', (int) $v['delete_time']);
				}
				else{
					$v['delete_time'] = '-';
				}

				$tids = Db::name('ProjectTask')->where([['project_id','=',$param['tid']],['delete_time','=',0]])->column('id');
				$schedule_map = [];
        		$schedule_map[] = ['tid','in',$tids];
        		$schedule_map[] = ['delete_time','=',0];
        		$schedule_map[] = ['admin_id','=',$v['uid']];
        		$v['schedules'] = Db::name('Schedule')->where($schedule_map)->count();
        		$v['labor_times'] = Db::name('Schedule')->where($schedule_map)->sum('labor_time');

				$task_map = [];
				$task_map[] = ['project_id','=',$param['tid']];
				$task_map[] = ['delete_time', '=', 0];

				$task_map1 = [
					['admin_id', '=', $v['uid']],
				];
				$task_map2 = [
					['director_uid', '=', $v['uid']],
				];
				$task_map3 = [
					['', 'exp', Db::raw("FIND_IN_SET('{$v['uid']}',assist_admin_ids)")],
				];

				//任务总数
				$v['tasks_total'] = Db::name('ProjectTask')
				->where(function ($query) use ($task_map1, $task_map2, $task_map3) {
					$query->where($task_map1)->whereor($task_map2)->whereor($task_map3);
				})
				->where($task_map)->count();
				//已完成任务
				$task_map[] = ['flow_status', '>', 2]; //已完成
				$v['tasks_finish'] = Db::name('ProjectTask')->where(function ($query) use ($task_map1, $task_map2, $task_map3) {
					$query->where($task_map1)->whereor($task_map2)->whereor($task_map3);
				})
				->where($task_map)->count();
				//未完成任务
				$v['tasks_unfinish'] = $v['tasks_total'] - $v['tasks_finish'];
				$v['tasks_pensent'] = "100％";
				if ($v['tasks_total'] > 0) {
					$v['tasks_pensent'] = round($v['tasks_finish'] / $v['tasks_total'] * 100, 2) . "％";
				}
			}
		}
        to_assign(0, '', $users);
    }

	//新增项目成员
    public function add_user()
    {
        $param = get_params();
        if (request()->isPost()) {
			$has = Db::name('ProjectUser')->where(['uid' => $param['uid'],'project_id'=>$param['project_id']])->find();
			if(!empty($has)){
				to_assign(1, '该员工已经是项目成员');
			}
			$project = Db::name('Project')->where(['id' => $param['project_id']])->find();
			if($this->uid == $project['admin_id'] || $this->uid == $project['director_uid']){
				$param['admin_id'] = $this->uid;
				$param['create_time'] = time();
				$res = Db::name('ProjectUser')->strict(false)->field(true)->insert($param);
				if ($res) {
					$log_data = array(
                        'module' => 'project',
                        'field' => 'user',
                        'action' => 'add',
                        'project_id' => $param['project_id'],
                        'admin_id' => $this->uid,
                        'new_content' => $param['uid'],
                        'create_time' => time(),
                    );
                    Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);
					to_assign();
				}				
			}else{
				to_assign(1, '只有项目创建者和负责人才有权限新增项目成员');
			}
		}
	}

	//移除项目成员
	public function remove_user()
	{
		$param = get_params();
		if (request()->isDelete()) {
			$detail = Db::name('ProjectUser')->where(['id' => $param['id']])->find();
			$project = Db::name('Project')->where(['id' => $detail['project_id']])->find();
			if($this->uid == $project['admin_id'] || $this->uid == $project['director_uid']){
				if($detail['uid'] == $project['admin_id']){
					to_assign(1, '该项目成员是项目的创建者，不能移除');
				}
				if($detail['uid'] == $project['director_uid']){
					to_assign(1, '该项目成员是项目的负责人，需要去除负责人权限才能移除');
				}
				$param['delete_time'] = time();
				if (Db::name('ProjectUser')->update($param) !== false) {	
					$log_data = array(
						'module' => 'project',
						'field' => 'user',
						'action' => 'remove',
						'project_id' => $detail['project_id'],
						'admin_id' => $this->uid,
						'new_content' => $detail['uid'],
						'create_time' => time(),
					);
					Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);			
					return to_assign(0, "移除成功");
				} else {
					return to_assign(1, "移除失败");
				}
			}else{
				to_assign(1, '只有项目创建者和负责人才有权限移除项目成员');
			}
		}else{
			return to_assign(1, "错误的请求");
		}
	}
	//恢复项目成员
	public function recover_user()
	{
		$param = get_params();
		if (request()->isPost()) {
			$detail = Db::name('ProjectUser')->where(['id' => $param['id']])->find();
			$project = Db::name('Project')->where(['id' => $detail['project_id']])->find();
			if($this->uid == $project['admin_id'] || $this->uid == $project['director_uid']){
				$param['delete_time'] = 0;
				if (Db::name('ProjectUser')->update($param) !== false) {		
					$log_data = array(
						'module' => 'project',
						'field' => 'user',
						'action' => 'recover',
						'project_id' => $detail['project_id'],
						'admin_id' => $this->uid,
						'new_content' => $detail['uid'],
						'create_time' => time(),
					);
					Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);			
					return to_assign(0, "恢复成功");
				} else {
					return to_assign(1, "恢复失败");
				}
			}else{
				to_assign(1, '只有项目创建者和负责人才有权限恢复项目成员');
			}
		}else{
			return to_assign(1, "错误的请求");
		}
	}


	//项目日志列表
    public function project_log()
    {
		$param = get_params();
		$list = new ProjectLog();
		$content = $list->project_log($param);
		return to_assign(0, '', $content);
    }
	
	//任务日志列表
    public function task_log()
    {
		$param = get_params();
		$list = new ProjectLog();
		$content = $list->get_list($param);
		return to_assign(0, '', $content);
    }
	
	
	//获取评论列表
    public function project_comment()
    {
		$param = get_params();
		$list = new ProjectComment();
		$content = $list->get_list($param);
		return to_assign(0, '', $content);
    }
	
    //添加修改评论内容
    public function add_comment()
    {
		$param = get_params();	
		if (!empty($param['id']) && $param['id'] > 0) {
			$param['update_time'] = time();
			unset($param['pid']);
			unset($param['padmin_id']);
            $res = ProjectComment::where(['admin_id' => $this->uid,'id'=>$param['id']])->strict(false)->field(true)->update($param);
			if ($res) {
				add_log('edit', $param['id'], $param);
				return to_assign();
			}
        } else {
            $param['create_time'] = time();
            $param['admin_id'] = $this->uid;
            $cid = ProjectComment::strict(false)->field(true)->insertGetId($param);
			if ($cid) {
				add_log('add', $cid, $param);
				return to_assign();
			}			
		}
    }
	
	//删除评论内容
    public function delete_comment()
    {
		if (request()->isDelete()) {
			$id = get_params("id");
			$res = ProjectComment::where('id',$id)->strict(false)->field(true)->update(['delete_time'=>time()]);
			if ($res) {
				add_log('delete', $id);
				return to_assign(0, "删除成功");
			} else {
				return to_assign(1, "删除失败");
			}
		}else{
			return to_assign(1, "错误的请求");
		}
    }
	
    //获取项目列表
    public function get_project($pid = 0)
    {
        $where = [];
        $where[] = ['delete_time', '=', 0];
        if ($pid > 0) {
            $where[] = ['product_id', '=', $pid];
        }
        $project = Db::name('Project')->field('id,name as title')->where($where)->select();
        return to_assign(0, '', $project);
    }
}
