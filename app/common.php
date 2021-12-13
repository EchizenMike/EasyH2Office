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
 * 截取字符串
 * @param $start 开始截取位置
 * @param $length 截取长度
 * @return
 */
function msubstr($str, $start = 0, $length, $charset = "utf-8", $suffix = true)
{
    if (function_exists("mb_substr")) {
        $slice = mb_substr($str, $start, $length, $charset);
    } elseif (function_exists('iconv_substr')) {
        $slice = iconv_substr($str, $start, $length, $charset);
        if (false === $slice) {
            $slice = '';
        }
    } else {
        $re['utf-8'] = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xff][\x80-\xbf]{3}/";
        $re['gb2312'] = "/[\x01-\x7f]|[\xb0-\xf7][\xa0-\xfe]/";
        $re['gbk'] = "/[\x01-\x7f]|[\x81-\xfe][\x40-\xfe]/";
        $re['big5'] = "/[\x01-\x7f]|[\x81-\xfe]([\x40-\x7e]|\xa1-\xfe])/";
        preg_match_all($re[$charset], $str, $match);
        $slice = join("", array_slice($match[0], $start, $length));
    }
    if (utf8_strlen($str) < $length) $suffix = false;
    return $suffix ? $slice . '...' : $slice;
}

function utf8_strlen($string = null)
{
    preg_match_all("/./us", $string, $match);
    return count($match[0]);
}

/**
 * PHP截取文字长度
 * @return string
 */
