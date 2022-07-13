
-- ----------------------------
-- Table structure for oa_contract_cate
-- ----------------------------
DROP TABLE IF EXISTS `oa_contract_cate`;
CREATE TABLE `oa_contract_cate`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '合同类别名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：-1删除 0禁用 1启用',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '合同类别';

-- ----------------------------
-- Records of oa_contract_cate
-- ----------------------------
INSERT INTO `oa_contract_cate` VALUES (1, '销售合同', 1, 1637987189, 0);
INSERT INTO `oa_contract_cate` VALUES (2, '采购合同', 1, 1637987199, 0);
INSERT INTO `oa_contract_cate` VALUES (3, '租赁合同', 1, 1637987199, 0);
INSERT INTO `oa_contract_cate` VALUES (4, '委托协议', 1, 1637987199, 0);
INSERT INTO `oa_contract_cate` VALUES (5, '代理协议', 1, 1637987199, 0);
INSERT INTO `oa_contract_cate` VALUES (6, '其他合同', 1, 1637987199, 0);

-- ----------------------------
-- Table structure for oa_contract
-- ----------------------------
DROP TABLE IF EXISTS `oa_contract`;
CREATE TABLE `oa_contract`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '父协议id',
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '合同编号',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '合同名称',
  `cate_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分类id',
  `type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '合同性质：0未设置,1普通合同、2框架合同、3补充协议、4其他合同',
  `subject_id` varchar(255) NOT NULL DEFAULT '' COMMENT '签约主体',
  `customer_id` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '客户ID,预设数据',
  `customer` varchar(255) NOT NULL DEFAULT '' COMMENT '客户名称',
  `customer_name` varchar(255) NOT NULL DEFAULT '' COMMENT '客户代表',
  `customer_mobile` varchar(255) NOT NULL DEFAULT '' COMMENT '客户电话',
  `customer_address` varchar(255) NOT NULL DEFAULT '' COMMENT '客户地址',
  `start_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同开始时间',
  `end_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同结束时间',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `prepared_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同制定人',
  `sign_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同签订人',
  `keeper_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同保管人', 
  `share_ids` varchar(500) NOT NULL DEFAULT '' COMMENT '共享人员，如:1,2,3',
  `sign_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同签订时间',
  `sign_did` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '合同签订部门',
  `cost` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '合同金额',
  `is_tax` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否含税：0未含税,1含税',
  `tax` decimal(15, 2) NOT NULL DEFAULT 0.00 COMMENT '税点',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '合同状态：0未设置,1已录入,2待审核,3已审核,4已中止,5已作废',
  `check_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核人',
  `check_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核时间',
  `check_remark` text NULL COMMENT '审核备注信息',
  `stop_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '中止人',
  `stop_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '中止时间',
  `stop_remark` text NULL COMMENT '中止备注信息',
  `void_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '作废人',
  `void_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '作废时间',
  `void_remark` text NULL COMMENT '作废备注信息',
  `archive_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '归档状态：0未归档,1已归档',
  `archive_uid` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '归档人',
  `archive_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '归档时间',
  `remark` text NULL COMMENT '备注信息',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `delete_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1000 CHARACTER SET = utf8mb4 COMMENT = '合同表';

-- ----------------------------
-- Table structure for oa_contract_file
-- ----------------------------
DROP TABLE IF EXISTS `oa_contract_file`;
CREATE TABLE `oa_contract_file`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` int(11) UNSIGNED NOT NULL COMMENT '关联合同id',
  `file_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '相关联附件id',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建人',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `delete_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '删除时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '合同附件关联表';

-- ----------------------------
-- Table structure for oa_contract_log
-- ----------------------------
DROP TABLE IF EXISTS `oa_contract_log`;
CREATE TABLE `oa_contract_log`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `action` varchar(100) NOT NULL DEFAULT 'edit' COMMENT '动作:add,edit,del,check,upload',
  `field` varchar(100) NOT NULL DEFAULT '' COMMENT '字段',
  `contract_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联合同id',
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作人',
  `old_content` text NULL COMMENT '修改前的内容',
  `new_content` text NULL COMMENT '修改后的内容',
  `remark` text NULL COMMENT '补充备注',
  `create_time` int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '合同操作记录表';


-- ----------------------------
-- Table structure for oa_data_auth
-- ----------------------------
DROP TABLE IF EXISTS `oa_data_auth`;
CREATE TABLE `oa_data_auth`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '权限名称',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '权限标识唯一，字母',
  `desc` text NULL COMMENT '备注描述',
  `module` varchar(255) NOT NULL DEFAULT '' COMMENT '所属模块，唯一，字母',
  `uids` text NULL COMMENT '权限用户，1,2,3',
  `create_time` int(11) NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(11) NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COMMENT = '数据权限表';


INSERT INTO `oa_data_auth` VALUES ((SELECT MAX(id) +1  FROM `oa_data_auth` a), '合同管理员','contract_admin','拥有该权限的员工可以查看、编辑、审核、作废、中止所有合同。', 'contract', '',0,0,0, 1656143065, 0);