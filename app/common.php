<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */
// 应用公共文件,内置主要的数据处理方法
use think\facade\Config;
use think\facade\Request;

//读取文件配置
function get_config($key)
{
    return Config::get($key);
}

//判断cms是否完成安装
function is_installed()
{
    static $isInstalled;
    if (empty($isInstalled)) {
        $isInstalled = file_exists(CMS_ROOT . 'config/install.lock');
    }
    return $isInstalled;
}


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

//获取url参数
function get_params($key = "")
{
    return Request::instance()->param($key);
}

//生成一个不会重复的字符串
function make_token()
{
    $str = md5(uniqid(md5(microtime(true)), true));
    $str = sha1($str); //加密
    return $str;
}

//随机字符串，默认长度10
function set_salt($num = 10)
{
    $str = 'qwertyuiopasdfghjklzxcvbnm1234567890';
    $salt = substr(str_shuffle($str), 10, $num);
    return $salt;
}
//密码加密
function set_password($pwd, $salt)
{
    return md5(md5($pwd . $salt) . $salt);
}
/**
 * 截取文章摘要
 *  @return bool
 */
function get_desc_content($content, $count)
{
    $content = preg_replace("@<script(.*?)</script>@is", "", $content);
    $content = preg_replace("@<iframe(.*?)</iframe>@is", "", $content);
    $content = preg_replace("@<style(.*?)</style>@is", "", $content);
    $content = preg_replace("@<(.*?)>@is", "", $content);
    $content = str_replace(PHP_EOL, '', $content);
    $space = array(" ", "　", "  ", " ", " ");
    $go_away = array("", "", "", "", "");
    $content = str_replace($space, $go_away, $content);
    $res = mb_substr($content, 0, $count, 'UTF-8');
    if (mb_strlen($content, 'UTF-8') > $count) {
        $res = $res . "...";
    }
    return $res;
}
/**
 * PHP格式化字节大小
 * @param number $size      字节数
 * @param string $delimiter 数字和单位分隔符
 * @return string            格式化后的带单位的大小
 */
function format_bytes($size, $delimiter = '')
{
    $units = array('B', 'KB', 'MB', 'GB', 'TB', 'PB');
    for ($i = 0; $size >= 1024 && $i < 5; $i++) {
        $size /= 1024;
    }
    return round($size, 2) . $delimiter . $units[$i];
}

/**
 *数据处理成树形格式1
 * @return array
 */
function list_to_tree($list, $pk = 'id', $pid = 'pid', $child = 'list', $root = 0)
{
    // 创建Tree
    $tree = array();
    if (is_array($list)) {
        // 创建基于主键的数组引用
        $refer = array();
        foreach ($list as $key => $data) {
            $refer[$data[$pk]] = &$list[$key];
        }
        foreach ($list as $key => $data) {
            // 判断是否存在parent
            $parentId = $data[$pid];
            if ($root == $parentId) {
                $tree[$data[$pk]] = &$list[$key];
            } else {
                if (isset($refer[$parentId])) {
                    $parent = &$refer[$parentId];
                    $parent[$child][$data[$pk]] = &$list[$key];
                }
            }
        }
    }
    return $tree;
}

/**
 *数据处理成树形格式2
 * @return array
 */
function create_tree_list($pid, $arr, $group, &$tree = [])
{
    foreach ($arr as $key => $vo) {
        if ($key == 0) {
            $vo['spread'] = true;
        }
        if (!empty($group) and in_array($vo['id'], $group)) {
            $vo['checked'] = true;
        } else {
            $vo['checked'] = false;
        }
        if ($vo['pid'] == $pid) {
            $child = create_tree_list($vo['id'], $arr, $group);
            if ($child) {
                $vo['children'] = $child;
            }
            $tree[] = $vo;
        }
    }
    return $tree;
}


//递归排序，用于分类选择
function set_recursion($result, $pid = 0, $level=-1)
{
    /*记录排序后的类别数组*/
    static $list = array();
    static $space = ['','├─','§§├─','§§§§├─','§§§§§§├─'];
	$level++;
    foreach ($result as $k => $v) {
        if ($v['pid'] == $pid) {
            if ($pid != 0) {
                $v['title'] = $space[$level] . $v['title'];
            }
            /*将该类别的数据放入list中*/
            $list[] = $v;
            set_recursion($result, $v['id'],$level);
        }
    }
    return $list;
}