function sub_str($str,$len=20){
    $strlen=strlen($str)/3;#在编码utf8下计算字符串的长度，并把它交给变量$strlen
    #echo $strlen;#输出字符串长度
    if($strlen<$len){
        return $str;
    }else{
        return mb_substr($str,0,$len,"utf-8")."...";
    }
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
 * 人民币转大写
 * @param
 */
function cny($ns)
{
    static $cnums = array("零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖"),
    $cnyunits = array("圆", "角", "分"),
    $grees = array("拾", "佰", "仟", "万", "拾", "佰", "仟", "亿");
    list($ns1, $ns2) = explode(".", $ns, 2);
    $ns2 = array_filter(array($ns2[1], $ns2[0]));
    $ret = array_merge($ns2, array(implode("", _cny_map_unit(str_split($ns1), $grees)), ""));
    $ret = implode("", array_reverse(_cny_map_unit($ret, $cnyunits)));
    return str_replace(array_keys($cnums), $cnums, $ret);
}

function _cny_map_unit($list, $units)
{
    $ul = count($units);
    $xs = array();
    foreach (array_reverse($list) as $x) {
        $l = count($xs);
        if ($x != "0" || !($l % 4)) {
            $n = ($x == '0' ? '' : $x) . ($units[($l - 1) % $ul]);
        } else {
            $n = is_numeric($xs[0][0]) ? $x : '';
        }
        array_unshift($xs, $n);
    }
    return $xs;
}


/**
 * 金额展示规则,超过1万时以万为单位，低于1万时以千为单位，低于1千时以元为单位
 * @param string $money 金额
 * @return string
 */
function format_money($money)
{
    $data = '0元';
    if (($money / 10000) > 1) {
        $data = is_int($money / 10000) ? ($money / 10000) . '万' : rand(($money / 10000), 2) . '万';
    } elseif (($money / 1000) > 1) {
        $data = is_int($money / 1000) ? ($money / 1000) . '千' : rand(($money / 1000), 2) . '千';
    } else {
        $data = $money . '元';
    }
    return $data;
}

/**
 * 数组转换字符串（以逗号隔开）
 * @param
 * @return
 */
function arrayToString($array)
{
    if (!is_array($array)) {
        $data_arr[] = $array;
    } else {
        $data_arr = $array;
    }
    $data_arr = array_filter($data_arr); //数组去空
    $data_arr = array_unique($data_arr); //数组去重
    $data_arr = array_merge($data_arr);
    $string = $data_arr ? ',' . implode(',', $data_arr) . ',' : '';
    return $string ?: '';
}

/**
 * 字符串转换数组（以逗号隔开）
 * @param
 * @return
 */
function stringToArray($string)
{
    if (is_array($string)) {
        $data_arr = array_unique(array_filter($string));
    } else {
        $data_arr = $string ? array_unique(array_filter(explode(',', $string))) : [];
    }
    $data_arr = $data_arr ? array_merge($data_arr) : [];
    return $data_arr ?: [];
}

/**
 * 二维数组排序(选择)
 * @param $select 要进行排序的select结果集
 * @param $field  排序的字段
 * @param $order 排序方式1降序2升序
 */
function sort_select($select = array(), $field, $order = 1)
{
    $count = count($select);
    if ($order == 1) {
        for ($i = 0; $i < $count; $i++) {
            $k = $i;
            for ($j = $i; $j < $count; $j++) {
                if ($select[$k][$field] < $select[$j][$field]) {
                    $k = $j;
                }
            }
            $temp = $select[$i];
            $select[$i] = $select[$k];
            $select[$k] = $temp;
        }
        return $select;
    } else {
        for ($i = 0; $i < $count; $i++) {
            $k = $i;
            for ($j = $i; $j < $count; $j++) {
                if ($select[$k][$field] > $select[$j][$field]) {
                    $k = $j;
                }
            }
            $temp = $select[$i];
            $select[$i] = $select[$k];
            $select[$k] = $temp;
        }
        return $select;
    }
}

/**
 * fullcalendar日历控件方法1
 */
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

/**
 * fullcalendar日历控件方法2
 */
function stripTime($datetime) {
  return new DateTime($datetime->format('Y-m-d'));
}

/**
 * 根据时间戳获取星期几
 * @param $time 要转换的时间戳
 */
function getTimeWeek($time, $i = 0)
{
    $weekarray = array("日", "一", "二", "三", "四", "五", "六");
    $oneD = 24 * 60 * 60;
    return "星期" . $weekarray[date("w", $time + $oneD * $i)];
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

/**
 * 将秒数转换为时间 (年、天、小时、分、秒）
 * @param
 */
function getTimeBySec($time)
{
    if (is_numeric($time)) {
        $value = array(
            "years" => 0, "days" => 0, "hours" => 0,
            "minutes" => 0, "seconds" => 0,
        );
        if ($time >= 31556926) {
            $value["years"] = floor($time / 31556926);
            $time = ($time % 31556926);
            $t .= $value["years"] . "年";
        }
        if ($time >= 86400) {
            $value["days"] = floor($time / 86400);
            $time = ($time % 86400);
            $t .= $value["days"] . "天";
        }
        if ($time >= 3600) {
            $value["hours"] = floor($time / 3600);
            $time = ($time % 3600);
            $t .= $value["hours"] . "小时";
        }
        if ($time >= 60) {
            $value["minutes"] = floor($time / 60);
            $time = ($time % 60);
            $t .= $value["minutes"] . "分钟";
        }
        if ($time < 60) {
            $value["seconds"] = floor($time);
            $t .= $value["seconds"] . "秒";
        }
        return $t;
    } else {
        return (bool)FALSE;
    }
}

/*
 *根据年月计算有几天
 */
function getmonthByYM($param)
{
    $month = $param['month'] ? $param['month'] : date('m', time());
    $year = $param['year'] ? $param['year'] : date('Y', time());
    if (in_array($month, array('1', '3', '5', '7', '8', '01', '03', '05', '07', '08', '10', '12'))) {
        $days = '31';
    } elseif ($month == 2) {
        if ($year % 400 == 0 || ($year % 4 == 0 && $year % 100 !== 0)) {
            //判断是否是闰年  
            $days = '29';
        } else {
            $days = '28';
        }
    } else {
        $days = '30';
    }
    return $days;
}

/**
 * 根据时间戳计算当月天数
 * @param
 */
function getmonthdays($time)
{
    $month = date('m', $time);
    $year = date('Y', $time);
    if (in_array($month, array('1', '3', '5', '7', '8', '01', '03', '05', '07', '08', '10', '12'))) {
        $days = '31';
    } elseif ($month == 2) {
        if ($year % 400 == 0 || ($year % 4 == 0 && $year % 100 !== 0)) {
            //判断是否是闰年  
            $days = '29';
        } else {
            $days = '28';
        }
    } else {
        $days = '30';
    }
    return $days;
}

/**
 * 生成从开始时间到结束时间的日期数组
 * @param type，默认时间戳格式
 * @param type = 1 时，date格式
 * @param type = 2 时，获取每日开始、结束时间
 */
function dateList($start, $end, $type = 0)
{
    if (!is_numeric($start) || !is_numeric($end) || ($end <= $start)) return '';
    $i = 0;
    //从开始日期到结束日期的每日时间戳数组
    $d = array();
    if ($type == 1) {
        while ($start <= $end) {
            $d[$i] = date('Y-m-d', $start);
            $start = $start + 86400;
            $i++;
        }
    } else {
        while ($start <= $end) {
            $d[$i] = $start;
            $start = $start + 86400;
            $i++;
        }
    }
    if ($type == 2) {
        $list = array();
        foreach ($d as $k => $v) {
            $list[$k] = getDateRange($v);
        }
        return $list;
    } else {
        return $d;
    }
}

/**
 * 获取指定日期开始时间与结束时间
 */
function getDateRange($timestamp)
{
    $ret = array();
    $ret['sdate'] = strtotime(date('Y-m-d', $timestamp));
    $ret['edate'] = strtotime(date('Y-m-d', $timestamp)) + 86400;
    return $ret;
}

/**
 * 生成从开始月份到结束月份的月份数组
 * @param int $start 开始时间戳
 * @param int $end 结束时间戳
 */
function monthList($start, $end)
{
    if (!is_numeric($start) || !is_numeric($end) || ($end <= $start)) return '';
    $start = date('Y-m', $start);
    $end = date('Y-m', $end);
    //转为时间戳
    $start = strtotime($start . '-01');
    $end = strtotime($end . '-01');
    $i = 0;
    $d = array();
    while ($start <= $end) {
        //这里累加每个月的的总秒数 计算公式：上一月1号的时间戳秒数减去当前月的时间戳秒数
        $d[$i] = $start;
        $start += strtotime('+1 month', $start) - $start;
        $i++;
    }
    return $d;
}

/**
 * 等于（时间段）数据处理
 *
 * @param $data
 * @return array
 * @since 2021-06-11
 * @author fanqi
 */
function advancedDate($data)
{
    // 本年度
    if ($data['value'][0] == 'year') {
        $arrTime = DataTime::year();
        $data['value'][0] = date('Y-m-d 00:00:00', $arrTime[0]);
        $data['value'][1] = date('Y-m-d 23:59:59', $arrTime[1]);
    }

    // 上一年度
    if ($data['value'][0] == 'lastYear') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '-1 year'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '-1 year'));
    }

    // 下一年度
    if ($data['value'][0] == 'nextYear') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '+1 year'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '+1 year'));
    }

    // 上半年
    if ($data['value'][0] == 'firstHalfYear') {
        $data['value'][0] = date('Y-01-01 00:00:00');
        $data['value'][1] = date('Y-06-30 23:59:59');
    }

    // 下半年
    if ($data['value'][0] == 'nextHalfYear') {
        $data['value'][0] = date('Y-07-01 00:00:00');
        $data['value'][1] = date('Y-12-31 23:59:59');
    }

    // 本季度
    if ($data['value'][0] == 'quarter') {
        $season = ceil((date('n')) / 3);
        $data['value'][0] = date('Y-m-d H:i:s', mktime(0, 0, 0, $season * 3 - 3 + 1, 1, date('Y')));
        $data['value'][1] = date('Y-m-d H:i:s', mktime(23, 59, 59, $season * 3, date('t', mktime(0, 0, 0, $season * 3, 1, date("Y"))), date('Y')));
    }

    // 上一季度
    if ($data['value'][0] == 'lastQuarter') {
        $season = ceil((date('n')) / 3) - 1;
        $data['value'][0] = date('Y-m-d H:i:s', mktime(0, 0, 0, $season * 3 - 3 + 1, 1, date('Y')));
        $data['value'][1] = date('Y-m-d H:i:s', mktime(23, 59, 59, $season * 3, date('t', mktime(0, 0, 0, $season * 3, 1, date("Y"))), date('Y')));
    }

    // 下一季度
    if ($data['value'][0] == 'nextQuarter') {
        $season = ceil((date('n')) / 3);
        $data['value'][0] = date('Y-m-d H:i:s', mktime(0, 0, 0, $season * 3 + 1, 1, date('Y')));
        $data['value'][1] = date('Y-m-d H:i:s', mktime(23, 59, 59, $season * 3 + 3, date('t', mktime(0, 0, 0, $season * 3, 1, date("Y"))), date('Y')));
    }

    // 本月
    if ($data['value'][0] == 'month') {
        $data['value'][0] = date('Y-m-01 00:00:00');
        $data['value'][1] = date('Y-m-31 23:59:59');
    }

    // 上月
    if ($data['value'][0] == 'lastMonth') {
        $data['value'][0] = date('Y-m-01 00:00:00', strtotime(date('Y-m-d') . '-1 month'));
        $data['value'][1] = date('Y-m-31 23:59:59', strtotime(date('Y-m-d') . '-1 month'));
    }

    // 下月
    if ($data['value'][0] == 'nextMonth') {
        $data['value'][0] = date('Y-m-01 00:00:00', strtotime(date('Y-m-d') . '+1 month'));
        $data['value'][1] = date('Y-m-31 23:59:59', strtotime(date('Y-m-d') . '+1 month'));
    }

    // 本周
    if ($data['value'][0] == 'week') {
        $data['value'][0] = date('Y-m-d 00:00:00', mktime(0, 0, 0, date('m'), date('d') - date('w') + 1, date('Y')));
        $data['value'][1] = date('Y-m-d 23:59:59', mktime(23, 59, 59, date('m'), date('d') - date('w') + 7, date('Y')));
    }

    // 上周
    if ($data['value'][0] == 'lastWeek') {
        $date = date("Y-m-d");
        $w = date("w", strtotime($date));
        $d = $w ? $w - 1 : 6;
        $start = date("Y-m-d", strtotime($date . " - " . $d . " days"));
        $data['value'][0] = date('Y-m-d', strtotime($start . " - 7 days"));
        $data['value'][1] = date('Y-m-d', strtotime($start . " - 1 days"));
    }

    // 下周
    if ($data['value'][0] == 'nextWeek') {
        $date = date("Y-m-d");
        $w = date("w", strtotime($date));
        $d = $w ? $w - 1 : 6;
        $start = date("Y-m-d", strtotime($date . " - " . $d . " days"));
        $data['value'][0] = date('Y-m-d', strtotime($start . " + 7 days"));
        $data['value'][1] = date('Y-m-d', strtotime($start . " + 13 days"));
    }

    // 今天
    if ($data['value'][0] == 'today') {
        $data['value'][0] = date('Y-m-d 00:00:00');
        $data['value'][1] = date('Y-m-d 23:59:59');
    }

    // 昨天
    if ($data['value'][0] == 'yesterday') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '-1 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '-1 day'));
    }

    // 明天
    if ($data['value'][0] == 'tomorrow') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '+1 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '+1 day'));
    }

    // 过去7天
    if ($data['value'][0] == 'previous7day') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '-7 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '-1 day'));
    }

    // 过去30天
    if ($data['value'][0] == 'previous30day') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '-30 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '-1 day'));
    }

    // 未来7天
    if ($data['value'][0] == 'future7day') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '+1 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '+7 day'));
    }

    // 未来30天
    if ($data['value'][0] == 'future30day') {
        $data['value'][0] = date('Y-m-d 00:00:00', strtotime(date('Y-m-d') . '+1 day'));
        $data['value'][1] = date('Y-m-d 23:59:59', strtotime(date('Y-m-d') . '+30 day'));
    }

    return $data;
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
 * 获取客户浏览器类型
 */
