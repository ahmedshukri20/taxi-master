<?php
if(!empty($tpl['avail_extra_arr']))
{
    ?>
    <div class="hr-line-dashed"></div>
    <div class="row">
    	<div class="col-lg-6 col-md-6 col-sm-12">
    		<div class="table-responsive table-responsive-secondary">
    			<table class="table table-striped table-hover" id="tblExtras">
					<thead>
    					<tr>
    						<th>&nbsp;</th>
    						<th><?php __('lblExtraName');?></th>
    						<th><?php __('lblPrice');?></th>
    					</tr>
    				</thead>
					<tbody>
						<?php
						foreach($tpl['avail_extra_arr'] as $k => $v)
						{
						    ?>
							<tr>
								<td><input type="checkbox" name="extra_id[]" value="<?php echo $v['extra_id']?>" class="i-checks pjAvailExtra" data-price="<?php echo $v['price'];?>" data-per="<?php echo $v['per']?>"/></td>
								<td><?php echo pjSanitize::html($v['name']);?></td>
								<td><?php echo pjCurrency::formatPrice($v['price']) . ($v['per'] == 'person' ? ' ' . __('lblPerPerson', true) : '');?></td>
							</tr>
							<?php
						}
    					?>
					</tbody>
				</table>
    		</div>
    	</div>
    </div>
    <?php
}
?>