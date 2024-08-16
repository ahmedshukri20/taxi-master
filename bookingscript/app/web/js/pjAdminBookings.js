var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var 
			$frmCreateBooking = $('#frmCreateBooking'),
			$frmUpdateBooking = $('#frmUpdateBooking'),
			$modalCancellation = $("#modalCancellation"),
			$modalConfirmation = $("#modalConfirmation"),
			$modalSmsConfirmation = $("#modalSmsConfirmation"),
			datagrid = ($.fn.datagrid !== undefined),
			datetimeOptions = null;;
	
		
		if($frmUpdateBooking.length > 0)
		{
			var passengers = parseInt($( "#passengers" ).attr('data-value'), 10);
			var luggage = parseInt($( "#luggage" ).attr('data-value'), 10);
			if(passengers > 0)
			{
				$( "#passengers" ).trigger("touchspin.updatesettings", {max: passengers});
				$( "#passengers" ).on('touchspin.on.startspin', function () {calcPrice();});
			}
			if(luggage > 0)
			{
				$( "#luggage" ).trigger("touchspin.updatesettings", {max: luggage});
			}
			if($('.i-checks').length > 0)
			{
				$('.i-checks').iCheck({
		            checkboxClass: 'icheckbox_square-green',
		            radioClass: 'iradio_square-green'
		        });
				$('input').on('ifChanged', function (event) { $(event.target).trigger('change'); });
			}
		}
		
		function calcDistance() {
			var start = document.getElementById('pickup_address').value;
			var end = document.getElementById('return_address').value;
			if(start != '' && end != '')
			{
				var request = {
					origin: start,
				    destination: end,
				    travelMode: 'DRIVING'
				};
				directionsService.route(request, function(response, status) {
					if (status == google.maps.DirectionsStatus.OK) {
						var distanceinkm = parseInt(response.routes[0].legs[0].distance.value / 1000, 10);
						$('#distance').val(distanceinkm);
				    }
				});
			}else{
				$('#distance').val("");
			}
			calcPrice();
		}
		if ($frmCreateBooking.length > 0 || $frmUpdateBooking.length > 0) 
		{
			var directionsService = new google.maps.DirectionsService();
			
			if($('#pickup_address').length > 0)
			{
				var autocomplete_pickup = new google.maps.places.Autocomplete($('#pickup_address')[0], {
					types: ["geocode"]
				});
				
				var pickup_field = document.getElementById('pickup_address');
				google.maps.event.addDomListener(pickup_field, 'keydown', function(e) { 
				    if (e.keyCode == 13) { 
				        e.preventDefault(); 
				    }
				});
				google.maps.event.addListener(autocomplete_pickup, 'place_changed', function() {
					calcDistance();
				});
			}
			if($('#return_address').length > 0)
			{
				var autocomplete_return = new google.maps.places.Autocomplete($('#return_address')[0], {
					types: ["geocode"]
				});
				var return_field = document.getElementById('return_address');
				google.maps.event.addDomListener(return_field, 'keydown', function(e) { 
				    if (e.keyCode == 13) { 
				        e.preventDefault(); 
				    }
				});
				google.maps.event.addListener(autocomplete_return, 'place_changed', function() {
					calcDistance();
				});
			}
			if($('#client_id').length == 0)
			{
				$('.clientRequired').addClass('required');
			}
			$.validator.addMethod('positiveNumber', function (value) { 
				return Number(value) >= 0;
			}, myLabel.positive_number);
			
			$.validator.addMethod('maximumNumber', function (value, element) { 
				var data = parseInt($(element).attr('data-value'), 10);
				if(Number(value) > data)
				{
					return false;
				}else{
					return true;
				}
			}, myLabel.max_number);
			
			$frmCreateBooking.validate({
				rules: {
					passengers: {
						positiveNumber: true,
						maximumNumber: true
					},
					luggage: {
						positiveNumber: true,
						maximumNumber: true
					},
					c_email: {
						email: true,
						remote: 'index.php?controller=pjAdminBookings&action=pjActionCheckEmail'
					}
				},
				messages: {
					c_email: {
						remote: myLabel.email_already_exist
					}
				},
				onkeyup: false,
				ignore: "",
				invalidHandler: function (event, validator) {
				    if (validator.numberOfInvalids()) {
				    	var $_id = $(validator.errorList[0].element, this).closest("div.tab-pane").attr("id");
				    	$('[data-toggle="tab"][href="#' + $_id + '"]' ).trigger( 'click' );
				    };
				},
			});
			$frmUpdateBooking.validate({
				rules:{
					"return_date":{
						required: function(){
							if($('#has_return').is(':checked'))
							{
								return true;
							}else{
								return false;
							}
						}
					},
					uuid: {
						required: true,
						remote: "index.php?controller=pjAdminBookings&action=pjActionCheckID&id=" + $frmUpdateBooking.find("input[name='id']").val()
					},
					passengers: {
						positiveNumber: true,
						maximumNumber: true
					},
					luggage: {
						positiveNumber: true,
						maximumNumber: true
					},
					c_email: {
						email: true,
						remote: {
							type: 'post',
							url: "index.php?controller=pjAdminBookings&action=pjActionCheckEmail",
							data:{
								c_email: function()
						        {
									if($frmUpdateBooking.find("input[name='new_client']").is(":checked"))
									{
										return $frmUpdateBooking.find("input[name='c_email']").val();	
									}else{
										return false;
									}
						        }
							}
						}
					}

				},
				messages:{
					uuid: {
						remote: myLabel.duplicated_id
					},
					c_email: {
						remote: myLabel.email_already_exist
					}
				},
				onkeyup: false,
				ignore: "",
				invalidHandler: function (event, validator) {
				    if (validator.numberOfInvalids()) {
				    	var $_id = $(validator.errorList[0].element, this).closest("div.tab-pane").attr("id");
				    	$('[data-toggle="tab"][href="#' + $_id + '"]' ).trigger( 'click' );
				    };
				},
			});
			
			
			if ($('#dateTimePickerOptions').length) {
				
	        	var currentDate = new Date(),
	        		$optionsEle = $('#dateTimePickerOptions');
	        	
		        moment.updateLocale('en', {
					week: { dow: parseInt($optionsEle.data('wstart'), 10) },
					months : $optionsEle.data('months').split("_"),
			        weekdaysMin : $optionsEle.data('days').split("_")
				});
		        datetimeOptions = {
						format: $optionsEle.data('format'),
						locale: moment.locale('en'),
						allowInputToggle: true,
						ignoreReadonly: true,
						useCurrent: false
					};
		        $('.datetimepick').datetimepicker(datetimeOptions);
		        
		        if($('.pjCrTimePicker').length > 0)
		        {
		        	$('.pjCrTimePicker').datetimepicker({
						format: $optionsEle.data('timeformat'),
						ignoreReadonly: true,
						allowInputToggle: true
					});	
		        }
	        }
			$(".field-int").TouchSpin({
	            verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white',
	            min: 1,
	            max: 4294967295
			});
			if ($(".select-item").length) {
	            $(".select-item").select2({
	                placeholder: myLabel.choose ,
	                allowClear: true
	            });
	        };
		}
		if ($("#grid").length > 0 && datagrid) {
			
			function formatStatus(val, obj) {
				if(val == 'confirmed')
				{
					return '<div class="btn bg-confirmed btn-xs no-margin"><i class="fa fa-check"></i> ' + myLabel.confirmed + '</div>';
				}else if(val == 'cancelled'){
					return '<div class="btn bg-cancelled btn-xs no-margin"><i class="fa fa-times"></i> ' + myLabel.cancelled + '</div>';
				}else if(val == 'pending'){
					return '<div class="btn bg-pending btn-xs no-margin"><i class="fa fa-exclamation-triangle"></i> ' + myLabel.pending + '</div>';
				}
			}
			
			var $grid = $("#grid").datagrid({
				buttons: [{type: "print", target: "_blank", url: "index.php?controller=pjAdminBookings&action=pjActionPrint&id={:id}"},
				          {type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"},
				          {type: "delete", url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBooking&id={:id}"}
						  ],
				columns: [
				          {text: myLabel.client, type: "text", sortable: false},
				          {text: myLabel.fleet, type: "text", sortable: false},
				          {text: myLabel.distance, type: "text", sortable: false},
				          {text: myLabel.date_time, type: "text", sortable: false},
				          {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatStatus}],
				dataUrl: "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString,
				dataType: "json",
				fields: ['client', 'fleet', 'distance', 'date_time', 'status'],
				paginator: {
					actions: [
					   {text: myLabel.delete_selected, url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBookingBulk", render: true, confirmation: myLabel.delete_confirmation},
					   {text: myLabel.exported, url: "index.php?controller=pjAdminBookings&action=pjActionExportBooking", render: false, ajax: false},
					   {text: myLabel.print, url: "javascript:void(0);", render: false}
					],
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminBookings&action=pjActionSaveBooking&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'
				},
			});
		}
		
		$(document).on("focusin", ".timepick", function (e) {
			var minDateTime, maxDateTime,
				$this = $(this),
				custom = {},
				o = {
					timeFormat: $this.attr("lang"),
					stepMinute: 5,
					timeOnly: true
				};
			$(this).datetimepicker(o);
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val(),
				status: $this.find("select[name='status']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString, "created", "DESC", content.page, content.rowCount);
			return false;
		}).on("change", ".pj-filter-status", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(".frm-filter").trigger("submit");
			return false;
		}).on("change", "#fleet_id", function (e) {
			
			var passengers = parseInt($('#fleet_id').find(':selected').attr('data-passengers'), 10),
				luggage = parseInt($('#fleet_id').find(':selected').attr('data-luggage'), 10),
				curr_passengers = parseInt($('#passengers').val(),10),
				curr_luggage = parseInt($("#luggage").val(), 10);
			if(passengers > 0)
			{
				$('#tr_max_passengers').html("("+myLabel.maximum+" "+passengers+")");
				$( "#passengers" ).trigger("touchspin.updatesettings", {max: passengers});
				$( "#passengers" ).on('touchspin.on.startspin', function () {calcPrice();});
				if(curr_passengers > passengers)
				{
					$( "#passengers" ).val("");
				}
				$( "#passengers" ).attr('data-value', passengers);
			}
			if(luggage > 0)
			{
				$('#tr_max_luggage').html("("+myLabel.maximum+" "+luggage+")");
				$( "#luggage" ).trigger("touchspin.updatesettings", {max: luggage});
				if(curr_luggage > luggage)
				{
					$( "#luggage").val("");
				}
				$( "#luggage" ).attr('data-value', luggage);
			}
			getExtras();
		}).on("change", ".pjAvailExtra", function (e) {
			calcPrice();
		}).on("change", ".onoffswitch-client .onoffswitch-checkbox", function (e) {
			if ($(this).prop('checked')) {
                $('.current-client-area').hide();
                $('.current-client-area').find('.fdRequired').removeClass('required');
                $('.new-client-area').show();
                $('.new-client-area').find('.fdRequired').addClass('required');
            }else {
                $('.current-client-area').show();
                $('.current-client-area').find('.fdRequired').addClass('required');
                $('.new-client-area').hide();
                $('.new-client-area').find('.fdRequired').removeClass('required');
                $('#c_email').val("").valid();
            }
		});
		
		$("#grid").on("click", 'a.pj-paginator-action:last', function (e) {
			e.preventDefault();
			var booking_id = $('.pj-table-select-row:checked').map(function(e){
				 return $(this).val();
			}).get();
			if(booking_id != '' && booking_id != null)
			{
				window.open('index.php?controller=pjAdminBookings&action=pjActionPrint&record=' + booking_id,'_blank');
			}	
			return false;
		});
		function getExtras()
		{
			var $frm = null;
			if($frmCreateBooking.length > 0)
			{
				$frm = $frmCreateBooking;
			}
			if($frmUpdateBooking.length > 0)
			{
				$frm = $frmUpdateBooking;
			}
			$.post("index.php?controller=pjAdminBookings&action=pjActionGetExtras", $frm.serialize()).done(function (data) {
				$('#extraBox').html(data);
				if($('.i-checks').length > 0)
				{
					$('.i-checks').iCheck({
			            checkboxClass: 'icheckbox_square-green',
			            radioClass: 'iradio_square-green'
			        });
					$('input').on('ifChanged', function (event) { $(event.target).trigger('change'); });
				}
				calcPrice();
			});	
		}
		function calcPrice()
		{
			var passengers = $('#passengers').val() != "" ? parseInt($('#passengers').val(), 10) : 0;
			var fleet_id = $('#fleet_id').val() != "" ? parseInt($('#fleet_id').val(), 10) : 0;
			var distance = $('#distance').val() != "" ? parseFloat($('#distance').val()) : 0;
			
			if(passengers > 0 && fleet_id > 0)
			{
				if($('.pjAvailExtra').length > 0)
				{
					var params = $('.pjAvailExtra').serializeArray();
					params.push({name: "fleet_id", value: fleet_id});
					params.push({name: "passengers", value: passengers});
					params.push({name: "distance", value: distance});
				}else{
					var params = {};
					params.fleet_id = fleet_id;
					params.passengers = passengers;
					params.distance = distance;
				}
				
				$.post(["index.php?controller=pjAdminBookings&action=pjActionCalPrice"].join(""), params).done(function (data) {
					if(parseFloat(data.subtotal) > 0)
					{
						$('#sub_total').val((data.subtotal).toFixed(2));
						$('#tax').val((data.tax).toFixed(2));
			    		$('#total').val((data.total).toFixed(2));
			    		$('#deposit').val((data.deposit).toFixed(2));
					}else{
						$('#sub_total').val("");
						$('#tax').val("");
						$('#total').val("");
						$('#deposit').val("");
					}
				}).fail(function () {
					$('#sub_total').val("");
					$('#tax').val("");
					$('#total').val("");
					$('#deposit').val("");
				});
			}else{
				$('#sub_total').val("");
				$('#tax').val("");
				$('#total').val("");
				$('#deposit').val("");
			}
		}
		
		function attachTinyMce(options) {
			if (window.tinymce !== undefined) {
				tinymce.EditorManager.editors = [];
				var defaults = {
					selector: "textarea.mceEditor",
					theme: "modern",
					width: 550,
					height: 330,
					plugins: [
				         "advlist autolink link image lists charmap print preview hr anchor pagebreak",
				         "searchreplace visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
				         "save table contextmenu directionality emoticons template paste textcolor"
				    ],
				    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons"
				};
				
				var settings = $.extend({}, defaults, options);
				
				tinymce.init(settings);
			}
		}
		if ($modalCancellation.length > 0) {
            $modalCancellation.on("show.bs.modal", function(e) {
                var link = $(e.relatedTarget);

                $(this).find(".modal-body").load(link.attr("href"), function (e) {
                    var $frmCancellation = $('form', $modalCancellation);

                    if ($modalCancellation.find('.multilang').length) {
                    	var locale = $frmCancellation.data("locale"),
                    		$el = $modalCancellation.find('.pj-form-langbar-item[data-index="' + locale + '"]');
                    	if ($el.length) {
                    		$el.trigger('click');
                    	} else {
                    		$modalCancellation.find('.pj-form-langbar-item[data-index]:first').trigger('click');                    		
                    	}
                    }
                    
                    $frmCancellation.validate({
                        ignore: "",
                        submitHandler: function(e) {
                            $.post("index.php?controller=pjAdminBookings&action=pjActionCancellation", $frmCancellation.serialize()).done(function (resp) {
                                if (resp.code !== undefined && parseInt(resp.code, 10) === 200) {
                                    $modalCancellation.modal('hide');
                                    swal("Success!", resp.text, "success");
                                } else {
                                    swal("Error!", resp.text, "error");
                                }
                            });
                        }
                    });
                    attachTinyMce.call(null);
                });
            }).on('click', '.btn-primary', function (e) {
                $modalCancellation.find('form').trigger('submit');
            });
		}
		if ($modalConfirmation.length > 0) {
			$modalConfirmation.on("show.bs.modal", function(e) {
                var link = $(e.relatedTarget);

                $(this).find(".modal-body").load(link.attr("href"), function (e) {
                    var $frmConfirmation = $('form', $modalConfirmation);

                    if ($modalConfirmation.find('.multilang').length) {
                    	var locale = $frmConfirmation.data("locale"),
                    		$el = $modalConfirmation.find('.pj-form-langbar-item[data-index="' + locale + '"]');
                    	if ($el.length) {
                    		$el.trigger('click');
                    	} else {
                    		$modalConfirmation.find('.pj-form-langbar-item[data-index]:first').trigger('click');                    		
                    	}
                    }
                    
                    $frmConfirmation.validate({
                        ignore: "",
                        submitHandler: function(e) {
                            $.post("index.php?controller=pjAdminBookings&action=pjActionConfirmation", $frmConfirmation.serialize()).done(function (resp) {
                                if (resp.code !== undefined && parseInt(resp.code, 10) === 200) {
                                	$modalConfirmation.modal('hide');
                                    swal("Success!", resp.text, "success");
                                } else {
                                    swal("Error!", resp.text, "error");
                                }
                            });
                        }
                    });
                    attachTinyMce.call(null);
                });
            }).on('click', '.btn-primary', function (e) {
            	$modalConfirmation.find('form').trigger('submit');
            });
		}
		
		if ($modalSmsConfirmation.length > 0) {
			$modalSmsConfirmation.on("show.bs.modal", function(e) {
                var link = $(e.relatedTarget);
                	
                $(this).find(".modal-body").load(link.attr("href"), function (e) {
                    var $frmSmsConfirmation = $('form', $modalSmsConfirmation);

                    if ($modalSmsConfirmation.find('.multilang').length) {
                    	var locale = $frmSmsConfirmation.data("locale"),
                    		$el = $modalSmsConfirmation.find('.pj-form-langbar-item[data-index="' + locale + '"]');
                    	if ($el.length) {
                    		$el.trigger('click');
                    	} else {
                    		$modalSmsConfirmation.find('.pj-form-langbar-item[data-index]:first').trigger('click');                    		
                    	}
                    }
                    
                    $frmSmsConfirmation.validate({
                        ignore: "",
                        submitHandler: function(e) {
                            $.post("index.php?controller=pjAdminBookings&action=pjActionSmsConfirmation", $frmSmsConfirmation.serialize()).done(function (resp) {
                                if (resp.code !== undefined && parseInt(resp.code, 10) === 200) {
                                	$modalSmsConfirmation.modal('hide');
                                    swal("Success!", resp.text, "success");
                                } else {
                                    swal("Error!", resp.text, "error");
                                }
                            });
                        }
                    });
                });
            }).on('click', '.btn-primary', function (e) {
            	$modalSmsConfirmation.find('form').trigger('submit');
            });
		}
	});
})(jQuery_1_8_2);