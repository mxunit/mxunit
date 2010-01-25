 
<cfcomponent  extends="mxunit.framework.TestCase">

<!--- Begin Specific Test Cases --->
	<cffunction name="testAdd" access="public" returntype="void">
  
	  <cfscript>
     testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
     testSuite.addAll("mxunit.tests.bugs.fixture.test-with_hyphen");
     testSuite.addAll("mxunit.tests.bugs.fixture.test_with_underscore");
     suites = testSuite.suites();
     debug(suites["mxunit.tests.bugs.fixture.test-with_hyphen"]);
     methods = suites["mxunit.tests.bugs.fixture.test-with_hyphen"].methods;
     debug(methods);
     assertEquals(3,arrayLen(methods),"Should be adding to methods element.");
     results = testSuite.run();
     debug(results);
    </cfscript>
      
	</cffunction>

  

	
	<cffunction name="testAddAssertTests" access="public" returntype="void">
   
	  <cfscript>
     testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
     testSuite.addAll("mxunit.tests.framework.AssertTest");
     testSuite.addAll("mxunit.tests.bugs.fixture.test-with_hyphen");
     debug(testSuite.suites());
     
     //assertEquals(2,arrayLen(testSuite.tests),"Should be adding to methods element.");
     
    </cfscript>
      
	</cffunction>


<cffunction name="testStructs">
  <cfscript>
   componentName = "mxunit.tests.bugs.fixture.test-with_hyphen";
   testSuites = structNew();
   tempStruct = structNew();
   tempStruct.ComponentObject = createObject("component",componentName);
   methods = arrayNew(1);
   methods[1] = "test1";
   methods[2] = "test2";
   methods[3] = "test3";
   tempStruct.methods =  methods ;
   testSuites[componentName] = tempStruct;
   debug(testSuites);
  </cfscript>

</cffunction>


	<cffunction name="setUp" access="public" returntype="void">
	  <!--- Place additional setUp and initialization code here --->
	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->	
	</cffunction>
	

</cfcomponent>
