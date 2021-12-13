<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */
/**
======================
 *模块数据获取公共文件
======================
 */
use think\facade\Cache;
use think\facade\Db;

//设置缓存
function set_cache($key, $value, $date = 86400)
{
    Cache::set($key, $value, $date);
}

//读取缓存
function get_cache($key)
{
    return Cache::get($key);
}

//清空缓存
function clear_cache($key)
{
    Cache::clear($key);
}

//读取系统配置
function get_system_config($name, $key = '')
{
    $config = [];
    if (get_cache('system_config' . $name)) {
        $config = get_cache('system_config' . $name);
    } else {
        $conf = Db::name('config')->where('name', $name)->find();
        if ($conf['content']) {
            $config = unserialize($conf['content']);
        }
        set_cache('system_config' . $name, $config);
    }
    if ($key == '') {
        return $config;
    } else {
        if ($config[$key]) {
            return $config[$key];
        }
    }
}

//获取指定管理员的信息
function get_admin($id)
{
    $admin = Db::name('Admin')
	->alias('a')
	->field('a.*,d.title as department,p.title as position')
	->leftJoin ('Department d ','d.id= a.did')
	->leftJoin ('Position p ','p.id= a.position_id')
	->where(['a.id' => $id])
	->cache(true,60)
	->find();
    $admin['last_login_time'] = empty($admin['last_login_time']) ? '-' : date('Y-m-d H:i', $admin['last_login_time']);
    return $admin;
}

//获取当前登录用户的信息
function get_login_admin($key = '')
{
    $session_admin = get_config('app.session_admin');
    if (\think\facade\Session::has($session_admin)) {
        $gougu_admin = \think\facade\Session::get($session_admin);
        $admin = get_admin($gougu_admin['id']);
        if (!empty($key)) {
            if (isset($admin[$key])) {
                return $admin[$key];
            } else {
                return '';
            }
        } else {
            return $admin;
        }
    } else {
        return '';
    }
}

//读取后台菜单列表
function get_admin_menu()
{
    $menu = Db::name('AdminMenu')->order('sort asc,id asc')->select()->toArray();
    return $menu;
}

//读取权限节点列表
function get_admin_rule()
{
    $rule = Db::name('AdminRule')->order('sort asc,id asc')->select()->toArray();
    return $rule;
}

//读取权限分组列表
function get_admin_group()
{
    $group = Db::name('AdminGroup')->order('id desc')->select()->toArray();
    return $group;
}

//读取指定权限分组详情
function get_admin_group_info($id)
{
    $group = Db::name('AdminGroup')->where(['id' => $id])->find();
    $group['rules'] = explode(',', $group['rules']);
    $group['menus'] = explode(',', $group['menus']);
    return $group;
}

//菜单父子关系排序，用于菜单
function get_admin_menus()
{
    $admin = get_login_admin();
    if (get_cache('menu' . $admin['id'])) {
        $list = get_cache('menu' . $admin['id']);
    } else {
        $adminGroup = Db::name('PositionGroup')->where(['pid' => $admin['position_id']])->column('group_id');
        $adminMenu = Db::name('AdminGroup')->where('id', 'in', $adminGroup)->column('menus');
        $adminMenus = [];
        foreach ($adminMenu as $k => $v) {
            $v = explode(',', $v);
            $adminMenus = array_merge($adminMenus, $v);
        }
        $menu = Db::name('AdminMenu')->where('id', 'in', $adminMenus)->order('sort asc')->select()->toArray();
        $list = list_to_tree($menu);
        Cache::tag('adminMenu')->set('menu' . $admin['id'], $list);
    }
    return $list;
}


/**
 * 节点权限判断
 * @return bool
 */
function check_auth($rule, $uid)
{
    $auth_list = Cache::get('RulesSrc' . $uid);
    if (!in_array($rule, $auth_list)) {
        return false;
    } else {
        return true;
    }
}

