<?php
class  Items_category_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
   public function get_categories () {
        $this->db->select('*');
        $this->db->from('items_category');
        $query = $this->db->get();
        return $query->result();
    }
        public function new_category($name) {
        $data = array(
            'category_name' => $name,
        );
        $this->db->insert('items_category', $data);
    }
    
    
    public function upload_image ($id,$filename,$path) {
        $array = array(
            'image' => base_url().$path.'/'.$filename
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('items_category');
    }


     public function search($search_text,$field_to_search) {
        $this->db->select('*');
        $this->db->from('items_category');
        $this->db->like($field_to_search, $search_text);
        $this->db->order_by('id');
        $query = $this->db->get();
        return $query->result(); 
    }
}