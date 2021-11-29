<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\BaseController;
use app\home\model\Mail as MailList;
use think\facade\Db;
use think\facade\View;

class Mail extends BaseController
{
    //收件箱
    public function inbox()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $param['status'] = 1;
            $map = [];
            if (!empty($param['keywords'])) {
                $map[] = ['name', 'like', '%' . $param['keywords'] . '%'];
            }
            if (!empty($param['is_read'])) {
                $map[] = ['is_read', '=', $param['is_read']];
            }
            if (!empty($param['mail_type'])) {
                $map[] = ['mail_type', '=', $param['mail_type']];
            }
            $map[] = ['to_uid', '=', $this->uid];
            $map[] = ['status', '=', $param['status']];
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime(urldecode($param['start_time'])) : 0;
            $end_time = isset($param['end_time']) ? strtotime(urldecode($param['end_time'])) : 0;
            if ($start_time > 0 && $end_time > 0) {
                $map[] = ['send_time', 'between', "$start_time,$end_time"];
            }
            $list = $this->getList($map, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }
    //发件箱
    public function sendbox()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $param['status'] = 1;
            $map = [];
            if (!empty($param['keywords'])) {
                $map[] = ['name', 'like', '%' . $param['keywords'] . '%'];
            }
            $map[] = ['from_uid', '=', $this->uid];
            $map[] = ['to_uid', '=', 0];
            $map[] = ['status', '=', $param['status']];
            $map[] = ['is_draft', '=', 1];
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime(urldecode($param['start_time'])) : 0;
            $end_time = isset($param['end_time']) ? strtotime(urldecode($param['end_time'])) : 0;
            if ($start_time > 0 && $end_time > 0) {
                $map[] = ['send_time', 'between', "$start_time,$end_time"];
            }
            $list = $this->getList($map, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }

    //草稿箱
    public function draft()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $param['status'] = 2;
            $map = [];
            if (!empty($param['keywords'])) {
                $map[] = ['name', 'like', '%' . $param['keywords'] . '%'];
            }
            $map[] = ['from_uid', '=', $this->uid];
            $map[] = ['status', '=', 1];
            $map[] = ['is_draft', '=', $param['status']];
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime(urldecode($param['start_time'])) : 0;
            $end_time = isset($param['end_time']) ? strtotime(urldecode($param['end_time'])) : 0;
            if ($start_time > 0 && $end_time > 0) {
                $map[] = ['send_time', 'between', "$start_time,$end_time"];
            }
            $list = $this->getList($map, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }

