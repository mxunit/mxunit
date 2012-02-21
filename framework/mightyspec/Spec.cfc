component extends="mxunit.framework.TestCase" {

	specs = {};
	runnableMethods = [];
	currentDescriptionContext = "";
	variables.actual = "";
	variables.expected = "";
	
	function getSpecs(){
		return specs;
	}
	
	function getRunnableMethods(){
		return runnableMethods;
	}
	
	/* BDD equivalents of setup/teardown, etc */
	function beforeAll(){}
	function afterAll(){}
	function before(){}
	function after(){}


	function describe( name, expectations="" ){
		if( isClosure( arguments.expectations ) ){
			specs[name] = {};
			variables.currentDescriptionContext = arguments.name;

			expectations();
		} else {
			throw("Description for #name# did not include a closure/function argument... ignoring");
		}

		variables.currentDescriptionContext = "";
	}

	function it( should, code ){
		writeLog("inside it: should = #should#");
		arrayAppend( runnableMethods, "#variables.currentDescriptionContext# : #should#");
		specs[ variables.currentDescriptionContext ][should] = code;
	}
	
	function executeSpec( methodName, args="#{}#" ){
		writeLog( "executing spec #methodName#" );
		var desc = trim(listFirst( methodName, ":" ));
		var spec = trim(listLast( methodName, ":" ));
		var fn = variables.specs[ desc ][ spec ];
		var outputOfTest = "";

		savecontent variable="outputOfTest"{
			debug(variables.specs[desc]);
			debug(spec);
			fn();
		}
		return outputOfTest;
	}
	
	/* Add 'expectation' behaviors */
	
	function expect( value ){
		variables.actual = value;
		return this;
	}
	
	
	function toBeTrue( message = "" ){
		assertTrue( getActual(), message );
	}
	
	function toBeFalse( message = "" ){
		assertFalse( getActual(), message );
	}
	
	function toBe( expected, message = "" ){
		if( isObject( getActual() ) && isObject( expected ) ){
			assertSame( getActual(), expected, message );		
		} else {
			assertEqualsCase( getActual(), expected, message );
		}
	}
	
	function toNotBe( expected, message = "" ){
		if( isObject( getActual() ) && isObject( expected ) ){
			assertNotSame( getActual(), expected, message );		
		} else {
			assertNotEqualsCase( getActual(), expected, message );
		}
	}
	
	function toEqual( expected, message = ""  ){
		assertEquals( getActual(), expected, message );
	}
	
	function toNotEqual( expected, message = ""  ){
		assertNotEquals( getActual(), expected, message );
	}
	
	/* TestCase overrides */
	
	function getAnnotation( methodName, annotationname, defaultValue="" ){
		//TODO: implement
		return defaultValue;
	}
	
	//TODO: DataProviders! Test Decorators. ExpectedException. What else?
	
	function beforeTests(){
		beforeAll();
	}
	
	function setUp(){
		before( argumentCollection=arguments );
	}
	
	function tearDown(){
		after( argumentCollection=arguments );
	}
	
	function afterTests(){
		afterAll();
	}
	
	function invokeTestMethod( methodName, args="#{}#" ){
		return executeSpec( methodname, args );
	}
	
	function onMissingMethod( missingMethodName, missingMethodArguments ){
		throw( "Spec.onMissingMethod: Unknown method #missingMethodName#" );
	}

}