<?php

if(!function_exists('get_section_type'))
{
    function get_section_type($id)
    {
        $CI =& get_instance();
        $CI->load->model('Addons_section_model');
        return $CI->Addons_section_model->get_section_type($id);
    }
}



if(!function_exists('get_section_name'))
{
    function get_section_name($id)
    {
        $CI =& get_instance();
        $CI->load->model('Addons_model');
        return $CI->Addons_model->get_section_name($id);
    }
}

if(!function_exists('get_details_by_section'))
{
    function get_details_by_section($item_id,$section_name)
    {
        $CI =& get_instance();
        $CI->load->model('Addon_detail_model');
        return $CI->Addon_detail_model->get_details_by_section($item_id,$section_name);
    }
}

