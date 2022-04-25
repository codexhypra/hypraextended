DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `accounts` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `job2` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job2_grade` int(11) DEFAULT 0,
  `loadout` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `position` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `lastname` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL,
  `dateofbirth` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `sex` varchar(1) COLLATE utf8mb4_bin DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `callsign` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `phone` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `profilepicture` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `background` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `iban` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `wardrobe` longtext COLLATE utf8mb4_bin NOT NULL,
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `tattoos` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `skills` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `pet` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `last_house` int(11) DEFAULT 0,
  `house` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{"owns":false,"furniture":[],"houseId":0}',
  `bought_furniture` longtext COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `last_property` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `jail_time` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`name`, `identifier`, `license`, `group`, `is_dead`, `accounts`, `inventory`, `job`, `job_grade`, `job2`, `job2_grade`, `loadout`, `position`, `firstname`, `lastname`, `dateofbirth`, `sex`, `height`, `status`, `callsign`, `phone`, `profilepicture`, `background`, `iban`, `wardrobe`, `skin`, `tattoos`, `phone_number`, `skills`, `pet`, `last_house`, `house`, `bought_furniture`, `last_property`, `jail_time`) VALUES
	('HYPRA', 'steam:1100001406ac5a6', NULL, 'admin', 0, '{"money":13520,"black_money":12972,"forascoin":0,"bank":243800}', '{"bread":100,"clip":1824,"weed":200,"gym_membership":1,"spray":98,"weed_pooch":100,"phone":1,"radio":1,"cannabis":100}', 'police', 10, 'mechanic', 4, '{"WEAPON_PISTOL":{"ammo":10}}', '{"z":29.2,"y":-1033.3,"x":328.3,"heading":231.6}', 'Elh', 'Japo', '09/06/2002', 'm', 200, '[{"val":1000000,"percent":100.0,"name":"hunger"},{"val":1000000,"percent":100.0,"name":"thirst"},{"val":0,"percent":0.0,"name":"drunk"}]', NULL, NULL, NULL, NULL, NULL, '', '{"torso_2":25,"sun_1":0,"tshirt_1":15,"beard_1":0,"chest_3":0,"torso_1":444,"chain_2":0,"glasses_1":0,"shoes_1":0,"eyebrows_1":0,"makeup_4":0,"lipstick_1":0,"moles_2":0,"blush_1":0,"tshirt_2":0,"blemishes_1":0,"hair_2":5,"glasses_2":0,"blush_2":0,"chest_1":0,"chest_2":0,"decals_2":0,"bodyb_1":0,"blush_3":0,"beard_3":0,"eyebrows_4":0,"eye_color":0,"arms_2":0,"decals_1":0,"bags_2":0,"beard_4":0,"pants_1":32,"arms":1,"hair_color_1":42,"moles_1":0,"eyebrows_2":0,"ears_2":0,"watches_2":0,"pants_2":4,"lipstick_3":0,"shoes_2":0,"sun_2":0,"makeup_2":0,"complexion_2":0,"mask_1":0,"watches_1":-1,"bodyb_2":0,"hair_color_2":42,"beard_2":0,"age_2":0,"bags_1":0,"helmet_1":-1,"complexion_1":0,"mask_2":0,"bracelets_2":0,"bproof_1":0,"makeup_1":0,"eyebrows_3":0,"makeup_3":0,"lipstick_4":0,"lipstick_2":0,"ears_1":-1,"bracelets_1":-1,"age_1":0,"skin":0,"face":21,"bproof_2":0,"blemishes_2":0,"hair_1":13,"sex":0,"helmet_2":0,"chain_1":101}', NULL, '713-7153', '{"Disparo":{"RemoveAmount":-0.1,"Current":0,"Stat"', 'cochon', 0, '', '', NULL, 0);
/*HYPRA WAS HERE*/

