<cfcomponent extends="mxunit.framework.TestCase">

	<cfset beforeTestsCount = 0>
	<cfset afterTestsCount = 0>

	<cffunction name="beforeTests" output="false" access="public" returntype="any" hint="">

    	<cflog text="Before Tests! Count is #beforeTestsCount#">
    	<cfset beforeTestsCount++>
    </cffunction>

    <cffunction name="afterTests" output="false" access="public" returntype="any" hint="">
    	<cflog text="After Tests! Count is #afterTestsCount#">
    	<cfset afterTestsCount++>
    </cffunction>

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
    	<cflog text="setUp">

	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">
    	<cflog text="tearDown">

	</cffunction>

	<cffunction name="one" returntype="void" access="public">
		<cfset debug("beforeTestsCount is #beforeTestsCount#; afterTestsCount is #afterTestsCount#")>
		<cfset assertEquals(1, beforeTestsCount)>
		<cfset assertEquals(0, afterTestsCount)>
	</cffunction>
	<cffunction name="two" returntype="void" access="public">
		<cfset debug("beforeTestsCount is #beforeTestsCount#; afterTestsCount is #afterTestsCount#")>
		<cfset assertEquals(1, beforeTestsCount)>
		<cfset assertEquals(0, afterTestsCount)>
	</cffunction>
	<cffunction name="three" returntype="void" access="public">
		<cfset debug("beforeTestsCount is #beforeTestsCount#; afterTestsCount is #afterTestsCount#")>
		<cfset assertEquals(1, beforeTestsCount)>
		<cfset assertEquals(0, afterTestsCount)>
	</cffunction>
	<cffunction name="four" returntype="void" access="public">
		<cfset debug("beforeTestsCount is #beforeTestsCount#; afterTestsCount is #afterTestsCount#")>
		<cfset assertEquals(1, beforeTestsCount)>
		<cfset assertEquals(0, afterTestsCount)>
	</cffunction>



</cfcomponent>