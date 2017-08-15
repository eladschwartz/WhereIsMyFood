<div class="col-lg-6">
       <div class="form-group">
             <?php echo form_open(base_url().'admin'); ?>
                    <select  name="search_field_driver">
                        <option selected="selected" disabled="disabled" value="">Filter By</option>
                        <option value="driver_name">Name</option>
                        <option value="phone">Phone</option>
                        <!--No need to filter by restaurant if you are the branch manager - only admin can filter -->
                           <?php if (isset($_SESSION['role']) && $_SESSION['role'] != 2): ?>
                        <option value="restaurant_name">Restaurant Name</option>
                        <?php endif; ?>
                    </select>
                    <input  type="text" name="search_driver" value="" placeholder="Search...">
                    <input class="btn btn-default" type="submit" name="filter" value="Go">
                    <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
                </form>
            </div>
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Drivers</h3>
            <div class="pull-right" style="margin-top: -25px">
                <button id="add-new-driver" class="btn btn-success" type="button">New</button>
            </div>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Restaurant</th>
                            <th>Location</th>
                            <th>Available</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($drivers as $key => $value): ?>
                            <tr>
                                <th scope="row">
                                    <?php echo $key + 1 ?>
                                </th>
                                <td>
                                    <?php echo $value['driver_name'] ?>
                                </td>
                                <td>
                                    <?php echo $value['phone'] ?>
                                </td>
                                 <td>
                                    <?php echo $value['restaurant_name'] ?>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <button class="btn btn-block btn-success location-btn"> Show Driver Location </button>
                                     </div>
                                  </td>
                                <td>
                                    <label class="switch">
                                        <?php
                                        if ($value['is_available'] == 1) {
                                            echo '<input type="checkbox" checked>';
                                        } else {
                                            echo '<input type="checkbox">';
                                        }
                                        ?>
                                        <div id="<?php echo $value['driver_id'] ?>" class="slider round btn is-available-btn-drivers" is_available="<?php echo $value['is_available'] ?>"></div>
                                    </label>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <button class="btn btn-block btn-success edit-btn-driver-table" driver-name="<?php echo $value['driver_name'] ?>" driver-phone="<?php echo $value['phone'] ?>"
                                                value="<?php echo $value['driver_id'] ?>" type="button">Edit</button>
                                    </div>
                                    <div class="form-group">
                                        <button class="btn  btn-block btn-danger delete-btn-drivers-table" value="<?php echo $value['driver_id'] ?>" type="button">Delete</button>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>