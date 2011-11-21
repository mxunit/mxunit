<!---
	MXUnit TestCase Template
	@author
	@description
	@history
	--->
<cfcomponent  extends="mxunit.framework.TestCase">

	<!--- Begin Specific Test Cases --->

	<cffunction name="testAssertEqualsCaseShouldPassOnSameStrings">
		<cfscript>
			var expected = 'a QuicK BrOWN foX';
			var actual = 'a QuicK BrOWN foX';
			assertEqualsCase( expected , actual );
		</cfscript>
	</cffunction>


	<cffunction name="testAssertEqualsCaseShouldFailOnDifferentCasedStrings">
		<cfscript>
			var expected = 'a quick brown fox';
			var actual = 'A QUICK BROWN FOX';
			try{
			 assertEqualsCase( expected , actual );
			 fail('should not get here');
			}
			catch(mxunit.exception.AssertionFailedError e){

			}

		</cfscript>
	</cffunction>


	<cffunction name="testAssert">
		<cfscript>
			var foo = [1,2,{foo='bar'}];
			assert(true,"should pass");

			try{
			  assert (false);
			}
			catch(mxunit.exception.AssertionFailedError e){
			 //ok we're good
			 // caught expected exception : assert(false)
			}

			assert(1 eq 1);
			try{
			  assert (1 eq 0);
			}
			catch(mxunit.exception.AssertionFailedError e){
			 //ok we're good
			 // caught expected exception : assert(1 eq 0)
			}

			try{
			 assert (foo);
			}
			catch(Application e){
			  // should not allow complex objects. But what's the exception type here, CF?
			}

			try{
			 assert ('some string');
			}
			catch(Expression e){
			 // should not allow strings, either;
			}

			//  assert (_MIN lt _MAX , "@see setUp() for system MIN and MAX values.");

		</cfscript>
	</cffunction>


	<cffunction name="testGetStringValue">
		<cfscript>
			var trace = "";
			var foo = structNew();
			var foo2 = structNew();
			var a = arrayNew(1);
			a[1] = myComponent3;
			a[2] = myComponent4;
			foo2.bar = a;
			foo.bar =  myComponent3;
			foo.bar2 = myComponent4;
			foo.bar3 = foo2;
			writeoutput(getStringValue(foo)) ;
			exp = "test stringValue output from ComparatorTestData.cfc";
			assertEquals(exp, getStringValue(myComponent3), "getStringValue(myComponent3) problem");
		</cfscript>
	</cffunction>


	<cffunction name="testAssertEqualsCFUnitFailure" returntype="void" hint="">
		<cfset setTestStyle("cfunit") />
		<cftry>
			<!--- do something here to cause an error --->
			<cfset assertEquals("message",1,2) />
			<cfthrow message="We should have failed prior to this">
			<cfcatch type="mxunit.exception.AssertionFailedError"><!--- we want this! ---></cfcatch>
			<cfcatch type="any"><cfrethrow></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testFailNotEqualsCFUnit" returntype="void" hint="">
		<cfset setTestStyle("cfunit") />
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failNotEquals(1,2,"my message",false) />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfif not (
						(find("[1]",cfcatch.message) OR find("[2]",cfcatch.message))
						or (find("[1.0]",cfcatch.message) OR find("[2.0]",cfcatch.message))
					)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testFailNotEquals">
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failNotEquals(1,2,"my message") />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfif not (
						(find("[1]",cfcatch.message) OR find("[2]",cfcatch.message))
						or (find("[1.0]",cfcatch.message) OR find("[2.0]",cfcatch.message))
					)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="failNotEqualsShouldAllowInvalidXMLCharsInActual">
		<!--- this was added to test http://jira.mxunit.org/browse/MXUI-12
			It passes using the html runner, but fails with an org.xml.sax.SAXParseException: Premature end of file.
			with the Eclipse plugin --->
		<cftry>
			<cfset failNotEquals(1,chr(30),"my message") />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfif not (
						find("[1]",cfcatch.message)
						OR find("[1.0]",cfcatch.message)
					) OR not find(chr(30),cfcatch.message)>
					<cfset fail("Should've had [1] and #chr(30)# in the throw message but instead the message was #cfcatch.message#") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testFailEquals" returntype="void" hint="tests error path">
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failEquals(1,2,"my message") />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfif not (
						(find("[1]",cfcatch.message) OR find("[2]",cfcatch.message))
						or (find("[1.0]",cfcatch.message) OR find("[2.0]",cfcatch.message))
					)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testFailEqualsCFUnit" returntype="void" hint="tests error path">
		<cfset setTestStyle("cfunit") />
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failEquals(1,2,false) />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfif not (
						(find("[1]",cfcatch.message) OR find("[2]",cfcatch.message))
						or (find("[1.0]",cfcatch.message) OR find("[2.0]",cfcatch.message))
					)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#") />
				</cfif>
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testAssertEquals" access="public" returntype="void">
		<cfscript>
			assertEquals(myComponent4, myComponent3,"stringValue() implemented"); //
		</cfscript>
	</cffunction>


	<cffunction name="whenAssertEqualsFailsForStringsExpectedAndActualValuesShouldBePopulated">
		<cftry>
			<cfset assertEquals("Please Excuse me sir","Please Excuse me madam") />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset assertEquals("Please Excuse me sir", getExpected()) />
				<cfset assertEquals("Please Excuse me madam", getActual()) />
			</cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="whenAssertEqualsPassesExpectedAndActualValuesShouldBeEmpty">
		<!--- trigger the assertion --->
		<cfset assertEquals("one","one") />
		<!--- now do the real assertions for this test --->
		<cfset assertTrue(getExpected() eq "","getExpected() should have been empty but was #getExpected()#") />
		<cfset assertTrue(getActual() eq "", "getActual() should have been empty but was #getActual()#") />
	</cffunction>


	<cffunction name="testAssertTrue" access="public" returntype="void">
		<cfscript>assertTrue(true,"This test should pass.");</cfscript>
	</cffunction>


	<cffunction name="testAssertFalse" access="public" returntype="void"><cfset assertFalse(false,"this test should pass") /></cffunction>

	<cffunction name="testAssertFalseFailure">
		<cftry>
			<cfset assertFalse(true,"this should fail") />
			<cfthrow message="should not get here" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testAssertFailures" access="public" returntype="void">
		<cftry>
			<cfscript>
				assertEquals(myComponent1,myComponent2,"This should fail because toString() or stringValue() not implemented.");
				assertEquals(1,2,"This should fail");
			</cfscript>
			<cfcatch type="mxunit.exception.AssertionFailedError" />
		</cftry>
	</cffunction>


	<cffunction name="testFailure" access="public" returntype="void">
		This tests an intentional failure. It should catch the exception correctly and return true.
		<cftry>
			<cfset fail("Did not catch AssertionFailedError") />
			<cfcatch type="mxunit.exception.AssertionFailedError" />
		</cftry>
	</cffunction>


	<cffunction name="testAssertEqualsNumbers">
		<!--- these should all fail if they are not equals --->
		<cfset assertEquals(1,1,"boo") />
		<cfset assertEquals(1.0,1) />
		<cfset assertEquals(1000000000000.0,1000000000000) />
		<cfset assertEquals(-5,-5.0) />
		<cfset assertEquals(-100.222,-100.222) />
		<cfset assertEquals("1",1) />
		<cfset assertEquals(2,"2") />
		<cfset assertEquals("2.222",2.222) />
	</cffunction>


	<cffunction name="testAssertEqualsNumbersFailures">
		<cftry>
			<cfset assertEquals(1,2) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(121.000001,121.000) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(1,"1.1") />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(-1,0) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(-1,-.9999999999999) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testAssertEqualsStrings" access="public" returntype="void">
		<cfset debug(getTestStyle()) />
		<cfset assertEquals("one","one" , "Should pass!") />
		<cfset assertEquals("#repeatString('aaaaaa ',50)#","#repeatString('aaaaaa ',50)#") />
		<cfset assertEquals("One","ONE","case sensitivity shouldn't matter when comparing strings") />
	</cffunction>


	<cffunction name="testAssertEqualsStringsFailures">
		<cftry>
			<cfset assertEquals("ONE","ONE ") />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals("ONE"," ONE") />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testAssertEqualsStructs">
		<cfset var s1 = StructNew() />
		<cfset var s2 = StructNew() />
		<cfset assertEquals(s1,s2) />
		<cfset s1.one = "one" />
		<cfset s2.one = "one" />
		<cfset assertEquals(s1,s2) />
		<cfset s1.two = ArrayNew(1) />
		<cfset s2.two = ArrayNew(1) />
		<cfset assertEquals(s1,s2) />
		<cfset s1.two[1] = "one" />
		<cfset s2.two[1] = "one" />
		<cfset assertEquals(s1,s2) />
	</cffunction>


	<cffunction name="testAssertEqualsStructsDeepComparison">
		<cfset var s1 = StructNew() />
		<cfset var s2 = StructNew() />
		<cfset var rand = "" />
		<cfset var i = "" />
		<cfset var key = "" />
		<cfloop from="1" to="100" index="i"><cfset s1["a"&i] = "b_#i#" />
			<cfset s2["a"&i] = "b_#i#" /></cfloop>
		<cfset assertEquals(s1,s2) />
		<cfset rand = getTickCount() />
		<cfloop collection="#s1#" item="key">
			<cfset s1[key] = StructNew() />
			<cfset s1[key][key] = rand />
			<cfset s2[key] = StructNew() />
			<cfset s2[key][key] = rand />
		</cfloop>
		<cfset assertEquals(s1,s2) />
		<cfset s2[key][key] = rand & "boo" />
		<cftry>
			<cfset assertEquals(s1,s2) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="testAssertEqualsStructsFailures">
		<cfset var s1 = StructNew() />
		<cfset var s2 = StructNew() />
		<cfset s1.one = "one" />
		<cfset s2.one = "two" />
		<cftry>
			<cfset assertEquals(s1,s2) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cfset s1.two = ArrayNew(1) />
		<cfset s2.two = ArrayNew(1) />
		<cftry>
			<cfset assertEquals(s1,s2) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cfset s1.two[1] = "one" />
		<cfset s2.two[1] = "two" />
		<cftry>
			<cfset assertEquals(s1,s2) />
			<cfthrow type="other" message="should throw an AssertionFailedError before this one" />
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="assertStructEquals_succeeds_for_matching_nested_structs" returntype="void">
		<cfset var nested = {one=1, 2="two" }>
    	<cfset var struct1 = { one="one", two="two", three="3", nested = nested }>
    	<cfset var struct2 = duplicate( struct1 )>
    	<cfset assertEquals( struct1, struct2 )>
    </cffunction>

	<cffunction name="assertStructEquals_succeeds_for_matching_nested_structs_with_different_key_case" returntype="void">
		<cfset var nested = {one=1, 2="two" }>
    	<cfset var struct1 = { one="one", two="two", three="3", nested = nested }>
    	<cfset var struct2 = structNew()>
    	<cfset struct2["one"] = "one">
    	<cfset struct2["two"] = "two">
    	<cfset struct2["three"] = "3">
    	<cfset struct2["nested"] = nested>
    	<cfset assertEquals( struct1, struct2 )>
    </cffunction>

	<cffunction name="assertStructEquals_fails_for_mismatching_simple_structs" returntype="void">
		<cfset var nested = {one=1, 2="too" }>
    	<cfset var struct1 = { one="one", two="two", three="3", nested=nested }>
    	<cfset var struct2 = duplicate( struct1 )>
    	<cfset struct2.one = 1>
    	<cfset struct2.nested["2"] = "two">

    	<cftry>
	    	<cfset assertEquals( struct1, struct2 )>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
		</cftry>
    </cffunction>

    <cffunction name="assertStructEquals_fails_for_mismatching_nested_structs" returntype="void">
    	<cfset var nested = {one=1, 2="two" }>
    	<cfset var struct1 = { one="one", two="two", three="3", nested=nested }>
    	<cfset var struct2 = duplicate( struct1 )>
    	<cfset struct2.nested.one = "one">

		<cftry>
	    	<cfset assertEquals( struct1, struct2 )>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
		</cftry>
    </cffunction>

	<cffunction name="assertQueryEquals_succeeds_for_equal_queries" returntype="void">
    	<cfset var q1 = "">
    	<cfset var q2 = "">

