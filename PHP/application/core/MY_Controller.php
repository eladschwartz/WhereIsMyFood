<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class MY_Controller extends CI_Controller {
   public function __construct($page_name, $modal_name)
   {
        parent::__construct();
        is_user_auth();
        $this->load->helper('auth');
        $this->load->helper('form');
        $this->load->helper('url');
        $this->load->helper('order');
        $this->load->helper('addons');
        $this->load->library('pagination');
        $this->load->library('form_validation');
        $this->load->model($modal_name);
        $data = $this->init_data();
        $data['total_orders_count'] = $this->get_total_new_orders();
        $data['new_orders'] = $this->get_new_orders();
        $success_msg =  $this->session->flashdata('success_msg');
        $error_msg =  $this->session->flashdata('error_msg');
        if ($success_msg != null) {
            $this->load->view('modals/success_modal');
        }
        if ($error_msg != null) {
            $data['error'] = $error_msg;
            $this->load->view('modals/error_modal',$data);
        }
        $this->load->view('layout/header',$data);
        $this->load->view('modals/new_notification',$data);
        $this->load->view('layout/sidebar');
        $this->load->view($page_name.'/index', $data);
        $this->load->view('layout/footer');
   }
   
    public function logout() {
        unset($_SESSION['token']);
        unset($_SESSION['restaurant_id_main']);
        unset($_SESSION['restaurant_id']);
        unset($_SESSION['role']);
    }
    

     public function get_new_orders() {
        $this->load->model('Order_model');
        return $this->Order_model->get_new_orders();
    }
    
    public function get_total_new_orders() {
        $this->load->model('Order_model');
        return $this->Order_model->get_total_new_orders();
    }
}
?>