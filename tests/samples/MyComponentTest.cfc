<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

<!--- Begin Specific Test Cases --->
	<cffunction name="testAdd" access="public" returntype="void">
	<cfscript>
   num = this.mycomp.add(1,1);
   addTrace("num == " & num );
   assertEquals(num,2);
  </cfscript>

	</cffunction>


	<cffunction name="testAdd2" access="public" returntype="void">
	<cfscript>
   num = this.mycomp.add(1,1);
   addTrace("num == " & num );
   assertEquals(num,3);
  </cfscript>
	</cffunction>


	<cffunction name="testSomethingElse2" access="public" returntype="void">
		<cfset var myExpression = evaluate("1+1 eq 2") />
    <cfset addTrace(" myExpression == " & myExpression) />
    <cfset assertTrue(myExpression) />
	</cffunction>
<!--- End Specific Test Cases --->


	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		 this.mycomp = createObject("component" ,"mxunit.samples.MyComponent");
		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>


</cfcomponent>
