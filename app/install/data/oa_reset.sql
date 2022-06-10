-- ----------------------------
-- Table structure for oa_admin_group
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_group`;
CREATE TABLE `oa_admin_group`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `status` int(1) NOT NULL DEFAULT 1,
  `rules` varchar(1000) NULL DEFAULT '' COMMENT '用户组拥有的规则id， 多个规则\",\"隔开',
  `desc` text NULL COMMENT '备注',
  `create_time` int(11) NOT NULL DEFAULT 0,
  `update_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '员工权限分组表';

-- ----------------------------
-- Records of cms_admin_group
-- ----------------------------
INSERT INTO `oa_admin_group` VALUES (1, '超级员工权限', 1, '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142',  '超级员工权限，拥有系统的最高权限，不可修改', 0, 0);
INSERT INTO `oa_admin_group` VALUES (2, '人事总监权限', 1, '2,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,3,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,4,78,79,80,81,82,83,84,85,86,87,5,88,89,90,91,6,92,93,94,95,96,7,97,100,101,102,98,99,8,103,105,106,107,104,108,110,111,112,113,109,114,115,116,117,118,9,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,10,142', '人力资源部门领导的最高管理权限', 0, 0);

-- ----------------------------
-- Table structure for oa_admin_module
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_module`;
CREATE TABLE `oa_admin_module`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块标识唯一，字母',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '状态,0禁用,1正常',
  `type` int(1) NOT NULL DEFAULT 2 COMMENT '模块类型,2普通模块,1系统模块',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '功能模块表';

-- ----------------------------
-- Records of oa_admin_module
-- ----------------------------
INSERT INTO `oa_admin_module` VALUES (1, '系统模块', 'HOME', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (2, '用户模块', 'USER', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (3, '消息模块', 'MSG', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (4, '公告模块', 'NOTE', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (5, '知识模块', 'KQ', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (6, 'OA模块', 'OA', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (7, '财务模块', 'CF', '', 1, 1, 1639562910, 0);
INSERT INTO `oa_admin_module` VALUES (8, '统计模块', 'BI', '', 1, 1, 1639562910, 0);


-- ----------------------------
-- Table structure for oa_admin_rule
-- ----------------------------
DROP TABLE IF EXISTS `oa_admin_rule`;
CREATE TABLE `oa_admin_rule`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父id',
  `src` varchar(255) NOT NULL DEFAULT '' COMMENT 'url链接',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '日志操作名称',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT '所属模块',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `menu` int(1) NOT NULL DEFAULT 0 COMMENT '是否是菜单,1是,2不是',
  `sort` int(11) NOT NULL DEFAULT 1 COMMENT '越小越靠前',
  `status` int(1) NOT NULL DEFAULT 1 COMMENT '状态,0禁用,1正常',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '菜单及权限表';


-- ----------------------------
-- Records of oa_admin_rule
-- ----------------------------
INSERT INTO `oa_admin_rule` VALUES (1, 0, '', '系统管理', '系统管理', 'HOME', 'icon-jichupeizhi', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (2, 0, '', '基础数据', '基础数据', 'HOME', 'icon-hetongshezhi', 1, 2, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (3, 0, '', '员工管理', '员工管理', 'USER', 'icon-renshishezhi', 1, 3, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (4, 0, '', '消息通知', '消息通知', 'MSG', 'icon-xiaoxishezhi', 1, 4, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (5, 0, '', '企业公告', '企业公告', 'NOTE', 'icon-zhaoshengbaobiao', 1, 5, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (6, 0, '', '知识文章', '知识文章', 'KQ', 'icon-kecheng', 1, 6, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (7, 0, '', '办公审批', '办公审批', 'OA', 'icon-shenpishezhi', 1, 7, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (8, 0, '', '日常办公', '日常办公', 'OA', 'icon-kaoshijihua', 1, 8, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (9, 0, '', '财务管理', '财务管理', 'CF', 'icon-yuangongtidian', 1, 9, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (10, 0, '', '商业智能', '商业智能', 'BI', 'icon-jiaoxuetongji', 1, 10, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (11, 1, 'home/conf/index', '系统配置', '系统配置', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (12, 11, 'home/conf/add', '新建/编辑', '配置项', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (13, 11, 'home/conf/delete', '删除', '配置项', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (14, 11, 'home/conf/edit', '编辑', '配置详情', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (15, 1, 'home/module/index', '功能模块', '功能模块', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (16, 15, 'home/module/add', '新建/编辑', '功能模块', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (17, 15, 'home/module/disable', '禁用/启用', '功能模块', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (18, 1, 'home/rule/index', '功能节点', '功能节点', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (19, 18, 'home/rule/add', '新建/编辑', '功能节点', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (20, 18, 'home/rule/delete', '删除', '功能节点', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (21, 1, 'home/role/index', '权限角色', '权限角色', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (22, 21, 'home/role/add', '新建/编辑', '权限角色', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (23, 21, 'home/role/delete', '删除', '权限角色', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (24, 1, 'home/log/index', '操作日志', '操作日志', 'HOME', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (25, 1, 'home/database/database', '备份数据', '数据备份', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (26, 25, 'home/database/backup', '备份数据表', '数据', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (27, 25, 'home/database/optimize', '优化数据表', '数据表', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (28, 25, 'home/database/repair', '修复数据表', '数据表', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (29, 1, 'home/database/backuplist', '还原数据', '数据还原', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (30, 29, 'home/database/import', '还原数据表', '数据', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (31, 29, 'home/database/downfile', '下载备份数据', '备份数据', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (32, 29, 'home/database/del', '删除备份数据', '备份数据', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (33, 2, 'home/cate/flow_type', '审批类型', '审批类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (34, 33, 'home/cate/flow_type_add', '新建/编辑', '审批类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (35, 33, 'home/cate/flow_type_check', '设置', '审批类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (36, 2, 'home/flow/index', '审批流程', '审批流程', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (37, 36, 'home/flow/add', '新建/编辑', '审批流程', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (38, 36, 'home/flow/delete', '删除', '审批流程', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (39, 36, 'home/flow/check', '设置', '审批流程', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (40, 2, 'home/cate/expense_cate', '报销类型', '报销类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (41, 40, 'home/cate/expense_cate_add', '新建/编辑', '报销类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (42, 40, 'home/cate/expense_cate_check', '设置', '报销类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (43, 2, 'home/cate/cost_cate', '费用类型', '费用类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (44, 43, 'home/cate/cost_cate_add', '新建/编辑', '费用类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (45, 43, 'home/cate/cost_cate_check', '设置', '费用类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (46, 2, 'home/cate/seal_cate', '印章类型', '印章类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (47, 46, 'home/cate/seal_cate_add', '新建/编辑', '印章类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (48, 46, 'home/cate/seal_cate_check', '设置', '印章类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (49, 2, 'home/cate/car_cate', '车辆类型', '车辆类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (50, 49, 'home/cate/car_cate_add', '新建/编辑', '车辆类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (51, 49, 'home/cate/car_cate_check', '设置', '车辆类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (52, 2, 'home/cate/subject', '发票主体', '发票主体', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (53, 52, 'home/cate/subject_add', '新建/编辑', '发票主体', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (54, 52, 'home/cate/subject_check', '设置', '发票主体', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (55, 2, 'home/cate/note_cate', '公告类型', '公告类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (56, 55, 'home/cate/note_cate_add', '新建/编辑', '公告类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (57, 55, 'home/cate/note_cate_delete', '删除', '公告类型', 'HOME', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (58, 2, 'home/cate/article_cate', '知识类型', '知识类型', 'HOME', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (59, 58, 'home/cate/article_cate_add', '新建/编辑', '知识类型', 'HOME', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (60, 58, 'home/cate/article_cate_delete', '删除', '知识类型', 'HOME', '', 2, 1, 1, 0, 0);


INSERT INTO `oa_admin_rule` VALUES (61, 3, 'user/department/index', '部门架构', '部门', 'USER', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (62, 61, 'user/department/add', '新建/编辑', '部门', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (63, 61, 'user/department/delete', '删除', '部门', 'USER', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (64, 3, 'user/position/index', '岗位职称', '岗位职称', 'USER', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (65, 64, 'user/position/add', '新建/编辑', '岗位职称', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (66, 64, 'user/position/delete', '删除', '岗位职称', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (67, 64, 'user/position/view', '查看', '岗位职称', 'USER', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (68, 3, 'user/user/index', '企业员工', '员工', 'USER', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (69, 68, 'user/user/add', '新建/编辑', '员工', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (70, 68, 'user/user/view', '查看', '员工信息', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (71, 68, 'user/user/set', '设置', '员工状态', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (72, 68, 'user/user/reset_psw', '重设密码', '员工密码', 'USER', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (73, 3, 'user/personal/change', '人事调动', '人事调动', 'USER', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (74, 73, 'user/personal/change_add', '新建/编辑', '人事调动', 'USER', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (75, 3, 'user/personal/leave', '离职档案', '离职档案', 'USER', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (76, 75, 'user/personal/leave_add', '新建/编辑', '离职档案', 'USER', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (77, 75, 'user/personal/leave_delete', '删除', '离职档案', 'USER', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (78, 4, 'message/index/inbox', '收件箱', '收件箱', 'MSG', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (79, 78, 'message/index/add', '新建/编辑', '消息', 'MSG', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (80, 78, 'message/index/send', '发送', '消息', 'MSG', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (81, 78, 'message/index/save', '保存', '消息到草稿', 'MSG', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (82, 78, 'message/index/reply', '回复', '消息', 'MSG', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (83, 78, 'message/index/read', '查看', '消息', 'MSG', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (84, 78, 'message/index/check', '设置', '消息状态', 'MSG', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (85, 4, 'message/index/sendbox', '发件箱', '发件箱', 'MSG', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (86, 4, 'message/index/draft', '草稿箱', '草稿箱', 'MSG', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (87, 4, 'message/index/rubbish', '垃圾箱', '垃圾箱', 'MSG', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (88, 5, 'note/index/index', '公告列表', '公告', 'NOTE', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (89, 88, 'note/index/add', '新建/编辑', '公告', 'NOTE', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (90, 88, 'note/index/delete', '删除', '公告', 'NOTE', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (91, 88, 'note/index/view', '查看', '公告', 'NOTE', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (92, 6, 'article/index/index', '共享知识', '知识文章', 'KQ', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (93, 6, 'article/index/list', '个人知识', '知识文章', 'KQ', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (94, 93, 'article/index/add', '新建/编辑', '知识文章', 'KQ', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (95, 93, 'article/index/delete', '删除', '知识文章', 'KQ', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (96, 93, 'article/index/view', '查看', '知识文章', 'KQ', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (97, 7, 'oa/approve/index', '我发起的', '办公审批', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (98, 7, 'oa/approve/list', '我处理的', '办公审批', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (99, 7, 'oa/approve/copy', '抄送给我的', '办公审批', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (100, 97, 'oa/approve/add', '新建/编辑', '办公审批', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (101, 97, 'oa/approve/view', '查看', '办公审批', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (102, 97, 'oa/approve/check', '审核', '办公审批', 'OA', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (103, 8, 'oa/plan/calendar', '日程日历', '日程安排', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (104, 8, 'oa/plan/index', '日程安排', '日程安排', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (105, 103, 'oa/plan/add', '新建/编辑', '日程安排', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (106, 103, 'oa/plan/delete', '删除', '日程安排', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (107, 103, 'oa/plan/detail', '查看', '日程安排', 'OA', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (108, 8, 'oa/schedule/calendar', '工作日历', '工作日历', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (109, 8, 'oa/schedule/index', '工作记录', '工作记录', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (110, 108, 'oa/schedule/add', '新建/编辑', '工作记录', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (111, 108, 'oa/schedule/delete', '删除', '工作记录', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (112, 108, 'oa/schedule/detail', '查看', '工作记录', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (113, 108, 'oa/schedule/update_labor_time', '更改工时', '工时', 'OA', '', 0, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (114, 8, 'oa/work/index', '工作汇报', '工作汇报', 'OA', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (115, 114, 'oa/work/add', '新建/编辑', '工作汇报', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (116, 114, 'oa/work/send', '发送', '工作汇报', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (117, 114, 'oa/work/read', '查看', '工作汇报', 'OA', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (118, 114, 'oa/work/delete', '删除', '工作汇报', 'OA', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (119, 9, '', '报销管理', '报销', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (120, 119, 'finance/expense/index', '我申请的', '报销', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (121, 119, 'finance/expense/list', '我处理的', '报销', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (122, 119, 'finance/expense/checkedlist', '报销打款', '报销', 'CF', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (123, 119, 'finance/expense/add', '新建/编辑', '报销', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (124, 119, 'finance/expense/delete', '删除', '报销', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (125, 119, 'finance/expense/view', '查看', '报销', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (126, 119, 'finance/expense/check', '审核', '报销', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (127, 119, 'finance/expense/topay', '打款', '报销', 'CF', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (128, 9, '', '发票管理', '发票', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (129, 128, 'finance/invoice/index', '我申请的', '发票', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (130, 128, 'finance/invoice/list', '我处理的', '发票', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (131, 128, 'finance/invoice/checkedlist', '发票开具', '发票', 'CF', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (132, 128, 'finance/invoice/add', '新建/编辑', '发票', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (133, 128, 'finance/invoice/delete', '删除', '发票', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (134, 128, 'finance/invoice/view', '查看', '发票', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (135, 128, 'finance/invoice/check', '审核', '发票', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (136, 128, 'finance/invoice/open', '开具', '发票', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (137, 128, 'finance/invoice/tovoid', '作废', '发票', 'CF', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (138, 9, 'finance/income/index', '到账管理', '到账记录', 'CF', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (139, 138, 'finance/income/add', '新建/编辑', '到账记录', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (140, 138, 'finance/income/view', '查看', '到账记录', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (141, 138, 'finance/income/delete', '删除', '到账记录', 'CF', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (142, 10, 'business/analysis/index', '智能分析', '智能分析', 'BI', '', 1, 1, 1, 0, 0);

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
INSERT INTO `oa_config` VALUES (1, '网站配置', 'web', 'a:13:{s:2:\"id\";s:1:\"1\";s:11:\"admin_title\";s:8:\"勾股OA\";s:5:\"title\";s:8:\"勾股OA\";s:4:\"logo\";s:52:\"/storage/202111/fc507cc8332d5ef49d9425185e4a9697.jpg\";s:4:\"file\";s:0:\"\";s:6:\"domain\";s:23:\"https://oa.gougucms.com\";s:3:\"icp\";s:23:\"粤ICP备1xxxxxx11号-1\";s:8:\"keywords\";s:8:\"勾股OA\";s:5:\"beian\";s:29:\"粤公网安备1xxxxxx11号-1\";s:4:\"desc\";s:479:\"勾股办公是一款基于ThinkPHP6 + Layui + MySql打造的，简单实用的开源免费的企业办公系统框架。系统集成了系统设置、人事管理模块、消息管理模块、日常办公、财务管理等基础模块。系统简约，易于功能扩展，方便二次开发，让开发者更专注于业务深度需求的开发，帮助开发者简单高效降低二次开发成本，通过二次开发之后可以用来做CRM，ERP，业务管理等系统。 \";s:4:\"code\";s:0:\"\";s:9:\"copyright\";s:36:\"© 2022 gougucms.com GPL-2.0 license\";s:7:\"version\";s:6:\"1.0.22\";}', 1, 1612514630, 1638010154);
INSERT INTO `oa_config` VALUES (2, '邮箱配置', 'email', 'a:8:{s:2:\"id\";s:1:\"2\";s:4:\"smtp\";s:11:\"smtp.qq.com\";s:9:\"smtp_port\";s:3:\"465\";s:9:\"smtp_user\";s:15:\"gougucms@qq.com\";s:8:\"smtp_pwd\";s:6:\"123456\";s:4:\"from\";s:24:\"勾股CMS系统管理员\";s:5:\"email\";s:18:\"admin@gougucms.com\";s:8:\"template\";s:485:\"<p>勾股办公是一款基于ThinkPHP6 + Layui + MySql打造的，简单实用的开源免费的企业办公系统框架。系统集成了系统设置、人事管理模块、消息管理模块、日常办公、财务管理等基础模块。系统简约，易于功能扩展，方便二次开发，让开发者更专注于业务深度需求的开发，帮助开发者简单高效降低二次开发成本，通过二次开发之后可以用来做CRM，ERP，业务管理等系统。</p>\";}', 1, 1612521657, 1637075205);
INSERT INTO `oa_config` VALUES (3, 'Api Token配置', 'token', 'a:5:{s:2:\"id\";s:1:\"3\";s:3:\"iss\";s:15:\"oa.gougucms.com\";s:3:\"aud\";s:7:\"gouguoa\";s:7:\"secrect\";s:7:\"GOUGUOA\";s:7:\"exptime\";s:4:\"3600\";}', 1, 1627313142, 1638010233);
INSERT INTO `oa_config` VALUES (4, '其他配置', 'other', 'a:3:{s:2:\"id\";s:1:\"5\";s:6:\"author\";s:15:\"勾股工作室\";s:7:\"version\";s:13:\"v1.2021.07.28\";}', 1, 1613725791, 1635953640);

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
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (1, '董事会', 0, 0, '13688888888');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (2, '人事部', 1, 0, '13688888889');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (3, '财务部', 1, 0, '13688888898');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (4, '市场部', 1, 0, '13688888978');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (5, '销售部', 1, 0, '13688889868');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (6, '技术部', 1, 0, '13688898858');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (7, '客服部', 1, 0, '13688988848');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (8, '销售一部', 5, 0, '13688998838');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (9, '销售二部', 5, 0, '13688999828');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (10, '销售三部', 5, 0, '13688999918');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (11, '产品部', 6, 0, '13688888886');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (12, '设计部', 6, 0, '13688888876');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (13, '研发部', 6, 0, '13688888666');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (14, '客服一部', 7, 0, '13688888865');
INSERT INTO `oa_department`(`id`, `title`, `pid`, `leader_id`, `phone`) VALUES (15, '客服二部', 7, 0, '13688888855');

-- ----------------------------
-- Table structure for oa_department_change
-- ----------------------------
DROP TABLE IF EXISTS `oa_department_change`;
CREATE TABLE `oa_department_change`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `from_did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '原部门id',
  `to_did` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '调到部门id',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `move_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '调到时间',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '人事调动部门记录表';

-- ----------------------------
-- Table structure for oa_personal_quit
-- ----------------------------
DROP TABLE IF EXISTS `oa_personal_quit`;
CREATE TABLE `oa_personal_quit`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `remark` varchar(1000) NULL DEFAULT '' COMMENT '备注',
  `admin_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `lead_admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '部门负责人',
  `connect_uids` varchar(100) NOT NULL DEFAULT '' COMMENT '交接人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `quit_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '离职时间',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '人事离职记录表';

