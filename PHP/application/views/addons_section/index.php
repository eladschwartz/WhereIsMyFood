<div class="content-wrapper">
  <section class="content-header">
    <h1>
Addons Sections
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
              <option value="section_name">Name</option>
              <option value="section_type">Type</option>
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
                <th>Type</th>
                <th>Required?</th>
                <th>Actions</th>
              </tr>
              <tbody>
                <?php foreach($sections as $section): ?>
                  <tr>
                    <td>
                      <?php echo $section->id ?>
                    </td>
                    <td>
                      <?php echo $section->section_name ?>
                    </td>
                    <td>
                      <?php echo get_section_type($section->section_type_id) ?>
                    </td>
                    <td>
                      <label class="switch">
                        <?php if($section->is_required == 1){
    echo '<input type="checkbox" checked>';
} else {
    echo '<input type="checkbox">';
} ?>
                          <div id="<?php echo $section->id ?>" active="<?php echo $section->is_required ?>" class="slider round btn is-required-btn"></div>
                      </label>
                    </td>
                    <td>
                      <div class="form-group">
                        <button class="btn btn-rounded btn-block btn-success edit-btn-table" data-section-name="<?php  echo $section->section_name ?>" data-section-type="<?php  echo get_section_type($section->section_type_id) ?>" value="<?php  echo $section->id ?>" type="button">Edit</button>
                      </div>
                      <div class="form-group">
                        <button class="btn  btn-rounded btn-block btn-danger delete-btn-table" value="<?php  echo $section->id ?>" type="button">Delete</button>
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
  <?php  $this->load->view('addons_section/new_modal'); ?>
    <?php  $this->load->view('addons_section/edit_modal'); ?>

      <script>
        $(document).ready(function() {
              $(function () {
            // Attach csfr data token
            $.ajaxSetup({
                data: csfrData
            });
        });
        
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
            var path = 'addons_section/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
          });
        });

               //Is required Button
        $(".is-required-btn").click(function () {
            var id = $(this).attr("id");
            var attr = $(this).attr("active");
            var active = (attr == '1') ? "0" : "1"
            $(this).attr("active", active);
            $.ajax({
                type: "post",
                url: window.location.href + "/change_required",
                data: {
                    id: id,
                    active: active
                },
                success: function (res) { }
            });
        });
      </script>