-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:8889
-- Generation Time: Aug 14, 2017 at 01:38 PM
-- Server version: 5.6.35
-- PHP Version: 7.0.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `whereismyfood`
--

-- --------------------------------------------------------

--
-- Table structure for table `addons`
--

CREATE TABLE `addons` (
  `id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `addon_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addons`
--

INSERT INTO `addons` (`id`, `section_id`, `addon_name`) VALUES
(1, 1, 'Bacon'),
(2, 2, 'Pink'),
(3, 3, 'Egg'),
(4, 1, 'Mayo'),
(5, 2, 'Well Done'),
(6, 2, 'Well'),
(7, 3, 'Fries'),
(8, 3, 'Egg'),
(9, 3, 'Asparagus'),
(10, 3, 'Baked beans'),
(11, 3, 'Baked potatoes'),
(12, 3, 'Broccoli'),
(13, 1, 'Cabbage'),
(14, 3, 'Cauliflower');

-- --------------------------------------------------------

--
-- Table structure for table `addons_section`
--

CREATE TABLE `addons_section` (
  `id` int(11) NOT NULL,
  `section_type_id` int(255) NOT NULL,
  `section_name` varchar(255) DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `addons_section`
--

INSERT INTO `addons_section` (`id`, `section_type_id`, `section_name`, `is_required`) VALUES
(1, 2, 'Add-On', 0),
(2, 1, 'Temperature', 1),
(3, 1, 'Sides', 0),
(4, 1, 'test', 0);

-- --------------------------------------------------------

--
-- Table structure for table `addons_section_type`
--

CREATE TABLE `addons_section_type` (
  `id` int(11) NOT NULL,
  `type_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `addons_section_type`
--

INSERT INTO `addons_section_type` (`id`, `type_name`) VALUES
(1, 'single'),
(2, 'multi');

-- --------------------------------------------------------

--
-- Table structure for table `addon_detail`
--

CREATE TABLE `addon_detail` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `addon_id` int(11) NOT NULL,
  `price` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `addon_detail`
--

INSERT INTO `addon_detail` (`id`, `item_id`, `addon_id`, `price`) VALUES
(1, 6, 1, 5),
(2, 10, 2, NULL),
(3, 6, 3, 10),
(57, 10, 1, 5),
(58, 10, 14, 5),
(59, 10, 4, 1),
(61, 6, 4, 5),
(62, 10, 5, NULL),
(63, 10, 7, 10),
(64, 10, 11, 4),
(65, 10, 10, 4),
(66, 10, 9, 4),
(67, 10, 8, 4),
(71, 11, 1, 5),
(72, 11, 2, NULL),
(73, 11, 4, 2),
(74, 11, 8, 4),
(75, 11, 7, 6),
(76, 11, 14, 7),
(77, 45, 2, NULL),
(78, 45, 1, 5),
(79, 45, 14, 5),
(80, 45, 4, 1),
(81, 45, 5, NULL),
(82, 45, 7, 10),
(83, 45, 11, 4),
(84, 45, 10, 4),
(85, 45, 9, 4),
(86, 45, 8, 4),
(87, 45, 12, 4),
(88, 46, 1, 5),
(89, 46, 2, NULL),
(90, 46, 4, 2),
(91, 46, 8, 4),
(92, 46, 7, 6),
(93, 46, 14, 7),
(94, 47, 2, NULL),
(95, 47, 1, 5),
(96, 47, 14, 5),
(97, 47, 4, 1),
(98, 47, 5, NULL),
(99, 47, 7, 10),
(100, 47, 11, 4),
(101, 47, 10, 4),
(102, 47, 9, 4),
(103, 47, 8, 4),
(104, 47, 12, 4),
(105, 48, 2, NULL),
(106, 48, 1, 5),
(107, 48, 14, 5),
(108, 48, 4, 1),
(109, 48, 5, NULL),
(110, 48, 7, 10),
(111, 48, 11, 4),
(112, 48, 10, 4),
(113, 48, 9, 4),
(114, 48, 8, 4),
(115, 48, 12, 4),
(116, 49, 2, NULL),
(117, 49, 1, 5),
(118, 49, 14, 5),
(119, 49, 4, 1),
(120, 49, 5, NULL),
(121, 49, 7, 10),
(122, 49, 11, 4),
(123, 49, 10, 4),
(124, 49, 9, 4),
(125, 49, 8, 4),
(126, 49, 12, 4),
(127, 50, 2, NULL),
(128, 50, 1, 5),
(129, 50, 14, 5),
(130, 50, 4, 1),
(131, 50, 5, NULL),
(132, 50, 7, 10),
(133, 50, 11, 4),
(134, 50, 10, 4),
(135, 50, 9, 4),
(136, 50, 8, 4),
(137, 50, 12, 4),
(138, 51, 1, 5),
(139, 51, 3, 10),
(140, 51, 4, 5),
(141, 52, 1, 5),
(142, 52, 3, 10),
(143, 52, 4, 5),
(144, 10, 12, 10);

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(11) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `code` varchar(25) DEFAULT NULL,
  `symbol` varchar(25) DEFAULT NULL,
  `thousand_separator` varchar(10) DEFAULT NULL,
  `decimal_separator` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `country`, `currency`, `code`, `symbol`, `thousand_separator`, `decimal_separator`) VALUES
