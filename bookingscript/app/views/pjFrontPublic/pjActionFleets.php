<?php
include_once dirname(__FILE__) . '/elements/header.php';
$SEARCH = @$_SESSION[$controller->defaultStore]['search'];
$passengers = !empty($SEARCH['passengers']) ? $SEARCH['passengers'] : 0;
$luggage = !empty($SEARCH['luggage']) ? $SEARCH['luggage'] : 0;
$distance = !empty($SEARCH['distance']) ? $SEARCH['distance'] : 0;
$time_str = (int) $SEARCH['luggage'] >= 1 ? __('front_taxi_on', true) : __('front_taxi_on_2', true);
$time_str = str_replace("{DATE}", $SEARCH['booking_date'], $time_str);
$time_str = str_replace("{TIME}", date($tpl['option_arr']['o_time_format'], strtotime($SEARCH['booking_time'])), $time_str);
$time_str = str_replace("{PASSENGERS}", $SEARCH['passengers'], $time_str);
$time_str = str_replace("{LUGGAGES}", $SEARCH['luggage'], $time_str);
?>
<div class="pjTbs-body">
	<div class="pjTbs-service-info">
		<div class="row">
			<div class="col-md-12 col-xs-12">
				<?php if (!empty($tpl['fleet_arr'])): ?>
					<p><?php __('front_taxi_service_from');?> <strong><?php echo pjSanitize::html($SEARCH['pickup_address']); ?></strong> <?php __('front_to_lowercase');?> <strong><?php echo pjSanitize::html($SEARCH['return_address']); ?></strong> <?php echo $time_str;?></p>
				<?php else: ?>
					<p><?php __('lblNoServicesAvailable'); ?></p>
				<?php endif; ?>
			</div><!-- /.col-md-10 -->
		</div><!-- /.row -->
	</div><!-- /.pjTbs-service-info -->

	<?php
	if(!empty($tpl['fleet_arr']))
	{ 
		foreach($tpl['fleet_arr'] as $k => $v)
		{
			$image = PJ_INSTALL_URL . PJ_IMG_PATH . 'frontend/250x130.png';
			if(isset($v['thumb_path']) && !empty($v['thumb_path']) && file_exists(PJ_INSTALL_PATH . $v['thumb_path']))
			{
				$image = PJ_INSTALL_URL . $v['thumb_path'];
			}
			?>
			<div class="pjTbs-car pjTbs-box">
				<div class="pjTbs-car-title"><?php echo pjSanitize::html($v['fleet']);?></div><!-- /.pjTbs-car-title -->
		
				<div class="row">
					<div class="col-sm-3 col-xs-12">
						<div class="pjTbs-car-image">
							<img src="<?php echo $image;?>" alt="" class="img-responsive">
						</div><!-- /.pjTbs-car-image -->
					</div><!-- /.col-md-3 -->
		
					<div class="col-sm-6 col-xs-12">
						<div class="pjTbs-car-desc">
							<ul class="pjTbs-car-meta">
								<li><?php __('front_passengers');?>: <?php for($p = 1; $p <= (int) $v['passengers']; $p++) {?><span class="glyphicon glyphicon-user"></span><?php }?> </li>
								<li><?php __('front_bags');?>: <?php for($p = 1; $p <= (int) $v['luggage']; $p++) {?><span class="glyphicon glyphicon-briefcase"></span><?php }?> </li>
							</ul><!-- /.pjTbs-car-meta -->		
		
							<div class="pjTbs-car-info"><?php echo nl2br(pjSanitize::clean($v['description']));?></div><!-- /.pjTbs-car-info -->
						</div><!-- /.pjTbs-car-desc -->		
					</div><!-- /.col-md-3 -->
					<div class="col-sm-3 col-xs-12">
						<div class="pjTbs-car-actions">
							<?php
							$total = $v['start_fee'];
							$total += $distance * $v['price'];
							$total += $passengers * $v['fee_per_person'];
							?>
							<div class="pjTbs-price-holder">
								<div class="pjTbs-price">
									<span><?php __('front_start_fee');?>: <?php echo pjCurrency::formatPrice($v['start_fee']);?></span><br/>
									<span><?php __('front_people');?>: <?php echo $passengers; ?> x <?php echo pjCurrency::formatPrice($v['fee_per_person']);?></span><br/>
									<span><?php __('front_distance');?>: <?php echo $distance; ?>km x <?php echo pjCurrency::formatPrice($v['price']);?></span><br/>
									<strong><?php __('front_total');?>: <?php echo pjCurrency::formatPrice($total);?></strong>
								</div><!-- /.pjTbs-price -->
							</div><!-- /.pjTbs-price-holder -->
	
							<input type="button" value="<?php __('front_btn_book_a_taxi');?>" data-id="<?php echo $v['id']?>" class="btn btn-primary btn-block pjTbsBtnBookTaxi">
							
						</div><!-- /.pjTbs-car-actions -->	
					</div><!-- /.col-md-3 -->
				</div><!-- /.row -->
			</div><!-- /.pjTbs-car -->
			<?php
		}
	}
	?>
	<div class="pjTbs-body-actions">
		<br>

		<div class="row">
			<div class="col-sm-3 col-xs-12">
				<a href="#" class="btn btn-secondary btn-block pjTbsBtnBack" data-load="loadSearch"><?php __('front_btn_back');?></a>
			</div><!-- /.col-sm-3 -->
		</div><!-- /.row -->
	</div><!-- /.pjTbs-body-actions -->
</div><!-- /.pjTbs-body -->