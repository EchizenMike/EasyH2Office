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

/**
======================
 *模块数据获取公共文件
======================
 */
use think\facade\Db;

//客户查看编辑数据权限判断
function customer_auth($uid,$customer_id,$ajax=0,$level=0)
{
	$customer =  Db::name('Customer')->where(['id' => $customer_id])->find();
	//是否是客户管理员
    $auth = isAuth($uid,'customer_admin','conf_1');
	if($customer['belong_uid']==0){
		return $customer;
	}
	if($auth==1){
		return $customer;
	}
	else if($auth==0){
		$auth_array=[];
		if(!empty($customer['share_ids'])){
			$share_ids = explode(",",$customer['share_ids']);
			$auth_array = array_merge($auth_array,$share_ids);
		}	
		array_push($auth_array,$customer['belong_uid']);
		//部门负责人
		$dids = get_leader_departments($uid);
		if(!in_array($uid,$auth_array) && !in_array($customer['belong_did'],$dids)){
			if($ajax == 1){
				to_assign(1,'无权限操作');
			}
			else{
				throw new \think\exception\HttpException(405, '无权限访问');
			}
		}
		else{
			return $customer;
		}
	}
}

//读取分类列表
function customer_grade()
{
    $cate = Db::name('CustomerGrade')->where(['status' => 1])->select()->toArray();
    return $cate;
}

//读取签约主体
function customer_source()
{
    $source = Db::name('CustomerSource')->where(['status' => 1])->select()->toArray();
    return $source;
}

//读取联系人
function customer_contact($cid)
{
    $contact = Db::name('CustomerContact')->where(['delete_time' => 0,'cid'=>$cid])->select()->toArray();
    return $contact;
}

//读取销售机会
function customer_chance($cid)
{
    $chance = Db::name('CustomerChance')->where(['delete_time' => 0,'cid'=>$cid])->select()->toArray();
    return $chance;
}

//写入日志
function to_log($uid,$type,$new,$old)
{
	$log_data = [];
	$key_array = ['id', 'create_time', 'update_time', 'admin_id','belong_did','belong_time','distribute_time'];
	$type_array = ['customer_id', 'trace_id', 'contact_id', 'chance_id'];
	foreach ($new as $key => $value) {
		if (!in_array($key, $key_array)) {
			if(isset($old[$key]) && ($old[$key]!=$value)){
				$log_data[] = array(
					'field' => $key,
					'type' => $type,
					$type_array[$type] => $new['id'],
					'admin_id' => $uid,
					'old_content' => $old[$key],
					'new_content' => $value,
					'create_time' => time(),
				);
			}
		}
	}
	Db::name('CustomerLog')->strict(false)->field(true)->insertAll($log_data);
}