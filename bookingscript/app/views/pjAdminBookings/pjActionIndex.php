<?php 
$titles = __('error_titles', true);
$bodies = __('error_bodies', true);
$months = __('months', true);
ksort($months);
$short_days = __('short_days', true);
$bs = __('booking_statuses', true);
$get = $controller->_get->raw();
?>
<div id="datePickerOptions" style="display:none;" data-wstart="<?php echo (int) $tpl['option_arr']['o_week_start']; ?>" data-format="<?php echo $tpl['date_format']; ?>" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>"></div>
<div class="row wrapper border-bottom white-bg page-heading">
	<div class="col-sm-12 bookings-page-heading">
		<div class="row">
			<div class="col-sm-10">
				<h2><?php __('infoReservationListTitle');?></h2>
			</div>
		</div><!-- /.row -->

		<p class="m-b-none"><i class="fa fa-info-circle"></i><?php __('infoReservationListDesc');?></p>
	</div><!-- /.col-md-12 -->
	
</div>

<div class="wrapper wrapper-content animated fadeInRight">
	<?php
	$error_code = $controller->_get->toString('err');
	if (!empty($error_code))
	{
		switch (true)
		{
			case in_array($error_code, array('ABB01', 'ABB03')):
				?>
				<div class="alert alert-success">
					<i class="fa fa-check m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code];?>
				</div>
				<?php 
				break;
			case in_array($error_code, array('ABB04', 'ABB08', 'ABB09', 'ABB10')):	
				?>
				<div class="alert alert-danger">
					<i class="fa fa-exclamation-triangle m-r-xs"></i>
					<strong><?php echo @$titles[$error_code]; ?></strong>
					<?php echo @$bodies[$error_code];?>
				</div>
				<?php
				break;
		}
	} 
	?>
	<div class="row">
		<div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-content cardealer-no-border">
					<form action="" method="get" class="form-horizontal frm-filter">
    					<div class="row m-b-md">
    						<div class="col-sm-3">
    						<?php 
                            if ($tpl['has_create'])
                            {
                            	?>
    							<a href="<?php echo $_SERVER['PHP_SELF']; ?>?controller=pjAdminBookings&amp;action=pjActionCreate" class="btn btn-primary"><i class="fa fa-plus m-r-xs"></i> <?php __('btnAddEnquiry'); ?></a>
    							<?php 
                            }
                            ?>
    						</div>
    						<div class="col-md-3 col-sm-5">
    							
								<div class="input-group">
									<input type="text" name="q" placeholder="<?php __('btnSearch', false, true); ?>" class="form-control">
									<div class="input-group-btn">
										<button class="btn btn-primary" type="submit">
											<i class="fa fa-search"></i>
										</button>
									</div>
								</div>
    							
                            </div>
                            <div class="col-lg-2 col-md-3 col-sm-4">&nbsp;</div><!-- /.col-md-2 -->
    						<div class="col-lg-2 col-lg-offset-2 col-md-12 text-right">
    							<select class="form-control pj-filter-status" name="status">
    								<option value="">-- <?php __('lblAll');?> --</option>
    								<?php foreach ($bs as $k => $v) { ?>
    									<option value="<?php echo $k;?>"><?php echo pjSanitize::html($v);?></option>
    								<?php } ?>
    							</select>
    						</div>
    					</div>				
					</form>
					<div id="grid"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var pjGrid = pjGrid || {};
pjGrid.queryString = "";
<?php
if ($controller->_get->toInt('fleet_id') > 0)
{
    ?>pjGrid.queryString += "&fleet_id=<?php echo $controller->_get->toInt('fleet_id'); ?>";<?php
}
if ($controller->_get->toInt('client_id') > 0)
{
    ?>pjGrid.queryString += "&client_id=<?php echo $controller->_get->toInt('client_id'); ?>";<?php
}
if ($controller->_get->has('date'))
{
    ?>pjGrid.queryString += "&date=<?php echo $controller->_get->toString('date'); ?>";<?php
}
?>
var myLabel = myLabel || {};
myLabel.client = <?php x__encode('lblClient', false, true); ?>;
myLabel.fleet = <?php x__encode('lblFleet', false, true); ?>;
myLabel.distance = <?php x__encode('lblDistance', false, true); ?>;
myLabel.date_time = <?php x__encode('lblDateTime', false, false); ?>;
myLabel.email = <?php x__encode('email', false, true); ?>;
myLabel.status = <?php x__encode('lblStatus'); ?>;
myLabel.exported = <?php x__encode('lblExport', false, true); ?>;
myLabel.print = <?php x__encode('lblPrint', false, true); ?>;
myLabel.delete_selected = <?php x__encode('delete_selected', false, true); ?>;
myLabel.delete_confirmation = <?php x__encode('delete_confirmation', false, true); ?>;
myLabel.pending = <?php echo x__encode('booking_statuses_ARRAY_pending'); ?>;
myLabel.confirmed = <?php echo x__encode('booking_statuses_ARRAY_confirmed'); ?>;
myLabel.cancelled = <?php echo x__encode('booking_statuses_ARRAY_cancelled'); ?>;
</script>