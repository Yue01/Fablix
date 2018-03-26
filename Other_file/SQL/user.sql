DROP DATABASE IF EXISTS usercc;
CREATE DATABASE usercc;

USE usercc;

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `email` varchar(10) NOT NULL,
  `password` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--
create table creditcard(
    credit varchar(20),
    exp varchar(20),
    first varchar(20),
    last varchar(20)
    );
create table sales(
    firstname varchar(20),
    lastname varchar(20),
    time varchar(20)
);
insert into creditcard values('1','1','1','1');
insert into creditcard values('2','2','2','2');
insert into creditcard values('3','3','3','3');
insert into creditcard values('4','4','4','4');
insert into creditcard values('5','5','5','5');
insert into creditcard values('6','6','6','6');
insert into creditcard values('7','7','7','7');
insert into creditcard values('8','8','8','8');
insert into creditcard values('9','9','9','9');
insert into creditcard values('10','10','10','10');


LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('4@4.com','4'),('5@5.com','5'),('6@6.com','6'),('7@7.com','7'),('8@8.com','8'),('9@9.com','9'),('10@10.com','10'),('11@11.com','11'),('1@1.com','1'),('2@2.com','2'),('3@3.com','3');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-05 22:17:28
