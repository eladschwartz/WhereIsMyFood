<div class="content-wrapper">
    <section class="content-header">
        <h1>
            Admin
        </h1>
    </section>
    <section class="content">
        <div class="row">
            <?php $this->load->view('admin/views/users_view', $this->data); ?>
            <?php $this->load->view('admin/views/drivers_view', $this->data); ?>
        </div>
        <div class="row">
            <?php $this->load->view('admin/views/settings_view', $this->data); ?>
     
        </div>
    </section>
</div>

<div id="modal-new-result">
    <?php $this->load->view('admin/new_user_modal'); ?>
</div>

<div id="modal-edit-result">
    <?php $this->load->view('admin/edit_modal_user'); ?>
</div>

<div id="modal-change-password-result">
    <?php $this->load->view('admin/change_password'); ?>
</div>

<div id="modal-new-result">
    <?php $this->load->view('admin/new_driver_modal'); ?>
</div>

<div id="modal-delete-result">
    <?php $this->load->view('modals/delete_modal'); ?>
</div>

<div id="modal-edit-drivers-result">
    <?php $this->load->view('admin/edit_modal_driver'); ?>
</div>

<div id="modal-edit-settings-result">
    <?php $this->load->view('admin/new_settings_modal'); ?>
</div>




<script>

    $(document).ready(function () {
   $(function () {
            // Attach csfr data token
            $.ajaxSetup({
                data: csfrData
            });
        });
        // ------- USERS ------------//

        //Show New Modal For Users
        $("#add-new-users").click(function () {
            $('#modal-new-user').modal('show');
            $('label[for="password"]').show();
        });


        //Show Edit Modal For User
        $(".edit-btn-table").click(function () {
            var id = $(this).val();
            var name = $(this).attr("users-name");
            var email = $(this).attr("users-email");
            $("#row-id-edit").attr("value", id);
            $("#edit-user-name").attr("value", name);
            $("#edit-user-email").attr("value", email);
            $('#modal-edit-users').modal('show');
        });

        //Show Change Password Modal For User
        $(".change-password-btn-table").click(function () {
            var id = $(this).val();
            $("#row-id-password").attr("value", id);
            $('label[for="password"]').show();
            $('#modal-password-users').modal('show');
        });

        //Show Edit Modal For User
        $(".edit-btn-table").click(function () {
            var id = $(this).val();
            var name = $(this).attr("users-name");
            var email = $(this).attr("users-email");
            $("#row-id-edit").attr("value", id);
            $("#edit-user-name").attr("value", name);
            $("#edit-user-email").attr("value", email);
            $('#modal-edit-user').modal('show');
        });

        $(".delete-btn-users-table").click(function () {
            var id = $(this).val();
            var path = window.location.href + '/delete_user/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });


        // ------- END - USERS ------------//


        // ------- Drivers ------------//
        // 
        //Show new driver modal
        $("#add-new-driver").click(function () {
            $('#modal-new-driver').modal('show');
        });

        //Show Edit Modal For Driver
        $(".edit-btn-driver-table").click(function () {
            var id = $(this).val();
            var name = $(this).attr("driver-name");
            var phone = $(this).attr("driver-phone");
            $("#row-id-edit-driver").attr("value", id);
            $("#edit-driver-name").attr("value", name);
            $("#edit-driver-phone").attr("value", phone);
            $('#modal-edit-driver').modal('show');
        });

        //Driver Available Button
        $(".active-btn-drivers").click(function () {
            var id = $(this).attr("id");
            var attr = $(this).attr("active");
            var active = (attr === '1') ? "0" : "1";
            $(this).attr("active", active);
            $.ajax({
                type: "post",
                url: window.location.href + "/change_available_driver",
                data: {
                    id: id,
                    active: active
                },
                success: function (res) { }
            });
        });

        $(".delete-btn-drivers-table").click(function () {
            var id = $(this).val();
            var path = window.location.href + '/delete_driver/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });


        //Is Available Button
        $(".is-available-btn-drivers").click(function () {
            var id = $(this).attr("id");
            var attr = $(this).attr("is_available");
            var is_available = (attr === '1') ? "0" : "1";
            $(this).attr("is_available", is_available);
            $.ajax({
                type: "post",
                url: window.location.href + "/change_available",
                data: {
                    id: id,
                    is_available: is_available
                },
                success: function () { }
            });
        });


        //Show location for the driver
        $(".location-btn").click(function () {
            window.location.href = window.location.origin + '/location'
            //window.location.href = "window.location.href" 
        });

        // ------- END - Drivers ------------//


        // ------- Settings ------------//

        //Show New Modal For Settings
        $("#add-new-setting").click(function () {
            $('#modal-new-setting').modal('show');
        });

        $(".delete-btn-settings-table").click(function () {
            var id = $(this).val();
            var path = window.location.href + '/delete_setting/' + id;
            $("#delete-btn-modal").attr("href", path);
            $('#modal-delete').modal('show');
        });


        //Active Settings Button
        $("#currencies").change(function () {
            var id = $(this).val();
            $.ajax({
                type: "post",
                url: window.location.href + "/change_currency",
                data: {
                    id: id
                },
                success: function () { }
            });
        });



    });
</script>