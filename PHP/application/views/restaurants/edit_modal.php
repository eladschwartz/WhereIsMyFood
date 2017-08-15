<div id="modal-edit" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Edit</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('restaurants/update_restaurant'); ?>
              <div class="form-group">
                <label for="name">Name </label>
                <input type="text" class="form-control" name="name" id="nameedit"> </div>
              <div class="form-group">
                <label for="address">Address </label>
                <input type="text" class="form-control" name="address" id="addressedit"> </div>
              <div class="form-group">
                <label for="phone">Phone Number </label>
                <input type="text" class="form-control" name="phone" id="phoneedit"> </div>
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