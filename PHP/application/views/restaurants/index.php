<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-lg-12">
                <div class="form-group">
                    <button id="add-new" class="btn btn-rounded btn-success pull-right" type="button">New Restaurant</button>
                </div>
                <h3 class="title">Restaurants/Branches</h3>
                <?php echo form_open(base_url().'restaurants'); ?> 
                <select class="" name="search_field">
                    <option selected="selected" disabled="disabled" value="">Filter By</option>
                    <option value="restaurant_name">Name</option>
                    <option value="restaurant_address">Address</option>
                    <option value="phone_number">Phone Number</option>
                </select>
                <input class="" type="text" name="search" value="" placeholder="Search...">
                <input class="btn btn-default" type="submit" name="filter" value="Go">
                <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
                </form>

                <div class="table-responsive">
                    <?php echo $this->pagination->create_links(); ?>
                    <table class="table table-users table-striped">
                        <thead>
                            <tr>
                                <th style="width:15%">Image</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>Phone Number</th>
                                <th>Active</th>
                                <th>Actions</th>
                            </tr>
                        <tbody>
                            <?php foreach($restaurants as $restaurant): ?>
                            <tr>
                                <td class="table-row-restaurant"  style="cursor:pointer" data-id="<?php echo $restaurant->id; ?>">
                                    <?php
                                    if ($restaurant->image == "UPLOAD IMAGE") {
                                    echo '<img src="'.base_url().'img/noimage.png" style="width:20%" alt="UPLOAD IMAGE">';
                                    } else {
                                    echo '<img style="width:100%" src='.$restaurant->image.'>';
                                    }
                                    ?>
                                </td>
                                <td>
                                    <?php echo $restaurant->restaurant_name ?>
                                </td>
                                <td>
                                    <?php echo $restaurant->restaurant_address ?>
                                </td>
                                <td>
                                    <?php echo $restaurant->phone_number ?>
                                </td>
                                <td>
                                    <label class="switch">
                                        <?php
                                        if($restaurant->active == 1){
                                        echo '<input type="checkbox" checked>';
                                        } else {
                                        echo '<input type="checkbox">';
                                        }
                                        ?>
                                        <div id="<?php echo $restaurant->id ?>" active="<?php echo $restaurant->active ?>" class="slider round btn active-btn-restaurant"></div>
                                    </label>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <button class="btn btn-rounded btn-block btn-success edit-btn-table" restaurant-address="<?php echo $restaurant->restaurant_address ?>" restaurant-name="<?php echo $restaurant->restaurant_name ?>" value="<?php echo $restaurant->id ?>" restaurant-phone="<?php echo $restaurant->phone_number ?>"
                                                type="button">Edit</button>
                                    </div>
                                    <div class="form-group">
                                        <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php echo $restaurant->id ?>" path-delete-name="../restaurants/delete/" type="button">Delete</button>
                                    </div>
                                    <div>
                                        <button class="btn  btn-rounded btn-block btn-primary image-btn-table" value="<?php echo $restaurant->id ?>" type="button">Upload Image</button>
                                    </div>
                                </td>
                            </tr>
                            <? endforeach; ?>
                        </tbody>
                    </table>

                </div>
            </div>
    </section>
</div>

<div id="modal-new-result">
    <?php $this->load->view('restaurants/new_modal'); ?>
</div>
<div id="modal-edit-result">
    <?php $this->load->view('restaurants/edit_modal'); ?>
</div>
<div id="modal-delete-result">
    <?php $this->load->view('modals/delete_modal'); ?>
</div>
<div id="modal-image-result">
    <?php $this->load->view('modals/image_upload_modal'); ?>
</div>



<script>
    $(document).ready(function () {
        $(function () {
            // Attach csfr data token
            $.ajaxSetup({
                data: csfrData
            });
        });
        //Show Edit Modal
        $(".edit-btn-table").click(function () {
            var id = $(this).val();
            var name = $(this).attr("restaurant-name");
            var address = $(this).attr("restaurant-address");
            var phone = $(this).attr("restaurant-phone");
            $("#row-id-edit").attr("value", id);
            $("#nameedit").attr("value", name);
            $("#addressedit").attr("value", address);
            $("#phoneedit").attr("value", phone);
            $('#modal-edit').modal('show');
        });

        $(".table-row-restaurant").click(function () {
            var restaurant_id = $(this).data('id');
            $.ajax({
                type: "post",
                url: window.location.href + "/save_restaurant_id",
                data: {
                    id: restaurant_id
                },
                success: function () {
                    window.location = 'menu_items';
                }
            });
        });
        $(".delete-btn-table").click(function () {
            var id = $(this).val();
            var path = window.location.href + '/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });

        //Restaurant Active Button
        $(".active-btn-restaurant").click(function () {
            var id = $(this).attr("id");
            var attr = $(this).attr("active");
            var active = (attr === '1') ? "0" : "1";
            $(this).attr("active", active);
            $.ajax({
                type: "post",
                url: window.location.href + "/change_active",
                data: {
                    id: id,
                    active: active
                },
                success: function (res) { }
            });
        });

    });
</script>