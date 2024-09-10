
ALTER TABLE `oa_customer_contact` 
ADD COLUMN `birthday` bigint(11) NOT NULL DEFAULT 0 COMMENT '生日' AFTER `department`;

ALTER TABLE `oa_customer_contact` 
ADD COLUMN `address` varchar(255) NOT NULL DEFAULT '' COMMENT '家庭住址' AFTER `birthday`;

ALTER TABLE `oa_customer_contact` 
ADD COLUMN `family` mediumtext NULL COMMENT '家庭成员' AFTER `address`;

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
  `create_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '菜单及权限表';

-- ----------------------------
-- Records of oa_admin_rule
-- ----------------------------
INSERT INTO `oa_admin_rule` VALUES (1, 0, '', '系统管理', '系统管理', 'home', 'icon-jichupeizhi', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (2, 0, '', '基础数据', '基础数据', 'base', 'icon-hetongshezhi', 1, 2, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (3, 0, '', '人事管理', '人事管理', 'user', 'icon-renshishezhi', 1, 3, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (4, 0, '', '行政办公', '行政办公', 'adm', 'icon-banjiguanli', 1, 4, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (5, 0, '', '个人办公', '个人办公', 'office', 'icon-kaoshijihua', 1, 5, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (6, 0, '', '财务管理', '财务管理', 'finance', 'icon-yuangongtidian', 1, 6, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (7, 0, '', '客户管理', '客户管理', 'customer', 'icon-kehuguanli', 1, 7, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (8, 0, '', '合同管理', '合同管理', 'contract', 'icon-hetongyidong', 1, 8, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (9, 0, '', '项目管理', '项目管理', 'project', 'icon-xiangmuguanli', 1, 9, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (10, 0, '', '知识网盘', '知识网盘', 'disk', 'icon-tikuguanli', 1, 10, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (11, 1, 'home/conf/index', '系统配置', '系统配置', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (12, 11, 'home/conf/add', '新建/编辑', '配置项', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (13, 11, 'home/conf/delete', '删除', '配置项', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (14, 11, 'home/conf/edit', '编辑', '配置详情', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (15, 1, 'home/module/index', '功能模块', '功能模块', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (16, 15, 'home/module/add', '新建/编辑', '功能模块', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (17, 15, 'home/module/del', '删除', '功能模块', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (18, 15, 'home/module/recovery', '恢复', '功能模块', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (19, 15, 'home/module/install', '安装', '功能模块', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (20, 1, 'home/dataauth/index', '模块配置', '模块配置', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (21, 20, 'home/dataauth/edit', '编辑', '模块配置', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (22, 1, 'home/rule/index', '功能节点', '功能节点', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (23, 22, 'home/rule/add', '新建/编辑', '功能节点', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (24, 22, 'home/rule/delete', '删除', '功能节点', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (25, 1, 'home/role/index', '角色权限', '角色权限', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (26, 25, 'home/role/add', '新建/编辑', '角色权限', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (27, 25, 'home/role/delete', '删除', '角色权限', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (28, 1, 'home/log/index', '操作日志', '操作日志', 'home', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (29, 1, 'home/files/index', '附件管理','附件管理', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (30, 29, 'home/files/edit', '编辑附件','附件', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (31, 29, 'home/files/move', '移动附件','附件', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (32, 29, 'home/files/delete', '删除附件','附件', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (33, 29, 'home/files/get_group', '附件分组','附件分组', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (34, 29, 'home/files/add_group', '新建/编辑','附件分组', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (35, 29, 'home/files/del_group', '删除附件分组','附件分组', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (36, 1, 'home/database/database', '备份数据', '数据备份', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (37, 36, 'home/database/backup', '备份数据表', '数据', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (38, 36, 'home/database/optimize', '优化数据表', '数据表', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (39, 36, 'home/database/repair', '修复数据表', '数据表', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (40, 1, 'home/database/backuplist', '还原数据', '数据还原', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (41, 40, 'home/database/import', '还原数据表', '数据', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (42, 40, 'home/database/downfile', '下载备份数据', '备份数据', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (43, 40, 'home/database/del', '删除备份数据', '备份数据', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (44, 1, 'home/task/index', '定时任务', '定时任务', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (45, 44, 'home/task/add', '新建/编辑', '定时任务', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (46, 44, 'home/task/delete', '删除', '定时任务', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (47, 2, '', '公共模块', '公共模块', 'home', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (48, 47, 'home/template/datalist', '消息模板', '消息模板', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (49, 48, 'home/template/add', '新建/编辑', '消息模板', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (50, 48, 'home/template/set', '设置', '消息模板', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (51, 48, 'home/template/view', '查看', '消息模板', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (52, 47, 'adm/flow/modulelist', '审批模块', '审批模块', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (53, 52, 'adm/flow/module_add', '新建/编辑', '审批模块', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (54, 52, 'adm/flow/module_check', '设置', '审批模块', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (55, 47, 'adm/flow/catelist', '审批类型', '审批类型', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (56, 55, 'adm/flow/cate_add', '新建/编辑', '审批类型', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (57, 55, 'adm/flow/cate_check', '设置', '审批类型', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (58, 47, 'adm/flow/datalist', '审批流程', '审批流程', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (59, 58, 'adm/flow/add', '新建/编辑', '审批流程', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (60, 58, 'adm/flow/del', '删除', '审批流程', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (61, 58, 'adm/flow/check', '设置', '审批流程', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (62, 47, 'home/cate/enterprise', '企业主体', '企业主体', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (63, 62, 'home/cate/enterprise_add', '新建/编辑', '企业主体', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (64, 62, 'home/cate/enterprise_set', '设置', '企业主体', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (65, 47, 'home/area/datalist', '全国省市', '全国省市', 'home', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (66, 65, 'home/area/add', '新建/编辑', '全国省市', 'home', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (67, 65, 'home/area/set', '设置', '全国省市', 'home', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (68, 2, '', '人事模块', '人事模块', 'user', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (69, 68, 'user/rewardscate/datalist', '奖罚项目', '奖罚项目', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (70, 69, 'user/rewardscate/add', '新建/编辑', '奖罚项目', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (71, 69, 'user/rewardscate/set', '设置', '奖罚项目', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (72, 68, 'user/carecate/datalist', '关怀项目', '关怀项目', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (73, 72, 'user/carecate/add', '新建/编辑', '关怀项目', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (74, 72, 'user/carecate/set', '设置', '关怀项目', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (75, 68, 'user/basic/datalist', '常规数据', '常规数据', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (76, 75, 'user/basic/add', '新建/编辑', '常规数据', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (77, 75, 'user/basic/set', '设置', '常规数据', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (78, 3, 'user/department/index', '部门架构', '部门', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (79, 78, 'user/department/add', '新建/编辑', '部门', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (80, 78, 'user/department/delete', '删除', '部门', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (81, 3, 'user/position/index', '岗位职称', '岗位职称', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (82, 81, 'user/position/add', '新建/编辑', '岗位职称', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (83, 81, 'user/position/delete', '删除', '岗位职称', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (84, 81, 'user/position/view', '查看', '岗位职称', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (85, 3, 'user/user/index', '企业员工', '员工', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (86, 85, 'user/user/add', '新建/编辑', '员工', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (87, 85, 'user/user/view', '查看', '员工信息', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (88, 85, 'user/user/set', '设置', '员工状态', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (89, 85, 'user/user/reset_psw', '重设密码', '员工密码', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (90, 3, 'user/files/datalist', '员工档案', '员工档案', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (91, 90, 'user/files/add', '编辑', '员工档案', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (92, 90, 'user/files/view', '查看', '员工档案', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (93, 90, 'user/files/set', '设置', '员工档案', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (94, 3, 'user/personal/change', '人事调动', '人事调动', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (95, 94, 'user/personal/change_add', '新建/编辑', '人事调动', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (96, 3, 'user/personal/leave', '离职档案', '离职档案', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (97, 96, 'user/personal/leave_add', '新建/编辑', '离职档案', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (98, 96, 'user/personal/leave_delete', '删除', '离职档案', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (99, 3, 'user/rewards/datalist', '奖罚管理', '奖罚管理', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (100, 99, 'user/rewards/add', '新建/编辑', '奖罚管理', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (101, 99, 'user/rewards/view', '查看', '奖罚管理', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (102, 99, 'user/rewards/del', '删除', '奖罚管理', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (103, 3, 'user/care/datalist', '员工关怀', '员工关怀', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (104, 103, 'user/care/add', '新建/编辑', '员工关怀', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (105, 103, 'user/care/view', '查看', '员工关怀', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (106, 103, 'user/care/del', '删除', '员工关怀', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (107, 3, 'user/laborcontract/datalist', '员工合同', '员工合同', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (108, 107, 'user/laborcontract/add', '新建/编辑', '员工合同', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (109, 107, 'user/laborcontract/add_renewal', '续签', '员工合同', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (110, 107, 'user/laborcontract/add_change', '变更', '员工合同', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (111, 107, 'user/laborcontract/view', '查看', '员工合同', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (112, 107, 'user/laborcontract/del', '删除', '员工合同', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (113, 107, 'user/laborcontract/set', '设置', '员工合同', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (114, 2, '', '行政模块', '行政模块', 'adm', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (115, 114, 'adm/propertycate/datalist', '资产分类', '资产分类', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (116, 115, 'adm/propertycate/add', '新建/编辑', '资产分类', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (117, 115, 'adm/propertycate/delete', '删除', '资产分类', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (118, 114, 'adm/propertybrand/datalist', '资产品牌', '资产品牌', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (119, 118, 'adm/propertybrand/add', '新建/编辑', '资产品牌', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (120, 118, 'adm/propertybrand/check', '设置', '资产品牌', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (121, 114, 'adm/propertyunit/datalist', '资产单位', '资产单位', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (122, 121, 'adm/propertyunit/add', '新建/编辑', '资产单位', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (123, 121, 'adm/propertyunit/check', '设置', '资产单位', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (124, 114, 'adm/sealcate/datalist', '印章管理', '印章', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (125, 124, 'adm/sealcate/add', '新建/编辑', '印章', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (126, 124, 'adm/sealcate/check', '设置', '印章', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (127, 114, 'adm/basic/datalist', '常规数据', '常规数据', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (128, 127, 'adm/basic/add', '新建/编辑', '常规数据', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (129, 127, 'adm/basic/set', '设置', '常规数据', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (130, 4, '', '固定资产', '固定资产', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (131, 130, 'adm/property/datalist', '资产信息', '固定资产', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (132, 131, 'adm/property/add', '新建/编辑', '固定资产', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (133, 131, 'adm/property/check', '设置', '固定资产', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (134, 131, 'adm/property/view', '查看', '固定资产', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (135, 130, 'adm/property/repair_list', '报修记录', '资产报修记录', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (136, 135, 'adm/property/repair_add', '新建/编辑', '资产报修记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (137, 135, 'adm/property/repair_view', '查看', '资产报修记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (138, 135, 'adm/property/repair_del', '删除', '资产报修记录', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (139, 4, '', '车辆管理', '车辆', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (140, 139, 'adm/car/datalist', '车辆信息', '车辆', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (141, 140, 'adm/car/add', '新建/编辑', '车辆', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (142, 140, 'adm/car/check', '设置', '车辆', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (143, 140, 'adm/car/view', '查看', '车辆', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (144, 139, 'adm/car/repair_list', '车辆维修', '车辆维修记录', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (145, 144, 'adm/car/repair_add', '新建/编辑', '车辆维修记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (146, 144, 'adm/car/repair_view', '查看', '车辆维修记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (147, 144, 'adm/car/repair_del', '删除', '车辆维修记录', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (148, 139, 'adm/car/protect_list', '车辆保养', '车辆保养记录', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (149, 148, 'adm/car/protect_add', '新建/编辑', '车辆保养记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (150, 148, 'adm/car/protect_view', '查看', '车辆保养记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (151, 148, 'adm/car/protect_del', '删除', '车辆保养记录', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (152, 139, 'adm/car/mileage_list', '车辆里程', '车辆里程记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (153, 152, 'adm/car/mileage_add', '新建/编辑', '车辆里程记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (154, 152, 'adm/car/mileage_del', '删除', '车辆里程记录', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (155, 139, 'adm/car/fee_list', '车辆费用', '车辆费用记录', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (156, 155, 'adm/car/fee_add', '新建/编辑', '车辆费用记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (157, 155, 'adm/car/fee_view', '查看', '车辆费用记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (158, 155, 'adm/car/fee_del', '删除', '车辆费用记录', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (159, 4, '', '会议管理', '会议管理', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (160, 159, 'adm/meeting/room', '会议室管理', '会议室', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (161, 160, 'adm/meeting/room_add', '新建/编辑', '会议室', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (162, 160, 'adm/meeting/room_view', '查看', '会议纪要', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (163, 160, 'adm/meeting/room_check', '设置', '会议室', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (164, 159, 'adm/meeting/records', '会议记录', '会议记录', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (165, 164, 'adm/meeting/records_add', '新建/编辑', '会议记录', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (166, 164, 'adm/meeting/records_view', '查看', '会议纪要', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (167, 164, 'adm/meeting/records_del', '删除', '会议纪要', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (168, 4, '', '公文管理', '公文管理', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (169, 168, 'adm/official/datalist', '公文列表', '公文管理', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (170, 169, 'adm/official/add', '新建/编辑', '公文管理', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (171, 169, 'adm/official/view', '查看', '公文管理', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (172, 169, 'adm/official/del', '删除', '公文管理', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (173, 168, 'adm/official/pending', '待审公文', '公文管理', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (174, 168, 'adm/official/reviewed', '已审公文', '公文管理', 'adm', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (175, 4, '', '用章管理', '用章管理', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (176, 175, 'adm/seal/datalist', '用章申请', '用章申请', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (177, 176, 'adm/seal/add', '新建/编辑', '用章申请', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (178, 176, 'adm/seal/view', '查看', '用章申请', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (179, 176, 'adm/seal/del', '删除', '用章申请', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (180, 175, 'adm/seal/record', '用章记录', '用章记录', 'adm', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (181, 104, 'adm/notecate/datalist', '公告类型', '公告类型', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (182, 181, 'adm/notecate/add', '新建/编辑', '公告类型', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (183, 181, 'adm/notecate/set', '设置', '公告类型', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (184, 4, 'adm/note/datalist', '公告列表', '公告', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (185, 184, 'adm/note/add', '新建/编辑', '公告', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (186, 184, 'adm/note/del', '删除', '公告', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (187, 184, 'adm/note/view', '查看', '公告', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (188, 4, 'adm/news/datalist', '公司新闻', '公司新闻', 'adm', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (189, 188, 'adm/news/add', '新建/编辑', '公司新闻', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (190, 188, 'adm/news/del', '删除', '公司新闻', 'adm', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (191, 188, 'adm/news/view', '查看', '公司新闻', 'adm', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (192, 5, 'oa/plan/datalist', '日程安排', '日程安排', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (193, 192, 'oa/plan/add', '新建/编辑', '日程安排', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (194, 192, 'oa/plan/view', '查看', '日程安排', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (195, 192, 'oa/plan/del', '删除', '日程安排', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (196, 5, 'oa/plan/calendar', '日程日历', '日程安排', 'oa', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (197, 5, 'oa/schedule/datalist', '工作记录', '工作记录', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (198, 197, 'oa/schedule/add', '新建/编辑', '工作记录', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (199, 197, 'oa/schedule/view', '查看', '工作记录', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (200, 197, 'oa/schedule/del', '删除', '工作记录', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (201, 5, 'oa/schedule/calendar', '工作日历', '工作日历', 'oa', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (202, 5, 'oa/work/datalist', '工作汇报', '工作汇报', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (203, 202, 'oa/work/add', '新建/编辑', '工作汇报', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (204, 202, 'oa/work/send', '发送', '工作汇报', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (205, 202, 'oa/work/view', '查看', '工作汇报', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (206, 202, 'oa/work/del', '删除', '工作汇报', 'oa', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (207, 5, 'oa/note/datalist', '公告通知', '公告通知', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (208, 207, 'oa/note/view', '查看', '公告通知', 'oa', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (209, 5, 'oa/news/datalist', '公司新闻', '公司新闻', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (210, 209, 'oa/news/view', '查看', '公司新闻', 'oa', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (211, 2, '', '财务模块', '财务模块', 'finance', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (212, 211, 'finance/expensecate/datalist', '报销类型', '报销类型', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (213, 212, 'finance/expensecate/add', '新建/编辑', '报销类型', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (214, 212, 'finance/expensecate/set', '设置', '报销类型', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (215, 211, 'finance/costcate/datalist', '费用类型', '费用类型', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (216, 215, 'finance/costcate/add', '新建/编辑', '费用类型', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (217, 215, 'finance/costcate/set', '设置', '费用类型', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (218, 6, 'finance/expense/datalist', '报销管理', '报销', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (219, 218, 'finance/expense/add', '新建/编辑', '报销', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (220, 218, 'finance/expense/del', '删除', '报销', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (221, 218, 'finance/expense/view', '查看', '报销', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (222, 6, 'finance/invoice/datalist', '开票管理', '发票', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (223, 222, 'finance/invoice/add', '新建/编辑', '发票', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (224, 222, 'finance/invoice/del', '删除', '发票', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (225, 222, 'finance/invoice/view', '查看', '发票', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (226, 6, 'finance/ticket/datalist', '收票管理', '发票', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (227, 226, 'finance/ticket/add', '新建/编辑', '发票', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (228, 226, 'finance/ticket/delete', '删除', '发票', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (229, 226, 'finance/ticket/view', '查看', '发票', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (230, 6, 'finance/income/datalist', '回款管理', '回款记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (231, 230, 'finance/income/add', '新建/编辑', '回款记录', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (232, 230, 'finance/income/view', '查看', '回款记录', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (233, 230, 'finance/income/del', '删除', '回款记录', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (234, 6, 'finance/invoice/datalist_a', '无发票回款', '无发票回款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (235, 234, 'finance/invoice/add_a', '新建/编辑', '无发票回款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (236, 234, 'finance/invoice/del_a', '删除', '无发票回款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (237, 234, 'finance/invoice/view_a', '查看', '无发票回款', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (238, 6, 'finance/payment/datalist', '付款管理', '付款记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (239, 238, 'finance/payment/add', '新建/编辑', '付款记录', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (240, 238, 'finance/payment/view', '查看', '付款记录', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (241, 238, 'finance/payment/del', '删除', '付款记录', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (242, 6, 'finance/ticket/datalist_a', '无发票付款', '无发票付款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (243, 242, 'finance/ticket/add_a', '新建/编辑', '无发票付款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (244, 242, 'finance/ticket/del_a', '删除', '无发票付款', 'finance', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (245, 242, 'finance/ticket/view_a', '查看', '无发票付款', 'finance', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (246, 6, '', '财务统计', '财务统计', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (247, 246, 'finance/expense/record', '报销记录', '报销记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (248, 246, 'finance/invoice/record', '开票记录', '开票记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (249, 246, 'finance/ticket/record', '收票记录', '收票记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (250, 246, 'finance/income/record', '回款记录', '回款记录', 'finance', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (251, 246, 'finance/payment/record', '付款记录', '付款记录', 'finance', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (252, 2, '', '客户模块', '客户模块', 'customer', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (253, 252, 'customer/industry/datalist', '行业类型', '行业类型', 'home', '', 1, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (254, 253, 'customer/industry/add', '新建/编辑', '行业类型', 'home', '', 2, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (255, 253, 'customer/industry/set', '设置', '行业类型', 'home', '', 2, 0, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (256, 252, 'customer/grade/datalist', '客户等级', '客户等级', 'customer', '', 1, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (257, 256, 'customer/grade/add', '新建/编辑', '客户等级', 'customer', '', 2, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (258, 256, 'customer/grade/set', '设置', '客户等级', 'customer', '', 2,0, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (259, 252, 'customer/source/datalist', '客户渠道', '客户渠道', 'customer', '', 1, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (260, 259, 'customer/source/add', '新建/编辑', '客户渠道', 'customer', '', 2, 0, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (261, 259, 'customer/source/set', '设置', '客户渠道', 'customer', '', 2,0, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (262, 252, 'customer/basic/datalist', '常规数据', '常规数据', 'user', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (263, 262, 'customer/basic/add', '新建/编辑', '常规数据', 'user', '', 2, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (264, 262, 'customer/basic/set', '设置', '常规数据', 'user', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (265, 7, 'customer/customer/datalist', '客户列表', '客户列表', 'customer', '', 1, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (266, 265, 'customer/customer/add', '新建/编辑', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (267, 265, 'customer/customer/view', '查看', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (268, 265, 'customer/customer/del', '删除', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);

INSERT INTO `oa_admin_rule` VALUES (269, 7, 'customer/index/rush', '抢 客 宝', '抢客宝', 'customer', '', 1, 0, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (270, 7, 'customer/index/sea', '公海客户', '客户', 'customer', '', 1, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (271, 270, 'customer/index/to_get', '获取', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (272, 270, 'customer/index/to_divide', '分配客户', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (273, 270, 'customer/index/to_sea', '转入公海', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (274, 270, 'customer/index/to_trash', '转入废弃池', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);
INSERT INTO `oa_admin_rule` VALUES (275, 270, 'customer/index/to_revert', '恢复客户', '客户', 'customer', '', 2, 0, 1, 1556143065, 0);

INSERT INTO `oa_admin_rule` VALUES (276, 7, 'customer/index/trash', '废弃客户', '客户', 'customer', '', 1, 0, 1, 1556143065, 0);

INSERT INTO `oa_admin_rule` VALUES (277, 7, 'customer/contact/datalist', '客户联系人', '联系人', 'customer', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (278, 277, 'customer/contact/add', '新建/编辑', '联系人', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (279, 277, 'customer/contact/del', '删除', '联系人', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (280, 277, 'customer/contact/view', '查看', '客户联系人', 'customer', '', 2, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (281, 7, 'customer/chance/datalist', '机会线索', '机会线索', 'customer', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (282, 281, 'customer/chance/add', '新建/编辑', '机会线索', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (283, 281, 'customer/chance/view', '查看', '机会线索', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (284, 281, 'customer/chance/del', '删除', '机会线索', 'customer', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (285, 7, 'customer/trace/datalist', '跟进记录', '跟进记录', 'customer', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (286, 285, 'customer/trace/add', '新建/编辑', '跟进记录', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (287, 285, 'customer/trace/view', '查看', '跟进记录', 'customer', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (288, 285, 'customer/trace/del', '删除', '跟进记录', 'customer', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (289, 2, '', '合同模块', '合同模块', 'contract', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (290, 289, 'contract/cate/datalist', '合同分类', '合同分类', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (291, 290, 'contract/cate/add', '新建/编辑', '合同分类', 'contract', '', 2, 1, 1, 0, 1656143065);
INSERT INTO `oa_admin_rule` VALUES (292, 290, 'contract/cate/set', '设置', '合同分类', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (293, 286, 'contract/productcate/datalist', '产品分类', '产品分类', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (294, 293, 'contract/productcate/add', '新建/编辑', '产品分类', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (295, 293, 'contract/productcate/del', '删除', '产品分类', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (296, 289, 'contract/product/datalist', '产品列表', '产品', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (297, 296, 'contract/product/add', '新建/编辑', '产品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (298, 296, 'contract/product/view', '查看', '产品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (299, 296, 'contract/product/del', '删除', '产品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (300, 296, 'contract/product/set', '设置', '产品', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (301, 289, 'contract/services/datalist', '服务内容', '服务内容', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (302, 301, 'contract/services/add', '新建/编辑', '服务内容', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (303, 301, 'contract/services/set', '设置', '服务内容', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (304, 289, 'contract/supplier/datalist', '供应商列表', '供应商', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (305, 304, 'contract/supplier/add', '新建/编辑', '供应商', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (306, 304, 'contract/supplier/set', '设置', '供应商', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (307, 304, 'contract/supplier/view', '查看', '供应商', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (308, 304, 'contract/supplier/del', '删除', '供应商', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (309, 304, 'contract/supplier/contact_add', '新建/编辑', '供应商联系人', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (310, 304, 'contract/supplier/contact_del', '删除', '供应商联系人', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (311, 289, 'contract/purchasedcate/datalist', '采购品分类', '采购品分类', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (312, 311, 'contract/purchasedcate/add', '新建/编辑', '采购品分类', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (313, 311, 'contract/purchasedcate/del', '删除', '采购品分类', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (314, 289, 'contract/purchased/datalist', '采购品列表', '采购品', 'contract', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (315, 314, 'contract/purchased/add', '新建/编辑', '采购品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (316, 314, 'contract/purchased/view', '查看', '采购品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (317, 314, 'contract/purchased/del', '删除', '采购品', 'contract', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (318, 314, 'contract/purchased/set', '设置', '采购品', 'contract', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (319, 8, 'contract/contract/datalist', '销售合同', '销售合同', 'contract', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (320, 319, 'contract/contract/add', '新建/编辑', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (321, 319, 'contract/contract/view', '查看', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (322, 319, 'contract/contract/del', '删除', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (323, 8, 'contract/purchase/datalist', '采购合同', '采购合同', 'contract', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (324, 323, 'contract/purchase/add', '新建/编辑', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (325, 323, 'contract/purchase/view', '查看', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (326, 323, 'contract/purchase/del', '删除', '合同', 'contract', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (327, 8, 'contract/contract/archivelist', '合同归档', '合同归档', 'contract', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (328, 327, 'contract/purchase/archivelist', '采购合同归档', '采购合同归档', 'contract', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (329, 8, 'contract/contract/stoplist', '中止合同', '中止合同', 'contract', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (330, 329, 'contract/purchase/stoplist', '中止采购合同', '中止采购合同', 'contract', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (331, 8, 'contract/contract/voidlist', '作废合同', '作废合同', 'contract', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (332, 331, 'contract/purchase/voidlist', '作废合同归档', '作废采购合同', 'contract', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (333, 2, '', '项目模块', '项目模块', 'project', '', 1, 1, 1, 0, 0);

INSERT INTO `oa_admin_rule` VALUES (334, 333, 'project/step/datalist', '项目阶段', '项目阶段', 'project', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (335, 334, 'project/step/add', '新建/编辑', '项目阶段', 'project', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (336, 334, 'project/step/set', '设置', '项目阶段', 'project', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (337, 333, 'project/cate/datalist', '项目分类', '项目分类', 'project', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (338, 337, 'project/cate/add', '新建/编辑', '项目分类', 'project', '', 2, 1, 1, 0, 1656143065);
INSERT INTO `oa_admin_rule` VALUES (339, 337, 'project/cate/set', '设置', '项目分类', 'project', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (340, 333, 'project/work/datalist', '工作类别', '工作类别', 'project', '', 1, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (341, 340, 'project/work/add', '新建/编辑', '工作类别', 'project', '', 2, 1, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (342, 340, 'project/work/set', '设置', '工作类别', 'project', '', 2, 1, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (343, 9, 'project/index/datalist', '项目列表', '项目', 'project', '', 1, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (344, 343, 'project/index/add', '新建', '项目', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (345, 343, 'project/index/edit', '编辑', '项目', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (346, 343, 'project/index/view', '查看', '项目', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (347, 343, 'project/index/del', '删除', '项目', 'project', '', 2, 0, 1, 1656142368, 0);

INSERT INTO `oa_admin_rule` VALUES (348, 9, 'project/task/datalist', '任务列表', '任务', 'project', '', 1, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (349, 348, 'project/task/add', '新建', '任务', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (350, 348, 'project/task/edit', '编辑', '任务', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (351, 348, 'project/task/view', '查看', '任务', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (352, 348, 'project/task/del', '删除', '任务', 'project', '', 2, 0, 1, 1656142368, 0);

INSERT INTO `oa_admin_rule` VALUES (353, 9, 'project/task/hour', '任务工时', '工时', 'project', '', 1, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (354, 9, 'project/task/comment', '任务评论', '工时', 'project', '', 1, 0, 1, 1656142368, 0);

INSERT INTO `oa_admin_rule` VALUES (355, 9, 'project/document/datalist', '文档列表', '文档', 'project', '', 1, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (356, 355, 'project/document/add', '新建/编辑', '文档', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (357, 355, 'project/document/view', '查看', '文档', 'project', '', 2, 0, 1, 1656142368, 0);
INSERT INTO `oa_admin_rule` VALUES (358, 355, 'project/document/del', '删除', '文档', 'project', '', 2, 0, 1, 1656142368, 0);

INSERT INTO `oa_admin_rule` VALUES (359, 10, 'disk/index/datalist', '个人文件', '个人文件', 'disk', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (360, 359, 'disk/index/add_upload', '新增', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (361, 359, 'disk/index/add_folder', '新增', '文件夹', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (362, 359, 'disk/index/add_article', '新增/编辑', '在线文档', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (363, 359, 'disk/index/view_article', '查看', '在线文档', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (364, 359, 'disk/index/del', '删除', '文件/文件夹/在线文档', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (365, 359, 'disk/index/rename', '重命名', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (366, 359, 'disk/index/move', '移动', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (367, 359, 'disk/index/share', '分享', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (368, 359, 'disk/index/unshare', '取消分享', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (369, 359, 'disk/index/star', '标星', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (370, 359, 'disk/index/unstar', '取消标星', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (371, 359, 'disk/index/back', '还原', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (372, 359, 'disk/index/clear', '清除', '文件', 'disk', '', 2, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (373, 10, 'disk/index/sharelist', '共享文件', '共享文件', 'disk', '', 1, 0, 1, 1656143065, 0);
INSERT INTO `oa_admin_rule` VALUES (374, 10, 'disk/index/clearlist', '回 收 站', '回收站文件', 'disk', '', 1, 0, 1, 1656143065, 0);

INSERT INTO `oa_admin_rule` VALUES (375, 5, 'oa/meeting/datalist', '会议纪要', '会议纪要', 'oa', '', 1, 1, 1, 0, 0);
INSERT INTO `oa_admin_rule` VALUES (376, 375, 'oa/meeting/view', '查看', '会议纪要', 'oa', '', 2, 1, 1, 0, 0);

UPDATE `oa_admin_group` SET `rules` = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376' WHERE `id` = 1;

-- ----------------------------
-- Table structure for oa_flow_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_flow_cate`;
CREATE TABLE `oa_flow_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '审批类型名称',
  `name` varchar(100) NOT NULL COMMENT '审批类型标识,唯一',
  `module_id` int(11) NOT NULL DEFAULT 0 COMMENT '关联审批模块id',
  `check_table` varchar(100) NOT NULL DEFAULT '' COMMENT '关联数据库表名',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `department_ids` varchar(255) NOT NULL DEFAULT '' COMMENT '应用部门ID（空为全部）1,2,3',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序：越大越靠前',
  `form` tinyint(1) NOT NULL DEFAULT 1 COMMENT '预设字段，表单模式：1固定表单,2自定义表单',
  `add_url` varchar(255) NOT NULL DEFAULT '' COMMENT '新建链接：固定表单模式必填',
  `view_url` varchar(255) NOT NULL DEFAULT '' COMMENT '查看链接：固定表单模式必填',
  `form_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '表单id：自定义表单模式必填',
  `is_list` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否列表页显示：0不显示 1显示',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `template_apply` int(11) NOT NULL DEFAULT 0 COMMENT '审批消息模板id',
  `template_ok` int(11) NOT NULL DEFAULT 0 COMMENT '通过消息模板id',
  `template_no` int(11) NOT NULL DEFAULT 0 COMMENT '拒绝消息模板id',
  `create_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '审批类型';

-- ----------------------------
-- Records of oa_flow_cate
-- ----------------------------

INSERT INTO `oa_flow_cate` VALUES (1, '用章', 'seal', 2, 'seal', 'icon-shenpishezhi', '', 0, 1, '/adm/seal/add', '/adm/seal/view', 0, 1, 1, 14, 15, 16, 1723469451, 1724138203);
INSERT INTO `oa_flow_cate` VALUES (2, '公文', 'official_docs', 2, 'official_docs', 'icon-lunwenguanli', '', 0, 1, '/adm/official/add', '/adm/official/view', 0, 1, 1, 17, 18, 19, 1723469614, 1724138182);
INSERT INTO `oa_flow_cate` VALUES (3, '报销', 'expense', 4, 'expense', 'icon-jizhang', '', 0, 1, '/finance/expense/add', '/finance/expense/view', 0, 1, 1, 20, 21, 22, 1723469732, 1724138154);
INSERT INTO `oa_flow_cate` VALUES (4, '发票', 'invoice', 4, 'invoice', 'icon-duizhangdan', '', 0, 1, '/finance/invoice/add', '/finance/invoice/view', 0, 1, 1, 24, 25, 26, 1723469814, 1724138127);
INSERT INTO `oa_flow_cate` VALUES (5, '收票', 'ticket', 4, 'ticket', 'icon-yingjiaoqingdan', '', 0, 1, '/finance/ticket/add', '/finance/ticket/view', 0, 1, 1, 28, 29, 29, 1724749856, 1724828690);
INSERT INTO `oa_flow_cate` VALUES (6, '销售合同', 'contract', 3, 'contract', 'icon-hetongguanli', '', 0, 1, '/contract/contract/add', '/contract/contract/view', 0, 0, 1, 31, 32, 33, 1723469917, 1724828537);
INSERT INTO `oa_flow_cate` VALUES (7, '采购合同', 'purchase', 3, 'purchase', 'icon-dianshang', '', 0, 1, '/contract/purchase/add', '/contract/purchase/view', 0, 0, 1, 34, 35, 36, 1723470017, 1724828575);
INSERT INTO `oa_flow_cate` VALUES (8, '请假', 'leaves', 1, 'leaves', 'icon-kechengziyuanguanli', '', 0, 1, '/home/leaves/add', '/home/leaves/view', 0, 1, 1, 2, 3, 4, 1723604674, 0);
INSERT INTO `oa_flow_cate` VALUES (9, '出差', 'trips', 1, 'trips', 'icon-jiaoshiguanli', '', 0, 1, '/home/trips/add', '/home/trips/view', 0, 1, 1, 5, 6, 7, 1723799422, 1724138037);
INSERT INTO `oa_flow_cate` VALUES (10, '外出', 'outs', 1, 'outs', 'icon-tuiguangguanli', '', 0, 1, '/home/outs/add', '/home/outs/view', 0, 1, 1, 8, 9, 10, 1723800336, 1724138021);
INSERT INTO `oa_flow_cate` VALUES (11, '加班', 'overtimes', 1, 'overtimes', 'icon-xueshengchengji', '', 0, 1, '/home/overtimes/add', '/home/overtimes/view', 0, 1, 1, 11, 12, 13, 1723800393, 1724138004);
INSERT INTO `oa_flow_cate` VALUES (12, '无发票回款', 'invoicea', 4, 'invoice', 'icon-shoufeipeizhi', '', 0, 1, '/finance/invoice/add_a', '/finance/invoice/view_a', 0, 1, 1, 39, 40, 41, 1725856435, 1725935194);
INSERT INTO `oa_flow_cate` VALUES (13, '无发票付款', 'ticketa', 4, 'ticket', 'icon-bulujiesuan', '', 0, 1, '/finance/ticket/add_a', '/finance/ticket/view_a', 0, 1, 1, 42, 43, 44, 1725856613, 1725935703);


-- ----------------------------
-- Table structure for oa_flow
-- ----------------------------
DROP TABLE IF EXISTS `oa_flow`;
CREATE TABLE `oa_flow`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '审批流程名称',
  `cate_id` tinyint(11) NOT NULL DEFAULT 0 COMMENT '关联审批类型id',
  `check_type` tinyint(4) NOT NULL COMMENT '1自由审批流,2固定审批流,3固定可回退的审批流,4固定条件审批流',
  `department_ids` varchar(500) NOT NULL DEFAULT '' COMMENT '应用部门ID（0为全部）1,2,3',
  `copy_uids` varchar(500) NOT NULL DEFAULT '' COMMENT '抄送人ID',
  `flow_list` varchar(1000) NULL DEFAULT '' COMMENT '流程数据序列化',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 1启用，0禁用',
  `remark` varchar(500) NOT NULL DEFAULT '' COMMENT '流程说明',
  `admin_id` int(11) NOT NULL COMMENT '创建人ID',
  `create_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '审批流程表';

