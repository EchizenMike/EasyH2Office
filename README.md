## 📐 勾股OA4.0

![勾股OA](https://oa.gougucms.com/storage/image/slogo.jpg)

### ✅ 相关链接
- 系统地址：https://www.gougucms.com/home/pages/detail/s/gouguoa.html
- 文档地址：[https://blog.gougucms.com/home/book/detail/bid/3.html](https://blog.gougucms.com/home/book/detail/bid/3.html)
- 项目会不定时进行更新，建议⭐star⭐和👁️watch👁️一份。

### ⭕ 同系列开源项目
1. [开源项目系列：勾股OA —— OA协同办公系统](https://gitee.com/gougucms/office)
2. [开源项目系列：勾股DEV —— 项目研发管理系统](https://gitee.com/gougucms/dev)
3. [开源项目系列：勾股CMS —— CMS内容管理系统框架](https://gitee.com/gougucms/gougucms)
4. [开源项目系列：勾股BLOG —— 个人&工作室博客系统](https://gitee.com/gougucms/blog)
5. [开源项目系列：勾股Admin —— 基于Layui的Web UI解决方案](https://gitee.com/gouguopen/guoguadmin)


### 📋 系统介绍
 **我们的愿景是：助力企业数智化。** 

勾股OA是一款基于ThinkPHP6 + Layui + MySql打造的实用的开源的企业办公系统，开箱即用，使用勾股OA可以简单快速地建立企业级的办公自动化系统。
办公自动化系统是员工及管理者使用频率最高的应用系统，可以极大提高公司的办公效率，我们立志为中小企业提供开源好用的办公自动化系统，帮助企业节省数字化、信息化办公的成本。

### ✳️ 演示地址

勾股OA演示地址：[https://oa.gougucms.com](https://oa.gougucms.com)

沟通咨询请加微信号：hdm588

PS：为了给后面的人提供良好的演示体验，体验以查看为主，如果确实需要填写数据，大家最好填些看似正常的数据，请不要乱填数据，比如：1111，aaa那些数据就不要乱来了。

体验账号及密码：
~~~
BOSS角色：suhaizhen     123456
总 经 理：yiyeshu      123456
人事总监：fengcailing      123456
财务总监：yucixin     1234566
市场总监：qinjiaxian     1234566
技术总监：yexiaochai     1234566
销售组长：fujianfenshuo      123456
销售组长：jianzixianji      123456
销售组长：shuloulongsu      123456
客服经理：hongchenxue      123456
客服人员：guxinglei      123456
~~~

### ✴️ 系统特点
- 系统各功能模块，一目了然，操作简单；通用型的后台权限管理框架，员工的操作记录全覆盖跟踪，紧随潮流、极低门槛、开箱即用。
- 系统集成了系统设置、人事管理、行政管理、消息管理、企业公告、知识库、审批流程设置、办公审批、日常办公、财务管理、客户管理、合同管理、项目管理、任务管理等基础模块。。
- 系统方便二次开发，易于功能扩展，代码维护，满足专注业务深度开发的需求。
- 开发人员可以快速基于此系统进行二次开发，免去写一次系统架构的痛苦，帮助开发者高效降低开发的成本，通过二次开发之后可以用来做CRM，ERP，项目管理等企业办公系统。

**功能矩阵**

系统后台集成了主流的通用功能，如：登录验证、系统配置、操作日志管理、角色权限、职位职称、功能菜单、模块管理、关键字管理、文件上传、数据备份/还原、基础数据、审批流程、员工管理、消息通知、企业公告、知识文章、办公审批、日常办公、财务管理、API接口等。更多的个性化功能可以基于当前系统便捷做二次开发。

![输入图片说明](https://oa.gougucms.com/storage/image/gouguoa2.0.png)


### 📚 安装教程

**一、服务器。**

服务器最低配置：
~~~
    1核CPU (建议2核+)
    1G内存 (建议4G+)
    1M带宽 (建议3M+)
~~~
服务器运行环境要求：
~~~
    PHP >= 7.2.5(建议7.4)  
    Mysql >= 5.5.0 (需支持innodb引擎)  
    Apache 或 Nginx  
    PDO PHP Extension  
    MBstring PHP Extension  
    CURL PHP Extension  
    Composer (用于管理第三方扩展包)
~~~

**二、系统安装**

**命令行安装（推荐）**

推荐使用命令行安装，因为采用命令行安装的方式可以和勾股OA随时保持更新同步。使用命令行安装请提前准备好Git、Composer。

Linux下，勾股OA的安装请使用以下命令进行安装。  

第一步：克隆勾股OA到你本地(不使用git的用户，可以点击右上角打包zip下载，并解压上传代码即可)  
    git clone https://gitee.com/gougucms/office.git

第二步：进入目录  
    cd gouguoa（文件所在根目录）  
    
第三步：下载PHP依赖包
    
composer install  
    
第四步：添加虚拟主机并绑定到项目的public目录 ，实际部署中，确保绑定域名访问到的是public目录。（这一步很重要，很多人出错）

第五步：伪静态配置（这一步也很重要，很多人出错）

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

第六步：访问 http://www.你的域名.com/install/index 进行安装（访问主域名会自动跳转到安装连接的）

⚠️⚠️ **注意：安装过程中，系统会自动创建数据库，请确保填写的数据库用户的权限可创建数据库，如果权限不足，请先手动创建空的数据库，然后填写刚创建的数据库名称和用户名也可完成安装。** 

🔺🔺  **提醒：安装过程中，如果进度条卡住，一般都是数据库写入权限或者安装环境配置问题，请注意检查。遇到问题请到QQ群反馈：24641076（群一满），46924914（群二名额不多）** 

✅✅ **PS：如需要重新安装，请删除目录里面 config/install.lock 的文件，即可重新安装。**


### ❓ 常见问题

1.  安装失败，可能存在php配置文件禁止了putenv 和 proc_open函数。解决方法，查找php.ini文件位置，打开php.ini，搜索 disable_functions 项，看是否禁用了putenv 和 proc_open函数。如果在禁用列表里，移除putenv proc_open然后退出，重启php即可。

2.  如果安装后打开页面提示404错误，请检查服务器伪静态配置，如果是宝塔面板，网站伪静态请配置使用thinkphp规则。

3.  如果提示当前权限不足，无法写入配置文件config/database.php，请检查database.php是否可读，还有可能是当前安装程序无法访问父目录，请检查PHP的open_basedir配置。

4.  如果composer install失败，请尝试在命令行进行切换配置到国内源，命令如下composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/。

5.  访问 http://www.你的域名.com/install/index ，请注意查看伪静态请配置是否设置了thinkphp规则。

6.  MySQL的连接用户是否有自动创建数据的权限（不清楚的或没有权限的，那就先手动创建一下数据库哦）。

7.  如果安装成功后，无法显示图形验证码的，请看是否已安装（开启）了PHP的GD库。

8.  如果遇到无法解决的问题请到QQ群反馈交流：24641076（群一满），46924914（群二名额不多）。

**📢如果需要提供安装服务，请搜索微信号：hdm588，添加好友，注意备注[安装勾股系统]。开源不易，该服务需友情赞赏💰99元。** 

### 🖼️ 截图预览
|页面截图      |    部分截图|
| :--------: | :--------:|
| ![功能导图](https://oa.gougucms.com/storage/image/oa4.png "功能导图")|![功能导图](https://oa.gougucms.com/storage/image/oa1.png "功能导图")|
|![功能导图](https://oa.gougucms.com/storage/image/oa2.png "功能导图")|![功能导图](https://oa.gougucms.com/storage/image/oa3.png "功能导图")|

### ⭐ 开源助力

- 勾股OA遵循GPL-3.0开源协议发布。
- 开源的系统少不了大家的参与，如果大家在体验的过程中发现有问题或者BUG，请到Issue里面反馈，谢谢！
- 如果觉得勾股OA不错，不要吝啬您的赞许和鼓励，请给我们⭐ STAR ⭐吧！

### 👍 支持我们
- If the project is very helpful to you, you can buy the author a cup of coffee☕.
- 如果这个项目对您有帮助，可以请作者喝杯咖啡吧哟☕

|支付宝      |    微信|
| :--------: | :--------:|
| <img src="https://www.gougucms.com/static/home/images/zfb.png" width="300"  align=center />|<img src="https://www.gougucms.com/static/home/images/wx.png" width="300"  align=center />|

