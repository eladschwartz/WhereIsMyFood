<?php

class Location_model extends CI_Model {
    
    public function __construct() {
        parent::__construct();
        $this->load->database();
    }

    function get_coordinates_drivers() {
        $coordinates = array();
        $this->db->select("driver_name, latitude,longitude");
        $this->db->from("drivers");
        $this->db->where('is_available', 0);
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            foreach ($query->result() as $row) {
                array_push($coordinates, $row);
            }
        }
        return $coordinates;
    }
    
        function get_coordinates_customers() {
        $customers = array();
        $this->db->select("c.customer_name, o.address");
        $this->db->from("orders o ");
        $this->db->join('customers c', 'o.customer_id = c.id');
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            foreach ($query->result() as $row) {
                array_push($customers, $row);
            }
        }
        return $customers;
    }

}
