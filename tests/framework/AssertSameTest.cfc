<cfcomponent name="AssertSameTest" extends="mxunit.framework.TestCase">


<cffunction name="testGetHashCode">
  Doesn't do any assertions, just looks at hashCode info
  <cfscript>
     // debug(ar.hashCode());
     // debug(getHashCode(ar));
     // debug(getHashCode(ar2));
     // debug(getHashCode(1));
     // debug(getHashCode(1.0));
     // debug(getHashCode(f1));
     // debug(getHashCode(f2)); 
     ds = structNew();
     ds.foo = "bar";
     // debug(getHashCode(ds));
     // debug(getHashCode(myComponent1));
     ds.bar = s2;
     // debug(ds);
     // debug(getHashCode(ds));   
    </cfscript>
</cffunction>

<cffunction name="testIdentityHashCodes">
  <cfscript>
     var system = createObject("java", "java.lang.System");
     var expected = system.identityHashCode(ar);
     var actual = system.identityHashCode(ar2);
     assertEquals(expected,expected);
     assertEquals(actual,actual);
     expected = system.identityHashCode(s);
     actual = system.identityHashCode(s);
     assertEquals(expected,expected);
     assertEquals(actual,actual);
   </cfscript>
</cffunction>


	<!--- TODO: Implement Tests --->
	<cffunction name="testHashEquals" returntype="void" access="public">
		<cfscript>
     // debug( ar.hashCode() );
     // debug( ar2.hashCode() ); 
     assertEquals(ar.hashCode(),ar2.hashCode());
     //assertEquals(s.hashCode(), s2.hashCode());
     foo = 1;
     bar = 1;
     assertEquals(foo.hashCode(),bar.hashCode());
     //assertEquals(s.hashCode(), s2.hashCode());
     //assertEquals(myComponent1.hashCode(),myComponent2.hashCode());
    </cfscript>
   	</cffunction>


  <cffunction name="testThrowWrapper">
   <cfscript>
   try{
    throwWrapper("mxunit.exception.TestException","testing","testing testing");
   }
   catch(mxunit.exception.TestException met){
    //no worries
   }

   try{
    throwWrapper("mxunit.exception.KnownIssueExceotion","testing","testing testing");
   }
   catch(mxunit.exception.KnownIssueExceotion met){
    //no worries
   }

   try{
    throwWrapper("mxunit.exception.CannotCompareArrayReferenceException","Cannot compare array references in ColdFusion","Arrays in ColdFusion are passed by value. To compare instances, you may wrap the array in a struct and compare those.");
   }
   catch(mxunit.exception.CannotCompareArrayReferenceException met){
    //no worries
   }

   </cfscript>
  </cffunction>

	<cffunction name="testAssertSameArray">
		<cfscript>
			var local = {};

			if(variables.arraysPassByValue)
			{
				local.check = false;
				try
				{
					assertSame(ar,ar,"Should catch exception because an array is being passed in");
				}
				catch(mxunit.exception.CannotCompareArrayReferenceException e)
				{
					//no worries
					local.check = true;
				}

				assertTrue(local.check, "Exception should be thrown");
			}
			else
			{
				assertSame(arr, arr);
			}

			//test native arrays
			local.native = createObject("java", "java.util.ArrayList").init();
			local.native2 = local.native;

			local.native[1] = "foo";

			assertSame(local.native, local.native2);
		</cfscript>
	</cffunction>

	<cffunction name="testAssertNotSameArray">
		<cfscript>
			var local = {};

			if(variables.arraysPassByValue)
			{
				local.check = false;
				try
				{
					assertSame(ar,ar2,"Should catch exception because an array is being passed in");
				}
				catch(mxunit.exception.CannotCompareArrayReferenceException e)
				{
					//no worries
					local.check = true;
				}

				assertTrue(local.check, "Exception should be thrown");
			}
			else
			{
				assertNotsame(ar, ar2);
			}

			local.native = createObject("java", "java.util.ArrayList").init();
			local.native2 = local.native.clone();

			local.native[1] = "foo";

			assertNotSame(local.native, local.native2);
		</cfscript>
	</cffunction>

   <cffunction name="testAssertSame">
    <cfscript>
     assertSame(s,s);
     assertSame(str,str);
     assertSame(q,q);
     assertSame(myComponent1,myComponent1);
     assertSame(1,1);
     assertSame(1.0,1.0);
     assertNotSame(-100000000000,-100000000000);
     assertSame(f1,f1);
     //assertSame(ar,ar);
    </cfscript>
   </cffunction>

  <cffunction name="testAssertNotSame">
    <cfscript>
     assertNotSame(s,s2);
     assertNotSame(str,str2);
     assertNotSame(q,q2);
     assertNotSame(myComponent1,myComponent2);
     assertNotSame(1,2);
     assertNotSame(1.1,1.01);
     assertNotSame(-100000000000,-20000);
     assertNotSame(f1,f2);

     //Same problem as testAssertSame
      //assertNotSame(ar,ar2);
    </cfscript>
   </cffunction>


