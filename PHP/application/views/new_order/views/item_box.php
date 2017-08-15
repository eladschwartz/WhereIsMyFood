 <div class="col-md-6">
      <?php foreach ($items as $item): ?>
          <div class="col-md-4">
                    <!-- Widget: user widget style 1 -->
                    <div class="box box-widget widget-user">
                        <!-- Add the bg color to the header using any of the bg-* classes -->
                        <div class="widget-user-header" style="background-color:#79BEDB;">
                            <h3 class="widget-user-username"><?php echo $item->item_name ?> </h3>
                            <h3 class="widget-user-desc">$<?php echo $item->price ?> </h3>
                        </div>
                       
                        <div class="box-footer" style="background-color: #99CC99;">
                            <div class="row">
                                              <div class="col-md-12">
                                   <div class="widget-user-image" style="top:17px;left:44%;">
                            <?php
                               if ($item->image == "UPLOAD IMAGE") {
                                            echo '<img  src="' . base_url() . 'img/noimage.png" style="border:none;"  alt="UPLOAD IMAGE">';
                                        } else {
                                            echo '<img  style="border:none;witdh:110px"  src=' . $item->image . '>';
                                        }
                                        ?>
                           
                        </div>
                                </div>
                            </div>
                           <div class="row">
                                <div class="col-md-12">
                                    <div class="description-block">
                                        <p><?php echo $item->description ?></p>
                                    </div>
                                    <!-- /.description-block -->
                                </div>
                            </div>
                    
                         </div>
                        </div>
                    <!-- /.widget-user -->
                     </div> 
                      <?php endforeach; ?>
 </div>
                   


          
