<div id="modal-image" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">Upload Image</h4>
      </div>
      <div class="modal-body">
        <?php echo $error;?>
          <?php echo form_open_multipart($image_func);?>
               <div class="form-group">
            <label class="btn btn-block  btn-rounded btn-primary btn-file">
              Choose Image
              <input class="upload-image" name="userfile" type="file" style="display: none;">
            </label>
                </div>
              <div class="form-group">
            <button type="submit" class="btn btn-block btn-success"> Upload </button>
             </div>
             <input id="row-id-image" type="txt" style="display:none" name='image_name_id'>
            </form>
            <div> 
                <img id="show-image-selected" src="#" alt="your image" style="display:none" />
              </div>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

