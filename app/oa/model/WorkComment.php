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
namespace app\oa\model;

use think\Model;

class WorkComment extends Model
{
    public function get_list($param = [])
    {
        $where = array();
		$where['a.article_id'] = $param['tid'];
        $where['a.delete_time'] = 0;
        $content = \think\facade\Db::name('WorkComment')
			->field('a.*,u.name,u.thumb,pu.name as pname')
            ->alias('a')
            ->join('Admin u', 'u.id = a.admin_id')
            ->leftjoin('Admin pu', 'pu.id = a.padmin_id')
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
        }
        return $content;
    }
}
