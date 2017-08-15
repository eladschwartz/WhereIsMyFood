<div id="modal-excel" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Upload Excel</h4>
      </div>
      <div class="modal-body">
        <?php echo $error;?>
          <?php echo form_open_multipart('menu_items/upload_xls');?>
               <div class="form-group">
            <label class="btn btn-block  btn-rounded btn-primary btn-file">
              Choose Excel/Cvs File
              <input class="upload-image" name="excelfile" type="file" style="display: none;">
            </label>
                </div>
              <div class="form-group">
            <button type="submit" class="btn btn-block btn-success"> Upload </button>
             </div>
            </form>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

