<cfcomponent  extends="mxunit.framework.TestCase">

	<cfscript>
	// Mocking integration tests
	
		// for mockFactory
		
		function getMockFactoryReturnsMightyMockByDefault() {
			mf = getMockFactory();
			assertIsTypeOf(mf,"mxunit.framework.mightymock.MockFactory");
		}



		//We don't want to have to create a dependency on external
		//resources in order to run tests.
		function getMockFactoryReturnsSpecificMockFactory() {
			mb = mock("Coldbox.system.testing.MockBox");
			mf = mock().getMockFactory("MockBox").returns(mb);
			o = mf.getMockFactory("MockBox");
			mockDebugData = o.debugMock();
			a = structKeyarray(mockDebugData);
			debug( mockDebugData[a[3]]);
			//Railo bug doesn't find name in struct?
			assertEquals("Coldbox.system.testing.MockBox", mockDebugData[a[3]]);
			//assertIsTypeOf(o,"Coldbox.system.testing.MockBox");
		}


		function getMockFactoryReturnsSpecificMockFactoryAfterSettingFrameworkName() {
			setMockingFramework("ColdMock");
			mf = getMockFactory();
			assertIsTypeOf(mf,"coldmock.MockFactory");
			setMockingFramework("");
		}

		// For built-in MightyMock
		
		function mockNoNameShouldReturnMightyMockObject() {
			mymock =  mock();
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
	
	<cffunction name="mockWithPartialShouldThrow" mxunit:expectedException="MightyMock.MockFactory.partialMocksNotImplemented">
		<cfset mymock =  mock("mxunit.framework.Assert","partial") />
	</cffunction>

	<!--- For ColdMock --->
		
		<cffunction name="mockCMNoNameShouldThrow" mxunit:expectedException="mock.invalidCFC">
			<cfset mymock = mock(fw="ColdMock") />
		</cffunction>
		
		<cffunction name="mockCMWithInvalidNameShouldThrow" mxunit:expectedException="mock.invalidCFC">
			<cfset mymock = mock(fw="ColdMock",mocked="foo") />
		</cffunction>
						
		<cffunction name="mockCMWithActualObjectShouldThrow" mxunit:expectedException="Expression">
			<cfset assert = createObject("component","mxunit.framework.Assert") />
			<cfset mymock =  mock(fw="ColdMock",mocked=assert) />
		</cffunction>
		
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
		
		
		//beforeTest test
		function $invokeBeforeTestsShouldSetSimpleValue(){
		   debug(before_tests_expected);
		}
		
		function $invokeAfterTestsShouldBeCalled(){
		  fail("how to test afterTests?");
		}
		
	</cfscript>

	
	

</cfcomponent>


