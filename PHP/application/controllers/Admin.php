<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Admin extends MY_Controller {

    public function __construct() {
        parent::__construct('admin', 'Admin_model');
        is_user_auth();
    }

    public function index() {
        
    }

    public function init_data() {
        //Init Users Data
        $search_text_user = $this->input->post('search');
        $search_field_user = $this->input->post('search_field');
        //If search requrest was made - show filtered data. if not show all data
        if ($search_field_user && !empty($search_field_user)) {
            $this->data['users'] = $this->Admin_model->search_users($search_text_user, $search_field_user);
        } else {
            $this->data['users'] = $this->Admin_model->get_users();
        }

        //Init Drivers Data
        $search_text_driver = $this->input->post('search_driver');
        $search_field_driver = $this->input->post('search_field_driver');
        //If search requrest was made - show filtered data. if not show all data
        if ($search_field_driver && !empty($search_text_driver)) {
            $this->data['drivers'] = $this->Admin_model->search_drivers($search_text_driver, $search_field_driver);
        } else {
            $this->data['drivers'] = $this->Admin_model->get_drivers();
        }
        //Init Settgins Data
        $data['settings'] = $this->Admin_model->get_settings();
        $data['currencies'] = $this->Admin_model->get_currencies();
        $this->load->model('Restaurant_model');
        $data['restaurants'] = $this->Restaurant_model->get_restaurants();
        $data['groups'] = $this->Admin_model->get_groups();
        $data['error'] = "";
        return $data;
    }

    //  ------------------- Users -----------------------------
    public function new_user() {
        is_user_auth();
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('email', 'Email', 'trim|required');
        $this->form_validation->set_rules('password', 'Password', 'trim|required');
        if ($this->form_validation->run() == FALSE) {

            redirect('admin');
        } else {
            $name = $this->input->post('name');
            $email = $this->input->post('email');
            $group_id = $this->input->post('groups');
            $restaurant_id = $this->input->post('restaurants');
            $this->Admin_model->new_user($name, $email, $restaurant_id, $group_id);
            redirect('admin');
        }
    }

    public function update_user() {
        is_user_auth();
        $this->form_validation->set_rules('edit-user-name', 'Name', 'trim|required');
        $this->form_validation->set_rules('edit-user-email', 'Email', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('admin');
        } else {
            $name = $this->input->post('edit-user-name');
            $email = $this->input->post('edit-user-email');
            $id = $this->input->post('row-id-edit');
            $this->Admin_model->update($name, $email, $id);
            redirect('admin');
        }
    }

    public function change_password() {
        is_user_auth();
        $this->form_validation->set_rules('change-password', 'Password', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('admin');
        } else {
            $id = $this->input->post('row-id-password');
            $password = password_hash($this->input->post('change-password'), PASSWORD_DEFAULT);
            $this->Admin_model->change_password($id, $password);
            redirect('admin');
        }
    }
    

    public function delete_user($id) {
        is_user_auth();
        $this->Admin_model->delete_user($id);
        redirect('admin');
    }

    //  ------------------- End - Users -----------------------------
    
    //  ------------------- Drivers -----------------------------

    public function new_driver() {
        is_user_auth();
        $this->form_validation->set_rules('driver_name', 'Name', 'trim|required');
        $this->form_validation->set_rules('driver_phone', 'Email', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('admin');
        } else {
            $name = $this->input->post('driver_name');
            $phone = $this->input->post('driver_phone');
            $restaurant_id = $_SESSION['restaurant_id'];
            $this->Admin_model->new_driver($name, $phone, $restaurant_id);
            redirect('admin');
        }
    }

    public function update_driver() {
        is_user_auth();
        $this->form_validation->set_rules('edit-driver-name', 'Name', 'trim|required');
        $this->form_validation->set_rules('edit-driver-phone', 'Phone', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('admin');
        } else {
            $name = $this->input->post('edit-driver-name');
            $phone = $this->input->post('edit-driver-phone');
            $id = $this->input->post('row-id-edit-driver');
            $this->Admin_model->update_driver($name, $phone, $id);
            redirect('admin');
        }
    }

    public function delete_driver($id) {
        is_user_auth();
        $this->Admin_model->delete_driver($id);
        redirect('admin');
    }

    public function change_available() {
        is_user_auth();
        $available = $this->input->post('is_available');
        $id = $this->input->post('id');
        $this->Admin_model->change_available($id, $available);
    }

    //  ------------------- End - Drivers -----------------------------

    
    //  ------------------- Settings -----------------------------
    
    public function new_setting() {
        is_user_auth();
        $this->form_validation->set_rules('setting_name', 'Name', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('admin');
        } else {
            $name = $this->input->post('setting_name');
            $this->Admin_model->new_setting($name);
            redirect('admin');
        }
    }
    
 
    
    public function delete_setting($id) {
        is_user_auth();
        $this->Admin_model->delete_setting($id);
        redirect('admin');
    }
    
      public  function change_currency() {
        is_user_auth();
        $currency_id = $this->input->post('id');
        $this->Admin_model->change_currency($currency_id );
        
    }

}
