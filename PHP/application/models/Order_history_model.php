<?php
class Order_history_model extends CI_Model {
    
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }                   
    
    public function get_orders(){
        $this->db->select('*');
        $this->db->from('orders_history');
        $this->db->order_by('created_at','DESC');
        $query = $this->db->get();
        return  $query->result();
        
    }
    
    public function get_driver_name($id) {
        $this->db->select('driver_name');
        $this->db->from('drivers');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->driver_name;
        }
        else
        {
            return false;
        }
    }
    

    public function get_order_info($id) {
        $this->db->select('*');
        $this->db->from('order_details od');
        $this->db->join('menu_items m', 'm.id=od.meal_id', 'left');
        $this->db->where('od.order_id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            
            return $query->result();
        }
        else
        {
            return false;
        }
    }

    public function get_customer_name($id) {
        $this->db->select('*');
        $this->db->from('customers');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->customer_name;
        }
        else
        {
            return false;
        } 
    }


    public function get_order_status($id) {
        $this->db->select('*');
        $this->db->from('status_group');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->status_name;
        }
        else
        {
            return false;
        } 
    }
}