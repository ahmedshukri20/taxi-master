(function (window, undefined){
	"use strict";
	pjQ.$.ajaxSetup({
		xhrFields: {
			withCredentials: true
		}
	});
	var document = window.document,
		validate = (pjQ.$.fn.validate !== undefined),
		routes = [
		          	{pattern: /^#!\/loadSearch$/, eventName: "loadSearch"},
		          	{pattern: /^#!\/loadFleets$/, eventName: "loadFleets"},
		          	{pattern: /^#!\/loadCheckout$/, eventName: "loadCheckout"},
		          	{pattern: /^#!\/loadPreview$/, eventName: "loadPreview"}
		         ];
	
	function log() {
		if (window.console && window.console.log) {
			for (var x in arguments) {
				if (arguments.hasOwnProperty(x)) {
					window.console.log(arguments[x]);
				}
			}
		}
	}
	
	function assert() {
		if (window && window.console && window.console.assert) {
			window.console.assert.apply(window.console, arguments);
		}
	}
	
	function hashBang(value) {
		if (value !== undefined && value.match(/^#!\//) !== null) {
			if (window.location.hash == value) {
				return false;
			}
			window.location.hash = value;
			return true;
		}
		
		return false;
	}
	
	function onHashChange() {
		var i, iCnt, m;
		for (i = 0, iCnt = routes.length; i < iCnt; i++) {
			m = window.location.hash.match(routes[i].pattern);
			if (m !== null) {
				pjQ.$(window).trigger(routes[i].eventName, m.slice(1));
				break;
			}
		}
		if (m === null) {
			pjQ.$(window).trigger("loadSearch");
		}
	}
	pjQ.$(window).on("hashchange", function (e) {
    	onHashChange.call(null);
    });
	
	function TaxiBooking(opts) {
		if (!(this instanceof TaxiBooking)) {
			return new TaxiBooking(opts);
		}
				
		this.reset.call(this);
		this.init.call(this, opts);
		
		return this;
	}
	
	TaxiBooking.inObject = function (val, obj) {
		var key;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) {
				if (obj[key] == val) {
					return true;
				}
			}
		}
		return false;
	};
	
	TaxiBooking.size = function(obj) {
		var key,
			size = 0;
		for (key in obj) {
			if (obj.hasOwnProperty(key)) {
				size += 1;
			}
		}
		return size;
	};
	
	TaxiBooking.prototype = {
		reset: function () {
			this.$container = null;			
			this.container = null;
			this.opts = {};
			this.map = null;
			this.directionsDisplay = new google.maps.DirectionsRenderer();
			this.directionsService = new google.maps.DirectionsService();
			return this;
		},
		
		disableButtons: function () {
			this.$container.find(".btn").each(function (i, el) {
				pjQ.$(el).attr("disabled", "disabled");
			});
		},
		enableButtons: function () {
			this.$container.find(".btn").removeAttr("disabled");
		},
		
		init: function (opts) {
			var self = this;
			this.opts = opts;
			this.container = document.getElementById("pjTbsContainer_" + self.opts.index);
						
			self.$container = pjQ.$(self.container);
			pjQ.$("html").attr('dir',self.opts.direction);
			this.$container.on("change.tbs", ".pjTbsMenu", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var load = pjQ.$(this).val();
				if (!hashBang("#!/" + load)) 
				{
					pjQ.$(window).trigger(load);
				}
				return false;
			}).on("click.tbs", ".pjTbsLocale", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}				
				self.opts.locale = pjQ.$(this).data("id");
				var dir = pjQ.$(this).data("dir");
				self.opts.direction = dir;
				var params = {};
				if(self.opts.session_id != '')
				{
					params.session_id = self.opts.session_id;
				}
				params.locale_id = self.opts.locale;
				params.index = self.opts.index;
				
				self.disableButtons.call(self);
				pjQ.$.get([self.opts.folder, "index.php?controller=pjFront&action=pjActionLocale"].join(""), params).done(function (data) {
					pjQ.$("html").attr('dir',dir);
					var i, iCnt, m;
					for (i = 0, iCnt = routes.length; i < iCnt; i++) {
						m = window.location.hash.match(routes[i].pattern);
						if (m !== null) {
							pjQ.$(window).trigger(routes[i].eventName, m.slice(1));
							break;
						}
					}
					if (m === null) {
						if (!hashBang("#!/loadFleets")) {
							pjQ.$(window).trigger("loadFleets");
						}
					}else{
						if (!hashBang(m)) {
							m = str.replace("#!/", "");
							pjQ.$(window).trigger(m);
						}
					}
				}).fail(function () {
					self.enableButtons.call(self);
				});
				return false;
			}).on("change.tbs", ".pjTbsServiceSelector", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var fleet_id = pjQ.$(this).attr('data-fleet_id');
				var service_id = pjQ.$(this).val();
				pjQ.$('.pjTbs-price-' + fleet_id).hide();
				if(service_id != '')
				{
					pjQ.$('#pjTbsPriceLabel_' + service_id).show();
					pjQ.$('#pjTbsBtnReserve_' + fleet_id).removeAttr('disabled');
				}else{
					pjQ.$('#pjTbsBtnReserve_' + fleet_id).attr('disabled', 'disabled');
				}
				return false;
			}).on("click.tbs", ".pjTbsBtnReserve", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var ajax_url = [self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionSetService"].join("");
				if(self.opts.session_id != '')
				{
					ajax_url = [self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionSetService", "&session_id=", self.opts.session_id].join("")
				}
				
				self.disableButtons.call(self);
				pjQ.$.post(ajax_url, pjQ.$(this).closest('form').serialize()).done(function (data) {
					if (!hashBang("#!/loadCheckout")) 
					{
						self.loadCheckout.call(self);
					}
				}).fail(function () {
					self.enableButtons.call(self);
				});
				return false;
			}).on('click.tbs', '.pjCssLogin', function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $loginForm = pjQ.$('#pjCssLoginForm_'+ self.opts.index);
				$loginForm.find('input[name="login_email"]').val("");
				$loginForm.find('input[name="login_password"]').val("");
				pjQ.$('#pjLoginMessage_'+ self.opts.index).html("").parent().parent().hide();
				pjQ.$('#pjCssLoginModal').modal('show');
				return false;
			}).on('click.tbs', '.pjCssLogout', function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var params = {};
				params.locale = self.opts.locale;
				params.index = self.opts.index;
				if(self.opts.session_id != '')
				{
					params.session_id = self.opts.session_id;
				}
				self.disableButtons.call(self);
				pjQ.$.get([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionLogout"].join(""), params).done(function (data) {
					if (!hashBang("#!/loadCheckout")) 
					{
						self.loadCheckout.call(self);
					}
				}).fail(function () {
					
				});
				return false;
			}).on('click.tbs', '#pjTbsImage_' + self.opts.index, function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $captchaImg = pjQ.$(this);
				if($captchaImg.length > 0){
					var rand = Math.floor((Math.random()*999999)+1); 
					
					if(self.opts.session_id != '')
					{
						$captchaImg.attr("src", self.opts.folder + 'index.php?controller=pjFrontEnd&action=pjActionCaptcha&rand=' + rand + "&session_id=" + self.opts.session_id);
					}else{
						$captchaImg.attr("src", self.opts.folder + 'index.php?controller=pjFrontEnd&action=pjActionCaptcha&rand=' + rand);
					}
					pjQ.$('#pjTbsCheckoutForm_' + self.opts.index).find('input[name="captcha"]').val("").removeData("previousValue");
				}
				return false;
			}).on('click.tbs', '.pjAvailExtra', function(e){
				self.calcPrices.call(self);
			}).on('click.tbs', '.pjTbsBtnBack', function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var load = pjQ.$(this).attr('data-load');
				if (!hashBang("#!/" + load)) 
				{
					pjQ.$(window).trigger(load);
				}
				return false;
			}).on('click.tbs', '.pjTbsBtnStartOver', function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}			
				self.map = null;
				if (!hashBang("#!/loadSearch")) 
				{
					self.loadSearch.call(self);
				}
				return false;
			}).on('click.tbs', '.pjTbsBtnBookTaxi', function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var id = pjQ.$(this).attr('data-id');
				var params = {};
				params.fleet_id = id;
				if(self.opts.session_id != '')
				{
					params.session_id = self.opts.session_id;
				}
				self.disableButtons.call(self);
				pjQ.$.get([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionSetTaxi"].join(""), params).done(function (data) {
					if(data.status == 'OK')
					{
						if (!hashBang("#!/loadCheckout")) 
						{
							self.loadCheckout.call(self);
						}
					}else{
						self.enableButtons.call(self);
					}
				}).fail(function () {
					self.enableButtons.call(self);
				});
				return false;
			});
			
			pjQ.$(window).on("loadSearch", this.$container, function (e) {
				self.loadSearch.call(self);
			}).on("loadFleets", this.$container, function (e) {
				self.loadFleets.call(self);
			}).on("loadCheckout", this.$container, function (e) {
				self.loadCheckout.call(self);
			}).on("loadPreview", this.$container, function (e) {
				self.loadPreview.call(self);
			});
			
			if (window.location.hash.length === 0) {
				this.loadSearch.call(this);
			} else {
				onHashChange.call(null);
			}
			
			pjQ.$(document).on("click.tbs", '.pjCssLinkForgotPassword', function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $forgotForm = pjQ.$('#pjCssForgotForm_'+ self.opts.index);
				$forgotForm.find('input[name="email"]').val("");
				pjQ.$('#pjForgotMessage_'+ self.opts.index).removeClass('text-danger text-success').html("").parent().parent().hide();
				pjQ.$('#pjCssLoginModal').modal('hide');
				pjQ.$('#pjCssForgotModal').modal('show');
				return false;
			}).on("click.tbs", '.pjCssLinkLogin', function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $loginForm = pjQ.$('#pjCssLoginForm_'+ self.opts.index);
				$loginForm.find('input[name="login_email"]').val("");
				$loginForm.find('input[name="login_password"]').val("");
				pjQ.$('#pjLoginMessage_'+ self.opts.index).html("").parent().parent().hide();
				pjQ.$('#pjCssForgotModal').modal('hide');
				pjQ.$('#pjCssLoginModal').modal('show');
				return false;
			}).on("change.tbs", "select[name='payment_method']", function () {
				self.$container.find(".pjTbsCcWrap").hide();
				self.$container.find(".pjTbsBankWrap").hide();
				switch (pjQ.$("option:selected", this).val()) {
				case 'creditcard':
					self.$container.find(".pjTbsCcWrap").show();
					break;
				case 'bank':
					self.$container.find(".pjTbsBankWrap").show();
					break;
				}
			}).on("click.tbs", 'button[data-dismiss="modal"]', function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $modal = pjQ.$(this).closest('.modal');
				if ($modal !== undefined && $modal.length > 0) {
					$modal.modal('hide');
					pjQ.$('body').removeClass('modal-open');
				}
				return false;
			});
		},
		
		loopPrices: function() {
			var self = this;
			pjQ.$('.pjTbsServiceSelector').each(function(e){
				var service_id = pjQ.$(this).val();
				pjQ.$('#pjTbsPriceLabel_' + service_id).show();
			});
		},
		loadSearch: function () {
			var self = this,
				index = this.opts.index,
				params = {};
			params.locale = this.opts.locale;
			params.index = this.opts.index;
			if(self.opts.session_id != '')
			{
				params.session_id = self.opts.session_id;
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionSearch"].join(""), params).done(function (data) {
				self.$container.html(data);
				self.bindSearch.call(self);
			}).fail(function () {
				
			});
		},
		loadFleets: function () {
			var self = this,
				index = this.opts.index,
				params = {};
			params.locale = this.opts.locale;
			params.index = this.opts.index;
			if(self.opts.session_id != '')
			{
				params.session_id = self.opts.session_id;
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionFleets"].join(""), params).done(function (data) {
				if (data.code != undefined && data.status == 'ERR') {
					if (!hashBang("#!/loadSearch")) 
					{
						self.loadSearch.call(self);
					}
				}else{
					self.$container.html(data);
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
			}).fail(function () {
				
			});
		},
		loadCheckout: function () {
			var self = this,
				index = this.opts.index,
				params = {};
			params.locale = this.opts.locale;
			params.index = this.opts.index;
			if(self.opts.session_id != '')
			{
				params.session_id = self.opts.session_id;
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionCheckout"].join(""), params).done(function (data) {
				if (data.code != undefined && data.status == 'ERR') {
					if (!hashBang("#!/loadFleets")) 
					{
						self.loadFleets.call(self);
					}
				}else{
					self.$container.html(data);
					self.bindCheckout.call(self);
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
			}).fail(function () {
				
			});
		},
		calcPrices: function(){
			var self = this;
			
			var $form = pjQ.$('#pjTbsCheckoutForm_'+ self.opts.index);
			
			var ajax_url = [self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionGetPrices"].join("");
			if(self.opts.session_id != '')
			{
				ajax_url = [self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionGetPrices", "&session_id=", self.opts.session_id].join("")
			}
			self.disableButtons.call(self);
			pjQ.$.post(ajax_url, $form.serialize()).done(function (data) {
				pjQ.$('#pjTbsPriceBox').html(data);
				self.enableButtons.call(self);
			}).fail(function () {
				self.enableButtons.call(self);
			});
		},
		initMap: function(){
			var self = this;
			
			self.map = new google.maps.Map(document.getElementById('pjTbsMapCanvas'), {
				center: {lat: self.opts.lat, lng: self.opts.lng},
				zoom: self.opts.zoom
        	});
			
			self.calcRoute.call(self);
		},
		calcRoute: function(){
			var self = this;
			var start = pjQ.$('#pickup_address_' + self.opts.index).val();
	        var end = pjQ.$('#return_address_' + self.opts.index).val();
	        if(start != '' && end != '')
	        {
	        	self.directionsDisplay.setMap(self.map);
	        	var request = {
		        		origin: start,
		        		destination: end,
		        		travelMode: google.maps.DirectionsTravelMode.DRIVING
	              	};
		        self.directionsService.route(request, function(response, status) {
		        	if (status == google.maps.DirectionsStatus.OK) {
		        		self.directionsDisplay.setDirections(response);
		        		var distanceinkm = parseInt(response.routes[0].legs[0].distance.value / 1000, 10);
		        		pjQ.$('#pjTbsDistanceFiled').val(distanceinkm);
		            }
		         });
	        }else{
	        	self.directionsDisplay.setMap(null);
	        	pjQ.$('#pjTbsDistanceFiled').val("");
	        }
		},
		bindSearch: function(){
			var self = this,
				index = this.opts.index;
			pjQ.$('.modal-dialog').css("z-index", "9999"); 
			if(pjQ.$('#pjTbsMapCanvas').length > 0)
			{
				self.initMap.call(self);
			}
			if(pjQ.$('#pickup_address_' + self.opts.index).length > 0)
			{
				var pickup_field = document.getElementById('pickup_address_' + self.opts.index);
				var autocomplete_pickup = new google.maps.places.Autocomplete(pickup_field, {
					types: ["geocode"]
				});
				google.maps.event.addDomListener(pickup_field, 'keydown', function(e) { 
				    if (e.keyCode == 13) { 
				        e.preventDefault(); 
				    }
				});
				google.maps.event.addListener(autocomplete_pickup, 'place_changed', function() {
					self.calcRoute.call(self);
				});
			}
			if(pjQ.$('#return_address_' + self.opts.index).length > 0)
			{
				var return_field = document.getElementById('return_address_' + self.opts.index);
				var autocomplete_return = new google.maps.places.Autocomplete(return_field, {
					types: ["geocode"]
				});
				google.maps.event.addDomListener(return_field, 'keydown', function(e) { 
				    if (e.keyCode == 13) { 
				        e.preventDefault(); 
				    }
				});
				google.maps.event.addListener(autocomplete_return, 'place_changed', function() {
					self.calcRoute.call(self);
				});
			}
			
			if(pjQ.$('#pjTbsCalendarLocale').length > 0)
			{
				var fday = parseInt(pjQ.$('#pjTbsCalendarLocale').data('fday'), 10);
				moment.updateLocale('en', {
					months : pjQ.$('#pjTbsCalendarLocale').data('months').split("_"),
			        weekdaysMin : pjQ.$('#pjTbsCalendarLocale').data('days').split("_"),
			        week: { dow: fday }
				});
			}
			if(pjQ.$('.date-pick').length > 0)
			{
				var currentDate = new Date();
				pjQ.$('.date-pick').datetimepicker({
					format: self.opts.momentDateFormat.toUpperCase(),
					locale: moment.locale('en'),
					allowInputToggle: true,
					minDate: new Date(currentDate.getFullYear(), currentDate.getMonth(), currentDate.getDate()),
					ignoreReadonly: true
				});
			}
			pjQ.$('.time-pick').datetimepicker({
				format: self.opts.time_format,
				ignoreReadonly: true,
				allowInputToggle: true
			});
			if (pjQ.$('.pjTbs-spinner').length) {
		        var spinnerUpClass = 'pjTbs-spinner-up';
		        var spinnerDownClass = 'pjTbs-spinner-down';
		        var spinnerResult = '.pjTbs-spinner-result';

		        pjQ.$('.pjTbs-spinner').on('click', '.pjTbs-spinner', function(e) {
		            var $clickedSpinnerBtn = pjQ.$(this);
		            var $spinnerField = $clickedSpinnerBtn.siblings(spinnerResult);
		            var $spinnerValue = $spinnerField.val();
		            var $maxValue = parseInt($spinnerField.attr('data-max'), 10);
		           
		            if ($clickedSpinnerBtn.hasClass(spinnerUpClass)) {
		                $spinnerValue = $spinnerValue +++ 1;
		            } else if ($clickedSpinnerBtn.hasClass(spinnerDownClass)) {
		                $spinnerValue = $spinnerValue --- 1;
		            };
		            if($spinnerField.attr('name') == 'passengers')
		            {
		            	if ($spinnerValue <= 1) {
			                $spinnerValue = 1;
			            };
		            }else{
		            	if ($spinnerValue <= 0) {
			                $spinnerValue = '';
			            };
		            }
		            if ($spinnerValue >= $maxValue) {
		                $spinnerValue = $maxValue;
		            };
		            $spinnerField.val($spinnerValue);

		            e.preventDefault();
		        });
		    };
			if (validate) 
			{
				var $form = pjQ.$('#pjTbsSearchForm_'+ self.opts.index);
				$form.validate({
					onkeyup: false,
					errorElement: 'li',
					ignore: '',
					errorPlacement: function (error, element) {
						if(element.attr('name') == 'booking_date' || element.attr('name') == 'booking_time' || element.attr('name') == 'distance')
						{
							error.appendTo(element.parent().next().find('ul'));
						}else if(element.attr('name') == 'terms' || element.attr('name') == 'passengers' || element.attr('name') == 'luggage'){
							error.appendTo(element.parent().parent().next().find('ul'));
						}else{
							error.appendTo(element.next().find('ul'));
						}
					},
		            highlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	if(element.attr('name') == 'booking_date' || element.attr('name') == 'booking_time' || element.attr('name') == 'distance')
						{
							element.parent().parent().removeClass('has-success').addClass('has-error');
						}else if(element.attr('name') == 'terms' || element.attr('name') == 'passengers' || element.attr('name') == 'luggage'){
							element.parent().parent().parent().removeClass('has-success').addClass('has-error');
						}else{
							element.parent().removeClass('has-success').addClass('has-error');
						}
		            },
		            unhighlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	if(element.attr('name') == 'booking_date' || element.attr('name') == 'booking_time' || element.attr('name') == 'distance')
						{
							element.parent().parent().removeClass('has-error').addClass('has-success');
						}else if(element.attr('name') == 'terms' || element.attr('name') == 'passengers' || element.attr('name') == 'luggage'){
							element.parent().parent().parent().removeClass('has-error').addClass('has-success');
						}else{
							element.parent().removeClass('has-error').addClass('has-success');
						}
		            },
					submitHandler: function (form) {
						self.disableButtons.call(self);
						var $form = pjQ.$(form);
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionSearch", "&session_id=", self.opts.session_id].join(""), $form.serialize()).done(function (data) {
							if (data.status == "OK") {
								if (!hashBang("#!/loadFleets")) 
								{
									self.loadFleets.call(self);
								}
							}else{
								if(data.code == '120')
								{
									pjQ.$('html, body').animate({
								        scrollTop: self.$container.offset().top
								    }, 500);
									pjQ.$('#pjTbsEarlierModal').modal('show');
								}
								self.enableButtons.call(self);
							}
						}).fail(function () {
							self.enableButtons.call(self);
						});
						return false;
					}
				});
			}
		},
		bindCheckout: function(){
			var self = this,
				index = this.opts.index;
		
			pjQ.$('.modal-dialog').css("z-index", "9999"); 
			pjQ.$('.time-pick').datetimepicker({
				format: self.opts.time_format,
				ignoreReadonly: true,
				allowInputToggle: true
			});
			if (validate) 
			{
				var $form = pjQ.$('#pjTbsCheckoutForm_'+ self.opts.index);
				var remote_url = self.opts.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckCaptcha";
				if(self.opts.session_id != '')
				{
					remote_url += "&session_id=" + self.opts.session_id;
				}
				
				var $reCaptcha = self.$container.find('#g-recaptcha');
				if ($reCaptcha.length > 0)
	            {
	                grecaptcha.render($reCaptcha.attr('id'), {
	                    sitekey: $reCaptcha.data('sitekey'),
	                    callback: function(response) {
	                        var elem = pjQ.$("input[name='recaptcha']");
	                        elem.val(response);
	                        elem.valid();
	                    }
	                });
	            }
				
				$form.validate({
					rules: {
						"captcha": {
							remote: remote_url
						},
						"recaptcha": {
	                        remote: self.opts.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckReCaptcha&session_id=" + self.opts.session_id
	                    },
					},
					onkeyup: false,
					errorElement: 'li',
					errorPlacement: function (error, element) {
						if(element.attr('name') == 'c_flight_time')
						{
							error.appendTo(element.parent().next().find('ul'));
						}else if(element.attr('name') == 'terms'){
							error.appendTo(element.parent().parent().next().find('ul'));
						}else{
							error.appendTo(element.next().find('ul'));
						}
					},
		            highlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	if(element.attr('name') == 'c_flight_time')
						{
							element.parent().parent().removeClass('has-success').addClass('has-error');
						}else if(element.attr('name') == 'terms'){
							element.parent().parent().parent().removeClass('has-success').addClass('has-error');
						}else{
							element.parent().removeClass('has-success').addClass('has-error');
						}
		            },
		            unhighlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	if(element.attr('name') == 'c_flight_time')
						{
							element.parent().parent().removeClass('has-error').addClass('has-success');
						}else if(element.attr('name') == 'terms'){
							element.parent().parent().parent().removeClass('has-error').addClass('has-success');
						}else{
							element.parent().removeClass('has-error').addClass('has-success');
						}
		            },
					submitHandler: function (form) {
						self.disableButtons.call(self);
						var $form = pjQ.$(form);
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionCheckout", "&session_id=", self.opts.session_id].join(""), $form.serialize()).done(function (data) {
							if (data.status == "OK") {
								if (!hashBang("#!/loadPreview")) 
								{
									self.loadPreview.call(self);
								}
							}
						}).fail(function () {
							self.enableButtons.call(self);
						});
						return false;
					}
				});
				
				var $form = pjQ.$('#pjCssLoginForm_'+ self.opts.index);
				$form.validate({
					onkeyup: false,
					errorElement: 'li',
					errorPlacement: function (error, element) {
						error.appendTo(element.next().find('ul'));
					},
		            highlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	element.parent().removeClass('has-success').addClass('has-error');
		            },
		            unhighlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	element.parent().removeClass('has-error').addClass('has-success');
		            },
					submitHandler: function (form) {
						self.disableButtons.call(self);
						var $form = pjQ.$(form);
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionCheckLogin", "&session_id=", self.opts.session_id].join(""), $form.serialize()).done(function (data) {
							if(data.code == '200')
							{
								pjQ.$('#pjCssLoginModal').modal('hide');
								if (!hashBang("#!/loadCheckout")) 
								{
									self.loadCheckout.call(self);
								}
							}else{
								var $loginMessage = pjQ.$('#pjLoginMessage_'+ self.opts.index);
								$loginMessage.html(data.text);
								$loginMessage.parent().parent().show();
							}
						}).fail(function () {
							self.enableButtons.call(self);
						});
						return false;
					}
				});
				
				var $form = pjQ.$('#pjCssForgotForm_'+ self.opts.index);
				$form.validate({
					onkeyup: false,
					errorElement: 'li',
					errorPlacement: function (error, element) {
						if(element.attr('name') == 'terms')
						{
							error.appendTo(element.parent().next().find('ul'));
						}else{
							error.appendTo(element.next().find('ul'));
						}
					},
		            highlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	element.parent().removeClass('has-success').addClass('has-error');
		            },
		            unhighlight: function(ele, errorClass, validClass) {
		            	var element = pjQ.$(ele);
		            	element.parent().removeClass('has-error').addClass('has-success');
		            },
					submitHandler: function (form) {
						self.disableButtons.call(self);
						var $form = pjQ.$(form);
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionSendPassword", "&session_id=", self.opts.session_id].join(""), $form.serialize()).done(function (data) {
							var $forgotMessage = pjQ.$('#pjForgotMessage_'+ self.opts.index);
							if(data.code == '200')
							{
								$forgotMessage.addClass('text-success');
							}else{
								$forgotMessage.addClass('text-danger');
							}
							$forgotMessage.html(data.text);
							$forgotMessage.parent().parent().show();
						}).fail(function () {
							self.enableButtons.call(self);
						});
						return false;
					}
				});
			}
		},
		loadPreview: function () {
			var self = this,
				index = this.opts.index,
				params = {};
			params.locale = this.opts.locale;
			params.index = this.opts.index;
			if(self.opts.session_id != '')
			{
				params.session_id = self.opts.session_id;
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionPreview"].join(""), params).done(function (data) {
				if (data.code != undefined && data.status == 'ERR') {
					if (!hashBang("#!/loadFleets")) 
					{
						self.loadFleets.call(self);
					}
				}else{
					self.$container.html(data);
					self.bindPreview.call(self);
					pjQ.$('html, body').animate({
				        scrollTop: self.$container.offset().top
				    }, 500);
				}
			}).fail(function () {
				
			});
		},
		bindPreview: function(){
			var self = this,
				index = this.opts.index;
		
			if (validate) 
			{
				var $form = pjQ.$('#pjTbsPreviewForm_'+ self.opts.index);
				$form.validate({
					submitHandler: function (form) {
						self.disableButtons.call(self);
						var $form = pjQ.$(form);
						pjQ.$.post([self.opts.folder, "index.php?controller=pjFrontEnd&action=pjActionSaveBooking", "&session_id=", self.opts.session_id].join(""), $form.serialize()).done(function (data) {
							if (data.code == "200") {
								self.getPaymentForm.call(self, data);
							} else if (data.code == "119") {
								self.enableButtons.call(self);
							}
						}).fail(function () {
							self.enableButtons.call(self);
						});
						return false;
					}
				});
			}
		},
		getPaymentForm: function(obj){
			var self = this,
				index = this.opts.index;
			var	params = {};
			params.locale = self.opts.locale;
			params.index = self.opts.index;
			params.booking_id =  obj.booking_id;
			params.payment_method = obj.payment;
			if(self.opts.session_id != '')
			{
				params.session_id = self.opts.session_id;
			}
			pjQ.$.get([this.opts.folder, "index.php?controller=pjFrontPublic&action=pjActionGetPaymentForm"].join(""), params).done(function (data) {
				self.$container.html(data);
				pjQ.$('html, body').animate({
			        scrollTop: self.$container.offset().top
			    }, 500);
				var $payment_form = self.$container.find("form[name='pjOnlinePaymentForm']").first();
				if ($payment_form.length > 0) {
					$payment_form.trigger('submit');
				}
			}).fail(function () {
				log("Deferred is rejected");
			});
		}
	};
	
	window.TaxiBooking = TaxiBooking;	
})(window);