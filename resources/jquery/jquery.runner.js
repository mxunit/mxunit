/**
 * Test Runner JS Enhancements
 */
;(function($){
	container = '';
	
	
	
	$(function(){
		container = $('.mxunitResults');
		
	
		
		$('#bug').tipsy({fade:false,gravity:'e'});
		$('a[rel="tipsy"]').tipsy({fade:true,gravity:'s'});
		$('.menu_item').tipsy({fade:true,gravity:'n',delayIn:2400});
		
				$('#sparkcontainer').tipsy({fade:true,gravity:'n'});
		$('.mxunittestsparks').sparkline( 'html', {type: 'tristate', barWidth: 1.25, colorMap: {'1': "#50B516", '-1': "#0781FA", '-2': "#DB1414"} } );

		
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
				text: 'Toggle Stack Trace'
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
					text: 'Toggle Stack Traces'
				}));
		
		// Append the toggle option
		toggleContext.appendTo($('.summary ul', container));     
		
		toggleTests('passed');
	});
	
	function toggleTests( type ) {
		debug('Toggling: ' + type);
		
		$('tr.' + type, container).toggle();
		
		
		// Toggle the active class on the link
		$('.summary .' + type + ' a', container).toggleClass('active');
		
		// Hide suites with no visible tests
		$('table.results>tbody:not(:has(>tr:visible))', container).parent().prev().andSelf().hide();
		
		// Show suites with visible tests
		$('table.results>tbody:has(>tr:visible)', container).parent().prev().andSelf().show();
	}
	
	function debug(s) {
		if (typeof window !== "undefined" && typeof window.console !== "undefined" && typeof window.console.debug !== "undefined") {
			window.console.log(s);
		} else {
			//alert(s);
		}
	}
	
	
	
	
	
})(jQuery);
