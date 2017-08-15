<?php
class Menu_items_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    public function get_menu_items($rest_id){
        $this->db->select('menu_items.id AS item_id,menu_items.restaurant_id,restaurant_name,item_name,menu_items.image,description,price,is_discount,discount_rate,show_menu');
        $this->db->from('menu_items');
        $this->db->join('restaurants', 'menu_items.restaurant_id = restaurants.id');
        $this->db->where('restaurant_id',$rest_id);
        $this->db->order_by('category_id, item_id');
        $query = $this->db->get();
        return $query->result();
    }
    
     public function total_items($rest_id) {
        $this->db->select('*');
        $this->db->from('menu_items');
        $this->db->where('restaurant_id',$rest_id);
        $result = $this->db->get()->result();
        return count($result);
    }

    
     public function total_items_by_category($rest_id,$category_id) {
        $this->db->select('*');
        $this->db->from('menu_items');
        $this->db->where('category_id',$category_id);
        $this->db->where('restaurant_id',$rest_id);
        $result = $this->db->get()->result();
        return count($result);
     }
    
        public function get_menu_items_by_category($rest_id,$category_id){
        $this->db->select('menu_items.id AS item_id,menu_items.restaurant_id,restaurant_name,item_name,menu_items.image,description,price,is_discount,discount_rate,show_menu');
        $this->db->from('menu_items');
        $this->db->join('restaurants', 'menu_items.restaurant_id = restaurants.id');
        $this->db->where('restaurant_id',$rest_id);
        $this->db->where('category_id',$category_id);
       $this->db->order_by('category_id, item_id');
        $query = $this->db->get();
        return $query->result();
    }
    
    
    public function new_item($name,$desc,$rest_id,$price,$disc_rate = null,$category_id) {
        $data = array(
            'item_name' => $name,
            'description' => $desc,
            'restaurant_id' => $rest_id,
            'price' => $price,
            'discount_rate' => $disc_rate,
            'category_id' => $category_id
        );
        $this->db->insert('menu_items', $data);
    }
    
    
    public function update($id,$name,$desc,$price,$disc_rate) {
        $array = array(
            'item_name' => $name,
            'description' => $desc,
            'price' => $price,
            'discount_rate' => $disc_rate
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('menu_items');
    }
    
    public function copy_to_restaurant($item_id,$rest_id) {
        $this->db->select('*');
        $this->db->from('menu_items');
        $this->db->where('id',$item_id);
        $q = $this->db->get()->result();
        
        foreach ($q as $r) { // loop over results
            $r->restaurant_id = $rest_id;
            $r->id = null;
            $this->db->insert('menu_items', $r); 
        }  
         $new_item_id = $this->db->insert_id();
         $this->db->select('*');
         $this->db->from('addon_detail');
         $this->db->where('item_id',$item_id);
         $q = $this->db->get()->result();
          foreach ($q as $r) { // loop over results
            $r->item_id = $new_item_id;
            $r->id = null;
            $this->db->insert('addon_detail', $r); 
        } 
         
    }
    
    public function change_discount($id,$is_discount) {
        
        $array = array(
            'is_discount' => $is_discount
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('menu_items');
    }
    
    public function change_active($id,$active) {
        $array = array(
            'show_menu' => $active
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('menu_items');
    }
    
    public function upload_image ($id,$filename,$path) {
        $array = array(
        'image' => base_url().$path.'/'.$filename
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('menu_items');
    }
    

    
    public function get_restaurants_name () {
        $this->db->select('restaurant_name,id');
        $this->db->from('restaurants');
        $query = $this->db->get();
        return $query->result();
    }

       public function get_restaurant_name ($rest_id) {
        $this->db->select('restaurant_name');
        $this->db->from('restaurants');
        $this->db->where('id',$rest_id);
        $query = $this->db->get();
        return $query->row()->restaurant_name;
    }

    public function get_categories () {
        $this->db->select('*');
        $this->db->from('items_category');
        $query = $this->db->get();
        return $query->result();
    }



     public function search($search_text,$field_to_search,$rest_id) {
        $this->db->select('menu_items.id AS item_id,menu_items.restaurant_id,restaurant_name,item_name,menu_items.image,description,price,is_discount,discount_rate,show_menu');
        $this->db->from('menu_items');
        $this->db->join('restaurants', 'menu_items.restaurant_id = restaurants.id');
        $this->db->where('restaurant_id',$rest_id);
        $this->db->like($field_to_search, $search_text);
        $this->db->order_by('item_id');
        $query = $this->db->get();
        return $query->result(); 
    }
    
        
       public function total_items_by_search($search_text,$field_to_search) {
        $this->db->select('*');
        $this->db->from('menu_items');
        $this->db->join('restaurants', 'menu_items.restaurant_id = restaurants.id');
        $this->db->where('restaurant_id',$rest_id);
        $this->db->like($field_to_search, $search_text); 
        $query = $this->db->get();
        return count($query);
    }
    
}