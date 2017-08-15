<div class="content-wrapper">
  <section class="content-header">
    <h1>
Addons Details
</h1>
  </section>
  <section class="content">
    <div class="row">
      <div class="col-lg-12">
        <div class="table-responsive ">
          <div class="form-group">
            <button id="add-new" class="btn btn-rounded btn-success pull-right" type="button">New Detail</button>
          </div>
          <form class="form-inline" action="<?php echo base_url() ?>addon_detail/<?php echo $item_id?>" method="post">
            <select class="form-control" name="search_field">
              <option selected="selected" disabled="disabled" value="">Filter By</option>
              <option value="addon_name">Addon Name</option>
              <option value="section_name">Section Name</option>
            </select>
            <input class="form-control" type="text" name="search" value="" placeholder="Search...">
            <input class="btn btn-default" type="submit" name="filter" value="Go">
            <input class="btn btn-default" type="submit" name="clear_btn" value="Clear">
          </form>
          <table class="table table-bordered">
            <thead>
              <tr>
                <th>Detail Name</th>
                <th>Section Name</th>
              </tr>
              <tbody>
                <?php for($i = 0; $i < count($sections); $i++): ?>
                  <tr>
                    <td>
                      <?php 
                      $section_name = $sections[$i]->section_name;
                      $addon = get_details_by_section($item_id,$section_name);
                      echo $addon['addon_name'];
                       ?>
                    </td>
                    <td>
                      <?php echo $sections[$i]->section_name ?>
                    </td>        
                  </tr>
                  <? endfor; ?>
              </tbody>
          </table>
        </div>
      </div>
    </div>
  </section>
</div>


<?php  $this->load->view('modals/delete_modal'); ?>
  <?php  $this->load->view('addon_detail/edit_modal'); ?>
    <?php  $this->load->view('addon_detail/new_modal'); ?>

      <script>
        $(document).ready(function() {
          //Show Edit Modal
          $(".edit-btn-table").click(function() {
            var id = $(this).val();
            var name = $(this).attr("detail-name");
            var section_name = $(this).attr("detail-section");
            var price = $(this).attr("detail-price");
            var section_id = $(this).attr("detail-section-id");
            $("#row-id-edit").attr("value", id);
            $("#addon-name-select-edit").attr("value", section_name);
            $("#addon-name-select-edit").val(section_id).change();
            $("#editprice").attr("value", price);
            $('#modal-edit').modal('show');
          });

          $(".delete-btn-table").click(function() {
            var id = $(this).attr("detail-id");
            console.log(id);
            var path = '../addon_detail/delete/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
          });
        });
      </script>