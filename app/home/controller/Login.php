<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\home\controller;

use app\home\validate\UserCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\Session;

class Login
{
    //登录
    public function index()
    {
        return View();
    }
    //提交登录
    public function login_submit()
    {
        $param = get_params();
        try {
            validate(UserCheck::class)->check($param);
        } catch (ValidateException $e) {
            // 验证失败 输出错误信息
            return to_assign(1, $e->getError());
        }

        $admin = Db::name('Admin')->where(['username' => $param['username']])->find();
        if (empty($admin)) {
            $admin = Db::name('Admin')->where(['mobile' => $param['username']])->find();
            if (empty($admin)) {
                return to_assign(1, '用户名或密码错误');
            }
        }
        $param['pwd'] = set_password($param['password'], $admin['salt']);
        if ($admin['pwd'] !== $param['pwd']) {
            return to_assign(1, '用户名或密码错误');
        }
        if ($admin['status'] != 1) {
            return to_assign(1, '该用户禁止登录,请与管理者联系');
        }
        $data = [
			'is_lock' => 0,
            'last_login_time' => time(),
            'last_login_ip' => request()->ip(),
            'login_num' => $admin['login_num'] + 1,
        ];
        Db::name('admin')->where(['id' => $admin['id']])->update($data);
        $session_admin = get_config('app.session_admin');
        Session::set($session_admin, $admin);
        $token = make_token();
        set_cache($token, $admin, 7200);
        $admin['token'] = $token;
        add_log('login', $admin['id'], $data);
        return to_assign(0, '登录成功', ['uid' => $admin['id']]);
    }

    //退出登录
    public function login_out()
    {
        $session_admin = get_config('app.session_admin');
        Session::delete($session_admin);
        return to_assign(0, "退出成功");
    }

	//锁屏
    public function lock()
    {
		$session_admin = get_config('app.session_admin');
		$admin= Session::get($session_admin);
		if (request()->isAjax()) {
			$param = get_params();
			if($param['lock_password'] == ''){
				return to_assign(1, '请输入登录密码解锁');
			}			
			if(empty($admin)){
				return to_assign(2, '登录超时，请重新登录');
			}
			$pwd = set_password($param['lock_password'], $admin['salt']);
			if ($admin['pwd'] !== $pwd) {
				return to_assign(1, '密码错误');
			}
			else{
				Db::name('admin')->where('id',$admin['id'])->update(['is_lock'=>0]);
				return to_assign(0, '解锁成功', ['uid' => $admin['id']]);
			}
        }
		Db::name('admin')->where('id',$admin['id'])->update(['is_lock'=>1]);
        return View();
    }
}
