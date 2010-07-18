

<cfcomponent  extends="mxunit.framework.TestCase">

	<cffunction name="testIsEqualTo" access="public" returntype="void">
    <cfscript>
      //addtrace(isEqualTo("this string").stringRepresentation); 
      assertThat( "this string", isEqualTo("this string") ); 
      a = arrayNew(1);
      a[1] = 'foo';
      b = arrayNew(1);
      b[1] = 'foo';
      s1 = structNew();
      s1.foo ='bar';
      s2 = structNew();
      s2.foo ='bar';
      s3 = structNew();
      s3.foo = s1;
      s4 = structNew();
      s4.foo = s2;
      
      assertThat(s3, isEqualTo(s4));  
      assertThat(a, isEqualTo(b) );   
      assertThat(1.1, isEqualTo(1.1) ); 
      assertThat(1.1, isEqualTo("1.1") ); //hmmm ... passes. should it?
      assertThat("my lowercase string" , isEqualTo("mY LowercASE sTrIng") );
      assertThat(0, isEqualTo(0) ); 
      assertThat(0, isEqualTo(-0) ); 
      assertThat(myComponent1, isEqualTo(myComponent2) ); 
    </cfscript>
  <cfdump var="#a#">
  <cfdump var="#s3#">
	</cffunction>

	<cffunction mxunit:run="true" name="testContainsTheString" access="public" returntype="void">
    <cfscript>
      //addtrace(isEqualTo("this string").stringRepresentation); 
      assertThat( "this string", containsTheString("this string") ); 
      a = arrayNew(1);
      a[1] = 'foo';
      b = arrayNew(1);
      b[1] = 'foo';
      s1 = structNew();
      s1.foo ='bar';
      s2 = structNew();
      s2.foo ='bar';
      s3 = structNew();
      s3.foo = s1;
      s4 = structNew();
      s4.foo = s2;
      
      assertThat(s3, isEqualTo(s4));  
      assertThat(a, isEqualTo(b) );   
      assertThat(1.1, isEqualTo(1.1) ); 
      assertThat(1.1, isEqualTo("1.1") ); //hmmm ... passes. should it?
      assertThat("my lowercase string" , isEqualTo("mY LowercASE sTrIng") );
      assertThat(0, isEqualTo(0) ); 
      assertThat(0, isEqualTo(-0) ); 
      assertThat(myComponent1, isEqualTo(myComponent2) ); 
    </cfscript>
  <cfdump var="#a#">
  <cfdump var="#s3#">
	</cffunction>

	<cffunction name="setUp" access="public" returntype="void">
	  <!--- Place additional setUp and initialization code here --->
      <cfset addAssertDecorator("HamcrestMatcher") />
      
       <cfscript>
       myComponent1 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
       myComponent2 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
      //below implement consistent stringValue()
       myComponent3 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
       myComponent4 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
    </cfscript>
      
  </cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
  </cffunction>

</cfcomponent>
