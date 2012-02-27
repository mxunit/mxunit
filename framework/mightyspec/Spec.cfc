component extends="mxunit.framework.TestCase" {

	specs = {};
	runnableMethods = [];
	currentDescriptionContext = "";
	currentSpecContext = "";
	variables.actual = "";
	variables.expected = "";
	
	public struct function getSpecs(){
		return specs;
	}
	
	/**
	*  A Description of specifications
	   @name A string usually representing the component, or specific behavior of a component, under test
	   @definitions a function closure containing one or more Specs, as represented by it() calls
	   
	   Usage:
	   
	   describe( "A Component", function(){
	   	var cut = new ComponentUnderTest();
	   	it("should do this", function(){
	   		expect( cut.doSomething() ).toEqual( 42 );
	   	});
	   	
	   	it("should do this other thing", function(){
	   		expect( cut.doSomethingElse() ).toEqual( 101 );
	   	});
	   });
	   
	*/
	public Spec function describe( name, definitions="" ){
		if( isClosure( arguments.definitions ) ){
			specs[name] = {};
			variables.currentDescriptionContext = arguments.name;
			//invoke specs
			definitions();
		} else {
			throw("Description for #name# did not include a closure/function argument... ignoring");
		}

		variables.currentDescriptionContext = "";
		variables.currentSpecContext = "";
		return this;
	}

	/**
	*  A Spec. 
	
		@should describes the specification
		@code is a function closure implementing the expectations for the spec
	*/
	public Spec function it( String should, code ){
		variables.currentSpecContext = should;
		arrayAppend( runnableMethods, "#variables.currentDescriptionContext# : #should#");
		specs[ variables.currentDescriptionContext ][should] = { code = code, annotations = {} };
		return this;
	}
	
	/**
	* Attaches an annotation to the current spec context, i.e. the *last* call to it()
	
		Preferred usage is to use a .withXXX function, where XXX is the name of the known
		Annotation, such as "DataProvider", "ExpectedException", etc. onMissingMethod will translate
		that into the appropriate withAnnotation() call
	
		Usage:
		
		describe(....
			var myArray = [1,2,3,4];
			it("..", function(){
			}).withDataProvider(myArray);
		
		);
	
	*/
	package Spec function withAnnotation( annotationName, annotationValue ){
		var context = getCurrentSpecContext();
		context.annotations[ annotationName ] = annotationValue;
		
		return this;
	}
	
	/* Equivalents of setup/teardown, etc */
	function beforeAll(){}
	function afterAll(){}
	function beforeEach(){}
	function afterEach(){}
	
	/* expectations you use in your specs */
	
	public Spec function expect( value ){
		variables.actual = value;
		return this;
	}
	
	public Spec function toEqual( expected, message = "" ){
		assertEquals( expected, getActual(), message );
		return this;
	}

	public Spec function toNotEqual( expected, message = "" ){
		assertNotEquals( expected, getActual(), message );
		return this;
	}
	
	public Spec function toBeTrue( message = "" ){
		assertTrue( getActual(), message );
		return this;
	}

	public Spec function toBeFalse( message = "" ){
		assertFalse( getActual(), message );
		return this;
	}
	
	public Spec function toBe( expected, message = "" ){
		if( isObject( getActual() ) && isObject( expected ) ){
			assertSame( expected, getActual(), message );		
		} else {
			assertEqualsCase( expected, getActual(), message );
		}
		return this;
	}
	
	public Spec function toNotBe( expected, message = "" ){
		if( isObject( getActual() ) && isObject( expected ) ){
			assertNotSame( expected, getActual(), message );		
		} else {
			assertNotEqualsCase( expected, getActual(), message );
		}
		return this;
	}
	
	public Spec function toBeTypeOf( String type ){
		assertIsTypeOf( getActual(), type );
		return this;
	}

	public Spec function toBeExactTypeOf( String type ){
		assertIsExactTypeOf( getActual(), type );
		return this;
	}
	
	
	public Spec function toBeAnXMLDoc( message = "" ){
		return _assertTruth( assertIsXMLDoc, message );
	}

	public Spec function toBeAnArray( message = "" ){
		return _assertTruth( assertIsArray, message );
	}

	public Spec function toBeAStruct( message = "" ){
		return _assertTruth( assertIsStruct, message );
	}

	public Spec function toBeAQuery( message = "" ){
		return _assertTruth( assertIsQuery, message );
	}
	
	public Spec function toBeAnObject( message = "" ){
		return _assertTruth( assertIsObject, message );
	}
	
	public Spec function toBeEmpty( message = "" ){
		return _assertTruth( assertIsEmpty, message );
	}
	
	private function _assertTruth( fn, message = "" ){
		fn( getActual(), message );
		return this;
	}
	
	private function executeSpec( methodName, args="#{}#" ){
		var context = getSpecContextFromFullSpecName( methodName );
		var thisSpecCode = context.code;
		var outputOfTest = "";

		savecontent variable="outputOfTest"{
			thisSpecCode();
		}
		return outputOfTest;
	}
	
	private function getCurrentDescriptionContext(){
		return specs[ variables.currentDescriptionContext ];
	}
	
	private function getCurrentSpecContext(){
		var descContext = getCurrentDescriptionContext(); 
		return descContext[ variables.currentSpecContext ];
	}
	
	private function getSpecContextFromFullSpecName( methodName ){
		var desc = trim(listFirst( methodName, ":" ));
		var spec = trim(listLast( methodName, ":" ));
		return variables.specs[ desc ][ spec ];
	}
	
	function beforeTests(){
		beforeAll();
	}
	
	function setUp(){
		beforeEach( argumentCollection=arguments );
	}
	
	function tearDown(){
		afterEach( argumentCollection=arguments );
	}
	
	function afterTests(){
		afterAll();
	}
		
	public array function getRunnableMethods(){
		return runnableMethods;
	}
	
	public function invokeTestMethod( methodName, args="#{}#" ){
		return executeSpec( methodname, args );
	}
	
	public function getMethodFromTestCase( methodName ){
		var context = getSpecContextFromFullSpecName( methodName );
		return context.code;
	}
	
	public Any function getAnnotation( methodName="", annotationname, defaultValue="" ){
		if( methodName eq "" ){
			return super.getAnnotation( argumentCollection = arguments );
		}
		
		var context = getSpecContextFromFullSpecName( methodName );
		if( structKeyExists( context.annotations, annotationName ) ){
			return context.annotations[ annotationName ];
		}
		return defaultValue;
	}
	
	function onMissingMethod( missingMethodName, missingMethodArguments ){
		if( lcase(missingMethodName).startsWith("with") ){
			return onMissingWithMethod( argumentCollection = arguments );
		}
		
		throw( "Spec.onMissingMethod: Unknown method #missingMethodName#" );
	}
	
	private function onMissingWithMethod(missingMethodName, missingMethodArguments){
		var annotationName = mid(missingMethodName, 5, len(missingMethodName) - 4);
		return withAnnotation( annotationName, missingMethodArguments[1] );
	}

}