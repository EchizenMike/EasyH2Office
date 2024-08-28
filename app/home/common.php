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

use think\facade\Db;

//获取服务器信息
function get_system_info($key)
{
    $system = [
        'os' => PHP_OS,
        'php' => PHP_VERSION,
        'upload_max_filesize' => get_cfg_var("upload_max_filesize") ? get_cfg_var("upload_max_filesize") : "不允许上传附件",
        'max_execution_time' => get_cfg_var("max_execution_time") . "秒 ",
    ];
    if (empty($key)) {
        return $system;
    } else {
        return $system[$key];
    }
}

//假期类型
function get_leaves_types($id=0)
{
	$types_array = ['未设置','事假','年假','调休假','病假','婚假','丧假','产假','陪产假','其他'];
	if($id==0){
		return $types_array;
	}
	else{
		$news_array=[];
		foreach($types_array as $key => $value){
			if($key>0){
				$news_array[]=array(
					'id'=>$key,
					'title'=>$value,
				);
			}
		}
		return $news_array;
	}
}

//根据假期类型读取名称
function leaves_types_name($types=0)
{
	$types_array = get_leaves_types();
	return $types_array[$types];
}

/**
 * curl 模拟GET请求
 * @author lee
 ***/
function curl_get($url)
{
    //初始化
    $ch = curl_init();
    //设置抓取的url
    curl_setopt($ch, CURLOPT_URL, $url);
    //设置获取的信息以文件流的形式返回，而不是直接输出。
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE); // https请求 不验证证书
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE); // https请求 不验证hosts
	curl_setopt($ch, CURLINFO_HEADER_OUT, TRUE);//添加这个获取请求头信息
    //执行命令
    $output = curl_exec($ch);
	$meta = curl_getinfo($ch,CURLINFO_HEADER_OUT);
	$accept = substr($meta,0,strpos($meta, 'Accept:'));
	$host = substr($accept,strpos($accept, 'Host:')+5);
    curl_close($ch); //释放curl句柄
    return $output;
}

/**
 * 模拟post进行url请求
 * @param string $url
 * @param string $param
 */
function curl_post($url = '', $post = array())
{
	$post['host'] = $_SERVER['HTTP_HOST'];
    $curl = curl_init(); // 启动一个CURL会话
    curl_setopt($curl, CURLOPT_URL, $url); // 要访问的地址
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0); // 从证书中检查SSL加密算法是否存在
    curl_setopt($curl, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']); // 模拟用户使用的浏览器
    curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1); // 使用自动跳转
    curl_setopt($curl, CURLOPT_AUTOREFERER, 1); // 自动设置Referer
    curl_setopt($curl, CURLOPT_POST, 1); // 发送一个常规的Post请求
    curl_setopt($curl, CURLOPT_POSTFIELDS, $post); // Post提交的数据包
    curl_setopt($curl, CURLOPT_TIMEOUT, 30); // 设置超时限制防止死循环
    curl_setopt($curl, CURLOPT_HEADER, 0); // 显示返回的Header区域内容
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1); // 获取的信息以文件流的形式返回
    $res = curl_exec($curl); // 执行操作
    if (curl_errno($curl)) {
        return 'Errno ' . curl_error($curl);//捕抓异常
    }
    curl_close($curl); // 关闭CURL会话
    return $res; // 返回数据，json格式
}


//读取后台菜单列表
function admin_menu()
{
    $menu = Db::name('AdminRule')->where(['menu' => 1,'status'=>1])->order('sort asc,id asc')->select()->toArray();
    return $menu;
}

//读取权限节点列表
function admin_rule()
{
    $rule = Db::name('AdminRule')->where(['status'=>1])->order('sort asc,id asc')->select()->toArray();
    return $rule;
}

//读取权限分组列表
function admin_group()
{
    $group = Db::name('AdminGroup')->order('id desc')->select()->toArray();
    return $group;
}

//读取指定权限分组菜单详情
function admin_group_info($id)
{
    $rule = Db::name('AdminGroup')->where(['id' => $id])->value('rules');
	$rules = explode(',', $rule);
    return $rules;
}

//读取模块列表
function admin_module()
{
    $group = Db::name('AdminModule')->order('id asc')->select()->toArray();
    return $group;
}
