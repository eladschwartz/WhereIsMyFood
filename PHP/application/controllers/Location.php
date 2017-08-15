<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Location extends MY_Controller {

    public function __construct() {
        parent::__construct('location', 'Location_model');
        //is_user_admin();
        is_user_auth();
    }

    public function index() {
        
    }

    public function init_data() {
        $this->load->library('googlemaps');
        $config['center'] = '1600 Amphitheatre Parkway in Mountain View, Santa Clara County, California';
        $config['zoom'] = "auto";
        $this->googlemaps->initialize($config);
        //get location for all drivers
        $coords = $this->Location_model->get_coordinates_drivers();
        foreach ($coords as $coordinate) {
            $marker = array();
            $marker['position'] = $coordinate->latitude . ',' . $coordinate->longitude;
            $marker['infowindow_content'] = $coordinate->driver_name;
            $marker['icon'] = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=D|0e98ff|000000';
            $this->googlemaps->add_marker($marker);
        }
        //Get location for all customer
        $coords_customers = $this->Location_model->get_coordinates_customers();
        foreach ($coords_customers as $coordinate) {
            $marker = array();
            $marker['position'] = $coordinate->address;
            $marker['infowindow_content'] = $coordinate->customer_name;
            $marker['icon'] = 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=C|00ff00|000000';
            $this->googlemaps->add_marker($marker);
        }
        $data['map'] = $this->googlemaps->create_map();

        $data['error'] = "";
        return $data;
    }

}
