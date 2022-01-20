# 勾股OA

[![勾股OA](https://img.shields.io/badge/GouguOA-1.1.6-brightgreen.svg)](https://gitee.com/gougucms/office/)
[![star](https://gitee.com/gougucms/office/badge/star.svg?theme=dark)](https://gitee.com/gougucms/office/stargazers)
[![fork](https://gitee.com/gougucms/office/badge/fork.svg?theme=dark)](https://gitee.com/gougucms/office/members)

### 链接
- 演示地址：https://oa.gougucms.com
- gitee：https://gitee.com/gougucms/office.git
- 文档地址：[https://blog.gougucms.com/home/book/detail/bid/3.html](https://blog.gougucms.com/home/book/detail/bid/3.html)
- 项目会不定时进行更新，建议⭐star⭐和👁️watch👁️一份。

### 开源项目
- [开源项目系列之勾股OA](https://gitee.com/gougucms/office)  
- [开源项目系列之勾股CMS](https://www.gougucms.com) 
- [开源项目系列之勾股BLOG](https://blog.gougucms.com) 

### 介绍
勾股OA是一款基于ThinkPHP6 + Layui + MySql打造的简单实用的开源免费的企业办公系统框架。可以帮助解决企业办公项目60%的重复工作，让开发更多关注业务逻辑。既能快速提高开发效率，帮助公司节省人力成本，同时又不失灵活性。使用勾股OA可以简单快速地开发出企业级的Web应用系统。

### 演示地址

   勾股OA演示地址：[https://oa.gougucms.com](https://oa.gougucms.com)
   
   勾股OA文档地址：[https://blog.gougucms.com/home/book/detail/bid/3.html](https://blog.gougucms.com/home/book/detail/bid/3.html)

PS：为了给后面的人提供良好的演示体验，体验以查看为主，如果确实需要填写数据，大家最好填些看似正常的数据，请不要乱填数据，比如：1111，aaa那些数据就不要乱来了。
如果大家不遵守体验规则，后期发现很多乱的数据的话，就关闭对应的填写权限了。

   登录账号及密码：
~~~
   BOSS角色：suhaizhen     123456
   人事总监：fengcailing    123456
   财务总监：yucixin        123456
   市场总监：qinjiaxian     123456
   技术总监：yexiaochai     123456
~~~

### 特点
- 系统各功能模块，一目了然，操作简单；通用型的后台权限管理框架，员工的操作记录覆盖跟踪，紧随潮流、极低门槛、开箱即用。
- 系统集成了九大办公基本的功能模块：系统管理、基础数据、人力资源、消息通知、企业公告、知识文章、日常办公、财务管理、商业智能基础模块。
- 系统易于功能扩展，代码维护，方便二次开发，帮助开发者简单高效降低二次开发的成本，满足专注业务深度开发的需求。
- 开发人员可以快速基于此系统进行二次开发，免去写一次系统架构的痛苦，通过二次开发之后可以用来做CRM，ERP，业务管理等企业办公系统。

### 目录结构

初始的目录结构如下：

~~~
www  系统部署目录（或者子目录）
├─app           		应用目录
│  │
│  ├─home               前台模块目录
│  │  ├─controller      控制器目录
│  │  ├─middleware      中间层目录
│  │  ├─model           模型目录
│  │  ├─validate        校验器目录
│  │  ├─view            视图模板目录
│  │  ├─BaseController.php      基础控制器
│  │  ├─common.php      模块函数文件
│  │
│  ├─install            安装模块目录(系统安装完后，建议删除)
│  │  ├─controller      控制器目录
│  │  ├─data            初始化数据库文件
│  │  ├─validate        校验器目录
│  │  ├─view            视图模板目录
│  │
├─config                配置文件目录
│  ├─app.php            系统主要配置文件
│  ├─database.php       数据库配置文件
│
├─extend                扩展类库目录
│  ├─avatars            自动生成头像文件目录
│  ├─backup             数据库备份文件目录
│
├─public                WEB目录（对外访问目录，域名绑定的目录）
│  ├─backup          	数据库备份目录
│  ├─static          	css、js等静态资源目录
│  │   ├─admin          系统后台css、js文件
│  │   ├─home         	系统前台css、js文件
│  │   ├─layui         	layui目录
│  │   ├─ueditor        百度编辑器目录
│  ├─storage            上传的图片等资源目录
│  ├─tpl                TP中转界面模板目录
│  ├─index.php          入口文件
│  ├─router.php         快速测试文件
│  └─.htaccess          用于apache的重写
│
├─route                 路由目录
├─vendor              	第三方类库目录(Composer依赖库目录)
│
├─runtime               应用的运行时目录（可写，可定制）
├─composer.json         composer 定义文件
├─LICENSE.txt           授权说明文件
├─README.md             README 文件
├─think                 命令行入口文件
~~~


### 功能矩阵

系统后台集成了主流的通用功能，如：登录验证、系统配置、操作日志管理、用户（组）管理、用户（组）权限、功能管理（后台菜单管理）、TAG关键字管理、文件上传、数据备份/还原、基础数据、人力资源、消息通知、企业公告、知识文章、日常办公、财务管理、商业智能、 API接口等。更多的个性化功能可以基于当前系统便捷做二次开发。

具体功能如下：

~~~
系统
│        		
├─系统管理           		
│  ├─系统配置
│  ├─功能菜单
│  ├─功能节点
│  ├─权限角色
│  ├─操作日志
│  ├─数据备份
│  ├─系统配置
│  ├─数据还原
│
├─基础数据
│  ├─审核人相关配置
│  ├─工作类型设置
│  ├─知识关键字设置
│  ├─报销类型设置
│  ├─发票主体设置 
│ 
├─人力资源
│  ├─部门架构
│  ├─岗位职称
│  ├─企业员工
│  ├─人事调动
│  ├─离职档案
│
├─消息通知
│  ├─收件箱
│  ├─已发送
│  ├─草稿箱
│  ├─垃圾箱
│
├─企业公告
│  ├─公告类别
│  ├─公告列表
│
├─知识文章
│  ├─知识类别
│  ├─共享知识
│  ├─个人知识
│
├─日常办公
│  ├─工作计划
│  ├─计划日历
│  ├─工作记录
│  ├─工作日历
│
├─财务管理
│  ├─报销管理
│  ├─发票管理
│  ├─到账管理
│
├─商业智能
│  ├─日志分析
│  ├─工时分析
│
├─...
~~~


### 安装教程

一、勾股OA推荐你使用阿里云和腾讯云服务器。

阿里云服务器官方长期折扣优惠地址：

点击访问，(https://www.aliyun.com/activity/daily/bestoffer?userCode=dmrcx154) 

腾讯云服务器官方长期折扣优惠地址：

点击访问，(https://curl.qcloud.com/PPEgI0oV) 


二、服务器运行环境要求。

~~~
    PHP >= 7.1  
    Mysql >= 5.5.0 (需支持innodb引擎)  
    Apache 或 Nginx  
    PDO PHP Extension  
    MBstring PHP Extension  
    CURL PHP Extension  
    Composer (用于管理第三方扩展包)
~~~

三、系统安装

**命令行安装（推荐）**

推荐使用命令行安装，因为采用命令行安装的方式可以和勾股OA随时保持更新同步。使用命令行安装请提前准备好Git、Composer。

Linux下，勾股OA的安装请使用以下命令进行安装。  

第一步：克隆勾股CMS到你本地  
    git clone https://gitee.com/gougucms/office.git

第二步：进入目录  
    cd gouguoa  
    
第三步：下载PHP依赖包 
    
composer install  
	
注意：composer的版本最好是2.0.8版本，否则可能下载PHP依赖包失败，composer降级：composer self-update 2.0.8
    
第四步：添加虚拟主机并绑定到项目的public目录  
    
第五步：访问 http://www.yoursite.com/install/index 进行安装

**PS：如需要重新安装，请删除目录里面 config/install.lock 的文件，即可重新安装。**

四、伪静态配置

**Nginx**
修改nginx.conf 配置文件 加入下面的语句。
~~~
    location / {
        if (!-e $request_filename){
        rewrite  ^(.*)$  /index.php?s=$1  last;   break;
        }
    }
~~~

**Apache**
把下面的内容保存为.htaccess文件放到应用入 public 文件的同级目录下。
~~~
    <IfModule mod_rewrite.c>
    Options +FollowSymlinks -Multiviews
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^(.*)$ index.php?/$1 [QSA,PT,L]
    </IfModule>
~~~


### 常见问题

1.  安装失败，可能存在php配置文件禁止了putenv 和 proc_open函数。解决方法，查找php.ini文件位置，打开php.ini，搜索 disable_functions 项，看是否禁用了putenv 和 proc_open函数。如果在禁用列表里，移除putenv proc_open然后退出，重启php即可。

2.  如果安装后打开页面提示404错误，请检查服务器伪静态配置，如果是宝塔面板，网站伪静态请配置使用thinkphp规则。

3.  如果提示当前权限不足，无法写入配置文件config/database.php，请检查database.php是否可读，还有可能是当前安装程序无法访问父目录，请检查PHP的open_basedir配置。

4.  如果composer install失败，请尝试在命令行进行切换配置到国内源，命令如下composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/。

5.  如果composer install失败，请尝试composer降级：composer self-update 2.0.8。

6.  访问 http://www.yoursite.com/install/index ，请注意查看伪静态请配置是否设置了thinkphp规则。

7.  遇到问题请到QQ群：24641076 反馈。

### 截图预览
![输入图片说明](https://oa.gougucms.com/storage/image/oa1.png)
![输入图片说明](https://oa.gougucms.com/storage/image/oa2.png)
![输入图片说明](https://oa.gougucms.com/storage/image/oa3.png)

### 开源协议  
勾股OA遵循GPL-2.0开源协议发布，并支持免费使用。 

### 开源助力
目前勾股OA版本在公测中，如果大家在体验的过程中发现有问题或者BUG，请到Issue里面反馈，谢谢！
如果觉得勾股OA不错，不要吝啬您的赞许和鼓励，请给我们⭐ STAR ⭐吧！

