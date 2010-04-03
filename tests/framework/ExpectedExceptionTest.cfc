<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent  extends="mxunit.framework.TestCase">


<cffunction name="testThrowSingleEntryNameExceptionUsingAnnotation" expectedException="MyCustomException">
   <cfthrow type="MyCustomException">
</cffunction>

<cffunction name="testThrowExceptionWithPackageNotationUsingAnnotation" expectedException="com.foo.MyCustomException">
   <cfthrow type="com.foo.MyCustomException">
</cffunction>

<cffunction name="testThrowBasicAssertionFailedErrorUsingAnnotation" expectedException="mxunit.exception.AssertionFailedError">
  <cfthrow type="mxunit.exception.AssertionFailedError">
</cffunction>

<cffunction name="oldSkoolBasicError" expectedException="foo.bar.exception">
	<cftry>
	 <cfthrow type="asd.zxc" />
	<cfcatch type="asd.zxc">
		<cfthrow type="foo.bar.exception" /> 
	</cfcatch>
	</cftry>   
  
</cffunction>



<cffunction access="public" name="shouldThrowException" expectedException="foo.bar.exception">
   <cfthrow type="foo.bar.exception">	
</cffunction>


<cfscript>
	
	
	function throwSomethingExpected(){
	  expectException("bananas");
	  _throw('bananas');
	}
	
	
	function $expectedExceptionTestUsingScriptMethodAndSingleName(){
		expectException("Bar");
		_throw("Bar");
	}
	
	function $expectedExceptionTestUsingScriptMethodAndPackageNotation(){
		expectException("com.foo.Bar");
		_throw("com.foo.Bar");
	}
	
	function $expectedExceptionShouldSetPropertyInTestCase(){
		expectException("my.funny.ValantineException");
		assertEquals( "my.funny.ValantineException", this.expectedExceptionType );
		// Reset the exception or it will trigger the real expected exception
		expectException('');
	}
	
</cfscript>

<cffunction name="_throw" access="private">
  <cfthrow type="#arguments[1]#" message="Custom Exception for unit tests.">
</cffunction>

</cfcomponent>
