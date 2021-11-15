/**
 * @copyright Copyright (c) 2021 勾股工作室
 * @license https://opensource.org/licenses/GPL-2.0
 * @link https://www.gougucms.com
 */


SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `cms_admin`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin`;
CREATE TABLE `cms_admin` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL DEFAULT '',
  `pwd` varchar(100) NOT NULL DEFAULT '',
  `salt` varchar(100) NOT NULL DEFAULT '',
  `nickname` varchar(255) DEFAULT '',
  `thumb` varchar(255) DEFAULT NULL,
  `mobile` bigint(11) DEFAULT '0',
  `desc` text COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `last_login_time` int(11) NOT NULL DEFAULT '0',
  `login_num` int(11) NOT NULL DEFAULT '0',
  `last_login_ip` varchar(64) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1正常,0禁止登录,-1删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='管理员表';

-- ----------------------------
-- Table structure for `cms_admin_group`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin_group`;
CREATE TABLE `cms_admin_group` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT '1',
  `rules` varchar(1000) DEFAULT '' COMMENT '用户组拥有的规则id， 多个规则","隔开',
  `menus` varchar(1000) DEFAULT '',
  `desc` text COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='权限分组表';

-- ----------------------------
-- Records of cms_admin_group
-- ----------------------------
INSERT INTO `cms_admin_group` VALUES ('1', '超级管理员', '1', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22', '超级管理员，系统自动分配所有可操作权限及菜单。', '0', '0');
INSERT INTO `cms_admin_group` VALUES (2, '测试角色', 1, '1,5,6,11,15,19,23,28,29,30,2,37,41,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,3,67,68,70,71,72,73,4,74,75,76,77,78,79,80,81', '1,5,6,7,8,9,10,11,12,2,13,14,15,16,17,3,18,19,4,20,21,22', '测试角色', 0, 0);
-- ----------------------------
-- Table structure for `cms_admin_group_access`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin_group_access`;
CREATE TABLE `cms_admin_group_access` (
  `uid` int(11) unsigned DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='权限分组和管理员的关联表';

-- ----------------------------
-- Records of cms_admin_group_access
-- ----------------------------
INSERT INTO `cms_admin_group_access` VALUES ('1', '1', '0', '0');

-- ----------------------------
-- Table structure for `cms_admin_menu`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin_menu`;
CREATE TABLE `cms_admin_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `src` varchar(255) DEFAULT '',
  `icon` varchar(255) DEFAULT '',
  `sort` int(11) NOT NULL DEFAULT '1' COMMENT '越大越靠前',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='后台菜单';

-- ----------------------------
-- Records of cms_admin_menu
-- ----------------------------
INSERT INTO `cms_admin_menu` VALUES (1, 0, '系统管理', '', 'icon-yingyongguanli', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (2, 0, '基础数据', '', 'icon-shebeiguanli', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (3, 0, '平台用户', '', 'icon-quanxianshenpi', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (4, 0, '资讯中心', '', 'icon-daibanshixiang', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (5, 1, '系统配置', 'admin/conf/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (6, 1, '功能菜单', 'admin/menu/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (7, 1, '功能节点', 'admin/rule/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (8, 1, '权限角色', 'admin/role/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (9, 1, '管 理 员', 'admin/admin/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (10, 1, '操作日志', 'admin/admin/log', '',  1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (11, 1, '数据备份', 'admin/database/database', '',  1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (12, 1, '数据还原', 'admin/database/backuplist', '',  1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (13, 2, '导航设置', 'admin/nav/index', '',  1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (14, 2, '网站地图', 'admin/sitemap/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (15, 2, '轮播广告', 'admin/slide/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (16, 2, 'SEO关键字', 'admin/keywords/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (17, 2, '搜索关键词', 'admin/search/index', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (18, 3, '用户列表', 'admin/user/index', '',1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (19, 3, '操作记录', 'admin/user/record', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (20, 3, '操作日志', 'admin/user/log', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (21, 4, '文章分类', 'admin/article/cate', '', 1, 0, 0);
INSERT INTO `cms_admin_menu` VALUES (22, 4, '文章列表', 'admin/article/index', '', 1, 0, 0);

-- ----------------------------
-- Table structure for `cms_admin_rule`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin_rule`;
CREATE TABLE `cms_admin_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) unsigned NOT NULL DEFAULT '0',
  `src` varchar(255) NOT NULL DEFAULT '' COMMENT '规则',
  `title` varchar(255) NOT NULL DEFAULT '',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='权限节点';

-- ----------------------------
-- Records of cms_admin_rule
-- ----------------------------
INSERT INTO `cms_admin_rule` VALUES (1, 0, '', '系统管理', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (2, 0, '', '基础数据', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (3, 0, '', '平台用户', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (4, 0, '', '资讯中心', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (5, 1, 'admin/conf/index', '系统配置', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (6, 5, 'admin/conf/add', '新增配置信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (7, 5, 'admin/conf/post_submit', '保存配置信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (8, 5, 'admin/conf/edit', '编辑配置详情', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (9, 5, 'admin/conf/conf_submit', '保存配置内容', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (10, 5, 'admin/conf/delete', '删除配置信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (11, 1, 'admin/menu/index', '功能菜单', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (12, 11, 'admin/menu/add', '添加菜单', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (13, 11, 'admin/menu/post_submit', '保存菜单信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (14, 11, 'admin/menu/delete', '删除菜单', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (15, 1, 'admin/rule/index', '功能节点', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (16, 15, 'admin/rule/add', '添加节点', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (17, 15, 'admin/rule/post_submit', '保存节点信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (18, 15, 'admin/rule/delete', '删除节点', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (19, 1, 'admin/role/index', '权限角色', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (20, 19, 'admin/role/add', '添加角色',0, 0);
INSERT INTO `cms_admin_rule` VALUES (21, 19, 'admin/role/post_submit', '保存角色信息',0, 0);
INSERT INTO `cms_admin_rule` VALUES (22, 19, 'admin/role/delete', '删除角色', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (23, 1, 'admin/admin/index', '管理员', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (24, 23, 'admin/admin/add', '添加/修改管理员', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (25, 23, 'admin/admin/post_submit', '保存管理员信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (26, 23, 'admin/admin/view', '查看管理员信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (27, 23, 'admin/admin/delete', '删除管理员',0, 0);
INSERT INTO `cms_admin_rule` VALUES (28, 1, 'admin/admin/log', '操作日志',0, 0);
INSERT INTO `cms_admin_rule` VALUES (29, 1, 'admin/database/database', '备份数据',  0, 0);
INSERT INTO `cms_admin_rule` VALUES (30, 29, 'admin/database/backup', '备份数据表', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (31, 29, 'admin/database/optimize', '优化数据表', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (32, 29, 'admin/database/repair', '修复数据表', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (33, 1, 'admin/database/backuplist', '还原数据', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (34, 33, 'admin/database/import', '还原数据表', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (35, 33, 'admin/database/downfile', '下载备份数据', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (36, 33, 'admin/database/del', '删除备份数据', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (37, 2, 'admin/nav/index', '导航组管理', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (38, 37, 'admin/nav/add', '添加/修改导航组', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (39, 37, 'admin/nav/post_submit', '保存导航组信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (40, 37, 'admin/nav/delete', '删除导航组', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (41, 2, 'admin/nav/nav_info', '导航管理', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (42, 41, 'admin/nav/nav_info_add', '添加/修改导航', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (43, 41, 'admin/nav/nav_info_submit', '保存导航信息',0, 0);
INSERT INTO `cms_admin_rule` VALUES (44, 41, 'admin/nav/nav_info_delete', '删除导航',0, 0);
INSERT INTO `cms_admin_rule` VALUES (45, 2, 'admin/sitemap/index', '网站地图分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (46, 45, 'admin/sitemap/add', '添加/编辑网站地图分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (47, 45, 'admin/sitemap/post_submit', '保存网站地图分类信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (48, 45, 'admin/sitemap/delete', '删除网站地图分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (49, 2, 'admin/sitemap/sitemap_info', '网站地图', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (50, 49, 'admin/sitemap/sitemap_info_add', '添加/编辑网站地图',0, 0);
INSERT INTO `cms_admin_rule` VALUES (51, 49, 'admin/sitemap/sitemap_info_submit', '保存网站地图信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (52, 49, 'admin/sitemap/sitemap_info_delete', '删除网站地图', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (53, 2, 'admin/slide/index', '轮播组',0, 0);
INSERT INTO `cms_admin_rule` VALUES (54, 53, 'admin/slide/add', '添加轮播组',  0, 0);
INSERT INTO `cms_admin_rule` VALUES (55, 53, 'admin/slide/post_submit', '保存轮播组信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (56, 53, 'admin/slide/delete', '删除轮播组', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (57, 2, 'admin/slide/slide_info', '轮播广告', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (58, 57, 'admin/slide/slide_info_add', '添加轮播图', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (59, 57, 'admin/slide/slide_info_submit', '保存轮播图信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (60, 57, 'admin/slide/slide_info_delete', '删除轮播图', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (61, 2, 'admin/keywords/index', 'SEO关键字', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (62, 61, 'admin/keywords/add', '添加SEO关键字',  0, 0);
INSERT INTO `cms_admin_rule` VALUES (63, 61, 'admin/keywords/post_submit', '保存SEO关键字', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (64, 61, 'admin/keywords/delete', '删除SEO关键字',  0, 0);
INSERT INTO `cms_admin_rule` VALUES (65, 2, 'admin/search/index', '搜索关键字', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (66, 65, 'admin/search/delete', '删除搜索关键字', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (67, 3, 'admin/user/index', '用户管理', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (68, 67, 'admin/user/edit', '编辑用户信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (69, 67, 'admin/user/post_submit', '保存用户信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (70, 67, 'admin/user/view', '查看用户信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (71, 67, 'admin/user/delete', '禁用用户',0, 0);
INSERT INTO `cms_admin_rule` VALUES (72, 3, 'admin/user/record', '操作记录', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (73, 3, 'admin/user/log', '操作日志', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (74, 4, 'admin/article/cate', '文章分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (75, 74, 'admin/article/cate_add', '添加文章分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (76, 74, 'admin/article/cate_post_submit', '保存文章分类信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (77, 74, 'admin/article/cate_delete', '删除文章分类', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (78, 4, 'admin/article/index', '文章列表',  0, 0);
INSERT INTO `cms_admin_rule` VALUES (79, 78, 'admin/article/add', '添加文章', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (80, 78, 'admin/article/post_submit', '保存文章信息', 0, 0);
INSERT INTO `cms_admin_rule` VALUES (81, 78, 'admin/article/delete', '删除文章', 0, 0);

-- ----------------------------
-- Table structure for `cms_admin_log`
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin_log`;
CREATE TABLE `cms_admin_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` varchar(80) NOT NULL DEFAULT '' COMMENT '操作类型',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '操作标题',
  `content` text COMMENT '操作描述',
  `module` varchar(32) NOT NULL DEFAULT '' COMMENT '模块',
  `controller` varchar(32) NOT NULL DEFAULT '' COMMENT '控制器',
  `function` varchar(32) NOT NULL DEFAULT '' COMMENT '方法',
  `rule_menu` varchar(255) NOT NULL DEFAULT '' COMMENT '节点权限路径',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '登录ip',
  `param_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '操作数据id',
  `param` text COMMENT '参数json格式',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0删除 1正常',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='后台操作日志表';

-- ----------------------------
-- Table structure for `cms_config`
-- ----------------------------
DROP TABLE IF EXISTS `cms_config`;
CREATE TABLE `cms_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '配置名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '配置标识',
  `content` text NULL COMMENT '配置内容',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='系统配置表';
-- ----------------------------
-- Records of cms_config
-- ----------------------------
INSERT INTO `cms_config` VALUES (1, '网站配置', 'web', 'a:13:{s:2:\"id\";s:1:\"1\";s:11:\"admin_title\";s:9:\"勾股cms\";s:5:\"title\";s:9:\"勾股cms\";s:4:\"logo\";s:0:\"\";s:4:\"file\";s:0:\"\";s:6:\"domain\";s:24:\"https://www.gougucms.com\";s:3:\"icp\";s:23:\"粤ICP备1xxxxxx11号-1\";s:8:\"keywords\";s:9:\"勾股cms\";s:5:\"beian\";s:29:\"粤公网安备1xxxxxx11号-1\";s:4:\"desc\";s:255:\"勾股CMS是一套基于ThinkPHP6 + Layui + MySql打造的轻量级、高性能快速建站的内容管理系统。后台管理模块，一目了然，操作简单，通用型后台权限管理框架，紧随潮流、极低门槛、开箱即用。        \";s:4:\"code\";s:0:\"\";s:9:\"copyright\";s:32:\"© 2021 gougucms.com MIT license\";s:7:\"version\";s:5:\"1.0.2\";}', 1, 1612514630, 1623721279);
INSERT INTO `cms_config` VALUES (2, '邮箱配置', 'email', 'a:8:{s:2:\"id\";s:1:\"2\";s:4:\"smtp\";s:11:\"smtp.qq.com\";s:9:\"smtp_port\";s:3:\"465\";s:9:\"smtp_user\";s:15:\"gougucms@qq.com\";s:8:\"smtp_pwd\";s:6:\"123456\";s:4:\"from\";s:24:\"勾股CMS系统管理员\";s:5:\"email\";s:18:\"admin@gougucms.com\";s:8:\"template\";s:122:\"<p>勾股CMS是一套基于ThinkPHP6 + Layui + MySql打造的轻量级、高性能快速建站的内容管理系统。</p>\";}', 1, 1612521657, 1619088538);
INSERT INTO `cms_config` VALUES (3, '微信配置', 'wechat', 'a:11:{s:2:\"id\";s:1:\"3\";s:5:\"token\";s:8:\"GOUGUCMS\";s:14:\"login_back_url\";s:49:\"https://www.gougucms.com/wechat/index/getChatInfo\";s:5:\"appid\";s:18:\"wxdf96xxxx7cd6f0c5\";s:9:\"appsecret\";s:32:\"1dbf319a4f0dfed7xxxxfd1c7dbba488\";s:5:\"mchid\";s:10:\"151xxxx331\";s:11:\"secrect_key\";s:29:\"gougucmsxxxxhumabcxxxxjixxxng\";s:8:\"cert_url\";s:13:\"/extend/cert/\";s:12:\"pay_back_url\";s:42:\"https://www.gougucms.com/wxappv1/wx/notify\";s:9:\"xcx_appid\";s:18:\"wxdf96xxxx9cd6f0c5\";s:13:\"xcx_appsecret\";s:28:\"gougucmsxxxxhunangdmabcxxxng\";}', 1, 1612522314, 1613789058);
INSERT INTO `cms_config` VALUES (4, 'Api Token配置', 'token', 'a:5:{s:2:\"id\";s:1:\"5\";s:3:\"iss\";s:16:\"www.gougucms.com\";s:3:\"aud\";s:8:\"gougucms\";s:7:\"secrect\";s:8:\"GOUGUCMS\";s:7:\"exptime\";s:4:\"3600\";}', 1, 1627313142, 1627376290);
INSERT INTO `cms_config` VALUES (5, '其他配置', 'other', 'a:3:{s:2:"id";s:1:"4";s:6:"author";s:15:"勾股工作室";s:7:"version";s:13:"v1.2021.07.28";}', 1, 1613725791, 1613789431);


-- ----------------------------
-- Table structure for `cms_keywords`
-- ----------------------------
DROP TABLE IF EXISTS `cms_keywords`;
CREATE TABLE `cms_keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字名称',
  `sort` int(11)  NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='关键字表';
-- ----------------------------
-- Records of cms_keywords
-- ----------------------------
INSERT INTO `cms_keywords` VALUES (1, '勾股CMS', 0, 1, 1610183567, 1610184824);

-- ----------------------------
-- Table structure for `cms_article_cate`
-- ----------------------------
DROP TABLE IF EXISTS `cms_article_cate`;
CREATE TABLE `cms_article_cate` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0' COMMENT '父类ID',
  `sort` int(5) NOT NULL DEFAULT '0' COMMENT '排序',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `keywords` varchar(255) DEFAULT '' COMMENT '关键字',
  `desc` varchar(1000) DEFAULT '' COMMENT '描述',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT '0' COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='内容分类表';
-- ----------------------------
-- Records of cms_article_cate
-- ----------------------------
INSERT INTO `cms_article_cate` VALUES (1, 0, 0, '勾股cms', '1', '分类描述内容...', 0, 1610196442);

-- ----------------------------
-- Table structure for `cms_article`
-- ----------------------------
DROP TABLE IF EXISTS `cms_article`;
CREATE TABLE `cms_article` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `keywords` varchar(255) DEFAULT '' COMMENT '关键字',
  `desc` varchar(1000) DEFAULT '' COMMENT '摘要',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1正常-1下架',
  `thumb` int(11) NOT NULL DEFAULT 0 COMMENT '缩略图id',
  `original` int(1) NOT NULL DEFAULT 0 COMMENT '是否原创，1原创',
  `origin` varchar(255) NOT NULL DEFAULT '' COMMENT '来源或作者',
  `origin_url` varchar(255) NOT NULL DEFAULT '' COMMENT '来源地址',
  `content` text NOT NULL,
  `read` int(11) NOT NULL DEFAULT '0' COMMENT '阅读量',
  `type` tinyint(2) NOT NULL DEFAULT '0' COMMENT '属性：1精华 2热门 3推荐',
  `is_home` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否首页显示，0否，1是',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `article_cate_id` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  `delete_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='文章表';

-- ----------------------------
-- Records of cms_article
-- ----------------------------
INSERT INTO `cms_article` VALUES (1, '勾股CMS简介', '', '勾股CMS是一套基于ThinkPHP6+Layui+MySql打造的轻量级、高性能快速建站的内容管理系统。后台管理模块，一目了然，操作简单，通用型后台权限管理框架，紧随潮流、极低门槛、开箱即用。', 1, 0, 0, '', '', '<p>勾股CMS是一套基于ThinkPHP6 + Layui + MySql打造的轻量级、高性能快速建站的内容管理系统。后台管理模块，一目了然，操作简单，通用型后台权限管理框架，紧随潮流、极低门槛、开箱即用。</p>', 0, 2, 1, 0, 1, 1625071256, 0, 0);

-- ----------------------------
-- Table structure for `cms_article_keywords`
-- ----------------------------
DROP TABLE IF EXISTS `cms_article_keywords`;
CREATE TABLE `cms_article_keywords` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `aid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '文章ID',
  `keywords_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '关联关键字id',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`),
  KEY `inid` (`keywords_id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='文章关联表';
-- ----------------------------
-- Records of cms_article_keywords
-- ----------------------------
INSERT INTO `cms_article_keywords` VALUES (1, 1, 1, 1, 1610198553);

-- ----------------------------
-- Table structure for cms_sitemap_cate
-- ----------------------------
DROP TABLE IF EXISTS `cms_sitemap_cate`;
CREATE TABLE `cms_sitemap_cate`  (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1可用-1禁用',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT = '网站地图分类表';

-- ----------------------------
-- Table structure for cms_sitemap
-- ----------------------------
DROP TABLE IF EXISTS `cms_sitemap`;
CREATE TABLE `cms_sitemap`  (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sitemap_cate_id` int(11) NOT NULL DEFAULT 0 COMMENT '分类id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `pc_img` varchar(255) NULL DEFAULT NULL COMMENT 'pc端图片',
  `pc_src` varchar(255) NULL DEFAULT NULL COMMENT 'pc端链接',
  `mobile_img` varchar(255) NULL DEFAULT NULL COMMENT '移动端图片',
  `mobile_src` varchar(255) NULL DEFAULT NULL COMMENT '移动端链接',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1可用-1禁用',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT = '网站地图内容表';


-- ----------------------------
-- Table structure for `cms_nav`
-- ----------------------------
DROP TABLE IF EXISTS `cms_nav`;
CREATE TABLE `cms_nav` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标识',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1可用-1禁用',
  `desc` varchar(1000) DEFAULT NULL,
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='导航';

-- -----------------------------
-- Records of `cms_nav`
-- -----------------------------
INSERT INTO `cms_nav` VALUES ('1', '主导航', 'NAV_HOME', '1', '平台主导航', '0', '0');

-- ----------------------------
-- Table structure for `cms_nav_info`
-- ----------------------------
DROP TABLE IF EXISTS `cms_nav_info`;
CREATE TABLE `cms_nav_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0',
  `nav_id` int(11) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT '',
  `src` varchar(255) DEFAULT NULL,
  `param` varchar(255) DEFAULT NULL,
  `target` int(1) NOT NULL DEFAULT '0' COMMENT '是否新窗口打开,默认0,1新窗口打开',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1可用,-1禁用',
  `sort` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='导航详情表';

-- -----------------------------
-- Records of `cms_nav_info`
-- -----------------------------
INSERT INTO `cms_nav_info` VALUES ('1', '0', '1', '首页', '/', 'index', '0', '1', '1', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('2', '0', '1', '开发日志', 'https://www.gougucms.com/home/index/logs.html', 'logs', '1', '1', '2', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('3', '0', '1', '博客社区', 'https://blog.gougucms.com/', '', '0', '1', '3', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('4', '0', '1', 'API接口', '/api/index', '', '1', '1', '4', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('5', '0', '1', '腾讯云优惠', 'https://curl.qcloud.com/PPEgI0oV', '', '1', '1', '5', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('6', '0', '1', '阿里云特惠', 'https://www.aliyun.com/activity/daily/bestoffer?userCode=dmrcx154', '', '1', '1', '6', '0', '0');
INSERT INTO `cms_nav_info` VALUES ('7', '0', '1', '后台演示', 'https://www.gougucms.com/admin/index/index.html', '', '1', '1', '7', '0', '0');

-- ----------------------------
-- Table structure for `cms_slide`
-- ----------------------------
DROP TABLE IF EXISTS `cms_slide`;
CREATE TABLE `cms_slide` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标识',
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1可用-1禁用',
  `desc` varchar(1000) DEFAULT NULL,
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='幻灯片表';

-- ----------------------------
-- Records of cms_slide
-- ----------------------------
INSERT INTO `cms_slide` VALUES ('1', '首页轮播', 'INDEX_SLIDE', '1', '首页轮播组。', '0', '0');

-- ----------------------------
-- Table structure for `cms_slide_info`
-- ----------------------------
DROP TABLE IF EXISTS `cms_slide_info`;
CREATE TABLE `cms_slide_info` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `slide_id` int(11) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `desc` varchar(1000) DEFAULT NULL,
  `img` varchar(255) NOT NULL DEFAULT '',
  `src` varchar(255) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT '1' COMMENT '1可用-1禁用',
  `sort` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `update_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='幻灯片详情表';

-- ----------------------------
-- Records of cms_slide_info
-- ----------------------------

-- ----------------------------
-- Table structure for cms_search_keywords
-- ----------------------------
DROP TABLE IF EXISTS `cms_search_keywords`;
CREATE TABLE `cms_search_keywords`  (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字',
  `times` int(11) NOT NULL DEFAULT 0 COMMENT '搜索次数',
  `type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '1,2',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT = '搜索关键字表';

-- ----------------------------
-- Table structure for cms_user
-- ----------------------------
DROP TABLE IF EXISTS `cms_user`;
CREATE TABLE `cms_user`  (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '用户微信昵称',
  `nickname_a` varchar(255) NOT NULL DEFAULT '' COMMENT '用户微信昵称16进制',
  `username` varchar(100) NOT NULL DEFAULT '' COMMENT '账号',
  `password` varchar(100) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` varchar(100) NOT NULL DEFAULT '' COMMENT '密码盐',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '真实姓名',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机（也可以作为登录账号)',
  `mobile_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '手机绑定状态： 0未绑定 1已绑定',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `headimgurl` varchar(255) NOT NULL DEFAULT '' COMMENT '微信头像',
  `sex` tinyint(1) NOT NULL DEFAULT 0 COMMENT '性别 0:未知 1:女 2:男 ',    
  `desc` varchar(1000) NOT NULL DEFAULT '' COMMENT '个人简介',
  `birthday` int(11) NULL DEFAULT '0' COMMENT '生日',
  `country` varchar(20) NOT NULL DEFAULT '' COMMENT '国家',
  `province` varchar(20) NOT NULL DEFAULT '' COMMENT '省',
  `city` varchar(20) NOT NULL DEFAULT '' COMMENT '城市',  
  `company` varchar(100) NOT NULL DEFAULT '' COMMENT '公司',  
  `address` varchar(100) NOT NULL DEFAULT '' COMMENT '公司地址',
  `depament` varchar(20) NOT NULL DEFAULT '' COMMENT '部门',
  `position` varchar(20) NOT NULL DEFAULT '' COMMENT '职位',
  `puid` int(11) NOT NULL DEFAULT 0 COMMENT '推荐人ID,默认是0',
  `qrcode_invite` int(11) NOT NULL DEFAULT 0 COMMENT '邀请场景二维码id',  
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态  -1删除 0禁用 1正常 ',   
  `last_login_time` int(11) NOT NULL DEFAULT '0' COMMENT '最后登录时间',
  `last_login_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `login_num` int(11) NOT NULL DEFAULT '0',
  `register_time` int(11) NOT NULL DEFAULT '0' COMMENT '注册时间',
  `register_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '注册IP',
  `wx_platform` int(11) NOT NULL DEFAULT 0 COMMENT '首次注册来自于哪个微信平台',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT = '用户表';

-- ----------------------------
-- Table structure for `cms_user_log`
-- ----------------------------
DROP TABLE IF EXISTS `cms_user_log`;
CREATE TABLE `cms_user_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `type` varchar(80) NOT NULL DEFAULT '' COMMENT '操作类型',
  `title` varchar(80) NOT NULL DEFAULT '' COMMENT '操作标题',
  `content` text COMMENT '操作描述',
  `module` varchar(32) NOT NULL DEFAULT '' COMMENT '模块',
  `controller` varchar(32) NOT NULL DEFAULT '' COMMENT '控制器',
  `function` varchar(32) NOT NULL DEFAULT '' COMMENT '方法',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '登录ip',
  `param_id` int(11) unsigned NOT NULL COMMENT '操作ID',
  `param` text COMMENT '参数json格式',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0删除 1正常',
  `create_time` int(11) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='用户操作日志表';

-- ----------------------------
-- Table structure for `cms_file`
-- ----------------------------
DROP TABLE IF EXISTS `cms_file`;
CREATE TABLE `cms_file` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(15) NOT NULL DEFAULT '' COMMENT '所属模块',
  `sha1` varchar(60) NOT NULL COMMENT 'sha1',
  `md5` varchar(60) NOT NULL COMMENT 'md5',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `filepath` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径+文件名',
  `filesize` int(10)  NOT NULL DEFAULT 0 COMMENT '文件大小',
  `fileext` varchar(10) NOT NULL DEFAULT '' COMMENT '文件后缀',
  `mimetype` varchar(100) NOT NULL DEFAULT '' COMMENT '文件类型',
  `user_id` int(11) unsigned NOT NULL DEFAULT 0 COMMENT '上传会员ID',
  `uploadip` varchar(15) NOT NULL DEFAULT '' COMMENT '上传IP',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0未审核1已审核-1不通过',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `admin_id` int(11) NOT NULL COMMENT '审核者id',
  `audit_time` int(11) NOT NULL DEFAULT '0' COMMENT '审核时间',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '来源模块功能',
  `use` varchar(255) NULL DEFAULT NULL COMMENT '用处',
  `download` int(11) NOT NULL DEFAULT 0 COMMENT '下载量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET = utf8mb4 COMMENT='文件表';
