<?php

if(!function_exists('get_driver_name'))
{
    function get_driver_name($id)
    {
        $CI =& get_instance();
        $CI->load->model('Order_model');
        return $CI->Order_model->get_driver_name($id);
    }
}

if(!function_exists('get_order_info'))
{
    function get_order_info($id)
    {
        $CI =& get_instance();
        $CI->load->model('Order_model');
        return $CI->Order_model->get_order_info($id);
    }
}
if(!function_exists('get_item_name'))
{
    function get_item_name($order_id)
    {
        $CI =& get_instance();
        $CI->load->model('Order_model');
        return $CI->Order_model->get_item_name($order_id);
    }
}




if(!function_exists('get_customer_name_order'))
{
    function get_customer_name_order($id)
    {
        $CI =& get_instance();
        $CI->load->model('Order_model');
        return $CI->Order_model->get_customer_name($id);
    }
}

if(!function_exists('get_order_status'))
{
    function get_order_status($id)
    {
        $CI =& get_instance();
        $CI->load->model('Order_model');
        return $CI->Order_model->get_order_status($id);
    }
}

if(!function_exists('get_addon'))
{
    function get_addon($id)
    {
        $CI =& get_instance();
        $CI->load->model('Addons_model');
        return $CI->Order_model->get_addon($id);
    }
}