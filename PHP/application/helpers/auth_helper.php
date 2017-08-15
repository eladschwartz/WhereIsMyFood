<?php

if (!function_exists('is_user_auth')) {

    function is_user_auth() {
        if (isset($_SESSION['token']) && !empty($_SESSION['token'])) {
            $CI = & get_instance();
            $CI->load->database();
            $token = $_SESSION['token'];
            $CI->db->where('token', $token);
            $query = $CI->db->get('users');
            if (!$query->num_rows() === 1) {
                redirect('login');
            }
        } else {
            redirect('login');
        }
    }

}

if (!function_exists('is_customer_auth')) {

    function is_customer_auth($token) {
        $CI = & get_instance();
        $CI->load->database();
        $CI->db->select('*');
        $CI->db->from('customers');
        $CI->db->where('token', $token);
        $query = $CI->db->get();
        if ($query->num_rows() == 0) {
            throw new Exception("Not Authorized");
        }
    }

}

if (!function_exists('is_driver_auth')) {

    function is_driver_auth($token) {
        $CI = & get_instance();
        $CI->load->database();
        $CI->db->select('*');
        $CI->db->from('drivers');
        $CI->db->where('token', $token);
        $query = $CI->db->get();
        if ($query->num_rows() == 0) {
            throw new Exception("Not Authorized");
        }
    }

}

if (!function_exists('is_user_admin')) {

    function is_user_admin() {
        if (isset($_SESSION['role']) && ($_SESSION['role'] != 1 && $_SESSION['role'] != 2)) {
            redirect('main');
        }
    }

}



