<?php
class Register_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    
    public function register($name, $email, $key, $jwt, $password)
    {
            $data = array(
            'name' => $name,
            'email' => $email,
            'password' => $password,
            'token' => $jwt,
            'token_key' => $key
            );
            $this->db->insert('users', $data);
    }
    
    public function is_user_exist($email){
        $this->db->where('email',$email);
        $query  = $this->db->get('users');
        if ($query->num_rows() === 1){
            return true;
        }else {
            return false;
        }
    }
}