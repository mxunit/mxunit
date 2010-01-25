<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent  extends="mxunit.framework.TestCase">

<!--- Begin Specific Test Cases --->
	<cffunction name="testSomething" access="public" returntype="void">

	</cffunction>


	<cffunction name="testSomethingElse" access="public" returntype="void">

	</cffunction>


	<cffunction name="testSomethingElse2" access="public" returntype="void">

	</cffunction>
<!--- End Specific Test Cases --->


	<cffunction name="setUp" access="public" returntype="void">
	  <!--- Place additional setUp and initialization code here --->
      <cfset variables.matcher = createObject("component","mxunit.framework.HamcrestMatcher") />
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>


</cfcomponent>
