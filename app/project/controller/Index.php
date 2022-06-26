<?php
/**
 * @copyright Copyright (c) 2022 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\project\controller;

use app\base\BaseController;
use app\project\model\Project as ProjectList;
use app\project\validate\ProjectCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Index extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $project_ids = Db::name('ProjectUser')->where(['uid' => $this->uid, 'delete_time' => 0])->column('project_id');
            $rows = empty($param['limit']) ? get_config('app . page_size') : $param['limit'];
            $list = ProjectList::withoutField('content,md_content')
                ->where([['delete_time', '=', 0], ['id', 'in', $project_ids]])
                ->order('id desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
                    $item->director_name = Db::name('Admin')->where(['id' => $item->director_uid])->value('name');
                    $item->plan_time = date('Y-m-d', $item->start_time) . ' 至 ' . date('Y-m-d', $item->end_time);
                    $item->status_name = ProjectList::$Status[(int) $item->status];

                    $task_map = [];
                    $task_map[] = ['project_id', '=', $item->id];
                    $task_map[] = ['delete_time', '=', 0];
                    //任务总数
                    $item->tasks_total = Db::name('ProjectTask')->where($task_map)->count();
                    //已完成任务
                    $task_map[] = ['flow_status', '>', 2]; //已完成
                    $item->tasks_finish = Db::name('ProjectTask')->where($task_map)->count();
                    //未完成任务
                    $item->tasks_unfinish = $item->tasks_total - $item->tasks_finish;
                    if ($item->tasks_total > 0) {
                        $item->tasks_pensent = round($item->tasks_finish / $item->tasks_total * 100, 2) . "％";
                    } else {
                        $item->tasks_pensent = "100％";
                    }
                });
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }

    //添加
    public function add()
    {
        $param = get_params();
        if (request()->isPost()) {
            if (isset($param['start_time'])) {
                $param['start_time'] = strtotime(urldecode($param['start_time']));
            }
            if (isset($param['end_time'])) {
                $param['end_time'] = strtotime(urldecode($param['end_time']));
            }
            if (!empty($param['id']) && $param['id'] > 0) {
                $project = (new ProjectList())->detail($param['id']);
                if ($this->uid == $project['admin_id'] || $this->uid == $project['director_uid']) {
                    if (isset($param['start_time'])) {
                        if ($param['start_time'] >= $project['end_time']) {
                            return to_assign(1, '开始时间不能大于计划结束时间');
                        }
                    }
                    if (isset($param['end_time'])) {
                        if ($param['end_time'] <= $project['start_time']) {
                            return to_assign(1, '计划结束时间不能小于开始时间');
                        }
                    }
                    if (isset($param['flow_status'])) {
                        if ($param['flow_status'] > 2) {
                            $param['over_time'] = time();
                        } else {
                            $param['over_time'] = 0;
                        }
                    }
                    try {
                        validate(ProjectCheck::class)->scene('edit')->check($param);
                    } catch (ValidateException $e) {
                        // 验证失败 输出错误信息
                        return to_assign(1, $e->getError());
                    }
                    //add_project_log('edit', $param['id'], $param, $project);
                    $param['update_time'] = time();
                    $res = ProjectList::where('id', $param['id'])->strict(false)->field(true)->update($param);
                    if ($res) {
                        add_log('edit', $param['id'], $param);
						add_project_log($this->uid,'project',$param, $project);
                    }
                    return to_assign();
                } else {
                    return to_assign(1, '只有创建人或者负责人才有权限编辑');
                }
            } else {
                try {
                    validate(ProjectCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['create_time'] = time();
                $param['admin_id'] = $this->uid;
                $sid = ProjectList::strict(false)->field(true)->insertGetId($param);
                if ($sid) {
					$project_users = $this->uid;
                    if (!empty($param['director_uid'])){
                        $project_users.=",".$param['director_uid'];
                    }
                    if (!empty($param['team_admin_ids'])){
                        $project_users.=",".$param['team_admin_ids'];
                    }
                    $project_array = explode(",",(string)$project_users);
                    $project_array = array_unique($project_array);
                    $project_user_array=[];
                    foreach ($project_array as $k => $v) {
                        if (is_numeric($v)) {
                            $project_user_array[]=array(
                                'uid'=>$v,
                                'admin_id'=>$this->uid,
                                'project_id'=>$sid,
                                'create_time'=>time(),
                            );
                        }
                    }
                    Db::name('ProjectUser')->strict(false)->field(true)->insertAll($project_user_array);
                    add_log('add', $sid, $param);
                    $log_data = array(
                        'module' => 'project',
                        'project_id' => $sid,
                        'new_content' => $param['name'],
                        'field' => 'new',
                        'action' => 'add',
                        'admin_id' => $this->uid,
                        'old_content' => '',
                        'create_time' => time(),
                    );
                    Db::name('ProjectLog')->strict(false)->field(true)->insert($log_data);
                }
                return to_assign();
            }
        } else {
            $id = isset($param['id']) ? $param['id'] : 0;
            if ($id > 0) {
                $detail = (new ProjectList())->detail($id);
                if (empty($detail)) {
                    return to_assign(1, '项目不存在');
                }
                View::assign('detail', $detail);
            }
            View::assign('id', $id);
            return view();
        }
    }

    //编辑
    public function edit()
    {
        $param = get_params();
        $id = isset($param['id']) ? $param['id'] : 0;
        $detail = (new ProjectList())->detail($id);
        if (empty($detail)) {
            return to_assign(1, '项目不存在');
        } else {
            $file_array = Db::name('FileInterfix')
                ->field('mf.id,mf.topic_id,mf.admin_id,f.name,f.filesize,f.filepath,a.name as admin_name')
                ->alias('mf')
                ->join('File f', 'mf.file_id = f.id', 'LEFT')
                ->join('Admin a', 'mf.admin_id = a.id', 'LEFT')
                ->order('mf.create_time desc')
                ->where(array('mf.topic_id' => $id, 'mf.module' => 'project'))
                ->select()->toArray();
            View::assign('file_array', $file_array);
            View::assign('detail', $detail);
            View::assign('id', $id);
            return view();
        }
    }

    //查看
    public function view()
    {
        $param = get_params();
        $id = isset($param['id']) ? $param['id'] : 0;
        $detail = (new ProjectList())->detail($id);
        if (empty($detail)) {
            return to_assign(1, '项目不存在');
        } else {
            $tids = Db::name('ProjectTask')->where([['project_id', '=', $detail['id']], ['delete_time', '=', 0]])->column('id');
            $detail['schedules'] = Db::name('Schedule')->where([['tid', 'in', $tids], ['delete_time', '=', 0]])->count();
            $detail['hours'] = Db::name('Schedule')->where([['tid', 'in', $tids], ['delete_time', '=', 0]])->sum('labor_time');
            $detail['plan_hours'] = Db::name('ProjectTask')->where([['project_id', '=', $detail['id']], ['delete_time', '=', 0]])->sum('plan_hours');
            $detail['tasks'] = Db::name('ProjectTask')->where([['project_id', '=', $detail['id']], ['delete_time', '=', 0]])->count();
            $detail['tasks_finish'] = Db::name('ProjectTask')->where([['project_id', '=', $detail['id']], ['flow_status', '>', 2], ['delete_time', '=', 0]])->count();
            $detail['tasks_unfinish'] = $detail['tasks'] - $detail['tasks_finish'];

            $task_map = [];
            $task_map[] = ['project_id', '=', $detail['id']];
            $task_map[] = ['delete_time', '=', 0];
            //判断是否是创建者或者负责人
            $role = 0;
            if ($detail['director_uid'] == $this->uid) {
                $role = 1; //负责人
            }
            if ($detail['admin_id'] == $this->uid) {
                $role = 2; //创建人
            }

			$file_array = Db::name('ProjectFile')
                ->field('mf.id,mf.topic_id,mf.admin_id,f.name,f.filesize,f.filepath,a.name as admin_name')
                ->alias('mf')
                ->join('File f', 'mf.file_id = f.id', 'LEFT')
                ->join('Admin a', 'mf.admin_id = a.id', 'LEFT')
                ->order('mf.create_time desc')
                ->where(array('mf.topic_id' => $id, 'mf.module' => 'project'))
                ->select()->toArray();
				
            View::assign('file_array', $file_array);
            View::assign('detail', $detail);
            View::assign('role', $role);
            View::assign('id', $id);
            return view();
        }
    }

    //删除
    public function delete()
    {
        if (request()->isDelete()) {
            $id = get_params("id");
            $count_task = Db::name('ProjectTask')->where([['project_id', '=', $id], ['delete_time', '=', 0]])->count();
            if ($count_task > 0) {
                return to_assign(1, "该项目下有关联的任务，无法删除");
            }
            $detail = Db::name('Project')->where('id', $id)->find();
            if ($detail['admin_id'] != $this->uid) {
                return to_assign(1, "你不是该项目的创建人，无权限删除");
            }
            if (Db::name('Project')->where('id', $id)->update(['delete_time' => time()]) !== false) {
                $log_data = array(
                    'module' => 'project',
                    'field' => 'delete',
                    'action' => 'delete',
                    'project_id' => $detail['id'],
                    'admin_id' => $this->uid,
                    'old_content' => '',
                    'new_content' => $detail['name'],
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
}
