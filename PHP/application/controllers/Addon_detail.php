<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Addon_detail extends MY_Controller {

    public $item_id = 0;

    public function __construct() {
        parent::__construct('addon_detail', 'Addon_detail_model');
        $this->form_validation->set_rules('price', 'Price', 'trim');
    }

    public function index() {
        
    }

    public function init_data() {
        $item_id = $this->item_id = $_SESSION['item_id'];
        $data['item_id'] = $item_id;
        //If user searched then show them filtered data
        $search_text = $this->input->post('search');
        $search_field = $this->input->post('search_field');
        if ($search_field && !empty($search_text)) {
            $data['details'] = $this->Addon_detail_model->search($search_text, $search_field, $item_id);
        } else {
            $data['details'] = $this->Addon_detail_model->get_details($item_id);
        }
        $data['addons'] = $this->Addon_detail_model->get_addons();
        $data['sections'] = $this->Addon_detail_model->count_section($item_id);
        $data['error'] = "";
        return $data;
    }

    //Add new detail to item
    public function new_detail() {
        is_user_auth();
        $item_id = $this->input->post('item_id');
        $this->form_validation->set_rules('addon-name-select', 'Addon Name', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('addon_detail/' . $item_id);
        } else {
            $addon_id = $this->input->post('addon-name-select');
            $price = $this->input->post('price');
            $this->Addon_detail_model->new_detail($addon_id, $price, $item_id);
            redirect('addon_detail/' . $item_id);
        }
    }

    //Delete detail
    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('addon_detail');
        redirect('addon_detail/' . $this->item_id);
    }
}
