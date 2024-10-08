<?php
include_once dirname(__FILE__) . '/elements/header.php';
$SEARCH = @$_SESSION[$controller->defaultStore]['search'];
$months = __('months', true);
$short_days = __('short_days', true);
ksort($months);
ksort($short_days);
$week_start = isset($tpl['option_arr']['o_week_start']) && in_array((int) $tpl['option_arr']['o_week_start'], range(0,6)) ? (int) $tpl['option_arr']['o_week_start'] : 0;
?>
<div class="pjTbs-body">
	<form id="pjTbsSearchForm_<?php echo $controller->_get->toString('index');?>" action="#" method="post" class="pjTbsSearchForm">
		<input type="hidden" name="tbs_search" value="1" />
		<div id="pjTbsCalendarLocale" style="display: none;" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>" data-fday="<?php echo $week_start;?>"></div>
		<div class="pjTbs-box">
			<div class="pjTbs-box-title"><?php __('front_booking_details');?></div><!-- /.pjTbs-box-title -->
	
			<div class="row">
				<div class="col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="control-label"><?php __('front_pickup_address');?></label>
	
						<input type="text" id="pickup_address_<?php echo $controller->_get->toString('index');?>" name="pickup_address" value="<?php echo isset($SEARCH['pickup_address']) ? pjSanitize::clean($SEARCH['pickup_address']) : NULL;?>" class="form-control required pjTbsAddress" data-msg-required="<?php __('front_required_field');?>">
						<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
					</div><!-- /.form-group -->

					<div class="form-group">
						<label class="control-label"><?php __('front_dropoff_address');?></label>
	
						<input type="text" id="return_address_<?php echo $controller->_get->toString('index');?>" name="return_address" value="<?php echo isset($SEARCH['return_address']) ? pjSanitize::clean($SEARCH['return_address']) : NULL;?>" class="form-control required pjTbsAddress" data-msg-required="<?php __('front_required_field');?>">
						<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
					</div><!-- /.form-group -->
				</div>

				<div class="col-sm-6 col-xs-12">
					<label><?php __('front_passengers');?></label>
					
					<div class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-user" aria-hidden="true"></span>
							</span>
					
							<div class="btn-group pjTbs-spinner" role="group" aria-label="...">
					            						<button type="button" class="btn pjTbs-spinner pjTbs-spinner-down">-</button>
					
								<input type="text" name="passengers" class="pjTbs-spinner-result digits" maxlength="3" value="<?php echo isset($SEARCH['passengers']) ? $SEARCH['passengers'] : 1;?>" data-msg-digits="<?php __('front_digits_validation');?>">
					
								<button type="button" class="btn pjTbs-spinner pjTbs-spinner-up">+</button>
							</div>
						</div>
						<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
					</div><!-- /.form-group --><!-- /.col-sm-6 -->
					
					<label><?php __('front_pieces_of_luggage');?></label>
					
					<div class="form-group">
						<div class="input-group">
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-briefcase" aria-hidden="true"></span>
							</span>
					
							<div class="btn-group pjTbs-spinner" role="group" aria-label="...">
					            						<button type="button" class="btn pjTbs-spinner pjTbs-spinner-down">-</button>
					
								<input type="text" name="luggage" class="pjTbs-spinner-result digits" maxlength="3" value="<?php echo isset($SEARCH['luggage']) ? $SEARCH['luggage'] : NULL;?>" data-msg-digits="<?php __('front_digits_validation');?>">
					
								<button type="button" class="btn pjTbs-spinner pjTbs-spinner-up">+</button>
							</div>
						</div>
						<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
					</div><!-- /.form-group --><!-- /.col-sm-6 --><!-- /.row -->
				</div><!-- /.col-sm-6 -->
	
				<div class="col-sm-6 col-xs-12">
					<label class="control-label"><?php __('front_date_time');?></label>
	
					<div class="row">
						<div class="col-md-6 col-sm-7 col-xs-12">
							<div class="form-group">
								<div class="input-group date-pick">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
									</span>
			
									<input type="text" name="booking_date" value="<?php echo isset($SEARCH['booking_date']) ? $SEARCH['booking_date'] : NULL;?>" class="form-control required" readonly="readonly" data-msg-required="<?php __('front_required_field');?>"/>
								</div>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.form-group -->
						</div><!-- /.col-sm-6 -->
	
						<div class="col-md-6 col-sm-5 col-xs-12">
							<div class="form-group">
								<div class="input-group time-pick">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-time" aria-hidden="true"></span>
									</span>
	
									<input type="text" name="booking_time" value="<?php echo isset($SEARCH['booking_time']) ? $SEARCH['booking_time'] : NULL;?>" class="form-control required" readonly data-msg-required="<?php __('front_required_field');?>"/>
								</div>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.form-group -->
						</div><!-- /.col-sm-6 -->
					</div><!-- /.row -->
				</div><!-- /.col-sm-6 -->

				<div class="col-sm-6 col-xs-12">
					<label class="control-label"><?php __('front_distance');?>:</label>

					<div class="pjTbs-distance">
						<input type="text" id="pjTbsDistanceFiled" name="distance" name="booking_date" value="<?php echo isset($SEARCH['distance']) ? $SEARCH['distance'] : NULL;?>" class="required number" data-msg-required="<?php __('front_required_field');?>" data-msg-number="<?php __('front_number_validation');?>" readonly="readonly"/> km</div>
					<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
				</div>
			</div><!-- /.row -->
	
			<div class="pjTbs-body-actions">		
				<input value="<?php __('front_btn_book_a_taxi');?>" class="btn btn-primary" type="submit">
			</div>
	
			<div class="pjTbs-map" id="pjTbsMapCanvas"></div>
		</div><!-- /.pjTbs-box -->
	</form>
</div><!-- /.pjTbs-body -->