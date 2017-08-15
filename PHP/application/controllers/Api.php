<?php

require_once('../vendor/autoload.php');

class Api extends CI_Controller {

    private $token = "";

    public function __construct() {
        parent::__construct();
        $this->load->database();
        $this->load->helper('auth_helper');
        $headers = $this->input->request_headers();
        if (isset($headers['Authorization'])) {
            $auth_header = preg_replace('/Bearer/', "", $headers['Authorization']);
            $this->token = preg_replace('/\s+/', '', $auth_header);
        }
    }

    //---------Restaurant------------
    public function get_restaurants() {
        is_customer_auth($this->token);
        $this->db->where('active', 1);
        $query = $this->db->get('restaurants');
        echo (json_encode($query->result()));
    }

    public function get_restaurant() {
        is_customer_auth($this->token);
        $this->db->where('active', 1);
        $this->db->limit(1);
        $query = $this->db->get('restaurants');
        echo (json_encode($query->result()));
    }

    public function get_currency() {
        $this->db->select('symbol');
        $this->db->from('settings s');
        $this->db->join('currencies c', 'c.id = s.currency_id');
        $currency = $this->db->get()->row()->symbol;
        echo (json_encode($currency));
    }

    //---------END - Restaurant------------
    //
    //---------Menu Items------------
    public function get_menu_items() {
        is_customer_auth($this->token);
        $restaurant_id = $this->input->get('restaurant_id');
        $category_id = $this->input->get('category_id');
        $this->db->select('*');
        $this->db->from('menu_items');
        $where = array(
            'restaurant_id' => $restaurant_id,
            'category_id' => $category_id
        );
        $this->db->where($where);
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    public function get_menu_items_categories() {
        is_customer_auth($this->token);
        $this->db->select('*');
        $this->db->from('items_category');
        $this->db->order_by('id');
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    public function get_addons_by_item() {
        is_customer_auth($this->token);
        $item_id = $this->input->get('id');
        $this->db->select('ad.id AS addon_detail_id, ad.item_id, ad.price, a.addon_name, as.section_name,a.id AS addon_id, a.section_id,ast.type_name,as.is_required');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->join('addons_section_type ast', 'as.section_type_id = ast.id');
        $this->db->where('item_id', $item_id);
        $this->db->order_by('section_name', 'addon_name');
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    public function get_sections_by_item() {
        is_customer_auth($this->token);
        $item_id = $this->input->get('id');
        $this->db->select('section_name,section_id,is_required,type_name');
        $this->db->distinct();
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'ad.addon_id = a.id');
        $this->db->join('addons_section as', 'a.section_id = as.id');
        $this->db->join('addons_section_type ast', 'as.section_type_id = ast.id');
        $this->db->where('item_id', $item_id);
        $this->db->order_by('section_name', 'addon_name');
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    public function get_section_by_id() {
        is_customer_auth($this->token);
        $section_id = $this->input->get('id');
        $this->db->select('as.id AS section_id, as.section_name, as.is_required, as.is_required, ast.type_name');
        $this->db->from('addons_section as');
        $this->db->from('addons_section_type ast');
        $this->db->where('as.id', $section_id);
        $this->db->limit(1);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    //---------END - menu_items------------
    //
    //---------Orders------------
    public function get_last_order() {
        is_customer_auth($this->token);
        $customer_id = $this->input->get('customer_id');
        $this->db->select('orders.id');
        $this->db->from('orders');
        $this->db->join('order_status', 'orders.status_id = order_status.id');
        $this->db->order_by('orders.created_at', 'DESC');
        $this->db->where('orders.customer_id', $customer_id);
        $this->db->where('orders.status_id !=', 4);
        $this->db->limit(1);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            $order_id = $query->row()->id;
            $this->get_order_details($order_id);
        }
    }

    public function get_order_details($order_id) {
        is_customer_auth($this->token);
        //get status and check if its not status 4(Delivered) if not then continue
        $this->db->select('orders.id, address,status_id, status_name, restaurant_address');
        $this->db->from('orders');
        $this->db->join('order_status', 'orders.status_id = order_status.id');
        $this->db->join('restaurants', 'orders.restaurant_id = restaurants.id');
        $this->db->where('orders.id', $order_id);
        $this->db->limit(1);
        $result = $this->db->get()->row();
        $status_name = $result->status_name;
        $order_address = $result->address;
        $restaurant_address = $result->restaurant_address;
        if ($result->status_id != '4') {
            $this->db->select('*');
            $this->db->from('order_details');
            $this->db->join('menu_items', 'order_details.item_id = menu_items.id');
            $this->db->where('order_details.order_id', $order_id);
            $this->db->limit(1);
            $query = $this->db->get();
            $data = array(
                "details" => $query->result(),
                "status_name" => $status_name,
                "order_address" => $order_address,
                "restaurant_address" => $restaurant_address
            );
            echo (json_encode($data));
        }
    }

    public function if_order_exist() {
        is_customer_auth($this->token);
        $customer_id = $this->input->get('customer_id');
        $this->db->select('*');
        $this->db->from('orders');
        $this->db->join('order_status', 'orders.status_id = order_status.id');
        $this->db->order_by('orders.created_at', 'DESC');
        $this->db->where('orders.customer_id', $customer_id);
        $this->db->where('orders.status_id !=', 4);
        $this->db->limit(1);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    public function is_active_order() {
        is_customer_auth($this->token);
        $order_id = $this->input->get('order_id');
        $this->db->select('drivers.active_order');
        $this->db->from('orders');
        $this->db->join('drivers', 'orders.driver_id = drivers.id');
        $this->db->where('drivers.active_order', $order_id);
        $this->db->limit(1);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    //---------End - Orders------------

    public function get_driver_location() {
        is_customer_auth($this->token);
        $order_id = $this->input->get('order_id');
        $this->db->select('latitude, longitude');
        $this->db->from('orders');
        $this->db->join('drivers', 'orders.driver_id = drivers.id');
        $this->db->where('orders.id', $order_id);
        $this->db->where('drivers.active_order', $order_id);
        $this->db->limit(1);
        $query = $this->db->get();
        echo (json_encode($query->result()));
    }

    //---------Users------------

    public function upload_user_image() {
        is_customer_auth($this->token);
        $config['upload_path'] = './images/restaurants';
        $config['allowed_types'] = 'gif|jpg|png|jpeg';
        $config['overwrite'] = true;
        $config[' max_height'] = 1024;
        $config['max_width'] = 768;

        $this->load->library('upload');
        $this->upload->initialize($config);
        $id = $this->input->post('image_name_id');


        if (!$this->upload->do_upload('userfile')) {
            $error = array('error' => $this->upload->display_errors());
            $this->session->set_flashdata('error_msg', json_encode($error));
            redirect('restaurants');
        } else {
            $this->upload->data();
            $filename = $this->upload->data('file_name');
            $this->session->set_flashdata('success_msg', 'success_msg');
            $this->Restaurant_model->upload_image($id, $filename);
            redirect('restaurants');
        }
    }

    public function save_user() {
        $customer_name = $this->input->post('customer_name');
        $email = $this->input->post('email');
        $uid = $this->input->post('uid');
        $address = $this->input->post('address');
        $floor = $this->input->post('floor');
        $apartnum = $this->input->post('apartnum');
        $country = $this->input->post('country');
        $city = $this->input->post('city');
        $state = $this->input->post('state');
        $zip_code = $this->input->post('zip_code');
        $phone = $this->input->post('phone');
        $ip = $this->input->ip_address();
        //Create token
        $this->load->helper('jwt');
        $key = password_hash(bin2hex(openssl_random_pseudo_bytes(16)), PASSWORD_DEFAULT);
        $token = array("customer_name" => $customer_name);
        $jwt = jwt::encode($token, $key);

        $data = array(
            'customer_name' => $customer_name,
            'email' => $email,
            'uid' => $uid,
            'address' => $address,
            'floor' => $floor,
            'apartnum' => $apartnum,
            'country' => $country,
            'city' => $city,
            'state' => $state,
            'zip_code' => $zip_code,
            'phone' => $phone,
            'ip_address' => $ip,
            'token' => $jwt
        );
        $this->db->insert('customers', $data);
        $user_id = $this->db->insert_id();
        $array = array('user_id' => $user_id, 'token' => $jwt);
        echo json_encode($array);
    }
    
    
      public function update_user() {
        $customer_name = $this->input->post('customer_name');
        $customer_id = $this->input->post('customer_id');
        $email = $this->input->post('email');
        $address = $this->input->post('address');
        $floor = $this->input->post('floor');
        $apartnum = $this->input->post('apartnum');
        $country = $this->input->post('country');
        $city = $this->input->post('city');
        $state = $this->input->post('state');
        $zip_code = $this->input->post('zip_code');
        $phone = $this->input->post('phone');
       
        
        $data = array(
            'customer_name' => $customer_name,
            'email' => $email,
            'address' => $address,
            'floor' => $floor,
            'apartnum' => $apartnum,
            'country' => $country,
            'city' => $city,
            'state' => $state,
            'zip_code' => $zip_code,
            'phone' => $phone,
        );
        $this->db->set($data);
        $this->db->where('id', $customer_id);
        $this->db->update('customers');
        $array = array('user_id' => $customer_id);
        echo json_encode($array);
    }

    public function get_customer_uid() {
        $phone = $this->input->get('phone');
        $this->db->select('uid');
        $this->db->from('customers');
        $this->db->where('phone', $phone);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    public function get_customer_details() {
        $phone = $this->input->get('phone');
        $this->db->select('id, phone, address, floor, apartnum, customer_name, email, country, city, state, zip_code, uid, token');
        $this->db->from('customers');
        $this->db->where('phone', $phone);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    public function get_customer_token() {
        $customer_id = $this->input->get('customer_id');
        $this->db->select('token');
        $this->db->from('customers');
        $this->db->where('id', $customer_id);
        $query = $this->db->get();
        if ($query->num_rows() != 0) {
            echo (json_encode($query->result()));
        }
    }

    public function delete_stripe_cards() {
        is_customer_auth($this->token);
        $customer_id = $this->input->post('customer_id');
        $uid = $this->input->post('uid');
        $this->db->where('customer_id', $customer_id);
        $this->db->delete('stripe_customers');
        //update the old uid to the new one
        $this->db->set('uid', $uid);
        $this->db->where('id', $customer_id);
        $this->db->update('customers');
    }

    public function save_new_address() {
        is_customer_auth($this->token);
        $customer_id = $this->input->post('customer_id');
        $address = $this->input->post('address');
        $floor = $this->input->post('floor');
        $apartnum = $this->input->post('apartnum');
        $this->db->where('id', $customer_id);
        $this->db->set('address', $address);
        $this->db->set('floor', $floor);
        $this->db->set('apartnum', $apartnum);
        $this->db->update('customers');
    }

    //---------End - Users------------
}
