-- MySQL dump 10.13  Distrib 5.7.44, for Linux (x86_64)
--
-- Host: localhost    Database: ershou
-- ------------------------------------------------------
-- Server version	5.7.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `address_book`
--

DROP TABLE IF EXISTS `address_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '地址簿id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  `consignee` varchar(20) NOT NULL COMMENT '收货人',
  `phone` varchar(20) NOT NULL COMMENT '手机号',
  `address` varchar(100) NOT NULL COMMENT '详细地址',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否为默认地址',
  PRIMARY KEY (`id`),
  KEY `address_book_user_id_fk` (`user_id`),
  CONSTRAINT `address_book_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='地址簿表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address_book`
--

LOCK TABLES `address_book` WRITE;
/*!40000 ALTER TABLE `address_book` DISABLE KEYS */;
INSERT INTO `address_book` VALUES (1,1,'包萝卜','10086','麻涌大学',0),(2,1,'包人','10001','香蕉大学',0),(4,7,'包人','10001','北京市北京市东城区123123',0),(6,7,'包人','10001','吉林省辽源市西安区锅包肉之乡',0),(8,5,'宝网','123456','北京市北京市东城区新华',1),(9,7,'包人','1339215427','北京市北京市东城区北京人',0),(10,7,'包包','15875436417','辽宁省辽阳市太子河区超绝萝卜头',0),(11,1,'zzh','9999999999','占位占位undefined503',0);
/*!40000 ALTER TABLE `address_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) DEFAULT NULL COMMENT '账号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `create_user` int(11) NOT NULL COMMENT '创建人',
  `update_user` int(11) NOT NULL COMMENT '修改人',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '启用状态',
  PRIMARY KEY (`id`),
  UNIQUE KEY `admin_pk` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','2024-10-10 19:24:41','2024-10-12 22:29:44',1,1,1),(2,'admin2','e10adc3949ba59abbe56e057f20f883e','2024-10-17 19:23:57','2024-10-17 19:24:00',1,1,0);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类id',
  `name` varchar(20) NOT NULL COMMENT '分类名称',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` int(11) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `update_user` int(11) DEFAULT NULL COMMENT '修改人',
  `carbon_reduction` double DEFAULT NULL COMMENT '减碳量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_pk` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'测试','2024-10-10 19:25:42',1,'2024-10-18 20:57:44',1,1.1),(2,'你好分类','2024-10-13 23:31:02',1,'2024-10-13 23:31:02',1,NULL),(3,'hahaha分类','2024-10-13 23:31:10',1,'2024-10-13 23:31:10',1,NULL);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat`
--

DROP TABLE IF EXISTS `chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fromuser_id` int(11) NOT NULL COMMENT '发消息者id',
  `touser_id` int(11) NOT NULL COMMENT '接收消息者id',
  `content` varchar(200) DEFAULT NULL COMMENT '内容',
  `time` datetime NOT NULL COMMENT '发送消息时间',
  `type` varchar(10) NOT NULL COMMENT '类型',
  `is_readed` tinyint(4) NOT NULL COMMENT '是否已读--0表示未读，1表示已读',
  PRIMARY KEY (`id`),
  KEY `chat_fk1` (`fromuser_id`),
  KEY `chat_fk2` (`touser_id`),
  CONSTRAINT `chat_fk1` FOREIGN KEY (`fromuser_id`) REFERENCES `user` (`id`),
  CONSTRAINT `chat_fk2` FOREIGN KEY (`touser_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='聊天记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat`
--

LOCK TABLES `chat` WRITE;
/*!40000 ALTER TABLE `chat` DISABLE KEYS */;
INSERT INTO `chat` VALUES (1,1,2,'你好!','2024-10-20 21:10:39','text',1),(2,1,2,'包王哈哈哈哈!','2024-10-23 11:10:36','text',1),(3,2,1,'包!','2024-10-23 11:16:02','text',1),(4,2,1,'人!','2024-10-23 11:27:45','text',1),(5,1,2,'人!','2024-10-23 11:32:00','text',1);
/*!40000 ALTER TABLE `chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `number` varchar(50) NOT NULL COMMENT '订单号',
  `status` tinyint(4) NOT NULL COMMENT '订单状态',
  `buyer_id` int(11) NOT NULL COMMENT '买家id',
  `seller_id` int(11) NOT NULL COMMENT '卖家id',
  `product_id` int(11) NOT NULL COMMENT '商品id',
  `title` varchar(30) NOT NULL COMMENT '商品标题',
  `image` varchar(100) NOT NULL COMMENT '商品封面',
  `amount` double NOT NULL COMMENT '实收金额--价格+运费',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `consignee` varchar(20) NOT NULL COMMENT '收货人',
  `phone` varchar(20) NOT NULL COMMENT '电话',
  `address` varchar(100) NOT NULL COMMENT '地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `order_fk2` (`buyer_id`),
  KEY `order_fk3` (`seller_id`),
  KEY `order_fk4` (`product_id`),
  CONSTRAINT `order_fk2` FOREIGN KEY (`buyer_id`) REFERENCES `user` (`id`),
  CONSTRAINT `order_fk3` FOREIGN KEY (`seller_id`) REFERENCES `user` (`id`),
  CONSTRAINT `order_fk4` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='订单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (3,'1729401529486',3,1,7,5,'超绝萝卜头','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',628,'无','包萝卜','10086','麻涌大学','2024-10-20 13:18:50'),(4,'1729401939720',1,1,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,'狗屎包','包人','10001','香蕉大学','2024-10-20 13:25:40'),(5,'1729401954323',1,1,7,8,'测试1','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/141a9378-7f3d-4782-ad27-384ddcf7aa45.jpg',246,'狗屎包','包人','10001','香蕉大学','2024-10-20 13:25:54'),(6,'1729402644909',1,9,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,'','包萝卜','10086','麻涌大学','2024-10-20 13:37:27'),(7,'1729402656607',1,9,1,2,'商品1','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg',109,'','包萝卜','10086','麻涌大学','2024-10-20 13:37:38'),(8,'1729436585233',1,1,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,'hello','包萝卜','10086','麻涌大学','2024-10-20 23:03:05'),(9,'1729436605406',1,1,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,'hello','包萝卜','10086','麻涌大学','2024-10-20 23:03:25'),(10,'1729436632730',1,1,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,'hello','包萝卜','10086','麻涌大学','2024-10-20 23:03:53'),(11,'1729436708679',4,1,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,'hello','包萝卜','10086','麻涌大学','2024-10-20 23:05:09'),(19,'1729441540460',4,5,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-21 00:25:40'),(20,'1729441929102',5,5,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-21 00:32:09'),(21,'1729441931838',5,5,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-21 00:32:12'),(22,'1729441952073',5,5,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-21 00:32:32'),(23,'1729479858181',5,7,7,6,'漂亮妹子超绝写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg',228,NULL,'包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 11:04:18'),(24,'1729480442658',5,7,7,8,'测试1','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/141a9378-7f3d-4782-ad27-384ddcf7aa45.jpg',246,'我是你爹','包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 11:14:03'),(25,'1729480458600',2,7,1,2,'商品1','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg',109,'我是你爹','包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 11:14:19'),(26,'1729480708465',5,7,1,1,'你好','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg',18,NULL,'包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 11:18:29'),(27,'1729481126404',5,7,1,3,'商品2','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg',114,NULL,'包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 11:25:26'),(28,'1729481139309',5,7,1,3,'商品2','https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg',114,NULL,'包人','10001','北京市北京市东城区123123','2024-10-21 11:25:39'),(29,'1729484549836',5,7,1,11,'数字图像处理无敌答案','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/b45cf1f0-5bbc-4f45-abe7-1450e146b8f1.png',110,'我要无敌答案','包人','10001','北京市北京市东城区123123','2024-10-21 12:22:30'),(30,'1729487092198',5,7,7,12,'金鱼佬','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/76fbb528-5723-4e24-b36f-c1c994ad8f0c.jpg',1.8,'我是金鱼佬的爹','包人','10001','吉林省辽源市西安区锅包肉之乡','2024-10-21 13:04:52'),(31,'1729487132214',4,7,7,12,'金鱼佬','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/76fbb528-5723-4e24-b36f-c1c994ad8f0c.jpg',1.8,'我是爱吃金鱼','包人','10001','北京市北京市东城区123123','2024-10-21 13:05:32'),(32,'1729491302251',5,7,1,11,'数字图像处理无敌答案','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/b45cf1f0-5bbc-4f45-abe7-1450e146b8f1.png',110,NULL,'包人','1339215427','北京市北京市东城区北京人','2024-10-21 14:15:02'),(33,'1729497518036',3,7,7,12,'金鱼佬','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/76fbb528-5723-4e24-b36f-c1c994ad8f0c.jpg',1.8,NULL,'包包','15875436417','辽宁省辽阳市太子河区超绝萝卜头','2024-10-21 15:58:38'),(34,'1729500638656',3,1,7,13,'vivo x100 12+512','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/c81977b8-5193-4a5a-a044-5efbb4265e52.jpg',4000,'让zhy送货上门','zzh','9999999999','占位占位undefined503','2024-10-21 16:50:39'),(35,'1729524968313',2,1,1,11,'数字图像处理无敌答案','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/b45cf1f0-5bbc-4f45-abe7-1450e146b8f1.png',110,'在我面前你敢说你图像处理无敌？不服碰碰，我叫吕耿康，月入1000个的小老板','包人','10001','香蕉大学','2024-10-21 23:36:08'),(36,'1729570530971',5,5,7,15,'马菜脯1.5星火单词书','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/da710316-741b-4456-9516-9e23e28c56af.jpg',1001.2,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:15:31'),(37,'1729570698037',5,5,7,15,'马菜脯1.5星火单词书','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/da710316-741b-4456-9516-9e23e28c56af.jpg',1001.2,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:18:18'),(38,'1729570753955',5,5,7,15,'马菜脯1.5星火单词书','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/da710316-741b-4456-9516-9e23e28c56af.jpg',1001.2,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:19:14'),(39,'1729570796964',5,5,7,15,'马菜脯1.5星火单词书','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/da710316-741b-4456-9516-9e23e28c56af.jpg',1001.2,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:19:57'),(40,'1729570935278',5,5,1,14,'zhy超绝私密写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/cda1c42b-fb70-49a6-aec0-65ecb1401ea9.webp',1998,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:22:15'),(41,'1729571073440',5,5,1,14,'zhy超绝私密写真','https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/cda1c42b-fb70-49a6-aec0-65ecb1401ea9.webp',1998,NULL,'宝网','123456','北京市北京市东城区新华','2024-10-22 12:24:33');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `user_id` int(11) DEFAULT NULL COMMENT '卖家id',
  `category_id` int(11) DEFAULT NULL COMMENT '分类id',
  `price` double NOT NULL COMMENT '价格',
  `title` varchar(30) NOT NULL COMMENT '标题',
  `desc` varchar(50) DEFAULT NULL COMMENT '描述',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '商品状态',
  `is_saled` tinyint(4) NOT NULL DEFAULT '0' COMMENT '售出状态',
  `freight` int(11) NOT NULL COMMENT '运费',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  `remark` varchar(100) DEFAULT NULL COMMENT '管理端审核是否通过的备注',
  PRIMARY KEY (`id`),
  KEY `product_fk1` (`user_id`),
  KEY `product_fk2` (`category_id`),
  CONSTRAINT `product_fk1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `product_fk2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COMMENT='商品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,1,10,'你好','哈哈哈哈哈',1,0,8,'2024-10-11 14:52:37','2024-10-17 17:22:43',NULL),(2,1,1,100,'商品1','123123312312321',1,0,9,'2024-10-11 15:29:47','2024-10-11 15:31:04',NULL),(3,1,1,109,'商品2','122321',1,0,5,'2024-10-11 15:30:07','2024-10-11 15:31:06',NULL),(5,7,2,114,'超绝萝卜头','无敌萝卜头',1,0,514,'2024-10-15 23:52:26','2024-10-15 23:52:26',NULL),(6,7,3,114,'漂亮妹子超绝写真','超绝写真',1,1,114,'2024-10-15 23:55:13','2024-10-23 15:22:35',NULL),(8,7,3,123,'测试1','123123213123',1,1,123,'2024-10-17 14:19:21','2024-10-23 12:07:44',NULL),(9,7,3,123,'123','123123123',2,0,123123,'2024-10-17 14:31:03','2024-10-22 13:27:30','太包'),(11,1,1,100,'数字图像处理无敌答案','数字图像处理无敌答案',1,0,10,'2024-10-21 12:20:39','2024-10-21 12:21:43','审核通过'),(12,7,2,0.8,'金鱼佬','卖🐋了',1,1,1,'2024-10-21 13:00:24','2024-10-21 22:58:55','审核通过'),(13,7,2,4000,'vivo x100 12+512','vivox100 碉堡了',1,0,0,'2024-10-21 16:38:00','2024-10-21 16:42:52','审核通过'),(14,1,2,999,'zhy超绝私密写真','！！！！！！！！！！！！！！',1,0,999,'2024-10-21 16:56:20','2024-10-21 16:57:22','审核通过'),(15,7,1,1.2,'马菜脯1.5星火单词书','低价书',1,0,1000,'2024-10-21 23:17:08','2024-10-21 23:17:37','审核通过'),(16,5,1,100,'超绝数字图像处理灰度图片','数字图像处理超绝照片',0,0,1,'2024-10-22 10:56:43','2024-10-22 11:54:20',NULL),(17,5,1,20213,'无敌默认头像','无敌默认头像',0,0,122,'2024-10-22 11:46:03','2024-10-22 11:46:03',NULL),(18,5,1,59,'切尔西无敌球衣越南版','切尔西无敌球衣越南版，直接梨花香启动了',0,0,10,'2024-10-22 11:58:18','2024-10-22 11:58:18',NULL),(19,7,1,0.1,'计算机专业数据二手出售','标价非实际价格，需要先交流',2,0,0,'2024-10-23 12:09:08','2024-10-23 12:24:37',NULL);
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_collection`
--

DROP TABLE IF EXISTS `product_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_collection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL COMMENT '商品id',
  `user_id` int(11) NOT NULL COMMENT '用户id',
  PRIMARY KEY (`id`),
  KEY `collection_fk1` (`product_id`),
  KEY `collection_fk2` (`user_id`),
  CONSTRAINT `collection_fk1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  CONSTRAINT `collection_fk2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COMMENT='商品收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_collection`
--

LOCK TABLES `product_collection` WRITE;
/*!40000 ALTER TABLE `product_collection` DISABLE KEYS */;
INSERT INTO `product_collection` VALUES (3,1,1),(4,2,1),(5,3,1),(8,6,1),(26,8,5),(27,6,5),(28,5,5),(29,3,5),(30,2,5),(31,1,5),(36,3,7),(38,6,7),(39,8,7),(40,2,7),(42,12,7),(43,11,7),(46,12,5),(47,13,1),(48,14,5);
/*!40000 ALTER TABLE `product_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_detail`
--

DROP TABLE IF EXISTS `product_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `product_detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `product_id` int(11) NOT NULL COMMENT '商品id',
  `image` varchar(100) NOT NULL COMMENT '图片url',
  PRIMARY KEY (`id`),
  KEY `product_detail_fk` (`product_id`),
  CONSTRAINT `product_detail_fk` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COMMENT='商品详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_detail`
--

LOCK TABLES `product_detail` WRITE;
/*!40000 ALTER TABLE `product_detail` DISABLE KEYS */;
INSERT INTO `product_detail` VALUES (1,1,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(2,1,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(3,2,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg'),(4,2,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(5,3,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/15625c47-dc25-4b8c-9917-023977b78575.jpg'),(6,3,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(8,5,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(9,5,'https://bao-tlias.oss-cn-guangzhou.aliyuncs.com/07fc67d7-3571-459a-9209-140a235a2bac.jpg'),(20,8,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/141a9378-7f3d-4782-ad27-384ddcf7aa45.jpg'),(22,9,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/40d544df-589e-4abb-94df-06a9e1a32d51.jpg'),(23,9,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/c42ac773-e5bf-4da2-91e8-ce307d58b064.jpg'),(24,6,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1deaffe1-0746-4b64-a9aa-3bdcfcbfe7a8.jpg'),(25,6,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/ec2c35b1-5a07-4281-8968-a80c1e1d2e04.jpg'),(28,11,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/b45cf1f0-5bbc-4f45-abe7-1450e146b8f1.png'),(29,11,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/2587bc65-b398-43d1-9a70-4e297a7851b9.png'),(30,11,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/83c31fed-174a-43f2-a75e-a731ea63ef2a.png'),(31,12,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/76fbb528-5723-4e24-b36f-c1c994ad8f0c.jpg'),(32,13,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/c81977b8-5193-4a5a-a044-5efbb4265e52.jpg'),(33,14,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/cda1c42b-fb70-49a6-aec0-65ecb1401ea9.webp'),(34,15,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/da710316-741b-4456-9516-9e23e28c56af.jpg'),(36,17,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1e0959fa-2fbf-4b90-b649-3238904a4494.jpg'),(39,16,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/2c341642-6fc2-43fd-9ad5-8e319f852255.jpg'),(40,18,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/6f84ca1e-3516-4674-8a9c-68c97c3ad7bc.jpg'),(41,19,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/4d430908-f962-488f-97e6-7f3df9ddbf3d.jpg');
/*!40000 ALTER TABLE `product_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `username` varchar(20) NOT NULL COMMENT '账户名',
  `account` varchar(30) NOT NULL COMMENT '账号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `point` int(11) DEFAULT '0' COMMENT '环保积分',
  `rate` float DEFAULT '0' COMMENT '卖家评分',
  `avatar` varchar(100) DEFAULT NULL COMMENT '头像url',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_pk` (`account`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'包萝卜头','user','e10adc3949ba59abbe56e057f20f883e',18,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/1f15fb9f-a355-4a17-af7f-33dcada046d7.webp','2024-10-10 19:28:01','2024-10-21 17:10:03'),(2,'用户6e9ba124-652b','12345','e10adc3949ba59abbe56e057f20f883e',0,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.jpg','2024-10-11 19:03:42','2024-10-11 19:03:42'),(5,'无敌滑蛋饭','2486667864@qq.com','e10adc3949ba59abbe56e057f20f883e',228,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/70326940-cb52-4ea9-8a1a-a766c64cd229.jpg','2024-10-11 21:28:17','2024-10-22 14:19:24'),(7,'我是你爹包包驼','2359376088@qq.com','e10adc3949ba59abbe56e057f20f883e',1,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/52695f36-3872-4d72-b59e-57a416b55469.jpg','2024-10-11 21:29:43','2024-10-21 14:18:02'),(8,'用户1e85ec49-dd46','1710713906@qq.com','e10adc3949ba59abbe56e057f20f883e',0,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.jpg','2024-10-15 11:48:55','2024-10-15 11:48:55'),(9,'用户17c45db0-46b5','1234567','e10adc3949ba59abbe56e057f20f883e',0,0,'https://jj-tlias.oss-cn-hangzhou.aliyuncs.com/%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.jpg','2024-10-16 12:53:59','2024-10-16 12:53:59');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ershou'
--

--
-- Dumping routines for database 'ershou'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-23 23:14:41