function getBrowser()
{
    $Browser = $_SERVER['HTTP_USER_AGENT'];
    if (preg_match('/MSIE/i', $Browser)) {
        $Browser = 'MSIE';
    } elseif (preg_match('/Firefox/i', $Browser)) {
        $Browser = 'Firefox';
    } elseif (preg_match('/Chrome/i', $Browser)) {
        $Browser = 'Chrome';
    } elseif (preg_match('/Safari/i', $Browser)) {
        $Browser = 'Safari';
    } elseif (preg_match('/Opera/i', $Browser)) {
        $Browser = 'Opera';
    } else {
        $Browser = 'Other';
    }
    return $Browser;
}

/**
 * 获取客户端系统
 */
function getOS()
{
    $agent = $_SERVER['HTTP_USER_AGENT'];
    if (preg_match('/win/i', $agent)) {
        if (preg_match('/nt 6.1/i', $agent)) {
            $OS = 'Windows 7';
        } else if (preg_match('/nt 6.2/i', $agent)) {
            $OS = 'Windows 8';
        } else if (preg_match('/nt 10.0/i', $agent)) {
            $OS = 'Windows 10';
        } else {
            $OS = 'Windows';
        }
    } elseif (preg_match('/mac/i', $agent)) {
        $OS = 'MAC';
    } elseif (preg_match('/linux/i', $agent)) {
        $OS = 'Linux';
    } elseif (preg_match('/unix/i', $agent)) {
        $OS = 'Unix';
    } elseif (preg_match('/bsd/i', $agent)) {
        $OS = 'BSD';
    } else {
        $OS = 'Other';
    }
    return $OS;
}

