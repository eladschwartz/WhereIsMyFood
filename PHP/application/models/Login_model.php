<?php
class Login_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    
    public function verify_user($email,$password)
    {
        $this->db->where('email',$email );
        $this->db->select('password, token, restaurant_id,group_id');
        $query  = $this->db->get('users')->result();
        $hash =  $query[0]->password;
        $token =  $query[0]->token;
        $restaurant_id =  $query[0]->restaurant_id;
        $group_id =  $query[0]->group_id;
        return  array (
            'verified'=>password_verify($password, $hash),
            'token'=> $token,
            'restaurant_id' => $restaurant_id,
            'group_id' => $group_id
        );
    } 
}