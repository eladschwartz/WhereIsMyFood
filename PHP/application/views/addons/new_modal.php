<div id="modal-new" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Meal Extra</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('addons/new_addon'); ?>
            <div class="form-group">
              <label for="name"> Name </label>
              <input type="text" class="form-control" name="name" id="name"> </div>
            <div class="form-group">
              <label for="section_name"> Section Name </label>
                <select id="section-name-select" name="section-name-select">
                 <?php  foreach($sections as $section) { ?>
                      <option value=<?php echo $section->id ?>>
                      <?php echo $section->section_name ?></option>
                <?php } ?>
                 </select>
            </div>
               <div class="form-group">
              <label for="required"> Required? </label>
              <select id="required" name="required">
                <option value="0">No</option>
                <option value="1">Yes</option>
              </select>
            </div>

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