<div class="col-lg-6">
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3 class="panel-title">Settings
                <div class="pull-right" style="margin-top: -8px">
                    <button id="add-new-setting" class="btn btn-success" type="button">New</button>
                </div>
            </h3>
        </div>
        <div class="panel-body">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Info</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($settings as $key => $value): ?>
                            <tr>
                                <td>
                                    <?php echo $value['setting_name'] ?>
                                </td>
                                <td>
                                        <?php
                                        if ($value['setting_name'] == "Currency") {
                                            if ($value['currency_id'] != null){
                                                ?>
                                                    <select id="currencies" name="currencies">
                                                   <?php  foreach($currencies as $currency): 
                                                     if ($currency->id == $value['currency_id']){
                                                        ?>  <option selected="selected" value=<?php echo $currency->id;?>>
                                                     <?php }else {?>
                                                            <option value=<?php echo $currency->id;?>>
                                                     <?php } ?>
                                                        <?php echo $currency->code.'('.$currency->symbol.')'; ?>
                                                     </option>
                                                       <?php endforeach; ?>
                                          </select>            
                                        <?php }else { ?>
                                             <select id="currencies" name="currencies">
                                             <?php  foreach($currencies as $currency): ?>
                                                          <option value=<?php echo $currency->id;?>>
                                                            <?php echo $currency->code.'('.$currency->symbol.')'; ?>
                                                     </option>
                                                       <?php endforeach; ?>
                                                        </select>     
                                       <?php }}  ?>  
                                </td>
                                <td>
                                    <div class="form-group">
                                        <button class="btn  btn-block btn-danger delete-btn-settings-table" value="<?php echo $value['id'] ?>" type="button">Delete</button>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>