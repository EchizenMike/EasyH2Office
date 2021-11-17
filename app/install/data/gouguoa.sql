/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50644
 Source Host           : localhost:3306
 Source Schema         : house

 Target Server Type    : MySQL
 Target Server Version : 50644
 File Encoding         : 65001

 Date: 16/11/2021 15:16:59
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for oa_admin
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin`;
CREATE TABLE `oa_admin`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL DEFAULT '' COMMENT '登录用户名',
  `pwd` varchar(100) NOT NULL DEFAULT '' COMMENT '登录密码',
  `salt` varchar(100) NOT NULL DEFAULT '' COMMENT '密码盐',
  `reg_pwd` varchar(100) NOT NULL DEFAULT '' COMMENT '初始密码',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '员工姓名',
  `mobile` bigint(11) NOT NULL DEFAULT 0 COMMENT '手机号码',
  `sex` int(255) NOT NULL DEFAULT 0 COMMENT '性别1男,2女',
  `nickname` varchar(255) NOT NULL DEFAULT '' COMMENT '昵称',
  `thumb` varchar(255) NOT NULL COMMENT '头像',
  `did` int(11) NOT NULL DEFAULT 0 COMMENT '部门id',
  `position_id` int(11) NOT NULL DEFAULT 0 COMMENT '职位id',
  `type` int(1) NOT NULL DEFAULT 0 COMMENT '员工类型：0未设置,1正式,2试用,3实习',
  `desc` text NULL COMMENT '员工个人简介',
  `entry_time` int(11) NOT NULL DEFAULT 0 COMMENT '员工入职日期',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '注册时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新信息时间',
  `last_login_time` int(11) NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `login_num` int(11) NOT NULL DEFAULT 0 COMMENT '登录次数',
  `last_login_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除,0禁止登录,1正常,2离职',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '员工表';

-- ----------------------------
-- Table structure for oa_admin_group
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_group`;
CREATE TABLE `oa_admin_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `rules` varchar(1000) NULL DEFAULT '' COMMENT '用户组拥有的规则id， 多个规则\",\"隔开',
  `menus` varchar(1000) NULL DEFAULT '',
  `desc` text NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '员工权限分组表';

