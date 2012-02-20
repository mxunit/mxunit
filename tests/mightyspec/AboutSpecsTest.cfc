component extends="mxunit.framework.Spec" {

	function before(){
		variables.lastBeforeMethodName = arguments.methodName;
	}
	
	function after(){
		variables.lastAfterMethodName = arguments.methodName;
	}
	
	describe("Specs are TestCases", function(){
		
		it( "can use makePublic", function(){
			fail("not yet implemented");
		});
		
		it( "can use injectMethod", function(){
			fail("not yet implemented");
		});
		
		it( "can use debug", function(){
			debug("look, ma!");
		});
		
		it( "is a TestCase", function(){
			fail("not yet implemented");
		});
		
	});

	describe("Spec Expectations", function(){
		
		it( "should assert equality with toEqual()", function(){
			expect("case").toEqual("case", "This should pass because they are the same case");
			expect("case").toEqual("Case", "This should pass even if they are not the same case");
			expect("case").toEqual("CASE", "This should pass even if they are not the same case");
		});
		
		it( "should assert exact equality with toBe()", function(){
			expect("case").toBe("case", "This should pass because they are the same case");
			
			try{
				expect("case").toBe("Case", "This should fail because they are not the same case");
				throw("Should not get here");
			} catch( mxunit.exception.AssertionFailedError e ){
				//expect to get here
			}
		});
		
		it( "should assert same-ness with toBe()", function(){
			var obj = new mxunit.framework.TestCase();
			var obj2 = new mxunit.framework.TestCase();
			
			//happy path
			expect(obj).toBe(obj);
			
			//guard
			try{
				expect(obj).toBe(obj2, "This should fail because they are not the same instance");
				throw("Should not get here");
			} catch( mxunit.exception.AssertionFailedError e ){
				//expect to get here
			}
		});
		
		it( "should assert not same-ness with toNotBe()", function(){
			//happy path
			expect("case").toNotBe("Case", "This should pass because they are not case-sensitively equal");	
			
			//guard
			try{
				expect("case").toNotBe("case", "This should fail because they are the same case");
				throw("Should not get here");
			} catch( mxunit.exception.AssertionFailedError e ){
				//expect to get here
			}
		});
		
		it( "should have access to mxunit assertion extensions", function(){
			assertIsArray([]);
			assertIsStruct({});
		});

	});
	
	describe("Spec Annotations", function(){
		
		it( "should honor dataproviders", function(){
			fail("not yet implemented");
		});
		
		it( "should honor expectedException", function(){
			fail("not yet implemented");		
		});
		
		it( "should honor setExpectedException() function", function(){
			fail("not yet implemented");
		});

	});
	
	describe("Spec Scoping Behavior", function(){
		
		it( "should have access to component functions", function(){
			fail("not yet implemented");
		});
		
		it( "should have access to description variables", function(){
			debug(local);
			fail("not yet implemented");
		});
		
		var someVar = 5;
		var someOtherVar = 10;
		it( "should have access to arguments", function(someArg = someVar){
			debug(arguments);
			debug(local);
			debug(someVar);
			debug(someOtherVar);
			fail("not yet implemented");
		});
		
	});
	
	describe("Spec Before and After", function(){
		
		it( "should run beforeSpecs() once per Component", function(){
			fail("not yet implemented");
		});
		
		it( "should run afterSpecs() once per Component", function(){
			fail("not yet implemented");
		});
		
		it( "should run before() once per spec", function(){
			fail("not yet implemented");
		});
		
		it( "should run after() once per spec", function(){
			fail("not yet implemented");
		});
		
	});
	
}  