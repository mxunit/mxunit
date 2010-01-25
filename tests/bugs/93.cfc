<cfcomponent  extends="mxunit.framework.TestCase">

	<cffunction name="testPrintTrace" access="public" returntype="void">
	 <cfscript>
     _93 = createObject("component","mxunit.tests.bugs.fixture.93Sample"); 
     debug(_93.printTrace());
   </cfscript>
    <!--- <cftrace abort="false" inline="true" text="Example Trace inside cfc">
  <cfdump var="#_93.printTrace()#">  --->
	</cffunction>



	<cffunction name="setUp" access="public" returntype="void">
	  

	</cffunction>
	
	<cffunction name="tearDown" access="public" returntype="void">

	</cffunction>
	

</cfcomponent>