(1, 'Albania', 'Leke', 'ALL', 'Lek', ',', '.'),
(2, 'America', 'Dollars', 'USD', '$', ',', '.'),
(3, 'Afghanistan', 'Afghanis', 'AF', '؋', ',', '.'),
(4, 'Argentina', 'Pesos', 'ARS', '$', ',', '.'),
(5, 'Aruba', 'Guilders', 'AWG', 'ƒ', ',', '.'),
(6, 'Australia', 'Dollars', 'AUD', '$', ',', '.'),
(7, 'Azerbaijan', 'New Manats', 'AZ', 'ман', ',', '.'),
(8, 'Bahamas', 'Dollars', 'BSD', '$', ',', '.'),
(9, 'Barbados', 'Dollars', 'BBD', '$', ',', '.'),
(10, 'Belarus', 'Rubles', 'BYR', 'p.', ',', '.'),
(11, 'Belgium', 'Euro', 'EUR', '€', ',', '.'),
(12, 'Beliz', 'Dollars', 'BZD', 'BZ$', ',', '.'),
(13, 'Bermuda', 'Dollars', 'BMD', '$', ',', '.'),
(14, 'Bolivia', 'Bolivianos', 'BOB', '$b', ',', '.'),
(15, 'Bosnia and Herzegovina', 'Convertible Marka', 'BAM', 'KM', ',', '.'),
(16, 'Botswana', 'Pula\'s', 'BWP', 'P', ',', '.'),
(17, 'Bulgaria', 'Leva', 'BG', 'лв', ',', '.'),
(18, 'Brazil', 'Reais', 'BRL', 'R$', ',', '.'),
(19, 'Britain (United Kingdom)', 'Pounds', 'GBP', '£', ',', '.'),
(20, 'Brunei Darussalam', 'Dollars', 'BND', '$', ',', '.'),
(21, 'Cambodia', 'Riels', 'KHR', '៛', ',', '.'),
(22, 'Canada', 'Dollars', 'CAD', '$', ',', '.'),
(23, 'Cayman Islands', 'Dollars', 'KYD', '$', ',', '.'),
(24, 'Chile', 'Pesos', 'CLP', '$', ',', '.'),
(25, 'China', 'Yuan Renminbi', 'CNY', '¥', ',', '.'),
(26, 'Colombia', 'Pesos', 'COP', '$', ',', '.'),
(27, 'Costa Rica', 'Colón', 'CRC', '₡', ',', '.'),
(28, 'Croatia', 'Kuna', 'HRK', 'kn', ',', '.'),
(29, 'Cuba', 'Pesos', 'CUP', '₱', ',', '.'),
(30, 'Cyprus', 'Euro', 'EUR', '€', ',', '.'),
(31, 'Czech Republic', 'Koruny', 'CZK', 'Kč', ',', '.'),
(32, 'Denmark', 'Kroner', 'DKK', 'kr', ',', '.'),
(33, 'Dominican Republic', 'Pesos', 'DOP ', 'RD$', ',', '.'),
(34, 'East Caribbean', 'Dollars', 'XCD', '$', ',', '.'),
(35, 'Egypt', 'Pounds', 'EGP', '£', ',', '.'),
(36, 'El Salvador', 'Colones', 'SVC', '$', ',', '.'),
(37, 'England (United Kingdom)', 'Pounds', 'GBP', '£', ',', '.'),
(38, 'Euro', 'Euro', 'EUR', '€', ',', '.'),
(39, 'Falkland Islands', 'Pounds', 'FKP', '£', ',', '.'),
(40, 'Fiji', 'Dollars', 'FJD', '$', ',', '.'),
(41, 'France', 'Euro', 'EUR', '€', ',', '.'),
(42, 'Ghana', 'Cedis', 'GHC', '¢', ',', '.'),
(43, 'Gibraltar', 'Pounds', 'GIP', '£', ',', '.'),
(44, 'Greece', 'Euro', 'EUR', '€', ',', '.'),
(45, 'Guatemala', 'Quetzales', 'GTQ', 'Q', ',', '.'),
(46, 'Guernsey', 'Pounds', 'GGP', '£', ',', '.'),
(47, 'Guyana', 'Dollars', 'GYD', '$', ',', '.'),
(48, 'Holland (Netherlands)', 'Euro', 'EUR', '€', ',', '.'),
(49, 'Honduras', 'Lempiras', 'HNL', 'L', ',', '.'),
(50, 'Hong Kong', 'Dollars', 'HKD', '$', ',', '.'),
(51, 'Hungary', 'Forint', 'HUF', 'Ft', ',', '.'),
(52, 'Iceland', 'Kronur', 'ISK', 'kr', ',', '.'),
(53, 'India', 'Rupees', 'INR', 'Rp', ',', '.'),
(54, 'Indonesia', 'Rupiahs', 'IDR', 'Rp', ',', '.'),
(55, 'Iran', 'Rials', 'IRR', '﷼', ',', '.'),
(56, 'Ireland', 'Euro', 'EUR', '€', ',', '.'),
(57, 'Isle of Man', 'Pounds', 'IMP', '£', ',', '.'),
(58, 'Israel', 'New Shekels', 'ILS', '₪', ',', '.'),
(59, 'Italy', 'Euro', 'EUR', '€', ',', '.'),
(60, 'Jamaica', 'Dollars', 'JMD', 'J$', ',', '.'),
(61, 'Japan', 'Yen', 'JPY', '¥', ',', '.'),
(62, 'Jersey', 'Pounds', 'JEP', '£', ',', '.'),
(63, 'Kazakhstan', 'Tenge', 'KZT', 'лв', ',', '.'),
(64, 'Korea (North)', 'Won', 'KPW', '₩', ',', '.'),
(65, 'Korea (South)', 'Won', 'KRW', '₩', ',', '.'),
(66, 'Kyrgyzstan', 'Soms', 'KGS', 'лв', ',', '.'),
(67, 'Laos', 'Kips', 'LAK', '₭', ',', '.'),
(68, 'Latvia', 'Lati', 'LVL', 'Ls', ',', '.'),
(69, 'Lebanon', 'Pounds', 'LBP', '£', ',', '.'),
(70, 'Liberia', 'Dollars', 'LRD', '$', ',', '.'),
(71, 'Liechtenstein', 'Switzerland Francs', 'CHF', 'CHF', ',', '.'),
(72, 'Lithuania', 'Litai', 'LTL', 'Lt', ',', '.'),
(73, 'Luxembourg', 'Euro', 'EUR', '€', ',', '.'),
(74, 'Macedonia', 'Denars', 'MKD', 'ден', ',', '.'),
(75, 'Malaysia', 'Ringgits', 'MYR', 'RM', ',', '.'),
(76, 'Malta', 'Euro', 'EUR', '€', ',', '.'),
(77, 'Mauritius', 'Rupees', 'MUR', '₨', ',', '.'),
(78, 'Mexico', 'Pesos', 'MX', '$', ',', '.'),
(79, 'Mongolia', 'Tugriks', 'MNT', '₮', ',', '.'),
(80, 'Mozambique', 'Meticais', 'MZ', 'MT', ',', '.'),
(81, 'Namibia', 'Dollars', 'NAD', '$', ',', '.'),
(82, 'Nepal', 'Rupees', 'NPR', '₨', ',', '.'),
(83, 'Netherlands Antilles', 'Guilders', 'ANG', 'ƒ', ',', '.'),
(84, 'Netherlands', 'Euro', 'EUR', '€', ',', '.'),
(85, 'New Zealand', 'Dollars', 'NZD', '$', ',', '.'),
(86, 'Nicaragua', 'Cordobas', 'NIO', 'C$', ',', '.'),
(87, 'Nigeria', 'Nairas', 'NG', '₦', ',', '.'),
(88, 'North Korea', 'Won', 'KPW', '₩', ',', '.'),
(89, 'Norway', 'Krone', 'NOK', 'kr', ',', '.'),
(90, 'Oman', 'Rials', 'OMR', '﷼', ',', '.'),
(91, 'Pakistan', 'Rupees', 'PKR', '₨', ',', '.'),
(92, 'Panama', 'Balboa', 'PAB', 'B/.', ',', '.'),
(93, 'Paraguay', 'Guarani', 'PYG', 'Gs', ',', '.'),
(94, 'Peru', 'Nuevos Soles', 'PE', 'S/.', ',', '.'),
(95, 'Philippines', 'Pesos', 'PHP', 'Php', ',', '.'),
(96, 'Poland', 'Zlotych', 'PL', 'zł', ',', '.'),
(97, 'Qatar', 'Rials', 'QAR', '﷼', ',', '.'),
(98, 'Romania', 'New Lei', 'RO', 'lei', ',', '.'),
(99, 'Russia', 'Rubles', 'RUB', 'руб', ',', '.'),
(100, 'Saint Helena', 'Pounds', 'SHP', '£', ',', '.'),
(101, 'Saudi Arabia', 'Riyals', 'SAR', '﷼', ',', '.'),
(102, 'Serbia', 'Dinars', 'RSD', 'Дин.', ',', '.'),
(103, 'Seychelles', 'Rupees', 'SCR', '₨', ',', '.'),
(104, 'Singapore', 'Dollars', 'SGD', '$', ',', '.'),
(105, 'Slovenia', 'Euro', 'EUR', '€', ',', '.'),
(106, 'Solomon Islands', 'Dollars', 'SBD', '$', ',', '.'),
(107, 'Somalia', 'Shillings', 'SOS', 'S', ',', '.'),
(108, 'South Africa', 'Rand', 'ZAR', 'R', ',', '.'),
(109, 'South Korea', 'Won', 'KRW', '₩', ',', '.'),
(110, 'Spain', 'Euro', 'EUR', '€', ',', '.'),
(111, 'Sri Lanka', 'Rupees', 'LKR', '₨', ',', '.'),
(112, 'Sweden', 'Kronor', 'SEK', 'kr', ',', '.'),
(113, 'Switzerland', 'Francs', 'CHF', 'CHF', ',', '.'),
(114, 'Suriname', 'Dollars', 'SRD', '$', ',', '.'),
(115, 'Syria', 'Pounds', 'SYP', '£', ',', '.'),
(116, 'Taiwan', 'New Dollars', 'TWD', 'NT$', ',', '.'),
(117, 'Thailand', 'Baht', 'THB', '฿', ',', '.'),
(118, 'Trinidad and Tobago', 'Dollars', 'TTD', 'TT$', ',', '.'),
(119, 'Turkey', 'Lira', 'TRY', 'TL', ',', '.'),
(120, 'Turkey', 'Liras', 'TRL', '£', ',', '.'),
(121, 'Tuvalu', 'Dollars', 'TVD', '$', ',', '.'),
(122, 'Ukraine', 'Hryvnia', 'UAH', '₴', ',', '.'),
(123, 'United Kingdom', 'Pounds', 'GBP', '£', ',', '.'),
(124, 'United States of America', 'Dollars', 'USD', '$', ',', '.'),
(125, 'Uruguay', 'Pesos', 'UYU', '$U', ',', '.'),
(126, 'Uzbekistan', 'Sums', 'UZS', 'лв', ',', '.'),
(127, 'Vatican City', 'Euro', 'EUR', '€', ',', '.'),
(128, 'Venezuela', 'Bolivares Fuertes', 'VEF', 'Bs', ',', '.'),
(129, 'Vietnam', 'Dong', 'VND', '₫', ',', '.'),
(130, 'Yemen', 'Rials', 'YER', '﷼', ',', '.'),
(131, 'Zimbabwe', 'Zimbabwe Dollars', 'ZWD', 'Z$', ',', '.');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `phone` varchar(500) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `uid` varchar(255) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `address` varchar(500) NOT NULL,
  `floor` varchar(3) NOT NULL,
  `apartnum` varchar(3) NOT NULL,
  `country` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `state` varchar(255) DEFAULT NULL,
  `zip_code` int(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `token` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `phone`, `customer_name`, `email`, `uid`, `ip_address`, `address`, `floor`, `apartnum`, `country`, `city`, `state`, `zip_code`, `created_at`, `token`) VALUES
