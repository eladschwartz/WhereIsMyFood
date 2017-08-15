<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Addons_section extends MY_Controller {
    
    public function __construct()
    {
        parent::__construct('addons_section','Addons_section_model');
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('type', 'Type', 'required');
        is_user_auth();
    }
    
    public function index() {
        
    }
    
    public function new_addon_section() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE)
        {
            redirect('addons_section');
        }
        else {
            $name = $this->input->post('name');
            $type = $this->input->post('type');
            $required = $this->input->post('required');
            $this->Addons_section_model->new_addon_section($name,$type,$required);
            redirect('addons_section');
        }
    }
    
    //Update  a section
    public function update() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE)
        {
            redirect('addons_section');
        }
        else {
            $name = $this->input->post('name');
            $type = $this->input->post('type');
            $id = $this->input->post('row-id-edit');
            $this->Addons_section_model->update($name,$type,$id);
            redirect('addons_section');
        }
    }

    //
    public function change_required() {
        is_user_auth();
        $active =  $this->input->post('active');
        $id = $this->input->post('id');
        $this->Addons_section_model->change_required($id,$active);
    }
    
    
    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('addons_section');
        redirect('addons_section');
    }
    
    
    public function init_data()
    {
        $search_field = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        if ($search_field && !empty($search_text)) {
            $data['sections'] = $this->Addons_section_model->search($search_text,$search_field);
        } else {
            $data['sections'] = $this->Addons_section_model->get_extras();
        }
        $data['error'] = "";
        return $data;
    }
}