-- ----------------------------
-- Table structure for oa_flow_type
-- ----------------------------
DROP TABLE IF EXISTS `oa_flow_type`;
CREATE TABLE `oa_flow_type`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1假勤,2行政,3财务,4人事,5其他,6报销,发票,合同',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '审批名称',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '审批标识',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '审批类型';

-- ----------------------------
-- Records of oa_flow_type
-- ----------------------------
INSERT INTO `oa_flow_type` VALUES (1, 1, '请假', 'qingjia', 'icon-kechengziyuanguanli', 1, 1639896302, 0);
INSERT INTO `oa_flow_type` VALUES (2, 1, '出差', 'chuchai', 'icon-jiaoshiguanli', 1, 1641802838, 0);
INSERT INTO `oa_flow_type` VALUES (3, 1, '外出', 'waichu', 'icon-tuiguangguanli', 1, 1641802858, 0);
INSERT INTO `oa_flow_type` VALUES (4, 1, '加班', 'jiaban', 'icon-xueshengchengji', 1, 1641802892, 0);
INSERT INTO `oa_flow_type` VALUES (5, 2, '会议室预定', 'huiyishi', 'icon-kehuguanli', 1, 1641802939, 0);
INSERT INTO `oa_flow_type` VALUES (6, 2, '公文流转', 'gongwen', 'icon-jiaoxuejihua', 1, 1641802976, 0);
INSERT INTO `oa_flow_type` VALUES (7, 2, '物品维修', 'weixiu', 'icon-chuangjianxitong', 1, 1641803005, 0);
INSERT INTO `oa_flow_type` VALUES (8, 2, '用章', 'yongzhang', 'icon-shenpishezhi', 1, 1641804126, 0);
INSERT INTO `oa_flow_type` VALUES (9, 2, '用车', 'yongche', 'icon-dongtaiguanli', 1, 1641804283, 0);
INSERT INTO `oa_flow_type` VALUES (10, 2, '用车归还', 'yongcheguihai', 'icon-kaoheguanli', 1, 1641804411, 0);
INSERT INTO `oa_flow_type` VALUES (11, 3, '借款', 'jiekuan', 'icon-zhangbuguanli', 1, 1641804537, 0);
INSERT INTO `oa_flow_type` VALUES (12, 3, '付款', 'fukuan', 'icon-gongziguanli', 1, 1641804601, 0);
INSERT INTO `oa_flow_type` VALUES (13, 3, '奖励', 'jiangli', 'icon-bulujiesuan', 1, 1641804711, 0);
INSERT INTO `oa_flow_type` VALUES (14, 3, '采购', 'caigou', 'icon-shoufeiguanli', 1, 1641804917, 0);
INSERT INTO `oa_flow_type` VALUES (15, 3, '活动经费', 'huodong', 'icon-shoufeipeizhi', 1, 1641805110, 0);
INSERT INTO `oa_flow_type` VALUES (16, 4, '入职', 'ruzhi', 'icon-xueshengdaoru', 1, 1641893853, 0);
INSERT INTO `oa_flow_type` VALUES (17, 4, '转正', 'zhuanzheng', 'icon-wodeshenpi', 1, 1641893926, 0);
INSERT INTO `oa_flow_type` VALUES (18, 4, '离职', 'lizhi', 'icon-xuexitongji', 1, 1641894048, 0);
INSERT INTO `oa_flow_type` VALUES (19, 4, '转岗', 'zhuangang', 'icon-xueshengyidong', 1, 1654681664, 0);
INSERT INTO `oa_flow_type` VALUES (20, 4, '招聘需求', 'zhaopin', 'icon-xiaoxizhongxin', 1, 1641894080, 0);
INSERT INTO `oa_flow_type` VALUES (21, 5, '通用审批', 'tongyong', 'icon-zhaoshengzhunbei', 1, 1654685923, 0);
INSERT INTO `oa_flow_type` VALUES (22, 6, '报销', 'baoxiao', 'icon-jizhang', 1, 1641804488, 0);
INSERT INTO `oa_flow_type` VALUES (23, 7, '发票', 'fapiao', 'icon-fuwuliebiao', 1, 1642904833, 0);
INSERT INTO `oa_flow_type` VALUES (24, 8, '合同', 'hetong', 'icon-hetongshezhi', 1, 1654692083, 0);

