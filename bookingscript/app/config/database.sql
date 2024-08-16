DROP TABLE IF EXISTS `taxi_bookings`;
CREATE TABLE IF NOT EXISTS `taxi_bookings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) DEFAULT NULL,
  `locale_id` int(10) unsigned DEFAULT NULL,
  `client_id` int(10) unsigned DEFAULT NULL,
  `fleet_id` int(10) unsigned DEFAULT NULL,
  `price_id` int(10) unsigned DEFAULT NULL,
  `pickup_address` varchar(255) DEFAULT NULL,
  `return_address` varchar(255) DEFAULT NULL,
  `booking_date` datetime DEFAULT NULL,
  `passengers` int(5) DEFAULT NULL,
  `luggage` int(5) DEFAULT NULL,
  `distance` decimal(9,2) unsigned DEFAULT NULL,
  `sub_total` decimal(9,2) unsigned DEFAULT NULL,
  `tax` decimal(9,2) unsigned DEFAULT NULL,
  `total` decimal(9,2) unsigned DEFAULT NULL,
  `deposit` decimal(9,2) unsigned DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `status` enum('confirmed','cancelled','pending') DEFAULT 'pending',
  `txn_id` varchar(255) DEFAULT NULL,
  `processed_on` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `c_title` varchar(255) DEFAULT NULL,
  `c_fname` varchar(255) DEFAULT NULL,
  `c_lname` varchar(255) DEFAULT NULL,
  `c_phone` varchar(255) DEFAULT NULL,
  `c_email` varchar(255) DEFAULT NULL,
  `c_company` varchar(255) DEFAULT NULL,
  `c_notes` text,
  `c_address` varchar(255) DEFAULT NULL,
  `c_city` varchar(255) DEFAULT NULL,
  `c_state` varchar(255) DEFAULT NULL,
  `c_zip` varchar(255) DEFAULT NULL,
  `c_country` int(10) unsigned DEFAULT NULL,
  `c_airline_company` varchar(255) DEFAULT NULL,
  `c_departure_airline_company` varchar(255) DEFAULT NULL,
  `c_flight_number` varchar(255) DEFAULT NULL,
  `c_flight_time` varchar(255) DEFAULT NULL,
  `c_departure_flight_number` varchar(255) DEFAULT NULL,
  `c_departure_flight_time` time DEFAULT NULL,
  `c_terminal` varchar(255) DEFAULT NULL,
  `cc_type` blob,
  `cc_num` blob,
  `cc_exp_month` blob,
  `cc_exp_year` blob,
  `cc_code` blob,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  KEY `fleet_id` (`fleet_id`),
  KEY `client_id` (`client_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_bookings_extras`;
CREATE TABLE IF NOT EXISTS `taxi_bookings_extras` (
  `booking_id` int(10) unsigned NOT NULL DEFAULT '0',
  `extra_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`booking_id`,`extra_id`),
  KEY `fleet_id` (`booking_id`),
  KEY `extra_id` (`extra_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_bookings_payments`;
CREATE TABLE IF NOT EXISTS `taxi_bookings_payments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `booking_id` int(10) unsigned DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `payment_type` varchar(255) DEFAULT NULL,
  `amount` decimal(9,2) unsigned DEFAULT NULL,
  `status` enum('paid','notpaid') DEFAULT 'paid',
  PRIMARY KEY (`id`),
  KEY `booking_id` (`booking_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_clients`;
CREATE TABLE IF NOT EXISTS `taxi_clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(10) unsigned DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `country_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_fleets`;
CREATE TABLE IF NOT EXISTS `taxi_fleets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_fee` decimal(9,2) unsigned DEFAULT NULL,
  `fee_per_person` decimal(9,2) unsigned DEFAULT NULL,
  `passengers` int(5) unsigned DEFAULT NULL,
  `luggage` int(5) unsigned DEFAULT NULL,
  `source_path` varchar(255) DEFAULT NULL,
  `thumb_path` varchar(255) DEFAULT NULL,
  `image_name` varchar(255) DEFAULT NULL,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_extras`;
CREATE TABLE IF NOT EXISTS `taxi_extras` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `price` decimal(9,2) unsigned DEFAULT NULL,
  `per` enum('person','total') DEFAULT 'total',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_fleets_extras`;
CREATE TABLE IF NOT EXISTS `taxi_fleets_extras` (
  `fleet_id` int(10) unsigned NOT NULL DEFAULT '0',
  `extra_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`fleet_id`,`extra_id`),
  KEY `fleet_id` (`fleet_id`),
  KEY `extra_id` (`extra_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_prices`;
CREATE TABLE IF NOT EXISTS `taxi_prices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fleet_id` int(10) unsigned NOT NULL DEFAULT '0',
  `start` int(10) unsigned DEFAULT NULL,
  `end` int(10) unsigned DEFAULT NULL,
  `price` decimal(9,2) unsigned DEFAULT NULL,
  `in_range` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_locations`;
CREATE TABLE IF NOT EXISTS `taxi_locations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` enum('T','F') NOT NULL DEFAULT 'T',
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

DROP TABLE IF EXISTS `taxi_options`;
CREATE TABLE IF NOT EXISTS `taxi_options` (
  `foreign_id` int(10) unsigned NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL DEFAULT '',
  `tab_id` tinyint(3) unsigned DEFAULT NULL,
  `value` text,
  `label` text,
  `type` enum('string','text','int','float','enum','bool') NOT NULL DEFAULT 'string',
  `order` int(10) unsigned DEFAULT NULL,
  `is_visible` tinyint(1) unsigned DEFAULT '1',
  `style` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`foreign_id`,`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `taxi_notifications`;
CREATE TABLE IF NOT EXISTS `taxi_notifications` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient` enum('client','admin') DEFAULT NULL,
  `transport` enum('email','sms') DEFAULT NULL,
  `variant` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) unsigned DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `recipient` (`recipient`,`transport`,`variant`),
  KEY `is_active` (`is_active`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

INSERT IGNORE INTO `taxi_notifications` (`id`, `recipient`, `transport`, `variant`, `is_active`) VALUES
(1, 'client', 'email', 'confirmation', 1),
(2, 'client', 'email', 'payment', 1),
(3, 'client', 'email', 'cancel', 1),
(4, 'client', 'email', 'account', 1),
(5, 'client', 'email', 'forgot', 1),
(6, 'client', 'sms', 'confirmation', 1),
(7, 'admin', 'email', 'confirmation', 1),
(8, 'admin', 'email', 'payment', 1),
(9, 'admin', 'email', 'cancel', 1),
(10, 'admin', 'sms', 'confirmation', 1),
(11, 'admin', 'sms', 'payment', 1),
(12, 'admin', 'email', 'account', 1);

INSERT INTO `taxi_options` (`foreign_id`, `key`, `tab_id`, `value`, `label`, `type`, `order`, `is_visible`, `style`) VALUES
(1, 'o_latitude', 2, '51.509865', NULL, 'string', 15, 1, NULL),
(1, 'o_longitude', 2, '-0.118092', NULL, 'string', 16, 1, NULL),

(1, 'o_deposit_payment', 2, '10.00', NULL, 'int', 2, 1, NULL),
(1, 'o_tax_payment', 2, '10.00', NULL, 'int', 4, 1, NULL),
(1, 'o_hour_earlier', 2, '2', NULL, 'int', 5, 1, NULL),
(1, 'o_booking_status', 2, 'confirmed|pending|cancelled::pending', 'Confirmed|Pending|Cancelled', 'enum', 6, 1, NULL),
(1, 'o_payment_status', 2, 'confirmed|pending|cancelled::confirmed', 'Confirmed|Pending|Cancelled', 'enum', 7, 1, NULL),
(1, 'o_thankyou_page', 2, 'http://www.phpjabbers.com', NULL, 'string', 8, 1, NULL),
(1, 'o_cancel_page', 2, 'http://www.phpjabbers.com', NULL, 'string', 8, 1, NULL),
(1, 'o_payment_disable', 2, 'Yes|No::No', 'Yes|No', 'enum', 10, 1, NULL),

(1, 'o_bf_include_title', 4, '1|2|3::1', 'No|Yes|Yes (required)', 'enum', 1, 1, NULL),
(1, 'o_bf_include_fname', 4, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 2, 1, NULL),
(1, 'o_bf_include_lname', 4, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 3, 1, NULL),
(1, 'o_bf_include_phone', 4, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 4, 1, NULL),
(1, 'o_bf_include_email', 4, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 5, 1, NULL),
(1, 'o_bf_include_company', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 6, 1, NULL),
(1, 'o_bf_include_notes', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 7, 1, NULL),
(1, 'o_bf_include_address', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 8, 1, NULL),
(1, 'o_bf_include_city', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 10, 1, NULL),
(1, 'o_bf_include_state', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 11, 1, NULL),
(1, 'o_bf_include_zip', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 12, 1, NULL),
(1, 'o_bf_include_country', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 13, 1, NULL),
(1, 'o_bf_include_airline_company', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 14, 1, NULL),
(1, 'o_bf_include_flight_number', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 15, 1, NULL),
(1, 'o_bf_include_flight_time', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 16, 1, NULL),
(1, 'o_bf_include_terminal', 4, '1|2|3::2', 'No|Yes|Yes (required)', 'enum', 18, 1, NULL),
(1, 'o_bf_include_captcha', 4, '1|2|3::3', 'No|Yes|Yes (required)', 'enum', 19, 1, NULL),

(1, 'o_terms', 5, '', NULL, 'text', 1, 1, NULL),

(1, 'o_theme', 99, 'theme1|theme2|theme3|theme4|theme5|theme6|theme7|theme8|theme9|theme10::theme1', 'Theme 1|Theme 2|Theme 3|Theme 4|Theme 5|Theme 6|Theme 7|Theme 8|Theme 9|Theme 10', 'enum', NULL, 0, NULL),
(1, 'o_multi_lang', 99, '1|0::1', NULL, 'enum', NULL, 0, NULL),
(1, 'o_fields_index', 99, '76e46b610cc307af7953461769a1c183', NULL, 'string', NULL, 0, NULL);

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'addLocale', 'backend', 'Add language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add language', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'adminForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'adminLogin', 'backend', 'Admin Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Admin Login', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'backend', 'backend', 'Backend titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back-end titles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_cancelled', 'arrays', 'booking_statuses_ARRAY_cancelled', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelled', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_confirmed', 'arrays', 'booking_statuses_ARRAY_confirmed', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_statuses_ARRAY_pending', 'arrays', 'booking_statuses_ARRAY_pending', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAdd', 'backend', 'Button Add', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add +', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddClient', 'backend', 'Button / Add client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddEnquiry', 'backend', 'Button / Add enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddExtra', 'backend', 'Button / Add extra', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add extra', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddReason', 'backend', 'Button / Add reason', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add reason', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddTransfer', 'backend', 'Button / Add transfer', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddUser', 'backend', 'Button / Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddVehicle', 'backend', 'Button / Add vehicle', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnBack', 'backend', 'Button Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '« Back', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnBackup', 'backend', 'Button Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnCancel', 'backend', 'Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnContinue', 'backend', 'Button Continue', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Continue', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnDelete', 'backend', 'Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnEdit', 'backend', 'Button / Edit', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnGenerate', 'backend', 'Button / Generate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Generate', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnLogin', 'backend', 'Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnPreview', 'backend', 'Button / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnRemove', 'backend', 'Button / Remove', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Remove', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnReset', 'backend', 'Reset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reset', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnSave', 'backend', 'Save', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Save', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnSearch', 'backend', 'Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnSend', 'backend', 'Button Send', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnUpdate', 'backend', 'Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnUseThisTheme', 'backend', 'Button / Use this theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use this theme', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_cancel', 'arrays', 'buttons_ARRAY_cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_copy', 'arrays', 'buttons_ARRAY_copy', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_no', 'arrays', 'buttons_ARRAY_no', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_set', 'arrays', 'buttons_ARRAY_set', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'buttons_ARRAY_yes', 'arrays', 'buttons_ARRAY_yes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_1', 'arrays', 'cancel_err_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing parameters', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_2', 'arrays', 'cancel_err_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation with such ID does not exist.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_200', 'arrays', 'cancel_err_ARRAY_200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation has been cancelled successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_3', 'arrays', 'cancel_err_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Security hash did not match.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cancel_err_ARRAY_4', 'arrays', 'cancel_err_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your reservation was already cancelled.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_AmericanExpress', 'arrays', 'cc_types_ARRAY_AmericanExpress', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'American Express', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_Maestro', 'arrays', 'cc_types_ARRAY_Maestro', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Maestro', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_MasterCard', 'arrays', 'cc_types_ARRAY_MasterCard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'MasterCard', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'cc_types_ARRAY_Visa', 'arrays', 'cc_types_ARRAY_Visa', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Visa', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'client_email_ARRAY_account', 'arrays', 'client_email_arr_ARRAY_account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client account email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'client_email_ARRAY_cancel', 'arrays', 'client_email_arr_ARRAY_cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'client_email_ARRAY_confirmation', 'arrays', 'client_email_arr_ARRAY_confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry is received', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'client_email_ARRAY_forgot', 'arrays', 'client_email_arr_ARRAY_forgot', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password recovery email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'client_email_ARRAY_payment', 'arrays', 'client_email_arr_ARRAY_payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment confirmation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'created', 'backend', 'Created', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'DateTime', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_add_enquiry', 'backend', 'Label / Add Enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_enquiries_received_today', 'backend', 'Label / enquiries received today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'today''s enquiries ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_enquiry_received_today', 'backend', 'Label / enquiry received today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'enquiry received today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_latest_enquiries', 'backend', 'Label / Latest enquiries', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Latest enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_link_reservations_today', 'backend', 'Label / Reservations today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservations today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_no_enquiries', 'backend', 'Label / No enquiries found.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No enquiries found.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_open_frontend', 'backend', 'Label / Open front-end', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Open frontend', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_quick_links', 'backend', 'Label / Quick links', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Quick links', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_reservation', 'backend', 'Label / reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'reservation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_reservations_today', 'backend', 'Label / reservations today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'today''s reservations', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_reservation_today', 'backend', 'Label / reservation today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'reservation today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_title_reservations_today', 'backend', 'Label / Reservations today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservations today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_total_reservations', 'backend', 'Label / total reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'total reservations', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_view_enquiries', 'backend', 'Label / View Enquiries', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'View enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_0', 'arrays', 'days_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sunday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_1', 'arrays', 'days_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Monday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_2', 'arrays', 'days_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tuesday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_3', 'arrays', 'days_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wednesday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_4', 'arrays', 'days_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thursday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_5', 'arrays', 'days_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Friday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'days_ARRAY_6', 'arrays', 'days_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Saturday', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_0', 'arrays', 'day_names_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_1', 'arrays', 'day_names_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'M', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_2', 'arrays', 'day_names_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_3', 'arrays', 'day_names_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'W', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_4', 'arrays', 'day_names_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'T', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_5', 'arrays', 'day_names_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'F', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_names_ARRAY_6', 'arrays', 'day_names_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'S', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_0', 'arrays', 'day_short_names_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Su', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_1', 'arrays', 'day_short_names_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mo', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_2', 'arrays', 'day_short_names_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_3', 'arrays', 'day_short_names_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_4', 'arrays', 'day_short_names_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Th', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_5', 'arrays', 'day_short_names_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fr', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'day_short_names_ARRAY_6', 'arrays', 'day_short_names_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sa', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'delete_confirmation', 'backend', 'Label / delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to delete selected record(s)?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'delete_selected', 'backend', 'Label / Delete selected', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete selected', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'email', 'backend', 'E-Mail', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'emailForgotBody', 'backend', 'Email / Forgot Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dear {Name},Your password: {Password}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'emailForgotSubject', 'backend', 'Email / Forgot Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password reminder', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'email_taken', 'backend', 'Label / email taken', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address was already in use.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA10', 'arrays', 'error_bodies_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Given email address is not associated with any account.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA11', 'arrays', 'error_bodies_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'For further instructions please check your mailbox.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA12', 'arrays', 'error_bodies_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, please try again later.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AA13', 'arrays', 'error_bodies_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to your profile have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB01', 'arrays', 'error_bodies_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc at ligula non arcu dignissim pretium. Praesent in magna nulla, in porta leo.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB02', 'arrays', 'error_bodies_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All backup files have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB03', 'arrays', 'error_bodies_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No option was selected.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB04', 'arrays', 'error_bodies_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup not performed.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB09', 'arrays', 'error_bodies_ARRAY_AB09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation confirmation has been sent successfully to the client.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB10', 'arrays', 'error_bodies_ARRAY_AB10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the confirmation email could not be sent successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB11', 'arrays', 'error_bodies_ARRAY_AB11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS has been sent to client.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB12', 'arrays', 'error_bodies_ARRAY_AB12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the SMS could not be sent to client successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB13', 'arrays', 'error_bodies_ARRAY_AB13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancellation email has been sent successfully to the client.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AB14', 'arrays', 'error_bodies_ARRAY_AB14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the cancellation email could not be sent!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABB01', 'arrays', 'error_bodies_ARRAY_ABB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the enquiry have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABB03', 'arrays', 'error_bodies_ARRAY_ABB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry has been added to the list.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABB04', 'arrays', 'error_bodies_ARRAY_ABB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the enquiry could not bee added successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ABB08', 'arrays', 'error_bodies_ARRAY_ABB08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the enquiry you are looking is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC01', 'arrays', 'error_bodies_ARRAY_AC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this client have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC03', 'arrays', 'error_bodies_ARRAY_AC03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this client have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC04', 'arrays', 'error_bodies_ARRAY_AC04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, but the client has not been added.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AC08', 'arrays', 'error_bodies_ARRAY_AC08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client your looking for is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE01', 'arrays', 'error_bodies_ARRAY_AE01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the extra have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE03', 'arrays', 'error_bodies_ARRAY_AE03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New extra has been added into the list.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE04', 'arrays', 'error_bodies_ARRAY_AE04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that new extra could not bee added successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AE08', 'arrays', 'error_bodies_ARRAY_AE08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the extra you are looking for is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF01', 'arrays', 'error_bodies_ARRAY_AF01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the vehicle have been saved successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF03', 'arrays', 'error_bodies_ARRAY_AF03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'A new vehicle has been added to the list.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF04', 'arrays', 'error_bodies_ARRAY_AF04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the new vehicle has not been added successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF05', 'arrays', 'error_bodies_ARRAY_AF05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New vehicle could not be added because image size too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF06', 'arrays', 'error_bodies_ARRAY_AF06', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The vehicle could not be updated because image size too large and your server cannot upload it. Maximum allowed size is {SIZE}. Please, upload smaller image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF08', 'arrays', 'error_bodies_ARRAY_AF08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the vehicle you are looking for is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF09', 'arrays', 'error_bodies_ARRAY_AF09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New vehicle has been added, but uploaded image is too big. Please, upload smaller image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF10', 'arrays', 'error_bodies_ARRAY_AF10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Uploaded image is too big. Please, upload smaller image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AF11', 'arrays', 'error_bodies_ARRAY_AF11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The uploaded file actually is not a image file. Please upload another image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL01', 'arrays', 'error_bodies_ARRAY_AL01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes you made to the location have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL03', 'arrays', 'error_bodies_ARRAY_AL03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer has been added successfully. Please add transfer fees by visiting the Prices tab under the corresponding Transfer page.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL04', 'arrays', 'error_bodies_ARRAY_AL04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Entry wasn''t saved. Please try again!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL08', 'arrays', 'error_bodies_ARRAY_AL08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that location you are looking is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AL09', 'arrays', 'error_bodies_ARRAY_AL09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the prices have been saved successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_ALC01', 'arrays', 'error_bodies_ARRAY_ALC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to titles have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO01', 'arrays', 'error_bodies_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the options page have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO02', 'arrays', 'error_bodies_ARRAY_AO02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made have been saved successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO03', 'arrays', 'error_bodies_ARRAY_AO03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the reservation form settings have been saved successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO04', 'arrays', 'error_bodies_ARRAY_AO04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the notifications have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AO05', 'arrays', 'error_bodies_ARRAY_AO05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes to the Terms have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR01', 'arrays', 'error_bodies_ARRAY_AR01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All changes made to the reason have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR03', 'arrays', 'error_bodies_ARRAY_AR03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New reason has been added into the list.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR04', 'arrays', 'error_bodies_ARRAY_AR04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that new reason could not bee added successfully.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AR08', 'arrays', 'error_bodies_ARRAY_AR08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry that the reason you are looking for is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU01', 'arrays', 'error_bodies_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU03', 'arrays', 'error_bodies_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All the changes made to this user have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU04', 'arrays', 'error_bodies_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We are sorry, but the user has not been added.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_bodies_ARRAY_AU08', 'arrays', 'error_bodies_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User your looking for is missing.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA10', 'arrays', 'error_titles_ARRAY_AA10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account not found!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA11', 'arrays', 'error_titles_ARRAY_AA11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password send!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA12', 'arrays', 'error_titles_ARRAY_AA12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password not send!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AA13', 'arrays', 'error_titles_ARRAY_AA13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile updated!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB01', 'arrays', 'error_titles_ARRAY_AB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB02', 'arrays', 'error_titles_ARRAY_AB02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup complete!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB03', 'arrays', 'error_titles_ARRAY_AB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB04', 'arrays', 'error_titles_ARRAY_AB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup failed!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB09', 'arrays', 'error_titles_ARRAY_AB09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation sent', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB10', 'arrays', 'error_titles_ARRAY_AB10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation not sent', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB11', 'arrays', 'error_titles_ARRAY_AB11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS sent', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB12', 'arrays', 'error_titles_ARRAY_AB12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS not sent', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB13', 'arrays', 'error_titles_ARRAY_AB13', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancellation email sent!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AB14', 'arrays', 'error_titles_ARRAY_AB14', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancellation email not sent!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABB01', 'arrays', 'error_titles_ARRAY_ABB01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABB03', 'arrays', 'error_titles_ARRAY_ABB03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry added', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABB04', 'arrays', 'error_titles_ARRAY_ABB04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enqiry failed to add', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_ABB08', 'arrays', 'error_titles_ARRAY_ABB08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC01', 'arrays', 'error_titles_ARRAY_AC01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client updated!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC03', 'arrays', 'error_titles_ARRAY_AC03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client added!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC04', 'arrays', 'error_titles_ARRAY_AC04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client failed to add.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AC08', 'arrays', 'error_titles_ARRAY_AC08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client not found.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE01', 'arrays', 'error_titles_ARRAY_AE01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE03', 'arrays', 'error_titles_ARRAY_AE03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra added', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE04', 'arrays', 'error_titles_ARRAY_AE04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra failed to add', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AE08', 'arrays', 'error_titles_ARRAY_AE08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF01', 'arrays', 'error_titles_ARRAY_AF01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF03', 'arrays', 'error_titles_ARRAY_AF03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle added', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF04', 'arrays', 'error_titles_ARRAY_AF04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle failed to add', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF05', 'arrays', 'error_titles_ARRAY_AF05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Image size too large', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF06', 'arrays', 'error_titles_ARRAY_AF06', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Image size too large', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF08', 'arrays', 'error_titles_ARRAY_AF08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF09', 'arrays', 'error_titles_ARRAY_AF09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File size exceeded', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF10', 'arrays', 'error_titles_ARRAY_AF10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'File size exceeded', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AF11', 'arrays', 'error_titles_ARRAY_AF11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wrong file type', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL01', 'arrays', 'error_titles_ARRAY_AL01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Changes have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL03', 'arrays', 'error_titles_ARRAY_AL03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New transfer was added.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL04', 'arrays', 'error_titles_ARRAY_AL04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Error!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL08', 'arrays', 'error_titles_ARRAY_AL08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Location not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AL09', 'arrays', 'error_titles_ARRAY_AL09', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO01', 'arrays', 'error_titles_ARRAY_AO01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO02', 'arrays', 'error_titles_ARRAY_AO02', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry options have been changed.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO03', 'arrays', 'error_titles_ARRAY_AO03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reservation form settings updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO04', 'arrays', 'error_titles_ARRAY_AO04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AO05', 'arrays', 'error_titles_ARRAY_AO05', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Changes saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR01', 'arrays', 'error_titles_ARRAY_AR01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason updated', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR03', 'arrays', 'error_titles_ARRAY_AR03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason added', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR04', 'arrays', 'error_titles_ARRAY_AR04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason failed to add', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AR08', 'arrays', 'error_titles_ARRAY_AR08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU01', 'arrays', 'error_titles_ARRAY_AU01', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User updated!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU03', 'arrays', 'error_titles_ARRAY_AU03', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User added!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU04', 'arrays', 'error_titles_ARRAY_AU04', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User failed to add.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'error_titles_ARRAY_AU08', 'arrays', 'error_titles_ARRAY_AU08', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'User not found.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_active', 'arrays', 'filter_ARRAY_active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'filter_ARRAY_inactive', 'arrays', 'filter_ARRAY_inactive', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'forgot_err_ARRAY_100', 'arrays', 'login_err_ARRAY_100', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email does not exist in the system.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'forgot_err_ARRAY_101', 'arrays', 'forgot_err_ARRAY_101', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your account is disabled.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'forgot_err_ARRAY_102', 'arrays', 'forgot_err_ARRAY_102', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Missing parameters.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'forgot_err_ARRAY_200', 'arrays', 'forgot_err_ARRAY_200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The password was already sent to your mail box.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'frontend', 'backend', 'Front-end titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Front-end titles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_address', 'frontend', 'Label / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_agree', 'frontend', 'Label / Agreement', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'I have read and accept your', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_airline', 'frontend', 'Label / Airline', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Airline', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_airline_company', 'frontend', 'Label / Arrival airline company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrival airline company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_all_inclusive', 'frontend', 'Label / All inclusive for only', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All inclusive for only', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_already_logged_in', 'frontend', 'Label / You already logged in.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You already logged in.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_arrival_time', 'frontend', 'Label / Arrival time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrival time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_back', 'frontend', 'Label / Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_bags', 'frontend', 'Label / Bags', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bags', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_bank_account', 'frontend', 'Lable / Bank account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_booking_created', 'frontend', 'Label / Booking created', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry created', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_booking_details', 'frontend', 'Label / Booking Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_booking_id', 'frontend', 'Label / Booking ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_back', 'frontend', 'Button / Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_book_a_taxi', 'frontend', 'Button / Book a taxi', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Book a taxi', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_cancel_enquiry', 'frontend', 'Button / Cancel enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_close', 'frontend', 'Button / Close', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Close', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_confirm', 'frontend', 'Button / Confirm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirm', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_login', 'frontend', 'Button / Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Log in', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_preview', 'frontend', 'Button / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_reserve', 'frontend', 'Button / Reserve', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reserve', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_send', 'frontend', 'Button / Send', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_btn_start_over', 'frontend', 'Button / Star over', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Star over', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_captcha', 'frontend', 'Label / Captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_cc_code', 'frontend', 'Label / CC code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC code', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_cc_exp', 'frontend', 'Label / CC expiration date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC expiration date', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_cc_num', 'frontend', 'Label / CC Number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC Number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_cc_type', 'frontend', 'Label / CC Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC Type', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_change', 'frontend', 'Label / Change', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_checkout', 'frontend', 'Label / Checkout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_choose', 'frontend', 'Label / Choose', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_choose_airport', 'frontend', 'Lable / Choose Airport Transfer', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose Airport Transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_choose_extras', 'frontend', 'Label / Choose extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_choose_provider', 'frontend', 'Label / Choose provider & service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose provider & service', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_city', 'frontend', 'Label / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_company', 'frontend', 'Label / Company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_confirm', 'frontend', 'Label / Confirm', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirm', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_country', 'frontend', 'Label / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_cruise_ship', 'frontend', 'Label / Cruise ship', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cruise ship', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_date_time', 'frontend', 'Label / Date and time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date and time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_departure', 'frontend', 'Label / Departure', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Departure', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_departure_airline_company', 'frontend', 'Label / Departure airline company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Departure airline company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_departure_flight_number', 'frontend', 'Label / Departure flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Departure flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_deposit_required', 'frontend', 'Label / Deposit required', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit required', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_destination', 'frontend', 'Label / Destination', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Destination', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_destination_address', 'frontend', 'Label / Complete destination address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Complete destination address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_digits_validation', 'frontend', 'Lable / Please enter only digits.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter only digits.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_distance', 'frontend', 'Label / Distance', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Distance', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_dropoff_address', 'frontend', 'Label / Drop-off address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Drop-off address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_dropoff_location', 'frontend', 'Label / Drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_email', 'frontend', 'Label / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_email_does_not_exist', 'frontend', 'Label / Email does not exist.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email does not exist.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_email_validation', 'frontend', 'Lable / Email is invalid.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email is invalid.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_existing_client', 'frontend', 'Label / Existing client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Existing client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_exp_month', 'frontend', 'Label / Expiration month is required.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Expiration month is required.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_exp_year', 'frontend', 'Label / Expiration year is required.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Expiration year is required.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_extras', 'frontend', 'Label / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_extra_price', 'frontend', 'Label / Extra price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_flight_departure_time', 'frontend', 'Label / Flight departure time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight departure time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_flight_details', 'frontend', 'Label / Flight Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight Details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_flight_details_desc', 'frontend', 'Label / Flight details description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'If you choose airport transfer service, please enter your flight details below.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_flight_number', 'frontend', 'Label / Arrival flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrival flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_flight_time', 'frontend', 'Label / Flight arrival time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight arrival time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_fname', 'frontend', 'Label / First name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_forgot_password', 'frontend', 'Label / Forgot password?', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_from', 'frontend', 'Label / From', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select pick-up', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_hour_earlier_desc', 'frontend', 'Label / Date time for accepted enquireis', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry can be accepted with {HOURS} hour(s) earlier.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_hour_earlier_title', 'frontend', 'Label / Date time for accepted enquireis', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date time for accepted enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_included', 'frontend', 'Label / included', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'included', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_incorrect_captcha', 'frontend', 'Label / Captcha is not correct.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha is not correct.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_incorrect_password', 'frontend', 'Label / Password is not correct.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password is not correct.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_invalid_date', 'frontend', 'Label / Invalid date time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The return date time cannot be less than pick-up date time.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_invalid_email', 'frontend', 'Label / Invalid email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Invalid email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_km', 'frontend', 'Label / km', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'km', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_link_forgot_password', 'frontend', 'Link / Forgot password?', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_link_login', 'frontend', 'Button / Login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Login', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_lname', 'frontend', 'Label / Last name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_login_message', 'frontend', 'Label /If you are existing client, click here to log in.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'If you have an account, click {STAG}here{ETAG} to log in.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_logout_message', 'frontend', 'Label / Logout message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You already logged in, click {STAG}here{ETAG} to logout.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_0', 'arrays', 'front_messages_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry is being processed...', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_1', 'arrays', 'front_messages_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry is saved. Redirecting to PayPal...', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_2', 'arrays', 'front_messages_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your reservation is saved. Redirecting to Authorize.Net...', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_3', 'arrays', 'front_messages_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry is saved. Redirecting to Authorize.Net...', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_4', 'arrays', 'front_messages_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry has been sent successfully!', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_messages_ARRAY_5', 'arrays', 'front_messages_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your enquiry failed to save.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_miles', 'frontend', 'Label / miles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'miles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_minutes', 'frontend', 'Label / minutes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'minutes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_new_client', 'frontend', 'Label / New client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_notes', 'frontend', 'Label / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_no_fleet_found', 'frontend', 'Label / No fleet found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are no vehicles found.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_number_validation', 'frontend', 'Label / Please enter a valid number.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter a valid number.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_on', 'frontend', 'Label / On', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Returning on', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_one_way', 'frontend', 'Label / One way', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'One way', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_passenger', 'frontend', 'Label / Passenger', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passenger', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_passengers', 'frontend', 'Label / Passengers', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passengers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_password', 'frontend', 'Label / Password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_password_sent', 'frontend', 'Label / The password has been sent to your email address.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The password has been sent to your email address.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_payment_medthod', 'frontend', 'Label / Payment method', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment method', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_people', 'frontend', 'Label / People', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'People', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_personal_details', 'frontend', 'Label / Personal Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Personal Details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_per_person', 'frontend', 'Label / per person', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'per person', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_phone', 'frontend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_pickup_address', 'frontend', 'Label / Pick-up address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_pickup_dropoff_location', 'frontend', 'Label / Pick-up and drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up and drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_pieces_of_luggage', 'frontend', 'Label / Pieces of luggage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pieces of luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_piece_of_luggage', 'frontend', 'Label / Piece of luggage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Piece of luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_plan_your_ride', 'frontend', 'Label / Plan your ride', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose Airport Transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_preview', 'frontend', 'Label / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_price', 'frontend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_processed_on', 'frontend', 'Label / Processed on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Processed on', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_reason_for_hire', 'frontend', 'Label / Reason for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason for hire', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_required_field', 'frontend', 'Label / This field is required.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This field is required.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_return', 'frontend', 'Label / Return', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Return', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_return_on', 'frontend', 'Label / Return on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Returning on', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_ride', 'frontend', 'Label / Ride', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ride', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_round_trip', 'frontend', 'Label / Round trip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Round trip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_search', 'frontend', 'Label / Search', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Get a quote', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_search_again', 'frontend', 'Label / Search again', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Search again', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_select_vehicle_type', 'frontend', 'Label / Select Vehicle Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select Vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_service', 'frontend', 'Label / Service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_single', 'frontend', 'Label / Single', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Single', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_single_ride', 'frontend', 'Label / Single ride', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Single ride', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_start_fee', 'frontend', 'Label / Start fee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Start fee', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_state', 'frontend', 'Label / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_subtotal', 'frontend', 'Label / Subtotal', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subtotal', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_tax', 'frontend', 'Label / Tax', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_taxi_on', 'frontend', 'Lable / taxi on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'on {DATE} at {TIME} for {PASSENGERS} passenger(s) travelling with {LUGGAGES} piece(s) of luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_taxi_on_2', 'frontend', 'Lable / taxi on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'on {DATE} at {TIME} for {PASSENGERS} passenger(s)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_taxi_service_from', 'frontend', 'Label / Taxi service from', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Taxi service from', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_terminal', 'frontend', 'Label / Terminal / Gate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terminal / Gate', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_terms_conditions', 'frontend', 'Label / Terms and conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms and conditions.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_terms_title', 'frontend', 'Label / Terms and conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms and conditions', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_title', 'frontend', 'Label / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_to', 'frontend', 'Label / To', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select drop-off', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_total', 'frontend', 'Label / Total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_total_price', 'frontend', 'Label / total price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'total price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_to_lowercase', 'frontend', 'Lable / to', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'to', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_transfer_reservation', 'frontend', 'Label / Transfer Reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer Reservation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_txn_id', 'frontend', 'Label / Paypal Transaction ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Paypal Transaction ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_with', 'frontend', 'Label / With', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'With', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_with_desc', 'frontend', 'Label / width passengers', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '{PASSENGERS} Passenger(s); {LUGGAGE} Piece(s) of luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_with_desc_2', 'frontend', 'Label / width passengers', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '{PASSENGERS} Passenger(s)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_your_account_disabled', 'frontend', 'Label / Your account is disabled.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', ' Your account is disabled.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_your_enquiry', 'frontend', 'Label / Your Enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your Enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'front_zip', 'frontend', 'Label / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridActionTitle', 'backend', 'Grid / Action Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Action confirmation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridBtnCancel', 'backend', 'Grid / Button Cancel', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridBtnDelete', 'backend', 'Grid / Button Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridBtnOk', 'backend', 'Grid / Button OK', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'OK', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridChooseAction', 'backend', 'Grid / Choose Action', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose Action', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridConfirmationTitle', 'backend', 'Grid / Confirmation Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure you want to delete selected record?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridDeleteConfirmation', 'backend', 'Grid / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete confirmation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridEmptyResult', 'backend', 'Grid / Empty resultset', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No records found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridGotoPage', 'backend', 'Grid / Go to page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Go to page:', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridItemsPerPage', 'backend', 'Grid / Items per page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Items per page', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridNext', 'backend', 'Grid / Next', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next »', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridNextPage', 'backend', 'Grid / Next page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Next page', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridPrev', 'backend', 'Grid / Prev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '« Prev', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridPrevPage', 'backend', 'Grid / Prev page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prev page', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'gridTotalItems', 'backend', 'Grid / Total items', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total items:', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddBookingDesc', 'backend', 'Infobox / Add new reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add a new enquiry (booking) using the form below.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddBookingTitle', 'backend', 'Infobox / Add new reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddClientDesc', 'backend', 'Infobox / Add client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill in the form below and click "Save" to add a new client.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddClientTitle', 'backend', 'Infobox / Add client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddExtraDesc', 'backend', 'Infobx / Add extra', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill in the form below and click "save" to add new extra.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddExtraTitle', 'backend', 'Infobx / Add extra', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add extra', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddFleetDesc', 'backend', 'Infobox / Add new fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill the form to add a new vehicle to the system. Vehicles are important because they correspond with your services.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddFleetTitle', 'backend', 'Infobox / Add new fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddLocationDesc', 'backend', 'Infobox / Add new location desc', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Create new transfer by specifying a pick-up location and at least one drop-off below. ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddLocationTitle', 'backend', 'Infobox / Add new location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddReasonDesc', 'backend', 'Infbox / Add reason for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter the reason name and "save" to add new reason for hire.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddReasonTitle', 'backend', 'Infbox / Add reason for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add reason for hire', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddUserDesc', 'backend', 'Infobox / Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fill in the form below and "save" to add a new user.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoAddUserTitle', 'backend', 'Infobox / Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoBookingFormDesc', 'backend', 'Infobox / Reservation form options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the drop-downs to set value for each of the fields below. Select ''Yes'' or ''No'' if you want a field to be displayed or not, and ''Yes (Required)'', if you''d like that field to be mandatory.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoBookingFormTitle', 'backend', 'Infobox / Reservation form options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Checkout form', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoCancellationEmailDesc', 'backend', 'Infobox / Send cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'On the form below, you can make any change on the content to be sent to client for cancelling enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoCancellationEmailTitle', 'backend', 'Infobox / Cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoClientsDesc', 'backend', 'Infobox / List of clients', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is a list of all clients. You can edit a specific client by clicking on the pencil icon in the corresponding entry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoClientsTitle', 'backend', 'Infobox / List of clients', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List of clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoConfirmation2Desc', 'backend', 'Infobox / Notifications description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are three types of auto-responder messages you can send to both clients and admins. The first one will be triggered after a new enquiry is submitted via the software. The second one will be sent to confirm a successful payment and the third one - after a service has been canceled. You may enable or disable all auto-responders separately as well as personalize the message using the tokens below. <br/><br/><div class="float_left w200">{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Password}<br/>{Phone}<br/>{Notes}<br/>{Country}<br/>{City}<br/>{State}<br/>{Zip}<br/>{Address}<br/>{Company}</div><div class="float_left w250">{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Distance}<br/>{Passengers}<br/>{Luggage}<br/>{Extras}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}</div><div class="float_left w250">{Airline}<br/>{FlightNumber}<br/>{ArrivalTime}<br/>{Terminal}<br/>{PaymentMethod}<br/>{CCType}<br/>{CCNum}<br/>{CCExp}<br/>{CCSec}<br/>{CancelURL}</div>', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoConfirmationDesc', 'backend', 'Infobox / Notifications description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are three types of auto-responder messages you can send to both clients and admins. The first one will be triggered after a new enquiry is submitted via the software. The second one will be sent to confirm a successful payment and the third one - after a service has been canceled. You may enable or disable all auto-responders separately as well as personalize the message using the tokens below. <br/><br/><div class="float_left w200">{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Password}<br/>{Phone}<br/>{Notes}<br/>{Country}<br/>{City}<br/>{State}<br/>{Zip}<br/>{Address}<br/>{Company}</div><div class="float_left w250">{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Distance}<br/>{Passengers}<br/>{Luggage}<br/>{Extras}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}</div><div class="float_left w250">{Airline}<br/>{FlightNumber}<br/>{ArrivalTime}<br/>{Terminal}<br/>{PaymentMethod}<br/>{CCType}<br/>{CCNum}<br/>{CCExp}<br/>{CCSec}<br/>{CancelURL}</div>', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoExtrasDesc', 'backend', 'Infobox / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is a list of all extras. If you want to add a new one, click on the "+ Add extra" button.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoExtrasTitle', 'backend', 'Infobox / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoFleetsDesc', 'backend', 'Infobox / Fleets description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is a list of all vehicles you have added to the system. All active vehicles can be booked on the front-end. To edit vehicle details, click on the pencil icon in the corresponding row. To add a new one,  click on the  "+ Add vehicle" button.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoFleetsTitle', 'backend', 'Infobox / Fleets title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List of vehicles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoGeneralDesc', 'backend', 'Infobox / General Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The general report summarizes your data using criteria such as pick-up location and vehicles. The report shows you the total number of enquiries, passengers served, luggage carried, traveling distance, amount collected via the system, as well as create comparison between the one-way and the round-trip bookings during the selected period of time.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoGeneralTitle', 'backend', 'Infobox / General Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Generate report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingAddressBody', 'backend', 'Infobox / Listing Address Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingAddressTitle', 'backend', 'Infobox / Listing Address Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Location and address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingBookingsBody', 'backend', 'Infobox / Listing Bookings Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingBookingsTitle', 'backend', 'Infobox / Listing Bookings Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingContactBody', 'backend', 'Infobox / Listing Contact Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Contact Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingContactTitle', 'backend', 'Infobox / Listing Contact Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Contact Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingExtendBody', 'backend', 'Infobox / Extend exp.date Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extend exp.date Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingExtendTitle', 'backend', 'Infobox / Extend exp.date Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extend exp.date Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingPricesBody', 'backend', 'Infobox / Listing Prices Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Prices Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoListingPricesTitle', 'backend', 'Infobox / Listing Prices Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Listing Prices Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysBody', 'backend', 'Locale / Languages Array Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Array Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesArraysTitle', 'backend', 'Locale / Languages Array Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Arrays Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendBody', 'backend', 'Infobox / Locales Backend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Backend Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesBackendTitle', 'backend', 'Infobox / Locales Backend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Backend Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesBody', 'backend', 'Infobox / Locales Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendBody', 'backend', 'Infobox / Locales Frontend Body', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Frontend Body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesFrontendTitle', 'backend', 'Infobox / Locales Frontend Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Frontend Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocalesTitle', 'backend', 'Infobox / Locales Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocationsDesc', 'backend', 'Infobox / Locations description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is a list of all point-to-point transfers you have added to the system. All transfers must have a pick-up location (which you see below) and at least on drop-off. To edit the predefined transfer details, click the pencil icon corresponding to the row. To add new transfer, go to the above tab “Add new”.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoLocationsTitle', 'backend', 'Infobox / Locations title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List of transfers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPickupLocationDesc', 'backend', 'Infobox / Pickup Location Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'In this form, you can select a specific location to generate the report. You will find in the report all of enquiries that will be transferred within the date range for selected pick-up location.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPickupLocationTitle', 'backend', 'Infobox / Pickup Location Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up Location Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPreviewInstallDesc', 'backend', 'Infobox / Preview front end and install on your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are multiple color schemes available for the frontend layout. Click on each of the thumbnails below to preview it. Click on "Use this theme" to apply the theme. Then scroll down and grab the Install code and put it on your web page.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPreviewInstallTitle', 'backend', 'Infobox / Preview front end and install on your website', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview frontend and install on your site', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReasonsDesc', 'backend', 'Infbox / List of reasons for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Use the predefined reasons for hire or add your own. If you want to add a new reason, click on the "+ Add reason" button.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReasonsTitle', 'backend', 'Infbox / List of reasons for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List of reasons for hire', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoResendEmailDesc', 'backend', 'Infobox / Re-send confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'On the form below, you can make any change on the content to be sent to client for confirming the reservation.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoResendEmailTitle', 'backend', 'Infobox / Re-send confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Re-send confirmation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReservationDesc', 'backend', 'Infobox / Reservation options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Customize your vehicle transfer enquiry system by configuring the options below. You can enable/disable payments, specify a percentage of security deposit and taxes, and more.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReservationListDesc', 'backend', 'Infobox / Reservations list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This is a list of all customer enquiries made through the vehicle booking system. You can filter enquiries by status, reorder, search by multiple criteria, export, and print the list. To see a specific enquiry and client details, click the pencil icon in the corresponding row. To add a new enquiry manually, click on the "+ Add enquiry" button.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReservationListTitle', 'backend', 'Infobox / Reservations list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'List of enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoReservationTitle', 'backend', 'Infobox / Reservation options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry options', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoSendSmsDesc', 'backend', 'Label / Send SMS notification', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'On the form below, you can make any change on the content message that will be sent to client for confirming the reservation.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoSendSmsTitle', 'backend', 'Label / Send SMS notification', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS notification', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoTermsDesc', 'backend', 'Infobox / Terms and Conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy and paste your booking terms in the field below. You can translate them and add the respective text for each language you have enabled on your website. Clients will not be able to complete their reservation if they haven’t read and accepted your terms and conditions.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoTermsTitle', 'backend', 'Infobox / Terms and Conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add your booking terms', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingDesc', 'backend', 'Infobox / Update booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'See enqiry and client details below.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateBookingTitle', 'backend', 'Infobox / Update booking', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateClientDesc', 'backend', 'Infobox / Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any changes on the form below and click "Save" button to edit client information.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateClientTitle', 'backend', 'Infobox / Update', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateExtraDesc', 'backend', 'Infobx / Update extra', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any changes on the form below. When ready, click "Save" to update the Extra information.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateExtraTitle', 'backend', 'Infobx / Update extra', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update extra', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateFleetDesc', 'backend', 'Infobox / Update fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can edit all vehicle details for all languages you have activated on your website. Just make sure you have switched the language using the flag buttons before you update the information.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateFleetTitle', 'backend', 'Infobox / Update fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateLocationDesc', 'backend', 'Infobox / Update location description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make changes to the fields below for all languages you have added to the system. Make sure you have switched the languages (if any) using the flag system, before you edit the information. Please note that, all transfers must have a pick-up location with exact address but can have multiple drop-offs.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateLocationTitle', 'backend', 'Infobox / Update location title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdatePriceDesc', 'backend', 'Label / Prices', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set transfer fees using the table below.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdatePriceTitle', 'backend', 'Label / Prices', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateReasonDesc', 'backend', 'Infbox / Update reason', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please change the reason name and "save" to update it.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateReasonTitle', 'backend', 'Infbox / Update reason', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update reason', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateUserDesc', 'backend', 'Infobox / Update user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can make any changes on the form below and click "Save" button to update user information.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUpdateUserTitle', 'backend', 'Infobox / Update user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update user', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUsersDesc', 'backend', 'Infobox / Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Below is a list of all users. You can add new users, edit user details and change user status. ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoUsersTitle', 'backend', 'Infobox / Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoVehicleDesc', 'backend', 'Infobox / Vehicle Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can select which vehicle to view report. In this report, you will find all of enquiries that will be transferred within the date range for selected vehicle.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoVehicleTitle', 'backend', 'Infobox / Vehicle Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Limo Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddClient', 'backend', 'Label / Add client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddFleet', 'backend', 'Label / Add fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAdditionalInfo', 'backend', 'Label / Additional info', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Additional info', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddLocation', 'backend', 'Label / Add location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddReservation', 'backend', 'Label / Add reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add new', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddress', 'backend', 'Label / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAddUser', 'backend', 'Add user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add user', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblAll', 'backend', 'Label / All', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'All', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblArrivalFlightNumber', 'backend', 'Label / Arrival flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrival flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBackupDatabase', 'backend', 'Backup / Database', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup database', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBackupFiles', 'backend', 'Backup / Files', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup files', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingAddress', 'backend', 'Label / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingAirlineCompany', 'backend', 'Label / Airline company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Airline company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingCity', 'backend', 'Label / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingCompany', 'backend', 'Label / Company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingCountry', 'backend', 'Label / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingCruiseShip', 'backend', 'Label / Cruise ship', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cruise ship', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingDestAddress', 'backend', 'Label / Complete destination address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Complete destination address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingDetails', 'backend', 'Label / Reservation details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingEmail', 'backend', 'Label / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingFlightNumber', 'backend', 'Label / Flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingFlightTime', 'backend', 'Label / Flight Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight arriving from / departure to', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingFname', 'backend', 'Label / First name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingID', 'backend', 'Label / Booking ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingLname', 'backend', 'Label / Last name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingNotes', 'backend', 'Label / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingPhone', 'backend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingsEmailExist', 'backend', 'Label / Email address already exist', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address already exist', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingState', 'backend', 'Label / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingTerminal', 'backend', 'Label / Terminal / Gate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terminal / Gate', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingTitle', 'backend', 'Label / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingZip', 'backend', 'Label / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCancelledReservations', 'backend', 'Label / Cancelled Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelled Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCCCode', 'backend', 'Label / CC code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC code', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCCExp', 'backend', 'Label / CC expiration date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC expiration date', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCCNum', 'backend', 'Label / CC number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCCType', 'backend', 'Label / CC Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'CC Type', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblChoose', 'backend', 'Choose', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblChooseTheme', 'backend', 'Label / Choose theme', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Choose color theme', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblClient', 'backend', 'Label / Client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblClientDetails', 'backend', 'Label / Client details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblConfirmedReservations', 'backend', 'Label / Confirmed Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmed Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCopyDropoff', 'backend', 'Label / Copy Drop-off Locations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Copy Drop-off Locations', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCopyLocation', 'backend', 'Label / copy location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'or copy from another location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCount', 'backend', 'Label / Count', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Count', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCreatedOn', 'backend', 'Label / Created on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Created on', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCurrentlyInUse', 'backend', 'Label / Currently in use', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currently in use', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblCustomer', 'backend', 'Label / Customer', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Customer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDashLastLogin', 'backend', 'Label / Last login', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last login', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDashViewAll', 'backend', 'Label / view all', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'view all', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDate', 'backend', 'Label / Date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDateAndTime', 'backend', 'Label / Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date & Time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDateFrom', 'backend', 'Label / Date from', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date from', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDateTime', 'backend', 'Label / Date & time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date & time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDateTo', 'backend', 'Label / Date to', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date to', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDays', 'backend', 'Days', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'days', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDelete', 'backend', 'Delete', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDeleteConfirmation', 'backend', 'Label / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Are you sure that you want to delete the image?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDeleteDropoff', 'backend', 'Label / Delete drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDeleteDropoffConfirm', 'backend', 'Label / Delete confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theer are enquiries made for this drop-off. Are you sure that you want to delete it?', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDeleteImage', 'backend', 'Label / Delete image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete image', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDepartureAirlineCompany', 'backend', 'Label / Departure airline company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Departure airline company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDepartureFlightNumber', 'backend', 'Label / Departure flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Departure flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDeposit', 'backend', 'Label / Deposit', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDescription', 'backend', 'Label / Description', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Description', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDestination', 'backend', 'Label / Destination', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Destination', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDestinationTrips', 'backend', 'Label / Destinations Trips', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Destinations Trips (confirmed reservations only)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDetails', 'backend', 'Label / Details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDistance', 'backend', 'Label / Distance', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Distance', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDropoff', 'backend', 'Label / Drop-off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Drop-off', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDropoffAddress', 'backend', 'Label / Drop-off address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Drop-off address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDropoffLocation', 'backend', 'Label / Drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDuplicatedUniqueID', 'backend', 'Label / Duplicated Unique ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Unique ID was already used.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDuration', 'backend', 'Label / Duration', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Duration', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblEditDropoff', 'backend', 'Label / Edit drop-off', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit drop-off', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblEnquiries', 'backend', 'Label / Enquiries', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblEnquiryDetails', 'backend', 'Label / Enquiry details', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry details', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblError', 'backend', 'Error', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Error', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblExistingClient', 'backend', 'Label / Existing client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Existing client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblExport', 'backend', 'Export', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblExtraName', 'backend', 'Label / Extra name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extra name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblExtras', 'backend', 'Label / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFeePerPerson', 'backend', 'Label / Fee per person', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fee per person', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFleet', 'backend', 'Label / Fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFlightArrivalTime', 'backend', 'Label / Flight arrival time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight arrival time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFlightDepartureTime', 'backend', 'Label / Flight departure time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight departure time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFlightTime', 'backend', 'Label / Flight time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblForgot', 'backend', 'Forgot password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Forgot password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFrom', 'backend', 'Label / From', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'From', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFromInKm', 'backend', 'Label / From (km)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'From (km)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFromPickupLocation', 'backend', 'Label / From pick-up location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'From pick-up location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblFromTo', 'backend', 'Label / From / To', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'From / To', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblGeneralReport', 'backend', 'Label / General Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reports', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblGeneralReservationsReport', 'backend', 'Label / General Reservations Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'General Enquiries Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblHere', 'backend', 'Label / here', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'here', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblID', 'backend', 'Label / ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblImage', 'backend', 'Label / Image', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Image', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblIncluded', 'backend', 'Label / included', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'included', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblIncludedExtras', 'backend', 'Label / Included extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras included in price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallCode', 'backend', 'Lable / Install code', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install code', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallConfig', 'backend', 'Label / Installation configuration', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Installation configuration', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallConfigHide', 'backend', 'Button / Hide language selector ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Hide language selector ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallConfigLocale', 'backend', 'Label / Select language', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select language', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_body', 'backend', 'Label / Installation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To embed the software into a web page, please follow the steps below. Set the language configuration first, then copy the integration code and paste into your HTML page, whenever you want the software to appear.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblInstallJs1_title', 'backend', 'Label / Installation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Installation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblIp', 'backend', 'IP address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblIpAddress', 'backend', 'Label / IP address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'IP address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblIsActive', 'backend', 'Is Active', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is confirmed', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblKm', 'backend', 'Label / Km', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Km', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLastEnquiry', 'backend', 'Label / Last enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLatestReservations', 'backend', 'Label / Latest Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'latest enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLbsRoundTrip', 'backend', 'Label / Round trip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Round trip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLegendEmails', 'backend', 'Label / Emails', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Emails', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLegendSMS', 'backend', 'Label / SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLocation', 'backend', 'Label / Location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLuggage', 'backend', 'Label / Luggage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblLuggageCaried', 'backend', 'Label / Luggage Carried', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Luggage Carried', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblManageFleet', 'backend', 'Label / Manage fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Manage vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblMaximum', 'backend', 'Label / maximum', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'maximum', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblMaxNumber', 'backend', 'Label / Maximum number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number cannot be greater than maximum value.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblMinutes', 'backend', 'Label / Minutes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Minutes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblName', 'backend', 'Name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNewClient', 'backend', 'Label / New client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNewReservationsToday', 'backend', 'Label / new reservations today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'new enquiries today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNewReservationToday', 'backend', 'Label / new reservation today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'new reservation today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNo', 'backend', 'No', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNoServicesAvailable', 'backend', 'Label / No services available', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No services are available for that number of people/luggage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNotifications', 'backend', 'Label / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOneWay', 'backend', 'Label / One way', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'One way', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOneWayReservations', 'backend', 'Label / One-way Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'One-way', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOneWayRoundTrip', 'backend', 'Label / One-way vs Round-trip Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'One-way vs Round-trip (confirmed reservations only)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOption', 'backend', 'Option', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Option', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOptionAdministrator', 'backend', 'Label / Administrator', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administrators', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOptionClient', 'backend', 'Label / Client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOptionHours', 'backend', 'Label / hour(s)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'hour(s)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblOptionList', 'backend', 'Option list', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Option list', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPassenger', 'backend', 'Label / Passenger', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passenger', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPassengers', 'backend', 'Label / Passengers', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passengers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPassengersPer', 'backend', 'Label / Passengers per reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passengers per reservation (confirmed reservations only)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPassengersServed', 'backend', 'Label / Passengers Served', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Passengers Served', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPayment', 'backend', 'Label / Payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPaymentMethod', 'backend', 'Label / Payment method', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment method', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPerPerson', 'backend', 'Label / per person', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'per person', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPhone', 'backend', 'Label / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickup', 'backend', 'Label / Pickup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pickup', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupAddress', 'backend', 'Label / Pick-up address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupDate', 'backend', 'Label / Pickup date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pickup date', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupDropoff', 'backend', 'Label / Pickup / Dropoff', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pickup / Dropoff', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupDropofLocation', 'backend', 'Label / Pick-up and drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up and drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupLocation', 'backend', 'Label / Pickup location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPickupLocationReport', 'backend', 'Label / Pickup Location Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pick-up Location Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPositiveNumber', 'backend', 'Label / Enter a positive number.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter a positive number.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPrice', 'backend', 'Label / Price', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPricePerKm', 'backend', 'Label / Price per km', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price per km', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPricePerPerson', 'backend', 'Label / Price per person', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Price per person', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPrices', 'backend', 'Label / Prices', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPriceStatusEnd', 'backend', 'Label / Prices have been saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPriceStatusFail', 'backend', 'Label / Prices could not be saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices could not be saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPriceStatusStart', 'backend', 'Label / Please wait while prices are saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please wait while prices are saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPrint', 'backend', 'Label / Print', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPrintReservation', 'backend', 'Label / Print Enquiry', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print Enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReasonForHire', 'backend', 'Label / Reason for hire', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason for hire', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReasonName', 'backend', 'Label / Reason name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reason name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReminderMessage', 'backend', 'Label / Message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReminderSubject', 'backend', 'Label / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReminderTo', 'backend', 'Label / To', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReportPickupLocation', 'backend', 'Label / Report by Pickup Location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Report by Pick-up Location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReportVehicle', 'backend', 'Label / Vehicle Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblResendConfirmation', 'backend', 'Label / Re-send confirmation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Re-send confirmation', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReservationPrint', 'backend', 'Label / Print Reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print Enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReservationPrintList', 'backend', 'Label / Reservations Print List', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries Print List', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReservations', 'backend', 'Label / Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReservationsNotFound', 'backend', 'Label / Reservations not found', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Not found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReservationsToday', 'backend', 'Label / Reservations Today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'enquiries today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReturn', 'backend', 'Label / Return', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Return', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReturnDateTime', 'backend', 'Label / Return date & time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Return date & time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReturnOn', 'backend', 'Label / Return on', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Returning on', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblReturnTrip', 'backend', 'Label / Return trip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Return trip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblRole', 'backend', 'Role', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Role', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblRoundTrip', 'backend', 'Label / roundtrip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'roundtrip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblRoundTripReservations', 'backend', 'Label / Round-trip Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Round-trip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSendCancellationEmail', 'backend', 'Label / Send cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSendSMSNotification', 'backend', 'Label / Send SMS notification', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS notification', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblService', 'backend', 'Label / Service', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Service', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblServices', 'backend', 'Label / Services', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Services', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSetPrices', 'backend', 'Label / Set prices', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Set prices', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSingle', 'backend', 'Label / Single', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Single', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSmsMessage', 'backend', 'Label / SMS message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS message', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStartFee', 'backend', 'Label / Start fee', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Start fee', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStatus', 'backend', 'Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStatusEnd', 'backend', 'Label / Locations have been saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Locations have been saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStatusFail', 'backend', 'Label / Locations could not be saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Locations could not be saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStatusStart', 'backend', 'Label / Please wait while locations are saved.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please wait while locations are saved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblStatusTitle', 'backend', 'Label / Status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSubTotal', 'backend', 'Label / Sub-total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subtotal', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTax', 'backend', 'Label / Tax', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblThumb', 'backend', 'Label / Thumb', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thumb', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTo', 'backend', 'Label / To', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblToCollect', 'backend', 'Label / To collect', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To collect', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTodayTransfers', 'backend', 'Label / Today Transfers', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today Transfers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblToDropoffLocation', 'backend', 'Label / To drop-off location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To drop-off location', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblToGreaterThanFrom', 'backend', 'Label / To must be greater than From', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To must be greater than From', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblToInKm', 'backend', 'Label / To (km)', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'To (km)', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTotal', 'backend', 'Label / Total', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTotalAmount', 'backend', 'Label / Total Amount', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total Amount', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTotalEnquiries', 'backend', 'Label / Total enquiries', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTotalReservations', 'backend', 'Label / Total Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransfer', 'frontend', 'Label / Transfer', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransferDate', 'backend', 'Label / Transfer date', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer date', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransferDateTime', 'backend', 'Label / Transfer Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer Date & Time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransferDestinations', 'backend', 'Label / Transfer Destinations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer Destinations', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransfersToday', 'backend', 'Label / Transfers Today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'today''s transfers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblTransferToday', 'backend', 'Label / Transfer Today', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfer Today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblType', 'backend', 'Type', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Type', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUniqueID', 'backend', 'Label / Unique ID', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Unique ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUpdateClient', 'backend', 'Label / Update client', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUpdateFleet', 'backend', 'Label / Update fleet', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUpdateLocation', 'backend', 'Label / Update location', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit transfer', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUpdateReservation', 'backend', 'Label / Update reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUpdateUser', 'backend', 'Update user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update user', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblUserCreated', 'backend', 'User / Registration Date & Time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Registration date/time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblValue', 'backend', 'Value', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Value', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblVehicle', 'backend', 'Label / Vehicle', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblVehicleReport', 'backend', 'Label / Vehicle Report', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle Report', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblVehicleUsed', 'backend', 'Label / Vehicle Used', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicle Used', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblVia', 'backend', 'Label / via', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'via', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblYes', 'backend', 'Yes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lnkBack', 'backend', 'Link Back', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Back', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'localeArrays', 'backend', 'Locale / Arrays titles', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrays titles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'locales', 'backend', 'Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'locale_flag', 'backend', 'Locale / Flag', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flag', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'locale_is_default', 'backend', 'Locale / Is default', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Is default', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'locale_order', 'backend', 'Locale / Order', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Order', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'locale_title', 'backend', 'Locale / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_1', 'arrays', 'login_err_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Wrong username or password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_2', 'arrays', 'login_err_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Access denied', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'login_err_ARRAY_3', 'arrays', 'login_err_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Account is disabled', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuBackup', 'backend', 'Menu Backup', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Backup', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuClients', 'backend', 'Menu / Clients', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuDashboard', 'backend', 'Menu Dashboard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuExtras', 'backend', 'Menu / Extras', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuFleets', 'backend', 'Menu / Fleets', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuGeneral', 'backend', 'Menu / General', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'General', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuInstall', 'backend', 'Menu / Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuInstallPreview', 'backend', 'Menu / Preview & Install', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview & Install', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuLang', 'backend', 'Menu Multi lang', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Multi Lang', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuLocales', 'backend', 'Menu Languages', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Languages', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuLocations', 'backend', 'Menu / Locations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Transfers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuLogout', 'backend', 'Menu Logout', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Logout', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuNews', 'backend', 'Menu / News', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'News', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuNotifications', 'backend', 'Menu / Notifications', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuOptions', 'backend', 'Menu Options', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Options', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuPlugins', 'backend', 'Menu Plugins', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Plugins', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuPreview', 'backend', 'Menu / Preview', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuProfile', 'backend', 'Menu Profile', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Profile', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuReports', 'backend', 'Menu / Reports', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reports', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuReservation', 'backend', 'Menu / Reservation', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuReservationForm', 'backend', 'Menu / Checkout form', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Checkout form', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuReservations', 'backend', 'Menu / Reservations', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuTerms', 'backend', 'Menu / Terms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuUsers', 'backend', 'Menu Users', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Users', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_1', 'arrays', 'months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'January', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_10', 'arrays', 'months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'October', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_11', 'arrays', 'months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'November', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_12', 'arrays', 'months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'December', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_2', 'arrays', 'months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'February', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_3', 'arrays', 'months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'March', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_4', 'arrays', 'months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'April', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_5', 'arrays', 'months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_6', 'arrays', 'months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'June', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_7', 'arrays', 'months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'July', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_8', 'arrays', 'months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'August', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'months_ARRAY_9', 'arrays', 'months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'September', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'multilangTooltip', 'backend', 'MultiLang / Tooltip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select a language by clicking on the corresponding flag and update existing translation.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_1', 'arrays', 'option_themes_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 1', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_10', 'arrays', 'option_themes_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 10', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_2', 'arrays', 'option_themes_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 2', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_3', 'arrays', 'option_themes_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 3', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_4', 'arrays', 'option_themes_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 4', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_5', 'arrays', 'option_themes_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 5', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_6', 'arrays', 'option_themes_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 6', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_7', 'arrays', 'option_themes_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 7', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_8', 'arrays', 'option_themes_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 8', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'option_themes_ARRAY_9', 'arrays', 'option_themes_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Theme 9', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_cancel_text', 'backend', 'Options / Send cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want to receive email notifications every time a client cancels his booking.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_client_account_message_text', 'backend', 'Options / Account tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Password}<br/>{Phone}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_client_account_text', 'backend', 'Options / New client account email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select "Yes" if you want the system to send automatic emails to administrator after new client accounts created.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_confirmation_text', 'backend', 'Options / Send confirmation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want the system to send you email every time a new enquiry is submitted. ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_email_payment_text', 'backend', 'Options / Send payment email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want to receive email notifications every time a new payment has been made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_confirmation_message', 'backend', 'Options / New Reservation SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notification upon new enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_confirmation_message_text', 'backend', 'Options / New Reservation SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<u>Available Tokens:</u><br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}<br/>', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_payment_message', 'backend', 'Options / Payment confirmation SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notification upon new payment.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_admin_sms_payment_message_text', 'backend', 'Options / Payment confirmation SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<u>Available Tokens:</u><br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}<br/>', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_allow_authorize', 'backend', 'Options / Allow payments with Authorize.net ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow payments with Authorize.Net ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_allow_bank', 'backend', 'Options / Allow bank account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Provide Bank account details for wire transfers', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_allow_cash', 'backend', 'Options / Allow payment with cash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow cash payments', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_allow_creditcard', 'backend', 'Options / Allow credit card', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Collect Credit Card details for offline processing ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_allow_paypal', 'backend', 'Options / Allow payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Allow payments with PayPal ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_md5_hash', 'backend', 'Options / Authorize.net MD5 hash ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.Net MD5 hash ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_merchant_id', 'backend', 'Options / Authorize.net merchant ID  ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.Net merchant ID', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_timezone', 'backend', 'Options / Authorize.net time zone ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.Net time zone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_authorize_transkey', 'backend', 'Options / Authorize.net transaction key ', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Authorize.Net transaction key ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bank_account', 'backend', 'Options / Bank account', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_address', 'backend', 'Options / Address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_airline_company', 'backend', 'Options / Airline company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Airline', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_captcha', 'backend', 'Options / Captcha', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Captcha', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_city', 'backend', 'Options / City', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'City', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_company', 'backend', 'Options / Company', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Company', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_country', 'backend', 'Options / Country', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Country', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_cruise_ship', 'backend', 'Options / Cruise ship', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cruise ship', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_destination_address', 'backend', 'Options / Complete destination address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Complete destination address', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_email', 'backend', 'Options / Email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_flight_number', 'backend', 'Options / Flight number', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Flight number', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_flight_time', 'backend', 'Options / Flight time', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Arrival time', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_fname', 'backend', 'Options / First name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_lname', 'backend', 'Options / Last name', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last name', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_notes', 'backend', 'Options / Notes', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_phone', 'backend', 'Options / Phone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Phone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_state', 'backend', 'Options / State', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'State', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_termial', 'backend', 'Label / Terminal / Gate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terminal / Gate', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_terminal', 'backend', 'Options / Terminal / Gate', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terminal / Gate', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_title', 'backend', 'Options / Title', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Title', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_bf_include_zip', 'backend', 'Options / Zip', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Zip', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_booking_status', 'backend', 'Options / Booking status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry status if not paid ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_currency', 'backend', 'Options / Currency', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Currency', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_date_format', 'backend', 'Options / Date format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Date format', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_deposit_payment', 'backend', 'Options / Deposit payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Deposit payment', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel', 'backend', 'Options / Send cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_message', 'backend', 'Options / Cancel confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_message_text', 'backend', 'Options / Cancel confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<u>Available Tokens:</u><br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Phone}<br/>{Notes}<br/>{Country}<br/>{City}<br/>{State}<br/>{Zip}<br/>{Address}<br/>{Company}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}<br/>{PaymentMethod}<br/>{CCType}<br/>{CCNum}<br/>{CCExp}<br/>{CCSec}<br/>{CancelURL}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_subject', 'backend', 'Options / Cancel confirmation subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_cancel_text', 'backend', 'Options / Send cancellation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want the system to send automatic email to the client after a service has been canceled. ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_client_account', 'backend', 'Options / New client account email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client account email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_client_account_message', 'backend', 'Options / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_client_account_message_text', 'backend', 'Options / Account tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Password}<br/>{Phone}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_client_account_subject', 'backend', 'Options / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_client_account_text', 'backend', 'Options / New client account email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select "Yes" if you want the system to send automatic emails to clients after client accounts are created', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation', 'backend', 'Options / New reservation received email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry is received', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_message', 'backend', 'Options / Reservation confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_message_text', 'backend', 'Options / Reservation confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<u>Available Tokens:</u><br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Phone}<br/>{Notes}<br/>{Country}<br/>{City}<br/>{State}<br/>{Zip}<br/>{Address}<br/>{Company}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}<br/>{PaymentMethod}<br/>{CCType}<br/>{CCNum}<br/>{CCExp}<br/>{CCSec}<br/>{CancelURL}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_subject', 'backend', 'Options / Reservation confirmation subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_confirmation_text', 'backend', 'Options / New reservation received email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want an auto-responder to be sent to clients after submiting new enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_forgot_message', 'backend', 'Options / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password recovery email message', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_forgot_message_text', 'backend', 'Options / Account tokens', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available Tokens:<br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Password}<br/>{Phone}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_forgot_subject', 'backend', 'Options / Subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password recovery email subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment', 'backend', 'Options / Send payment confirmation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment confirmation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_message', 'backend', 'Options / Payment confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message body', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_message_text', 'backend', 'Options / Payment confirmation message', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', '<u>Available Tokens:</u><br/><br/>{Title}<br/>{FirstName}<br/>{LastName}<br/>{Email}<br/>{Phone}<br/>{Notes}<br/>{Country}<br/>{City}<br/>{State}<br/>{Zip}<br/>{Address}<br/>{Company}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}<br/>{UniqueID}<br/>{SubTotal}<br/>{Tax}<br/>{Total}<br/>{Deposit}<br/>{PaymentMethod}<br/>{CCType}<br/>{CCNum}<br/>{CCExp}<br/>{CCSec}<br/>{CancelURL}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_subject', 'backend', 'Options / Payment confirmation subject', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_email_payment_text', 'backend', 'Options / Send payment confirmation email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want a confirmation email to be sent to clients after successful payment is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_google_api_key', 'backend', 'Label / Google API key', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Google API key', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_hour_earlier', 'backend', 'Label / Accept enquiries X hours earlier', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Accept enquiries X hours earlier', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_latitude', 'backend', 'Options / Default latitude', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default latitude', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_longitude', 'backend', 'Options / Default longitude', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Default longitude', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_mileage', 'backend', 'Options / Mileage', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mileage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_payment_disable', 'backend', 'Options / Payment disable', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select ''Yes'' if you want to disable payments.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_payment_status', 'backend', 'Options / Payment status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry status if paid', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_paypal_address', 'backend', 'Options / Paypal address', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'PayPal business email address ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_send_email', 'backend', 'opt_o_send_email', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation_message', 'backend', 'Options / Reservation reminder SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMS notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_sms_confirmation_message_text', 'backend', 'Options / Reservation reminder SMS', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can also send personalized SMS notifications via the each enquiry page. Available Tokens:<br/><br/>{FirstName}<br/>{LastName}<br/>{DateTime}<br/>{From}<br/>{To}<br/>{Vehicle}<br/>{Passengers}', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_host', 'backend', 'opt_o_smtp_host', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Host', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_pass', 'backend', 'opt_o_smtp_pass', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_port', 'backend', 'opt_o_smtp_port', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Port', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_smtp_user', 'backend', 'opt_o_smtp_user', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SMTP Username', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_tax_payment', 'backend', 'Options / Tax payment', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tax payment', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_terms', 'backend', 'Options / Terms and Conditions', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms and conditions', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_thankyou_page', 'backend', 'Options / Thank you page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL for the web page where your clients will be redirected after PayPal or Authorize.Net payment ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_timezone', 'backend', 'Options / Timezone', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Timezone', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_time_format', 'backend', 'Options / Time format', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Time format', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_vehicle_per_page', 'backend', 'Options / Vehicles per page', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Number of vehicles shown per page on the front-end.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_week_start', 'backend', 'Options / First day of the week', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'First day of the week', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pass', 'backend', 'Password', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_bank', 'arrays', 'payment_methods_ARRAY_bank', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bank account', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_cash', 'arrays', 'payment_methods_ARRAY_cash', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cash', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_creditcard', 'arrays', 'payment_methods_ARRAY_creditcard', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Credit card', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_dr', 'arrays', 'personal_titles_ARRAY_dr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dr.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_miss', 'arrays', 'personal_titles_ARRAY_miss', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Miss', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mr', 'arrays', 'personal_titles_ARRAY_mr', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mr.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_mrs', 'arrays', 'personal_titles_ARRAY_mrs', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mrs.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_ms', 'arrays', 'personal_titles_ARRAY_ms', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Ms.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_other', 'arrays', 'personal_titles_ARRAY_other', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Other', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_prof', 'arrays', 'personal_titles_ARRAY_prof', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prof.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'personal_titles_ARRAY_rev', 'arrays', 'personal_titles_ARRAY_rev', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Rev.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pj_digits_validation', 'backend', 'Label / Please enter only digits', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter only digits', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pj_email_taken', 'backend', 'Users / Email already taken', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email address is already taken.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pj_number_validation', 'backend', 'Label / Please enter a valid number.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Please enter a valid number.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'plugin_backup_size', 'backend', 'Plugin / Size', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Size', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'plugin_backup_sizeXXXXXX', 'backend', 'Plugin / Size', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'SizeXXXX', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'plugin_country_revert_status', 'backend', 'Plugin / Revert status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'revert_status', 'backend', 'Revert status', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_0', 'arrays', 'short_days_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Su', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_1', 'arrays', 'short_days_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mo', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_2', 'arrays', 'short_days_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Tu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_3', 'arrays', 'short_days_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'We', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_4', 'arrays', 'short_days_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Th', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_5', 'arrays', 'short_days_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Fr', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_days_ARRAY_6', 'arrays', 'short_days_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sa', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_1', 'arrays', 'short_months_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jan', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_10', 'arrays', 'short_months_ARRAY_10', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Oct', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_11', 'arrays', 'short_months_ARRAY_11', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Nov', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_12', 'arrays', 'short_months_ARRAY_12', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dec', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_2', 'arrays', 'short_months_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Feb', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_3', 'arrays', 'short_months_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Mar', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_4', 'arrays', 'short_months_ARRAY_4', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Apr', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_5', 'arrays', 'short_months_ARRAY_5', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'May', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_6', 'arrays', 'short_months_ARRAY_6', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jun', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_7', 'arrays', 'short_months_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Jul', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_8', 'arrays', 'short_months_ARRAY_8', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Aug', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'short_months_ARRAY_9', 'arrays', 'short_months_ARRAY_9', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Sep', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_1', 'arrays', 'status_ARRAY_1', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You are not loged in.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_123', 'arrays', 'status_ARRAY_123', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your hosting account does not allow uploading such a large image.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_2', 'arrays', 'status_ARRAY_2', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Access denied. You have not requisite rights to.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_3', 'arrays', 'status_ARRAY_3', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Empty resultset.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_7', 'arrays', 'status_ARRAY_7', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'The operation is not allowed in demo mode.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_996', 'arrays', 'status_ARRAY_996', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No property for the enquiry found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_997', 'arrays', 'status_ARRAY_997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No enquiry  found', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_998', 'arrays', 'status_ARRAY_998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No permisions to edit the enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_999', 'arrays', 'status_ARRAY_999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No permisions to edit the property', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9997', 'arrays', 'status_ARRAY_9997', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'E-Mail address already exist', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9998', 'arrays', 'status_ARRAY_9998', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your registration was successfull. Your account needs to be approved.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'status_ARRAY_9999', 'arrays', 'status_ARRAY_9999', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Your registration was successfull.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'tabReasons', 'backend', 'Tab / Reasons for hide', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Reasons for hire', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-10800', 'arrays', 'timezones_ARRAY_-10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-03:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-14400', 'arrays', 'timezones_ARRAY_-14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-04:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-18000', 'arrays', 'timezones_ARRAY_-18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-05:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-21600', 'arrays', 'timezones_ARRAY_-21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-06:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-25200', 'arrays', 'timezones_ARRAY_-25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-07:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-28800', 'arrays', 'timezones_ARRAY_-28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-08:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-32400', 'arrays', 'timezones_ARRAY_-32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-09:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-3600', 'arrays', 'timezones_ARRAY_-3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-01:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-36000', 'arrays', 'timezones_ARRAY_-36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-10:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-39600', 'arrays', 'timezones_ARRAY_-39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-11:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-43200', 'arrays', 'timezones_ARRAY_-43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-12:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_-7200', 'arrays', 'timezones_ARRAY_-7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT-02:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_0', 'arrays', 'timezones_ARRAY_0', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_10800', 'arrays', 'timezones_ARRAY_10800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+03:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_14400', 'arrays', 'timezones_ARRAY_14400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+04:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_18000', 'arrays', 'timezones_ARRAY_18000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+05:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_21600', 'arrays', 'timezones_ARRAY_21600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+06:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_25200', 'arrays', 'timezones_ARRAY_25200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+07:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_28800', 'arrays', 'timezones_ARRAY_28800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+08:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_32400', 'arrays', 'timezones_ARRAY_32400', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+09:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_3600', 'arrays', 'timezones_ARRAY_3600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+01:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_36000', 'arrays', 'timezones_ARRAY_36000', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+10:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_39600', 'arrays', 'timezones_ARRAY_39600', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+11:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_43200', 'arrays', 'timezones_ARRAY_43200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+12:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_46800', 'arrays', 'timezones_ARRAY_46800', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+13:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'timezones_ARRAY_7200', 'arrays', 'timezones_ARRAY_7200', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'GMT+02:00', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'tr_field_required', 'backend', 'Label / This field is required.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This field is required.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'url', 'backend', 'URL', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'URL', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'user', 'backend', 'Username', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Username', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_F', 'arrays', 'u_statarr_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Inactive', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'u_statarr_ARRAY_T', 'arrays', 'u_statarr_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Active', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_F', 'arrays', '_yesno_ARRAY_F', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, '_yesno_ARRAY_T', 'arrays', '_yesno_ARRAY_T', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Yes', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_name', 'backend', 'Label / Script Name', 'script', '2022-01-19 07:29:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Taxi Booking Script', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookings', 'backend', 'Label / Bookings', 'script', '2022-01-21 08:06:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Bookings', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblClientTotalBookings', 'backend', 'Label / Total bookings', 'script', '2022-01-25 09:23:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Total bookings', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblClientLastBooking', 'backend', 'Label / Last booking', 'script', '2022-01-25 09:24:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Last booking', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblChangeImage', 'backend', 'Label / Change image', 'script', '2022-01-26 09:21:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change image', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblSelectImage', 'backend', 'Label / Select image', 'script', '2022-01-26 09:21:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Select image', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblNoExtrasFound', 'backend', 'Label / No extras found.', 'script', '2022-01-26 09:31:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'No extras found. Add an extra', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'btnAddPrice', 'backend', 'Button / Add Price', 'script', '2022-01-27 01:36:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add Price', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoInstallTitle', 'backend', 'Infobox / Install', 'script', '2022-01-27 03:41:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Integration Code', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoInstallDesc', 'backend', 'Infobox / Install', 'script', '2022-01-27 03:41:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Follow the instructions below to install the script on your website.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPreviewTitle', 'backend', 'Infobox / Preview', 'script', '2022-01-27 03:47:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview front end', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'infoPreviewDesc', 'backend', 'Infobox / Preview', 'script', '2022-01-27 03:47:43');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'There are multiple color schemes available for the front end. Click on each of the thumbnails below to preview it. Click on "Use this theme" button for the theme you want to use.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_change_labels', 'backend', 'Label / Change Labels', 'script', '2022-01-27 03:48:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Change Labels', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_preview_your_website', 'backend', 'Label / Open in new window', 'script', '2022-01-27 03:49:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Open in new window', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_install_your_website', 'backend', 'Label / Install your website', 'script', '2022-01-27 03:50:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install your website', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_menu_settings', 'backend', 'Label / Settings', 'script', '2022-01-27 10:52:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Settings', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_menu_payments', 'backend', 'Label / Payments', 'script', '2022-01-27 10:53:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, '_booking_statuses_ARRAY_confirmed', 'arrays', '_booking_statuses_ARRAY_confirmed', 'script', '2022-02-08 10:34:18');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Confirmed', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, '_booking_statuses_ARRAY_pending', 'arrays', '_booking_statuses_ARRAY_pending', 'script', '2022-02-08 10:34:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Pending', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, '_booking_statuses_ARRAY_cancelled', 'arrays', '_booking_statuses_ARRAY_cancelled', 'script', '2022-02-08 10:34:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancelled', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblThankYouPage', 'backend', 'Label / Thank you page', 'script', '2022-02-08 10:40:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Thank you page', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblThankYouPageText', 'backend', 'Label / Thank you page', 'script', '2022-02-08 10:40:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter the URL your customers will be redirected to after online payment.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_page', 'backend', 'Options / Cancel page', 'script', '2022-02-08 10:41:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Cancel page', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'opt_o_cancel_page_text', 'backend', 'Options / Cancel page', 'script', '2022-02-08 10:41:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enter the URL your customers will be redirected to if cancel their reservation.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDisablePayments', 'backend', 'Label / Disable payments', 'script', '2022-02-08 10:43:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Disable payments', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblDisablePaymentsText', 'backend', 'Label / Disable payments', 'script', '2022-02-08 10:43:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'You can disable online payments and only accept bookings.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_infobox_notifications_title', 'backend', 'Infobox / Notifications', 'script', '2022-02-14 09:34:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_infobox_notifications_desc', 'backend', 'Infobox / Notifications', 'script', '2022-02-14 09:34:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Email notifications will be sent to people who make a booking after the booking form is completed or/and payment is made. If you leave subject field blank no email will be sent.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_main_title', 'backend', 'notifications_main_title', 'script', '2022-02-14 09:35:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_main_subtitle', 'backend', 'notifications_main_subtitle', 'script', '2022-02-14 09:35:49');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Automated messages are sent both to client and administrator(s) on specific events. Select message type to edit it - enable/disable or just change message text. For SMS notifications you need to enable SMS service. ', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_recipient', 'backend', 'notifications_recipient', 'script', '2022-02-14 09:36:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Recipient', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_client', 'arrays', 'recipients_ARRAY_client', 'script', '2022-02-14 09:36:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'recipients_ARRAY_admin', 'arrays', 'recipients_ARRAY_admin', 'script', '2022-02-14 09:37:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Administrator', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_tokens_note', 'backend', 'notifications_tokens_note', 'script', '2022-02-14 09:37:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Personalize the message by including any of the available tokens and it will be replaced with corresponding data.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_tokens', 'backend', 'notifications_tokens', 'script', '2022-02-14 09:37:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Available tokens', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_client', 'backend', 'notifications_msg_to_client', 'script', '2022-02-14 09:55:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_default', 'backend', 'notifications_msg_to_default', 'script', '2022-02-14 09:55:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_msg_to_admin', 'backend', 'notifications_msg_to_admin', 'script', '2022-02-14 09:55:50');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messages sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_status', 'backend', 'notifications_status', 'script', '2022-02-14 09:56:23');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_send', 'backend', 'notifications_send', 'script', '2022-02-14 09:57:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_do_not_send', 'backend', 'notifications_do_not_send', 'script', '2022-02-14 09:57:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Do not send', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_cancel', 'arrays', 'notifications_ARRAY_admin_email_cancel', 'script', '2022-02-14 10:32:55');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_confirmation', 'arrays', 'notifications_ARRAY_admin_email_confirmation', 'script', '2022-02-14 10:33:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry received email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_payment', 'arrays', 'notifications_ARRAY_admin_email_payment', 'script', '2022-02-14 10:34:15');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_email_account', 'arrays', 'notifications_ARRAY_admin_email_account', 'script', '2022-02-14 10:36:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client account email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_ARRAY_admin_sms_confirmation', 'script', '2022-02-14 10:37:21');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry received SMS', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_admin_sms_payment', 'arrays', 'notifications_ARRAY_admin_sms_payment', 'script', '2022-02-14 10:37:37');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment confirmation SMS', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_account', 'arrays', 'notifications_ARRAY_client_email_account', 'script', '2022-02-14 10:38:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client account email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_cancel', 'arrays', 'notifications_ARRAY_client_email_cancel', 'script', '2022-02-14 10:38:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send cancellation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_confirmation', 'arrays', 'notifications_ARRAY_client_email_confirmation', 'script', '2022-02-14 10:38:54');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry received email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_forgot', 'arrays', 'notifications_ARRAY_client_email_forgot', 'script', '2022-02-14 10:39:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send forgot password email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_email_payment', 'arrays', 'notifications_ARRAY_client_email_payment', 'script', '2022-02-14 10:39:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send payment confirmation email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_ARRAY_client_sms_confirmation', 'arrays', 'notifications_ARRAY_client_sms_confirmation', 'script', '2022-02-14 10:39:56');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New enquiry received SMS', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_cancel', 'arrays', 'notifications_titles_ARRAY_admin_email_cancel', 'script', '2022-02-14 10:41:34');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation email sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_confirmation', 'arrays', 'notifications_titles_ARRAY_admin_email_confirmation', 'script', '2022-02-14 10:42:05');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New Enquiry Received email sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_payment', 'arrays', 'notifications_titles_ARRAY_admin_email_payment', 'script', '2022-02-14 10:42:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Payment Confirmation email sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_titles_ARRAY_admin_sms_confirmation', 'script', '2022-02-14 10:43:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Confirmation SMS sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_sms_payment', 'arrays', 'notifications_titles_ARRAY_admin_sms_payment', 'script', '2022-02-14 10:43:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation SMS sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_admin_email_account', 'arrays', 'notifications_titles_ARRAY_admin_email_account', 'script', '2022-02-14 10:45:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send New Client Account email sent to Admin', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_cancel', 'arrays', 'notifications_subtitles_ARRAY_admin_email_cancel', 'script', '2022-02-14 10:46:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a client cancels an enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_confirmation', 'arrays', 'notifications_subtitles_ARRAY_admin_email_confirmation', 'script', '2022-02-14 10:47:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a new enquiry is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_payment', 'arrays', 'notifications_subtitles_ARRAY_admin_email_payment', 'script', '2022-02-14 10:47:47');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a payment for a new enquiry is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_confirmation', 'arrays', 'notifications_subtitles_ARRAY_admin_sms_confirmation', 'script', '2022-02-14 10:48:22');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to administrator when a new enquiry is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_sms_payment', 'arrays', 'notifications_subtitles_ARRAY_admin_sms_payment', 'script', '2022-02-14 10:49:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to administrator when a payment is made for a new enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_admin_email_account', 'arrays', 'notifications_subtitles_ARRAY_admin_email_account', 'script', '2022-02-14 10:49:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the administrator when a new client account created.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_cancel', 'arrays', 'notifications_titles_ARRAY_client_email_cancel', 'script', '2022-02-14 10:51:01');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Cancellation email sent to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_cancel', 'arrays', 'notifications_subtitles_ARRAY_client_email_cancel', 'script', '2022-02-14 10:51:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a client cancels an enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_confirmation', 'arrays', 'notifications_titles_ARRAY_client_email_confirmation', 'script', '2022-02-14 10:52:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Confirmation email sent to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_confirmation', 'arrays', 'notifications_subtitles_ARRAY_client_email_confirmation', 'script', '2022-02-14 10:52:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to client when a new enquiry is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_payment', 'arrays', 'notifications_titles_ARRAY_client_email_payment', 'script', '2022-02-14 10:53:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payment Confirmation email sent to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_payment', 'arrays', 'notifications_subtitles_ARRAY_client_email_payment', 'script', '2022-02-14 10:53:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when a payment is made for a new enquiry.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_forgot', 'arrays', 'notifications_titles_ARRAY_client_email_forgot', 'script', '2022-02-14 10:54:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send forgot password email to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_forgot', 'arrays', 'notifications_subtitles_ARRAY_client_email_forgot', 'script', '2022-02-14 10:55:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to client when he requests for password recovery.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_email_account', 'arrays', 'notifications_titles_ARRAY_client_email_account', 'script', '2022-02-14 10:56:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'New client account email sent to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_email_account', 'arrays', 'notifications_subtitles_ARRAY_client_email_account', 'script', '2022-02-14 10:56:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This message is sent to the client when new account is created.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_titles_ARRAY_client_sms_confirmation', 'arrays', 'notifications_titles_ARRAY_client_sms_confirmation', 'script', '2022-02-14 10:57:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiry Confirmation SMS sent to Client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subtitles_ARRAY_client_sms_confirmation', 'arrays', 'notifications_subtitles_ARRAY_client_sms_confirmation', 'script', '2022-02-14 10:58:07');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'This SMS is sent to client when a new enquiry is made.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_is_active', 'backend', 'notifications_is_active', 'script', '2022-02-14 10:58:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send this message', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_subject', 'backend', 'notifications_subject', 'script', '2022-02-14 10:59:28');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'notifications_message', 'backend', 'notifications_message', 'script', '2022-02-14 10:59:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Message', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'menuEnquiries', 'backend', 'Menu / Enquiries', 'script', '2022-03-23 07:29:36');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_online_payment_gateway', 'backend', 'Label / Online payment gateway', 'script', '2022-03-24 04:21:44');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Online payment gateway', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'script_offline_payment', 'backend', 'Label / Offline payment', 'script', '2022-03-24 04:22:13');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Offline payment', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblBookingPassword', 'backend', 'Label / Password', 'script', '2022-03-24 09:17:02');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Password', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'dash_today', 'backend', 'Dash / Today', 'script', '2022-03-31 10:09:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Today', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdmin_pjActionIndex', 'backend', 'pjAdmin_pjActionIndex', 'script', '2022-03-31 10:20:48');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Dashboard', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients', 'backend', 'pjAdminClients', 'script', '2022-03-31 10:21:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Clients Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionIndex', 'backend', 'pjAdminClients_pjActionIndex', 'script', '2022-03-31 10:21:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Clients List', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionCreate', 'backend', 'pjAdminClients_pjActionCreate', 'script', '2022-03-31 10:22:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionUpdate', 'backend', 'pjAdminClients_pjActionUpdate', 'script', '2022-03-31 10:22:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionDeleteClient', 'backend', 'pjAdminClients_pjActionDeleteClient', 'script', '2022-03-31 10:22:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single client', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionDeleteClientBulk', 'backend', 'pjAdminClients_pjActionDeleteClientBulk', 'script', '2022-03-31 10:23:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multile clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionStatusClient', 'backend', 'pjAdminClients_pjActionStatusClient', 'script', '2022-03-31 10:23:24');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Revert clients status', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminClients_pjActionExportClient', 'backend', 'pjAdminClients_pjActionExportClient', 'script', '2022-03-31 10:23:39');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export clients', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets', 'backend', 'pjAdminFleets', 'script', '2022-03-31 10:21:33');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicles Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets_pjActionIndex', 'backend', 'pjAdminFleets_pjActionIndex', 'script', '2022-03-31 10:21:45');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Vehicles List', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets_pjActionCreate', 'backend', 'pjAdminFleets_pjActionCreate', 'script', '2022-03-31 10:22:11');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets_pjActionUpdate', 'backend', 'pjAdminFleets_pjActionUpdate', 'script', '2022-03-31 10:22:30');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Update vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets_pjActionDeleteFleet', 'backend', 'pjAdminFleets_pjActionDeleteFleet', 'script', '2022-03-31 10:22:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single vehicle', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminFleets_pjActionDeleteFleetBulk', 'backend', 'pjAdminFleets_pjActionDeleteFleetBulk', 'script', '2022-03-31 10:23:00');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multile vehicles', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras', 'backend', 'pjAdminExtras', 'script', '2022-03-31 10:23:57');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionIndex', 'backend', 'pjAdminExtras_pjActionIndex', 'script', '2022-03-31 10:24:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Extras List', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionCreateForm', 'backend', 'pjAdminExtras_pjActionCreateForm', 'script', '2022-03-31 10:24:25');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionUpdateForm', 'backend', 'pjAdminExtras_pjActionUpdateForm', 'script', '2022-03-31 10:24:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionDeleteExtra', 'backend', 'pjAdminExtras_pjActionDeleteExtra', 'script', '2022-03-31 10:24:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single extra', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminExtras_pjActionDeleteExtraBulk', 'backend', 'pjAdminExtras_pjActionDeleteExtraBulk', 'script', '2022-03-31 10:25:08');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple extras', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions', 'backend', 'pjAdminOptions', 'script', '2022-03-31 11:16:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Settings menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBooking', 'backend', 'pjAdminOptions_pjActionBooking', 'script', '2022-03-31 11:16:46');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjPayments_pjActionIndex', 'backend', 'pjPayments_pjActionIndex', 'script', '2022-03-31 11:16:59');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Payments', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionBookingForm', 'backend', 'pjAdminOptions_pjActionBookingForm', 'script', '2022-03-31 11:17:12');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Booking form', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionNotifications', 'backend', 'pjAdminOptions_pjActionNotifications', 'script', '2022-03-31 11:17:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Notifications', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionTerm', 'backend', 'pjAdminOptions_pjActionTerm', 'script', '2022-03-31 11:17:41');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Terms', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings', 'backend', 'pjAdminBookings', 'script', '2022-03-31 11:17:58');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionIndex', 'backend', 'pjAdminBookings_pjActionIndex', 'script', '2022-03-31 11:18:17');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Enquiries List', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionCreate', 'backend', 'pjAdminBookings_pjActionCreate', 'script', '2022-03-31 11:18:35');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Add Enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionUpdate', 'backend', 'pjAdminBookings_pjActionUpdate', 'script', '2022-03-31 11:18:52');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Edit Enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBooking', 'backend', 'pjAdminBookings_pjActionDeleteBooking', 'script', '2022-03-31 11:19:06');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete single enquiry', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionDeleteBookingBulk', 'backend', 'pjAdminBookings_pjActionDeleteBookingBulk', 'script', '2022-03-31 11:19:27');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Delete multiple enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionExportBooking', 'backend', 'pjAdminBookings_pjActionExportBooking', 'script', '2022-03-31 11:20:04');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Export Enquiries', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminBookings_pjActionPrint', 'backend', 'pjAdminBookings_pjActionPrint', 'script', '2022-03-31 11:20:16');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Print', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionPreview', 'backend', 'pjAdminOptions_pjActionPreview', 'script', '2022-03-31 11:20:31');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Preview Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'pjAdminOptions_pjActionInstall', 'backend', 'pjAdminOptions_pjActionInstall', 'script', '2022-03-31 11:20:42');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Install Menu', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'lblPricesDuplicated', 'backend', 'Label / Prices are duplicated.', 'script', NULL);
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Prices are duplicated.', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_cancellation_title', 'backend', 'booking_cancellation_title', 'script', '2022-07-19 04:50:29');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send Cancellation Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_subject', 'backend', 'booking_subject', 'script', '2022-07-19 05:01:53');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Subject', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_message', 'backend', 'booking_message', 'script', '2022-07-19 05:02:10');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Messsage', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_confirmation_title', 'backend', 'booking_confirmation_title', 'script', '2022-07-19 08:11:40');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Re-send Confirmation Email', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'booking_sms_notification_title', 'backend', 'booking_sms_notification_title', 'script', '2022-07-19 08:19:38');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'Send SMS Notification', 'script');

