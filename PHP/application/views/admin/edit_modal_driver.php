<div id="modal-edit-driver" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Edit</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('admin/update_driver'); ?>
            <div class="form-group">
              <label for="name">Name </label>
              <input type="text" class="form-control" name="edit-driver-name" id="edit-driver-name">
            </div>
            <div class="form-group">
              <label for="name">Phone </label>
              <input type="text" class="form-control" name="edit-driver-phone" id="edit-driver-phone">
            </div>
              <input id="row-id-edit-driver" type="txt" style="display:none" name="row-id-edit-driver">
              <div class="form-group">
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
    <!-- /.modal -->