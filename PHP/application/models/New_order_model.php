<?php
class New_order_model extends CI_Model {
    
    public function __construct()
    {
        parent::__construct();
        $this->load->database();
    }
    
    public function get_orders(){
        $this->db->select('o.id AS order_id,o.address,o.address_aprt,o.status_id,o.total,o.driver_id,
        o.address_floor,o.restaurant_notes,o.delivery_notes,c.customer_name,r.restaurant_name');
        $this->db->from('orders o');
        $this->db->join('customers c', 'o.customer_id=c.id');
        $this->db->join('restaurants r', 'o.restaurant_id=r.id');
        //If branch manager, show only orders link to the user's restaurant. otherwise(Admin) show all orders
        if (isset($_SESSION['role']) && $_SESSION['role'] == 2) {
             $restaurant_id = $_SESSION['restaurant_id'];
             $this->db->where('restaurant_id',$restaurant_id);
        }
        $this->db->order_by('o.created_at','DESC');
        $this->db->order_by('o.status_id');
        $query = $this->db->get();
        return  $query->result();
    }
    
      public function get_new_orders(){
        $this->db->select('o.id AS order_id,o.address,o.address_aprt,o.status_id,o.total,o.driver_id,
        o.address_floor,o.restaurant_notes,o.delivery_notes,c.customer_name,r.restaurant_name');
        $this->db->from('orders o');
        $this->db->join('customers c', 'o.customer_id=c.id');
        $this->db->join('restaurants r', 'o.restaurant_id=r.id');
        //If branch manager, show only orders link to the user's restaurant. otherwise(Admin) show all orders
        if (isset($_SESSION['role']) && $_SESSION['role'] == 2) {
             $restaurant_id = $_SESSION['restaurant_id'];
             $this->db->where('restaurant_id',$restaurant_id);
        }
        $this->db->where('status_id', 1);
        $this->db->order_by('o.created_at','DESC');
        $query = $this->db->get();
        return  $query->result();
    }
    
       public function get_total_new_orders() {
        $this->db->select('*');
        $this->db->from('orders');
          if (isset($_SESSION['role']) && $_SESSION['role'] == 2) {
             $restaurant_id = $_SESSION['restaurant_id'];
             $this->db->where('restaurant_id',$restaurant_id);
        }
        $this->db->where('status_id', 1);
        $this->db->order_by('id', 'desc');
        $query = $this->db->get();
        $count = $query->num_rows();
        if ($count > 0) {
            return $count;
        }
    }
    
    public function get_driver_name($id) {
        $this->db->select('driver_name');
        $this->db->from('drivers');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->driver_name;
        }
    }
    
    public function get_drivers () {
        $this->db->select('*');
        $this->db->from('drivers');
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->result();
        }
    }
    
    public function assign_driver($order_id,$driver_id) {
        $array = array(
        'driver_id' => $driver_id
        );
        $this->db->set($array);
        $this->db->where('id', $order_id);
        $this->db->update('orders');
    }
    
    public function change_driver_available($driver_id,$driver_id_to_chnage = null) {
        $array = array(
        'is_available' => 0
        );
        $this->db->set($array);
        $this->db->where('id', $driver_id);
        $this->db->update('drivers');
        
        if (isset($driver_id_to_chnage)) {
            $array = array(
            'is_available' => 1
            );
            $this->db->set($array);
            $this->db->where('id', $driver_id_to_chnage);
            $this->db->update('drivers');
        }
        
    }
    
