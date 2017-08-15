<div class="content-wrapper">
  <section class="content-header">
    <h1>
  Items Categories
</h1>
  </section>
  <section class="content">
    <div class="row">
      <div class="col-lg-12">
        <div class="table-responsive">
          <div class="form-group">
            <button id="add-new" class="btn btn-rounded btn-success pull-right" type="button">New Category</button>
          </div>
          <form class="form-inline" action="<?php echo base_url() ?>items_category" method="post">
            <select class="form-control" name="search_field">
              <option selected="selected" disabled="disabled" value="">Filter By</option>
              <option value="category_name">Name</option>
            </select>
            <input class="form-control" type="text" name="search" value="" placeholder="Search...">
            <input class="btn btn-default" type="submit" name="filter" value="Go">
            <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
          </form>
          <table class="table table-bordered table-hover">
            <thead>
              <tr>
                <th style="width:7%">Image</th>
                <th style="width:5%">Name</th>
                <th style="width:1%">Options</th>
              </tr>
              <tbody>
                <?php foreach($categories as $category): ?>
                  <tr class="table-row">
                    <td td class="table-row-item">
                      <?php if ($category->image == "UPLOAD IMAGE") {
                              echo '<img src="'.base_url().'/img/noimage.png" style="width:100%" alt="UPLOAD IMAGE">';
                          } else {
                              echo '<img style="width:15%" src='.$category->image.'>';
                          } ?>
                    </td>
                    <td>
                      <?php echo $category->category_name ?>
                      </td>
                    <td>
                      <div class="form-group">
                        <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php  echo $category->id ?>" type="button">Delete</button>
                      </div>
                      <div class="form-group">
                        <button class="btn  btn-rounded btn-block btn-primary image-btn-table" value="<?php  echo $category->id ?>" type="button">Upload Image</button>
                      </div>
                    </td>
                  </tr>
                  <? endforeach; ?>
              </tbody>
          </table>
        </div>
      </div>
    </div>
  </section>
</div>

<div id="modal-new-result">
  <?php  $this->load->view('items_category/new_modal'); ?>
</div>
<div id="modal-delete-result">
  <?php  $this->load->view('modals/delete_modal'); ?>
</div>
<div id="modal-image-result">
  <?php  $this->load->view('modals/image_upload_modal'); ?>
</div>








<script>
  $(document).ready(function() {
    $(".copy-btn-table").click(function() {
      var id = $(this).val();
      var rest_id = $(this).attr("data-rest-id");
      $("#row-id-copy").attr("value", id);
      $("#row-id-rest_copy").attr("value", rest_id);
      $('#modal-copy').modal('show');
    });


    //Show delete window
    $(".delete-btn-table").click(function() {
      var id = $(this).val();
      var path = 'items_category/delete/' + id;
      $("#delete-btn-modal").attr("href", path);
      $('#modal-delete').modal('show');
    });


  });
</script>