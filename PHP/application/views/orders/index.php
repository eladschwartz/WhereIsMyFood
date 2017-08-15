<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-lg-12">
                <h3 class="title">Orders<?php
                    if (isset($_SESSION['role']) && $_SESSION['role'] == 2){echo " - ".$restaurant_name;
                    }
                    ?></h3> 
                <?php echo form_open(base_url().'orders'); ?> 
                <select class="form-" name="search_field">
                    <option selected="selected" disabled="disabled" value="">Filter By</option>
                    <option value="o.id">ID</option>
                    <option value="restaurant_name">Restaurant Name</option>
                    <option value="address">Address</option>
                    <option value="driver_name">Driver Name</option>
                </select>
                <input class="" type="text" name="search" value="" placeholder="Search...">
                <input class="btn btn-default" type="submit" name="filter" value="Go">
                <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
                </form>
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>ID</th>

                                <?php
                                if (isset($_SESSION['role']) && $_SESSION['role'] != 2){echo "<th>Restaurant Name</th>";
                                }
                                ?>
                                <th>Order Details</th>
                                <th>Customer</th>
                                <th>Address</th>
                                <th>Driver</th>
                                <th>Status</th>
                                <th>Total</th>
                                <th>Notes</th>
                                <th >Actions</th>
                            </tr>
                        <tbody>
                            <?php foreach($orders as $order): ?>
                            <tr>
                                <td>
                                    <?php echo $order->order_id ?>
                                </td>

                                <?php
                                if (isset($_SESSION['role']) && $_SESSION['role'] != 2) {echo "<td>".$order->restaurant_name."</td>";
                                }
                                ?>

                                <td>
                                    <?php get_order_info($order->order_id); ?>
                                </td>
                                <td>
                                    <?php echo $order->customer_name ?>
                                </td>
                                <td>
                                    <?php echo $order->address ?>
                                </td>
                                <td>
                                    <?php if(($order->status_id == '4')) { ?>
                                    <?php } else if (!get_driver_name($order->driver_id)) { $disabled_class = "disabled" ?>
                                    <button class="btn btn-block btn-success assign-driver" order-id="<?php echo $order->order_id ?>">Assign Driver
                                        <?php
                                        } else {
                                        $disabled_class = "";
                                        echo (get_driver_name($order->driver_id));
                                        }
                                        ?>
                                </td>
                                <td>
                                    <div class=" form-group" style="font-size:160%">
                                        <p class="label label-warning"> <?php echo get_order_status($order->status_id) ?></p>
                                    </div>
                                    <?php if(($order->status_id == '1')): ?>
                                    <div class="form-group">
                                        <button class="btn btn-block btn-success btn-change-status" type="button" value="<?php echo $order->order_id ?>">Change status to processing</button>
                                    </div>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php echo $order->total ?>
                                </td>
                                <td>
                                    <p><?php echo $order->restaurant_notes ?></p>

                                </td>
                                <td>
                                    <div>
                                        <div class="form-group">
                                            <button class="btn <?php echo $disabled_class ?> btn-rounded btn-block btn-success change-driver-btn<?php echo $disabled_class ?>" order-id="<?php echo $order->order_id ?>" driver-id="<?php echo $order->driver_id ?>"  type="button">Change Driver</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn  btn-rounded btn-block btn-warning cancel-btn-order" value="<?php echo $order->order_id ?>" type="button">Cancel Order</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php echo $order->order_id ?>" type="button">Delete</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn <?php echo $disabled_class ?> btn-rounded btn-block btn-info complete-btn-table<?php echo $disabled_class ?>" value="<?php echo $order->order_id ?>" driver-id="<?php echo $order->driver_id ?>" type="button">Complete Order</button>
                                        </div>
                                    </div>
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
<div id="modal-cancel-result">
    <?php $this->load->view('orders/cancel_order_modal'); ?>
</div>
<div id="modal-driver-result">
    <?php $this->load->view('orders/assign_driver_modal'); ?>
</div>
<div id="modal-complete-result">
    <?php $this->load->view('orders/complete_modal'); ?>
</div>






<script>
    $(document).ready(function () {
        $(function () {
            // Attach csfr data token
            $.ajaxSetup({
                data: csfrData
            });
        });
        
        //Show Assign Modal
        $(".assign-driver").click(function () {
            var orderid = $(this).attr("order-id");
            $("#row-id-order").attr("value", orderid);
            $("#action-name").attr("value", "assign");
            $('#modal-driver').modal('show');
        });
        //Show Change Driver Modal
        $(".change-driver-btn").click(function () {
            var orderid = $(this).attr("order-id");
            var driverid = $(this).attr("driver-id");
            $("#row-id-order").attr("value", orderid);
            $("#driver-id-order").attr("value", driverid);
            $("#action-name").attr("value", "change");
            $('#modal-driver').modal('show');
        });
        //Show delete window
        $(".delete-btn-table").click(function () {
            var id = $(this).val();
            var path = 'orders/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });
        //Complete Order
        $(".complete-btn-table").click(function () {
            var id = $(this).val();
            var driverid = $(this).attr("driver-id");
            $('#modal-complete-order').modal('show');
            $('.complete-btn').click(function () {
                $.ajax({
                    url: window.location.href + '/complete_order/',
                    type: 'POST',
                    data: {
                        id: id,
                        driverid: driverid
                    },
                    success: function () {
                        window.location.reload();
                    }
                });
            });
        });
        //Cancel Order
        $(".cancel-btn-order").click(function () {
            var id = $(this).val();
            $("#cancel-btn-modal").attr("href", window.location.href + '/cancel_order/' + id);
            $('#modal-cancel').modal('show');
        });
        //Change order status
        $(".btn-change-status").click(function () {
            var id = $(this).val();
            $.ajax({
                url: window.location.href + '/change_status_processing',
                type: 'POST',
                data: {
                    id: id
                },
                success: function () {
                    window.location.reload();
                }
            });
        });
    });
</script>