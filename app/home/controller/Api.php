<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */
declare (strict_types = 1);
namespace app\home\controller;

use app\api\BaseController;
use app\home\model\AdminLog;
use app\user\validate\AdminCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\Session;

class api extends BaseController
{
    //首页公告
    public function get_note_list()
    {
        $list = Db::name('Note')
            ->field('a.id,a.title,a.create_time,c.title as cate_title')
            ->alias('a')
            ->join('note_cate c', 'a.cate_id = c.id')
            ->where(['a.status' => 1])
            ->order('a.end_time desc,a.sort desc,a.create_time desc')
            ->limit(8)
            ->select()->toArray();
        foreach ($list as $key => $val) {
            $list[$key]['create_time'] = date('Y-m-d :H:i', $val['create_time']);
        }
        $res['data'] = $list;
        return table_assign(0, '', $res);
    }
	
	//首页知识列表
    public function get_article_list()
    {
		$prefix = get_config('database.connections.mysql.prefix');//判断是否安装了文章模块
		$exist = Db::query('show tables like "'.$prefix.'article"');
		$res['data'] = [];
		if($exist){
			$list = Db::name('Article')
				->field('a.id,a.title,a.create_time,a.read,c.title as cate_title')
				->alias('a')
				->join('article_cate c', 'a.cate_id = c.id')
				->where(['a.delete_time' => 0])
				->order('a.id desc')
				->limit(8)
				->select()->toArray();
			foreach ($list as $key => $val) {
				$list[$key]['create_time'] = date('Y-m-d :H:i', $val['create_time']);
			}
			$res['data'] = $list;			
		}
		return table_assign(0, '', $res);
	}

    //首页项目
    public function get_project_list()
    {
		$prefix = get_config('database.connections.mysql.prefix');//判断是否安装了项目模块
		$exist = Db::query('show tables like "'.$prefix.'project"');
		$res['data'] = [];
		if($exist){
			$project_ids = Db::name('ProjectUser')->where(['uid' => $this->uid, 'delete_time' => 0])->column('project_id');
			$list = Db::name('Project')
				->field('a.id,a.name,a.status,a.create_time,a.start_time,a.end_time,u.name as director_name')
				->alias('a')
				->join('Admin u', 'a.director_uid = u.id')
				->where([['a.delete_time', '=', 0], ['a.id', 'in', $project_ids]])
				->order('a.id desc')
				->limit(8)
				->select()->toArray();
			foreach ($list as $key => $val) {
				$list[$key]['create_time'] = date('Y-m-d :H:i', $val['create_time']);
				$list[$key]['plan_time'] = date('Y-m-d', $list[$key]['start_time']) . ' 至 ' . date('Y-m-d', $list[$key]['end_time']);
				$list[$key]['status_name'] = \app\project\model\Project::$Status[(int) $val['status']];
			}
			$res['data'] = $list;
		}
        return table_assign(0, '', $res);
    }
	
    //首页任务
    public function get_task_list()
    {
		$prefix = get_config('database.connections.mysql.prefix');//判断是否安装了项目模块
		$exist = Db::query('show tables like "'.$prefix.'project_task"');
		$res['data'] = [];
		if($exist){
			$where = array();
			$map1 = [];
			$map2 = [];
			$map3 = [];
			$map1[] = ['admin_id', '=', $this->uid];
			$map2[] = ['director_uid', '=', $this->uid];
			$map3[] = ['', 'exp', Db::raw("FIND_IN_SET({$this->uid},assist_admin_ids)")];

			$where[] = ['delete_time', '=', 0];
			$list = Db::name('ProjectTask')->where($where)
				->where(function ($query) use ($map1, $map2, $map3) {
					$query->where($map1)->whereor($map2)->whereor($map3);
				})
				->withoutField('content,md_content')
				->order('flow_status asc')
				->order('id desc')
				->limit(8)
				->select()->toArray();
				foreach ($list as $key => $val) {
					$list[$key]['director_name'] = Db::name('Admin')->where(['id' => $val['director_uid']])->value('name');
					$list[$key]['end_time'] = date('Y-m-d', $val['end_time']);
					$list[$key]['flow_name'] = \app\project\model\ProjectTask::$FlowStatus[(int) $val['flow_status']];
				}
			$res['data'] = $list;
		}
        return table_assign(0, '', $res);
    }
	
