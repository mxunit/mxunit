<cfcomponent extends="mxunit.framework.TestCase">

	<cfset this.objUnderTest = "">

	<cffunction name="setUp">
		<!--- we'll use this here object as a target, just for demonstration --->
		<cfset this.objUnderTest = createObject("component","PrivateMethodTest")>
	</cffunction>

	<cffunction name="testPrivateDirectly">
		<!--- this is gonna fail! --->
		<cfset var result = this.objUnderTest.somePrivateMethod("blah") />
		<cfset assertEquals("blah",result)>
	</cffunction>

	<cffunction name="testPrivateAndLookNoError">
		<cfset var result = "" />
		<cfset makePublic(this.objUnderTest,"somePrivateMethod","_YeeHaw")>
		<cfset result = this.objUnderTest._YeeHaw("blah")>
		<cfset assertEquals("blah",result)>

		<!--- without the 3rd arg, it defaults to the method name  --->
		<cfset makePublic(this.objUnderTest,"somePrivateMethod")>
		<cfset result = this.objUnderTest.somePrivateMethod("i love this stuff!")>
		<cfset assertEquals("i love this stuff!",result)>
	</cffunction>

	<!--- pretend this is in some other object you're trying to test --->
	<cffunction name="somePrivateMethod" access="private">
		<cfargument name="arg1" type="string" required="false" default="">
		<cfreturn arg1>
	</cffunction>

</cfcomponent>