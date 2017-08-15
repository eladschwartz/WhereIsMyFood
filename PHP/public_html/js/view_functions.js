"use strict";
(function ($) {
    $(document).ready(function () {
        //Show new Modal
        $("#add-new").click(function () {
            $('#modal-new').modal('show');
            $('label[for="password"]').show()
        });
       

        //Upload Image
        $(".image-btn-table").click(function () {
            var id = $(this).val();
            $("#row-id-image").attr("value", id)
            $('#modal-image').modal('show');
        });

        //show image before upload
        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#show-image-selected').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        $(".upload-image").change(function () {
            $("#show-image-selected").css({
                'display': 'block'
            });
            readURL(this);
        });
        //show suceess message if upload ok
        $("#success-alert").fadeTo(3000, 500).slideUp(500, function () {
            $("#success-alert").slideUp(500);
        });
    });
})($);
