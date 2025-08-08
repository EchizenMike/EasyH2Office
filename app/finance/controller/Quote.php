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

namespace app\finance\controller;

use app\base\BaseController;
use app\finance\model\Quote as QuoteModel;
use app\finance\validate\QuoteValidate;
use think\exception\ValidateException;
use think\facade\Db;
use think\facade\View;

class Quote extends BaseController
{
	/**
     * 构造函数
     */
	protected $model;
    public function __construct()
    {
		parent::__construct(); // 调用父类构造函数
        $this->model = new QuoteModel();
    }

    /**
    * 数据列表
    */
//    public function datalist()
//    {
//        $param = get_params();
////        echo "<script>alert(-1)</script>";
//        if (request()->isAjax()) {
//			$tab = isset($param['tab']) ? $param['tab'] : 0;
//			$uid=$this->uid;
//            $where = array();
//            $whereOr = array();
//			$where[]=['delete_time','=',0];
//			$where[]=['invoice_type','>',0];
//            if($tab == 0){
//				$auth = isAuthInvoice($uid);
//				if($auth == 0){
//					$whereOr[] = ['admin_id', '=', $this->uid];
//					$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_uids)")];
//					$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_history_uids)")];
//					$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_copy_uids)")];
//					$dids_a = get_leader_departments($uid);
//					$dids_b = get_role_departments($uid);
//					$dids = array_merge($dids_a, $dids_b);
//					if(!empty($dids)){
//						$whereOr[] = ['did','in',$dids];
//					}
//				}
//			}
//			if($tab == 1){
//				//我创建的
//				$where[] = ['admin_id', '=', $this->uid];
//			}
//			if($tab == 2){
//				//待我审核的
//				$where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_uids)")];
//			}
//			if($tab == 3){
//				//我已审核的
//				$where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_history_uids)")];
//			}
//			if($tab == 4){
//				//抄送给我的
//				$where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_copy_uids)")];
//			}
//			if($tab == 5){
//				//已开具的
//				$where[] = ['open_status', '=', 1];
//			}
//			if($tab == 6){
//				//已作废的
//				$where[] = ['open_status', '=', 2];
//			}
//			//按时间检索
//			if (!empty($param['diff_time'])) {
//				$diff_time =explode('~', $param['diff_time']);
//				$where[] = ['open_time', 'between', [strtotime(urldecode($diff_time[0])),strtotime(urldecode($diff_time[1].' 23:59:59'))]];
//			}
//            if (isset($param['open_status']) && $param['open_status'] != "") {
//                $where[] = ['open_status', '=', $param['open_status']];
//            }
//            if (isset($param['enter_status']) && $param['enter_status'] != "") {
//                $where[] = ['enter_status', '=', $param['enter_status']];
//            }
//			if (isset($param['check_status']) && $param['check_status'] != "") {
//                $where[] = ['check_status', '=', $param['check_status']];
//            }
//            $list = $this->model->datalist($param,$where,$whereOr);
//            return table_assign(0, '', $list);
//        }
//        else{
////            echo "<script>alert('ajax错误')</script>";
//            return view();
//        }
//    }
    public function datalist()
    {
        $param = get_params();

        if (request()->isAjax()) {
            $uid = $this->uid;
            $tab = $param['tab'] ?? 0;

            $where = [['delete_time', '=', 0]];
            $whereOr = [];

            switch ($tab) {
                case 1: // 我创建的
                    $where[] = ['admin_id', '=', $uid];
                    break;
                case 2: // 待我审批
                    $where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_uids)")];
                    break;
                case 3: // 我已审批
                    $where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_history_uids)")];
                    break;
                case 4: // 抄送给我
                    $where[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_copy_uids)")];
                    break;
                default: // 全部（带权限）
                    $auth = isAuthInvoice($uid);
//                    echo $auth;exit;
                    if ($auth == 0) {
                        $whereOr[] = ['admin_id', '=', $uid];
                        $whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_uids)")];
                        $whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_history_uids)")];
                        $whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}', check_copy_uids)")];
                        $dids_a = get_leader_departments($uid);
                        $dids_b = get_role_departments($uid);
                        $dids = array_merge($dids_a, $dids_b);
                        if (!empty($dids)) {
                            $whereOr[] = ['did', 'in', $dids];
                        }
                    }
                    break;
            }

            // 按时间区间筛选报价时间（quote_time）
