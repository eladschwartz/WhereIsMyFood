<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-lg-12">
                <h3 class="title">New Order - Under Construction<?php
                    if (isset($_SESSION['role']) && $_SESSION['role'] == 2) {
                        echo " - " . $restaurant_name;
                    }
                    ?></h3> 

                <div class="row">
              <?php $this->load->view('new_order/views/item_box', $this->data); ?>
                      <?php $this->load->view('new_order/views/order_table', $this->data); ?>
                </div>
                 
            </div>
                 
        </div>
    </section>
</div>






<script>
    $(document).ready(function () {

    });
</script>