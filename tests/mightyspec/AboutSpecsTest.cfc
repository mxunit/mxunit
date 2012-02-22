component extends="mxunit.framework.Spec" {

	function beforeAll(){
		fixtureSuite = createObject("component", "mxunit.framework.TestSuite");
		var fixtureSpec = createObject("component", "fixture.SpecFixture");
		fixtureSuite.addAll( "mxunit.tests.mightyspec.fixture.SpecFixture", fixtureSpec);
		fixtureResult = fixtureSuite.run();
		fixtureRunnableMethods = fixtureSpec.getRunnableMethods();
	}
	
	describe("Specs are TestCases", function(){
		
		var anObject = createObject("component", "fixture.AComponent");
		
		it( "can use makePublic", function(){
			makePublic(anObject, "privateMethod");
			expect(anObject.privateMethod("hello")).toEqual("hello");
		});
		
		it( "can use injectMethod", function(){
			injectMethod(anObject, this, "override", "methodOne");
			expect(anObject.methodOne()).toEqual("overridden");
		});
		
		it( "can use debug", function(){
			debug("look, ma!");
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
			expect( request.fixtureDataProviderCount ).toEqual(4);//because I know the internal DP is 4 elements
			debug(request);
		});
		
		it( "should honor expectedException", function(){
			throw(type="MyCustomException");	
		}).withExpectedException("MyCustomException");
		
		it( "should honor setExpectedException() function", function(){
			expectException("AnotherCustomException");
			throw(type="AnotherCustomException");
		});

	});
	
	describe("Spec Scoping Behavior", function(){
		var insideSpecScopingBehavior = "insideSSB";
		
		it( "should have access to component functions", function(){
			var result = aFunctionInASpec( "hello world" );
			expect(result).toBe("hello world");
		});
		
		it( "should have access to description variables", function(){
			expect(insideSpecScopingBehavior).toBe("insideSSB");
		});
		
		var someVar = 5;
		var someOtherVar = 10;
		it( "should have access to arguments", function(someArg = someVar){
			debug(arguments);
			debug(local);
			debug(someVar);
			debug(someOtherVar);
			expect(someArg).toEqual(someVar);
		});
		
	});
	
	describe("Spec Before and After", function(){
		
		 
		it( "should run beforeAll() once per Component", function(){
			expect(request.specFixtureBeforeAllCount).toEqual(1);
		});
		
		it( "should run afterAll() once per Component", function(){
			expect(request.specFixtureAfterAllCount).toEqual(1);
		});
		
		it( "should run beforeEach() once per spec", function(){
			expect(request.specFixtureBeforeCount).toEqual(arrayLen(fixtureRunnableMethods));
		});
		
		it( "should run afterEach() once per spec", function(){
			expect(request.specFixtureAfterCount).toEqual(arrayLen(fixtureRunnableMethods));
		});
		
	});
	
	function aFunctionInASpec(input = ""){
		return input;
	}
	
	function override(){
		return "overridden";
	}
	
}  