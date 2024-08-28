<?php
/**
+-----------------------------------------------------------------------------------------------
* GouGuOPEN [ 左手研发，右手开源，未来可期！]
+-----------------------------------------------------------------------------------------------
* @Copyright (c) 2021~2024 http://www.gouguoa.com All rights reserved.
+-----------------------------------------------------------------------------------------------
* @Licensed 勾股OA，开源且可免费使用，但并不是自由软件，未经授权许可不能去除勾股OA的相关版权信息
+-----------------------------------------------------------------------------------------------
* @Author 勾股工作室 <hdm58@qq.com>
+-----------------------------------------------------------------------------------------------
*/

declare (strict_types = 1);
namespace app\Project\model;
use think\facade\Db;
use think\Model;

class ProjectComment extends Model
{
    //列表
    function datalist($param=[],$where=[],$whereOr=[]) {
        $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
		$order = empty($param['order']) ? 'id desc' : $param['order'];
        try {
            $list = self::where($where)
			->where(function ($query) use ($whereOr) {
				if (!empty($whereOr))
					$query->whereOr($whereOr);
				})
			->order($order)
			->paginate(['list_rows'=> $rows])
			->each(function ($item, $key) use($param){
				$item['admin_name'] = Db::name('Admin')->where(['id' => $item['admin_id']])->value('name');
				$to_names = Db::name('Admin')->where([['id', 'in', $item['to_uids']]])->column('name');
				if (empty($to_names)) {
                    $item['to_names'] = '-';
                } else {
                    $item['to_names'] = implode(',', $to_names);
                }
				if ($item['topic_id'] == 0) {
					$item['topic_name'] = '-';
				} else {
					if($item['module'] =='project'){
						$item['topic_name'] = Db::name('Project')->where(['id' => $item['topic_id']])->value('name');
					}
					else{
						$item['topic_name'] = Db::name('ProjectTask')->where(['id' => $item['topic_id']])->value('title');
					}
				}
			    $item['read'] = 0;
				if($item['admin_id'] == $param['admin_id']){
					$item['read'] = 2;
				}
				else{
					$count = Db::name('CommentRead')->where(['comment_id' => $item['id'],'admin_id' => $param['admin_id']])->count();
					if($count>0){
						$item['read'] = 1;
					}
				}
				return $item;
			});
			return $list;
        } catch(\Exception $e) {
            return ['code' => 1, 'data' => [], 'msg' => $e->getMessage()];
        }
    }
	
    public function get_list($param = [])
    {
        $where = array();
        $where['a.module'] = $param['m'];
		$where['a.topic_id'] = $param['tid'];
        $where['a.delete_time'] = 0;
        $content = \think\facade\Db::name('ProjectComment')
			->field('a.*,u.name,u.thumb')
            ->alias('a')
            ->join('Admin u', 'u.id = a.admin_id')
            ->order('a.create_time desc')
            ->where($where)
            ->select()->toArray();
        foreach ($content as $k => &$v) {
            $v['times'] = time_trans($v['create_time']);
			$v['create_time'] = date('Y-m-d H:i:s',$v['create_time']);
			if($v['update_time']>0){
				$v['update_time'] = '，最后编辑时间:'.time_trans($v['update_time']);
			}
			else{
				$v['update_time'] = '';
			}
			$to_names = Db::name('Admin')->where([['id', 'in', $v['to_uids']]])->column('name');
			if (empty($to_names)) {
				$v['to_names'] = '-';
			} else {
				$v['to_names'] = implode('@', $to_names);
			}
			if($v['pid']>0){
				$pcomment = Db::name('ProjectComment')->where('id','=',$v['pid'])->find();
				$padmin_id =$pcomment['admin_id'];
				$v['padmin'] =Db::name('Admin')->where('id','=',$padmin_id)->value('name');
				$v['pcontent'] = $pcomment['content'];
				$v['ptimes'] = time_trans($pcomment['create_time']);;
			}
        }
        return $content;
    }
}
