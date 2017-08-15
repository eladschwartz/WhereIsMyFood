<?php
class Addon_detail_model extends CI_Model {
    
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    public function get_details($item_id){
        $this->db->select('ad.id AS id, ad.item_id, ad.price, a.addon_name, as.section_name, a.section_id');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->where('item_id',$item_id);
        $this->db->order_by('section_name','addon_name');
        $query = $this->db->get();
        return $query->result();
    }


public function get_details_by_section($item_id,$section_name){
        $this->db->select('ad.id AS id, ad.item_id, ad.price, a.addon_name, as.section_name, a.section_id');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->where('item_id',$item_id);
         $this->db->where('section_name',$section_name);
        $this->db->order_by('section_name','addon_name');
        $query = $this->db->get();
         if($query->num_rows() != 0)
        {
            $addons_output = "";
            $results = $query->result();
            foreach($results as $result) {
                $addon_name = $result->addon_name;
                $price = $result->price;
                $array[] = $addon_name.' - '.$price;
                if (isset($price)) {
                     $addons_output = $addons_output.$addon_name.' - Price: '.$price.'<i detail-id="'.$result->id.'" style="color:red;cursor:pointer;" class="fa fa-fw fa-remove delete-btn-table"></i>'."\n";
                } else {
                     $addons_output = $addons_output.$addon_name.'<i detail-id="'.$result->id.'" style="color:red;cursor:pointer;" class="fa fa-fw fa-remove delete-btn-table"></i>'."\n";
                }
            } 
            echo nl2br($addons_output);

        }
    }

    public function get_sections(){
        $this->db->select('*');
        $this->db->from('addons_section');
        $this->db->order_by('section_name');
        $query = $this->db->get();
        return $query->result();
    }

    public function count_section($item_id){
        $this->db->select('section_name');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->group_by('section_name');
        $this->db->where('item_id', $item_id);
        $query = $this->db->get();
        return $query->result();
    }

    
    public function update($addon_id,$price,$id) {
        $array = array(
                    'addon_id' => $addon_id,
                    'price' => $price
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('addon_detail');
    }
    

    public function new_detail($addon_id,$price,$item_id) {
         $data = array(
            'addon_id' => $addon_id,
            'item_id'=> $item_id
        );

          if (!empty($price)) {
               $data['price'] = $price;
            }
        $this->db->insert('addon_detail', $data);
    }

    public function get_item_name($item_id) {
        $this->db->select('addon_name');
        $this->db->from('menu_items');
        $this->db->where('id', $item_id);
        $query = $this->db->get();
        return json_encode($query->result());
    }

    public function get_addons() {
        $this->db->select('*');
        $this->db->from('addons');
        $query = $this->db->get();
        return $query->result();
    }


     public function search($search_text,$field_to_search,$item_id) {
        $this->db->select('ad.id AS id, ad.item_id, ad.price, a.addon_name, as.section_name, a.section_id');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->where('item_id',$item_id);
        $this->db->like($field_to_search, $search_text);
        $this->db->order_by('section_name','addon_name');
        $query = $this->db->get();
        return $query->result(); 
    }
}