-- ----------------------------
-- Table structure for oa_flow
-- ----------------------------
DROP TABLE IF EXISTS `oa_flow`;
CREATE TABLE `oa_flow`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL COMMENT '审批流名称',
  `check_type` tinyint(4) NOT NULL COMMENT '1固定审批,2授权审批人',
  `type` tinyint(4) NOT NULL COMMENT '应用模块,1假勤,2行政,3财务,4人事,5其他,6报销,7发票,8合同',
  `flow_cate` tinyint(11) NOT NULL DEFAULT 0 COMMENT '应用审批类型id',
  `department_ids` varchar(500) NOT NULL DEFAULT '' COMMENT '应用部门ID（0为全部）1,2,3',
  `copy_uids` varchar(500) NOT NULL DEFAULT '' COMMENT '抄送人ID',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '流程说明',
  `flow_list` varchar(1000) NULL DEFAULT '' COMMENT '流程数据序列化',
  `admin_id` int(11) NOT NULL COMMENT '创建人ID',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 1启用，0禁用',
  `delete_time` int(11) NOT NULL DEFAULT 0 COMMENT '删除时间',
  `delete_user_id` int(11) NOT NULL DEFAULT 0 COMMENT '删除人ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '审批流程表';

-- ----------------------------
-- Records of oa_flow
-- ----------------------------
INSERT INTO `oa_flow` VALUES (1, '请假审批', 2, 1, 1, '', '', '请假审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644401970, 1644402071, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (2, '出差审批', 2, 1, 2, '', '', '请假审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402054, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (3, '外出审批', 2, 1, 3, '', '', '外出审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402116, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (4, '加班申请审批', 2, 1, 4, '', '', '加班申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402147, 1644456735, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (5, '会议室预定审批', 2, 2, 5, '', '', '会议室预定审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402193, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (6, '公文流转审批', 2, 2, 6, '', '', '公文流转审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402386, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (7, '物品维修审批', 2, 2, 7, '', '', '物品维修审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402473, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (8, '用章审批', 2, 2, 8, '', '', '用章审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402499, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (9, '用车审批', 2, 2, 9, '', '', '用车审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402525, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (10, '用车归还审批', 2, 2, 10, '', '', '用车归还审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402549, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (11, '借款申请审批', 2, 3, 11, '', '', '借款申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402611, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (12, '付款申请审批', 2, 3, 12, '', '', '付款申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402679, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (13, '奖励申请审批', 2, 3, 13, '', '', '奖励申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402705, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (14, '采购申请审批', 2, 3, 14, '', '', '采购申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402739, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (15, '活动经费审批', 2, 3, 15, '', '', '活动经费审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402762, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (16, '入职申请审批', 2, 4, 16, '', '', '入职申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402791, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (17, '转正申请审批', 2, 4, 17, '', '', '转正申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402812, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (18, '离职申请审批', 2, 4, 18, '', '', '离职申请审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402834, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (19, '转岗申请审批', 2, 4, 19, '', '', '转岗申请审核流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1654681954, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (20, '招聘需求审批', 2, 4, 20, '', '', '招聘需求审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644402855, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (21, '通用审批', 2, 5, 21, '', '', '通用审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1654686338, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (22, '报销审批', 2, 6, 22, '', '', '报销审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644490024, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (23, '发票审批', 2, 7, 23, '', '', '发票审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1644490053, 0, 1, 0, 0);
INSERT INTO `oa_flow` VALUES (24, '合同审批', 2, 8, 24, '', '', '合同审批流程', 'a:1:{i:0;a:2:{s:9:\"flow_type\";s:1:\"1\";s:9:\"flow_uids\";s:0:\"\";}}', 1, 1654692519, 0, 1, 0, 0);