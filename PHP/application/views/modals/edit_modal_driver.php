<div id="modal-edit-driver" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Edit</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open("admin/driver_action/update"); ?>
            <?php foreach($inputs_driver as $input): ?>
              <div class="form-group">
                <label for="<?php echo $input[1] ?>"><?php echo $input[0] ?> </label>
                <?php if ($input[2] == 'textarea') {
                echo '<textarea  rows="4" cols="50" id='. $input[1].' class="form-control" name='.$input[1].'></textarea>';
                } else if ($input[2] == 'select') { ?>
                   <select id="meal-select" name="meal-select">
                   <?php  foreach($restaurants_name as $restaurant) { ?>
                                <option value=<?php echo $restaurant->id ?>><?php echo $restaurant->restaurant_name ?></option>
               <?php  } ?>
                 </select>
                 <?php
                } else {
                    echo  '<input type='. $input[2].' class="form-control" name='.$input[1].' id='.$input[1].'>';
                } ?>
              </div>
              <? endforeach; ?>
                <input id="row-id-edit" type="txt" style="display:none" name='row-id-edit'>
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