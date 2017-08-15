<?php
class Restaurant_model extends CI_Model {
   
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    
    public function get_restaurants($limit=null, $offset=NULL) {
        $this->db->order_by('restaurant_name');
        $this->db->limit($limit, $offset);
        $query  = $this->db->get('restaurants');
        return $query->result();
    }

    public function total_restaurants() {
        return $this->db->count_all_results('restaurants');
    }
    
    public function delete($id) {
        $this->db->where('id', $id);
        $this->db->delete('restaurants');
    }
    
    public function update($name,$address,$id,$phone_number) {
        $array = array(
                        'restaurant_name' => $name,
                        'restaurant_address' => $address,
                        'phone_number' => $phone_number
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('restaurants');
    }

     public function change_active($id,$active) {
            
        $array = array(
                        'active' => $active
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('restaurants');
    }

    public function upload_image ($id,$filename,$path) {
          $array = array(
                        'image' => base_url().$path.'/'.$filename
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('restaurants');
    }

    public function new_restaurant($name,$address,$phone_number) {
             $data = array(
                'restaurant_name' => $name,
                'restaurant_address' => $address,
                'phone_number' => $phone_number
            );
            $this->db->insert('restaurants', $data);
    }

  public function search($search_text,$field_to_search) {
            $query = $this->db->like($field_to_search, $search_text)->order_by('restaurant_name')->get('restaurants');
            return $query->result();
    }

}