//读取部门列表
function get_department()
{
    $department = Db::name('Department')->where(['status' => 1])->select()->toArray();
    return $department;
}

//获取某部门的子部门id.$is_self时候包含自己
function get_department_son($did = 0, $is_self = 1)
{
    $department = get_department();
    $department_list = get_data_node($department, $did);
    $department_array = array_column($department_list, 'id');
    if ($is_self == 1) {
        //包括自己在内
        $department_array[] = $did;
    }
    return $department_array;
}

//读取关键字列表
function get_keywords()
{
    $keywords = Db::name('Keywords')->where(['status' => 1])->order('id desc')->select()->toArray();
	return $keywords;
}

//读取公告分类列表
function get_note_cate()
{
    $cate = Db::name('NoteCate')->order('id desc')->select()->toArray();
    return $cate;
}

//读取公告分类子分类ids
function get_note_son($id = 0, $is_self = 1)
{
    $note = get_note_cate();
    $note_list = get_data_node($note, $id);
    $note_array = array_column($note_list, 'id');
    if ($is_self == 1) {
        //包括自己在内
        $note_array[] = $id;
    }
    return $note_array;
}

//读取知识分类列表
function get_article_cate()
{
    $cate = Db::name('ArticleCate')->order('id desc')->select()->toArray();
    return $cate;
}

//读取知识分类子分类ids
function get_article_son($id = 0, $is_self = 1)
{
    $article = get_article_cate();
    $article_list = get_data_node($article, $id);
    $article_array = array_column($article_list, 'id');
    if ($is_self == 1) {
        //包括自己在内
        $article_array[] = $id;
    }
    return $article_array;
}

//读取开票主体
function get_invoice_subject()
{
    $subject = Db::name('InvoiceSubject')->where(['status' => 1])->order('id desc')->select()->toArray();
    return $subject;
}

//读取审核人
function get_check_user($type=1)
{
    $user = Db::name('Check')
    ->field('c.*,a.name as user')
    ->alias('c')
    ->join('admin a', 'a.id = c.uid', 'LEFT')
    ->where(['c.type'=>$type,'c.status' => 1])
    ->order('c.id desc')
    ->select()
    ->toArray();
    return $user;
}

/**
 * 根据附件表的id返回url地址
 * @param  [type] $id [description]
 */
function get_file($id)
{
    if ($id) {
        $geturl = Db::name("file")->where(['id' => $id])->find();
        if ($geturl['status'] == 1) {
            //审核通过
            //获取签名的URL
            $url = $geturl['filepath'];
            return $url;
        } elseif ($geturl['status'] == 0) {
            //待审核
            return '/static/home/images/none_pic.jpg';
        } else {
            //不通过
            return '/static/home/images/none_pic.jpg';
        }
    }
    return false;
}

/**
 * 发送站内信
 * @param  $user_id 接收人user_id
 * @param  $data 操作内容
 * @param  $sysMessage 1为系统消息
 * @param  $template 消息模板
 * @return
 */
function sendMessage($user_id, $template, $data=[])
{
    $content = get_config('message.template')[$template]['template'];
	foreach ($data as $key => $val) {
		$content = str_replace('{' . $key . '}', $val, $content);
	}
	if(isSet($data['from_uid'])){
		$content = str_replace('{from_user}', get_admin($data['from_uid'])['name'], $content);
	}
	$content = str_replace('{date}', date('Y-m-d'), $content);
		
    if (!$user_id) return false;
    if (!$content) return false;
    if (!is_array($user_id)) {
        $users[] = $user_id;
    } else {
        $users = $user_id;
    }
    $users = array_unique(array_filter($users));
	//组合要发的消息
	$send_data = [];
	foreach ($users as $key => $value) {
		$send_data[] = array(
			'to_uid' => $value,//接收人
			'action_id' => $data['action_id'],
			'title' => $data['title'],
			'content' => $content,
			'template' => $template,
			'module_name' => strtolower(app('http')->getName()),
			'controller_name' => strtolower(app('request')->controller()),
			'action_name' => strtolower(app('request')->action()),
			'send_time' => time(),
			'create_time' => time()
		);
	}
	$res = Db::name('Message')->strict(false)->field(true)->insertAll($send_data);
    return $res;
}

