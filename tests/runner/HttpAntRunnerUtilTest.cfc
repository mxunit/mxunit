<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="testThatUsesCfSaveContent">
		<cfset var strText = "">
		<cfsavecontent variable="strText">
			Hello There!
		</cfsavecontent>
		<cfset assertEquals("Hello There!", trim(strText))>
	</cffunction>
</cfcomponent>