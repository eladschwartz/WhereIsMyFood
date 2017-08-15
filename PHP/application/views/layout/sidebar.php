<aside class="main-sidebar">
  <!-- sidebar: style can be found in sidebar.less -->
  <section class="sidebar">
    <!-- sidebar menu: : style can be found in sidebar.less -->
    <ul class="sidebar-menu">
      <li>
        <a href="<?php echo base_url(); ?>main">
            <i class="fa fa-home"></i> <span>Home</span>
          </a>
      </li>
      <?php if (isset($_SESSION['role']) && $_SESSION['role'] == 2): ?>
      <?php  $this->load->view('layout/menu_options_branch_manager'); ?>
      <?php else:
       $this->load->view('layout/menu_options_admin'); 
      endif;
      ?>
      <li class="treeview">
        <a href="#">
            <i class="fa fa-dashboard"></i> <span>Orders</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
        <ul class="treeview-menu">
          <li><a href="<?php echo base_url(); ?>orders"><i class="fa fa-home"></i> Orders</a></li>
          <li><a href="<?php echo base_url(); ?>orders_history"><i class="fa fa-home"></i> History</a></li>
        </ul>
      </li>
      <li>
        <a href="<?php echo base_url(); ?>admin">
            <i class="fa fa-home"></i> <span>Admin</span>
          </a>
      </li>
    </ul>
     <!-- /.sidebar -->
  </section>
</aside>