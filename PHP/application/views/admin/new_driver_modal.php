<div id="modal-new-driver" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Driver</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('admin/new_driver'); ?>
            <div class="form-group">
              <label for="name"> Name </label>
              <input type="text" class="form-control" name="driver_name" id="driver_name">
            </div>
             <div class="form-group">
              <label for="email"> Phone </label>
              <input type="text" class="form-control" name="driver_phone" id=driver_phone">
            </div>
           <?php if (isset($_SESSION['role']) && $_SESSION['role'] != 2): ?>
            <div class="form-group">
              <label for="restaurants">Choose Restaurant: </label>
              <select id="driver_restaurants" name="driver_restaurants">
                <?php  foreach($restaurants as $restaurant) { ?>
                  <option value=<?php echo $restaurant->id ?>>
                    <?php echo $restaurant->restaurant_name ?>
                  </option>
                  <?php  } ?>
              </select>
            </div>
          <?php endif ?>
         
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