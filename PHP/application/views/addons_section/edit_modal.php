<div id="modal-edit" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Edit</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('addons_section/update'); ?>
            <div class="form-group">
              <label for="name">Name </label>
              <input type="text" class="form-control" name="name" id="editname"> </div>
            <div class="form-group">
               <label for="type"> Type </label>
              <select id="edittype" name="type">
                <option value="single">Single</option>
                <option value="multi">Multi</option>
              </select>
              <input id="row-id-edit" type="txt" style="display:none" name="row-id-edit">
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
      </div>
    <!-- /.modal -->