<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */

declare (strict_types = 1);

namespace app\customer\controller;

use app\base\BaseController;
use app\customer\model\Customer as CustomerList;
use app\customer\validate\CustomerCheck;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Index extends BaseController
{
    public function index()
    {
        if (request()->isAjax()) {
            $param = get_params();
			$tab = isset($param['tab']) ? $param['tab'] : 0;
            $where = array();
            $whereOr = array();
            if (!empty($param['keywords'])) {
                $where[] = ['a.id|a.name', 'like', '%' . $param['keywords'] . '%'];
            }
			if (!empty($param['status'])) {
                $where[] = ['a.status', '=', $param['status']];
            }
			if (!empty($param['grade_id'])) {
                $where[] = ['a.grade_id', '=', $param['grade_id']];
            }
			if (!empty($param['source_id'])) {
                $where[] = ['a.source_id', '=', $param['source_id']];
            }
			if (!empty($param['type'])) {
                $where[] = ['a.intent_status', '=', $param['type']];
            }
            $where[] = ['a.delete_time', '=', 0];
			
			$uid = $this->uid;
			$auth = isAuth($uid,'customer_admin');
			if (!empty($param['uid']) && $auth == 1) {
				$where[] =['a.belong_uid', '=', $param['uid']];	
			}
			else{
				$dids = get_department_role($uid);
				if($auth == 0){
					if($tab == 1){
						$whereOr[] =['a.belong_uid', '=', $uid];
					}
					else if($tab == 2){
						if(!empty($dids)){
							$whereOr[] =['a.belong_did', 'in', $dids];
						}
						else{
							$whereOr[] =['a.belong_did', '=', 0];
							$where[] =['a.belong_uid', '>', 0];
						}
					}
					else if($tab == 3){
						$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',a.share_ids)")];
					}
					else{
						$whereOr[] =['a.belong_uid', '=', $uid];	
						if(!empty($dids)){
							$whereOr[] =['a.belong_did', 'in', $dids];
						}			
						$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',a.share_ids)")];
					}
				}
				else if($auth ==1 ){
					if($tab == 1){
						$whereOr[] =['a.belong_uid', '=', $uid];
					}
					else if($tab == 2){
						if(!empty($dids)){
							$whereOr[] =['a.belong_did', 'in', $dids];
						}
						else{
							$whereOr[] =['a.belong_did', '=', 0];
							$where[] =['a.belong_uid', '>', 0];
						}
					}
					else if($tab == 3){
						$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',a.share_ids)")];
					}
					else{
						$whereOr[] =['a.belong_uid', '>', 0];
					}
				}
			}
			
            $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
            $content = CustomerList::where($where)
				->where(function ($query) use($whereOr) {
					$query->whereOr($whereOr);
				})
                ->field('a.*,d.title as belong_department,g.title as grade,s.title as source,i.title as industry')
                ->alias('a')
                ->join('customer_source s', 'a.source_id = s.id')
                ->join('customer_grade g', 'a.grade_id = g.id')
                ->join('industry i', 'a.industry_id = i.id')
                ->join('department d', 'a.belong_did = d.id','LEFT')
                ->order('a.create_time desc')
                ->paginate($rows, false, ['query' => $param])
				->each(function ($item, $key) {
                    $item->belong_name = Db::name('Admin')->where(['id' => $item->belong_uid])->value('name');
					$item->create_time = date('Y-m-d H:i', $item->create_time);
					if($item->update_time == 0){
						$item->update_time='-';
					}
					else{
						$item->update_time = date('Y-m-d H:i', $item->update_time);
					}
                    $item->intent_status_name = CustomerList::$IntentStatus[(int) $item->intent_status];
                    $item->status_name = CustomerList::$Status[(int) $item->status];
					$contact = Db::name('CustomerContact')->where(['is_default'=>1,'cid' => $item->id])->find();
					if(!empty($contact)){
						$item->user = $contact['name'];
						$item->mobile = $contact['mobile'];
						$item->qq = $contact['qq'];
						$item->wechat = $contact['wechat'];
					}
					
					if($item->services_id == 0){
						$item->services_name = '-';
					}
					else{
						$item->services_name = Db::name('Services')->where(['id' => $item->services_id])->value('title');
					}
				});
            return table_assign(0, '', $content);
        } else {
			$uid = $this->uid;
			$auth = isAuth($uid,'customer_admin');
			View::assign('auth', $auth);
            return view();
        }
    }
	
	//公海客户
    public function sea()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            if (!empty($param['keywords'])) {
                $where[] = ['a.id|a.name', 'like', '%' . $param['keywords'] . '%'];
            }
			if (!empty($param['status'])) {
                $where[] = ['a.status', '=', $param['status']];
            }
			if (!empty($param['industry_id'])) {
                $where[] = ['a.industry_id', '=', $param['industry_id']];
            }
			if (!empty($param['source_id'])) {
                $where[] = ['a.source_id', '=', $param['source_id']];
            }
            $where[] = ['a.delete_time', '=', 0];
            $where[] = ['a.belong_uid', '=', 0];
			
            $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
            $content = CustomerList::where($where)
                ->field('a.*,d.title as belong_department,g.title as grade,s.title as source,i.title as industry')
                ->alias('a')
                ->join('customer_source s', 'a.source_id = s.id')
                ->join('customer_grade g', 'a.grade_id = g.id')
                ->join('industry i', 'a.industry_id = i.id')
                ->join('department d', 'a.belong_did = d.id','LEFT')
                ->order('a.create_time desc')
                ->paginate($rows, false, ['query' => $param])
				->each(function ($item, $key) {
                    $item->belong_name = Db::name('Admin')->where(['id' => $item->belong_uid])->value('name');
                    $item->create_time = date('Y-m-d H:i', $item->create_time);
					if($item->update_time == 0){
						$item->update_time='-';
					}
					else{
						$item->update_time = date('Y-m-d H:i', $item->update_time);
					}
                    $item->intent_status_name = CustomerList::$IntentStatus[(int) $item->intent_status];
                    $item->status_name = CustomerList::$Status[(int) $item->status];
					$contact = Db::name('CustomerContact')->where(['is_default'=>1,'cid' => $item->id])->find();
					if(!empty($contact)){
						$item->user = $contact['name'];
						$item->mobile = $contact['mobile'];
						$item->qq = $contact['qq'];
						$item->wechat = $contact['wechat'];
					}
					
					if($item->services_id == 0){
						$item->services_name = '-';
					}
					else{
						$item->services_name = Db::name('Services')->where(['id' => $item->services_id])->value('title');
					}
				});
            return table_assign(0, '', $content);
        } else {
            return view();
        }
    }
	
	//移入公海
	public function to_sea()
    {
		if (request()->isAjax()) {
			$id = get_params("id");
			$uid = $this->uid;
			//是否有权限
			$customer = customer_auth($uid,$id,1,1);
			$data['id'] = $id;
			$data['belong_uid'] = 0;
			$data['belong_did'] = 0;
			$data['belong_time'] = 0;
			if (Db::name('Customer')->update($data) !== false) {
				add_log('tosea', $id);
				$log_data = array(
					'field' => 'belong',
					'action' => 'tosea',
					'type' => 0,
					'customer_id' => $data['id'],
					'admin_id' => $this->uid,
					'create_time' => time(),
				);
				Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
				return to_assign(0, "操作成功");
			} else {
				return to_assign(1, "操作失败");
			}
		} else {
            return to_assign(1, "错误的请求");
        }
	}
	
	//废池客户
    public function trash()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            if (!empty($param['keywords'])) {
                $where[] = ['a.id|a.name|c.title', 'like', '%' . $param['keywords'] . '%'];
            }
			if (!empty($param['status'])) {
                $where[] = ['a.status', '=', $param['status']];
            }
            $where[] = ['a.delete_time', '>', 0];
            $where[] = ['a.belong_uid', '=', 0];
			
            $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
            $content = CustomerList::where($where)
                ->field('a.*,d.title as belong_department,g.title as grade,s.title as source,i.title as industry')
                ->alias('a')
                ->join('customer_source s', 'a.source_id = s.id')
                ->join('customer_grade g', 'a.grade_id = g.id')
                ->join('industry i', 'a.industry_id = i.id')
                ->join('department d', 'a.belong_did = d.id','LEFT')
                ->order('a.create_time desc')
                ->paginate($rows, false, ['query' => $param])
				->each(function ($item, $key) {
                    $item->belong_name = Db::name('Admin')->where(['id' => $item->belong_uid])->value('name');
                    $item->create_time = date('Y-m-d H:i', $item->create_time);
					if($item->update_time == 0){
						$item->update_time='-';
					}
					else{
						$item->update_time = date('Y-m-d H:i', $item->update_time);
					}
                    $item->intent_status_name = CustomerList::$IntentStatus[(int) $item->intent_status];
                    $item->status_name = CustomerList::$Status[(int) $item->status];
					$contact = Db::name('CustomerContact')->where(['is_default'=>1,'cid' => $item->id])->find();
					if(!empty($contact)){
						$item->user = $contact['name'];
						$item->mobile = $contact['mobile'];
						$item->qq = $contact['qq'];
						$item->wechat = $contact['wechat'];
					}
					
					if($item->services_id == 0){
						$item->services_name = '-';
					}
					else{
						$item->services_name = Db::name('Services')->where(['id' => $item->services_id])->value('title');
					}
				});
            return table_assign(0, '', $content);
        } else {
            return view();
        }
    }
	
	//抢客宝
    public function rush()
    {
        if (request()->isAjax()) {
            $param = get_params();
            $where = array();
            $where[] = ['a.delete_time', '=', 0];
            $where[] = ['a.belong_uid', '=', 0];
            $content = CustomerList::where($where)
                ->field('a.*,d.title as belong_department,g.title as grade,s.title as source,i.title as industry')
                ->alias('a')
                ->join('customer_source s', 'a.source_id = s.id')
                ->join('customer_grade g', 'a.grade_id = g.id')
                ->join('industry i', 'a.industry_id = i.id')
                ->join('department d', 'a.belong_did = d.id','LEFT')
                ->orderRaw('rand()')
                ->limit(10)
				->paginate()
				->each(function ($item, $key) {
                    $item->create_time = date('Y-m-d H:i:s', (int) $item->create_time);
					$contact = Db::name('CustomerContact')->where(['is_default'=>1,'cid' => $item->id])->find();
					if(!empty($contact)){
						$item->user = $contact['name'];
						$item->mobile = $contact['mobile'];
						$item->qq = $contact['qq'];
						$item->wechat = $contact['wechat'];
					}					
					if($item->services_id == 0){
						$item->services_name = '-';
					}
					else{
						$item->services_name = Db::name('Services')->where(['id' => $item->services_id])->value('title');
					}
				});
            return table_assign(0, '', $content);
        } else {
			$time = strtotime(date('Y-m-d')." 00:00:00");
			$max_num = Db::name('DataAuth')->where('name','customer_admin')->value('expected_1');
			$count = Db::name('Customer')->where([['belong_time','>',$time],['belong_uid','=',$this->uid]])->count();
			View::assign('max_num', $max_num);
			View::assign('count', $count);
            return view();
        }
    }

    //添加&&编辑
    public function add()
    {
        $param = get_params();
        if (request()->isAjax()) {
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(CustomerCheck::class)->scene($param['scene'])->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
				$customer = customer_auth($this->uid,$param['id'],1);
                $param['update_time'] = time();
				$res = customerList::strict(false)->field(true)->update($param);
				if ($res) {
					add_log('edit', $param['id'], $param);
					to_log($this->uid,0,$param,$customer);
					return to_assign();
				} else {
					return to_assign(1, '操作失败');
				}
            } else {
                try {
                    validate(CustomerCheck::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $param['create_time'] = time();
                $param['admin_id'] = $this->uid;
				$cid = CustomerList::strict(false)->field(true)->insertGetId($param);
				
				$contact = [
					'name' => $param['c_name'],
					'mobile' => $param['c_mobile'],
					'sex' => $param['c_sex'],
					'qq' => $param['c_qq'],
					'wechat' => $param['c_wechat'],
					'email' => $param['c_email'],
					'cid' => $cid,
					'is_default' => 1,
					'create_time' => time(),
					'admin_id' => $this->uid
				];
				Db::name('CustomerContact')->strict(false)->field(true)->insert($contact);
				if ($cid) {
					add_log('add', $cid, $param);
					$log_data = array(
						'field' => 'new',
						'action' => 'add',
						'type' => 0,
						'customer_id' => $cid,
						'admin_id' => $param['admin_id'],
						'create_time' => time(),
					);
					Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
					return to_assign();
				} else {
					return to_assign(1, '操作失败');
				}                
            }
        } else {
			if (!empty($param['id']) && $param['id'] > 0) {
				$sea = isset($param['sea']) ? $param['sea'] : 0;
				//查看权限判断
				$customer = customer_auth($this->uid,$param['id']);
				$detail = (new CustomerList())->detail($param['id']);
				View::assign('sea', $sea);
				View::assign('detail', $detail);
				return view('edit');
			}
			else{
				$sea = isset($param['sea']) ? $param['sea'] : 0;
				View::assign('sea', $sea);
				View::assign('userinfo', get_admin($this->uid));
				return view();
			}
        }
    }

    //查看
    public function view()
    {
        $id = get_params("id");
		//查看权限判断
		$customer = customer_auth($this->uid,$id);
		
        $detail = (new CustomerList())->detail($id);				
		$contact = Db::name('CustomerContact')->where(['is_default'=>1,'cid'=>$id])->find();
		//是否是客户管理员
		$auth = isAuth($this->uid,'customer_admin');
        View::assign('auth', $auth);
        View::assign('contact', $contact);
        View::assign('detail', $detail);
        return view();
    }
	
	//获取客户
	public function get()
    {
		if (request()->isAjax()) {
			$id = get_params("id");
			$time = strtotime(date('Y-m-d')." 00:00:00");
			$max_num = Db::name('DataAuth')->where('name','customer_admin')->value('expected_1');
			$count = Db::name('Customer')->where([['belong_time','>',$time],['belong_uid','=',$this->uid]])->count();
			if($count>=$max_num){
				return to_assign(1, "今日领取客户数已到达上限，请明天再来领取");
			}
			$data['id'] = $id;
			$data['belong_uid'] = $this->uid;
			$data['belong_did'] = $this->did;
			$data['belong_time'] = time();
			if (Db::name('Customer')->update($data) !== false) {
				add_log('tosea', $id);
				$log_data = array(
					'field' => 'belong',
					'action' => 'get',
					'type' => 0,
					'customer_id' => $data['id'],
					'admin_id' => $this->uid,
					'create_time' => time(),
				);
				Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
				return to_assign(0, "操作成功");
			} else {
				return to_assign(1, "操作失败");
			}
		} else {
            return to_assign(1, "错误的请求");
        }
	}	
	
	//客户移入废弃池
    public function to_trash()
    {
		if (request()->isAjax()) {
			$params = get_params();			
			$data['id'] = $params['id'];
			$log_data = array(
				'field' => 'del',
				'action' => 'delete',
				'type' => 0,
				'customer_id' => $params['id'],
				'admin_id' => $this->uid,
				'create_time' => time(),
			);
			$data['delete_time'] = time();
			$log_data['action'] = 'totrash';
			if (Db::name('Customer')->update($data) !== false) {
				add_log('totrash', $params['id']);
				Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
				return to_assign();
			} else {
				return to_assign(1, "操作失败");
			}
		} else {
            return to_assign(1, "错误的请求");
        }
    }
	
	//还原客户
    public function revert()
    {
		if (request()->isAjax()) {
			$params = get_params();		
			$data['id'] = $params['id'];
			$data['delete_time'] = 0;
			if (Db::name('Customer')->update($data) !== false) {
				add_log('recovery', $params['id']);
				$log_data = array(
					'field' => 'del',
					'action' => 'recovery',
					'type' => 0,
					'customer_id' => $params['id'],
					'admin_id' => $this->uid,
					'create_time' => time(),
				);
				Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
				return to_assign();
			} else {
				return to_assign(1, "操作失败");
			}
		} else {
            return to_assign(1, "错误的请求");
        }
    }
	
	//彻底删除客户
    public function delete()
    {
		if (request()->isDelete()) {
			$params = get_params();
			//是否是客户管理员
			$auth = isAuth($this->uid,'customer_admin');
			if($auth==0){
				return to_assign(1, "只有客户管理员才有权限操作");
			}			
			$data['id'] = $params['id'];
			$data['delete_time'] = -1;
			$log_data = array(
				'field' => 'del',
				'action' => 'delete',
				'type' => 0,
				'customer_id' => $params['id'],
				'admin_id' => $this->uid,
				'create_time' => time()
			);
			if (Db::name('Customer')->update($data) !== false) {
				add_log('delete', $params['id']);
				Db::name('CustomerLog')->strict(false)->field(true)->insert($log_data);
				return to_assign();
			} else {
				return to_assign(1, "操作失败");
			}
		} else {
            return to_assign(1, "错误的请求");
        }
    }


}