//递归返回树形菜单数据
function get_tree($data, $pId ,$open=0,$deep=0)
{
	$tree = [];		
	foreach($data as $k => $v)
	{
		$v['checkArr']=array('type'=>0, 'isChecked'=>0);	
		$v['spread']=true;	
		$v['parentId']=$v['pid'];	
		if($deep>=$open){
			$v['spread']=false;	
		}			
		$v['name']=$v['title'];	
		if($v['pid'] == $pId){ 
		//父亲找到儿子
		$deep++;
		$v['children'] = get_tree($data, $v['id'],$open,$deep);
		$tree[] = $v;
		//unset($data[$k]);
	   }
	}
	return array_values($tree);
}

/**
 * 根据id递归返回子数据
 * @param  $data 数据
 * @param  $pid 父节点id
 */
function get_data_node($data=[],$pid=0){
	$dep = [];		
	foreach($data as $k => $v){			
		if($v['pid'] == $pid){
			$node=get_data_node($data, $v['id']);
			array_push($dep,$v);
			if(!empty($node)){					
				$dep=array_merge($dep,$node);
			}
		}   	
	}
	return array_values($dep);
}

//访问按小时归档统计
function hour_document($arrData)
{
    $documents = array();
    $hour = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23];
    foreach ($hour as $val) {
        $documents[$val] = 0;
    }
    foreach ($arrData as $index => $value) {
        $archivesTime = intval(date("H", $value['create_time']));
        $documents[$archivesTime] += 1;
    }
    return $documents;
}

//访问按日期归档统计
function date_document($arrData)
{
    $documents = array();
    foreach ($arrData as $index => $value) {
        $archivesTime = date("Y-m-d", $value['create_time']);
        if (empty($documents[$archivesTime])) {
            $documents[$archivesTime] = 1;
        } else {
            $documents[$archivesTime] += 1;
        }
    }
    return $documents;
}


/**
 * 返回json数据，用于接口
 * @param    integer    $code
 * @param    string     $msg
 * @param    array      $data
 * @param    string     $url
 * @param    integer    $httpCode
 * @param    array      $header
 * @param    array      $options
 * @return   json
 */
function to_assign($code = 0, $msg = "操作成功", $data = [], $url = '', $httpCode = 200, $header = [], $options = [])
{
    $res = ['code' => $code];
    $res['msg'] = $msg;
    $res['url'] = $url;
    if (is_object($data)) {
        $data = $data->toArray();
    }
    $res['data'] = $data;
    $response = \think\Response::create($res, "json", $httpCode, $header, $options);
    throw new \think\exception\HttpResponseException($response);
}

/**
 * 适配layui table数据列表的返回数据方法，用于接口
 * @param    integer    $code
 * @param    string     $msg
 * @param    array      $data
 * @param    integer    $httpCode
 * @param    array      $header
 * @param    array      $options
 * @return   json
 */
function table_assign($code = 0, $msg = '请求成功', $data = [], $httpCode = 200, $header = [], $options = [])
{
    $res['code'] = $code;
    $res['msg'] = $msg;
    if (is_object($data)) {
        $data = $data->toArray();
    }
    if (!empty($data['total'])) {
        $res['count'] = $data['total'];
    } else {
        $res['count'] = 0;
    }
    $res['data'] = $data['data'];
    $response = \think\Response::create($res, "json", $httpCode, $header, $options);
    throw new \think\exception\HttpResponseException($response);
}

/**
 * 时间戳格式化
 * @param int    $time
 * @param string $format 默认'Y-m-d H:i'，x代表毫秒
 * @return string 完整的时间显示
 */
function time_format($time = NULL, $format = 'Y-m-d H:i:s')
{
    $usec = $time = $time === null ? '' : $time;
    if (strpos($time, '.')!==false) {
        list($usec, $sec) = explode(".", $time);
    } else {
        $sec = 0;
    }
    return $time != '' ? str_replace('x', $sec, date($format, intval($usec))) : '';
}

function parseDateTime($string, $timeZone=null) {
  $date = new DateTime(
    $string,
    $timeZone ? $timeZone : new DateTimeZone('UTC')
  );
  if ($timeZone) {
    $date->setTimezone($timeZone);
  }
  return $date;
}


function stripTime($datetime) {
  return new DateTime($datetime->format('Y-m-d'));
}

