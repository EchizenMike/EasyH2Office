ALTER TABLE `oa_admin` 
ADD COLUMN `auth_did` int(2) NOT NULL DEFAULT 0 COMMENT '数据权限:0仅自己关联的数据,1所属主部门的数据,2所属次部门的数据,3所属主次部门的数据,4所属主部门及其子部门数据,5所属次部门及其子部门数据,6所属主次部门及其子部门数据,7所属主部门所在顶级部门及其子部门数据,8所属次部门所在顶级部门及其子部门数据,9所属主次部门所在顶级部门及其子部门数据,10所有部门数据' AFTER `is_lock`;

ALTER TABLE `oa_admin` 
ADD COLUMN `is_staff` int(1) NOT NULL DEFAULT 1 COMMENT '身份类型:1企业员工,2劳务派遣,3兼职员工' AFTER `type`;

ALTER TABLE `oa_admin` 
ADD COLUMN `medical_account` varchar(255) NOT NULL DEFAULT '' COMMENT '医保账号' AFTER `social_account`;