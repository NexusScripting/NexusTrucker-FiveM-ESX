CREATE TABLE IF NOT EXISTS `trucker_stats` (
  `identifier` VARCHAR(60) NOT NULL,
  `xp` INT(11) DEFAULT 0,
  `level` INT(11) DEFAULT 1,
  `total_money` INT(11) DEFAULT 0,
  `total_deliveries` INT(11) DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;