-- ----------------------------
-- Records of oa_flow_cate
-- ----------------------------
INSERT INTO `oa_flow` VALUES (1, '用章审批', 1, 1, '', '', '', 1, '', 1, 1723470400, 0, 0);
INSERT INTO `oa_flow` VALUES (2, '公文审批', 2, 1, '', '', '', 1, '', 1, 1723470419, 0, 0);
INSERT INTO `oa_flow` VALUES (3, '报销审批', 3, 1, '', '', '', 1, '', 1, 1723470468, 0, 0);
INSERT INTO `oa_flow` VALUES (4, '发票审批', 4, 1, '', '', '', 1, '', 1, 1723470482, 0, 0);
INSERT INTO `oa_flow` VALUES (5, '收票审批', 5, 1, '', '', '', 1, '', 1, 1723470482, 0, 0);
INSERT INTO `oa_flow` VALUES (6, '销售合同审批', 6, 1, '', '', '', 1, '', 1, 1723470490, 0, 0);
INSERT INTO `oa_flow` VALUES (7, '采购合同审批', 7, 1, '', '', '', 1, '', 1, 1723470501, 0, 0);
INSERT INTO `oa_flow` VALUES (8, '请假审批', 8, 1, '', '', '', 1, '', 1, 1723791655, 0, 0);
INSERT INTO `oa_flow` VALUES (9, '出差审批', 9, 1, '', '', '', 1, '', 1, 1723799665, 0, 0);
INSERT INTO `oa_flow` VALUES (10, '外出审批', 10, 1, '', '', '', 1, '', 1, 1723800434, 0, 0);
INSERT INTO `oa_flow` VALUES (11, '加班审批', 11, 1, '', '', '', 1, '', 1, 1723800446, 0, 0);
INSERT INTO `oa_flow` VALUES (12, '无发票回款', 12, 1, '', '', '', 1, '', 1, 1725935073, 0, 0);
INSERT INTO `oa_flow` VALUES (13, '无发票付款', 13, 1, '', '', '', 1, '', 1, 1725935159, 1725935232, 0);

