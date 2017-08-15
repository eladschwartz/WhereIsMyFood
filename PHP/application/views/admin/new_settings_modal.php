<div id="modal-new-setting" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Settings</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('admin/new_setting'); ?>
            <div class="form-group">
              <label for="name"> Name </label>
              <input type="text" class="form-control" name="setting_name" id="setting_name">
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