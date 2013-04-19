// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .
$(function() {
	$('.view_option').click(function() {
		var view = $(this).text();
		$('#option_view').val(view);
		change_name_selectbox();
		if(view == "Custom") {
			$(".calendar").show();
			return false;
		}
		
		$('form#view_mode_frm').trigger('submit.rails');
		
		//$.post('/dashboard/view-options', $('#view_mode_frm').serialize());
		//alert($('#view_mode_frm').serialize());
		// $.post('/dashboard/view-options', $('#view_mode_frm').serialize(), function(data) {
			// $('#dashboard_content').html(data);
		// });
	});
});

function change_name_selectbox() {
	var group = $('.filterselectebox');
	var dropbox = $('.view_option.current', group) 
	view_mode = $('#option_view').val();
	alert(view_mode);
	if(view_mode != "") dropbox.text(view_mode);
}
