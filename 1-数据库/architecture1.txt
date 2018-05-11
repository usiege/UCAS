CREATE SCHEMA architectur;

CREATE TABLE `architectur`.`component` (
  `bigComponent_id` INT(12) NOT NULL COMMENT '元器件ID',
  `bigComponent_name` VARCHAR(64) NOT NULL COMMENT '权限名称',
  `bigComponent_type` VARCHAR(64) NOT NULL COMMENT '元器件种类',
  `remark` VARCHAR(128) NULL COMMENT '备注信息',
  PRIMARY KEY (`bigComponent_id`));

  
  
  CREATE TABLE `architectur`.`component_branch` (
  `comBranch_id` INT(12) NOT NULL COMMENT '元器件ID',
  `comBranch_name` VARCHAR(128) NOT NULL COMMENT '权限名字',
  `comBranch_type` VARCHAR(64) NOT NULL COMMENT '元器件种类',
  `bigComponent_type` VARCHAR(64) NOT NULL COMMENT '元器大类',
  `remark` VARCHAR(256) NULL,
  PRIMARY KEY (`comBranch_id`));
  
  CREATE TABLE `architectur`.`new_component` (
  `component_id` VARCHAR(32) NOT NULL,
  `component_name` VARCHAR(64) NULL COMMENT '物料名称',
  `component_bType` VARCHAR(64) NOT NULL COMMENT '元器件大种类',
  `component_sType` VARCHAR(64) NOT NULL COMMENT '元器件大种类之子类',
  `component_status` VARCHAR(64)  NULL COMMENT '物料状态',
  `spec_model` VARCHAR(64) NOT NULL COMMENT '规格型号',
  `briefexplanation` VARCHAR(64) NULL COMMENT '简要说明信息',
  `funct` VARCHAR(64) NULL COMMENT '功能',
  `pack` VARCHAR(64) NULL COMMENT '封装',
  `manufacturer` VARCHAR(64) NOT NULL COMMENT '生产厂家',
  `component_data` VARCHAR(64) NULL COMMENT '器件资料',
  `remark` VARCHAR(128) NULL COMMENT '备注',
  PRIMARY KEY (`component_id`));

  
  CREATE TABLE `architectur`.`old_component` (
  `oldComponent_id` VARCHAR(32) NOT NULL COMMENT '元器件编码',
  `oldComponent_name` VARCHAR(64) NOT NULL COMMENT '物料名称',
  `oldComponent_bType` VARCHAR(64)  NULL COMMENT '元器件大种类',
  `oldComponent_sType` VARCHAR(64)  NULL COMMENT '元器件大种类之子类',
  `oldComponent_status` VARCHAR(64) NOT NULL COMMENT '物料状态',
  `oldSpec_model` VARCHAR(64) NULL COMMENT '规格型号',
  `oldBrief_explana` VARCHAR(64) NULL COMMENT '简要说明信息',
  `old_funct` VARCHAR(64) NULL COMMENT '功能',
  `old_package` VARCHAR(64) NOT NULL COMMENT '封装',
  `old_manufact` VARCHAR(64) NULL COMMENT '生产厂家',
  `oldComponent_data` VARCHAR(64) NULL COMMENT '器件资料',
  `remark` VARCHAR(128) NULL,
  PRIMARY KEY (`oldComponent_id`))
ENGINE = InnoDB;


CREATE TABLE `architectur`.`user` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NULL,
  `user_role` INT(11) NULL,
  `remark` VARCHAR(64) NULL,
  PRIMARY KEY (`user_id`));

  
  CREATE TABLE `architectur`.`sequence` (
  `name` VARCHAR(32) NOT NULL,
  `current_value` INT(11) NOT NULL,
  `increment` INT(11) NOT NULL,
  PRIMARY KEY (`name`));

  
USE `architectur`;
DROP function IF EXISTS `setval`;

DELIMITER $$
USE `architectur`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `setval`(seq_name VARCHAR(50), value INTEGER) RETURNS int(11)
    DETERMINISTIC
BEGIN
    UPDATE sequence
    SET current_value = value
    WHERE name = seq_name;
    RETURN currval(seq_name);
  END$$

DELIMITER ;


USE `architectur`;
DROP function IF EXISTS `nextval`;

DELIMITER $$
USE `architectur`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `nextval`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    UPDATE sequence
    SET current_value = current_value + increment
    WHERE name = seq_name;
    RETURN currval(seq_name);
  END$$

DELIMITER ;


USE `architectur`;
DROP function IF EXISTS `currval`;

DELIMITER $$
USE `architectur`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `currval`(seq_name VARCHAR(50)) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE value INTEGER;
    SET value = 0;
    SELECT current_value INTO value
    FROM sequence
    WHERE name = seq_name;
    RETURN value;
  END$$

DELIMITER ;


USE `architectur`;
CREATE  OR REPLACE VIEW `allcomponent` AS
SELECT 
        `new_component`.`component_id` AS `component_id`,
        `new_component`.`component_name` AS `component_name`,
        `new_component`.`component_status` AS `component_status`,
        `new_component`.`spec_model` AS `spec_model`,
        `new_component`.`briefexplanation` AS `briefexplanation`,
        `new_component`.`funct` AS `funct`,
        `new_component`.`pack` AS `pack`,
        `new_component`.`manufacturer` AS `manufacture`,
        `new_component`.`component_data` AS `component_data`,
        `new_component`.`remark` AS `remark`
    FROM
        `new_component` 
    UNION SELECT 
        `old_component`.`oldComponent_id` AS `component_id`,
        `old_component`.`oldComponent_name` AS `component_name`,
        `old_component`.`oldComponent_status` AS `component_status`,
        `old_component`.`oldSpec_model` AS `spec_model`,
        `old_component`.`oldBrief_explana` AS `briefexplanation`,
        `old_component`.`old_funct` AS `funct`,
        `old_component`.`old_package` AS `pack`,
        `old_component`.`old_manufact` AS `manufacture`,
        `old_component`.`oldComponent_data` AS `component_data`,
        `old_component`.`remark` AS `remark`
    FROM
        `old_component`;;
DELIMITER ;
  
  
    USE `architectur`;
DROP procedure IF EXISTS `query_resistance_info`;

DELIMITER $$
USE `architectur`$$
CREATE PROCEDURE `query_resistance_info`(IN modelType VARCHAR(40),IN specModel VARCHAR(40))
BEGIN
CREATE TEMPORARY TABLE
		IF NOT EXISTS resistance_info (
			`oldComponentId` VARCHAR (64) NOT NULL,
			`oldComponentName` VARCHAR (64) NOT NULL,
			`oldSpecModel` VARCHAR (64),
			`oldPackage` VARCHAR (64) NOT NULL,
            `oldBriefExplana` VARCHAR (128)
		) ENGINE = MEMORY;

		#清空临时表中的数据
		TRUNCATE TABLE resistance_info;
		
		INSERT INTO resistance_info 
		SELECT  
		oldComponent_id,
		oldComponent_name,
		oldSpec_model,
		old_package,
        oldBrief_explana 
		FROM old_component  where substr(oldSpec_model,-4)= modelType and substr(oldSpec_model,1,length(oldSpec_model)-4)<substr(specModel,1,length(specModel)-4)*1.1
		and substr(oldSpec_model,1,length(oldSpec_model)-4) > substr(specModel,1,length(specModel)-4)* 0.9;
		
		SELECT ts.oldComponentId,ts.oldComponentName,ts.oldSpecModel,ts.oldPackage,ts.oldBriefExplana from resistance_info ;
END
$$

DELIMITER ;
  
  
  
  

