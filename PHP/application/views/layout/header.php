<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>WhereIsMyFood</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.6 -->
        <link rel="stylesheet" href="<?php echo base_url(); ?>bootstrap/css/bootstrap.min.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
        <!-- Ionicons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
        <!-- Theme style -->
        <link rel="stylesheet" href="<?php echo base_url(); ?>css/AdminLTE.css">
        <!-- AdminLTE Skins. Choose a skin from the css/skins
             folder instead of downloading all of them to reduce the load. -->
        <link rel="stylesheet" href="<?php echo base_url(); ?>css/skins/_all-skins.min.css">

        <link rel="stylesheet" href="<?php echo base_url(); ?>css/switch.css">


        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->

        <!-- jQuery 2.2.3 -->
        <script src="<?php echo base_url(); ?>plugins/jQuery/jquery-2.2.3.min.js"></script>
        <!-- Bootstrap 3.3.6 -->
        <script src="<?php echo base_url(); ?>bootstrap/js/bootstrap.min.js"></script>
        <!-- SlimScroll -->
        <script src="<?php echo base_url(); ?>plugins/slimScroll/jquery.slimscroll.min.js"></script>
        <!-- FastClick -->
        <script src="<?php echo base_url(); ?>plugins/fastclick/fastclick.js"></script>
        <!-- AdminLTE App -->
        <script src="<?php echo base_url(); ?>js/app.min.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="<?php echo base_url(); ?>js/demo.js"></script>
        <script src="<?php echo base_url(); ?>js/view_functions.js"></script>

        <script>
            $(document).ready(function () {
                //Log out user
                $(".sign-out-btn").click(function () {
                    $.ajax({
                        type: "post",
                        url: window.location.href + "/logout",
                        data: {
                            '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>'
                        },
                        success: function () {
                            window.location.href = "login";
                        }
                    });
                });

                //Keep Seesion Alive - don't log out user
                var sessionTimer = setInterval(function () {
                    $.ajax({
                        url: window.location.origin + '/login/keep_session_alive',
                        data: {
                            '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>',
                        },
                        beforeSend: function () {},
                        success: function (data) {
                            console.info(data);
                        }
                    });
                }, 120000);

                //Check for new orders
                var sessionTimer = setInterval(function () {
                    $.ajax({
                        url: window.location.origin + '/orders/check_if_new_order',
                        dataType: 'text',
                        data: {
                            '<?php echo $this->security->get_csrf_token_name(); ?>': '<?php echo $this->security->get_csrf_hash(); ?>'
                        },
                        beforeSend: function () {},
                        success: function (data) {
                            console.log(data);
                            if (data > 0) {
                                if (window.location.pathname === '/orders') {
                                    window.location = window.location
                                    document.location.href = String(document.location.href).replace("#/", "");
                                } else {
                                    isShown = ($("#modal-new-notifction").data('bs.modal') || {}).isShown;
                                    if (!isShown && window.location.pathname !== '/orders') {
                                        $('#modal-new-notifction').modal('show');
                                    }
                                }

                            }
                        }
                    });
                }, 60000);


            });
        </script>


    </head>
    <body class="hold-transition skin-blue sidebar-mini">
        <!-- Site wrapper -->
        <div class="wrapper">

            <header class="main-header">
                <!-- Logo -->
                <a href="<?php echo base_url(); ?>main" class="logo">
                    <!-- mini logo for sidebar mini 50x50 pixels -->
                    <span class="logo-mini"><b>D</b>Q</span>
                    <!-- logo for regular state and mobile devices -->
                    <span class="logo-lg"><b>WhereIsMyFood</b></span>
                </a>
                <!-- Header Navbar: style can be found in header.less -->
                <nav class="navbar navbar-static-top">
                    <!-- Sidebar toggle button-->
                    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                        <span class="sr-only">Toggle navigation</span>
                    </a>

                    <div class="navbar-custom-menu">
                        <ul class="nav navbar-nav">

                            <!-- Notifications: style can be found in dropdown.less -->
                            <li class="dropdown notifications-menu" id="new-orders-notifications">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                    <i class="fa fa-bell-o"></i>
                                    <span class="label label-warning"><?php echo $total_orders_count ?></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <li class="header">You have <?php echo $total_orders_count ?> new orders</li>
                                    <li>
                                        <!-- inner menu: contains the actual data -->
                                        <ul class="menu">
                                            <li>
                                                <a href="#">
                                                    <?php foreach ($new_orders as $order): ?>
                                                        <p>
                                                            <i></i> <?php echo $order->order_id . '-' . $order->customer_name ?>
                                                        </p>
                                                    <?php endforeach; ?>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="footer"><a href="#">View all</a></li>
                                </ul>
                            </li>
                            <li>
                                <!-- Sign Out Button-->
                                <a href="#" class="sign-out-btn">
                                    <i class="fa fa-fw fa-sign-out"></i>
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </header>


            <script>
             var csfrData = {};
                csfrData['<?php echo $this->security->get_csrf_token_name(); ?>']
                        = '<?php echo $this->security->get_csrf_hash(); ?>';
            </script>