<div id="modal-copy" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Copy Item To Restaurant</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('menu_items/copy_item'); ?>
            <div class="form-group">
              <select id="restaurant_copy_select" name="restaurant_copy_select">
                <label for="restaurant_copy_select">Copy to restaurant: </label>
                <?php  foreach($restaurants_name as $restaurant) { ?>
                  <option value=<?php echo $restaurant->id ?>>
                    <?php echo $restaurant->restaurant_name ?>
                  </option>
                  <?php  } ?>
              </select>
            </div>
            <input id="row-id-copy" type="txt" style="display:none" name="row-id-copy">
            <input id="row-id-rest_copy" type="txt" style="display:none" name="row-id-rest_copy">
            <div class="form-group">
              <button type="submit" class="btn btn-primary">Copy</button>
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
            </form>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
</div>
<!-- /.modal -->