/**
 * 根据IP获取地址
 */
function getAddress($ip)
{
    $res = file_get_contents("http://ip.360.cn/IPQuery/ipquery?ip=" . $ip);
    $res = json_decode($res, 1);
    if ($res && $res['errno'] == 0) {
        return explode("\t", $res['data'])[0];
    } else {
        return '';
    }
}

/**
 * 下载服务器文件
 *
 * @param string $file 文件路径
 * @param string $name 下载名称
 * @param boolean $del 下载后删除
 * @return void
 */
function download($file, $name = '', $del = false)
{
    if (!file_exists($file)) {
        return resultArray([
            'error' => '文件不存在',
        ]);
    }
    // 仅允许下载 public 目录下文件
    $res = strpos(realpath($file), realpath('./public'));
    if ($res !== 0) {
        return resultArray([
            'error' => '文件路径错误',
        ]);
    }

    $fp = fopen($file, 'r');
    $size = filesize($file);

    //下载文件需要的头
    header("Content-type: application/octet-stream");
    header("Accept-Ranges: bytes");
    header('ResponseType: blob');
    header("Accept-Length: $size");
    $file_name = $name != '' ? $name : pathinfo($file, PATHINFO_BASENAME);
    // urlencode 处理中文乱码
    header("Content-Disposition:attachment; filename=" . urlencode($file_name));

    // 导出数据时  csv office Excel 需要添加bom头
    if (pathinfo($file, PATHINFO_EXTENSION) == 'csv') {
        echo "\xEF\xBB\xBF";    // UTF-8 BOM
    }

    $fileCount = 0;
    $fileUnit = 1024;
    while (!feof($fp) && $size - $fileCount > 0) {
        $fileContent = fread($fp, $fileUnit);
        echo $fileContent;
        $fileCount += $fileUnit;
    }
    fclose($fp);

    // 删除
    if ($del) @unlink($file);
    die();
}