<cf_querysim>
q1
col1,col2,col3,col4
1|1.2|1.3|1.4
2|2.2|2.3|2.4
3|3.2|3.3|3.4
</cf_querysim>

<cf_querysim>
q2
col4,col2,col3,col1
1.4|1.2|1.3|1
2.4|2.2|2.3|2
3.4|3.2|3.3|3
</cf_querysim>

	<cfset assertEquals( q1, q2, "These queries should have been equal even though they were created with columns in a different order")>

    </cffunction>

	<cffunction name="assertQueryEquals_fails_for_mismatching_queries" returntype="void">
		<cfset var queries = createUnequalQueries()>

		<cftry>
			<cfset assertEquals( queries.query1, queries.query2, "These queries should fail because they are not equal")>

		<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
		</cftry>

    </cffunction>

    <cffunction name="assertEquals_passes_for_matching_arrays" output="false" access="public" returntype="any" hint="">
		<cfset var expected = [1,2,3,4,5, "a", "b", "c", "d", "e"]>
		<cfset var actual = [1,2,3,4,5,"a","b","c","d","e"]>
		<cfset assertEquals( expected, actual, "These arrays should have been equal" )>
    </cffunction>

    <cffunction name="assertEquals_fails_for_longer_expected_array" output="false" access="public" returntype="any" hint="">
		<cfset var expected = [1,2,3,4,5, "a", "b", "c", "d", "e", "f", "g"]>
		<cfset var actual = [1,2,3,4,5,"a","b","c","d","e"]>
		<cftry>
			<cfset assertEquals( expected, actual, "These arrays should have been equal" )>

		<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
		</cftry>
    </cffunction>

    <cffunction name="assertEquals_fails_for_longer_actual_array" output="false" access="public" returntype="any" hint="">
		<cfset var expected = [1,2,3,4,5,"a","b","c","d","e"]>
		<cfset var actual = [1,2,3,4,5, "a", "b", "c", "d", "e", "f", "g", {}]>
		<cftry>
			<cfset assertEquals( expected, actual, "These arrays should have been equal" )>

			<cfthrow message="We should have failed prior to this">
		<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
		</cftry>

    </cffunction>

    <cffunction name="assertEquals_fails_for_array_with_mismatching_queries" output="false" access="public" returntype="any" hint="">
    	<cfset var queries = createUnequalQueries()>
    	<cfset var expected = [queries.query1, queries.query2]>
    	<cfset var actual = [queries.query2, queries.query1]>

    	<cftry>
    		<cfset assertEquals( expected, actual, "These comparisons should fail because the queries at each array position do not match")>
	    	<cfthrow message="We should have failed prior to this">
    	<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
    	</cftry>

    </cffunction>

    <cffunction name="assertEquals_passes_for_array_with_matching_queries" output="false" access="public" returntype="any" hint="">
    	<cfset var queries = createUnequalQueries()>
    	<cfset var expected = [queries.query1, queries.query2]>
    	<cfset var actual = [queries.query1, queries.query2]>

    	<cfset assertEquals( expected, actual, "These comparisons should pass because the queries at each array position match")>
    </cffunction>

    <cffunction name="assertEquals_fails_for_array_with_mismatching_structs" output="false" access="public" returntype="any" hint="">
    	<cfset var expected = [ 1,2,3, {one="one", two="two", three=["a", "b", "c"]} ]>
    	<cfset var actual = [ 1,2,3, {one="one", two="two", three=["a", "b", "c", "d"]} ]>

    	<cftry>
    		<cfset assertEquals( expected, actual, "These comparisons should fail because the nested array inside of the nested struct did not match")>
	    	<cfthrow message="We should have failed prior to this">
    	<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
    	</cftry>

    </cffunction>

    <cffunction name="assertEquals_passes_for_array_with_matching_structs" output="false" access="public" returntype="any" hint="">
    	<cfset var expected = [ 1,2,3, {one="one", two="two", three=["a", "b", "c"]} ]>
    	<cfset var actual = [ 1,2,3, {two="two", three=["a", "b", "c"], one="one"} ]>

    	<cfset assertEquals( expected, actual, "These comparisons should pass b/c the nested data are equal")>
    </cffunction>

	<cffunction name="assertEquals_fails_for_array_with_mismatching_arrays" output="false" access="public" returntype="any" hint="">
    	<cfset var expected = [ [1,2,3], [4,5,6] ]>
    	<cfset var actual = [ [1,2,4], [4,5,7] ]>
    	<cftry>
    		<cfset assertEquals( expected, actual, "These comparisons should fail because the nested arrays do not match")>
	    	<cfthrow message="We should have failed prior to this">
    	<cfcatch type="mxunit.exception.AssertionFailedError" >
			<!--- we want this failure --->
			<cfset debug(cfcatch)>
		</cfcatch>
    	</cftry>
    </cffunction>

	<cffunction name="assertEquals_passes_for_array_with_matching_arrays" output="false" access="public" returntype="any" hint="">
    	<cfset var expected = [ [1,2,3], [4,5,6] ]>
    	<cfset var actual = duplicate( expected )>
    	<cfset assertEquals( expected, actual, "These comparisons should pass because the nested arrays match")>
    </cffunction>

	<cffunction name="testNormalizeArgumentsDefaultEquals">
		<cfset var asserttype = "equals" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset args.expected = "1" />
		<cfset args.actual = "2" />
		<cfset args.message = "message" />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(args.expected eq newargs.expected) />
		<cfset assertTrue(args.actual eq newargs.actual) />
		<cfset assertTrue(args.message eq newargs.message) />
	</cffunction>


	<cffunction name="testNormalizeArgumentsDefaultTrue">
		<cfset var asserttype = "true" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset args.condition = false />
		<cfset args.message = "message" />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(args.condition eq newargs.condition) />
		<cfset assertTrue(args.message eq newargs.message) />
	</cffunction>


	<cffunction name="testNormalizeArgumentsDefaultXMLDoc">
		<cfset var asserttype = "isxmldoc" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset args.xml = "<myxml>blah</myxml>" />
		<cfset args.message = "message" />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(args.xml eq newargs.xml) />
		<cfset assertTrue(args.message eq newargs.message) />
	</cffunction>


	<cffunction name="testNormalizeArgumentsDefaultEmptyArray">
		<cfset var asserttype = "isemptyarray" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset args.a = ArrayNew(1) />
		<cfset args.message = "message" />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(ArrayLen(args.a) eq ArrayLen(newargs.a)) />
		<cfset assertTrue(args.message eq newargs.message) />
	</cffunction>


	<cffunction name="testNormalizeArgumentsCFUnitTrue">
		<cfset var asserttype = "true" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset setTestStyle("cfunit") />
		<cfset args.condition = "message" />
		<cfset args.message = false />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(args.condition eq newargs.message) />
		<cfset assertTrue(args.message eq newargs.condition) />
	</cffunction>


	<cffunction name="testNormalizeArgumentsCFUnitEquals">
		<cfset var asserttype = "equals" />
		<cfset var args = structnew() />
		<cfset var newargs = "" />
		<cfset var expected=2 />
		<cfset var actual=2 />
		<cfset setTestStyle("cfunit") />
		<cfset args.expected = "1" />
		<cfset args.actual = "2" />
		<cfset args.message = "message" />
		<cfset newargs = normalizeArguments(asserttype,args) />
		<cfset assertTrue(args.expected neq newargs.expected) />
		<cfset assertTrue(args.actual neq newargs.actual) />
		<cfset assertTrue(args.message neq newargs.message) />
		<!--- here's the tale of the tape, in a way: if this doesn't work, it'll throw an error  --->
		<cfset assertEquals("message",expected,actual) />
	</cffunction>


	<cffunction name="testDoubleHashError">
		<!--- see http://jira.mxunit.org/browse/MXUI-13 --->
		<cftry>
			<cfset assertTrue(false, "This -> ## <- should not cause an error") />
			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset assertEquals("This -> ## <- should not cause an error", cfcatch.message) />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="createUnequalQueries" output="false" access="private" returntype="struct" hint="">
		<cfset var q1 = "">
		<cfset var q2 = "">
		<cfset var result = "">
