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
namespace app\contract\model;

use think\facade\Db;
use think\Model;

class PurchaseLog extends Model
{
    public static $Sourse = [
		'type' => ['', '未设置', '普通合同', '框架合同', '补充协议', '其他合同'],
		'check_status' => ['待审核', '审核中', '审核通过', '审核拒绝', '已撤销', '已中止', '已作废'],
		'action' => [			
			'add' => '添加',
			'edit' => '修改',
			'delete' => '删除',
			'upload' => '上传',
		],
		'field_array' => [			
			'code' => '编号',
			'name' => '名称',
			'cate_id' => '类别',
			'type' => '性质',
			'subject_id' => '签约主体',
			'supplier' => '供应商名称',
			'contact_name' => '供应商代表姓名',
			'contact_mobile' => '供应商电话',
			'contact_address'=> '供应商地址',
			'start_time' => '开始时间',
			'end_time' => '结束时间',
			'prepared_uid' => '制定人',
			'sign_uid'  => '签订人',
			'keeper_uid'  => '保管人', 
			'share_ids'  => '共享人员',
			'sign_time'  => '签订时间',
			'cost' => '金额',
			'stop_status' => '中止状态',
			'void_status' => '作废状态',
			'check_status' => '审批状态',
			'status' => '状态',
			'archive_status' => '归档状态',
			'file_ids' => '合同附件',
			'file' => '合同附件',
			'remark' => '备注信息',
			'new' => '新增',
			'del' => '删除',
		]
    ];

    public function contract_log($param = [])
    {
        $where = [];
        $where[] = ['a.contract_id', '=', $param['contract_id']];
        $page = intval($param['page']);
        $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
        $content = Db::name('PurchaseLog')
            ->field('a.*,u.name,u.thumb')
            ->alias('a')
            ->join('Admin u', 'u.id = a.admin_id')
            ->order('a.create_time desc')
            ->where($where)
            ->page($page, $rows)
            ->select()->toArray();
        $data = [];
		$sourse = self::$Sourse;
		$field_array = $sourse['field_array'];
		$action = $sourse['action'];
        foreach ($content as $k => $v) {
			if (isset($sourse[$v['field']])) {
                $v['old_content'] = $sourse[$v['field']][$v['old_content']];
                $v['new_content'] = $sourse[$v['field']][$v['new_content']];
            }			
            if (strpos($v['field'], '_time') !== false) {
                if ($v['old_content'] == '') {
                    $v['old_content'] = '未设置';
                }
                $v['new_content'] = date('Y-m-d', (int) $v['new_content']);
            }
            if (strpos($v['field'], '_uid') !== false) {
                $v['old_content'] = Db::name('Admin')->where(['id' => $v['old_content']])->value('name');
                $v['new_content'] = Db::name('Admin')->where(['id' => $v['new_content']])->value('name');
            }
            if ($v['field'] == 'cate_id') {
                $v['old_content'] = Db::name('PurchaseCate')->where(['id' => $v['old_content']])->value('title');
                $v['new_content'] = Db::name('PurchaseCate')->where(['id' => $v['new_content']])->value('title');
            }
			if ($v['field'] == 'subject_id') {
                $v['old_content'] = Db::name('Enterprise')->where(['id' => $v['old_content']])->value('title');
                $v['new_content'] = Db::name('Enterprise')->where(['id' => $v['new_content']])->value('title');
            }
			if ($v['field'] == 'archive_status') {
                $v['old_content'] = $v['old_content'] == 1?'已归档':'未归档';
                $v['new_content'] = $v['new_content'] == 1?'已归档':'未归档';
            }
			if ($v['field'] == 'stop_status') {
                $v['old_content'] = $v['old_content'] == 1?'已中止':'未中止';
                $v['new_content'] = $v['new_content'] == 1?'已中止':'未中止';
            }
			if ($v['field'] == 'void_status') {
                $v['old_content'] = $v['old_content'] == 1?'已作废':'未作废';
                $v['new_content'] = $v['new_content'] == 1?'已作废':'未作废';
            }
            if (strpos($v['field'], '_ids') !== false) {
                $old_ids = Db::name('Admin')->where('id', 'in', $v['old_content'])->column('name');
                $v['old_content'] = implode(',', $old_ids);
                $new_ids = Db::name('Admin')->where('id', 'in', $v['new_content'])->column('name');
                $v['new_content'] = implode(',', $new_ids);
            }
            if ($v['old_content'] == '' || $v['old_content'] == null) {
                $v['old_content'] = '未设置';
            }
            if ($v['new_content'] == '' || $v['new_content'] == null) {
                $v['new_content'] = '未设置';
            }
            $v['action'] = $action[$v['action']];
            $v['title'] = $field_array[$v['field']];
            $v['times'] = time_trans($v['create_time']);
            $v['create_time'] = date('Y-m-d', $v['create_time']);
            $data[] = $v;
        }
        return $data;
    }
}
