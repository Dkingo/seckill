/*
 Navicat Premium Data Transfer

 Source Server         : D.k_mysql
 Source Server Type    : MySQL
 Source Server Version : 80016
 Source Host           : localhost:3306
 Source Schema         : seckill

 Target Server Type    : MySQL
 Target Server Version : 80016
 File Encoding         : 65001

 Date: 27/08/2020 15:42:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for seckill
-- ----------------------------
DROP TABLE IF EXISTS `seckill`;
CREATE TABLE `seckill`  (
  `seckill_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品库存id',
  `name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品名称',
  `number` int(11) NOT NULL COMMENT '库存数量',
  `start_time` timestamp(0) NOT NULL COMMENT '秒杀开启时间',
  `end_time` timestamp(0) NOT NULL COMMENT '秒杀结束时间',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`seckill_id`) USING BTREE,
  INDEX `idx_start_time`(`start_time`) USING BTREE,
  INDEX `idx_end_time`(`end_time`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1013 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '秒杀库存表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of seckill
-- ----------------------------
INSERT INTO `seckill` VALUES (1004, '1000元秒杀iphone6', 94, '2020-04-19 00:00:00', '2020-05-13 00:00:00', '2020-04-11 17:30:45');
INSERT INTO `seckill` VALUES (1005, '500元秒杀ipad2', 198, '2020-04-12 00:00:00', '2020-10-16 00:00:00', '2020-04-11 17:30:45');
INSERT INTO `seckill` VALUES (1006, '300元秒杀小米4', 300, '2020-08-01 00:00:00', '2020-10-03 00:00:00', '2020-04-11 17:30:45');
INSERT INTO `seckill` VALUES (1007, '200元秒杀华为P40', 400, '2020-04-12 00:00:00', '2020-05-13 00:00:00', '2020-04-11 17:30:45');
INSERT INTO `seckill` VALUES (1008, '100元秒杀iphone8', 20, '2020-07-15 23:31:45', '2020-07-16 23:31:56', '2020-07-15 23:31:45');
INSERT INTO `seckill` VALUES (1009, '200元秒杀三星8', 30, '2020-07-15 10:19:16', '2020-07-18 10:19:21', '2020-07-15 10:19:16');
INSERT INTO `seckill` VALUES (1010, '500元秒杀三星10', 50, '2020-07-17 10:19:51', '2020-07-31 10:19:55', '2020-07-15 10:20:01');
INSERT INTO `seckill` VALUES (1011, '1000元秒杀小灵通', 50, '2020-08-20 10:20:22', '2020-09-10 10:20:26', '2020-07-15 10:20:33');
INSERT INTO `seckill` VALUES (1012, '1000元秒杀华为p30', 500, '2020-07-24 10:21:05', '2020-08-14 10:21:10', '2020-07-15 10:21:18');
INSERT INTO `seckill` VALUES (1013, '500元秒杀单反', 998, '2020-07-18 10:21:45', '2020-07-29 10:21:49', '2020-07-15 10:21:53');

-- ----------------------------
-- Table structure for success_killed
-- ----------------------------
DROP TABLE IF EXISTS `success_killed`;
CREATE TABLE `success_killed`  (
  `seckill_id` bigint(20) NOT NULL COMMENT '秒杀商品id',
  `user_phone` bigint(20) NOT NULL COMMENT '用户手机号',
  `state` tinyint(4) NOT NULL DEFAULT -1 COMMENT '状态标识：-1：无效 0：成功 1:已付款',
  `create_time` timestamp(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`seckill_id`, `user_phone`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '秒杀成功明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of success_killed
-- ----------------------------
INSERT INTO `success_killed` VALUES (1004, 12345647894, -1, '2020-04-23 10:23:37');
INSERT INTO `success_killed` VALUES (1004, 12345678912, -1, '2020-04-23 13:07:29');
INSERT INTO `success_killed` VALUES (1004, 12345678961, 0, '2020-04-22 11:52:43');
INSERT INTO `success_killed` VALUES (1004, 12543586312, 0, '2020-04-23 11:32:43');
INSERT INTO `success_killed` VALUES (1004, 13515236478, 0, '2020-04-13 13:45:24');
INSERT INTO `success_killed` VALUES (1004, 13545321452, 1, '2020-04-14 15:27:54');
INSERT INTO `success_killed` VALUES (1004, 13545321455, 1, '2020-04-14 15:33:16');
INSERT INTO `success_killed` VALUES (1005, 12345678912, 0, '2020-04-18 17:50:59');
INSERT INTO `success_killed` VALUES (1005, 12345678951, -1, '2020-07-14 15:29:59');
INSERT INTO `success_killed` VALUES (1005, 13515236478, 0, '2020-04-13 13:49:58');
INSERT INTO `success_killed` VALUES (1013, 12345678951, -1, '2020-07-19 07:54:15');

-- ----------------------------
-- Procedure structure for execute_seckill
-- ----------------------------
DROP PROCEDURE IF EXISTS `execute_seckill`;
delimiter ;;
CREATE PROCEDURE `execute_seckill`(in v_seckill_id bigint, in v_phone bigint,
     in v_kill_time timestamp , out r_result int)
begin
     declare insert_count int default 0;
     start transaction ;
     insert ignore into success_killed
        (seckill_id, user_phone, create_time)
        values (v_seckill_id, v_phone, v_kill_time);
     select row_count() into insert_count;
     if (insert_count < 0) then
        rollback;
        set r_result = -2;
     else
        update seckill
        set number = number - 1
        where seckill_id = v_seckill_id
          and end_time > v_kill_time
          and start_time < v_kill_time
          and number > 0;
        select row_count() into insert_count;
        if (insert_count = 0) then
            rollback;
            set r_result = 0;
        elseif (insert_count < 0) then
            rollback;
            set  r_result = -2;
        else
            commit;
            set r_result = 1;
        end if;
     end if;
    end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
