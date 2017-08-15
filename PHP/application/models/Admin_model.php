<?php

class Admin_model extends CI_Model {

    public $name;
    public $email;

    public function __construct() {
        parent::__construct();
        $this->load->database();
    }

    //  ------------------- Users -----------------------------
    public function get_users() {
        $this->db->select('u.id AS user_id,u.email,u.user_name,r.restaurant_name,g.group_name');
        $this->db->from('users u');
        $this->db->join('user_group g', 'u.group_id=g.id');
        $this->db->join('restaurants r', 'u.restaurant_id=r.id');
        $this->db->order_by('group_name');
        // Show only users that are working on the same restaurant as Branch Mangaer
        if ($_SESSION['role'] == 2) {
            $this->db->where('group_id !=', 1);
            $this->db->where('restaurant_id', $_SESSION['restaurant_id']);
        }
        $query = $this->db->get();
        return $query->result_array();
    }

    public function change_available_driver($id, $available) {
        $array = array(
            'is_available' => $available
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('drivers');
    }



    public function change_password($id, $password) {
        $array = array(
            'password' => $password
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('users');
    }

    public function update($name, $email, $id) {
        $array = array(
            'user_name' => $name,
            'email' => $email
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('users');
    }

    public function delete_user($id) {
        $this->db->where('id', $id);
        $this->db->delete('users');
    }

    public function new_user($name, $email, $rest_id, $group_id) {
        $this->load->helper('jwt');
        $password = $this->input->post('password');
        $password_encrypt = password_hash($password, PASSWORD_DEFAULT);
        $key = password_hash(bin2hex(openssl_random_pseudo_bytes(16)), PASSWORD_DEFAULT);
        $token = array("name" => $name);
        $jwt = jwt::encode($token, $key);
        $data = array(
            'user_name' => $name,
            'email' => $email,
            'password' => $password_encrypt,
            'token' => $jwt,
            'token_key' => $key,
            'restaurant_id' => $rest_id,
            'group_id' => $group_id
        );
        $this->db->insert('users', $data);
    }

    public function search_users($search_text, $field_to_search) {
        if ($field_to_search == "restaurant_name") {
            //Get restaurant ID
            $this->db->where('restaurant_name', $search_text);
            $query = $this->db->get('restaurants');
            if ($query->row() !== null) {
                $restaurant_id = $query->row()->id;
            } else {
                redirect('admin');
            }

            //Search the ID in users table
            $this->db->select('u.id AS user_id,u.email,u.user_name,r.restaurant_name,g.group_name');
            $this->db->from('users u');
            $this->db->join('user_group g', 'u.group_id=g.id');
            $this->db->join('restaurants r', 'u.restaurant_id=r.id');
            $this->db->where('r.id', $restaurant_id);
            $query = $this->db->get();
            return $query->result_array();
        } else {
            $this->db->select('u.id AS user_id,u.email,u.user_name,r.restaurant_name,g.group_name');
            $this->db->from('users u');
            $this->db->join('user_group g', 'u.group_id=g.id');
            $this->db->join('restaurants r', 'u.restaurant_id=r.id');
            $this->db->like($field_to_search, $search_text);
            $this->db->order_by('restaurant_name');
            $query = $this->db->get();
            return $query->result_array();
        }
    }

    public function get_groups() {
        $query = $this->db->get('user_group');
        return $query->result();
    }

   
    //  ------------------- Drivers -----------------------------

    public function get_drivers() {
        $this->db->select('d.id AS driver_id,d.driver_name,d.phone,d.latitude,d.longitude,d.is_available,r.restaurant_name');
        $this->db->from('drivers d');
        $this->db->join('restaurants r', 'd.restaurant_id=r.id');
        $this->db->order_by('r.restaurant_name');
        // Show only users that are working on the same restaurant as Branch Mangaer
        if ($_SESSION['role'] == 2) {
            $this->db->where('restaurant_id', $_SESSION['restaurant_id']);
        }
        $query = $this->db->get();
        return $query->result_array();
    }

    public function new_driver($name, $phone, $restaurant_id) {
        //Create token
        $this->load->helper('jwt');
        $key = password_hash(bin2hex(openssl_random_pseudo_bytes(16)), PASSWORD_DEFAULT);
        $token = array("driver_name" => $name);
        $jwt = jwt::encode($token, $key);
        
        $data = array(
            'driver_name' => $name,
            'phone' => $phone,
            'restaurant_id' => $restaurant_id,
            'token' => $jwt
        );
        $this->db->insert('drivers', $data);
    }

    public function delete_driver($id) {
        $this->db->where('id', $id);
        $this->db->delete('drivers');
    }

    public function update_driver($name, $phone, $id) {
        $array = array(
            'driver_name' => $name,
            'phone' => $phone
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('drivers');
    }

    public function change_available($id, $available) {
        $array = array(
            'is_available' => $available
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('drivers');
    }

    public function search_drivers($search_text, $field_to_search) {
        if ($field_to_search == "restaurant_name") {
            //Get restaurant ID
            $this->db->where('restaurant_name', $search_text);
            $query = $this->db->get('restaurants');
            if ($query->row() !== null) {
                $restaurant_id = $query->row()->id;
            } else {
                redirect('admin');
            }
            //Search the ID in users table
            $this->db->select('d.id AS driver_id,d.driver_name,d.phone,d.latitude,d.longitude,d.is_available,r.restaurant_name');
            $this->db->from('drivers d');
            $this->db->join('restaurants r', 'd.restaurant_id = r.id');
            $this->db->where('r.id', $restaurant_id);
            $query = $this->db->get();
            return $query->result_array();
        } else {
            $this->db->select('d.id AS driver_id,d.driver_name,d.phone,d.latitude,d.longitude,d.is_available,r.restaurant_name');
            $this->db->from('drivers d');
            $this->db->join('restaurants r', 'd.restaurant_id = r.id');
            $this->db->like($field_to_search, $search_text);
            $query = $this->db->get();
            return $query->result_array();
        }
    }

        //  ------------------- Settings -----------------------------
    
     public function get_settings() {
        $query = $this->db->get('settings');
        return $query->result_array();
    }

    
    public function new_setting($name) {
        $data = array(
            'setting_name' => $name
        );
        $this->db->insert('settings', $data);
    }
    
    
      public function delete_setting($id) {
        $this->db->where('id', $id);
        $this->db->delete('settings');
    }
    
    public  function get_currencies() {
         $query = $this->db->get('currencies');
         return $query->result();
    }
    
     public  function change_currency($id) {
        $this->db->set('currency_id',$id);
        $this->db->update('settings');
    }
    
    
    
    


}
