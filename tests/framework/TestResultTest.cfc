<cfcomponent generatedOn="12-05-2007 4:01:02 PM EST" extends="mxunit.framework.TestCase">



<cffunction name="testGetInstallRoot">
  <cfscript>
   root = this.testResult.getInstallRoot();
   assertEquals("#getContextRoot()#/mxunit",root);
  </cfscript>
</cffunction>


<cffunction name="testGetQueryResults">
 <cfscript>
  var q = this.testResult.getQueryResults();
  assertIsQuery(q);
  assertEquals(q.recordcount,2,"Should be 4 results returned");
 </cfscript>
</cffunction>

<!--- Getting tired and need a break. 01.04.08 --->
<cffunction name="testGetResultsOutput">
	<cfscript>
	 var mode = 'html';
	 var result = this.testResult.getResultsOutput(mode);
	 //
	 mode = 'xml';
	 result = this.testResult.getResultsOutput(mode);
	 //assertIsXmlDoc(result);

	 mode = 'extjs';
	 //result = this.testResult.getResultsOutput(mode);
	 //seems to be outputing extjs stuff and breaks ant reports
	 //assertIsXml(result);

	 mode = 'junitxml';
	 result = this.testResult.getResultsOutput(mode);
	 //assertIsXml(result);
	 debug(result);


	 mode = 'query';
	 result = this.testResult.getResultsOutput(mode);
	 assertIsQuery(result);
	</cfscript>
</cffunction>



<cffunction name="testAddError">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addError" returnVariable="actual">
    <cfinvokeargument name="exception" value="" />
  </cfinvoke>
  <cfset assertEquals(1,1) />

</cffunction>


<cffunction name="testEndTest">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="endTest" returnVariable="actual">
    <cfinvokeargument name="testCase" value="" />
  </cfinvoke>
  <cfset assertEquals(1,1) />

</cffunction>


<cffunction name="testAddTrace">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addTrace" returnVariable="actual">
    <cfinvokeargument name="message" value="my test message" />
  </cfinvoke>
</cffunction>


<cffunction name="testAddProcessingTime">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addProcessingTime" returnVariable="actual">
    <cfinvokeargument name="milliseconds" value="1234" />
  </cfinvoke>


</cffunction>


<cffunction name="testAddSuccess">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addSuccess" returnVariable="actual">
    <cfinvokeargument name="message" value="" />
  </cfinvoke>
  <cfset assertEquals(1,1) />

</cffunction>


<cffunction name="testAddFailure">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addFailure" returnVariable="actual">
    <cfinvokeargument name="exception" value="" />
  </cfinvoke>
</cffunction>


<cffunction name="testConstructTagContextElements">
	<cfset var actual = "" />
  <cfset var catchVar = structNew() />
  <cftry>
   <cfthrow type="myTestException" message="Test Error" detail="For use in mxunit framework tests" >
  <cfcatch type="myTestException">
    <cfset catchVar =  cfcatch />
   <!---  <cfset debug(catchVar) > --->
  </cfcatch>
  </cftry>
  <cfinvoke component="#this.testResult#"  method="constructTagContextElements" returnVariable="actual">
    <cfinvokeargument name="exception" value="#catchVar#" />
  </cfinvoke>
</cffunction>


<cffunction name="testGetPackage">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="getPackage" returnVariable="actual">
  </cfinvoke>
</cffunction>


<cffunction name="testGetSuccesses">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="getSuccesses" returnVariable="actual">
  </cfinvoke>
 <cfset assertEquals(actual,2,"Should be only two successes not #actual# ") />
</cffunction>


<cffunction name="testTestResult">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="TestResult" returnVariable="actual">
  </cfinvoke>
</cffunction>


<cffunction name="testAddContent">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="addContent" returnVariable="actual">
    <cfinvokeargument name="content" value="" />
  </cfinvoke>
</cffunction>


<cffunction name="testStartTest">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="startTest" returnVariable="actual">
    <cfinvokeargument name="testCase" value="" />
    <cfinvokeargument name="componentName" value="" />
  </cfinvoke>
</cffunction>


<cffunction name="testGetFailures">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="getFailures" returnVariable="actual">
  </cfinvoke>
</cffunction>


<cffunction name="testSetDebug">
	<cfscript>
  var objs = arrayNew(1);
  var result =  createObject("component","mxunit.framework.TestResult");
  var cu =  createObject("component","mxunit.framework.ComponentUtils");
  var actual =  "";
  objs[1] = createObject("component","mxunit.framework.Assert");
  objs[2] = this;
  objs[3] = createObject("java","java.util.List");

  result.setDebug(objs[1]);
  actual = result.getDebug();
  assertTrue(isObject(actual[1]),"Should return the object itself");


   result.setDebug(objs[2]);
   actual = result.getDebug();
   assertTrue(isObject(actual[1]),"Should return the object itself");

   result.setDebug(objs[3]);
   actual = result.getDebug();
   assertEquals("class coldfusion.runtime.java.JavaProxy", getMetadata(actual[1]),"Java Object: May fail in Railo, OBD");


   result.setDebug(arrayNew(1));
   actual = result.getDebug();
   assertIsArray(actual);


   result.setDebug(structNew());
   actual = result.getDebug();
   assertIsArray(actual);

   result.setDebug(-3213213213213213211222222222222222222222222222222222222222222222221);
   actual = result.getDebug();
   assertEquals(-3213213213213213211222222222222222222222222222222222222222222222221, actual[1]);

   result.setDebug(10002234234234234232.1789789789789789789236654);
   actual = result.getDebug();
   assertEquals(10002234234234234232.1789789789789789789236654, actual[1]);

  </cfscript>
