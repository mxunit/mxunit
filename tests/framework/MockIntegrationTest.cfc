<cfcomponent  extends="mxunit.framework.TestCase">

<cffunction name="_setFactoryOk" access="private" returntype="void"><!--- do nada for ok ---></cffunction>
<cffunction name="_setFactoryNotOk" access="private" returntype="void">
  <cfthrow type="Expression" message="Can't find component X ...">
</cffunction>



<cfscript>	
		
	// Mocking integration tests
    function setUp(){
		//mock mock framework      	
        $mock = mock("my.mock.factory");			
		
		//mock mockfactory
		$factory = mock("mxunit.framework.MockFactoryFactory");
	    $factory.setFactory('{string}').returns();
		$factory.getFactory().returns($mock);			
		
		//the real deal
		realMockFactory = createObject('component','mxunit.framework.MockFactoryFactory').MockFactoryFactory("MightyMock");
    }

    //Reset State back to normal
    function tearDown(){
		$factory.reset();
		$mock.reset();
		setMockingFramework("");
		_setMockFactory(realMockFactory);  
	 }
	
	
	function $getMM(){
	//the real deal
		var f = createObject('component','mxunit.framework.MockFactoryFactory');
		f.MockFactoryFactory("MightyMock");
	}
	
	
	
	function getMockFactoryIsInvokedOnce() {
			_setMockFactory($factory);
			//set fw
			setMockingFramework("ColdMock");
			//check/guard
			assertTrue( this.MockingFramework == 'ColdMock' , "mock framework not set correctly" );
			//this is our "main" test
			mf = getMockFactory();
			//verify
			$factory.verifyTimes(1).getFactory();
		}
	
	
		
		function getMockFactoryReturnsMightyMockByDefault() {
			_setMockFactory(realMockFactory);
			mf = getMockFactory();
			assertIsTypeOf(mf,"mxunit.framework.mightymock.MockFactory");
		}

	
		// For built-in MightyMock
		
		function mockNoNameShouldReturnMightyMockObject() {
			mymock =  mock();
			//debug( mymock.debugMock() );
			assertIsTypeOf(mymock,"mxunit.framework.mightymock.MightyMock");
			assertEquals("",mymock.getMocked().name);
		}
		


		function mockExplicitFastShouldReturnFastMightyMockObject() {
			mymock =  mock(mockType="fast");
			assertIsTypeOf(mymock,"mxunit.framework.mightymock.MightyMock");
			assertEquals("",mymock.getMocked().name);
		}
		
		function mockWithNameShouldReturnNamedMightyMockObject() {
			mymock =  mock("foo");
			assertIsTypeOf(mymock,"mxunit.framework.mightymock.MightyMock");
			assertEquals("foo",mymock.getMocked().name);
		}
				
		function mockWithTypeSafeShouldCreateTypeSafeMightyMockObject() {
			mymock =  mock("mxunit.framework.Assert","typeSafe");
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			assertEquals("mxunit.framework.Assert",mymock.getMocked().name);
		}
		
		function mockWithActualObjectShouldCreateTypeSafeMightyMockObject() {
			assert = createObject("component","mxunit.framework.Assert");
			mymock =  mock(assert);
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			assertEquals("mxunit.framework.Assert",mymock.getMocked().name);
		}
	
	
	</cfscript>
	
	
	
	<cffunction name="mockWithPartialShouldThrow" mxunit:expectedException="MightyMock.MockFactory.PartialMocksNotImplemented">
		<cfset mymock =  mock("mxunit.framework.Assert","partial") />
	</cffunction>



	<cffunction name="notregisteredMockFrameworkShouldThrowNotResgiteredException" mxunit:expectedException="org.mxunit.exception.MockFrameworkNotRegisteredException">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory') />
		 <cfset f.findMockFactory("hoosfoos") />
	</cffunction>

	<cffunction name="notinstalledMockFrameworkShouldThrowNotInstalledException" mxunit:expectedException="org.mxunit.exception.MockFrameworkNotInstalledException">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory') />
		 <cfset f.setFactory("coldmock.ColdMock") />
	</cffunction>
	
	<cffunction name="notinstalledMockBoxShouldThrowNotInstalledException" mxunit:expectedException="org.mxunit.exception.MockFrameworkNotInstalledException">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory') />
		 <cfset f.setFactory("coldmock.ColdMock") />
	</cffunction>
	
	<cffunction name="notinstalledColdMockShouldThrowNotInstalledException2" mxunit:expectedException="org.mxunit.exception.MockFrameworkNotInstalledException">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory').MockFactoryFactory("ColdMock") />
	</cffunction>
	
	<cffunction name="notinstalledMockBoxShouldThrowNotInstalledException2" mxunit:expectedException="org.mxunit.exception.MockFrameworkNotInstalledException">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory').MockFactoryFactory("MockBox") />
	</cffunction>
	
	
	<cffunction name="emptyConstructorShouldGenerateMM">
		 <cfset	var f = createObject('component','mxunit.framework.MockFactoryFactory').MockFactoryFactory() />
		 <cfset assertIsTypeOf(f.getFactory(), "mxunit.framework.mightymock.MockFactory") />
	</cffunction>

	<!--- For ColdMock --->
	<!--- 						
		<cffunction name="mockCMWithActualObjectShouldThrow" mxunit:expectedException="Expression">
			<cfset assert = createObject("component","mxunit.framework.Assert") />
			<cfset mymock =  mock(fw="ColdMock", mocked=assert) />
		</cffunction>
		
		
		<!--- Seems like these are testing the dependencies and not MXUnit? --->
		
		<cffunction name="mockCMWithValidNameShouldReturnColdMockObject">
			<cfscript>
				mymock =  mock(fw="ColdMock",mocked="mxunit.framework.Assert");
				assertIsTypeOf(mymock,"mxunit.framework.Assert");
				mymock.mockMethod("getHashCode").returns("Hello!");
				assertEquals("Hello!",mymock.getHashCode(""));
			</cfscript>
		</cffunction>
				
		<!--- For MockBox --->
		
		<cffunction name="mockMBNoNameShouldThrow" mxunit:expectedException="Application">
			<cfset mymock = mock(fw="MockBox") />
		</cffunction>
		
		<cffunction name="mockMBWithInvalidNameShouldThrow" mxunit:expectedException="Application">
			<cfset mymock = mock(fw="MockBox",mocked="foo") />
		</cffunction>
		
		<cfscript>
		
		function mockMBWithValidNameShouldReturnMockBoxObject() {
			mymock =  mock(fw="MockBox",mocked="mxunit.framework.Assert");
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			mymock.$(method="crazyMethod",returns="Hello!");
			assertEquals("Hello!",mymock.crazyMethod(""));
			assertTrue(structkeylist(mymock) contains "assertEquals");
		}
		
		function mockMBWithActualObjectShouldReturnMockBoxObject() {
			assert = createObject("component","mxunit.framework.Assert");
			mymock =  mock(fw="MockBox",mocked=assert);
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			mymock.$(method="crazyMethod",returns="Hello!");
			assertEquals("Hello!",mymock.crazyMethod(""));
		}

		function mockMBCanCreateAnEmptyMockViaArguments() {
			mymock =  mock(fw="MockBox",mocked="mxunit.framework.Assert",clearMethods=true);
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			mymock.$(method="crazyMethod",returns="Hello!");
			assertEquals("Hello!",mymock.crazyMethod(""));
			assertFalse(structkeylist(mymock) contains "assertEquals");
		}
		
		
		
		
	</cfscript>

	
	
 --->

</cfcomponent>