(49, '+12', 'John Doe', 'test@gmail.com', '654153E3-8C0C-4EA7-BF16-FA1FCDFF0CC8', '1', '137 Amazon Ave\r\n', '3', '1', 'USA', 'San Francisco', 'CA', 94112, '2017-08-14 11:36:34', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjdXN0b21lcl9uYW1lIjoiZWxhZCJ9.JoaVn_cmi2P8mpB07J_RWoD9hsBWrasSA8-tS2IEheI');

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `driver_name` varchar(255) NOT NULL,
  `phone` varchar(500) NOT NULL,
  `latitude` float NOT NULL,
  `longitude` float NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `active_order` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `drivers`
--

INSERT INTO `drivers` (`id`, `restaurant_id`, `driver_name`, `phone`, `latitude`, `longitude`, `token`, `created_at`, `is_available`, `active_order`) VALUES
(12, 4, 'Jon Driver', '+11', 0, 0, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkcml2ZXJfbmFtZSI6IkpvbiBEb2UifQ.0TbnkSnJlu3mOX8G4I1x7HY712StprjZYdZzwPZMK28', '2017-08-14 11:33:10', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `items_category`
--

CREATE TABLE `items_category` (
  `id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `image` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `items_category`
--

INSERT INTO `items_category` (`id`, `category_name`, `image`) VALUES
(1, 'Hamburger', 'http://whereismyfood.biz/img/items_category/burgers.png'),
(2, 'Fish', 'http://whereismyfood.biz/img/items_category/fish_(3).png'),
(3, 'Salad', 'http://whereismyfood.biz/img/items_category/Salad.png'),
(4, 'Sushi', 'http://whereismyfood.biz/img/items_category/sushi.png'),
(5, 'Dessert', 'http://whereismyfood.biz/img/items_category/dessert_(1).png'),
(6, 'Soup', 'http://whereismyfood.biz/img/items_category/soups.png');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT 'UPLOAD IMAGE',
  `price` float NOT NULL,
  `is_discount` tinyint(1) NOT NULL DEFAULT '0',
  `discount_rate` decimal(10,0) DEFAULT '0',
  `show_menu` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `category_id`, `restaurant_id`, `item_name`, `description`, `image`, `price`, `is_discount`, `discount_rate`, `show_menu`, `created_at`) VALUES
(6, 2, 4, 'Tuna Hamburger', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 100, 1, '10', 1, '2017-04-26 08:58:29'),
(7, 2, 10, 'Chicken Burger', 'fgedr', 'UPLOAD IMAGE', 50, 0, '0', 1, '2017-04-26 09:20:31'),
(8, 1, 10, 'Veggie Burger', 'greger', 'UPLOAD IMAGE', 20, 0, '0', 1, '2017-04-26 09:20:47'),
(9, 4, 4, 'Shushi', 'Shushi', 'http://whereismyfood.biz/img/menu_items/shshi.jpeg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(10, 1, 4, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(11, 1, 4, 'Hamburger4', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-179833.jpeg', 20, 1, '10', 1, '2017-04-25 12:35:46'),
(12, 2, 4, 'Tuna Hamburger3', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 25, 0, '0', 1, '2017-04-26 08:58:29'),
(13, 1, 4, 'Hamburger3', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/burger-cheese-food-hamburger.jpg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(14, 1, 4, 'Hamburger5', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/abstract-barbeque-bbq-beauty-161675.jpeg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(15, 2, 4, 'Tuna Hamburger6', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 30, 0, '0', 1, '2017-04-26 08:58:29'),
(16, 1, 4, 'Hamburger7', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(18, 2, 9, 'Tuna Hamburger9', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 40, 0, '0', 1, '2017-04-26 08:58:29'),
(19, 1, 9, 'Hamburge10', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/beef-burger.jpg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(20, 1, 8, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/beef-burger.jpg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(22, 1, 4, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-121513_(1).jpeg', 100, 0, '10', 1, '2017-04-25 12:35:46'),
(23, 3, 4, 'Salad', 'Salad', 'http://whereismyfood.biz/img/menu_items/salad.jpg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(24, 1, 8, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-121513_(1).jpeg', 100, 0, '10', 1, '2017-04-25 12:35:46'),
(25, 1, 10, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-121513_(1).jpeg', 100, 0, '10', 1, '2017-04-25 12:35:46'),
(32, 3, 4, 'Salad', 'Salad', 'http://whereismyfood.biz/img/menu_items/pexels-photo-406152.jpeg', 10, 0, '0', 1, '2017-07-19 14:09:28'),
(33, 3, 4, 'Salad', 'Salad', 'http://whereismyfood.biz/img/menu_items/pexels-photo-521502.jpeg', 10, 0, '0', 1, '2017-07-19 14:09:28'),
(34, 4, 4, 'Shushi', 'Shushi', 'http://whereismyfood.biz/img/menu_items/sushi-eat-japanese-asia-47546.jpeg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(35, 4, 4, 'Shushi', 'Shushi', 'http://whereismyfood.biz/img/menu_items/pexels-photo-357756.jpeg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(37, 1, 6, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(39, 1, 6, 'Hamburger4', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-179833.jpeg', 20, 1, '10', 1, '2017-04-25 12:35:46'),
(40, 1, 6, 'Hamburger7', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 20, 0, '0', 1, '2017-04-25 12:35:46'),
(45, 1, 5, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(46, 1, 5, 'Hamburger4', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/pexels-photo-179833.jpeg', 20, 1, '10', 1, '2017-04-25 12:35:46'),
(47, 1, 5, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(48, 1, 5, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(49, 1, 6, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(50, 1, 6, 'Hamburger', 'chopped applewood smoked bacon, cheddar cheese, scallion cream, potato crisp, Certified Angus Beef® burger, brioche bun, Cheese & Ale Sauc', 'http://whereismyfood.biz/img/menu_items/lunch-hamburger-bistro-78190.jpeg', 10, 0, '0', 1, '2017-04-25 12:35:46'),
(51, 2, 5, 'Tuna Hamburger', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 100, 1, '10', 1, '2017-04-26 08:58:29'),
(52, 2, 6, 'Tuna Hamburger', 'applewood smoked bacon, Gouda cheese, guacamole, onion strings, chipotle- jalapeño sauce, Certified Angus Beef® burger, lettuce, tomato, brioche bun', 'http://whereismyfood.biz/img/menu_items/tuna-burger.jpg', 100, 1, '10', 1, '2017-04-26 08:58:29'),
(53, 3, 5, 'Salad', 'Salad', 'http://whereismyfood.biz/img/menu_items/salad.jpg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(54, 3, 6, 'Salad', 'Salad', 'http://whereismyfood.biz/img/menu_items/salad.jpg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(55, 4, 6, 'Shushi', 'Shushi', 'http://whereismyfood.biz/img/menu_items/shshi.jpeg', 30, 0, '0', 1, '2017-04-26 09:20:47'),
(56, 5, 4, 'Cake', 'Cake', 'http://whereismyfood.biz/img/menu_items/pexels-photo-132694.jpeg', 5, 0, '0', 1, '2017-07-21 07:45:41'),
(57, 5, 5, 'Cake', 'Cake', 'http://whereismyfood.biz/img/menu_items/pexels-photo-132694.jpeg', 5, 0, '0', 1, '2017-07-21 07:45:41'),
(58, 5, 6, 'Cake', 'Cake', 'http://whereismyfood.biz/img/menu_items/pexels-photo-132694.jpeg', 5, 0, '0', 1, '2017-07-21 07:45:41'),
(59, 6, 4, 'Soup', 'Soup.png', 'http://whereismyfood.biz/img/menu_items/pexels-photo-539451.jpeg', 2, 0, '0', 1, '2017-08-06 08:48:24');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `address` varchar(500) NOT NULL,
  `address_floor` varchar(3) NOT NULL,
  `address_aprt` varchar(3) NOT NULL,
  `total` float NOT NULL,
  `restaurant_notes` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picked_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `orders_history`
--

CREATE TABLE `orders_history` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `address` varchar(500) NOT NULL,
  `address_floor` varchar(3) NOT NULL,
  `address_aprt` varchar(3) NOT NULL,
  `total` int(11) NOT NULL,
  `restaurant_notes` varchar(500) NOT NULL,
  `delivery_notes` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picked_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `sub_total` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_item_addons`
--

CREATE TABLE `order_item_addons` (
  `id` int(11) NOT NULL,
  `order_detail_id` int(11) NOT NULL,
  `addon_detail_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

-- --------------------------------------------------------

--
-- Table structure for table `order_status`
--

CREATE TABLE `order_status` (
  `id` int(11) NOT NULL,
  `status_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `order_status`
--

INSERT INTO `order_status` (`id`, `status_name`) VALUES
(1, 'New'),
(2, 'Processing'),
(3, 'In Delivery'),
(4, 'Delivered'),
(6, 'Canceled'),
(7, 'Ready'),
(8, 'Cooking');

-- --------------------------------------------------------

--
-- Table structure for table `restaurants`
--

CREATE TABLE `restaurants` (
  `id` int(11) NOT NULL,
  `restaurant_name` varchar(255) NOT NULL,
  `restaurant_address` varchar(255) NOT NULL,
  `phone_number` varchar(50) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT 'UPLOAD IMAGE',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `is_main` tinyint(1) NOT NULL DEFAULT '0',
  `delivery_fee` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `restaurants`
--

INSERT INTO `restaurants` (`id`, `restaurant_name`, `restaurant_address`, `phone_number`, `image`, `active`, `is_main`, `delivery_fee`, `created_at`) VALUES
(4, 'Achilles', '398 Hawkins StHollister, CA 95023USA', '202-555-0101', 'http://whereismyfood.biz/img/restaurants/pexels-photo-370984_(2).jpeg', 1, 1, 5.5, '2017-04-22 13:42:56'),
(5, 'YummyFood2', '71 Pilgrim Avenue  Chevy Chase, MD 20815', '202-555-4444', 'http://whereismyfood.biz/img/restaurants/pexels-photo-331107.jpeg', 1, 0, 0, '2017-07-15 08:17:30'),
(6, 'SoGoodFood', '123 6th St.  Melbourne, FL 32904', '222-555-03333', 'http://whereismyfood.biz/img/restaurants/pexels-photo-67468.jpeg', 1, 0, 0, '2017-07-19 13:36:12');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `currency_id` int(11) DEFAULT NULL,
  `setting_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `currency_id`, `setting_name`) VALUES
(1, 2, 'Currency');

-- --------------------------------------------------------

--
-- Table structure for table `stripe_customers`
--

CREATE TABLE `stripe_customers` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `cust_stripe_id` varchar(500) NOT NULL,
  `email` varchar(255) NOT NULL,
  `customer_name` varchar(500) NOT NULL,
  `card` varchar(100) NOT NULL,
  `last4` varchar(4) NOT NULL,
  `used_last` tinyint(4) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `token_key` varchar(255) NOT NULL,
  `last_login` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `restaurant_id`, `group_id`, `user_name`, `email`, `password`, `token`, `token_key`, `last_login`, `is_active`, `created_at`) VALUES
(25, 4, 1, 'Admin', 'admin@admin.com', '$2y$10$9j6g6.ExxHj2Ucvlzbq.vOL9cHspuigGkv.t5pOFOdeGSVKr1Z3wu', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiZWxhZCBzY2h3YXJ0eiJ9.SZWK8K-OZgil8EsNpDPi8rBgF_rEFKIOqLXBRvNO4dg', '$2y$10$FxV3D8peNDQJf6OnLTHsnuXMnxnDD6N8JepJZxjxilBpKBvM0s30a', '0000-00-00 00:00:00', 1, '2017-05-18 12:38:39');

-- --------------------------------------------------------

--
-- Table structure for table `user_group`
--

CREATE TABLE `user_group` (
  `id` int(11) NOT NULL,
  `group_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_group`
--

INSERT INTO `user_group` (`id`, `group_name`) VALUES
(1, 'Admin'),
(2, 'Branch Manager'),
(3, 'Staff');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addons`
--
ALTER TABLE `addons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `addons_section`
--
ALTER TABLE `addons_section`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `addons_section_type`
--
ALTER TABLE `addons_section_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `addon_detail`
--
ALTER TABLE `addon_detail`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items_category`
--
ALTER TABLE `items_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders_history`
--
ALTER TABLE `orders_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_item_addons`
--
ALTER TABLE `order_item_addons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stripe_customers`
--
ALTER TABLE `stripe_customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_group`
--
ALTER TABLE `user_group`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addons`
--
ALTER TABLE `addons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `addons_section`
--
ALTER TABLE `addons_section`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `addons_section_type`
--
ALTER TABLE `addons_section_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `addon_detail`
--
ALTER TABLE `addon_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;
--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;
--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;
--
-- AUTO_INCREMENT for table `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `items_category`
--
ALTER TABLE `items_category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `orders_history`
--
ALTER TABLE `orders_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `order_details`
--
ALTER TABLE `order_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `order_item_addons`
--
ALTER TABLE `order_item_addons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;
--
-- AUTO_INCREMENT for table `order_status`
--
ALTER TABLE `order_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `stripe_customers`
--
ALTER TABLE `stripe_customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT for table `user_group`
--
ALTER TABLE `user_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;