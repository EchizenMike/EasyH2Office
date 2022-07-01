<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */

namespace app\contract\model;

use think\facade\Db;
use think\Model;

class Contract extends Model
{
	const ZERO = 0;
    const ONE = 1;
    const TWO = 2;
    const THREE = 3;
    const FORE = 4;
    const FIVE = 5;

    public static $Type = [
        self::ZERO => '未设置',
        self::ONE => '普通合同',
        self::TWO => '框架合同',
        self::THREE => '补充协议',
        self::FORE => '其他合同',
    ];
	
	public static $Status = [
        self::ZERO => '未设置',
        self::ONE => '已录入',
        self::TWO => '待审核',
        self::THREE => '已审核',
        self::FORE => '已中止',
        self::FIVE => '已作废',
    ];
	
	public static $ArchiveStatus = [
        self::ZERO => '未归档',
        self::ONE => '已归档',
    ];
    // 获取合同详情
    public function detail($id)
    {
        $detail = Db::name('Contract')->where(['id' => $id])->find();
        if (!empty($detail)) {
			$file_array = Db::name('ContractFile')
				->field('cf.id,f.filepath,f.name,f.filesize,f.fileext')
				->alias('cf')
				->join('File f', 'f.id = cf.file_id', 'LEFT')
				->order('cf.create_time asc')
				->where(array('cf.contract_id' => $id, 'cf.delete_time' => 0))
				->select()->toArray();
				
			$detail['status_name'] = self::$Status[(int) $detail['status']];	
			$detail['archive_status_name'] = self::$ArchiveStatus[(int) $detail['archive_status']];	
			$detail['sign_time'] = date('Y-m-d', $detail['sign_time']);
            $detail['start_time'] = date('Y-m-d', $detail['start_time']);
            $detail['end_time'] = date('Y-m-d', $detail['end_time']);
            $detail['create_time'] = date('Y-m-d', $detail['create_time']);
			$detail['cate_title'] = Db::name('ContractCate')->where(['id' => $detail['cate_id']])->value('title');
			$detail['sign_department'] = Db::name('Department')->where(['id' => $detail['sign_did']])->value('title');
			$detail['sign_name'] = Db::name('Admin')->where(['id' => $detail['sign_uid']])->value('name');
			$detail['admin_name'] = Db::name('Admin')->where(['id' => $detail['admin_id']])->value('name');
			$detail['prepared_name'] = Db::name('Admin')->where(['id' => $detail['prepared_uid']])->value('name');
			$detail['keeper_name'] = Db::name('Admin')->where(['id' => $detail['keeper_uid']])->value('name');
			
			$share_names = Db::name('Admin')->where([['id','in',$detail['share_ids']]])->column('name');
			$detail['share_names'] = implode(',',$share_names);
			
			//审核信息
			if($detail['check_uid'] > 0){
				$detail['check_name'] = Db::name('Admin')->where(['id' => $detail['check_uid']])->value('name');
				$detail['check_time'] = date('Y-m-d', $detail['check_time']);
			}
			//中止信息
			if($detail['stop_uid'] > 0){
				$detail['stop_name'] = Db::name('Admin')->where(['id' => $detail['stop_uid']])->value('name');
				$detail['stop_time'] = date('Y-m-d', $detail['stop_time']);
			}
			//作废信息
			if($detail['void_uid'] > 0){
				$detail['void_name'] = Db::name('Admin')->where(['id' => $detail['void_uid']])->value('name');
				$detail['voidtime'] = date('Y-m-d', $detail['void_time']);
			}
			//归档信息
			if($detail['archive_status'] == 1){
				$detail['archive_name'] = Db::name('Admin')->where(['id' => $detail['archive_uid']])->value('name');
				$detail['archive_time'] = date('Y-m-d', $detail['archive_time']);
			}
			
			if($detail['pid']>0){
				$detail['pname'] = Db::name('Contract')->where(['id' => $detail['pid']])->value('name');
			}
			$detail['file_array'] = $file_array;
        }
        return $detail;
    }
}