-- ----------------------------
-- Table structure for oa_template
-- ----------------------------
DROP TABLE IF EXISTS `oa_template`;
CREATE TABLE `oa_template`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '消息模板名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '权限标识唯一，字母',
  `types` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类型',
  `remark` mediumtext  NULL COMMENT '备注描述，使用场景等',
  `msg_title` varchar(255) NOT NULL DEFAULT '' COMMENT '系统消息模板标题',
  `msg_link` varchar(255) NOT NULL DEFAULT '' COMMENT '系统消息模板链接',
  `msg_content` mediumtext  NULL COMMENT '系统消息模板内容',
  `weixin_title` varchar(255) NOT NULL DEFAULT '' COMMENT '企业微信模板标题',
  `weixin_link` varchar(255) NOT NULL DEFAULT '' COMMENT '企业微信模板链接',
  `weixin_content` mediumtext  NULL COMMENT '企业微信模板内容',
  `mobile_title` varchar(255) NOT NULL DEFAULT '' COMMENT '手机消息模板标题',
  `mobile_link` varchar(255) NOT NULL DEFAULT '' COMMENT '手机消息模板链接',
  `mobile_content` mediumtext  NULL COMMENT '手机消息模板内容',
  `email_title` varchar(255) NOT NULL DEFAULT '' COMMENT '邮件消息模板标题',
  `email_link` varchar(255) NOT NULL DEFAULT '' COMMENT '邮件消息模板链接',
  `email_content` mediumtext  NULL COMMENT '邮件消息模板内容',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `admin_id` int(11) NOT NULL DEFAULT 0 COMMENT  '创建人',
  `create_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  `delete_time` bigint(11) NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '消息模板表';

-- ----------------------------
-- Records of oa_template
-- ----------------------------
INSERT INTO `oa_template` VALUES (1, '公告通知', 'note', 1, NULL, '{from_user}发了一个新『公告』，请及时查看', '<a class=\"side-a\" data-href=\"/adm/note/view/id/{action_id}\">查看详情</a>', '您有一个新公告：{title}。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724125098, 1724130546, 0);
INSERT INTO `oa_template` VALUES (2, '请假申请待审批', 'leaves_apply', 1, NULL, '{from_user}提交了一个『请假申请』，请及时审批', '<a class=\"side-a\" data-href=\"/home/leaves/view/id/{action_id}\">去审批</a>', '您有一个新的『请假申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724125630, 1724125687, 0);
INSERT INTO `oa_template` VALUES (3, '请假申请通过', 'leaves_ok', 1, NULL, '您提交的『请假申请』已被审批通过', '<a class=\"side-a\" data-href=\"/home/leaves/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『请假申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724125677, 0, 0);
INSERT INTO `oa_template` VALUES (4, '请假申请被拒绝', 'leaves_no', 1, NULL, '您提交的『请假申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/home/leaves/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『请假申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724125748, 0, 0);
INSERT INTO `oa_template` VALUES (5, '出差申请待审批', 'trips_apply', 1, NULL, '{from_user}提交了一个『出差申请』，请及时审批', '<a class=\"side-a\" data-href=\"/home/trips/view/id/{action_id}\">去审批</a>', '您有一个新的『出差申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135684, 0, 0);
INSERT INTO `oa_template` VALUES  (6, '出差申请通过', 'trips_ok', 1, NULL, '您提交的『出差申请』已被审批通过', '<a class=\"side-a\" data-href=\"/home/trips/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『出差申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135729, 0, 0);
INSERT INTO `oa_template` VALUES (7, '出差申请被拒绝', 'trips_no', 1, NULL, '您提交的『出差申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/home/trips/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『出差申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135788, 0, 0);
INSERT INTO `oa_template` VALUES (8, '外出申请待审批', 'outs_apply', 1, NULL, '{from_user}提交了一个『外出申请』，请及时审批', '<a class=\"side-a\" data-href=\"/home/outs/view/id/{action_id}\">去审批</a>', '您有一个新的『外出申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135849, 0, 0);
INSERT INTO `oa_template` VALUES (9, '外出申请通过', 'outs_ok', 1, NULL, '您提交的『外出申请』已被审批通过', '<a class=\"side-a\" data-href=\"/home/outs/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『外出申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135883, 0, 0);
INSERT INTO `oa_template` VALUES (10, '外出申请被拒绝', 'outs_no', 1, NULL, '您提交的『外出申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/home/outs/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『外出申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135930, 0, 0);
INSERT INTO `oa_template` VALUES (11, '加班申请待审批', 'overtimes_apply', 1, NULL, '{from_user}提交了一个『加班申请』，请及时审批', '<a class=\"side-a\" data-href=\"/home/overtimes/view/id/{action_id}\">去审批</a>', '您有一个新的『加班申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724135970, 0, 0);
INSERT INTO `oa_template` VALUES (12, '加班申请通过', 'overtimes_ok', 1, NULL, '您提交的『加班申请』已被审批通过', '<a class=\"side-a\" data-href=\"/home/overtimes/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『加班申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136004, 0, 0);
INSERT INTO `oa_template` VALUES (13, '加班申请被拒绝', 'overtimes_no', 1, NULL, '您提交的『加班申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/home/overtimes/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『加班申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136042, 0, 0);
INSERT INTO `oa_template` VALUES (14, '用章申请待审批', 'seal_apply', 1, NULL, '{from_user}提交了一个『用章申请』，请及时审批', '<a class=\"side-a\" data-href=\"/adm/seal/view/id/{action_id}\">去审批</a>', '您有一个新的『用章申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136081, 0, 0);
INSERT INTO `oa_template` VALUES (15, '用章申请通过', 'seal_ok', 1, NULL, '您提交的『用章申请』已被审批通过', '<a class=\"side-a\" data-href=\"/adm/seal/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『用章申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136128, 0, 0);
INSERT INTO `oa_template` VALUES (16, '用章申请被拒绝', 'seal_no', 1, NULL, '您提交的『用章申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/adm/seal/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『用章申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136158, 0, 0);
INSERT INTO `oa_template` VALUES (17, '公文申请待审批', 'official_apply', 1, NULL, '{from_user}提交了一个『公文申请』，请及时审批', '<a class=\"side-a\" data-href=\"/adm/official/view/id/{action_id}\">去审批</a>', '您有一个新的『公文申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136211, 0, 0);
INSERT INTO `oa_template` VALUES (18, '公文申请通过', 'official_ok', 1, NULL, '您提交的『公文申请』已被审批通过', '<a class=\"side-a\" data-href=\"/adm/official/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『公文申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136250, 0, 0);
INSERT INTO `oa_template` VALUES (19, '公文申请被拒绝', 'official_no', 1, NULL, '您提交的『公文申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/adm/official/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『公文申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136290, 0, 0);
INSERT INTO `oa_template` VALUES (20, '报销申请待审批', 'expense_apply', 1, NULL, '{from_user}提交了一个『报销申请』，请及时审批', '<a class=\"side-a\" data-href=\"/finance/expense/view/id/{action_id}\">去审批</a>', '您有一个新的『报销申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136340, 0, 0);
INSERT INTO `oa_template` VALUES (21, '报销申请通过', 'expense_ok', 1, NULL, '您提交的『报销申请』已被审批通过', '<a class=\"side-a\" data-href=\"/finance/expense/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『报销申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136382, 0, 0);
INSERT INTO `oa_template` VALUES (22, '报销申请被拒绝', 'expense_no', 1, NULL, '您提交的『报销申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/finance/expense/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『报销申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136419, 0, 0);
INSERT INTO `oa_template` VALUES (23, '报销申请已发放', 'expense_pay', 1, NULL, '您提交的『报销申请』已发放', '<a class=\"side-a\" data-href=\"/finance/expense/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『报销申请』已于{date}发放，请查看是否到账。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136462, 0, 0);
INSERT INTO `oa_template` VALUES (24, '发票申请待审批', 'invoice_apply', 1, NULL, '{from_user}提交了一个『发票申请』，请及时审批', '<a class=\"side-a\" data-href=\"/finance/invoice/view/id/{action_id}\">去审批</a>', '您有一个新的『发票申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136495, 0, 0);
INSERT INTO `oa_template` VALUES (25, '发票申请通过', 'invoice_ok', 1, NULL, '您提交的『发票申请』已被审批通过', '<a class=\"side-a\" data-href=\"/finance/invoice/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『发票申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136542, 0, 0);
INSERT INTO `oa_template` VALUES (26, '发票申请被拒绝', 'invoice_no', 1, NULL, '您提交的『发票申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/finance/invoice/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『发票申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136580, 0, 0);
INSERT INTO `oa_template` VALUES (27, '发票申请已开具', 'invoice_open', 1, NULL, '您提交的『发票申请』已开具好发票', '<a class=\"side-a\" data-href=\"/finance/invoice/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『发票申请』已于{date}已开具好，请查看具体发票信息。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136609, 0, 0);
INSERT INTO `oa_template` VALUES (28, '收票申请待审批', 'ticket_apply', 1, NULL, '{from_user}提交了一个『收票申请』，请及时审批', '<a class=\"side-a\" data-href=\"/finance/ticket/view/id/{action_id}\">去审批</a>', '您有一个新的『收票申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724750048, 1724751142, 0);
INSERT INTO `oa_template` VALUES (29, '收票申请通过', 'ticket_ok', 1, NULL, '您提交的『收票申请』已被审批通过', '<a class=\"side-a\" data-href=\"/finance/ticket/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『收票申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724751487, 0, 0);
INSERT INTO `oa_template` VALUES (30, '收票申请被拒绝', 'ticket_no', 1, NULL, '您提交的『收票申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/finance/ticket/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『收票申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724751542, 0, 0);
INSERT INTO `oa_template` VALUES (31, '销售合同待审批', 'contract_apply', 1, NULL, '{from_user}提交了一个『销售合同审核』，请及时审批', '<a class=\"side-a\" data-href=\"/contract/contract/view/id/{action_id}\">去审批</a>', '您有一个新的『销售合同审核』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136647, 0, 0);
INSERT INTO `oa_template` VALUES (32, '销售合同审批通过', 'contract_ok', 1, NULL, '您提交的『销售合同审核』已被审批通过', '<a class=\"side-a\" data-href=\"/contract/contract/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『合同审核』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136685, 0, 0);
INSERT INTO `oa_template` VALUES (33, '销售合同审批被拒绝', 'contract_no', 1, NULL, '您提交的『销售合同审核』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/contract/contract/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『合同审核』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136718, 0, 0);
INSERT INTO `oa_template` VALUES (34, '采购合同待审批', 'purchase_apply', 1, NULL, '{from_user}提交了一个『采购合同审核』，请及时审批', '<a class=\"side-a\" data-href=\"/contract/purchase/view/id/{action_id}\">去审批</a>', '您有一个新的『采购合同审核』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136755, 0, 0);
INSERT INTO `oa_template` VALUES (35, '采购合同审批通过', 'purchase_ok', 1, NULL, '您提交的『采购合同审核』已被审批通过', '<a class=\"side-a\" data-href=\"/contract/purchase/view/id/{action_id}\">去审批</a>', '您在{create_time}提交的『采购合同审核』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136783, 0, 0);
INSERT INTO `oa_template` VALUES (36, '采购合同审批被拒绝', 'purchase_no', 1, NULL, '您提交的『采购合同审核』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/contract/purchase/view/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『采购合同审核』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724136818, 0, 0);
INSERT INTO `oa_template` VALUES (37, '工作汇报接收通知', 'work', 1, NULL, '{from_user}发了一份新『工作汇报』，请及时查看', '<a class=\"side-a\" data-href=\"/oa/work/view/id/{action_id}\">查看详情</a>', '{from_user}于{send_time}发了一份工作汇报，请及时查看。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724292890, 1724313006, 0);
INSERT INTO `oa_template` VALUES (38, '工作汇报点评通知', 'work_commet', 1, NULL, '{from_user}点评了您的『工作汇报』，请及时查看', '<a class=\"side-a\" data-href=\"/oa/work/view/id/{action_id}\">查看详情</a>', '{from_user}于{create_time}对您的『工作汇报』进行了点评，请及时查看。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1724293060, 1724314320, 0);
INSERT INTO `oa_template` VALUES (39, '无发票回款申请审批', 'invoicea_apply', 1, NULL, '{from_user}提交了一个『无发票回款申请』，请及时审批', '<a class=\"side-a\" data-href=\"/finance/invoice/view_a/id/{action_id}\">去审批</a>', '您有一个新的『无发票回款申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725890572, 1725930801, 0);
INSERT INTO `oa_template` VALUES (40, '无发票回款申请通过', 'invoicea_ok', 1, NULL, '您提交的『无发票回款申请』已被审批通过', '<a class=\"side-a\" data-href=\"/finance/invoice/view_a/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『无发票回款申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725890755, 1725930821, 0);
INSERT INTO `oa_template` VALUES (41, '无发票回款申请拒绝', 'invoicea_no', 1, NULL, '您提交的『无发票回款申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/finance/invoice/view_a/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『无发票回款申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725890846, 1725930836, 0);
INSERT INTO `oa_template` VALUES (42, '无发票付款申请审批', 'ticketa_apply', 1, NULL, '{from_user}提交了一个『无发票付款申请』，请及时审批', '<a class=\"side-a\" data-href=\"/finance/ticket/view_a/id/{action_id}\">去审批</a>', '您有一个新的『无发票付款申请』需要处理。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725935364, 0, 0);
INSERT INTO `oa_template` VALUES (43, '无发票付款申请通过', 'ticketa_ok', 1, NULL, '您提交的『无发票付款申请』已被审批通过', '<a class=\"side-a\" data-href=\"/finance/ticket/view_a/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『无发票付款申请』已于{date}被审批通过。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725935428, 0, 0);
INSERT INTO `oa_template` VALUES (44, '无发票付款申请被拒绝', 'ticketa_no', 1, NULL, '您提交的『无发票付款申请』已被驳回拒绝', '<a class=\"side-a\" data-href=\"/finance/ticket/view_a/id/{action_id}\">查看详情</a>', '您在{create_time}提交的『无发票付款申请』已于{date}被驳回拒绝。', '', '', NULL, '', '', NULL, '', '', NULL, 1, 1, 1725935500, 0, 0);
