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
      debug("caught expected exception : assert(false)");
     }

     assert(1 eq 1);
     try{
       assert (1 eq 0);
     }
     catch(mxunit.exception.AssertionFailedError e){
      //ok we're good
      debug("caught expected exception : assert(1 eq 0)");
     }

     try{
      assert (foo);
     }
     catch(Application e){
      debug("should not allow complex objects. But what's the exception type here, CF?'");
     }

     try{
      assert ('some string');
     }
     catch(Expression e){
      debug("should not allow strings, either");
     }

     assert (MIN lt MAX , "@see setUp() for system MIN and MAX values.");

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
                <cfset setTestStyle("cfunit")>
               <cftry>
                       <!--- do something here to cause an error --->
                       <cfset assertEquals("message",1,2)>
                <cfcatch type="mxunit.exception.AssertionFailedError">
                       <!--- we want this! --->
                </cfcatch>
                <cfcatch type="any">
                        <cfrethrow>
                </cfcatch>
                </cftry>
 </cffunction>


<cffunction name="testFailNotEqualsCFUnit" returntype="void" hint="">
       <cfset setTestStyle("cfunit")>
        <cftry>
			<!--- do something here to cause an error --->
			<cfset failNotEquals(1,2,"my message",false)>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfset debug(cfcatch)>
			<cfif not find("[1]",cfcatch.message)
				OR not find("[2]",cfcatch.message)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#")>
			</cfif>
		</cfcatch>
		</cftry>
 </cffunction>

  <cffunction name="testFailNotEquals">
   		<cftry>
			<!--- do something here to cause an error --->
			<cfset failNotEquals(1,2,"my message")>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfset debug(cfcatch)>
			<cfif not find("[1]",cfcatch.message)
				OR not find("[2]",cfcatch.message)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#")>
			</cfif>
		</cfcatch>
		</cftry>

  </cffunction>

	<cffunction name="testFailEquals" returntype="void" hint="tests error path">
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failEquals(1,2,"my message")>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfset debug(cfcatch)>
			<cfif not find("[1]",cfcatch.message)
				OR not find("[2]",cfcatch.message)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#")>
			</cfif>
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testFailEqualsCFUnit" returntype="void" hint="tests error path">
		 <cfset setTestStyle("cfunit")>
		<cftry>
			<!--- do something here to cause an error --->
			<cfset failEquals(1,2,false)>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfset debug(cfcatch)>
			<cfif not find("[1]",cfcatch.message)
				OR not find("[2]",cfcatch.message)>
					<cfset fail("Should've had [1] and [2] in the throw message but instead the message was #cfcatch.message#")>
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
		<cfset assertEquals("Please Excuse me sir","Please Excuse me madam")>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfset assertEquals("Please Excuse me sir",this.expected)>
			<cfset assertEquals("Please Excuse me madam",this.actual)>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="whenAssertEqualsPassesExpectedAndActualValuesShouldBeEmpty">
	<!--- trigger the assertion --->
	<cfset assertEquals("one","one")>
	<!--- now do the real assertions for this test --->
	<cfset assertTrue(this.expected eq "","this.expected should have been empty but was #this.expected#")>
	<cfset assertTrue(this.actual eq "", "this.actual should have been empty but was #this.actual#")>
