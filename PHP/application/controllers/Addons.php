<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Addons extends MY_Controller {
    
    public function __construct()
    {
        parent::__construct('addons','Addons_model');
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('section-name-select', 'Section Name', 'required');
        is_user_auth();
    }
    
    public function index() {
        
    }
    
     public function init_data()
    {
        //Filter data by search params
        $search_field = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        if ($search_field  && !empty($search_text )) {
            $data['addons'] = $this->Addons_model->search($search_text,$search_field );
        } else {
            $data['addons'] = $this->Addons_model->get_addons();
        }
        $data['sections'] = $this->Addons_model->get_sections();
        $data['error'] = "";
        return $data;
    }
    
    //Add new addon
    public function new_addon() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE)
        {
            redirect('addons');
        }
        else {
            $name = $this->input->post('name');
            $type = $this->input->post('section-name-select');
            $required = $this->input->post('required');
            $this->Addons_model->new_addon($name,$type,$required);
            redirect('addons');
        }
    }
    
    //Update addon
    public function update() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE)
        {
            redirect('addons');
        }
        else {
            $name = $this->input->post('name');
            $type = $this->input->post('type');
            $id = $this->input->post('row-id-edit');
            $this->Addons_model->update($name,$type,$id);
            redirect('addons');
        }
    }

    //Delete Addon
    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('addons');
        redirect('addons');
    } 
}