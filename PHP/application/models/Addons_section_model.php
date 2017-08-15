<?php
class Addons_section_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    
    public function get_extras()
    {
        $query = $this->db->get('addons_section');
        return $query->result();
    }
    
    public function change_required($id,$requried) {
        $array = array(
        'is_required' => $requried
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('addons_section');
    }
    
    
    public function update($name,$type,$id) {
        $array = array(
            'section_name' => $name,
            'section_type' => $type
        );
        $this->db->where('id', $id);
        $this->db->update('addons_section',$array);
    }
    
    public function delete($id) {
        $this->db->where('id', $id);
        $this->db->delete('addons_section');
    }
    
    public function new_addon_section($name, $section_type_id, $required) {
        $data = array(
          'section_name' => $name,
          'section_type_id' => $section_type_id,
          'is_required' => $required
        );
        $this->db->insert('addons_section', $data);
    }
    
    public function search($search_text,$field_to_search) {
        $query = $this->db->like($field_to_search, $search_text)->order_by('section_name')->get('addons_section');
        return $query->result();
    }

    public function get_section_type($id) {
         $this->db->select('type_name');
        $this->db->from('addons_section_type');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->type_name;
        }

    }
    
}