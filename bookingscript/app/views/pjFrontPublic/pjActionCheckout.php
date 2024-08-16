<?php
include_once dirname(__FILE__) . '/elements/header.php';
$SEARCH = @$_SESSION[$controller->defaultStore]['search'];
$FORM = @$_SESSION[$controller->defaultForm];
$months = __('months', true);
$short_days = __('short_days', true);
ksort($months);
ksort($short_days);
$week_start = isset($tpl['option_arr']['o_week_start']) && in_array((int) $tpl['option_arr']['o_week_start'], range(0,6)) ? (int) $tpl['option_arr']['o_week_start'] : 0;
?>
<div class="pjTbs-body">
	<form id="pjTbsCheckoutForm_<?php echo $controller->_get->toString('index');?>" action="#" method="post" class="pjTbsCheckoutForm">
		<input type="hidden" name="lbs_checkout" value="1" />
		<div id="pjTbsCalendarLocale" style="display: none;" data-months="<?php echo implode("_", $months);?>" data-days="<?php echo implode("_", $short_days);?>" data-fday="<?php echo $week_start;?>"></div>
		
		<div class="pjTbs-service-list">
			<div class="pjTbs-service-list-row">
				<div class="row">
					<div class="col-sm-5 col-xs-12">
						<p><?php __('front_pickup_address');?>:</p>

						<p><strong><?php echo $SEARCH['pickup_address'];?> </strong></p>

						<p><small><?php echo $SEARCH['booking_date'];?>, <?php echo date($tpl['option_arr']['o_time_format'], strtotime($SEARCH['booking_time']));?></small></p>
					</div><!-- /.col-sm-5 -->

					<div class="col-sm-4 col-xs-12">
						<p><?php __('front_dropoff_address');?>:</p>
						
						<p><strong><?php echo $SEARCH['return_address'];?></strong></p>
					</div><!-- /.col-sm-4 -->

					<div class="col-sm-3 col-xs-12">
						<p><?php __('front_distance');?>:</p>
						
						<p><strong><?php echo $SEARCH['distance'];?> km</strong></p>
					</div><!-- /.col-sm-3 -->
				</div><!-- /.row -->
			</div><!-- /.pjTbs-service-list-row -->
			<?php
			$with_str = (int) $SEARCH['luggage'] >= 1 ? __('front_with_desc', true) : __('front_with_desc_2', true);
			$with_str = str_replace("{PASSENGERS}", $SEARCH['passengers'], $with_str);
			$with_str = str_replace("{LUGGAGE}", $SEARCH['luggage'], $with_str);
			$total_price = $tpl['fleet_arr']['start_fee'] + $SEARCH['passengers'] * $tpl['fleet_arr']['fee_per_person'] + $tpl['fleet_arr']['price'];
			?>
			<div class="pjTbs-service-list-row">
				<div class="row">
					<div class="col-sm-5 col-xs-12">
						<p><?php __('front_with');?>:</p>
						
						<p><em><?php echo $with_str;?> </em></p>
					</div><!-- /.col-sm-5 -->

					<div class="col-sm-4 col-xs-12">
						<p><?php __('front_ride');?>:</p>
						
						<p><em><?php echo pjSanitize::clean($tpl['fleet_arr']['fleet']);?> </em></p>
					</div><!-- /.col-sm-4 -->

					<div class="col-sm-3 text-right">
						<p><?php __('front_price');?>:</p>
						
						<p><strong><?php echo pjCurrency::formatPrice($total_price);?></strong></p>
					</div><!-- /.col-sm-3 -->
				</div><!-- /.row -->
			</div><!-- /.pjTbs-service-list-row -->
		</div><!-- /.pjTbs-service-list -->
		
		<div class="row">
			<div class="col-sm-6 col-xs-12">
				<div class="pjTbs-box">
					<div class="pjTbs-box-title"><?php __('front_personal_details');?></div><!-- /.pjTbs-box-title -->
					<?php
					if(!$controller->isFrontLogged())
					{
						$login_message = __('front_login_message', true);
						$login_message = str_replace("{STAG}", '<a href="#" class="pjCssLogin">', $login_message);
						$login_message = str_replace("{ETAG}", '</a>', $login_message);
						?>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group"><label><?php echo $login_message;?></label></div>
							</div>
						</div>
						<?php
					}else{
						$logout_message = __('front_logout_message', true);
						$logout_message = str_replace("{STAG}", '<a href="#" class="pjCssLogout">', $logout_message);
						$logout_message = str_replace("{ETAG}", '</a>', $logout_message);
						?>
						<div class="row">
							<div class="col-sm-12">
								<div class="form-group"><label><?php echo $logout_message;?></label></div>
							</div>
						</div>
						<?php
					}
					$CLIENT = $controller->isFrontLogged() ? $_SESSION[$controller->defaultClient] : array();
					
					if (in_array($tpl['option_arr']['o_bf_include_title'], array(2, 3)))
					{
						?>
						<div class="form-group">
							<label><?php __('front_title'); ?></label>
	
							<select name="c_title" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_title'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php __('front_required_field');?>">
								<option value="">----</option>
								<?php
								$title_arr = pjUtil::getTitles();
								$name_titles = __('personal_titles', true, false);
								foreach ($title_arr as $v)
								{
									?><option value="<?php echo $v; ?>"<?php echo isset($FORM['c_title']) && $FORM['c_title'] == $v ? ' selected="selected"' : (isset($CLIENT['title']) ? ($CLIENT['title'] == $v ? ' selected="selected"' : NULL ) : NULL); ?>><?php echo $name_titles[$v]; ?></option><?php
								}
								?>
							</select>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					} 
					if (in_array($tpl['option_arr']['o_bf_include_fname'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_fname'); ?></label>
							
							<input type="text" name="c_fname" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_fname'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_fname']) ? pjSanitize::clean($FORM['c_fname']) : (isset($CLIENT['fname']) ? pjSanitize::clean($CLIENT['fname']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_lname'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_lname'); ?></label>
							
							<input type="text" name="c_lname" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_lname'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_lname']) ? pjSanitize::clean($FORM['c_lname']) : (isset($CLIENT['lname']) ? pjSanitize::clean($CLIENT['lname']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_phone'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_phone'); ?></label>
							
							<input type="text" name="c_phone" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_phone'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_phone']) ? pjSanitize::clean($FORM['c_phone']) : (isset($CLIENT['phone']) ? pjSanitize::clean($CLIENT['phone']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_email'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_email'); ?></label>
							
							<input type="text" name="c_email" class="form-control email<?php echo ($tpl['option_arr']['o_bf_include_email'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_email']) ? pjSanitize::clean($FORM['c_email']) : (isset($CLIENT['email']) ? pjSanitize::clean($CLIENT['email']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>" data-msg-email="<?php __('front_email_validation');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_company'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_company'); ?></label>
							
							<input type="text" name="c_company" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_company'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_company']) ? pjSanitize::clean($FORM['c_company']) : (isset($CLIENT['company']) ? pjSanitize::clean($CLIENT['company']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_address'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_address'); ?></label>
							
							<input type="text" name="c_address" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_address'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_address']) ? pjSanitize::clean($FORM['c_address']) : (isset($CLIENT['address']) ? pjSanitize::clean($CLIENT['address']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_city'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_city'); ?></label>
							
							<input type="text" name="c_city" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_city'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_city']) ? pjSanitize::clean($FORM['c_city']) : (isset($CLIENT['city']) ? pjSanitize::clean($CLIENT['city']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_state'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_state'); ?></label>
							
							<input type="text" name="c_state" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_state'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_state']) ? pjSanitize::clean($FORM['c_state']) : (isset($CLIENT['state']) ? pjSanitize::clean($CLIENT['state']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_zip'], array(2, 3))){
						?>
						<div class="form-group">
							<label><?php __('front_zip'); ?></label>
							
							<input type="text" name="c_zip" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_zip'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_zip']) ? pjSanitize::clean($FORM['c_zip']) : (isset($CLIENT['zip']) ? pjSanitize::clean($CLIENT['zip']) : NULL);?>" data-msg-required="<?php __('front_required_field');?>"/>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_country'], array(2, 3)))
					{
						?>
						<div class="form-group">
							<label><?php __('front_country'); ?></label>
							
							<select name="c_country" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_country'] == 3) ? ' required' : NULL; ?>" data-msg-required="<?php __('front_required_field');?>">
								<option value="">----</option>
								<?php
								foreach ($tpl['country_arr'] as $v)
								{
									?><option value="<?php echo $v['id']; ?>"<?php echo isset($FORM['c_country']) ? ($FORM['c_country'] == $v['id'] ? ' selected="selected"' : NULL) : (isset($CLIENT['country_id']) ? ($CLIENT['country_id'] == $v['id'] ? ' selected="selected"' : NULL) : NULL) ; ?>><?php echo $v['country_title']; ?></option><?php
								}
								?>
							</select>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_notes'], array(2, 3)))
					{
						?>
						<div class="form-group">
							<label class="control-label"><?php __('front_notes');?></label>
	
							<textarea name="c_notes" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_notes'] == 3) ? ' required' : NULL; ?>" cols="30" rows="10" data-msg-required="<?php __('front_required_field');?>"><?php echo isset($FORM['c_notes']) ? pjSanitize::clean($FORM['c_notes']) : null;?></textarea>
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<?php
					}
					if($tpl['option_arr']['o_payment_disable'] == 'No')
					{
					    $plugins_payment_methods = pjObject::getPlugin('pjPayments') !== NULL? pjPayments::getPaymentMethods(): array();
					    $haveOnline = $haveOffline = false;
					    foreach ($tpl['payment_titles'] as $k => $v)
					    {
					        if( $k != 'cash' && $k != 'bank' )
					        {
					            if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
					            {
					                $haveOnline = true;
					                break;
					            }
					        }
					    }
					    foreach ($tpl['payment_titles'] as $k => $v)
					    {
					        if( $k == 'cash' || $k == 'bank' )
					        {
					            if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
					            {
					                $haveOffline = true;
					                break;
					            }
					        }
					    }
						?>
						<div class="form-group">
							<label><?php __('front_payment_medthod'); ?></label>
							
							<select id="trPaymentMethod_<?php echo $controller->_get->toString('index');?>" name="payment_method" class="form-control required" data-msg-required="<?php __('front_required_field');?>">
								<option value="">-- <?php __('lblChoose'); ?>--</option>
								<?php
								if ($haveOnline && $haveOffline)
								{
								    ?><optgroup label="<?php __('script_online_payment_gateway', false, true); ?>"><?php
			                    }
			                    foreach ($tpl['payment_titles'] as $k => $v)
			                    {
			                        if($k == 'cash' || $k == 'bank' ){
			                            continue;
			                        }
			                        if (array_key_exists($k, $plugins_payment_methods))
			                        {
			                            if(!isset($tpl['payment_option_arr'][$k]['is_active']) || (isset($tpl['payment_option_arr']) && $tpl['payment_option_arr'][$k]['is_active'] == 0) )
			                            {
			                                continue;
			                            }
			                        }
			                        ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
			                    }
			                    if ($haveOnline && $haveOffline)
			                    {
			                        ?>
			                    	</optgroup>
			                    	<optgroup label="<?php __('script_offline_payment', false, true); ?>">
			                    	<?php 
			                    }
			                    foreach ($tpl['payment_titles'] as $k => $v)
			                    {
			                        if( $k == 'cash' || $k == 'bank' )
			                        {
			                            if( (int) $tpl['payment_option_arr'][$k]['is_active'] == 1)
			                            {
			                                ?><option value="<?php echo $k; ?>"><?php echo $v; ?></option><?php
			                            }
			                        }
			                    }
			                    if ($haveOnline && $haveOffline)
			                    {
			                        ?></optgroup><?php
			                    }
								?>
							</select>
							
							<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
						</div><!-- /.form-group -->
						<div class="form-group pjTbsBankWrap" style="display: <?php echo @$FORM['payment_method'] != 'bank' ? 'none' : NULL; ?>">
							<label><?php __('front_bank_account')?></label>
							
							<div class="text-muted"><strong><?php echo nl2br(pjSanitize::html($tpl['bank_account'])); ?></strong></div>
						</div>
						<?php
					}
					if (in_array($tpl['option_arr']['o_bf_include_captcha'], array(2, 3)))
					{
						?>
						<div class="form-group">
							<label><?php __('front_captcha'); ?></label>
							<?php
							if($tpl['option_arr']['o_captcha_type_front'] == 'system')
							{
    							?>
    							<div class="row">
    								<div class="col-sm-6 col-xs-12">
    									<div class="form-group">
    										<input type="text" name="captcha" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_captcha'] == 3) ? ' required' : NULL; ?>" autocomplete="off" data-msg-required="<?php __('front_required_field'); ?>" data-msg-remote="<?php __('front_incorrect_captcha');?>"/>
    										<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
    									</div><!-- /.form-group -->
    								</div><!-- /.col-sm-6 -->
    	
    								<div class="col-sm-4 col-xs-12">
    									<img id="pjTbsImage_<?php echo $controller->_get->toString('index')?>" src="<?php echo PJ_INSTALL_URL; ?>index.php?controller=pjFrontEnd&amp;action=pjActionCaptcha&amp;rand=<?php echo rand(1, 99999); ?><?php echo $controller->_get->check('session_id') ? '&session_id=' . $controller->_get->toString('session_id') : NULL;?>" alt="Captcha" style="vertical-align: middle; cursor: pointer;" />
    								</div><!-- /.col-sm-6 -->
								</div><!-- /.row -->
								<?php
							}else {
							    ?>
							    <div id="g-recaptcha" class="g-recaptcha" data-sitekey="<?php echo $tpl['option_arr']['o_captcha_site_key_front'] ?>"></div>
								<input type="hidden" id="recaptcha" name="recaptcha" class="recaptcha<?php echo ($tpl['option_arr']['o_bf_include_captcha'] == 3) ? ' required' : NULL; ?>" autocomplete="off" data-msg-required="<?php __('front_4_v_captcha');?>" data-msg-remote="<?php __('front_4_v_captcha_incorrect');?>"/>
								<?php 
							}
							?>
						</div><!-- /.form-group -->
						<?php
					} 
					?>

					<div class="form-group">
						<div class="checkbox">
							<label><input type="checkbox" name="terms" class="required" data-msg-required="<?php __('front_required_field'); ?>"/>  <?php __('front_agree');?> <a href="#" class="pjTbModalTrigger" data-pj-toggle="modal" data-pj-target="#pjNcbTermModal" data-title="<?php __('front_terms_title');?>"><?php __('front_terms_conditions');?></a></label>
						</div>
						<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
					</div><!-- /.form-group -->
				</div><!-- /.pjTbs-car -->							
			</div><!-- /.col-sm-6 -->

			<div class="col-sm-6 col-xs-12">
				<?php
				if(in_array($tpl['option_arr']['o_bf_include_airline_company'], array(2, 3)) || 
				   in_array($tpl['option_arr']['o_bf_include_flight_number'], array(2, 3)) ||
				   in_array($tpl['option_arr']['o_bf_include_flight_time'], array(2, 3)) ||
				   in_array($tpl['option_arr']['o_bf_include_termial'], array(2, 3))
				  ){
					?>
					<div class="pjTbs-box">
						<div class="pjTbs-box-title"><?php __('front_flight_details');?></div><!-- /.pjTbs-box-title -->
						<div class="form-group">
							<span><?php __('front_flight_details_desc');?></span>
						</div>
						<?php
						if (in_array($tpl['option_arr']['o_bf_include_airline_company'], array(2, 3)))
						{
							?>
							<div class="form-group">
								<label><?php __('front_airline'); ?></label>
								
								<input type="text" name="c_airline_company" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_airline_company'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_airline_company']) ? pjSanitize::clean($FORM['c_airline_company']) : null;?>" data-msg-required="<?php __('front_required_field');?>"/>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.form-group -->
							<?php
						}
						if (in_array($tpl['option_arr']['o_bf_include_flight_number'], array(2, 3)))
						{
							?>
							<div class="form-group">
								<label><?php __('front_flight_number'); ?></label>
								
								<input type="text" name="c_flight_number" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_flight_number'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_flight_number']) ? pjSanitize::clean($FORM['c_flight_number']) : null;?>" data-msg-required="<?php __('front_required_field');?>"/>
								<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
							</div><!-- /.form-group -->
							<?php
						}
						
						if (in_array($tpl['option_arr']['o_bf_include_flight_time'], array(2, 3)) || in_array($tpl['option_arr']['o_bf_include_terminal'], array(2, 3)))
						{ 
							?>
							<div class="row">
								<?php
								if (in_array($tpl['option_arr']['o_bf_include_flight_time'], array(2, 3)))
								{ 
									?>
									<div class="col-md-6 col-sm-7 col-xs-12">
										<div class="form-group">
											<label class="control-label"><?php __('front_flight_time');?></label>
											<div class="input-group time-pick">
												<span class="input-group-addon">
													<span class="glyphicon glyphicon-time" aria-hidden="true"></span>
												</span>
			
												<input type="text" name="c_flight_time" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_flight_time'] == 3) ? ' required' : NULL; ?>" autocomplete="off" value="<?php echo isset($FORM['c_flight_time']) ? pjSanitize::clean($FORM['c_flight_time']) : null;?>" data-msg-required="<?php __('front_required_field');?>"/>
											</div>
											<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
										</div><!-- /.form-group -->
									</div><!-- /.col-sm-6 -->
									<?php
								}
								if (in_array($tpl['option_arr']['o_bf_include_terminal'], array(2, 3)))
								{ 
									?>
			
									<div class="col-md-6 col-sm-5 col-xs-12">
										<div class="form-group">
											<label><?php __('front_terminal'); ?></label>
											
											<input type="text" name="c_terminal" class="form-control<?php echo ($tpl['option_arr']['o_bf_include_terminal'] == 3) ? ' required' : NULL; ?>" value="<?php echo isset($FORM['c_terminal']) ? pjSanitize::clean($FORM['c_terminal']) : null;?>" data-msg-required="<?php __('front_required_field');?>"/>
											<div class="help-block with-errors"><ul class="list-unstyled"></ul></div>
										</div><!-- /.form-group -->
									</div><!-- /.col-sm-6 -->
									<?php
								} 
								?>
							</div><!-- /.row -->
							<?php
						}
					?>
					</div>
					<?php
				}
				?>
				<div id="pjTbsPriceBox" >
					<?php
					include_once dirname(__FILE__) . '/pjActionGetPrices.php';
					?>
				</div>
								
			</div><!-- /.col-sm-6 -->
		</div><!-- /.row -->
		<div class="pjTbs-body-actions">
			<div class="row">
				<div class="col-sm-3 col-xs-12">
					<a href="#" class="btn btn-secondary btn-block pjTbsBtnBack" data-load="loadFleets"><?php __('front_btn_back');?></a>
				</div><!-- /.col-sm-3 -->

				<div class="col-sm-3 col-sm-offset-6 col-xs-12">
					<input type="submit" value="<?php __('front_btn_preview');?>" class="btn btn-primary btn-block" >
				</div><!-- /.col-sm-3 -->
			</div><!-- /.row -->
		</div><!-- /.pjTbs-body-actions -->
	</form>
</div><!-- /.pjTbs-body -->