INSERT INTO `taxi_plugin_base_fields` VALUES (NULL, 'payment_methods_ARRAY_paypal', 'arrays', 'payment_methods_ARRAY_paypal', 'script', '2022-07-25 03:51:26');
SET @id := (SELECT LAST_INSERT_ID());
INSERT INTO `taxi_plugin_base_multi_lang` VALUES (NULL, @id, 'pjBaseField', '::LOCALE::', 'title', 'PayPal', 'script');

INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjPayment', '1', 'cash', 'Cash', 'data');

INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'confirm_subject_client', 'Your enquiry has been received.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'confirm_tokens_client', '<p>Your enquiry has been received. Details are below:<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'payment_subject_client', 'Payment has been received.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'payment_tokens_client', '<p>Payment has been received.<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'cancel_subject_client', 'Service has been canceled.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'cancel_tokens_client', '<p>You''ve just cancelled the service.<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'account_subject_client', 'Client account', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'account_tokens_client', '<p>You have just made an enquiry and a new account is also created for you. Here is the details information:<br /><br />First name: {FirstName}<br />Last name: {LastName}<br />Email: {Email}<br />Password: {Password}<br />Phone: {Phone}</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'forgot_subject_client', 'Password recovery', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'forgot_tokens_client', '<p>Hi {FirstName},<br /><br />Password: {Password}<br /><br />Thanks!</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'confirm_subject_admin', 'New enquiry has been received.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'confirm_tokens_admin', '<p>New enquiry has been received:<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'payment_subject_admin', 'New payment has been made.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'payment_tokens_admin', '<p>New payment has been made:<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'cancel_subject_admin', 'Service has been canceled.', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'cancel_tokens_admin', '<p>The following service has been canceled:<br /><br />Personal details:<br />Title: {Title}<br />First Name: {FirstName}<br />Last Name: {LastName}<br />E-Mail: {Email}<br />Phone: {Phone}<br />Notes: {Notes}<br />Country: {Country}<br />City: {City}<br />State: {State}<br />Zip: {Zip}<br />Address: {Address}<br />Company: {Company}<br /><br />Reservation details:<br />Date time: {DateTime}<br />From: {From}<br />To: {To}<br />Vehicle: {Vehicle}<br />Passengers: {Passengers}<br />Unique ID: {UniqueID}<br />Total: {Total}<br /><br />If you want to cancel your reservation follow next link: {CancelURL}<br /><br />Thank you, we will contact you ASAP.</p>', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'account_subject_admin', 'Client account created', 'script');
INSERT IGNORE INTO `taxi_plugin_base_multi_lang` VALUES(NULL, '1', 'pjOption', '1', 'account_tokens_admin', '<p>A new client account has been created:<br /><br />First name: {FirstName}<br />Last name: {LastName}<br />Email: {Email}<br />Password: {Password}<br />Phone: {Phone}</p>', 'script');

INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdmin_pjActionIndex');

INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminClients');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminClients_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionCreate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionUpdate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionDeleteClient');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionDeleteClientBulk');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionStatusClient'); 
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminClients_pjActionExportClient');
    
INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminExtras');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminExtras_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionCreateForm');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionUpdateForm');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionDeleteExtra');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminExtras_pjActionDeleteExtraBulk');
    
INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminFleets');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminFleets_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminFleets_pjActionCreate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminFleets_pjActionUpdate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminFleets_pjActionDeleteFleet');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminFleets_pjActionDeleteFleetBulk');

INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBooking');
  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjPayments_pjActionIndex');
  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionBookingForm');
  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionNotifications');
  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminOptions_pjActionTerm');
  
INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminBookings');
SET @level_1_id := (SELECT LAST_INSERT_ID());

  INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_1_id, 'pjAdminBookings_pjActionIndex');
  SET @level_2_id := (SELECT LAST_INSERT_ID());

    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionCreate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionUpdate');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBooking');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionDeleteBookingBulk');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionExportBooking');
    INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, @level_2_id, 'pjAdminBookings_pjActionPrint');
    
INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionPreview');
INSERT INTO `taxi_plugin_auth_permissions` (`id`, `parent_id`, `key`) VALUES (NULL, NULL, 'pjAdminOptions_pjActionInstall');