<cf_querysim>
q1
col1,col2,col3,col4
1|1.2|1.3|1.4
2|2.2|2.3|2.4
3|3.2|3.3|3.4
</cf_querysim>

<cf_querysim>
q2
col1,col2,col3,col4
4|1.2|1.3|1.a
6|2.2|2.3|2.b
9|3.2|3.3|3.c
10|3.6|3.0|3.d
</cf_querysim>

		<cfset result = {query1 = q1, query2 = q2}>
		<cfreturn result>
    </cffunction>

	<!---End Specific Test Cases --->

	<cffunction name="setUp" access="public" returntype="void">
		<!--- doing this because some tests need to test the cfunit-style behavior and we want
			to ensure that we set it back for the other tests --->
		<cfset this.setTestStyle('default') />
		<!--- Place additional setUp and initialization code here --->
		<cfscript>
			myComponent1 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
			myComponent2 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
			//below implement consistent stringValue()
			myComponent3 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
			myComponent4 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
			_MIN = createObject("java","java.lang.Integer").MIN_VALUE;
			_MAX = createObject("java","java.lang.Integer").MAX_VALUE;
		</cfscript>
	</cffunction>


	<cffunction name="tearDown" access="public" returntype="void"><!--- Place tearDown/clean up code here ---></cffunction>

</cfcomponent>