<!---
  <cffunction name="testJavaAssertSame">
  Tests the Java component for arrays, structs, queries, and CFCs
  <cfscript>
    paths = arrayNew(1);
    paths[1] = expandPath("/mxunit/framework/lib/mxunit-ext.jar");
		loader = createObject("component", "mxunit.framework.JavaLoader").init(paths);
    comp = loader.create("CompareObjects").init();
    debug(comp);

    //Compare arrays
    results = comp.assertSame(ar,ar2);
    assertFalse(results);

    results = comp.assertSame(ar,ar);
    assertTrue(results);

    //Compare structs
    results = comp.assertSame(s,s2);
    assertFalse(results);

    results = comp.assertSame(s,s);
    assertTrue(results);

    //Compare strings

    results = comp.assertSame( str, str );
    assertTrue(results);

    results = comp.assertSame( str, str2 );
    debug(results);
    assertFalse(results);

    //compare ints
    results = comp.assertSame( 1, 1 );
    assertTrue(results);

    results = comp.assertSame( 1, 2 );
    assertFalse(results);

    //compare real
     results = comp.assertSame( 1.001, 1.001 );
    assertTrue(results);

    results = comp.assertSame( 1.0001, 2.0 );
    assertFalse(results);

    //compare cfcs
    results = comp.assertSame( myComponent1, myComponent2 );
    assertFalse(results);

    results = comp.assertSame( myComponent1, myComponent1 );
    assertTrue(results);

    //compare cfcs
    results = comp.assertSame( q, q2 );
    assertFalse(results);

    debug(q);
    results = comp.assertSame( q, q );
    assertTrue(results);


  </cfscript>



  </cffunction>
   --->

  <cffunction name="setUp" returntype="void" access="public">
	<cfset var fileToRead = "#getDirectoryFromPath(getCurrentTemplatePath())#AssertSameTest.cfc">
   <cfscript>
    ar = arrayNew(1);
    ar[1] = 'foo';
    ar2 = arrayNew(1);
    ar2[1] = 'foo';

    s = structNew();
    s.foo = 'bar';
    s2 = structNew();
    s2.foo = 'foo';

    str  = createObject("java","java.lang.String").init("s");
    str2 = createObject("java","java.lang.String").init("s");

     myComponent1 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
     myComponent2 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
      //below implement consistent stringValue()
     myComponent3 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
     myComponent4 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");

    q = queryNew('foo');
    q2 = queryNew('bar');

   </cfscript>

   <cffile action="read" file="#fileToRead#" variable="variables.f1">
   <cffile action="read" file="#fileToRead#" variable="variables.f2">


  </cffunction>

	<cffunction name="tearDown" returntype="void" access="public">

  </cffunction>



</cfcomponent>