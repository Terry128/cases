use energo;


CREATE TABLE `auth` (
  `auth_id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(10) NOT NULL,
  `passw` varchar(100),
  `session_id` int,
  PRIMARY KEY (`auth_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `abon_info` (
  `abon_info_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `lic_schet` varchar(10) NOT NULL,
  `address` varchar(255) NOT NULL,
  `abon_fio` varchar(100) DEFAULT NULL,
  `schetchik_type` varchar(20) DEFAULT NULL,
  `schetchik_sn` varchar(20) DEFAULT NULL,
  `schetchik_phase` varchar(1) DEFAULT NULL,
  `schetchik_razr` smallint DEFAULT NULL,
  `tariff_type` varchar(45) DEFAULT NULL,
  `last_control_date` date DEFAULT NULL,
  `last_control_data` decimal(8,0) DEFAULT NULL,
  PRIMARY KEY (`abon_info_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `tariff` (
  `tariff_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `tariff_name` varchar(30) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `value` decimal(7,4) NOT NULL,
  PRIMARY KEY (`tariff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `schetchik` (
  `schetchik_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `schetchik_type` varchar(20) NOT NULL,
  `schetchik_sn` varchar(20) NOT NULL,
  `schetchik_phase` varchar(1) NOT NULL,
  `schetchik_razr` smallint NOT NULL,
  `inst_date` date NOT NULL,
  `inst_value` decimal(8,0) NOT NULL,
  `rem_date` date DEFAULT NULL,
  `rem_value` decimal(8,0) DEFAULT NULL,
  PRIMARY KEY (`schetchik_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `control` (
  `control_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `control_date` date NOT NULL,
  `control_value` decimal(8,0) NOT NULL,
  PRIMARY KEY (`control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



CREATE TABLE `calc` (
  `calc_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `calc_month` date NOT NULL,
  `start_value` decimal(8,0) NOT NULL,
  `end_value` decimal(8,0) NOT NULL,
  `w` decimal(8,0) NOT NULL,
  `calc_detail` varchar(45) NOT NULL,
  `paid_amount` decimal(8,2) NOT NULL,
  `paid_w` decimal(8,0) NOT NULL,
  PRIMARY KEY (`calc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `pays` (
  `pay_id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `pay_date` date NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `penalty` decimal(8,2) NOT NULL,
  PRIMARY KEY (`pay_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