/**
 * 员工操作日志
 * @param string $type 操作类型 login add edit view delete
 * @param int    $param_id 操作类型
 * @param array  $param 提交的参数
 */
function add_log($type, $param_id = '', $param = [])
{
	$action = '未知操作';
	$type_action = get_config('log.type_action');
	if($type_action[$type]){
		$action = $type_action[$type];
	}
    if ($type == 'login') {
        $login_admin = Db::name('Admin')->where(array('id' => $param_id))->find();
    } else {
        $session_admin = get_config('app.session_admin');
        $login_admin = \think\facade\Session::get($session_admin);
    }
    $data = [];
    $data['uid'] = $login_admin['id'];
    $data['name'] = $login_admin['name'];
    $data['type'] = $type;
    $data['action'] = $action;
    $data['param_id'] = $param_id;
    $data['param'] = json_encode($param);
    $data['module'] = strtolower(app('http')->getName());
    $data['controller'] = strtolower(app('request')->controller());
    $data['function'] = strtolower(app('request')->action());
    $parameter = $data['module'] . '/' . $data['controller'] . '/' . $data['function'];
    $rule_menu = Db::name('AdminRule')->where(array('src' => $parameter))->find();
	if($rule_menu){
		$data['title'] = $rule_menu['title'];
		$data['subject'] = $rule_menu['name'];
	}
	else{
		$data['title'] = '';
		$data['subject'] ='系统';
	}
    $content = $login_admin['name'] . '在' . date('Y-m-d H:i:s') . $data['action'] . '了' . $data['subject'];
    $data['content'] = $content;
    $data['ip'] = app('request')->ip();
    $data['create_time'] = time();
    Db::name('AdminLog')->strict(false)->field(true)->insert($data);
}

/**
 * 邮件发送
 * @param $to    接收人
 * @param string $subject 邮件标题
 * @param string $content 邮件内容(html模板渲染后的内容)
 * @throws Exception
 * @throws phpmailerException
 */
function send_email($to, $subject = '', $content = '')
{
    $mail = new PHPMailer\PHPMailer\PHPMailer();
    $email_config = Db::name('config')->where('name', 'email')->find();
    $config = unserialize($email_config['content']);

    $mail->CharSet = 'UTF-8'; //设定邮件编码，默认ISO-8859-1，如果发中文此项必须设置，否则乱码
    $mail->isSMTP();
    $mail->SMTPDebug = 0;

    //调试输出格式
    //$mail->Debugoutput = 'html';
    //smtp服务器
    $mail->Host = $config['smtp'];
    //端口 - likely to be 25, 465 or 587
    $mail->Port = $config['smtp_port'];
    if ($mail->Port == '465') {
        $mail->SMTPSecure = 'ssl'; // 使用安全协议
    }
    //Whether to use SMTP authentication
    $mail->SMTPAuth = true;
    //发送邮箱
    $mail->Username = $config['smtp_user'];
    //密码
    $mail->Password = $config['smtp_pwd'];
    //Set who the message is to be sent from
    $mail->setFrom($config['email'], $config['from']);
    //回复地址
    //$mail->addReplyTo('replyto@example.com', 'First Last');
    //接收邮件方
    if (is_array($to)) {
        foreach ($to as $v) {
            $mail->addAddress($v);
        }
    } else {
        $mail->addAddress($to);
    }

    $mail->isHTML(true); // send as HTML
    //标题
    $mail->Subject = $subject;
    //HTML内容转换
    $mail->msgHTML($content);
    $status = $mail->send();
    if ($status) {
        return true;
    } else {
        //  echo "Mailer Error: ".$mail->ErrorInfo;// 输出错误信息
        //  die;
        return false;
    }
}
