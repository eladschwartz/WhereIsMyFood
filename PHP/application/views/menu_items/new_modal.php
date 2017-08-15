<div id="modal-new" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Item</h4>
      </div>
      <div class="modal-body">
        <?php echo validation_errors(); ?>
          <?php echo form_open('menu_items/new_item'); ?>
            <div class="form-group">
              <label for="name"> Item Name </label>
              <input type="text" class="form-control" name="name" id="name">
            </div>
              <div class="form-group">
              <label for="name"> Description </label>
              <input type="text" class="form-control" name="description" id="description">
            </div>
              <div class="form-group">
             <label for="category">Choose Category: </label>
              <select id="new-category" name="new-category">
                <?php  foreach($categories as $category) { ?>
                  <option value=<?php echo $category->id ?>>
                    <?php echo $category->category_name ?>
                  </option>
                  <?php  } ?>
              </select>
              </div>
            <div class="form-group">
              <label for="price"> Price </label>
              <input type="text" class="form-control" name="price" id="price"> 
              </div>
                 <div class="form-group">
              <label for="price"> Discount Rate </label>
              <input type="text" class="form-control" name="discount" id="discount"> 
              </div>
            <div class="form-group">
              <input type="text" class="form-control" name="row-new-rest-id" id="row-new-rest-id" style="display:none" value="<?php echo $restaurant_id ?>"> </div>
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
</div>
<!-- /.modal -->