<!--Notification Window-->
<div id="modal-new-notifction" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">New Order Alert!</h4>
      </div>
      <div class="modal-body">
        <p>You just got an new order!</p>
      </div>
      <div class="modal-footer">
        <a id="orders-btn-modal">
        <button type="button" class="btn btn-primary go-orders-btn">Go to orders</button>
        </a>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!--End Small Modal-->

<script>
 $(document).ready(function () {
     $(".go-orders-btn").click(function () {
         window.location.href = "/orders";
     });
 });
 </script>