    //垃圾箱
    public function rubbish()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $param['status'] = 0;
            $map = [];
            if (!empty($param['keywords'])) {
                $map[] = ['name', 'like', '%' . $param['keywords'] . '%'];
            }
            $map[] = ['status', '=', $param['status']];
            //按时间检索
            $start_time = isset($param['start_time']) ? strtotime(urldecode($param['start_time'])) : 0;
            $end_time = isset($param['end_time']) ? strtotime(urldecode($param['end_time'])) : 0;
            if ($start_time > 0 && $end_time > 0) {
                $map[] = ['send_time', 'between', "$start_time,$end_time"];
            }
            $list = $this->getList($map, $param);
            return table_assign(0, '', $list);
        } else {
            return view();
        }
    }

    //获取消息列表
    public function getList($map = [], $param = [])
    {
        $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
        //垃圾箱列表特殊处理
        if ($param['status'] == 0) {
            $where = [['from_uid', '=', $this->uid], ['to_uid', '=', $this->uid]];
            $mail = MailList::where($map)
                ->where(function ($query) use ($where) {$query->whereOr($where);})
                ->order('create_time desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
                    $item->send_time = empty($item->send_time) ? '-' : date('Y-m-d H:i:s', $item->send_time);
                    $item->from_name = Db::name('Admin')->where(['id' => $item->from_uid])->value('nickname');
                    $item->to_name = Db::name('Admin')->where(['id' => $item->to_uid])->value('nickname');
                    $item->type_title = MailList::$Type[$item->type];
                    $item->mail_type_title = MailList::$MailType[$item->mail_type];
                    $item->delete_source_title = MailList::$Source[$item->delete_source];
                    $item->files = Db::name('MailFileInterfix')->where(['mid' => $item->id, 'status' => 1])->count();
                });
            return $mail;
        } else {
            $mail = MailList::where($map)
                ->order('create_time desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
                    $item->send_time = empty($item->send_time) ? '-' : date('Y-m-d H:i:s', $item->send_time);
                    $item->from_name = Db::name('Admin')->where(['id' => $item->from_uid])->value('nickname');
                    $item->to_name = Db::name('Admin')->where(['id' => $item->to_uid])->value('nickname');
                    $item->type_title = MailList::$Type[$item->type];
                    $item->mail_type_title = MailList::$MailType[$item->mail_type];
                    $item->files = Db::name('MailFileInterfix')->where(['mid' => $item->id, 'status' => 1])->count();
                });
            return $mail;
        }
    }

    //新增信息
    public function add()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
        $fid = 0;
        if ($id > 0) {
            $detail = Db::name('Mail')->where(['id' => $id, 'from_uid' => $this->uid])->find();
            if (empty($detail)) {
                $this->error('该信息不存在');
            }
            $fid = $detail['fid'];
            $person_name = [];
            if ($detail['type'] == 0) { //人员
                $users = Db::name('Admin')->where('status', 1)->where('id', 'in', $detail['type_user'])->select()->toArray();
                $person_name = array_column($users, 'name');
            } elseif ($detail['type'] == 1) { //部门
                $departments = Db::name('Department')->where('id', 'in', $detail['type_user'])->select()->toArray();
                $person_name = array_column($departments, 'title');
            } elseif ($detail['type'] == 2) { //角色
                $group_uid = Db::name('PositionGroup')->where('group_id', 'in', $detail['type_user'])->select()->toArray();
                $pids = array_column($group_uid, 'pid');
                $positions = Db::name('Position')->where('id', 'in', $pids)->select()->toArray();
                $person_name = array_column($positions, 'title');
            }
            $detail['person_name'] = implode(",", $person_name);
            $file_array = Db::name('MailFileInterfix')
                ->field('mf.id,mf.mid,mf.file_id,f.name,f.filesize,f.filepath')
                ->alias('mf')
                ->join('file f', 'mf.file_id = f.id', 'LEFT')
                ->order('mf.create_time desc')
                ->where(array('mf.mid' => $id, 'mf.status' => 1))
                ->select()->toArray();
            $interfix_ids = array_column($file_array, 'file_id');
            $detail['file_ids'] = implode(",", $interfix_ids);

            //引用消息的附件
            if($detail['fid']>0){
                $detail['from_content'] = Db::name('Mail')->where(['id' => $detail['fid']])->value('content');
                $from_file_array = Db::name('MailFileInterfix')
                ->field('mf.id,mf.mid,mf.file_id,f.name,f.filesize,f.filepath')
                ->alias('mf')
                ->join('file f', 'mf.file_id = f.id', 'LEFT')
                ->order('mf.create_time desc')
                ->where(array('mf.mid' => $detail['fid'], 'mf.status' => 1))
                ->select()->toArray();
                $detail['from_file_array'] = $from_file_array;
            }

            View::assign('file_array', $file_array);
            View::assign('detail', $detail);
        }
        View::assign('id', $id);
        View::assign('fid', $fid);
        return view();
    }

    //回复和转发消息
    public function reply()
    {
        $id = empty(get_params('id')) ? 0 : get_params('id');
        $type = empty(get_params('type')) ? 0 : get_params('type');
        $detail = Db::name('Mail')->where(['id' => $id, 'mail_type' => 2])->find();
        if (empty($detail)) {
            $this->error('该信息不存在');
        }
        if ($detail['to_uid'] != $this->uid && $detail['from_uid'] != $this->uid) {
            $this->error('该信息不存在');
        }
        $sender = get_admin($detail['from_uid']);
        $detail['person_name'] = $sender['name'];
        $file_array = Db::name('MailFileInterfix')
            ->field('mf.id,mf.mid,mf.file_id,f.name,f.filesize,f.filepath')
            ->alias('mf')
            ->join('file f', 'mf.file_id = f.id', 'LEFT')
            ->order('mf.create_time desc')
            ->where(array('mf.mid' => $id, 'mf.status' => 1))
            ->select()->toArray();
        $interfix_ids = array_column($file_array, 'file_id');
        $detail['file_ids'] = implode(",", $interfix_ids);
        View::assign('file_array', $file_array);
        View::assign('detail', $detail);
        View::assign('fid', $id);
        View::assign('type', $type);
        return view();
    }

    //查看消息
    public function read()
    {
        $param = get_params();
        $id = $param['id'];
        $detail = Db::name('Mail')->where(['id' => $id])->find();
        if (empty($detail)) {
            $this->error('该信息不存在');
        }
        if ($detail['to_uid'] != $this->uid && $detail['from_uid'] != $this->uid) {
            $this->error('该信息不存在');
        }
        Db::name('Mail')->where(['id' => $id])->update(['is_read' => 2]);
        if($detail['from_uid']==0){
            $detail['person_name'] = '系统管理员';
        }
        else{
            $sender = get_admin($detail['from_uid']);
            $detail['person_name'] = $sender['name'];
        }
        //引用消息的附件
        if($detail['fid']>0){
            $detail['from_content'] = Db::name('Mail')->where(['id' => $detail['fid']])->value('content');
            $from_file_array = Db::name('MailFileInterfix')
            ->field('mf.id,mf.mid,mf.file_id,f.name,f.filesize,f.filepath')
            ->alias('mf')
            ->join('file f', 'mf.file_id = f.id', 'LEFT')
            ->order('mf.create_time desc')
            ->where(array('mf.mid' => $detail['fid'], 'mf.status' => 1))
            ->select()->toArray();
            $detail['from_file_array'] = $from_file_array;
        }

        //当前消息的附件
        $file_array = Db::name('MailFileInterfix')
            ->field('mf.id,mf.mid,mf.file_id,f.name,f.filesize,f.filepath')
            ->alias('mf')
            ->join('file f', 'mf.file_id = f.id', 'LEFT')
            ->order('mf.create_time desc')
            ->where(array('mf.mid' => $detail['id'], 'mf.status' => 1))
            ->select()->toArray();
        $detail['file_array'] = $file_array;
        $detail['send_time'] = date('Y-m-d h:i:s',$detail['send_time']);    
        //发送人查询
        $user_names=[];
        //已读回执
        $read_user_names = [];
        if($detail['from_uid'] == $this->uid){
            $mails= Db::name('Mail')->where(['pid' => $id])->select()->toArray();
            $read_mails= Db::name('Mail')->where(['pid' => $id,'is_read' => 2])->select()->toArray();
            $read_user_ids = array_column($read_mails, 'to_uid');
            $read_users = Db::name('Admin')->where('status', 1)->where('id', 'in', $read_user_ids)->select()->toArray();
            $read_user_names = array_column($read_users, 'name');
        }
        else{
            $mails= Db::name('Mail')->where(['pid' => $detail['pid']])->select()->toArray();
        }
        $user_ids = array_column($mails, 'to_uid');
        $users = Db::name('Admin')->where('status', 1)->where('id', 'in', $user_ids)->select()->toArray();
        $user_names = array_column($users, 'name');

        $detail['users'] = implode(",", $user_names);
        $detail['read_users'] = implode(",", $read_user_names);
        View::assign('detail', $detail);
        return view();
    }

    //保存到草稿
    public function save()
    {
        $param = get_params();
        $id = empty($param['id']) ? 0 : $param['id'];
        $fid = empty($param['fid']) ? 0 : $param['fid'];
        //接受人类型判断
        if ($param['type'] == 0) {
            if (!$param['uids']) {
                return to_assign(1, '人员不能为空');
            } else {
                $type_user = $param['uids'];
            }
        } elseif ($param['type'] == 1) {
            if (!$param['dids']) {
                return to_assign(1, '部门不能为空');
            } else {
                $type_user = $param['dids'];
            }
        } elseif ($param['type'] == 2) {
            if (!$param['pids']) {
                return to_assign(1, '岗位不能为空');
            } else {
                $type_user = $param['pids'];
            }
        } else {
            $type_user = '';
        }
        //基础信息数据
        $admin_id = $this->uid;
        $did = get_admin($admin_id)['did'];
        $basedata = [];
        $basedata['from_uid'] = $admin_id;
        $basedata['admin_id'] = $admin_id;
        $basedata['did'] = $did;
        $basedata['fid'] = $fid;
        $basedata['mail_type'] = 2;//同事信息类型
        $basedata['is_draft'] = 2;//默认是草稿信息
        $basedata['name'] = $param['name'];
        $basedata['type'] = $param['type'];
        $basedata['type_user'] = $type_user;
        $basedata['content'] = $param['content'];
        if ($id > 0) {
            //编辑信息的情况
            $basedata['update_time'] = time();
            $basedata['id'] = $id;
            $res = Db::name('Mail')->strict(false)->field(true)->update($basedata);
        } else {
            //新增信息的情况
            $basedata['create_time'] = time();
            $res = Db::name('Mail')->strict(false)->field(true)->insertGetId($basedata);
        }
        if ($res !== false) {
            //信息附件处理
            if ($id > 0) {
                $mid = $id;
                Db::name('MailFileInterfix')->where('mid', $mid)->delete();
            } else {
                $mid = $res;
            }
            //附件插入附件
            if (!empty($param['file_ids'])) {
                $file_array = explode(',', $param['file_ids']);
                $file_data = array();
                foreach ($file_array as $key => $value) {
                    if (!$value) {
                        continue;
                    }
                    $file_data[] = array(
                        'mid' => $mid,
                        'file_id' => $value,
                        'create_time' => time(),
                        'admin_id' => $admin_id,
                    );
                }
                if ($file_data) {
                    Db::name('MailFileInterfix')->strict(false)->field(true)->insertAll($file_data);
                }
            }
            add_log('save',$mid);
            return to_assign(0, '保存成功', $mid);
        } else {
            return to_assign(1, '操作失败');
        }
    }

    //发送消息
    public function send()
    {
        $param = get_params();
        //查询要发的消息
        $msg = Db::name('Mail')->where(['id' => $param['id']])->find();
        $users = [];
        if ($msg) {
            $admin_id = $msg['admin_id'];
            //查询全部收件人
            if ($msg['type'] == 0) { //人员
                $users = Db::name('Admin')->where('status', 1)->where('id', 'in', $msg['type_user'])->select()->toArray();
            } elseif ($msg['type'] == 1) { //部门
                $users = Db::name('Admin')->where('status', 1)->where('did', 'in', $msg['type_user'])->select()->toArray();
            } elseif ($msg['type'] == 2) { //角色
                $group_uid = Db::name('PositionGroup')->where('group_id', 'in', $msg['type_user'])->select()->toArray();
                $pids = array_column($group_uid, 'pid');
                $users = Db::name('Admin')->where('status', 1)->where('position_id', 'in', $pids)->select()->toArray();
            } elseif ($msg['type'] == 3) { //全部
                $users = Db::name('Admin')->where('status', 1)->select()->toArray();
            }
            //组合要发的消息
            $send_data = [];
            foreach ($users as $key => $value) {
                if (!$value || ($value['id'] == $admin_id)) {
                    continue;
                }
                $send_data[] = array(
                    'pid' => $msg['id'],//来源发件关联id
                    'fid' => $msg['fid'],//转发或回复消息关联id
                    'name' => $msg['name'],
                    'type' => $msg['type'],
                    'type_user' => $msg['type_user'],
                    'from_uid' => $admin_id,//发送人
                    'did' => $value['did'],
                    'to_uid' => $value['id'],
                    'mail_type' => 2,//同事信息类型
                    'content' => $msg['content'],
                    'send_time' => time(),
                    'admin_id' => $admin_id,
                    'create_time' => time()
                );
            }
            $res = Db::name('Mail')->strict(false)->field(true)->insertAll($send_data);
            if ($res!==false) {
                //查询原来的附件，并插入
                $file_array = Db::name('MailFileInterfix')->where('mid', $msg['id'])->select()->toArray();
                if ($file_array) {
                    $mids = Db::name('Mail')->where('pid', $msg['id'])->select()->toArray();
                    foreach ($mids as $k => $v) {
                        $file_data = array();
                        foreach ($file_array as $key => $value) {
                            if (!$value) {
                                continue;
                            }
                            $file_data[] = array(
                                'mid' => $v['id'],
                                'file_id' => $value['file_id'],
                                'create_time' => time(),
                                'admin_id' => $admin_id,
                            );
                        }
                        if ($file_data) {
                            Db::name('MailFileInterfix')->strict(false)->field(true)->insertAll($file_data);
                        }
                    }
                }
                //草稿消息变成已发消息
                Db::name('Mail')->where(['id' => $msg['id']])->update(['is_draft' => '1', 'send_time' => time(), 'update_time' => time()]);
                add_log('send',$msg['id']);
                return to_assign(0, '发送成功');
            } else {
                return to_assign(1, '发送失败');
            }
        } else {
            return to_assign(1, '发送失败，找不到要发送的内容');
        }
    }

    //状态修改
    public function check()
    {
        $param = get_params();
        $type = empty($param['type']) ? 0 : $param['type'];
        $source = empty($param['source']) ? 0 : $param['source'];
        $ids = empty($param['ids']) ? 0 : $param['ids'];
        $idArray = explode(',', $ids);
        $list = [];
        foreach ($idArray as $key => $val) {
            if ($type==1) { //设置信息为已读
                $list[] = [
                    'is_read' => 2,
                    'id' => $val,
                    'update_time' => time(),
                ];
            }
            else if ($type==2) {  //设置信息进入垃圾箱
                $list[] = [
                    'status' => 0,
                    'id' => $val,
                    'delete_source' => $source,
                    'update_time' => time(),
                ];
            }
            else if ($type==3) {  //设置信息从垃圾箱恢复
                $list[] = [
                    'status' => 1,
                    'id' => $val,
                    'update_time' => time(),
                ];
            }
            else if ($type==4) {  //设置信息彻底删除
                $list[] = [
                    'status' => -1,
                    'id' => $val,
                    'update_time' => time(),
                ];
            }

        }
        foreach ($list as $key => $v) {
            if (Db::name('Mail')->update($v) !== false) {
                if ($type = 1) {
                    add_log('view', $v['id']);
                } else if ($type = 2) {
                    add_log('delete', $v['id']);
                } else if ($type = 3) {
                    add_log('recovery', $v['id']);
                }
                else if ($type = 4) {
                    add_log('clear', $v['id']);
                }
            }
        }
        return to_assign(0, '操作成功');
    }

}
