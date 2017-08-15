<?php
class Addons_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    
    public function get_addons()
    {
        $this->db->select('*');
        $this->db->from('addons');
        $this->db->order_by('section_id');
        $query = $this->db->get();
        return $query->result();
    }
    
  
    public function update($addon_name,$section_id,$id) {
        $array = array(
            'addon_name' => $addon_name,
            'section_id' => $section_id
        );
        $this->db->where('id', $id);
        $this->db->update('addons',$array);
    }
    
    public function delete($id) {
        $this->db->where('id', $id);
        $this->db->delete('addons');
    }
    
    public function new_addon($addon_name, $section_id) {
        
        $data = array(
            'addon_name' => $addon_name,
            'section_id' => $section_id
          
        );
        $this->db->insert('addons', $data);
    }
    
    public function search($search_text,$field_to_search) {
        $query = $this->db->like($field_to_search, $search_text)->order_by('addon_name')->get('addons');
        return $query->result();
    }

    public function get_section_name($id) {
        $this->db->select('section_name');
        $this->db->from('addons_section');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->section_name;
        }
    }

      public function get_sections() {
        $this->db->select('*');
        $this->db->from('addons_section');
        $query = $this->db->get();
        return $query->result();
    }
    
}