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
		change_name_selectbox(view);
		if(view == "Custom") {
			$(".calendar").show();
			return false;
		}
		
		//$.post('/dashboard/view-options', $('#view_mode_frm').serialize());
		//alert($('#view_mode_frm').serialize());
		$('#view_mode_frm').ajaxSubmit();
	});
});

function change_name_selectbox(view) {
	var group = $('.filterselectebox');
	var dropbox = $('.view_option.current', group) 
	if(view != "") dropbox.text(view);
}
