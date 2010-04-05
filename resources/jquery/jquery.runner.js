/**
 * Test Runner JS Enhancements
 */
;(function($){
	container = '';
	
	
	
	$(function(){
		container = $('.mxunitResults');
		
		$('a[rel="tipsy"]').tipsy({fade:true,gravity:'s'});
		
		// Make the table into a grid
		$('table.results', container).tablesorter({
			headers: { 
				3: {
					sorter: 'digit' 
				}
			}
		});
		
		// Add the active toggle for the filters
		$('.summary a', container)
			.addClass('active')
			.click(function() {
				// Toggle the active class on the link
				$(this).toggleClass('active');
				
				// Find what type of filter we are on
				type = $(this).parent().attr('className');
				
				// Toggle all the matching tests
				toggleTests(type);
				
				return false;
			});
		
		// Hide the tag contexts by default
		contexts = $('table.tagcontext').hide();
		
		// Add the ability to toggle individual contexts
		$('<p />')
			.append($('<a />', {
				click: function() {
					// Find context directly after the link
					nextContext = $(this).parent().next();
					
					nextContext.toggle();
					
					return false;
				},
				href: '#',
				text: 'Toggle Error Context'
			}))
			.insertBefore(contexts);
		
		// Create a toggle link for the error context
		toggleContext = $('<li />', {})
			.append($('<a />', {
					click: function() {
						contexts.toggle();
						
						return false;
					},
					href: '#',
					text: 'Toggle Error Contexts'
				}));
		
		// Append the toggle option
		toggleContext.appendTo($('.summary ul', container));
	});
	
	function toggleTests( type ) {
		debug('Toggling: ' + type);
		
		$('tr.' + type, container).toggle();
	}
	
	function debug(s) {
		if (typeof window !== "undefined" && typeof window.console !== "undefined" && typeof window.console.debug !== "undefined") {
			window.console.log(s);
		} else {
			//alert(s);
		}
	}
	
})(jQuery);
