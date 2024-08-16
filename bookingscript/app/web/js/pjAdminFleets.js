var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreateFleet = $("#frmCreateFleet"),
			$frmUpdateFleet = $("#frmUpdateFleet"),
			chosen = ($.fn.chosen !== undefined),
			multilang = ($.fn.multilang !== undefined),
			validate = ($.fn.validate !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			remove_arr = new Array();
		
		if (multilang && 'pjCmsLocale' in window) {
			$(".multilang").multilang({
				langs: pjCmsLocale.langs,
				flagPath: pjCmsLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					$("input[name='locale_id']").val(ui.index);
				}
			});
		}
		if (chosen) {
			$("#extra_id").chosen();
		}
		function setPrices()
		{
			var index_arr = new Array();
				
			$('#pjTbPriceTable').find(".pjTbPriceRow").each(function (index, row) {
				index_arr.push($(row).attr('data-index'));
			});
			$('#index_arr').val(index_arr.join("|"));
		}
		if ($frmCreateFleet.length > 0 && validate) {
			$frmCreateFleet.validate({
				invalidHandler: function (event, validator) {
				    $(".pj-multilang-wrap").each(function( index ) {
						if($(this).attr('data-index') == myLabel.localeId)
						{
							$(this).css('display','block');
						}else{
							$(this).css('display','none');
						}
					});
					$(".pj-form-langbar-item").each(function( index ) {
						if($(this).attr('data-index') == myLabel.localeId)
						{
							$(this).addClass('btn-primary');
						}else{
							$(this).removeClass('btn-primary');
						}
					});
				},
				ignore: "",
				submitHandler: function(form){
					setPrices();
					$.post("index.php?controller=pjAdminFleets&action=pjActionCheckPrices", $(form).serialize()).done(function (data) {
						if(data.status == 'OK')
						{
							form.submit();
						}else{
							swal({
				    			title: "",
								text: data.text,
								type: "warning",
								confirmButtonColor: "#DD6B55",
								confirmButtonText: "OK",
								closeOnConfirm: false,
								showLoaderOnConfirm: false
							}, function () {
								swal.close();
							});
						}
					});
				}
			});
			$frmCreateFleet.find(".pj-field-count").TouchSpin({
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white',
	            min: 0,
	            max: 4294967295
	        });
		}
		if ($frmUpdateFleet.length > 0 && validate) {
			$frmUpdateFleet.validate({
				invalidHandler: function (event, validator) {
				    $(".pj-multilang-wrap").each(function( index ) {
						if($(this).attr('data-index') == myLabel.localeId)
						{
							$(this).css('display','block');
						}else{
							$(this).css('display','none');
						}
					});
					$(".pj-form-langbar-item").each(function( index ) {
						if($(this).attr('data-index') == myLabel.localeId)
						{
							$(this).addClass('btn-primary');
						}else{
							$(this).removeClass('btn-primary');
						}
					});
				},
				ignore: "",
				submitHandler: function(form){
					setPrices();
					$.post("index.php?controller=pjAdminFleets&action=pjActionCheckPrices", $(form).serialize()).done(function (data) {
						if(data.status == 'OK')
						{
							form.submit();
						}else{
							swal({
				    			title: "",
								text: data.text,
								type: "warning",
								confirmButtonColor: "#DD6B55",
								confirmButtonText: "OK",
								closeOnConfirm: false,
								showLoaderOnConfirm: false
							}, function () {
								swal.close();
							});
						}
					});
				}
			});
			$frmUpdateFleet.find(".pj-field-count").TouchSpin({
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white',
	            min: 0,
	            max: 4294967295
	        });
		}
		function formatImage(val, obj) {
			var src = val != null ? val : 'app/web/img/backend/no-image.png';
			return ['<a href="index.php?controller=pjAdminFleets&action=pjActionUpdate&id=', obj.id ,'"><img src="', src, '" style="width: 100px" /></a>'].join("");
		}
		if ($("#grid").length > 0 && datagrid) {
			var $grid = $("#grid").datagrid({
				buttons: [{type: "edit", url: "index.php?controller=pjAdminFleets&action=pjActionUpdate&id={:id}"},
				          {type: "delete", url: "index.php?controller=pjAdminFleets&action=pjActionDeleteFleet&id={:id}"}
				          ],
				columns: [{text: myLabel.thumb, type: "text", sortable: false, editable: false, renderer: formatImage},
				          {text: myLabel.fleet, type: "text", sortable: true, editable: true, editableWidth: 170},
				          {text: myLabel.passengers, type: "text", sortable: true, editable: true, editableWidth: 70},
				          {text: myLabel.luggage, type: "text", sortable: true, editable: true, editableWidth: 70},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: true, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}
				          ],
				dataUrl: "index.php?controller=pjAdminFleets&action=pjActionGetFleet",
				dataType: "json",
				fields: ['thumb_path', 'fleet', 'passengers', 'luggage', 'status'],
				paginator: {
					actions: [
					   {text: myLabel.delete_selected, url: "index.php?controller=pjAdminFleets&action=pjActionDeleteFleetBulk", render: true, confirmation: myLabel.delete_confirmation}
					],
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminFleets&action=pjActionSaveFleet&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'
				}
			});
		}		
		
		$(document).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminFleets&action=pjActionGetFleet", "fleet", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", ".btnAddPrice", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $c = $("#pjTbPriceClone tbody").clone(),
				r = $c.html().replace(/\{INDEX\}/g, 'new_' + Math.ceil(Math.random() * 99999));
			
			$(this).closest("form").find("table").find("tbody").append(r);
			if($frmCreateFleet.length > 0)
			{
				$frmCreateFleet.find(".pj-field-count").TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            min: 0,
		            max: 4294967295
		        });	
			}
			if($frmUpdateFleet.length > 0)
			{
				$frmUpdateFleet.find(".pj-field-count").TouchSpin({
					verticalbuttons: true,
		            buttondown_class: 'btn btn-white',
		            buttonup_class: 'btn btn-white',
		            min: 0,
		            max: 4294967295
		        });
			}
		}).on("click", ".lnkRemovePrice", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $tr = $(this).closest("tr");
			var id =  $(this).attr("data-index");
			if(id.indexOf("new") == -1)
			{
				remove_arr.push(id);
			}
			$('#remove_arr').val(remove_arr.join("|"));
			$tr.css("backgroundColor", "#FFB4B4").fadeOut("slow", function () {
				$tr.remove();
			});			
			return false;
		}).on("click", ".btnDeleteImage", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var id = $(this).attr('data-id');
			var $this = $(this);
			swal({
				title: myLabel.alert_title,
				text: myLabel.alert_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$('#image_container').remove();
						break;
					}
				});
			});
		});
	});
})(jQuery_1_8_2);