<div id="modal-edit" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Edit</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('addon_detail/update'); ?>
            <div class="form-group">
              <label for="addon-name"> Addon Name </label>
               <select id="addon-name-select-edit" name="addon-name-select-edit">
                 <?php  foreach($addons as $addon) { ?>
                      <option value=<?php echo $addon->id ?>>
                      <?php echo $addon->addon_name ?></option>
                <?php } ?>
                 </select>
              </div>
               <div class="form-group">
              <label for="price">Price </label>
              <input type="text" class="form-control" name="price" id="editprice"> 
              </div>
              <input id="row-id-edit" type="txt" style="display:none" name="row-id-edit">
              <div class="form-group">
                <input type="text" class="form-control" name="item_id" id="item_id" style="display:none" value=<?php echo $item_id ?>> </div>
                <button type="submit" class="btn btn-primary">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
              </form>
            </div>
            <!-- /.modal-content -->
      </div>
      <!-- /.modal-dialog -->
    </div>
  </div>
</div>
<!-- /.modal -->