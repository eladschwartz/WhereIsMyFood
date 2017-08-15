<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Orders_history extends MY_Controller {
    
    public function __construct()
    {
        parent::__construct('orders_history','Order_history_model');
        is_user_auth();
    }
    
    public function index() {
    }
    
    
    public function get_driver_name($id) {
        $name =  $this->Order_history_model->get_driver_name($id);
        return $name;
    }
    
    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('orders_history');
        redirect('orders_history');
    }
    
    
    public function init_data() {
        $data['orders'] = $this->Order_history_model->get_orders();
        $data['error'] = "";
        return $data;
    }
}