/**
 * 导出数据为excel表格
 * @param $data    一个二维数组,结构如同从数据库查出来的数组
 * @param $title   excel的第一行标题,一个数组,如果为空则没有标题
 * @param $filename 下载的文件名
 * @param exportexcel($arr,array('id','账户','密码','昵称'),'文件名!');
 */
function exportexcel($data = array(), $title = array(), $filename = 'report')
{
    header("Content-type:application/octet-stream");
    header("Accept-Ranges:bytes");
    header("Content-type:application/vnd.ms-excel");
    header("Content-Disposition:attachment;filename=" . $filename . ".xls");
    header("Pragma: no-cache");
    header("Expires: 0");
    //导出xls 开始
    if (!empty($title)) {
        foreach ($title as $k => $v) {
            $title[$k] = iconv("UTF-8", "GB2312", $v);
        }
        $title = implode("\t", $title);
        echo "$title\n";
    }
    if (!empty($data)) {
        foreach ($data as $key => $val) {
            foreach ($val as $ck => $cv) {
                $data[$key][$ck] = iconv("UTF-8", "GB2312", $cv);
            }
            $data[$key] = implode("\t", $data[$key]);
        }
        echo implode("\n", $data);
    }
}


//根据数据库查询出来数组获取某个字段拼接字符串
function getFieldArray($array = array(), $field = '')
{
    if (is_array($array) && $field) {
        $ary = array();
        foreach ($array as $value) {
            $ary[] = $value[$field];
        }
        $str = implode(',', $ary);
        return $str;
    } else {
        return false;
    }
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
    //执行命令
    $output = curl_exec($ch);
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
    $curl = curl_init(); // 启动一个CURL会话
    curl_setopt($curl, CURLOPT_URL, $url); // 要访问的地址
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0); // 对认证证书来源的检查
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 1); // 从证书中检查SSL加密算法是否存在
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
        echo 'Errno' . curl_error($curl);//捕抓异常
    }
    curl_close($curl); // 关闭CURL会话
    return $res; // 返回数据，json格式
}
