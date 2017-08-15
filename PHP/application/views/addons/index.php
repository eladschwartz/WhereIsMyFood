<div class="content-wrapper">
  <section class="content-header">
    <h1>
Addons
</h1>
  </section>
  <section class="content">
    <div class="row">
      <div class="col-lg-12">
        <div class="table-responsive ">
          <div class="form-group">
            <button id="add-new" class="btn btn-rounded btn-success pull-right" type="button">New</button>
          </div>
          <form class="form-inline" action="<?php echo base_url() . 'addons_section'; ?>" method="post">
            <select class="form-control" name="search_field">
              <option selected="selected" disabled="disabled" value="">Filter By</option>
              <option value="addon_name">Addon Name</option>
            </select>
            <input class="form-control" type="text" name="search" value="" placeholder="Search...">
            <input class="btn btn-default" type="submit" name="filter" value="Go">
            <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
          </form>
          <table class="table table-hover table-bordered">
            <thead>
              <tr>
                <th>#</th>
                <th>Name</th>
                <th>Section Name</th>
                <th>Actions</th>
              </tr>
              <tbody>
                <?php foreach($addons as $addon): ?>
                  <tr>
                    <td>
                      <?php echo $addon->id ?>
                    </td>
                    <td>
                      <?php echo $addon->addon_name ?>
                    </td>
                    <td>
                      <?php echo get_section_name($addon->section_id) ?>
                    </td>
                    <td>
                      <div class="form-group">
                        <button class="btn btn-rounded btn-block btn-success edit-btn-table" data-section-name="<?php  echo $addon->addon_name ?>" data-section-type="<?php  echo get_section_name($addon->section_id) ?>" value="<?php  echo $addon->id ?>" type="button">Edit</button>
                      </div>
                      <div class="form-group">
                        <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php  echo $addon->id ?>" type="button">Delete</button>
                      </div>
                    </td>
                  </tr>
                  <?php endforeach; ?>
              </tbody>
          </table>
        </div>
      </div>
    </div>
  </section>
</div>


<?php  $this->load->view('modals/delete_modal'); ?>
  <?php  $this->load->view('addons/new_modal'); ?>
    <?php  $this->load->view('addons/edit_modal'); ?>

      <script>
        $(document).ready(function() {
          //Show Edit Modal
          $(".edit-btn-table").click(function() {
            var id = $(this).val();
            var name = $(this).attr("data-section-name");
            var type = $(this).attr("data-section-type");
            var required = $(this).attr("data-section-required");
            console.log(name, type, required);
            $("#row-id-edit").attr("value", id);
            $("#editname").attr("value", name);
            $("#edittype").val(type).change();
            $('#modal-edit').modal('show');
          });

          //Show delete window
          $(".delete-btn-table").click(function() {
            var id = $(this).val();
            var path = 'addons/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
          });
        });

      </script>