-- ----------------------------
-- Records of cms_admin_group
-- ----------------------------
INSERT INTO `oa_admin_group` VALUES ('1', '超级员工权限', '1', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113', '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43', '超级员工权限，拥有系统的最高权限，不可修改', '0', '0');

-- ----------------------------
-- Table structure for oa_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_log`;
CREATE TABLE `oa_admin_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '姓名',
  `type` varchar(80) NOT NULL DEFAULT '' COMMENT '操作类型',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '操作标题',
  `content` text NULL COMMENT '操作描述',
  `module` varchar(32) NOT NULL DEFAULT '' COMMENT '模块',
  `controller` varchar(32) NOT NULL DEFAULT '' COMMENT '控制器',
  `function` varchar(32) NOT NULL DEFAULT '' COMMENT '方法',
  `rule_menu` varchar(255) NOT NULL DEFAULT '' COMMENT '节点权限路径',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '登录ip',
  `param_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作数据id',
  `param` text NULL COMMENT '参数json格式',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0删除 1正常',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '员工操作日志表';

-- ----------------------------
-- Table structure for oa_admin_menu
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_menu`;
CREATE TABLE `oa_admin_menu`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT 0,
  `title` varchar(255) NOT NULL DEFAULT '标题',
  `src` varchar(255) NULL DEFAULT '链接',
  `icon` varchar(255) NULL DEFAULT '图标',
  `sort` int(11) NOT NULL DEFAULT 1 COMMENT '越大越靠前',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '后台菜单';

-- ----------------------------
-- Records of oa_admin_menu
-- ----------------------------
INSERT INTO `oa_admin_menu` VALUES (1, 0, '系统管理', '', 'icon-jichupeizhi', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (2, 0, '基础数据', '', 'icon-hetongshezhi', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (3, 0, '人力资源', '', 'icon-renshishezhi', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (4, 0, '消息通知', '', 'icon-xiaoxishezhi', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (5, 0, '企业公告', '', 'icon-zhaoshengbaobiao', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (6, 0, '知识文章', '', 'icon-kecheng', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (7, 0, '日常办公', '', 'icon-kaoshijihua', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (8, 0, '财务管理', '', 'icon-yuangongtidian', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (9, 0, '商业智能', '', 'icon-jiaoxuetongji', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (10, 1, '系统配置', 'home/conf/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (11, 1, '功能菜单', 'home/menu/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (12, 1, '功能节点', 'home/rule/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (13, 1, '权限角色', 'home/role/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (14, 1, '操作日志', 'home/admin/log', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (15, 1, '数据备份', 'home/database/database', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (16, 1, '数据还原', 'home/database/backuplist', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (17, 2, '审核人相关配置', 'home/check/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (18, 2, '工作类型设置', 'home/schedule/cate', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (19, 2, '知识关键字设置', 'home/keywords/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (20, 2, '报销类型设置', 'home/expense/cate', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (21, 2, '发票主体设置', 'home/invoice/subject', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (22, 3, '部门架构', 'home/department/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (23, 3, '岗位职称', 'home/position/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (24, 3, '企业员工', 'home/admin/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (25, 3, '人事调动', 'home/personnel/chage', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (26, 3, '离职档案', 'home/personnel/leave', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (27, 4, '收件箱', 'home/mail/inbox', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (28, 4, '已发送', 'home/mail/sendbox', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (29, 4, '草稿箱', 'home/mail/draft', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (30, 4, '垃圾箱', 'home/mail/rubbish', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (31, 5, '公告类别', 'home/note/cate', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (32, 5, '公告列表', 'home/note/index', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (33, 6, '知识类别', 'home/article/cate', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (34, 6, '共享知识', 'home/article/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (35, 6, '个人知识', 'home/article/list', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (36, 7, '工作计划', 'home/plan/list', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (37, 7, '计划日历', 'home/plan/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (38, 7, '工作记录', 'home/schedule/list', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (39, 7, '工作日历', 'home/schedule/index', '', 1, 0, 0);

INSERT INTO `oa_admin_menu` VALUES (40, 8, '报销管理', 'home/expense/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (41, 8, '发票管理', 'home/invoice/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (42, 8, '到账管理', 'home/income/index', '', 1, 0, 0);
INSERT INTO `oa_admin_menu` VALUES (43, 9, '日志分析', 'home/analysis/list', '', 1, 0, 0);

-- ----------------------------
-- Table structure for oa_admin_rule
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_rule`;
CREATE TABLE `oa_admin_rule`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `src` varchar(255) NOT NULL DEFAULT '' COMMENT '规则',
  `title` varchar(255) NOT NULL DEFAULT '规则标题',
  `name` varchar(255) NOT NULL DEFAULT '操作名称',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '权限节点';


-- ----------------------------
-- Records of oa_admin_rule
-- ----------------------------
INSERT INTO `oa_admin_rule` VALUES (1, 0, '', '系统管理','系统管理', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (2, 0, '', '基础数据','基础数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (3, 0, '', '人力资源','人力资源', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (4, 0, '', '消息通知','消息通知', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (5, 0, '', '企业公告','企业公告', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (6, 0, '', '知识文章','知识文章', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (7, 0, '', '日常办公','日常办公', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (8, 0, '', '财务管理','财务管理', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (9, 0, '', '商业智能','商业智能', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (10, 1, 'home/conf/index', '系统配置','系统配置', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (11, 10, 'home/conf/add', '新增/编辑配置项','配置项', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (12, 10, 'home/conf/edit', '新增/编辑配置详情','配置详情', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (13, 10, 'home/conf/delete', '删除配置项','配置项', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (14, 1, 'home/menu/index', '功能菜单','功能菜单', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (15, 14, 'home/menu/add', '新增/编辑功能菜单','功能菜单', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (16, 14, 'home/menu/delete', '删除功能菜单','功能菜单', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (17, 1, 'home/rule/index', '功能节点','功能节点', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (18, 17, 'home/rule/add', '新增/编辑功能节点','功能节点', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (19, 17, 'home/rule/delete', '删除功能节点','功能节点', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (20, 1, 'home/role/index', '权限角色','权限角色', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (21, 20, 'home/role/add', '新增/编辑权限角色','权限角色', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (22, 20, 'home/role/delete', '删除权限角色','权限角色', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (23, 1, 'home/admin/log', '操作日志','操作日志', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (24, 1, 'home/database/database', '备份数据','备份数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (25, 24, 'home/database/backup', '备份数据表','备份数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (26, 24, 'home/database/optimize', '优化数据表','优化数据表', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (27, 24, 'home/database/repair', '修复数据表','修复数据表', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (28, 1, 'home/database/backuplist', '还原数据','还原数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (29, 28, 'home/database/import', '还原数据表','还原数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (30, 28, 'home/database/downfile', '下载备份数据','下载备份数据', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (31, 28, 'home/database/del', '删除备份数据','删除备份数据', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (32, 2, 'home/check/index', '审核人配置','审核人', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (33, 32, 'home/check/add', '新增/编辑审核人','审核人', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (34, 32, 'home/check/delete', '删除审核人','审核人', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (35, 2, 'home/schedule/cate', '工作类型设置','工作类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (36, 35, 'home/schedule/cate_add', '新增/编辑工作类型','工作类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (37, 35, 'home/schedule/cate_disable', '禁用工作类型','工作类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (38, 35, 'home/schedule/cate_delete', '删除工作类型','工作类型', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (39, 2, 'home/keywords/index', '知识关键字设置','知识关键字', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (40, 39, 'home/keywords/add', '新增/编辑知识关键字','知识关键字', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (41, 39, 'home/keywords/delete', '删除知识关键字','知识关键字', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (42, 2, 'home/expense/cate', '报销类型设置','报销类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (43, 42, 'home/expense/cate_add', '新增/编辑报销类型','报销类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (44, 42, 'home/expense/cate_disable', '禁用报销类型','报销类型', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (45, 42, 'home/expense/cate_delete', '删除报销类型','报销类型', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (46, 2, 'home/invoice/subject', '发票主体设置','发票主体', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (47, 46, 'home/invoice/subject_add', '新增/编辑发票主体','发票主体', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (48, 46, 'home/invoice/subject_disable', '禁用发票主体','发票主体', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (49, 46, 'home/invoice/subject_delete', '删除发票主体','发票主体', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (50, 3, 'home/department/index', '部门架构','部门', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (51, 50, 'home/department/add', '添加/编辑部门信息','部门', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (52, 50, 'home/department/delete', '删除部门','部门', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (53, 3, 'home/position/index', '岗位职称','岗位职称', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (54, 53, 'home/position/add', '添加/编辑岗位职称','岗位职称', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (55, 53, 'home/position/delete', '删除岗位职称','岗位职称', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (56, 53, 'home/position/view', '查看岗位职称','岗位职称', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (57, 3, 'home/admin/index', '企业员工','员工', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (58, 57, 'home/admin/add', '添加/编辑员工','员工', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (59, 57, 'home/admin/view', '查看员工信息','员工', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (60, 57, 'home/admin/set', '设置员工状态','员工状态', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (61, 57, 'home/admin/reset_psw', '重设员工密码','员工密码', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (62, 3, 'home/personnel/index', '人事调动','人事调动', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (63, 62, 'home/personnel/add', '新增/编辑人事调动','人事调动', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (64, 3, 'home/personnel/index', '离职档案','离职档案', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (65, 64, 'home/personnel/add', '新增/编辑离职档案','离职档案', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (66, 64, 'home/personnel/delete', '删除离职档案','离职档案', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (67, 4, 'home/mail/inbox', '收件箱','收件箱', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (68, 67, 'home/mail/add', '添加/修改消息','消息', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (69, 67, 'home/mail/send', '发送消息','消息', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (70, 67, 'home/mail/save', '保存消息到草稿','消息到草稿', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (71, 67, 'home/mail/reply', '回复消息','消息', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (72, 67, 'home/mail/check', '设置消息状态','消息状态', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (73, 67, 'home/mail/read', '查看消息','消息', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (74, 4, 'home/mail/sendbox', '发件箱','发件箱', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (75, 4, 'home/mail/draft', '草稿箱','草稿箱', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (76, 4, 'home/mail/rubbish', '垃圾箱','垃圾箱', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (77, 5, 'home/note/cate', '公告分类','公告分类', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (78, 77, 'home/note/cate_add', '添加/修改公告分类','公告分类', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (79, 77, 'home/note/cate_delete', '删除公告分类','公告分类', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (80, 5, 'home/note/index', '公告列表','公告', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (81, 80, 'home/note/add', '添加公告','公告', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (82, 80, 'home/note/delete', '删除公告','公告', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (83, 80, 'home/note/view', '查看公告','公告', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (84, 6, 'home/article/cate', '知识分类','知识分类', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (85, 84, 'home/article/cate_add', '添加/修改知识分类','知识分类', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (86, 84, 'home/article/cate_delete', '删除知识分类','知识分类', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (87, 6, 'home/article/index', '知识列表','知识文章', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (88, 87, 'home/article/add', '添加/修改知识文章','知识文章', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (89, 87, 'home/article/delete', '删除知识文章','知识文章', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (90, 87, 'home/article/view', '查看知识文章','知识文章', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (91, 7, 'home/plan/index', '工作计划','工作计划', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (92, 91, 'home/plan/calendar', '工作计划日历','工作计划', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (93, 91, 'home/plan/add', '添加/编辑工作计划','工作计划', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (94, 91, 'home/plan/delete', '删除工作计划','工作计划', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (95, 91, 'home/plan/detail', '查看工作计划','工作计划', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (96, 7, 'home/schedule/index', '工作记录','工作记录', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (97, 96, 'home/schedule/calendar', '工作记录日历','工作日历', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (98, 96, 'home/schedule/add', '添加/编辑工作记录','工作记录', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (99, 96, 'home/schedule/delete', '删除工作记录','工作记录', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (100, 96, 'home/schedule/detail', '查看工作记录','工作记录', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (101, 96, 'home/schedule/update_labor_time', '更改工时','工时', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (102, 8, 'home/expense/index', '报销管理','报销', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (103, 102, 'home/expense/add', '新增/编辑报销','报销', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (104, 102, 'home/expense/delete', '删除报销','报销', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (105, 102, 'home/expense/view', '查看报销信息','报销', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (106, 102, 'home/expense/check', '设置报销状态','报销状态', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (107, 8, 'home/invoice/index', '发票管理','发票', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (108, 107, 'home/invoice/add', '新增/编辑发票','发票', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (109, 107, 'home/invoice/delete', '删除发票','发票', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (110, 107, 'home/invoice/view', '查看发票信息','发票', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (111, 107, 'home/invoice/check', '设置发票状态','发票状态', 0, 0);

INSERT INTO `oa_admin_rule` VALUES (112, 8, 'home/income/index', '到账管理','到账', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (113, 112, 'home/income/add', '新增到账','到账', 0, 0);
INSERT INTO `oa_admin_rule` VALUES (114, 112, 'home/income/check', '设置到账状态','到账状态', 0, 0);

-- ----------------------------
-- Table structure for oa_article
-- ----------------------------
DROP TABLE IF EXISTS `oa_article`;
CREATE TABLE `oa_article`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '知识文章标题',
  `keywords` varchar(255) NULL DEFAULT '' COMMENT '关键字',
  `desc` varchar(1000) NULL DEFAULT '' COMMENT '摘要',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '状态:1正常-1下架',
  `thumb` int(11) NOT NULL DEFAULT 0 COMMENT '缩略图id',
  `original` int(1) NOT NULL DEFAULT 0 COMMENT '是否原创，1原创',
  `origin` varchar(255) NOT NULL DEFAULT '' COMMENT '来源或作者',
  `origin_url` varchar(255) NOT NULL DEFAULT '' COMMENT '来源地址',
  `content` text NOT NULL,
  `read` int(11) NOT NULL DEFAULT 0 COMMENT '阅读量',
  `type` tinyint(2) NOT NULL DEFAULT 0 COMMENT '属性：1精华 2热门 3推荐',
  `is_share` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否分享，0否，1是',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `article_cate_id` int(11) NOT NULL DEFAULT 0,
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  `delete_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '知识文章表';

-- ----------------------------
-- Table structure for oa_article_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_article_cate`;
CREATE TABLE `oa_article_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT 0 COMMENT '父类ID',
  `sort` int(5) NOT NULL DEFAULT 0 COMMENT '排序',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '分类标题',
  `desc` varchar(1000) NULL DEFAULT '' COMMENT '描述',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '知识文章分类表';

-- ----------------------------
-- Table structure for oa_article_keywords
-- ----------------------------
DROP TABLE IF EXISTS `oa_article_keywords`;
CREATE TABLE `oa_article_keywords`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `aid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '知识文章ID',
  `keywords_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联关键字id',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `aid`(`aid`) USING BTREE,
  INDEX `inid`(`keywords_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '知识文章关联表';

-- ----------------------------
-- Table structure for oa_config
-- ----------------------------
DROP TABLE IF EXISTS `oa_config`;
CREATE TABLE `oa_config`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '配置名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '配置标识',
  `content` text NULL COMMENT '配置内容',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COMMENT = '系统配置表';

-- ----------------------------
-- Records of oa_config
-- ----------------------------
INSERT INTO `oa_config`(`id`, `title`, `name`, `content`, `status`, `create_time`, `update_time`) VALUES (1, '网站配置', 'web', 'a:13:{s:2:\"id\";s:1:\"1\";s:11:\"admin_title\";s:18:\"勾股办公系统\";s:5:\"title\";s:18:\"勾股办公系统\";s:4:\"logo\";s:52:\"/storage/202111/fc507cc8332d5ef49d9425185e4a9697.jpg\";s:4:\"file\";s:0:\"\";s:6:\"domain\";s:24:\"https://www.gougucms.com\";s:3:\"icp\";s:23:\"粤ICP备1xxxxxx11号-1\";s:8:\"keywords\";s:9:\"勾股cms\";s:5:\"beian\";s:29:\"粤公网安备1xxxxxx11号-1\";s:4:\"desc\";s:478:\"勾股办公是一款基于ThinkPHP6 + Layui + MySql打造的，简单实用的开源免费的企业办公系统框架。系统集成了系统设置、人事管理模块、消息管理模块、日常办公、财务管理等基础模块。系统简约，易于功能扩展，方便二次开发，让开发者更专注于业务深度需求的开发，帮助开发者简单高效降低二次开发成本，通过二次开发之后可以用来做CRM，ERP，业务管理等系统。\";s:4:\"code\";s:0:\"\";s:9:\"copyright\";s:32:\"© 2021 gougucms.com MIT license\";s:7:\"version\";s:5:\"1.0.2\";}', 1, 1612514630, 1637075196);
INSERT INTO `oa_config`(`id`, `title`, `name`, `content`, `status`, `create_time`, `update_time`) VALUES (2, '邮箱配置', 'email', 'a:8:{s:2:\"id\";s:1:\"2\";s:4:\"smtp\";s:11:\"smtp.qq.com\";s:9:\"smtp_port\";s:3:\"465\";s:9:\"smtp_user\";s:15:\"gougucms@qq.com\";s:8:\"smtp_pwd\";s:6:\"123456\";s:4:\"from\";s:24:\"勾股CMS系统管理员\";s:5:\"email\";s:18:\"admin@gougucms.com\";s:8:\"template\";s:485:\"<p>勾股办公是一款基于ThinkPHP6 + Layui + MySql打造的，简单实用的开源免费的企业办公系统框架。系统集成了系统设置、人事管理模块、消息管理模块、日常办公、财务管理等基础模块。系统简约，易于功能扩展，方便二次开发，让开发者更专注于业务深度需求的开发，帮助开发者简单高效降低二次开发成本，通过二次开发之后可以用来做CRM，ERP，业务管理等系统。</p>\";}', 1, 1612521657, 1637075205);
INSERT INTO `oa_config`(`id`, `title`, `name`, `content`, `status`, `create_time`, `update_time`) VALUES (3, 'Api Token配置', 'token', 'a:5:{s:2:\"id\";s:1:\"4\";s:3:\"iss\";s:16:\"www.gougucms.com\";s:3:\"aud\";s:8:\"gougucms\";s:7:\"secrect\";s:8:\"GOUGUCMS\";s:7:\"exptime\";s:4:\"3600\";}', 1, 1627313142, 1635953635);
INSERT INTO `oa_config`(`id`, `title`, `name`, `content`, `status`, `create_time`, `update_time`) VALUES (4, '其他配置', 'other', 'a:3:{s:2:\"id\";s:1:\"5\";s:6:\"author\";s:15:\"勾股工作室\";s:7:\"version\";s:13:\"v1.2021.07.28\";}', 1, 1613725791, 1635953640);


-- ----------------------------
-- Table structure for oa_check
-- ----------------------------
DROP TABLE IF EXISTS `oa_check`;
CREATE TABLE `oa_check`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核人ID',
  `type` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '审核类型 1报销审核人 2报销打款确认人 3发票审核人 4发票开票人',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '审核人配置表';

-- ----------------------------
-- Records of oa_check
-- ----------------------------
INSERT INTO `oa_check`(`id`, `uid`, `type`, `remark`, `status`, `create_time`, `update_time`) VALUES (1, 1, 1, '初始化设置', 1, 1558681814, 0);
INSERT INTO `oa_check`(`id`, `uid`, `type`, `remark`, `status`, `create_time`, `update_time`) VALUES (2, 1, 2, '初始化设置', 1, 1558681814, 0);
INSERT INTO `oa_check`(`id`, `uid`, `type`, `remark`, `status`, `create_time`, `update_time`) VALUES (3, 1, 3, '初始化设置', 1, 1558681814, 0);
INSERT INTO `oa_check`(`id`, `uid`, `type`, `remark`, `status`, `create_time`, `update_time`) VALUES (4, 1, 4, '初始化设置', 1, 1558681814, 0);

-- ----------------------------
-- Table structure for oa_department
-- ----------------------------
DROP TABLE IF EXISTS `oa_department`;
CREATE TABLE `oa_department`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '部门名称',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级部门id',
  `leader_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '部门负责人ID',
  `phone` varchar(60) NOT NULL DEFAULT '' COMMENT '部门联系电话',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '部门组织';

-- ----------------------------
-- Records of oa_department
-- ----------------------------
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (1, '董事会', 0, 0, '13688888888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (2, '人事部', 1, 0, '13688888889', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (3, '财务部', 1, 0, '13688888898', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (4, '市场部', 1, 0, '13688888988', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (5, '销售部', 1, 0, '13688889888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (6, '技术部', 1, 0, '13688898888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (7, '客服部', 1, 0, '13688988888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (8, '销售一部', 5, 0, '13688998888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (9, '销售二部', 5, 0, '13688999888', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (10, '销售三部', 5, 0, '13688999988', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (11, '产品部', 6, 0, '13688888886', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (12, '设计部', 6, 0, '13688888866', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (13, '研发部', 6, 0, '13688888666', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (14, '客服一部', 7, 0, '13688888885', '', 1, 0, 0);
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`, `remark`, `status`, `create_time`, `update_time`) VALUES (15, '客服二部', 7, 0, '13688888855', '', 1, 0, 0);

-- ----------------------------
-- Table structure for oa_expense
-- ----------------------------
DROP TABLE IF EXISTS `oa_expense`;
CREATE TABLE `oa_expense`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL DEFAULT '' COMMENT '报销编码',
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '报销人员ID',
  `did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '报销部门ID',
  `income_month` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '入账月份',
  `expense_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '原始单据日期',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `ptid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预定字段:关联项目ID',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `check_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核人ID',
  `check_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核时间',
  `check_status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '报销状态:0审核不通过,1申请审核中,1审核通过,2已打款',
  `check_remark` text NULL COMMENT '审核不通过的理由',
  `pay_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '打款人ID',
  `pay_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '打款时间',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '报销表';

-- ----------------------------
-- Table structure for oa_expense_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_expense_cate`;
CREATE TABLE `oa_expense_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '报销类型名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '报销类型';

-- ----------------------------
-- Table structure for oa_expense_file_interfix
-- ----------------------------
DROP TABLE IF EXISTS `oa_expense_file_interfix`;
CREATE TABLE `oa_expense_file_interfix`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `exid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '报销ID',
  `file_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相关联附件id',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '报销模块关联的附件表';

-- ----------------------------
-- Table structure for oa_expense_interfix
-- ----------------------------
DROP TABLE IF EXISTS `oa_expense_interfix`;
CREATE TABLE `oa_expense_interfix`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `exid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '报销ID',
  `amount` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '金额',
  `cate_id` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '报销类型ID',
  `remarks` text NULL COMMENT '备注',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '登记人',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '报销关联数据表';

-- ----------------------------
-- Table structure for oa_file
-- ----------------------------
DROP TABLE IF EXISTS `oa_file`;
CREATE TABLE `oa_file`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `module` varchar(15) NOT NULL DEFAULT '' COMMENT '所属模块',
  `sha1` varchar(60) NOT NULL COMMENT 'sha1',
  `md5` varchar(60) NOT NULL COMMENT 'md5',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '原始文件名',
  `filename` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `filepath` varchar(255) NOT NULL DEFAULT '' COMMENT '文件路径+文件名',
  `filesize` int(10) NOT NULL DEFAULT 0 COMMENT '文件大小',
  `fileext` varchar(10) NOT NULL DEFAULT '' COMMENT '文件后缀',
  `mimetype` varchar(100) NOT NULL DEFAULT '' COMMENT '文件类型',
  `user_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上传会员ID',
  `uploadip` varchar(15) NOT NULL DEFAULT '' COMMENT '上传IP',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0未审核1已审核-1不通过',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `admin_id` int(11) NOT NULL COMMENT '审核者id',
  `audit_time` int(11) NOT NULL DEFAULT 0 COMMENT '审核时间',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '来源模块功能',
  `use` varchar(255) NULL DEFAULT NULL COMMENT '用处',
  `download` int(11) NOT NULL DEFAULT 0 COMMENT '下载量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '文件表';

-- ----------------------------
-- Table structure for oa_invoice
-- ----------------------------
DROP TABLE IF EXISTS `oa_invoice`;
CREATE TABLE `oa_invoice`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL DEFAULT '' COMMENT '发票号码',
  `cmid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预定字段:关联客户ID',
  `crid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预定字段:关联合同协议号ID',
  `ptid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预定字段:关联项目ID',
  `sid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联发票主体ID',
  `cash_type` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '付款方式：1现金 2转账 3微信支付 4支付宝 5信用卡 6支票 7其他',
  `is_cash` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否直接到账：0否 1是',
  `remark_desc` text NULL COMMENT '备注',
  `amount` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '发票金额',
  `enter_amount` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '到账金额',
  `did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开发票部门',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票申请人',
  `check_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票审核人',
  `open_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票开具人',
  `invoice_type` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '发票类型：0普票 1专票',
  `invoice_tax` varchar(100) NOT NULL DEFAULT '' COMMENT '纳税人识别号',
  `invoice_title` varchar(100) NOT NULL DEFAULT '' COMMENT '纳税人名称',
  `invoice_bank` varchar(100) NOT NULL DEFAULT '' COMMENT '开户银行',
  `invoice_banking` varchar(100) NOT NULL DEFAULT '' COMMENT '银行营业网点',
  `invoice_account` varchar(100) NOT NULL DEFAULT '' COMMENT '银行账号',
  `invoice_phone` varchar(100) NOT NULL DEFAULT '' COMMENT '电话号码',
  `invoice_address` varchar(100) NOT NULL DEFAULT '' COMMENT '地址',
  `invoice_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '发票状态:0审核不通过 1审核中 2审核通过 3待开具 4已开具 5部分到账 6全部到账 10已作废',
  `check_remark` text NULL COMMENT '审核不通过的理由',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1正常',
  `enter_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最新到账时间',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '发票表';

-- ----------------------------
-- Table structure for oa_invoice_income
-- ----------------------------
DROP TABLE IF EXISTS `oa_invoice_income`;
CREATE TABLE `oa_invoice_income`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `inid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票ID',
  `amount` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '到账金额',
  `remarks` text NULL COMMENT '备注',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '到账登记人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1正常 6作废',
  `enter_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '到账时间',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '发票到账记录表';

-- ----------------------------
-- Table structure for oa_invoice_subject
-- ----------------------------
DROP TABLE IF EXISTS `oa_invoice_subject`;
CREATE TABLE `oa_invoice_subject`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '主体名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '发票主体名称';

-- ----------------------------
-- Table structure for oa_keywords
-- ----------------------------
DROP TABLE IF EXISTS `oa_keywords`;
CREATE TABLE `oa_keywords`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '关键字名称',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '关键字表';

-- ----------------------------
-- Table structure for oa_mail
-- ----------------------------
DROP TABLE IF EXISTS `oa_mail`;
CREATE TABLE `oa_mail`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '消息主题',
  `type` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '阅览人类型：0 人员 1部门 2岗位 3全部',
  `type_user` text NULL COMMENT '人员ID或部门ID或角色ID，全员则为空',
  `mail_type` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '消息类型：1系统消息，2同事消息',
  `from_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送人id',
  `to_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '接收人id',
  `send_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发送日期',
  `content` text NULL COMMENT '消息内容',
  `is_read` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否已读：1未读消息，2已读消息',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人所属部门',
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '来源发件id',
  `fid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '转发或回复消息关联id',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1已删除消息 0垃圾消息 1正常消息',
  `is_draft` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否是草稿：1正常消息 2草稿消息',
  `delete_source` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '垃圾消息来源： 1已发消息 2草稿消息 3已收消息',
  `action` varchar(50) NOT NULL DEFAULT '' COMMENT '来源模块（针对系统消息）',
  `action_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '来源模块数据的id（针对系统消息）',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '消息表';

-- ----------------------------
-- Table structure for oa_mail_file_interfix
-- ----------------------------
DROP TABLE IF EXISTS `oa_mail_file_interfix`;
CREATE TABLE `oa_mail_file_interfix`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mid` int(11) UNSIGNED NOT NULL COMMENT '消息id',
  `file_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相关联附件id',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mid`(`mid`) USING BTREE,
  INDEX `fid`(`file_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '消息关联的附件表';

-- ----------------------------
-- Table structure for oa_note
-- ----------------------------
DROP TABLE IF EXISTS `oa_note`;
CREATE TABLE `oa_note`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cate_id` int(11) NOT NULL DEFAULT 0 COMMENT '关联分类ID',
  `title` varchar(225) NULL DEFAULT NULL COMMENT '标题',
  `content` varchar(100) NULL DEFAULT NULL COMMENT '内容',
  `src` varchar(100) NULL DEFAULT NULL COMMENT '关联链接',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '1可用-1禁用',
  `sort` int(11) NOT NULL DEFAULT 0,
  `start_time` int(11) NOT NULL DEFAULT 0 COMMENT '展示开始时间',
  `end_time` int(11) NOT NULL DEFAULT 0 COMMENT '展示结束时间',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '公告';

-- ----------------------------
-- Table structure for oa_note_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_note_cate`;
CREATE TABLE `oa_note_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT 0 COMMENT '父类ID',
  `sort` int(5) NOT NULL DEFAULT 0 COMMENT '排序',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '标题',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '公告分类';

-- ----------------------------
-- Table structure for oa_position
-- ----------------------------
DROP TABLE IF EXISTS `oa_position`;
CREATE TABLE `oa_position`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '岗位名称',
  `work_price` int(10) NOT NULL DEFAULT 0 COMMENT '工时单价',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '岗位职称';

-- ----------------------------
-- Records of oa_position
-- ----------------------------
INSERT INTO `oa_position`(`id`, `title`, `work_price`, `remark`, `status`, `create_time`, `update_time`) VALUES (1, '超级岗位', 200, '超级岗位，不能轻易修改权限', 1, 0, 0);

-- ----------------------------
-- Table structure for oa_position_group
-- ----------------------------
DROP TABLE IF EXISTS `oa_position_group`;
CREATE TABLE `oa_position_group`  (
  `pid` int(11) UNSIGNED NULL DEFAULT NULL,
  `group_id` int(11) NULL DEFAULT NULL,
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  UNIQUE INDEX `pid_group_id`(`pid`, `group_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COMMENT = '权限分组和岗位的关联表';

-- ----------------------------
-- Records of oa_position_group
-- ----------------------------
INSERT INTO `oa_position_group`(`pid`, `group_id`, `create_time`, `update_time`) VALUES (1, 1, 1635755739, 0);

-- ----------------------------
-- Table structure for oa_schedule
-- ----------------------------
DROP TABLE IF EXISTS `oa_schedule`;
CREATE TABLE `oa_schedule`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '工作记录主题',
  `cid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预设字段:关联工作内容类型ID',
  `cmid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预设字段:关联客户ID',
  `ptid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预设字段:关联项目ID',
  `plid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '预设字段:关联任务计划ID',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联创建员工ID',
  `did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属部门',
  `start_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始时间',
  `end_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  `labor_time` decimal(15, 1) NOT NULL DEFAULT 0.0 COMMENT '工时',
  `labor_type` int(1) NOT NULL DEFAULT 0 COMMENT '工作类型:1案头2外勤',
  `remark` text NOT NULL COMMENT '描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '工作记录';

-- ----------------------------
-- Table structure for oa_schedule_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_schedule_cate`;
CREATE TABLE `oa_schedule_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '工作类型名称',
  `did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联部门id',
  `service_cate_id` int(11) NOT NULL DEFAULT 0 COMMENT '预留字段：关联业务类型id',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '工作类型表';

-- ----------------------------
-- Table structure for oa_schedule_interfix
-- ----------------------------
DROP TABLE IF EXISTS `oa_schedule_interfix`;
CREATE TABLE `oa_schedule_interfix`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `scid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '工作记录ID',
  `file_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相关联附件id',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联创建员工ID',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '工作记录关联的附件表';
