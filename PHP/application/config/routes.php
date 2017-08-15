<?php
defined('BASEPATH') OR exit('No direct script access allowed');


$route['login'] = 'login/index';
$route['logout'] = 'logout/index';
$route['main'] = 'main/index';
$route['admin'] = 'admin/index';
$route['locations'] = 'location/index';
$route['restaurants'] = 'restaurants/index';
$route['menu_items'] = 'menu_items/index';
$route['addons'] = 'addons/index';
$route['addons_section'] = 'addons_section/index';
$route['addon_detail/(:num)'] = 'addon_detail/index/$1';
$route['items_category'] = 'items_category/index';
$route['orders'] = 'orders/index';
$route['new_order'] = 'new_order/index'; 
$route['orders_history'] = 'orders_history/index';
$route['default_controller'] = 'login';
$route['404_override'] = '';
$route['translate_uri_dashes'] = FALSE;
