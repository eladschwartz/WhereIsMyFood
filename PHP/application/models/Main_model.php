<?php

class Main_model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->load->database();
    }

    public function count_open_orders() {
        $this->db->select('*');
        $this->db->from('orders');
        $this->db->where('status_id', 1);
        $query = $this->db->get();
        return $query->num_rows();
    }

    public function count_total_orders() {
        $this->db->select('*');
        $this->db->from('orders');
        $query = $this->db->get();
        return $query->num_rows();
    }
    
     public function total_sales_sum() {
        $this->db->select_sum('total');
        $this->db->from('orders');
        $query = $this->db->get();
        return $query->row()->total;
    }
    
    public function get_currency() {
        $this->db->select('symbol');
        $this->db->from('settings s');
        $this->db->join('currencies c', 'c.id = s.currency_id');
        $currency = $this->db->get()->row()->symbol;
        return $currency;
    }

}
