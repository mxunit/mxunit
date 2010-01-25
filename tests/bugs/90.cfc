<cfcomponent  extends="mxunit.framework.TestCase">
  Calls TestSuite.run() which invokes tearDown(). This is caught but not 
  displayed in debug ..

	<cffunction name="tearDown" access="public" returntype="void">
    <cfscript>error</cfscript>
    <cfset assertTrue("failure" eq false) />
	</cffunction>
	

</cfcomponent>
