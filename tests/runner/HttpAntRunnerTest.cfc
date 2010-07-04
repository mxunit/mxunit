<cfcomponent generatedOn="12-12-2007 4:35:38 AM EST" extends="mxunit.framework.TestCase">


<cffunction name="testRun">

 Tests the AntRunner and makes sure the generated content is aok
  <cfset var found = "" />
  <cfset var rsDom = xmlParse(actual) />
  <cfset assertIsXmlDoc(rsDom) />
  <cfset debug(rsDom.xmlroot.xmlAttributes) />

  <cfset assertEquals(11,rsDom.xmlroot.xmlAttributes["tests"],"Should be 10 tests in this suite") />
  <cfset found = refind("<title>Test Results \[[0-9]{2}/[0-9]{2}/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}[ ]*.*</title>", actual, 0, true)>
  <cfset debug(found) />
  <cfset assertTrue(arrayLen(found.len) gt 0) />
  <cfset assertTrue(arrayLen(found.pos) gt 0) />

</cffunction>


<!--- Override these methods as needed. Note that the call to setUp() is Required if using a this-scoped instance--->

<cffunction name="setUp">

<!--- Assumption: Instantiate an instance of the component we want to test --->
 <cfset var httpAntRunner = createObject("component","mxunit.runner.HttpAntRunner") />

 <!--- Below is to adjust context depending upon the runner. --->
 <!--- Logic maybe should be a static util as setContext() ...
 <cfset dirPath = expandPath("HttpAntRunnerTest.cfc")>
 <cfset contextDir = getDirectoryFromPath(dirPath) />
 <cfset dir = listSetAt(contextDir,listLen(contextDir,'\'),'','\') />
 <cfset dir = dir & 'framework\fixture\fixturetests\' />

 <cfset debug("contextDir=" & contextDir) />
 <cfset debug(listLen(contextDir,'\')) />
 --->
 <cfset var dir = expandPath('/mxunit/tests/framework/fixture/fixturetests') />
 <cfset var contextDir = "" />
 <cfset var dirPath = "" />

 <cfset debug(dir) />
 <cfsavecontent variable="variables.actual">
   <cfinvoke component="#httpAntRunner#"  method="run">
   <cfinvokeargument name="type" value="dir" />
   <cfinvokeargument name="value" value="#dir#" />
   <cfinvokeargument name="packagename" value="mxunit.tests.framework.fixture.fixturetests" />
   <cfinvokeargument name="componentpath" value="mxunit.tests.framework.fixture.fixturetests" />	
   <cfinvokeargument name="outputformat" value="xml" />
	<cfinvokeargument name="recurse" value="false">
  </cfinvoke>
  </cfsavecontent>
  <cfset variables.actual = replace(actual,'<?xml version="1.0" encoding="UTF-8"?>','','one') />

<!--- Add additional set up code here--->
</cffunction>


<cffunction name="tearDown">

</cffunction>



</cfcomponent>