    //获取访问记录
    public function get_view_data()
    {
        $param = get_params();
        $first_time = time();
        $second_time = $first_time - 86400;
        $three_time = $first_time - 86400 * 365;
        $begin_first = strtotime(date('Y-m-d', $first_time) . " 00:00:00");
        $end_first = strtotime(date('Y-m-d', $first_time) . " 23:59:59");
        $begin_second = strtotime(date('Y-m-d', $second_time) . " 00:00:00");
        $end_second = strtotime(date('Y-m-d', $second_time) . " 23:59:59");
        $begin_three = strtotime(date('Y-m-d', $three_time) . " 00:00:00");
        $data_first = Db::name('AdminLog')->field('create_time')->whereBetween('create_time', "$begin_first,$end_first")->select();
        $data_second = Db::name('AdminLog')->field('create_time')->whereBetween('create_time', "$begin_second,$end_second")->select();
        $data_three = Db::name('AdminLog')->field('create_time')->whereBetween('create_time', "$begin_three,$end_first")->select();
		
		//获取员工活跃数据
        $times = strtotime("-30 day");
        $where = [];
        $where[] = ['uid','<>',1];
        $where[] = ['create_time', '>', $times];
        $content = Db::name('AdminLog')->field("id,uid,name")->where($where)->select();
        $logs = array();
        foreach ($content as $index => $value) {
            $uid = $value['uid'];
            if (empty($logs[$uid])) {
                $logs[$uid]['count'] = 1;
                $logs[$uid]['name'] = $value['name'];
            } else {
                $logs[$uid]['count'] += 1;
            }
        }
        $counts = array_column($logs, 'count');
        array_multisort($counts, SORT_DESC, $logs);
        //攫取前10
        $data_logs = array_slice($logs, 0, 10);
        return to_assign(0, '', ['data_first' => hour_document($data_first), 'data_second' => hour_document($data_second), 'data_three' => date_document($data_three),'data_logs' => $data_logs]);
    }

    //修改个人信息
    public function edit_personal()
    {
		if (request()->isAjax()) {
            $param = get_params();
            $uid = $this->uid;
            Db::name('Admin')->where(['id' => $uid])->strict(false)->field(true)->update($param);
            $session_admin = get_config('app.session_admin');
            Session::set($session_admin, Db::name('admin')->find($uid));
            return to_assign();
        }
		else{
			return view('user@user/edit_personal', [
				'admin' => get_admin($this->uid),
			]);
		}
    }

    //修改密码
    public function edit_password()
    {
		if (request()->isAjax()) {
            $param = get_params();
            try {
                validate(AdminCheck::class)->scene('editPwd')->check($param);
            } catch (ValidateException $e) {
                // 验证失败 输出错误信息
                return to_assign(1, $e->getError());
            }
            $uid = $this->uid;
			
			$admin = Db::name('Admin')->where(['id' => $uid])->find();
			$old_psw = set_password($param['old_pwd'], $admin['salt']);
			if ($admin['pwd'] != $old_psw) {
				return to_assign(1, '旧密码错误');
			}

			$salt = set_salt(20);
			$new_pwd = set_password($param['pwd'], $salt);
			$data = [
				'reg_pwd' => '',
				'salt' => $salt,
				'pwd' => $new_pwd,
				'update_time' => time(),
			];
            Db::name('Admin')->where(['id' => $uid])->strict(false)->field(true)->update($data);
            $session_admin = get_config('app.session_admin');
            Session::set($session_admin, Db::name('admin')->find($uid));
            return to_assign();
        }
		else{
			return view('user@user/edit_password', [
				'admin' => get_admin($this->uid),
			]);
		}
    }
	
    //系统操作日志
    public function log_list()
    {
		if (request()->isAjax()) {
			$param = get_params();
			$log = new AdminLog();
			$content = $log->get_log_list($param);
			return table_assign(0, '', $content);
		}else{
			return view('home@log/log_list');
		}
    }

}
