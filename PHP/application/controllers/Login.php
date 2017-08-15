<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Login extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('Login_model');
        $this->load->helper('form');
        $this->load->library('form_validation');
    }

    public function index() {
        $this->load->view('auth/login');
    }

    public function login_user() {
        $this->form_validation->set_rules('password', 'Password', 'trim|required');
        $this->form_validation->set_rules('email', 'Email', 'valid_email|required');
        if ($this->form_validation->run() == FALSE) {
            $this->load->view('auth/login');
        } else {
            $password = $this->input->post('password');
            $email = $this->input->post('email');
            $result = $this->Login_model->verify_user($email, $password);
            if ($result ['verified']) {
                $_SESSION['token'] = $result['token'];
                $_SESSION['restaurant_id'] = $result['restaurant_id'];
                $_SESSION['role'] = $result['group_id'];
                redirect('main');
            } else {
                redirect('login');
            }
        }
    }
   
    public function keep_session_alive() {
        $lastActivity = $this->session->userdata('last_activity');
        $configtimeout = $this->config->item('sess_expiration');
        $sessonExpireson = $lastActivity + $configtimeout;
        $threshold = $sessonExpireson - 300; //five minutes before session time out
        $current_time = time();
        if ($current_time >= $threshold) {
            $this->session->set_userdata('last_activity', time()); //THIS LINE DOES THE TRICK
            echo "Session Re-registered";
        } else {
            echo "Not yet time to re-register";
        }
        exit;
    }

}
