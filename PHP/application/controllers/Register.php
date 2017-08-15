<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Register extends CI_Controller {
    
    
    public function __construct()
    {
        parent::__construct();
        $this->load->model('Register_model');
        $this->load->helper('form');
        $this->load->library('form_validation');
    }
    
    public function index() {
        $this->load->view('auth/register');
    }
    
    public function create_user()
    {
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('password', 'Password', 'trim|required');
        $this->form_validation->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_check');
        if ($this->form_validation->run() == FALSE)
        {
            $this->load->view('auth/register');
        }
        else {
            $this->load->helper('jwt');
            $password = password_hash($this->input->post('password'), PASSWORD_DEFAULT);
            $email = $this->input->post('email');
            $name = $this->input->post('name');
            $key = password_hash(bin2hex(openssl_random_pseudo_bytes(16)),PASSWORD_DEFAULT);
            $token = array( "name" => $name);
            $jwt =  jwt::encode($token, $key);
            $this->Register_model->register($name, $email, $key, $jwt, $password);
            $_SESSION['token'] = $jwt;
            redirect('main');
        }
    }
    
    //function for form validation, check if email alraedy exist in DB.
    public function email_check($str)
    {
        if ($this->Register_model->is_user_exist($str))
        {
            $this->form_validation->set_message('email_check', 'This {field} is already in use');
            return FALSE;
        }
        else
        {
            return TRUE;
        }
    }
}