//            if (!empty($param['diff_time'])) {
//                $diff = explode('~', $param['diff_time']);
//                $start = strtotime(trim($diff[0]));
//                $end = strtotime(trim($diff[1] . ' 23:59:59'));
//                $where[] = ['quote_time', 'between', [$start, $end]];
//            }
//
//            // 按开票类型、抬头类型等筛选
//            if (isset($param['invoice_type']) && $param['invoice_type'] !== '') {
//                $where[] = ['invoice_type', '=', $param['invoice_type']];
//            }
//            if (isset($param['types']) && $param['types'] !== '') {
//                $where[] = ['types', '=', $param['types']];
//            }

            $list = $this->model->datalist($param, $where, $whereOr);

            return table_assign(0, '', $list);
        }

        return view();
    }





    /**
    * 添加/编辑
    */
//    public function add()
//    {
//        $param = get_params();
//        if (request()->isAjax()) {
//            if ($param['types'] == 1) {
//                if (!$param['invoice_bank']) {
//                    return to_assign(1, '开户银行不能为空');
//                }
//                if (!$param['invoice_account']) {
//                    return to_assign(1, '银行账号不能为空');
//                }
//            }
//			$param['admin_id'] = $this->uid;
//			$param['did'] = $this->did;
//            if (!empty($param['id']) && $param['id'] > 0) {
//                try {
//                    validate(QuoteValidate::class)->scene('edit')->check($param);
//                } catch (ValidateException $e) {
//                    // 验证失败 输出错误信息
//                    return to_assign(1, $e->getError());
//                }
//				$this->model->edit($param);
//            } else {
//                try {
//                    validate(QuoteValidate::class)->scene('add')->check($param);
//                } catch (ValidateException $e) {
//                    // 验证失败 输出错误信息
//                    return to_assign(1, $e->getError());
//                }
//                $this->model->add($param);
//            }
//        }else{
//			$id = isset($param['id']) ? $param['id'] : 0;
//			if ($id>0) {
//				$detail = $this->model->getById($id);
//				View::assign('detail', $detail);
//				if(is_mobile()){
//					return view('qiye@/finance/add_invoice');
//				}
//				return view('edit');
//			}
//			if(is_mobile()){
//				return view('qiye@/finance/add_invoice');
//			}
//			return view();
//		}
//    }
    public function add()
    {
        $param = get_params();
        // 如果有 product_detail，手动转成 JSON 字符串保存
//        if (isset($param['product_detail']) && is_array($param['product_detail'])) {
//            $param['product_detail'] = json_encode($param['product_detail'], JSON_UNESCAPED_UNICODE);
////            echo "<script>alert('监测到detail')</script>";
//            echo "<script>alert('".addslashes(json_encode($param, JSON_UNESCAPED_UNICODE))."')</script>";
//        }else{
//            echo "<script>alert('".addslashes(json_encode($param, JSON_UNESCAPED_UNICODE))."')</script>";
////            exit;
//        }
        if (isset($param['product_detail']) && is_array($param['product_detail'])) {
            $param['product_detail'] = json_encode($param['product_detail'], JSON_UNESCAPED_UNICODE);
        }

        if (request()->isAjax()) {

            // 自动补充操作人
            $param['admin_id'] = $this->uid;
            $param['did'] = $this->did;

            // 判断新增 or 编辑
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(QuoteValidate::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    return to_assign(1, $e->getError());
                }
                $this->model->edit($param);
            } else {
                try {
                    validate(QuoteValidate::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    return to_assign(1, $e->getError());
                }
                $this->model->add($param);
            }

            return to_assign(0, '操作成功');
        } else {
            $id = isset($param['id']) ? $param['id'] : 0;
            if ($id > 0) {
                $detail = $this->model->getById($id);
                View::assign('detail', $detail);
                return is_mobile() ? view('qiye@/finance/add_quote') : view('edit');
            }
            return is_mobile() ? view('qiye@/finance/add_quote') : view();
        }
    }


    /**
    * 查看
    */
    public function view($id)
    {
        $quote_code = input('quote_code');
//        echo "这是 Quote 控制器"; exit;
        if ($id != '-1'){
            $detail = $this->model->getById($id);
        }else{
            $detail = $this->model->getByQuoteCode($quote_code);
        }

        if (!empty($detail)) {
			$detail['subject'] = Db::name('Enterprise')->where(['id' =>$detail['invoice_subject']])->value('title');
			$other_file_array = Db::name('File')->where('id','in',$detail['other_file_ids'])->select();
			$detail['other_file_array'] = $other_file_array;
			if($detail['open_status']>0){
				$detail['open_admin_name'] = Db::name('Admin')->where('id','=',$detail['open_admin_id'])->value('name');
			}
//            echo "这是 Quote 控制器".$other_file_array; exit;
            // 关键：将 product_detail 字段的 JSON 字符串转为数组
//            if (!empty($detail['product_detail']) && is_string($detail['product_detail'])) {
//                $detail['product_detail'] = json_decode($detail['product_detail'], true);
//            }


            View::assign('detail', $detail);
			View::assign('create_user', get_admin($detail['admin_id']));
			if(is_mobile()){
//				return view('qiye@/finance/view_invoice');
				return view('qiye@/finance/view_quote');
			}
            return view('quote/view_q'); // view改个名字，要不显示会出问题
        }
		else{
			return view(EEEOR_REPORTING,['code'=>404,'warning'=>'找不到页面']);
		}
    }


   /**
    * 删除
    */
    public function del()
    {
		$param = get_params();
		$id = isset($param['id']) ? $param['id'] : 0;
		if (request()->isDelete()) {
			$this->model->delById($id);
		} else {
            return to_assign(1, "错误的请求");
        }
    }

	//开票记录
    public function record()
    {
		$uid = $this->uid;
		$auth = isAuthInvoice($uid);
        if (request()->isAjax()) {
			$param = get_params();
			$tab = isset($param['tab']) ? $param['tab'] : 0;
			$where = [];
			$whereOr = [];
			$where[]=['delete_time','=',0];
			$where[]=['check_status','=',2];
			$where[]=['invoice_type','>',0];
			if($auth == 0){
				$dids_a = get_leader_departments($uid);
				$dids_b = get_role_departments($uid);
				$dids = array_merge($dids_a, $dids_b);
				if(!empty($dids)){
					$whereOr[] = ['did','in',$dids];
				}
			}
			if($tab == 0){
				//正常的
				$where[] = ['open_status', '<', 2];
			}
			if($tab == 1){
				//已作废的
				$where[] = ['open_status', '=', 2];
			}
			//按时间检索
			if (!empty($param['diff_time'])) {
				$diff_time =explode('~', $param['diff_time']);
				$where[] = ['open_time', 'between', [strtotime(urldecode($diff_time[0])),strtotime(urldecode($diff_time[1].' 23:59:59'))]];
			}
            if (isset($param['open_status']) && $param['open_status'] != "") {
                $where[] = ['open_status', '=', $param['open_status']];
            }
			$list = $this->model->datalist($param,$where,$whereOr);

			$amount = $this->model::where($where)->where(function ($query) use($whereOr) {
				if (!empty($whereOr)){
					$query->whereOr($whereOr);
				}
			})->sum('amount');
			$totalRow['amount'] = sprintf("%.2f",$amount);
            return table_assign(0, '', $list);
        } else {

			View::assign('authInvoice', $auth);
            return view();
        }
    }


   /**
    * 无发票回款列表
    */
    public function datalist_a()
    {
		$param = get_params();
        if (request()->isAjax()) {
			$uid=$this->uid;
            $where = array();
            $whereOr = array();
			$where[]=['delete_time','=',0];
			$where[]=['invoice_type','=',0];

			$whereOr[] = ['admin_id', '=', $this->uid];
			$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_uids)")];
			$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_history_uids)")];
			$whereOr[] = ['', 'exp', Db::raw("FIND_IN_SET('{$uid}',check_copy_uids)")];
			$auth = isAuthInvoice($uid);
			if($auth == 0){
				$dids_a = get_leader_departments($uid);
				$dids_b = get_role_departments($uid);
				$dids = array_merge($dids_a, $dids_b);
				if(!empty($dids)){
					$whereOr[] = ['did','in',$dids];
				}
			}
			//按时间检索
			if (!empty($param['diff_time'])) {
				$diff_time =explode('~', $param['diff_time']);
				$where[] = ['enter_time', 'between', [strtotime(urldecode($diff_time[0])),strtotime(urldecode($diff_time[1].' 23:59:59'))]];
			}
            if (isset($param['enter_status']) && $param['enter_status'] != "") {
                $where[] = ['enter_status', '=', $param['enter_status']];
            }
			if (isset($param['check_status']) && $param['check_status'] != "") {
                $where[] = ['check_status', '=', $param['check_status']];
            }
            $list = $this->model->datalist($param,$where,$whereOr);
            return table_assign(0, '', $list);
        }
        else{
			View::assign('auth', isAuthIncome($this->uid));
            return view();
        }
    }

    /**
    * 无发票添加/编辑
    */
    public function add_a()
    {
		$param = get_params();
        if (request()->isAjax()) {
			$param['admin_id'] = $this->uid;
			$param['did'] = $this->did;
            if (!empty($param['id']) && $param['id'] > 0) {
                try {
                    validate(QuoteValidate::class)->scene('edit')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
				$this->model->edit($param);
            } else {
                try {
                    validate(QuoteValidate::class)->scene('add')->check($param);
                } catch (ValidateException $e) {
                    // 验证失败 输出错误信息
                    return to_assign(1, $e->getError());
                }
                $this->model->add($param);
            }
        }else{
			$id = isset($param['id']) ? $param['id'] : 0;
			if ($id>0) {
				$detail = $this->model->getById($id);
				View::assign('detail', $detail);
				if(is_mobile()){
					return view('qiye@/finance/add_invoice_a');
				}
				return view('edit_a');
			}
			if(is_mobile()){
				return view('qiye@/finance/add_invoice_a');
			}
			return view();
		}
    }

    /**
    * 无发票查看
    */
    public function view_a($id)
    {
		$detail = $this->model->getById($id);
		if (!empty($detail)) {
			$detail['subject'] = Db::name('Enterprise')->where(['id' =>$detail['invoice_subject']])->value('title');
			$other_file_array = Db::name('File')->where('id','in',$detail['other_file_ids'])->select();
			$detail['other_file_array'] = $other_file_array;
			if($detail['open_status']>0){
				$detail['open_admin_name'] = Db::name('Admin')->where('id','=',$detail['open_admin_id'])->value('name');
			}
			View::assign('detail', $detail);
			View::assign('create_user', get_admin($detail['admin_id']));
			if(is_mobile()){
				return view('qiye@/finance/view_invoice_a');
			}
			return view();
		}
		else{
			return view(EEEOR_REPORTING,['code'=>404,'warning'=>'找不到页面']);
		}
    }

   /**
    * 删除
    */
    public function del_a($id)
    {
		if (request()->isDelete()) {
			$this->model->delById($id);
		} else {
            return to_assign(1, "错误的请求");
        }
    }
    /**
    * 生成报价单
    */
    // 数字转大写
    function numToRmbUpper($num)
    {
        $cnums = ['零','壹','贰','叁','肆','伍','陆','柒','捌','玖'];
        $units = ['','拾','佰','仟'];
        $sections = ['','万','亿','兆'];
        $decUnits = ['角','分'];

        $num = round($num, 2);
        $numStr = (string)$num;
        if (strpos($numStr, '.') !== false) {
            list($intPart, $decPart) = explode('.', $numStr);
        } else {
            $intPart = $numStr;
            $decPart = '';
        }

        $int = '';
        $intLen = strlen($intPart);
        $zero = false;
        $section = 0;

        while ($intLen > 0) {
            $sectionLen = ($intLen >= 4) ? 4 : $intLen;
            $start = $intLen - $sectionLen;
            $part = substr($intPart, $start, $sectionLen);
            $partResult = '';
            $zeroCount = 0;

            for ($i = 0; $i < $sectionLen; $i++) {
                $digit = (int)$part[$i];
                if ($digit === 0) {
                    $zeroCount++;
                } else {
                    if ($zeroCount > 0) {
                        $partResult .= '零';
                    }
                    $partResult .= $cnums[$digit] . $units[$sectionLen - $i - 1];
                    $zeroCount = 0;
                }
            }

            if ($partResult !== '') {
                $partResult .= $sections[$section];
            }

            $int = $partResult . $int;
            $section++;
            $intLen -= $sectionLen;
        }

        $int = $int === '' ? '零' : $int;
        $int .= '元';

        $dec = '';
        if ($decPart) {
            $len = strlen($decPart);
            for ($i = 0; $i < 2; $i++) {
                if ($i < $len) {
                    $n = (int)$decPart[$i];
                    if ($n !== 0) {
                        $dec .= $cnums[$n] . $decUnits[$i];
                    } else {
                        if ($i == 0 && (int)$decPart[1] != 0) {
                            $dec .= '零';
                        }
                    }
                }
            }
        }

        if ($dec === '') {
            $dec = '整';
        }

        return $int . $dec;
    }




    public function download()
    {
        $quote_code = input('quote_code');
        $checker = input('checker');
        // 解析checker参数，转换为PHP数组
        $checkList = json_decode($checker, true);
//        echo $checkList[0];exit();
        // 引入 TBS 和 OpenTBS
        include_once('/www/wwwroot/office/app/lib/opentbs/tbs_class.php');
        include_once('/www/wwwroot/office/app/lib/opentbs/tbs_plugin_opentbs.php');
        $TBS = new \clsTinyButStrong;
        $TBS->Plugin(TBS_INSTALL, OPENTBS_PLUGIN);

        $template ='/www/wwwroot/office/public/static/assets/temple/quote/temple.xlsx'; // 模板路径
        $TBS->LoadTemplate($template, OPENTBS_ALREADY_UTF8);


        // 1. 查询 quote 表
        $quote = Db::name('quote')->where('quote_code', $quote_code)->find();
        if (!$quote) {
            return json(['error' => '找不到对应的报价单']);
        }

        // 2. 查询 admin 表
        $admin = Db::name('admin')->where('id', $quote['admin_id'])->find();
        if (!$admin) {
            return json(['error' => '找不到对应的管理员']);
        }

        // 3. 查询 customer 表
        $customer = Db::name('customer')->where('name', $quote['customer_name'])->find();
        if (!$customer) {
            return json(['error' => '找不到对应的客户:'.$quote['customer_name']]);
        }

        // 3. 查询 customer_contract 表
        $customer_contact = Db::name('customer_contact')->where('cid', $customer['id'])->find();
        if (!$customer_contact) {
            return json(['error' => '找不到对应的客户资料']);
        }

        // 4.查询产品明细
        // 查询一条记录（或多条）并获取 product_detail 字段
        $rows = Db::name('quote')
            ->where('quote_code', $quote_code)
            ->select()
            ->toArray();

        $totalQuantity = 0;
        $newItems = [];

        foreach ($rows as $row) {
            $details = json_decode($row['product_detail'], true);

            foreach ($details as $item) {
                $newItems[] = [
                    'type'   => $item['product_type'],
                    'cooling_method'   => $item['cooling_method'],
                    'stack_type'   => $item['stack_type'],
                    'polar_metrials_and_system_type' => $item['polar_metrials_and_system_type'],
                    'power_rate' => $item['power_rate'],
//                    'model'  => $item['product_model'],
                    'qua'    => isset($item['quantity']) ? intval($item['quantity']) : 0, // quantity -> qua
                    'unit'   => $item['unit'],
                    'sprice' => $item['price'],
                    'aprice' => $item['total'],
                    'remark' => $item['remark']
                ];
            }
            

            if (is_array($details)) {
                foreach ($details as $item) {
                    if (isset($item['quantity']) && is_numeric($item['quantity'])) {
                        $totalQuantity += intval($item['quantity']);
                    }
                }
            }
        }
        




        // 模拟数据（你应从数据库传进来）
        $data = [
            'cus_name' =>  $quote['customer_name'],
            'quote_date' => date('Y年m月d日', $quote['create_time']),
            'email' => $admin['email'],
            'contract_name' => $admin['name'],
            'cus_contract_name' => $customer_contact['name'],
            'phone' => $customer_contact['mobile'],
            'cus_address' => $customer['address'],
            'cus_email' => $customer_contact['email'],
            'fax' => '12345678',
            'quote_code' => $quote_code,
            // 'stack_type' => '燃料电池堆',
            'remark' => $quote['remark'],
            'qu_total' => $totalQuantity,
            'money_total' => $quote['amount_total_with_tax'],
            'money_caps' => $this->numToRmbUpper(floatval($quote['amount_total_with_tax'])),
            'tax_rate' => $quote['tax_rate'] * 100 .'%',
            'price_without_tax' => $quote['amount_total_without_tax'],

            // 表格动态行数据
//            'item' => [
//                [
//                    'name' => '燃料电池电堆 A型',
//                    'model' => 'FCS-100',
//                    'qua' => 2,
//                    'unit' => '套',
//                    'sprice' => 500,
//                    'aprice' => 1000,
//                    'remark' => '主要用于轻型物流车',
//                ],
//                [
//                    'name' => '冷却系统',
//                    'model' => 'COOL-X',
//                    'qua' => 3,
//                    'unit' => '件',
//                    'sprice' => 150,
//                    'aprice' => 450,
//                    'remark' => '电堆配件',
//                ]
//            ],

            'item' => $newItems,

            'foot_date_1' => date('Y年m月d日', $quote['create_time']),
            'foot_date_2' => date('Y年m月d日', $quote['create_time'])
        ];
        

//        // 合并循环数据
        $TBS->MergeBlock('item', $data['item']);

        // 合并字段
        $TBS->MergeField('cus_name', $data['cus_name']);
        $TBS->MergeField('email', $data['email']);
        $TBS->MergeField('contract_name', $data['contract_name']);
        $TBS->MergeField('cus_address', $data['cus_address']);
        $TBS->MergeField('cus_email', $data['cus_email']);
        $TBS->MergeField('quote_date', $data['quote_date']);
        $TBS->MergeField('cus_contract_name', $data['cus_contract_name']);
        $TBS->MergeField('phone', $data['phone']);
        $TBS->MergeField('fax', $data['fax']);
        $TBS->MergeField('quote_code', $data['quote_code']);
        // $TBS->MergeField('stack_type', $data['stack_type']);
        $TBS->MergeField('remark', $data['remark']);
        $TBS->MergeField('qu_total', $data['qu_total']);
        $TBS->MergeField('money_total', $data['money_total']);
        $TBS->MergeField('money_caps', $data['money_caps']);
        $TBS->MergeField('tax_rate', $data['tax_rate']);
        $TBS->MergeField('price_without_tax', $data['price_without_tax']);
        $TBS->MergeField('foot_date_1', $data['foot_date_1']);
        $TBS->MergeField('foot_date_2', $data['foot_date_2']);
        // echo print_r($newItems);exit();
        // 调试
//        echo '<pre>';
//        print_r($data['item']);
//        echo '</pre>';
//        exit; // 结束程序，避免输出模板
        // 输出模板内容（XML），看看有没有被替换
//        echo htmlentities($TBS->Source);
//        exit();
        add_log('quote_export','10001',subject: '报价单');

//        $param['create_time'] = time();
//        $insertId = self::strict(false)->field(true)->insertGetId($param);
//        echo $insertId;exit;
//        add_log('add', $insertId, $param);
//        $param = get_params();
//        $users= Db::name('Admin')->field('id as from_uid')->where(['status' => 1])->column('id');
//        $insertId = Db::name('quote')->field('id')->where(['quote_code' => $quote_code]);
        $insertId = Db::name('quote')
            ->where(['quote_code' => $quote_code])
            ->value('id');

        $from_uid = Db::name('quote')
            ->where(['quote_code' => $quote_code])
            ->value('admin_id');

        $users = Db::name('admin')
            ->where('name', 'in', $checkList)
            ->column('id'); // 结果：['张钊源' => 1, '张顺' => 2]
//        echo print_r($users);exit();

        // 遍历接收人
//        if (is_array($checkList)){
//            foreach ($checkList as $item) {
//
//
//            }
//        }
        // 遍历每个item
        $msg=[
            'from_uid'=> $from_uid,//发送人
            'to_uids'=> $users,//接收人
            'template_id'=>'quote_export',//消息模板ID
            'content'=>[ //消息内容
                'create_time'=>date('Y-m-d H:i:s'),
                'title' => '有同事申请并下载了『(预）报价单』，请知晓。',
                'action_id'=> $insertId,
            ]
        ];
//        echo print_r($checkList);exit();
        event('SendMessage',$msg);


        // 下载
        $TBS->Show(OPENTBS_DOWNLOAD, '报价单_' . date('Ymd_His') . '.xlsx');
//        add_log('add', $insertId, $param);
//        $param = get_params();
//        echo  print_r($param);

        exit;
    }
}
