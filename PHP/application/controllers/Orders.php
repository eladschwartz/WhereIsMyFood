<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Orders extends MY_Controller {

    public function __construct() {
        parent::__construct('orders', 'Order_model');
        is_user_auth();
    }

    public function index() {
        
    }

    public function init_data() {
        $search_field = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        if ($search_field && !empty($search_text)) {
            $data['orders'] = $this->Order_model->search($search_text, $search_field);
        } else {
            $data['orders'] = $this->Order_model->get_orders();
        }
        $data['error'] = "";
        $data['drivers'] = $this->Order_model->get_drivers();
        $data['restaurant_name'] = $this->Order_model->get_restaurant_name($_SESSION['restaurant_id']);
        $data['addons'] = "";
        return $data;
    }

    public function get_driver_name($id) {
        $name = $this->Order_model->get_driver_name($id);
        return $name;
    }

    public function delete($id) {
        is_user_auth();
        $this->Order_model->delete($id);
        redirect('orders');
    }

    public function cancel_order($id) {
        is_user_auth();
        $this->Order_model->cancel_order($id);
        redirect('orders');
    }

    public function assign_driver() {
        $action_name = $this->input->post('actionname');
        switch ($action_name) {
            case 'assign' :
                $driver_id = $this->input->post('driver-select');
                $order_id = $this->input->post('orderid');
                $this->Order_model->assign_driver($order_id, $driver_id);
                $this->Order_model->change_driver_available($driver_id);
                break;
            case 'change':
                $driver_id = $this->input->post('driver-select');
                $driver_id_to_change = $this->input->post('driverid');
                $order_id = $this->input->post('orderid');
                $this->Order_model->assign_driver($order_id, $driver_id);
                $this->Order_model->change_driver_available($driver_id, $driver_id_to_change);
                break;
        }
        redirect('orders');
    }

    public function change_driver() {
        $driver_id = $this->input->post('driver-select');
        $order_id = $this->input->post('orderid');
        $this->Order_model->assign_driver($order_id, $driver_id);
        $this->Order_model->change_driver_available($driver_id);
        redirect('orders');
    }

    public function complete_order($id) {
        $this->Order_model->complete_order($id);
        redirect('orders', 'location');
    }

    public function check_if_new_order() {
        $count = $this->Order_model->get_total_new_orders();
        echo $count;
        exit();
    }
    
    public  function change_status_processing(){
        $id = $this->input->post('id');
        $this->Order_model->change_status($id);
    }

}
