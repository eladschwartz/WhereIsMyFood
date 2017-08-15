<?php
require_once('../vendor/autoload.php');

class Api_drivers extends CI_Controller {
    
    private $token = "";
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
        $this->load->helper('auth_helper');
        $headers = $this->input->request_headers();
        if (isset($headers['Authorization'])) {
            $auth_header = preg_replace('/Bearer/', "", $headers['Authorization']);
            $this->token = preg_replace('/\s+/', '', $auth_header);
        }
        
    }
    public function get_orders(){
        is_driver_auth($this->token);
        $driver_id  = $this->input->get('driver_id');
        $this->db->select('orders.id, customers.customer_name, orders.address, orders.address_floor AS floor, orders.address_aprt AS apartnum, customers.phone');
        $this->db->from('orders');
        $this->db->join('customers', 'orders.customer_id = customers.id');
        $this->db->order_by('orders.created_at', 'DESC');
        $this->db->where('driver_id',$driver_id);
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    public function is_driver_approved() {
        $phone = $this->input->post('phone');
        $this->db->select('*');
        $this->db->from('drivers');
        $this->db->where('phone', $phone);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
             echo (true);
        }
    }
    
      public function get_driver_details() {
        $phone = $this->input->get('phone');
        $this->db->select('*');
        $this->db->from('drivers');
        $this->db->where('phone', $phone);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
             echo (json_encode($query->result()));
        }
    }

    public function update_location() {
        $latitude = $this->input->post('latitude');
        $longitude = $this->input->post('longitude');
        $driver_id =  $this->input->post('id');
        $this->db->set('latitude', $latitude);
        $this->db->set('longitude', $longitude);
        $this->db->where('id', $driver_id);
        $this->db->update('drivers');
    }

     public function complete_order() {
        $id = $this->input->post('id');
        $this->db->set('driver_id', null);
        $this->db->set('status_id', 4);
        $this->db->where('id', $id);
        $this->db->update('orders');
    }

      public function set_active_order() {
        $id = $this->input->post('id');
        $driver_id = $this->input->post('driver_id');
        $this->db->set('active_order', $id);
        $this->db->where('id', $driver_id);
        $this->db->update('drivers');
        echo (true);
    }
}