<div id="modal-password-users" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Change Password</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('admin/change_password'); ?>
            <div class="form-group">
              <label for="password"> Password </label>
              <input type="password" class="form-control" name="change-password" id="change-password">
            </div>
           <input id="row-id-password" type="txt" style="display:none" name="row-id-password">
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
    
    