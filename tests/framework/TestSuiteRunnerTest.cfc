<cfcomponent  extends="mxunit.framework.TestCase">
<cfscript>
/*
  This was written primarily to test the handleCaughtExceptino method, which
  was reported to use cfcatch incorrectly

*/	
	
function beforeTests(){
  runner = createObject("component","mxunit.framework.TestSuiteRunner");
  
  e = { type='my exception',message='you suck at unit testing' };
  
}	

/*
		<cfargument name="expectedExceptionType" type="string" required="true" />
		<cfargument name="expectedExceptionMessage" type="string" required="true" />
		<cfargument name="results" />
		<cfargument name="outputOfTest" />
		<cfargument name="testCase" />
*/
function testHandleCaughtExceptionShouldCoverAllPaths(){
   makePublic(runner,"handleCaughtException");
   
   runner.handleCaughtException(e,'you suck at testing','results',1,this);
   
}

</cfscript>
</cfcomponent>
