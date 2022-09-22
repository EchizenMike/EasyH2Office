<?php
/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-3.0
 * @link https://www.gougucms.com
 */
declare (strict_types = 1);
namespace app\api\controller;

use app\api\BaseController;
use think\facade\Db;
use app\user\model\Admin;
use avatars\MDAvatars;
use Overtrue\Pinyin\Pinyin;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Shared\Date as Shared;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;


class Import extends BaseController
{
    //生成头像
    public function to_avatars($char)
    {
        $defaultData = array('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N',
            'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'S', 'Y', 'Z',
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
            '零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖', '拾',
            '一', '二', '三', '四', '五', '六', '七', '八', '九', '十');
        if (isset($char)) {
            $Char = $char;
        } else {
            $Char = $defaultData[mt_rand(0, count($defaultData) - 1)];
        }
        $OutputSize = min(512, empty($_GET['size']) ? 36 : intval($_GET['size']));

        $Avatar = new MDAvatars($Char, 256, 1);
        $avatar_name = '/avatars/avatar_256_' . set_salt(10) . time() . '.png';
        $path = get_config('filesystem.disks.public.url') . $avatar_name;
        $res = $Avatar->Save('.' . $path, 256);
        $Avatar->Free();
        return $path;
    }
	
    //登录名校验
    public function check_name($name,$arr)
    {
        if(in_array($name,$arr)){
			$name = $this->check_name($name.'1',$arr);
		}
		return $name;       
    }
	
	//导入员工
	public function import_admin(){
        // 获取表单上传文件
        $file[]= request()->file('file');
		if($this->uid>1){
			return to_assign(1,'该操作只能是超级管理员有权限操作');
		}
        try {
            // 验证文件大小，名称等是否正确
            validate(['file' => 'filesize:51200|fileExt:xls,xlsx'])->check($file);
			// 日期前綴
			 $dataPath = date('Ym');
			 $md5 = $file[0]->hash('md5');
			 $savename = \think\facade\Filesystem::disk('public')->putFile($dataPath, $file[0], function () use ($md5) {
				 return $md5;
			 });
            $fileExtendName = substr(strrchr($savename, '.'), 1);
            // 有Xls和Xlsx格式两种
            if ($fileExtendName == 'xlsx') {
                $objReader = IOFactory::createReader('Xlsx');
            } else {
                $objReader = IOFactory::createReader('Xls');
            }
            $objReader->setReadDataOnly(TRUE);
			$path = get_config('filesystem.disks.public.url');
            // 读取文件，tp6默认上传的文件，在runtime的相应目录下，可根据实际情况自己更改
            $objPHPExcel = $objReader->load('.'.$path . '/' .$savename);
            //$objPHPExcel = $objReader->load('./storage/202209/d11544d20b3ca1c1a5f8ce799c3b2433.xlsx');
            $sheet = $objPHPExcel->getSheet(0);   //excel中的第一张sheet
            $highestRow = $sheet->getHighestRow();       // 取得总行数
            $highestColumn = $sheet->getHighestColumn();   // 取得总列数
            Coordinate::columnIndexFromString($highestColumn);
            $lines = $highestRow - 1;
            if ($lines <= 0) {
				return to_assign(1, '数据不能为空');
                exit();
            }
			$sex_array=['未知','男','女'];
			$type_array=['未知','正式','试用','实习'];
			$mobile_array = Db::name('Admin')->where([['status','>=',0]])->column('mobile');
			$email_array = Db::name('Admin')->where([['status','>=',0]])->column('email');
			$username_array = Db::name('Admin')->where([['status','>=',0]])->column('username');
			$department_array = Db::name('Department')->where(['status' => 1])->column('title', 'id');
			$position_array = Db::name('Position')->where(['status' => 1])->column('title', 'id');
            //循环读取excel表格，整合成数组。如果是不指定key的二维，就用$data[i][j]表示。
			$pinyin = new Pinyin();
            for ($j = 3; $j <= $highestRow; $j++) {
				$salt = set_salt(20);
				$reg_pwd  = '123456';
				$name = $objPHPExcel->getActiveSheet()->getCell("A" . $j)->getValue();
				if(empty($name)){
					continue;
				}
				$char = mb_substr($name, 0, 1, 'utf-8');
				$sex = arraySearch($sex_array,$objPHPExcel->getActiveSheet()->getCell("D" . $j)->getValue());
				$department = arraySearch($department_array,$objPHPExcel->getActiveSheet()->getCell("E" . $j)->getValue());
				$position = arraySearch($position_array,$objPHPExcel->getActiveSheet()->getCell("f" . $j)->getValue());
				$type = arraySearch($type_array,$objPHPExcel->getActiveSheet()->getCell("G" . $j)->getValue());
				$pinyinname = $pinyin->name($name,PINYIN_UMLAUT_V);
				$username = implode('', $pinyinname);
				
				$mobile = $objPHPExcel->getActiveSheet()->getCell("B" . $j)->getValue();
				$email = $objPHPExcel->getActiveSheet()->getCell("C" . $j)->getValue();
				$file_check['mobile'] = $mobile;
				$file_check['email'] = $email;
				$validate_mobile = \think\facade\Validate::rule([
					'mobile' => 'require|mobile',
				]);
				$validate_email = \think\facade\Validate::rule([
					'email' => 'email',
				]);
				if (!$validate_mobile->check($file_check)) {
					return to_assign(1, '第'.($j - 2).'行的手机号码'.$validate->getError());
				}
				else{
					if(in_array($mobile,$mobile_array)){
						return to_assign(1, '第'.($j - 2).'行的手机号码已存在或者重复');
					}
					else{
						array_push($mobile_array,$mobile);
					}
				}
				
				if(!empty($email)){
					if (!$validate_email->check($file_check)) {
						return to_assign(1, '第'.($j - 2).'行的电子邮箱'.$validate->getError());
					}
					else{
						if(in_array($email,$email_array)){
							return to_assign(1, '第'.($j - 2).'行的电子邮箱已存在或者重复');
						}
						else{
							array_push($email_array,$email);
						}
					}
				}
				else{
					$email='';
				}
				 
				if(empty($department)){
					return to_assign(1, '第'.($j - 2).'行的所在部门错误');
				}
				if(empty($department)){
					return to_assign(1, '第'.($j - 2).'行的所在部门错误');
				}
				if(empty($position)){
					return to_assign(1, '第'.($j - 2).'行的所属职位错误');
				}
                $data[$j - 3] = [		
                    'name' => $name,
                    'nickname' => $name,
                    'mobile' => $mobile,
                    'email' => $email,
                    'sex' => $sex,
                    'did' => $department,
                    'position_id' => $position,
                    'type' => $type,
					'entry_time' => Shared::excelToTimestamp($objPHPExcel->getActiveSheet()->getCell("H" . $j)->getValue(),'Asia/Shanghai'),
					'username' => $this->check_name($username,$username_array),
                    'salt' => $salt,
					'pwd' => set_password($reg_pwd, $salt),
                    'reg_pwd' => $reg_pwd,
                    'thumb' => $this->to_avatars($char)
                ];
            }
           //dd($data);exit;
            // 批量添加数据
            if ((new Admin())->saveAll($data)) {
                return to_assign(0, '导入成功');
            }
			else{
				return to_assign(1, '导入失败，请检查excel文件再试');
			}
        } catch (\think\exception\ValidateException $e) {
			return to_assign(1, $e->getMessage());
        }
    }
}