</cffunction>

  <cffunction name="testAssertTrue" access="public" returntype="void">
   <cfscript>
    assertTrue(true,"This test should pass.");
   </cfscript>
 </cffunction>

	<cffunction name="testAssertFalse" access="public" returntype="void">
		<cfset assertFalse(false,"this test should pass")>
	</cffunction>

	<cffunction name="testAssertFalseFailure">
		<cftry>
			<cfset assertFalse(true,"this should fail")>
			<cfthrow message="should not get here">
			<cfcatch type="mxunit.exception.AssertionFailedError">

			</cfcatch>
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
	  This tests an intentional failure. It should catch the exception
	  correctly and return true.
	     <cftry>
	       <cfset fail("Did not catch AssertionFailedError") />
	       <cfcatch type="mxunit.exception.AssertionFailedError" />
	     </cftry>
	</cffunction>

	<cffunction name="testAssertEqualsNumbers">
		<!--- these should all fail if they are not equals --->
		<cfset assertEquals(1,1)>
		<cfset assertEquals(1.0,1)>
		<cfset assertEquals(1000000000000.0,1000000000000)>
		<cfset assertEquals(-5,-5.0)>
		<cfset assertEquals(-100.222,-100.222)>
		<cfset assertEquals("1",1)>
		<cfset assertEquals(2,"2")>
		<cfset assertEquals("2.222",2.222)>

	</cffunction>

	<cffunction name="testAssertEqualsNumbersFailures">
		<cftry>
			<cfset assertEquals(1,2)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(121.000001,121.000)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(1,"1.1")>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(-1,0)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
		<cftry>
			<cfset assertEquals(-1,-.9999999999999)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testAssertEqualsStrings" access="public" returntype="void">
		<cfset assertEquals("one","one" , "Should pass!")>
		<cfset assertEquals("#repeatString('aaaaaa ',50)#","#repeatString('aaaaaa ',50)#")>
		<cfset assertEquals("One","ONE","case sensitivity shouldn't matter when comparing strings")>
	 </cffunction>


	<cffunction name="testAssertEqualsStringsFailures">
		<cftry>
			<cfset assertEquals("ONE","ONE ")>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>

		<cftry>
			<cfset assertEquals("ONE"," ONE")>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testAssertEqualsStructs">
		<cfset var s1 = StructNew()>
		<cfset var s2 = StructNew()>
		<cfset assertEquals(s1,s2)>

		<cfset s1.one = "one">
		<cfset s2.one = "one">
		<cfset assertEquals(s1,s2)>

		<cfset s1.two = ArrayNew(1)>
		<cfset s2.two = ArrayNew(1)>
		<cfset assertEquals(s1,s2)>

		<cfset s1.two[1] = "one">
		<cfset s2.two[1] = "one">
		<cfset assertEquals(s1,s2)>
	</cffunction>

	<cffunction name="testAssertEqualsStructsDeepComparison">
		<cfset var s1 = StructNew() />
		<cfset var s2 = StructNew() />
		<cfset var rand = "" />
		<cfset var i = "" />
		<cfset var key = "" />

		<cfloop from="1" to="100" index="i">
			<cfset s1["a"&i] = "b_#i#">
			<cfset s2["a"&i] = "b_#i#">
		</cfloop>
		<cfset assertEquals(s1,s2)>

		<cfset rand = getTickCount()>
		<cfloop collection="#s1#" item="key">
			<cfset s1[key] = StructNew()>
			<cfset s1[key][key] = rand>
			<cfset s2[key] = StructNew()>
			<cfset s2[key][key] = rand>
		</cfloop>
		<cfset assertEquals(s1,s2)>
		<cfset s2[key][key] = rand & "boo">
		<cftry>
			<cfset assertEquals(s1,s2)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>

	</cffunction>

	<cffunction name="testAssertEqualsStructsFailures">
		<cfset var s1 = StructNew()>
		<cfset var s2 = StructNew()>

		<cfset s1.one = "one">
		<cfset s2.one = "two">

		<cftry>
			<cfset assertEquals(s1,s2)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>

		<cfset s1.two = ArrayNew(1)>
		<cfset s2.two = ArrayNew(1)>
		<cftry>
			<cfset assertEquals(s1,s2)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>

		<cfset s1.two[1] = "one">
		<cfset s2.two[1] = "two">

		<cftry>
			<cfset assertEquals(s1,s2)>
			<cfthrow type="other" message="should throw an AssertionFailedError before this one">
			<cfcatch type="mxunit.exception.AssertionFailedError"></cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testNormalizeArgumentsDefaultEquals">
		<cfset var asserttype = "equals">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset args.expected = "1">
		<cfset args.actual = "2">
		<cfset args.message = "message">
		<cfset newargs = normalizeArguments(asserttype,args)>
		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(args.expected eq newargs.expected)>
		<cfset assertTrue(args.actual eq newargs.actual)>
		<cfset assertTrue(args.message eq newargs.message)>


	</cffunction>

	<cffunction name="testNormalizeArgumentsDefaultTrue">
		<cfset var asserttype = "true">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset args.condition = false>
		<cfset args.message = "message">
		<cfset newargs = normalizeArguments(asserttype,args)>
		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(args.condition eq newargs.condition)>
		<cfset assertTrue(args.message eq newargs.message)>
	</cffunction>

	<cffunction name="testNormalizeArgumentsDefaultXMLDoc">
		<cfset var asserttype = "isxmldoc">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset args.xml = "<myxml>blah</myxml>">
		<cfset args.message = "message">
		<cfset newargs = normalizeArguments(asserttype,args)>
		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(args.xml eq newargs.xml)>
		<cfset assertTrue(args.message eq newargs.message)>
	</cffunction>

	<cffunction name="testNormalizeArgumentsDefaultEmptyArray">
		<cfset var asserttype = "isemptyarray">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset args.a = ArrayNew(1)>
		<cfset args.message = "message">
		<cfset newargs = normalizeArguments(asserttype,args)>
		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(ArrayLen(args.a) eq ArrayLen(newargs.a))>
		<cfset assertTrue(args.message eq newargs.message)>
	</cffunction>

	<cffunction name="testNormalizeArgumentsCFUnitTrue">

		<cfset var asserttype = "true">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset setTestStyle("cfunit")>
		<cfset args.condition = "message">
		<cfset args.message = false>
		<cfset newargs = normalizeArguments(asserttype,args)>

		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(args.condition eq newargs.message)>
		<cfset assertTrue(args.message eq newargs.condition)>
	</cffunction>

	<cffunction name="testNormalizeArgumentsCFUnitEquals">
		<cfset var asserttype = "equals">
		<cfset var args = structnew()>
		<cfset var newargs = "" />
		<cfset var expected=2 />
		<cfset var actual=2 />
		<cfset setTestStyle("cfunit")>
		<cfset args.expected = "1">
		<cfset args.actual = "2">
		<cfset args.message = "message">
		<cfset newargs = normalizeArguments(asserttype,args)>
		<cfset debug("Teststyle is " & getTestStyle())>
		<cfset debug(newargs)>

		<cfset assertTrue(args.expected neq newargs.expected)>
		<cfset assertTrue(args.actual neq newargs.actual)>
		<cfset assertTrue(args.message neq newargs.message)>

		<!--- here's the tale of the tape, in a way: if this doesn't work, it'll throw an error  --->

		<cfset assertEquals("message",expected,actual)>


	</cffunction>




  <!---End Specific Test Cases --->




  <cffunction name="setUp" access="public" returntype="void">
    <!--- doing this because some tests need to test the cfunit-style behavior and we want
      to ensure that we set it back for the other tests --->
	<cfset this.setTestStyle('default')>
    <!--- Place additional setUp and initialization code here --->
       <cfscript>
       myComponent1 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
       myComponent2 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
      //below implement consistent stringValue()
       myComponent3 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
       myComponent4 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
       MIN = createObject("java","java.lang.Integer").MIN_VALUE;
       MAX = createObject("java","java.lang.Integer").MAX_VALUE;
    </cfscript>
  </cffunction>

  <cffunction name="tearDown" access="public" returntype="void">
   <!--- Place tearDown/clean up code here --->
  </cffunction>



</cfcomponent>
