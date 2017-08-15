<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Pages extends CI_Controller {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->helper('auth');
        is_user_auth();
    }
    
    public function view($page = 'login')
    {
        if ( ! file_exists(APPPATH.'views/pages/'.$page.'.php'))
        {
            // Whoops, we don't have a page for that!
            show_404();
        }
        
        $data['title'] = ucfirst($page); // Capitalize the first letter
        $this->load->view('layout/header',$data);
        $this->load->view('layout/sidebar');
        $this->load->view('pages/'.$page, $data);
        $this->load->view('layout/footer');
    }
}