 <cfcomponent  extends="mxunit.framework.TestCase">


	<cffunction name="testAdd" access="public" returntype="void">
  
	  <cfscript>
     testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
     testSuite.addAll("mxunit.tests.bugs.fixture.test-with_hyphen");
     testSuite.addAll("mxunit.tests.bugs.fixture.test_with_underscore");
     suites = testSuite.suites();
     //debug(suites["mxunit.tests.bugs.fixture.test-with_hyphen"]);
     methods = suites.get("mxunit.tests.bugs.fixture.test-with_hyphen").methods;
     assertEquals(3,arrayLen(methods),"Should be adding to methods element.");
    
    </cfscript>
      
	</cffunction>

  <cffunction name="testRunSuiteRemote" access="public" returntype="void">
   Maybe needs to be a behavioral test ...  
	  <cfscript>
     testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
     testSuite.addAll("mxunit.tests.bugs.fixture.test-with_hyphen");
     testSuite.addAll("mxunit.tests.bugs.fixture.test_with_underscore");
    // testSuite.runTestRemote('html');//should just spit it all out        
    </cfscript>
		
	<!--- without this, the extjs view gets all messed up! All we're testing 
	here is that it doesn't blow up; we're not making any assertions --->
	<cfsilent>
		<cfset testSuite.runTestRemote('html')>
	</cfsilent>
      
	</cffunction>

	<cffunction name="settingMockingFrameworkInTestSuiteUsesThatFramework" access="public" returntype="void">
  
	  <cfscript>
     testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
     testSuite.addAll("mxunit.tests.framework.fixture.Mocking");
	 testSuite.setMockingFramework("ColdMock");
	 testSuite.run();
    </cfscript>
      
	</cffunction>
	
	<cffunction name="testAddOneTestMethod">    
		<cfscript>
		var testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();   
		testSuite.add("mxunit.tests.framework.fixture.fixturetests.SomeRandomTest", "testThree");
		results = testSuite.run();
		assertEquals(1, arrayLen(results.results));      
		</cfscript>   
	</cffunction>

	<cffunction name="testGetMapReturnsMap">
		<cfscript>
		var testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();   
		var map = "";

		makePublic(testSuite,"getMap");
		map = testSuite.getMap();
		
		assertTrue(isInstanceof(map,"java.util.Map"));
		</cfscript>
	</cffunction>

	<cffunction name="setUp" access="public" returntype="void">

	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">

	</cffunction>
	

</cfcomponent>
