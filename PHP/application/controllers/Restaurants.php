<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Restaurants extends MY_Controller {

    public $data = array();

    public function __construct() {
        parent::__construct('restaurants', 'Restaurant_model');
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('address', 'Address', 'trim|required');
        $this->form_validation->set_rules('phone', 'Phone Number', 'trim|required');
    }

    public function index() {
        
    }

    public function init_data() {
        $this->data['form_image_attributes'] = array('class' => 'upload-image-form');
        $this->data['error'] = "";
        $this->data['image_func'] = 'restaurants/upload_image';
        $this->data['new_title'] = "New Restaurant";
        $this->config_pagination();
        return $this->data;
    }

    public function save_restaurant_id() {
        $restaurant_id = $this->input->post('id');
        $_SESSION['restaurant_id'] = $restaurant_id;
    }

    public function new_restaurant() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE) {
            redirect('restaurants');
        } else {
            $name = $this->input->post('name');
            $address = $this->input->post('address');
            $phone_number = $this->input->post('phone');
            $this->Restaurant_model->new_restaurant($name, $address, $phone_number);
            redirect('restaurants');
        }
    }

    public function update_restaurant() {
        is_user_auth();
        if ($this->form_validation->run() == FALSE) {
            redirect('restaurants');
        } else {
            $name = $this->input->post('name');
            $address = $this->input->post('address');
            $phone_number = $this->input->post('phone');
            $id = $this->input->post('row-id-edit');
            $this->Restaurant_model->update($name, $address, $id, $phone_number);
            redirect('restaurants');
        }
    }

    public function delete($id) {
        is_user_auth();
        $this->Restaurant_model->delete($id);
        redirect('restaurants');
    }

    public function change_active() {
        is_user_auth();
        $active = $this->input->post('active');
        $id = $this->input->post('id');
        $this->Restaurant_model->change_active($id, $active);
    }

    public function upload_image() {
        is_user_auth();
        $config['upload_path'] = 'img/restaurants';
        $config['allowed_types'] = 'gif|jpg|png|jpeg';
        $config['overwrite'] = true;
        $config[' max_height'] = 1024;
        $config['max_width'] = 768;

        $this->load->library('upload');
        $this->upload->initialize($config);
        $id = $this->input->post('image_name_id');


        if (!$this->upload->do_upload('userfile')) {
            $error = array('error' => $this->upload->display_errors());
            $this->session->set_flashdata('error_msg', $error['error']);
            redirect('restaurants');
        } else {
            $this->data = array('upload_data' => $this->upload->data());
            $filename = $this->upload->data('file_name');
            $this->session->set_flashdata('success_msg', 'success_msg');
            $this->Restaurant_model->upload_image($id, $filename, $config['upload_path']);
            redirect('restaurants');
        }
    }

    public function config_pagination() {
        $uri_segment = $this->uri->segment(3);
        $per_page = 5;
        $search_field = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        if ($search_field && !empty($search_text)) {
            $this->data['restaurants'] = $this->Restaurant_model->search($search_text, $search_field);
        } else {
            $this->data['restaurants'] = $this->Restaurant_model->get_restaurants($per_page, $uri_segment);
        }
        $config = array();
        $config["base_url"] = base_url() . "restaurants/config_pagination";
        $config["total_rows"] = $this->Restaurant_model->total_restaurants();
        $config["uri_segment"] = 3;
        $config["per_page"] = $per_page;
        $config['full_tag_open'] = '<div class="pagination pull-right">';
        $config['full_tag_close'] = '</div>';
        $config['first_link'] = '« First';
        $config['last_link'] = 'Last »';
        $config['last_tag_open'] = '<li class="last page">';
        $config['last_tag_close'] = '</li>';
        $config['next_link'] = 'Next →';
        $config['next_tag_open'] = '<li class="next page">';
        $config['next_tag_close'] = '</li>';
        $config['prev_link'] = '← Previous';
        $config['prev_tag_open'] = '<li class="prev page">';
        $config['prev_tag_close'] = '</li>';
        $config['cur_tag_open'] = '<li class="active"><a href="">';
        $config['cur_tag_close'] = '</a></li>';
        $config['num_tag_open'] = '<li class="page">';
        $config['num_tag_close'] = '</li>';
        $this->pagination->initialize($config);
    }

}
