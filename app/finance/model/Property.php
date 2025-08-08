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

namespace app\finance\model;
use think\model;
use think\facade\Db;
class Property extends Model
{
    protected $table = 'oa_property'; // ✅ 添加这一行 临时复用原来的表
     
	//资产处置模式
	public static $property_source = ['','普通销售','借出','出租','赠予','其他'];
	
	//资产生产状态
	public static $property_status = ['正常生产','停产'];
    /**
    * 获取分页列表
    * @param $where
    * @param $param
    */
//    public function datalist($where, $param)
//    {
//		$rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
//		$order = empty($param['order']) ? 'p.id desc' : $param['order'];
//        try {
//            $list = self::where($where)
//				->field('p.*,pc.title as cate,pb.title as brand,pu.title as unit,u.name as create_name')
//				->alias('p')
//				->join('PropertyCate pc', 'pc.id = p.cate_id', 'left')
//				->join('PropertyBrand pb', 'pb.id = p.brand_id', 'left')
//				->join('PropertyUnit pu', 'pu.id = p.unit_id', 'left')
//				->join('Admin u', 'u.id = p.admin_id', 'left')
//				->order($order)
//				->paginate(['list_rows'=> $rows])
//				->each(function ($item, $key){
//					$item->update_time_str = '-';
//					$item->update_name = '-';
//					if(!empty($item->update_time)){
//						$item->update_time_str = $item->update_time;
//						$item->update_name = Db::name('Admin')->where('id',$item->update_id)->value('name');
//					}
//					$item->status_str = self::$property_status[$item->status];
//					$item->source_str = self::$property_source[$item->source];
//					$item->create_time = to_date($item->create_time);
//					$item->update_time_str = to_date($item->update_time);
//				});
//			return $list;
//        } catch(\Exception $e) {
//            return ['code' => 1, 'data' => [], 'msg' => $e->getMessage()];
//        }
//    }
    public function datalist($where, $param)
    {

        $rows = empty($param['limit']) ? get_config('app.page_size') : $param['limit'];
        $order = empty($param['order']) ? 'p.id desc' : $param['order'];
        // 从Cookie中获取用户名
        $username = $_COOKIE['username'] ?? '';


        try {
            // Step 1: 获取用户名对应的 did（假设传入的用户名在 $param['username'] 中）
            $did = 0;
//            if (!empty($username)) {
//                echo "<script>alert('登录成功')</script>";
//                $sql = Db::name('oa_admin')->where('username', $username)->buildSql();
//                error_log("执行的 SQL: $sql");
////                $did = Db::name('oa_admin')->where('username', $username)->value('did');
////                error_log("登录成功，用户名: $username, 部门ID: " . var_export($did, true));
//            }else{
//                error_log('参数内容：' . print_r($username, true));
//            }
            if (!empty($username)) {
                error_log("登录成功，准备查询 did");
                try {
                    $did = Db::name('admin')->where('username', $username)->value('did');

                    if ($did !== null) {
                        error_log("查询成功，用户名: $username, 部门ID: " . var_export($did, true));
                    } else {
                        error_log("查询失败：用户名 $username 未查询到 did");
                    }
                } catch (\Throwable $e) {
                    error_log("数据库查询异常：" . $e->getMessage());
                }
            } else {
                error_log("username 参数为空：" . var_export($username, true));
            }



            // Step 2: 添加 FIND_IN_SET 条件
            $query = self::where($where)
                ->alias('p')
                ->field('p.*, pc.title as cate, pb.title as brand, pu.title as unit, u.name as create_name')
                ->join('PropertyCate pc', 'pc.id = p.cate_id', 'left')
                ->join('PropertyBrand pb', 'pb.id = p.brand_id', 'left')
                ->join('PropertyUnit pu', 'pu.id = p.unit_id', 'left')
                ->join('Admin u', 'u.id = p.admin_id', 'left')
                ->order($order);
//            $data = $query->select();  // 或 ->all()，根据 ThinkPHP 版本
//            error_log(print_r($data, true));  // 输出结果到日志
            if ($did!=1) { //如果是管理员账户(did==1)则匹配所有资产，如果非管理员账户，则匹配对应部门资产
                error_log("匹配对应部门的资产");
                $query = $query->whereRaw("FIND_IN_SET($did, p.user_dids)");

                $sql = $query->buildSql();
                error_log("生成的 SQL：$sql");
            }

            // Step 3: 分页 + 每条记录附加字段
            $list = $query->paginate(['list_rows' => $rows])
                ->each(function ($item, $key) {
                    $item->update_time_str = '-';
                    $item->update_name = '-';
                    if (!empty($item->update_time)) {
                        $item->update_time_str = to_date($item->update_time);
                        $item->update_name = Db::name('Admin')->where('id', $item->update_id)->value('name');
                    }
                    $item->status_str = self::$property_status[$item->status];
                    $item->source_str = self::$property_source[$item->source];
                    $item->create_time = to_date($item->create_time);
                    $item->update_time_str = to_date($item->update_time);
                });

            return $list;


        } catch (\Exception $e) {
            return ['code' => 1, 'data' => [], 'msg' => $e->getMessage()];
        }
    }


    /**
    * 添加数据
    * @param $param
    */
    public function add($param)
    {
		$insertId = 0;
        try {
			$param['create_time'] = time();
			$insertId = self::strict(false)->field(true)->insertGetId($param);
			add_log('add', $insertId, $param);
        } catch(\Exception $e) {
			return to_assign(1, '操作失败，原因：'.$e->getMessage());
        }
		return to_assign(0,'操作成功',['aid'=>$insertId]);
    }

    /**
    * 编辑信息
    * @param $param
    */
    public function edit($param)
    {
        try {
            $param['update_time'] = time();
            self::where('id', $param['id'])->strict(false)->field(true)->update($param);
			add_log('edit', $param['id'], $param);
        } catch(\Exception $e) {
			return to_assign(1, '操作失败，原因：'.$e->getMessage());
        }
		return to_assign();
    }	

    /**
    * 根据id获取信息
    * @param $id
    */
    public function getById($id)
    {
        $info = self::find($id);
		$info['status_str'] = self::$property_status[$info['status']];
		$info['source_str'] = self::$property_source[$info['source']];
		return $info;
    }

    /**
    * 删除信息
    * @param $id
    * @param $type
    * @return array
    */
    public function delById($id,$type=0)
    {
		if($type==0){
			//逻辑删除
			try {
				$param['delete_time'] = time();
				self::where('id', $id)->update(['delete_time'=>time()]);
				add_log('delete', $id);
			} catch(\Exception $e) {
				return to_assign(1, '操作失败，原因：'.$e->getMessage());
			}
		}
		else{
			//物理删除
			try {
				self::destroy($id);
				add_log('delete', $id);
			} catch(\Exception $e) {
				return to_assign(1, '操作失败，原因：'.$e->getMessage());
			}
		}
		return to_assign();
    }
}
