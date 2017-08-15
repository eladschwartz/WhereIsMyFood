<div class="content-wrapper">
    <section class="content-header">
        <h1>
            Menu - <?php echo $restaurant_name ?>
        </h1>
    </section>
    <section class="content">
        <div class="row">
            <div class="col-lg-12">
                <div class="table-responsive">
                    <div class="form-group">
                        <div class="form-group">
                        <button id="add-new" class="btn btn-rounded btn-success pull-right" type="button">New Item</button>
                        </div>
                        <div class="form-group" style ="padding-right:7%;">
                         <button class="btn btn-rounded btn-primary btn-excel pull-right"  type="submit" name="excel" value="excel">Import Items From Excel </button>
                        </div>
                    </div>
                      <?php echo form_open(base_url().'menu_items'); ?>
                        <select  name="search_field">
                            <option selected="selected" disabled="disabled" value="">Filter By</option>
                            <option value="item_name">Name</option>
                            <option value="price">Price</option>
                        </select>
                        <input  type="text" name="search" value="" placeholder="Search...">
                        <input class="btn btn-default" type="submit" name="filter" value="Go">
                        <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
                    </form>
                    Click here to filter by category:
                     <?php echo form_open(base_url().'menu_items'); ?>
                        <?php foreach ($categories as $category): ?>
                            <button type="submit" name="category_btn" class="btn btn-primary category-btn" value="<?php echo $category->id ?>"> <?php echo $category->category_name ?>   </button>
                        <?php endforeach; ?>
                     </form>
                    </div>
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th style="width:15%">Image</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Price</th>
                                <th style="width:11%">Price With Discount </th>
                                <th>Discount</th>
                                <th style="width:11%">Discount Rate(%)</th>
                                <th>Show On Menu</th>
                                <th>Options</th>
                            </tr>
                        <tbody>
                            <?php foreach ($items as $item): ?>
                                <tr class="table-row">
                                    <td td class="table-row-item" style="cursor:pointer" data-id="<?php echo $item->item_id; ?> ">
                                        <?php
                                        if ($item->image == "UPLOAD IMAGE") {
                                            echo '<img src="' . base_url() . 'img/noimage.png" style="width:100%" alt="UPLOAD IMAGE">';
                                        } else {
                                            echo '<img style="width:100%" src=' . $item->image . '>';
                                        }
                                        ?>
                                    </td>
                                    <td>
                                        <?php echo $item->item_name ?>
                                    </td>
                                    <td>
                                        <?php echo $item->description ?>
                                    </td>
                                    <td>
                                        <?php echo $item->price; ?>
                                    </td>
                                    <td>
                                        <?php
                                        $price_discount = $item->price - ($item->price * ($item->discount_rate / 100));
                                        echo $price_discount;
                                        ?>
                                    </td>
                                    <td>
                                        <label class="switch">
                                            <?php
                                            if ($item->is_discount == 1) {
                                                echo '<input type="checkbox" checked>';
                                            } else {
                                                echo '<input type="checkbox">';
                                            }
                                            ?>
                                            <div itemid="<?php echo $item->item_id ?>" active="<?php echo $item->is_discount ?>" class="slider round btn discount-btn"></div>
                                        </label>
                                    </td>
                                    <td>
                                        <?php echo $item->discount_rate . '%' ?>
                                    </td>
                                    <td class="text-center">
                                        <label class="switch">
                                            <?php
                                            if ($item->show_menu == 1) {
                                                echo '<input type="checkbox" checked>';
                                            } else {
                                                echo '<input type="checkbox">';
                                            }
                                            ?>
                                            <div itemid="<?php echo $item->item_id ?>" active="<?php echo $item->show_menu ?>" class="slider round btn menu-btn"></div>
                                        </label>
                                    </td>
                                    <td>
                                        <div class="form-group">
                                            <button class="btn btn-rounded btn-block btn-success edit-btn-table" value="<?php echo $item->item_id ?>" item-name="<?php echo $item->item_name ?>" item-desc="<?php echo $item->description ?>" item-rest-id="<?php echo $item->restaurant_id ?>" item-price="<?php echo $item->price ?>"
                                                    item-discount="<?php echo $item->discount_rate ?>" type="button">Edit</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php echo $item->item_id ?>" type="button">Delete</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn  btn-rounded btn-block btn-primary image-btn-table" value="<?php echo $item->item_id ?>" type="button">Upload Image</button>
                                        </div>
                                        <div class="form-group">
                                            <button class="btn  btn-rounded btn-block btn-primary copy-btn-table" value="<?php echo $item->item_id ?>" type="button" data-rest-id="<?php echo $item->restaurant_id ?>">Copy Meal</button>
                                        </div>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<div id="modal-new-result">
    <?php $this->load->view('menu_items/new_modal'); ?>
</div>
<div id="modal-edit-result">
    <?php $this->load->view('menu_items/edit_modal'); ?>
</div>
<div id="modal-delete-result">
    <?php $this->load->view('modals/delete_modal'); ?>
</div>
<div id="modal-image-result">
    <?php $this->load->view('modals/image_upload_modal'); ?>
</div>

<div id="modal-excel-result">
    <?php $this->load->view('menu_items/excel_upload_modal'); ?>
</div>
<div id="modal-copy-result">
    <?php $this->load->view('menu_items/copy_modal'); ?>
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
            console.log("test");
            var id = $(this).val();
            var name = $(this).attr("item-name");
            var desc = $(this).attr("item-desc");
            var price = $(this).attr("item-price");
            var discount = $(this).attr("item-discount");     
            var rest_id = $(this).attr("item-rest-id");
            $("#row-id-edit").attr("value", id);
            $("#row-rest-id").attr("value", rest_id);
            $("#editname").attr("value", name);
            $("#editdesc").val(desc);
            $("#editprice").attr("value", price);
            $("#editdiscount").attr("value", discount);
            $('#modal-edit').modal('show');
        });

        //Show Copy Modal - For copying Item to another restaurant(or to the same restaurant)
        $(".copy-btn-table").click(function () {
            var id = $(this).val();
            var rest_id = $(this).attr("data-rest-id");
            $("#row-id-copy").attr("value", id);
            $("#row-id-rest_copy").attr("value", rest_id);
            $('#modal-copy').modal('show');
        });

        //Navigate to Item's addons
        $(".table-row-item").click(function () {
            var item_id = $(this).data('id');
            $.ajax({
                type: "post",
                url: window.location + "/save_item_id",
                data: {
                    id: item_id
                },
                success: function () {
                    window.location ='addon_detail/' + item_id;
                }
            });
        });

        //Show delete window
        $(".delete-btn-table").click(function () {
            var id = $(this).val();
            var path = '../menu_items/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });

        //Discount Button
        $(".discount-btn").click(function () {
            var id = $(this).attr("itemid");
            var attr = $(this).attr("active");
            console.log(id,attr);
            var active = (attr === '1') ? "0" : "1";
            $(this).attr("active", active);
            $.ajax({
                type: "post",
                url:  window.location + "/discount_toggle",
                data: {
                    id: id,
                    active: active
                },
                success: function () {}
            });
        });

        //Show On Menu Button
        $(".menu-btn").click(function () {
            var id = $(this).attr("itemid");
            var attr = $(this).attr("active");
            var active = (attr === '1') ? "0" : "1";
            $(this).attr("active", active);
            $.ajax({
                type: "post",
                url: window.location + "/show_menu_toggle",
                data: {
                    id: id,
                    active: active
                },
                success: function () {}
            });
        });
        
          //Upload Excel
        $(".btn-excel").click(function () {
            $('#modal-excel').modal('show');
        });

    });
</script>