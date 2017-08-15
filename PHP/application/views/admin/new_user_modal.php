<div id="modal-new-user" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New User</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('admin/new_user'); ?>
            <div class="form-group">
              <label for="name"> Name </label>
              <input type="text" class="form-control" name="name" id="name">
            </div>
           <?php if (isset($_SESSION['role']) && $_SESSION['role'] != 2): ?>
            <div class="form-group">
              <label for="restaurants">Choose Restaurant: </label>
              <select id="restaurants" name="restaurants">
                <?php  foreach($restaurants as $restaurant) { ?>
                  <option value=<?php echo $restaurant->id ?>>
                    <?php echo $restaurant->restaurant_name ?>
                  </option>
                  <?php  } ?>
              </select>
            </div>
          <?php endif ?>
            <div class="form-group">
              <label for="groups">Group: </label>
              <select id="groups" name="groups">
                <?php  foreach($groups as $group) { ?>
                    <?php if (isset($_SESSION['role']) && ($_SESSION['role'] == 2 && $group->group_name != "Admin")): ?>
                  <option value=<?php echo $group->id ?>>
                    <?php echo $group->group_name ?>
                  </option>
                  <?php elseif($_SESSION['role'] == 1):  ?>
                   <option value=<?php echo $group->id ?>>
                    <?php echo $group->group_name ?>
                  </option>
                   <?php endif; ?>
                  <?php  } ?>
              </select>
            </div>
            <div class="form-group">
              <label for="email"> Email </label>
              <input type="text" class="form-control" name="email" id="email">
            </div>
            <div class="form-group">
              <label for="password"> Password </label>
              <input type="password" class="form-control" name="password" id="password">
            </div>
            <div class="form-group">
              <button type="submit" class="btn btn-primary">Save</button>
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
            </form>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->