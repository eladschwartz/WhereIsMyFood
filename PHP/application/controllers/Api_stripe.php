<?php

require_once('../vendor/autoload.php');

class Api_stripe extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->database();
    }

    public function is_stripe_customer() {
        $customer_id = $this->input->post('customer_id');
        $this->db->select('last4, card');
        $this->db->from('stripe_customers');
        $where = array(
            'customer_id' => $customer_id
        );
        $this->db->order_by('created_at', 'DESC');
        $this->db->limit(1);
        $this->db->where($where);
        $query = $this->db->get();
        if ($query->num_rows() == 1) {
            echo (json_encode($query->result()));
        }
    }
    
    public function get_credit_cards() {
        $customer_id = $this->input->post('customer_id');
        $this->db->select('id,card, last4');
        $this->db->from('stripe_customers');
        $where = array(
            'customer_id' => $customer_id
        );
        $this->db->where($where);
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            echo (json_encode($query->result()));
        }
    }
    
    public  function delete_credit_card() {
        $card_id = $this->input->post('card_id');
        $this->db->where('id', $card_id);
        $this->db->delete('stripe_customers');
 
    }

    public function create_order() {
        $token = $this->input->post('stripe_token');
        $total = $this->input->post('total');
        $email = $this->input->post('email');
        $is_new_card = $this->input->post('is_new_card');
        $customer_id = $this->input->post('customer_id');
        $customer_name = $this->input->post('customer_name');
        $last_4_digits = $this->input->post('last_4_digits');
        $customer_stripe_id = "";
        //Get system currency
        $this->db->select('code');
        $this->db->from('settings s');
        $this->db->join('currencies c', 'c.id = s.currency_id');
        $currency = $this->db->get()->row()->code;
        $stripe = array(
            "secret_key" => "sk_test_fxPyQSN3FgonSvRFjWk19gT8",
            "publishable_key" => "pk_test_YXp2FSaGgBEWyj5ih1os26zf"
        );

        try {
            \Stripe\Stripe::setApiKey($stripe['secret_key']);
            //check if customer paid before and if yes, get his customer stripe id and use it to charge
            //else - create new customer and charge it then save it to DB
            $this->db->select('cust_stripe_id');
            $this->db->from('stripe_customers');
            $where = ['customer_id' => $customer_id,'last4' => $last_4_digits];
            $this->db->where($where);
            $query = $this->db->get();
            if ($query->num_rows() == 1 && $is_new_card == 0) {
                $customer_stripe_id = $query->row()->cust_stripe_id;
                $customer = \Stripe\Customer::retrieve($customer_stripe_id);
                
                $charge = \Stripe\Charge::create(array(
                            'customer' => $customer->id,
                            'amount' => $total * 100,
                            'currency' => $currency
                ));
               
            } else {
                $customer = \Stripe\Customer::create(array(
                            'email' => $email,
                            'source' => $token
                ));

                $charge = \Stripe\Charge::create(array(
                            'customer' => $customer->id,
                            'amount' => $total * 100,
                            'currency' => $currency
                ));
                $customer_stripe_id = $customer->id;

                // save customer id to use for future payments
                $customer_data = array(
                    'customer_id' => $customer_id,
                    'cust_stripe_id' => $customer_stripe_id,
                    'email' => $email,
                    'customer_name' => $customer_name,
                    'card' => $charge['source']['brand'],
                    'last4' => $charge['source']['last4']
                );
                $this->db->insert('stripe_customers', $customer_data);
            }

            if ($charge->paid) {
                $address = $this->input->post('address');
                $address_floor = $this->input->post('address_floor');
                $address_aprt = $this->input->post('address_aprt');
                $total = $this->input->post('total');
                $restaurant_id = $this->input->post('restaurant_id');
                $restaurant_notes = $this->input->post('restaurant_notes');
                $order_details = json_decode($this->input->post('order_details'));
                //Inset Order data to Orders table
                $data_order = array(
                    'address' => $address,
                    'address_floor' => $address_floor,
                    'address_aprt' => $address_aprt,
                    'total' => $total,
                    'status_id' => 1,
                    'customer_id' => $customer_id,
                    'restaurant_id' => $restaurant_id,
                    'restaurant_notes' => $restaurant_notes,
                );
                $this->db->insert('orders', $data_order);
                $order_id = $this->db->insert_id();
                $data = array("order_id" => $order_id, "charge" => $charge);
                echo json_encode($data);
                //Inset Order Details to Order Details table
                $items_total = 0;
                $addons_total = 0;
                $order_detail_total = 0;
                foreach ($order_details as $detail) {
                    $order_detail = array(
                        'order_id' => $order_id,
                        'item_id' => $detail->item_id,
                        'sub_total' => $detail->item_price * $detail->quantity,
                        'quantity' => $detail->quantity,
                    );
                    $items_total += $detail->item_price * $detail->quantity;
                    $this->db->insert('order_details', $order_detail);
                    $order_detail_id = $this->db->insert_id();
                    $addons = $detail->addons;
                    foreach ($addons as $addon) {
                        $item_id_addon = $addon->item_id;
                        $item_id = $detail->item_id;
                        if ($item_id_addon == $item_id) {
                            $addonarr = array(
                                'order_detail_id' => $order_detail_id,
                                'addon_detail_id' => $addon->addon_detail_id
                            );
                            $addons_total += $addon->price;
                            $this->db->insert('order_item_addons', $addonarr);
                        }
                    }
                }

                $order_detail_total = $items_total + $addons_total;
                $this->db->set('sub_total', $order_detail_total);
                $this->db->update('order_details');
            }
        } catch (\Stripe\Error\Card $e) {
            $body = $e->getJsonBody();
            $err = $body['error'];
            echo json_encode($err);
        }
    }

}
