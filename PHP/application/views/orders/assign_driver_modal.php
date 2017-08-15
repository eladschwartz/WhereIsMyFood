<div id="modal-driver" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Assign Driver</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('orders/assign_driver'); ?>
           <div class="form-group">
            <select id="driver-select" name="driver-select">
                <?php  foreach($drivers as $driver) { ?>
                  <option value=<?php echo $driver->id ?>>
                    <?php echo $driver->driver_name ?>
                  </option>
                  <?php  } ?>
              </select>
               </div>
                <input id="row-id-order" type="txt" style="display:none" name='orderid'>
                <input id="driver-id-order" type="txt" style="display:none" name='driverid'>
                <input id="action-name" type="txt" style="display:none" name='actionname'>
                <div class="form-group">
                  <button type="submit" type="button" class="btn btn-primary">Save</button>
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