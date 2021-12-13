<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\home\model;

use think\Model;
use think\facade\Db;

class Message extends Model
{
    const ZERO = 0;
    const ONE = 1;
    const TWO = 2;
    const THREE = 3;
    const FOUR = 4;
    const FINE = 5;

    public static $Source = [
        self::ZERO => '无',
        self::ONE => '已发消息',
        self::TWO => '草稿消息',
        self::THREE => '已收消息',
    ];

    public static $Type = [
        self::ZERO => '系统',
        self::ONE => '同事',
        self::TWO => '部门',
        self::THREE => '岗位',
        self::FOUR => '全部',
    ];
	
    //获取消息列表
    public function getList($map = [], $param = [],$uid)
    {
        $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
        //垃圾箱列表特殊处理
        if ($param['status'] == 0) {
            $where = [['from_uid', '=', $uid], ['to_uid', '=', $uid]];
            $mail = $this->where($map)
                ->where(function ($query) use ($where) {$query->whereOr($where);})
                ->order('create_time desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
					if($item->template==0){
						$item->msg_type = '个人信息';
						$item->from_name = Db::name('Admin')->where(['id' => $item->from_uid])->value('name');
					}
					else{
						$item->msg_type = '系统信息';
						$item->from_name = '系统';
					}
                    $item->send_time = empty($item->send_time) ? '-' : date('Y-m-d H:i:s', $item->send_time);
                    $item->to_name = Db::name('Admin')->where(['id' => $item->to_uid])->value('name');
                    $item->type_title = self::$Type[(int)$item->type];
                    $item->delete_source_title = self::$Source[(int)$item->delete_source];
                    $item->files = Db::name('MessageFileInterfix')->where(['mid' => $item->id, 'status' => 1])->count();
                });
            return $mail;
        } else {
            $mail = self::where($map)
                ->order('create_time desc')
                ->paginate($rows, false, ['query' => $param])
                ->each(function ($item, $key) {
					if($item->template==0){
						$item->msg_type = '个人信息';
						$item->from_name = Db::name('Admin')->where(['id' => $item->from_uid])->value('name');
					}
					else{
						$item->msg_type = '系统信息';
						$item->from_name = '系统';
					}
                    $item->send_time = empty($item->send_time) ? '-' : date('Y-m-d H:i:s', $item->send_time);
                    $item->to_name = Db::name('Admin')->where(['id' => $item->to_uid])->value('name');
                    $item->type_title = self::$Type[(int)$item->type];
                    $item->files = Db::name('MessageFileInterfix')->where(['mid' => $item->id, 'status' => 1])->count();
                });
            return $mail;
        }
    }
}
