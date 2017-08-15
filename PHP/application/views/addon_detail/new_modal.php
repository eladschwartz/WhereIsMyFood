<div id="modal-new" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Detail</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('addon_detail/new_detail'); ?>
            <div class="form-group">
              <label for="addon"> Addon Name </label>
              <select id="addon-name-select" name="addon-name-select">
                 <?php  foreach($addons as $addon) { ?>
                      <option value=<?php echo $addon->id ?>>
                      <?php echo $addon->addon_name ?></option>
                <?php } ?>
                 </select>
            <div class="form-group">
              <label for="price"> Price </label>
              <input type="text" class="form-control" name="price" id="price"> </div>
            <div class="form-group">
              <input type="text" class="form-control" name="item_id" id="item_id" style="display:none" value=<?php echo $item_id ?>> </div>
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
</div>
<!-- /.modal -->