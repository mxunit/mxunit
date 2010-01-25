<!---
 Extension of TestResult

ToDo: Get pacakge for testresult name ex: mxunit.tests.framework for any in that package
 --->
 <cfcomponent displayname="JUnitXMLTestResult" output="no" extends="TestResult" hint="JUnit style XML representation of MXUnit TestResult.">
   <cfparam name="this.testRuns" type="numeric" default="0" />
   <cfparam name="this.failures" type="numeric" default="0" />
   <cfparam name="this.errors" type="numeric" default="0" />
   <cfparam name="this.successes" type="numeric" default="0" />
   <cfparam name="this.totalExecutionTime" type="numeric" default="0" />
   <cfparam name="this.resultsXML" type="string" default='' />
   <cfparam name="tempTestCase" type="any" default="" />
   <cfparam name="tempTestComponent" type="any" default="" />
   <cfparam name="this.closeCalls" default="0" type="numeric" />
   <cfparam name="this.name" default="mxunit.tests" type="string" />

 <cffunction name="JUnitXMLTestResult" hint="Constructor" access="public" returntype="TestResult">
   <cfargument name="testResults" type="TestResult" required="false" />
   <cfset this.testRuns = arguments.testResults.testRuns />
   <cfset this.failures = arguments.testResults.testFailures />
   <cfset this.errors = arguments.testResults.testErrors />
   <cfset this.successes = arguments.testResults.testSuccesses />
   <cfset this.totalExecutionTime = arguments.testResults.totalExecutionTime />
   <cfset this.name = arguments.testResults.getPackage() />

   <cfset buildXmlresults(arguments.testResults.getResults()) />
   <cfreturn  this />
 </cffunction>



 <cffunction name="getXMLDomResults" access="public" returntype="xml" output="false" hint="Returns an XML Dom representation of a TestResult">
   <cfset var dom= "" />
   <cfset dom = xmlParse(this.resultsXML) />
   <cfreturn dom />
 </cffunction>


 <cffunction name="getXMLResults" access="public" returntype="string" output="false" hint="Returns an XML string representation of a TestResult">
   <!--- <cfinvoke method="buildXmlResults" /> --->
   <cfset var dom= "" />
   <cfset dom = this.resultsXML />
   <cfreturn dom />
 </cffunction>

 <cffunction name="buildXmlResults" access="public" output="false" hint="Converts the TestResult into the xml representation">
   <cfargument name="results" type="array" required="true" />
  <cfscript>
   var i = "";
   this.resultsXML = this.resultsXML & '<testsuite name="#this.name#" hostname="#cgi.remote_host#" tests="#this.testRuns#" failures="#this.failures#" errors="#this.errors#" timestamp="#dateFormat(now(),"mm/dd/yy")# #timeFormat(now(),"medium")#" time="#this.totalExecutionTime/1000#">';
   this.resultsXML = this.resultsXML & '<properties>';
   this.resultsXML = this.resultsXML & genProps(server.coldfusion);
   this.resultsXML = this.resultsXML & genProps(server.os);
   this.resultsXML = this.resultsXML & genProps(cgi);
   this.resultsXML = this.resultsXML & genProps(cookie);
   this.resultsXML = this.resultsXML & genProps(request);
   if(isDefined("application")) this.resultsXML = this.resultsXML & genProps(application);
   //JUnitReport XSL transformation doesn't like some of the CGI stuff, like query string &amp;
   //CGI props should not be as important at sever level properties
   this.resultsXML = this.resultsXML & '</properties>';

   for(i = 1; i lte arrayLen(arguments.results); i = i + 1){
	   testResults = arguments.results[i];
	   this.resultsXML = this.resultsXML & '<testcase classname="#testResults.component#" name="#testResults.testname#" time="#testResults.time/1000#">';
	   if( listFindNoCase("Failed",testResults.testStatus)){
	   	this.resultsXML = this.resultsXML & '<failure message="#xmlformat(testResults.error.message)#"><![CDATA[#testResults.error.stacktrace#]]></failure>';
	   }
	   else if( listFindNoCase("Error",testResults.testStatus)) {
	   	 this.resultsXML = this.resultsXML & '<error message="#testResults.error.type#"><![CDATA[#testResults.error.stacktrace#]]></error>';
	   }
	   this.resultsXML = this.resultsXML & '</testcase>';
   }
   this.resultsXML = this.resultsXML & '</testsuite>';
  </cfscript>
</cffunction>


<!--- Util --->
<cffunction name="genProps" access="private" output="true" hint="Generates JUnitReport style XML properties">
  <cfargument name="collection" type="struct" />
  <cfscript>
   var properties = '';
   for(prop in collection){
   	if( isSimpleValue(collection[prop]) ){
     	properties = properties & '<property name="#ucase(prop)#" value="#replace(collection[prop],"&","&amp;","all")#" />';
   	}else{
   		properties = properties & '<property name="#ucase(prop)#" value="Complex Data Type...Not Displaying" />';
   	}
   }
   return properties;
  </cfscript>
</cffunction>

 </cfcomponent>