
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){
    $.fn.checknet();
});

$(function() {
	change_name_selectbox();
	$('.view_option').click(function() {
		var view = $(this).text();
		$('#option_view').val(view);
		change_name_selectbox();
		if(view == "Custom") {
			$("#calendar_area").show();
			$("#view_mode_sb").show();
			return false;
		} else {
			$("#calendar_area").hide();
			$("#view_mode_sb").hide();
		}
		
		$('form#view_mode_frm').trigger('submit.rails');
		
	});
  
	
	
	$('.frm-checkout').submit(function() {
			var data = $(this).serialize();
			
			$.post( "/visitors/checkout", data, function(response) {
				var success = response.success;
				var visitor_id = response.id;
				var message = response.message
				if(success == 1) {
					
					var parent = $('#form-' + visitor_id).parent('td');
					$('#form-' + visitor_id).remove();
					$(parent).text('Checked out');
					$('.notification').text(message).removeClass('alert-error').addClass('alert-success').fadeIn(300).delay(2000).fadeOut(300)
				} else {
					$('.notification').text(message).removeClass('alert-success').addClass('alert-error').fadeIn(300).delay(2000).fadeOut(300)
				}
            }, "json"); 
		});
	
});

function change_name_selectbox() {
	var group = $('.filterselectebox');
	var dropbox = $('.view_option.current', group) 
	view_mode = $('#option_view').val();
	
	if(view_mode != "") dropbox.text(view_mode);
}