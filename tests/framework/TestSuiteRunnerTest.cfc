<cfcomponent  extends="mxunit.framework.TestCase">
<cfscript>
/*
  This was written primarily to test the handleCaughtExceptino method, which
  was reported to use cfcatch incorrectly

*/	
	
function beforeTests(){
  runner = createObject("component","mxunit.framework.TestSuiteRunner");
   e = { type='my exception', message='you suck at unit testing', detail='my exception detail' };
   makePublic(runner,"handleCaughtException");
  
}	

function setUp(){
  this.result = createObject("component","mxunit.framework.TestResult").TestResult();
}

/* -----------------------------------------------------------------------------
interface:
	<cfargument name="caughtException" type="any"/>
	<cfargument name="expectedExceptionType" type="string" required="true" />
	<cfargument name="expectedExceptionMessage" type="string" required="true" />
	<cfargument name="results" />
	<cfargument name="outputOfTest" />
	<cfargument name="testCase" />
------------------------------------------------------------------------------*/

function handleCaughtExceptionShouldCreatePassingEntry(){
	e = { type='my.exception', message='you suck at unit testing', detail='my exception detail' };
   runner.handleCaughtException( e,'my.exception','you suck at testing', this.result,'output',this);
   assertEquals( 1,this.result.testSuccesses );
}

function handleCaughtExceptionShouldCreateFailure(){
	e = { type='my.exception', message='you suck at unit testing', detail='my exception detail' };
   runner.handleCaughtException( e,'my.wrong.exception','you suck at testing', this.result,'output',this);
   debug(this.result);
   assertEquals( 1, this.result.testFailures );
}

//hits path exceptionMatchesType==false, expectedExceptionType neq ''==true
function handleCaughtExceptionShouldAssignMessageAndFailIf(){
   e = { type='my.exception', message='message', detail='my exception detail' };
  runner.handleCaughtException( e,'my.other.exception.xyz','you suck at testing', this.result,'output',this);
  assertEquals( 1, this.result.testFailures );
}

//hits path exceptionMatchesType==false, expectedExceptionType neq ''==false,
function handleCaughtExceptionShouldCreateError(){
   e = { type='my.exception', message='message', detail='my exception detail' };
  runner.handleCaughtException( e,'','', this.result,'output',this);
  debug( this.result );
  assertEquals( 1, this.result.testErrors );
}



</cfscript>
</cfcomponent>
