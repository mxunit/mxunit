<cfcomponent name="HtmlRunner" hint="Responsible for determining what is to be run and outputting results" output="true">



<cffunction name="HtmlRunner" returntype="HtmlRunner" hint="Constructor">
  <cfreturn this />
</cffunction>

<cffunction name="run" access="remote" output="true">
 <cfargument name="test" type="string" required="true" hint="TestCase,TestSuite, or Dircetory to run"  />
 <cfargument name="componentPath" type="string" required="false" default="" hint="A dotted prefix mapping for the directory; e.g., com.foo.bar"  />
 <cfargument name="output" required="false"  default="extjs" hint="The type of output format" />
 <cfset var local = "">
 <cfset var dirrunner = "">
 <cfset var results = "">
 <cfif refind("[\\/]+", arguments.test)>
   <cfscript>
   if( arguments.componentPath is ""){
   	writeoutput("WARNING: Please supply componentPath when running a directory of tests");
   	return;
   }
   dirrunner = createObject("component","DirectoryTestSuite");
   results = dirrunner.run(test,componentPath,false);
   writeoutput(results.getResultsOutput(arguments.output));
   </cfscript>
 <cfelse>
  <cfset localTest = createObject("component", arguments.test) />
  <cfset localTest.runTestRemote(output=arguments.output) />
 </cfif>
 
</cffunction>

</cfcomponent>