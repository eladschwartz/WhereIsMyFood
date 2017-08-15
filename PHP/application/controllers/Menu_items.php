<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require_once 'Classes/PHPExcel.php';

class Menu_items extends MY_Controller {

    public $restaurant_id = 0;
    public $data = array();

    public function __construct() {
        parent::__construct('menu_items', 'Menu_items_model');
        is_user_auth();
    }

    public function index() {
      
    }

    public function init_data() {
        $restaurant_id = $this->restaurant_id = $_SESSION['restaurant_id'];
        $this->data['form_image_attributes'] = array('class' => 'upload-image-form');
        $this->data['error'] = "";
        $this->data['restaurants_name'] = $this->Menu_items_model->get_restaurants_name();
        $this->data['restaurant_name'] = $this->Menu_items_model->get_restaurant_name($restaurant_id);
        $this->data['categories'] = $this->Menu_items_model->get_categories();
        $this->data['image_func'] = 'menu_items/upload_image';
        $this->data['restaurant_id'] = $restaurant_id;
        $field_to_search = $this->input->post('search_field');
        $search_text = $this->input->post('search');
        $clear = $this->input->post('clear_btn');
        if ($clear) {
            $this->data['items'] = $this->Menu_items_model->get_menu_items($restaurant_id);
        }
        if ($field_to_search && !empty($search_text)) {
            $this->data['items'] = $this->Menu_items_model->search($search_text, $field_to_search, $restaurant_id);
        } else {
            $category_id = $this->input->post('category_btn');
            if ($category_id) {
                $this->data['items'] = $this->Menu_items_model->get_menu_items_by_category($restaurant_id, $category_id);
            } else {
                $this->data['items'] = $this->Menu_items_model->get_menu_items($restaurant_id);
            }
        }
        return $this->data;
    }

    public function new_item() {
        is_user_auth();
        $restaurant_id = $this->input->post('row-new-rest-id');
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('description', 'Description', 'trim|required');
        $this->form_validation->set_rules('price', 'Price', 'trim|required');
        $this->form_validation->set_rules('new-category', 'Category', 'required');
        if ($this->form_validation->run() == FALSE) {
            redirect('menu_items');
        } else {
            $name = $this->input->post('name');
            $desc = $this->input->post('description');
            $price = $this->input->post('price');
            $discount_rate = $this->input->post('discount');
            $category_id = $this->input->post('new-category');
            $this->Menu_items_model->new_item($name, $desc, $restaurant_id, $price, $discount_rate, $category_id);
            redirect('menu_items');
        }
    }

    public function update() {
        is_user_auth();
        $this->form_validation->set_rules('name', 'Name', 'trim|required');
        $this->form_validation->set_rules('description', 'description', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('menu_items');
        } else {
            $name = $this->input->post('name');
            $desc = $this->input->post('description');
            $price = $this->input->post('price');
            $discount_rate = $this->input->post('discount');
            $id = $this->input->post('row-id-edit');
            $this->Menu_items_model->update($id, $name, $desc, $price, $discount_rate);
            redirect('menu_items');
        }
    }

    public function copy_item() {
        is_user_auth();
        $this->form_validation->set_rules('restaurant_copy_select', 'ResturantList', 'trim|required');
        if ($this->form_validation->run() == FALSE) {
            redirect('menu_items');
        } else {
            $restaurant_id_to_copy = $this->input->post('restaurant_copy_select');
            $item_id = $this->input->post('row-id-copy');
            $this->Menu_items_model->copy_to_restaurant($item_id, $restaurant_id_to_copy);
            redirect('menu_items');
        }
    }

    public function delete($id) {
        is_user_auth();
        $this->db->where('id', $id);
        $this->db->delete('menu_items');
        redirect('menu_items');
    }

    public function save_item_id() {
        $item_id = $this->input->post('id');
        $_SESSION['item_id'] = $item_id;
    }

    public function discount_toggle() {
        is_user_auth();
        $active = $this->input->post('active');
        $id = $this->input->post('id');
        $this->Menu_items_model->change_discount($id, $active);
    }

    public function show_menu_toggle() {
        is_user_auth();
        $active = $this->input->post('active');
        $id = $this->input->post('id');
        $this->Menu_items_model->change_active($id, $active);
    }

    public function upload_image() {
        is_user_auth();
        $config['upload_path'] = 'img/menu_items';
        $config['allowed_types'] = 'gif|jpg|png|jpeg';
        $config['overwrite'] = true;
        $config['max_height'] = 1024;
        $config['max_width'] = 768;

        $this->load->library('upload');
        $this->upload->initialize($config);
        $id = $this->input->post('image_name_id');

        if (!$this->upload->do_upload('userfile')) {
            $error = array('error' => $this->upload->display_errors());
            $this->session->set_flashdata('error_msg', $error['error']);
            redirect('menu_items');
        } else {
            $this->data = array('upload_data' => $this->upload->data());
            $filename = $this->upload->data('file_name');
            $this->session->set_flashdata('success_msg', 'success_msg');
            $this->Menu_items_model->upload_image($id, $filename, $config['upload_path']);
            redirect('menu_items');
        }
    }
    
      public function upload_xls() {
        is_user_auth();
        $config['upload_path'] = 'excel';
        $config['allowed_types'] = 'xlsx|xls|csv';
        $config['overwrite'] = true;

        $this->load->library('upload');
        $this->upload->initialize($config);

        if (!$this->upload->do_upload('excelfile')) {
            $error = array('error' => $this->upload->display_errors());
            $this->session->set_flashdata('error_msg', $error['error']);
            redirect('menu_items');
        } else {
            $this->data = array('upload_data' => $this->upload->data());
            $full_path = $this->upload->data('full_path');
            $this->import_excel($full_path);
            redirect('menu_items');
        }
    }
    
    public function import_excel($inputFileName) {
        $objPHPExcel = PHPExcel_IOFactory::load($inputFileName);
        $sheetData = $objPHPExcel->getActiveSheet()->toArray(null, true, true, true);
        foreach ($sheetData as $data) {
            $item_name =  $data['A'];
            $item_desc =  $data['B'];
            $item_price =  $data['C'];
            $category_id =  $data['D'];
             if (isset($item_name)) {
             $this->Menu_items_model->new_item($item_name, $item_desc, $this->restaurant_id, $item_price, null, $category_id);
            }
        }
          $this->session->set_flashdata('success_msg', 'test');
    }
}
