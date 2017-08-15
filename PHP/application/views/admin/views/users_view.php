<div class="col-lg-6">
        <div class="form-group">
                 <?php echo form_open(base_url().'admin'); ?>
                    <select  name="search_field">
                        <option selected="selected" disabled="disabled" value="">Filter By</option>
                        <option value="user_name">Name</option>
                        <option value="email">Email</option>
                        <!--No need to filter by restaurant if you are the branch manager - only admin can filter -->
                           <?php if (isset($_SESSION['role']) && $_SESSION['role'] != 2): ?>
                        <option value="restaurant_name">Restaurant Name</option>
                        <?php endif; ?>
                    </select>
                    <input  type="text" name="search" value="" placeholder="Search...">
                    <input class="btn btn-default" type="submit" name="filter" value="Go">
                    <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
                </form>
            </div>
    <div class="panel panel-default">
        
        <div class="panel-heading">
            <h3 class="panel-title">Users
                <div class="pull-right" style="margin-top: -8px">
                    <button id="add-new-users" class="btn btn-success" type="button">New</button>
                </div>
            </h3>
        </div>
        
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Restaurant</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($users as $key => $value): ?>
                            <tr>
                                <th scope="row">
                                    <?php echo $key + 1 ?>
                                </th>
                                <td>
                                    <?php echo $value['user_name'] ?>
                                </td>
                                <td>
                                    <?php echo $value['email'] ?>
                                </td>
                                <td>
                                    <?php echo $value['restaurant_name'] ?>
                                </td>
                                <td>
                                    <?php echo $value['group_name'] ?>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <button class="btn btn-block btn-success edit-btn-table" users-name="<?php echo $value['user_name'] ?>" users-email="<?php echo $value['email'] ?>"
                                                value="<?php echo $value['user_id'] ?>" type="button">Edit</button>
                                    </div>
                                    <div class="form-group">
                                        <button class="btn  btn-block btn-danger delete-btn-users-table" value="<?php echo $value['user_id'] ?>" type="button">Delete</button>
                                    </div>
                                    <div>
                                        <button class="btn  btn-block btn-primary change-password-btn-table" value="<?php echo $value['user_id'] ?>" type="button">Change Password</button>
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