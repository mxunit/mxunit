component extends="mxunit.framework.Spec" {

	function before(){
		variables.lastBeforeMethodName = arguments.methodName;
	}
	
	function after(arguments){
		variables.lastAfterMethodName = arguments.methodName;
	}

	describe("This Fixture", function(){
		it( "should have a single spec for This Fixture", function(){
			expect("one").toEqual("one");
		});
	});
	
	describe("This Fixture should have two specs for the second description", function(){
		
		it( "I am the first", function(){
			expect("two").toEqual("two");
		});
		
		it( "I am the second", function(){
			expect("two").toEqual("two");
		});

	});
	
}  