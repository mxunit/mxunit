<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="testThatWillTake5Seconds">
		<cfset var obj = createObject("java","java.lang.Thread")>
		<cfset obj.sleep(5000)>
	</cffunction>

</cfcomponent>