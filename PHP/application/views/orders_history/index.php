   <div class="content-wrapper">
 <section class="content">
  <div class="row">
    <div class="col-lg-12">
      <div class="form-group">
      </div>
      <h3 class="title">Orders History</h3>

      <div class="table-responsive">
        <table class="table table-users table-striped">
          <thead>
            <tr>
              <th>ID</th>
              <th>Order Details</th>
              <th>Customer</th>
              <th>Address</th>
              <th>Driver</th>
              <th>Status</th>
              <th>Total</th>
              <th>Actions</th>
            </tr>
            <tbody>
              <?php foreach($orders as $order): ?>
                <tr>
                  <td>
                    <?php echo $order->id ?>
                  </td>
                  <td>
                   <?php get_order_info($order->id); ?>
                  </td>
                  <td>
                  <?php echo (get_customer_name_order($order->customer_id)) ?>
                  </td>
                  <td>
                    <?php echo $order->address ?>
                  </td>
                  <td>
                    <?php echo (get_driver_name($order->driver_id)); ?>
                  </td>
                  <td>
                    <?php echo get_order_status($order->status_id) ?>
                  </td>
                  <td>
                    <?php echo $order->total ?>
                  </td>
                  <td>
                    <div class="form-group">
                      <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php  echo $order->id ?>" type="button">Delete</button>
                    </div>
                  </td>
                  </td>
                </tr>
                <? endforeach; ?>
            </tbody>
        </table>
      </div>
    </div>
  </div>
 </section>
   </div>

<div id="modal-delete-result">
    <?php $this->load->view('modals/delete_modal'); ?>
</div>


<script>
    $(document).ready(function () {
        //Show delete window
        $(".delete-btn-table").click(function () {
            var id = $(this).val();
            var path = 'orders_history/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });
       
    });
</script>