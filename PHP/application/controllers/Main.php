<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Main extends MY_Controller {

    public function __construct() {
        parent::__construct('main', 'Main_model');
        is_user_auth();
    }

    public function index() {
        
    }

    public function init_data() {
        $this->data['new_orders_count'] = $this->Main_model->count_open_orders();
        $this->data['total_orders'] = $this->Main_model->count_total_orders();
        $this->data['sales_sum'] = $this->Main_model->total_sales_sum();
        $this->data["currency"] = $this->Main_model->get_currency();
        $this->data['error'] = "";
        return $this->data;
    }

}
