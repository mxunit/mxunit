<cfcomponent generatedOn="12-04-2007 9:29:58 PM EST" extends="mxunit.framework.TestCase">
 
<cffunction name="testTest" hint="Testing Abstract Constructor">
 <cftry>
 <cfset this.test.Test() />  
 <cfcatch type="mxunit.exception.CannotInstantiateException" />
    <!--- no worries. we want this to fail --->
  </cftry>

</cffunction>

<cffunction name="testRun" hint="Testing Abstract run method">
 <cftry>
 <cfset this.test.run() />  
 <cfcatch type="mxunit.exception.CannotInstantiateException" />
    <!--- no worries. we want this to fail --->
  </cftry>

</cffunction>

<!--- Override these methods as needed. Note that the call to setUp() is Required if using a this-scoped instance--->

<cffunction name="setUp">
<!--- Assumption: Instantiate an instance of the component we want to test --->
<cfset this.test = createObject("component","mxunit.framework.Test") />
<!--- Add additional set up code here--->
</cffunction>
 

<cffunction name="tearDown">
</cffunction>


</cfcomponent>