/**
 * 间隔时间段格式化
 * @param int $time 时间戳
 * @param string $format 格式 【d：显示到天 i显示到分钟 s显示到秒】
 * @return string
 */
function time_trans($time, $format = 'd')
{
    $now = time();
    $diff = $now - $time;
    if ($diff < 60) {
        return '1分钟前';
    } else if ($diff < 3600) {
        return floor($diff / 60) . '分钟前';
    } else if ($diff < 86400) {
        return floor($diff / 3600) . '小时前';
    }
    $yes_start_time = strtotime(date('Y-m-d 00:00:00', strtotime('-1 days'))); //昨天开始时间
    $yes_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-1 days'))); //昨天结束时间
    $two_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-2 days'))); //2天前结束时间
    $three_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-3 days'))); //3天前结束时间
    $four_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-4 days'))); //4天前结束时间
    $five_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-5 days'))); //5天前结束时间
    $six_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-6 days'))); //6天前结束时间
    $seven_end_time = strtotime(date('Y-m-d 23:59:59', strtotime('-7 days'))); //7天前结束时间

    if ($time > $yes_start_time && $time < $yes_end_time) {
        return '昨天';
    }

    if ($time > $yes_start_time && $time < $two_end_time) {
        return '1天前';
    }

    if ($time > $yes_start_time && $time < $three_end_time) {
        return '2天前';
    }

    if ($time > $yes_start_time && $time < $four_end_time) {
        return '3天前';
    }

    if ($time > $yes_start_time && $time < $five_end_time) {
        return '4天前';
    }

    if ($time > $yes_start_time && $time < $six_end_time) {
        return '5天前';
    }

    if ($time > $yes_start_time && $time < $seven_end_time) {
        return '6天前';
    }

    switch ($format) {
        case 'd':
            $show_time = date('Y-m-d', $time);
            break;
        case 'i':
            $show_time = date('Y-m-d H:i', $time);
            break;
        case 's':
            $show_time = date('Y-m-d H:i:s', $time);
            break;
    }
    return $show_time;
}


/**
 * 判断是否是手机浏览器
 *  @return bool
 */
function is_mobile()
{ 
    if (isset($_SERVER['HTTP_VIA']) && stristr($_SERVER['HTTP_VIA'], "wap")) {
        return true;
    } elseif (isset($_SERVER['HTTP_ACCEPT']) && strpos(strtoupper($_SERVER['HTTP_ACCEPT']), "VND.WAP.WML")) {
        return true;
    } elseif (isset($_SERVER['HTTP_X_WAP_PROFILE']) || isset($_SERVER['HTTP_PROFILE'])) {
        return true;
    } elseif (isset($_SERVER['HTTP_USER_AGENT']) && preg_match('/(blackberry|configuration\/cldc|hp |hp-|htc |htc_|htc-|iemobile|kindle|midp|mmp|motorola|mobile|nokia|opera mini|opera |Googlebot-Mobile|YahooSeeker\/M1A1-R2D2|android|iphone|ipod|mobi|palm|palmos|pocket|portalmmm|ppc;|smartphone|sonyericsson|sqh|spv|symbian|treo|up.browser|up.link|vodafone|windows ce|xda |xda_)/i', $_SERVER['HTTP_USER_AGENT'])) {
        return true;
    } else {
        return false;
    }
}

/**
 * 验证输入的邮件地址是否合法
 * @param $user_email 邮箱
 * @return bool
 */
function is_email($user_email)
{
    $chars = "/^([a-z0-9+_]|\\-|\\.)+@(([a-z0-9_]|\\-)+\\.)+[a-z]{2,6}\$/i";
    if (strpos($user_email, '@') !== false && strpos($user_email, '.') !== false) {
        if (preg_match($chars, $user_email)) {
            return true;
        } else {
            return false;
        }
    } else {
        return false;
    }
}

/**
 * 验证输入的手机号码是否合法
 * @param $mobile_phone 手机号
 * @return bool
 */
function is_mobile_phone($mobile_phone)
{
    $chars = "/^13[0-9]{1}[0-9]{8}$|15[0-9]{1}[0-9]{8}$|18[0-9]{1}[0-9]{8}$|17[0-9]{1}[0-9]{8}$/";
    if (preg_match($chars, $mobile_phone)) {
        return true;
    }
    return false;
}
