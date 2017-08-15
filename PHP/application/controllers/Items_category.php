<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Items_category extends MY_Controller {
    
   
    public function __construct()
    {
        parent::__construct('items_category','Items_category_model');
        is_user_auth();
    }
    
    public function index() {
     
    }
    
    public function new_category() {
        is_user_auth();
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        if ($this->form_validation->run() == FALSE)
        {
            redirect('items_category');
        }
        else {
            $name = $this->input->post('name');
            $this->Items_category_model->new_category($name);
            redirect('items_category');
        }
    }
    

    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('items_category');
        redirect('items_category');
    }
    
 
    public function upload_image() {
        is_user_auth();
        $config['upload_path']          = 'img/items_category';
        $config['allowed_types']        = 'gif|jpg|png|jpeg';
        $config['overwrite']            = true;
        $config['max_height']          = 1024;
        $config['max_width']            = 768;
        
        $this->load->library('upload');
        $this->upload->initialize($config);
        $id = $this->input->post('image_name_id');
        
        if (!$this->upload->do_upload('userfile'))
        {
            $error = array('error' => $this->upload->display_errors());
            $this->session->set_flashdata( 'error_msg', $error['error']);
            redirect('items_category');
        }
        else
        {
            $this->upload->data();
            $filename = $this->upload->data('file_name');
            $this->session->set_flashdata( 'success_msg', 'success_msg' );
            $this->Items_category_model->upload_image($id, $filename,$config['upload_path']);
            redirect('items_category');
        }
    }
    
    public function init_data()
    {
        $search_field = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        if ($search_field  && !empty($search_text )) {
            $data['categories'] = $this->Items_category_model->search($search_text,$search_field);
        } else {
            $data['categories'] = $this->Items_category_model->get_categories();
        }
        
        $data['form_image_attributes'] = array('class' => 'upload-image-form');
        $data['error'] = "";
        $data['image_func'] = 'items_category/upload_image/';
        return $data;
    }
}