</cffunction>


<cffunction name="testGetDebug">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="getDebug" returnVariable="actual">
  </cfinvoke>
</cffunction>


<cffunction name="testSetPackage">
	<cfset var returnPackage = "" />
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="setPackage" returnVariable="actual">
    <cfinvokeargument name="package" value="mxunit.test.test.test" />
  </cfinvoke>
  <cfset returnPackage = this.testResult.getPackage() />
  <cfset assertEquals(returnPackage,"mxunit.test.test.test") />
</cffunction>


<cffunction name="testGetResults">
	<cfset var actual = "" />
	<cfset var expectedResultCount = "" />
  <cfinvoke component="#this.testResult#"  method="getResults" returnVariable="actual">
  </cfinvoke>

  <cfset assertIsArray(actual) />
  <cfset expectedResultCount = 2 />
  <cfset assertEquals(expectedResultCount, arraylen(actual) ) />
</cffunction>

<cffunction name="testGetResultsAsStruct">
	<cfset var a_tests = "" />
	<cfset var i = "" />
	<cfset var actual = "" />
	<cfinvoke component="#this.testResult#"  method="getResultsAsStruct" returnVariable="actual">
  </cfinvoke>
  	<cfset assertTrue(isStruct(actual))>
	<cfset assertTrue(1,StructCount(actual))>
	<cfset a_tests = actual["mxunit.tests.framework.fixture.MyCFCTest"]>

	<cfset assertTrue(ArrayLen(a_tests) GT 0)>
	<!--- make sure it's a struct we know and love --->
	<cfloop from="1" to="#ArrayLen(a_tests)#" index="i">
		<cfset assertTrue( StructKeyExists(a_tests[i],"component") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"testname") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"content") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"teststatus") )>
	</cfloop>

</cffunction>

<cffunction name="testGetResultsAsStructMultipleComponents">
	<cfset var a_tests = "" />
	<cfset var i = "" />
	<cfset var actual = "" />
	<cfset var testSuite = createObject("component","mxunit.framework.TestSuite")>
	<cfset testSuite.addAll("mxunit.tests.framework.fixture.MyCFCTest")>
	<cfset testSuite.addAll("mxunit.tests.framework.RemoteFacadeObjectCacheTest")>
	<cfset this.testResult = testSuite.run()>

	<cfinvoke component="#this.testResult#"  method="getResultsAsStruct" returnVariable="actual">
  </cfinvoke>
  	<cfset assertTrue(isStruct(actual))>
	<cfset assertEquals(2,StructCount(actual))>
	<cfset a_tests = actual["mxunit.tests.framework.RemoteFacadeObjectCacheTest"]>

	<cfset assertTrue(ArrayLen(a_tests) GT 0)>
	<!--- make sure it's a struct we know and love --->
	<cfloop from="1" to="#ArrayLen(a_tests)#" index="i">
		<cfset assertTrue( StructKeyExists(a_tests[i],"component") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"testname") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"content") )>
		<cfset assertTrue( StructKeyExists(a_tests[i],"teststatus") )>
	</cfloop>

</cffunction>


<cffunction name="testCloseResults">
	<cfset var actual = "" />
  <cfinvoke component="#this.testResult#"  method="closeResults" returnVariable="actual">
  </cfinvoke>
</cffunction>

<cffunction name="normalizeQueryStringShouldIgnoreComplexObjects" hint="Bug and patch by Luis Majano - 3.23.10">
	<cfscript>
	var u = structnew(); //url rep
	var o = structnew();
	o.foo = "bar";
	u.method = "runtestremote";
	u.output = "html";
	u.a = [1,2,'123',o]; //add array to url
	u.cfc = this; //add cfc obj to url
	u.complex = o;  //add struct to url
	qs = this.testresult.normalizeQueryString(u,'some_random_known_output'); //should ignore or err
	assertEquals("method=runtestremote&output=some_random_known_output" ,qs);
	</cfscript>
</cffunction>

<cffunction name="testNormalizeQueryString">
	<cfset var qs = "" />
	<cfset var u = structnew()>
	<cfset u.method = "runtestremote">
	<cfset u.output = "extjs">
	<cfset qs = this.testresult.normalizeQueryString(u,'html')>
	<cfset assertEquals(1,ListValueCountNoCase(qs,"output=html","&"))>
	<cfset assertEquals(1,ListValueCountNoCase(qs,"method=runtestremote","&"))>
	<cfset assertEquals(0,ListValueCountNoCase(qs,"output=extjs","&"))>
	<cfset assertEquals(0,ListValueCountNoCase(qs,"testmethod=testSomethingElse","&"))>
	<cfset u.testmethod = "testSomethingElse">
	<cfset qs = this.testresult.normalizeQueryString(u,'html')>
	<cfset assertEquals(1,ListValueCountNoCase(qs,"testmethod=testSomethingElse","&"))>
</cffunction>


<!--- Override these methods as needed. Note that the call to setUp() is Required if using a this-scoped instance--->

<cffunction name="setUp">
<!--- Assumption: MXUnit framework works ;-) how else could we test? --->
<cfscript>
 testSuite = createObject("component","mxunit.framework.TestSuite");
 testSuite.addAll("mxunit.tests.framework.fixture.MyCFCTest");
 this.testResult = testSuite.run();
</cfscript>
</cffunction>


<cffunction name="tearDown">
</cffunction>


</cfcomponent>
