 <?php echo $map['js']; ?>
<div class="content-wrapper">
    <section class="content-header">
        <h1>
            Driver Locations
        </h1>
    </section>
    <section>
      <?php echo $map['html']; ?>
    </section>
    <div class="form-group">
        <button class="btn btn-success btn-refresh-map"> Refresh </button>
    </div>
</div>


<script>

    $(document).ready(function () {
        $(".btn-refresh-map").click(function () {
           location.reload();
        });
    });
</script>