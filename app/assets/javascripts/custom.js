(function($) {

	$(document).ready(function() {
		twocol_height();
		twocol_checkin();
		dropdownmenufix(
			  $('.quick-search .btn-group'),
			  $('.quick-search .btn-group .place'),
			  $('.quick-search .btn-group .dropdown-menu a')
			  );
		dropdownmenufix(
			  $('#searchbag .type-choose'),
			  $('#searchbag .type-choose .place'),
			  $('#searchbag .type-choose .dropdown-menu a')
			  );
		dropdownmenufix(
			  $('.dash-tab'),
			  $('.dash-tab .place'),
			  $('.dash-tab .dropdown-menu a')
			  );

	});

	function dropdownmenufix(group, place, lista) {
		function changetext(t) {
			var value = t.attr('rel');
			place.text(t.text());
			place.attr('rel', value);
		}
		lista.on('click', function(e) {
			e.preventDefault();
			changetext($(this));
		});
		changetext($(lista).eq(0));
	}

	function twocol_height() {
		var abcols_left = $('.twocol-bg-left');
		var abcols_right = $('.twocol-bg-right-ext-col');

		var h = abcols_left.outerHeight(true);
		abcols_left.css('min-height', h);
		abcols_right.css('min-height', h);
	}

	function twocol_checkin() {
		var triggle = $('.visitor-opt-bt');
		if (triggle.length > 0) {
			var content1 = $('.wellcome');
			var content2 = $('.more-detail');
			content2.hide();

			triggle.click(function(e) {
				e.preventDefault();
				content1.animate({opacity: 0}, 400, function() {
					$(this).hide();
					content2.css({'opacity': 0, 'display': 'block'});
					content2.animate({opacity: 1}, 400);
				});
				$(this).animate({opacity: 0}, 400);
			});
		}
	}

})(jQuery);