    public function cancel_order($id) {
        $array = array(
        'status_id' => 6
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('orders');
        $this->db->query('INSERT INTO orders_history SELECT * from orders where id='.$id);
        $this->db->delete('orders',array('id' => $id));
    }
    
    public function get_order_info($id) {
        $this->db->select('od.id,m.item_name,od.quantity');
        $this->db->from('order_details od');
        $this->db->join('menu_items m', 'm.id=od.item_id');
        $this->db->where('od.order_id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            $results =  $query->result();
            foreach($results as $result) {
                $item_name = $result->item_name;
                $quantity = $result->quantity;
                echo nl2br($item_name." x ".$quantity."\n");
                $this->get_addons_name($result->id);
            }
        }
    }
    
    
    public function get_addons_name($order_detail_id) {
        $this->db->select('*');
        $this->db->from('order_item_addons oia');
        $this->db->join('addon_detail ad','ad.id = oia.addon_detail_id');
        $this->db->join('addons a','a.id = ad.addon_id');
        $this->db->join('addons_section as','as.id = a.section_id');
        $this->db->where('oia.order_detail_id',$order_detail_id);
        $query = $this->db->get();
        $array = array();
        if($query->num_rows() != 0)
        {
            $results =  $query->result();
            foreach($results as $result) {
                $section_name = $result->section_name;
                $addon_name = $result->addon_name;
                if (isset($array[$section_name])){
                    $array[$section_name] = $array[$section_name].' , '.$addon_name;
                } else {
                    $array[$section_name] = $addon_name;
                }
                foreach($array as $key=>$value) {
                    echo nl2br($key.' : '.$value."\n");
                }
                $array = array();
            }
              echo "-------------------------------";
            echo "<br>";
        } else {
              echo "-------------------------------";
            echo "<br>";
        }
    }
    
    public function get_customer_name($id) {
        $this->db->select('*');
        $this->db->from('customers');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->customer_name;
        }
    }
    
    public function get_addon($id) {
        $this->db->select('*');
        $this->db->from('addon_detail ad');
        $this->db->join('addons a', 'a.id=ad.addon_id');
        $this->db->join('addons_section as', 'a.section_id=as.id');
        $this->db->where('ad.id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            $row = $query->row();
            $addon_name = $row->addon_name;
            $section_name = $row->section_name;
            $array = array (
            'addon_name' => $addon_name,
            'section_name' => $section_name
            );
            return $array;
        }
    }
    
    public function get_order_status($id) {
        $this->db->select('*');
        $this->db->from('order_status');
        $this->db->where('id',$id);
        $query = $this->db->get();
        if($query->num_rows() != 0)
        {
            return $query->row()->status_name;
        }
    }
    
    public function complete_order() {
        $id = $this->input->post('id');
        $driver_id = $this->input->post('driverid');
        $array = array(
        'status_id' => 4
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('orders');
        $this->db->query('INSERT INTO orders_history SELECT * from orders where id='.$id);
        $this->db->delete('orders',array('id' => $id));
        
        $this->db->set('is_available', 1);
        $this->db->set('active_order', null);
        $this->db->where('id', $driver_id);
        $this->db->update('drivers');
    }
    
    public function move_to_history($id) {
        $array = array(
        'status_id' => 4
        );
        $this->db->set($array);
        $this->db->where('id', $id);
        $this->db->update('orders');
        $this->db->query('INSERT INTO orders_history SELECT * from orders where id='.$id);
        $this->db->delete('orders',array('id' => $id));
    }
    
    
    public  function delete($order_id) {
        //delete the order by id
        $this->db->where('id', $order_id);
        $this->db->delete('orders');
        $array_id = array();
        //get array of all details ids from  order_details
        $this->db->select('id');
        $this->db->where('order_id',$order_id);
        $results = $this->db->get('order_details')->result();
        foreach ($results as $result) {
            array_push($array_id,$result->id);
        }
        //delete them from order_item_addons
        $this->db->where_in('order_detail_id',$array_id);
        $this->db->delete('order_item_addons');
        //delete order_details by order id       
        $this->db->where('order_id',$order_id);
        $this->db->delete('order_details');
        
        
        
    }
    public function search($search_text,$field_to_search) {
        $this->db->select('o.id AS order_id,o.address,o.address_aprt,o.status_id,o.total,o.driver_id,
        o.address_floor,o.restaurant_notes,o.delivery_notes,c.customer_name,r.restaurant_name');
        $this->db->from('orders o');
        $this->db->join('customers c', 'o.customer_id=c.id');
        $this->db->join('restaurants r', 'o.restaurant_id=r.id');
        $this->db->like($field_to_search, $search_text);
        $this->db->order_by('o.created_at','DESC');
        $query = $this->db->get();
        return  $query->result();
    }
    
        public function get_restaurant_name ($rest_id) {
        $this->db->select('restaurant_name');
        $this->db->from('restaurants');
        $this->db->where('id',$rest_id);
        $query = $this->db->get();
        return $query->row()->restaurant_name;
    }
    
        public function change_status($id){
            $this->db->set('status_id',2);
            $this->db->where('id', $id);
            $this->db->update('orders');
        }
    
}