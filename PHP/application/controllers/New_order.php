<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require_once('../vendor/autoload.php');

class New_order extends MY_Controller {

    public function __construct() {
        parent::__construct('new_order', 'New_order_model');
    
        is_user_auth();
    }

    public function index() {
        
    }

    public function init_data() {
        $restaurant_id = $_SESSION['restaurant_id'];
        $data['error'] = "";
        $this->load->model('Menu_items_model');
        $this->data['items'] = $this->Menu_items_model->get_menu_items($restaurant_id);
    
        $data['addons'] = "";
        return $data;
    }

     public function new_item() {
        is_user_auth();
        $restaurant_id = $this->input->post('row-new-rest-id');
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('description', 'Description', 'trim|required');
        $this->form_validation->set_rules('price', 'Price', 'trim|required');
        $this->form_validation->set_rules('new-category', 'Category', 'required');
        if ($this->form_validation->run() == FALSE) {
            redirect('menu_items');
        } else {
            $name = $this->input->post('name');
            $desc = $this->input->post('description');
            $price = $this->input->post('price');
            $discount_rate = $this->input->post('discount');
            $category_id = $this->input->post('new-category');
            $this->Menu_items_model->new_item($name, $desc, $restaurant_id, $price, $discount_rate, $category_id);
            redirect('menu_items');
        }
    }

}
