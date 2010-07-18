<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>




 function queryHandlerShouldInvokeFixtureObjectTwelveTimes() {
    dpHandler.runQueryDataProvider(cut,'queryEcho','q');
 }


 function queryHandlerShouldInvokeFromQueryreference() {
    dpHandler.runQueryDataProvider(cut,'queryEcho',q); //passing in reference not string
 }

  function queryHandlerShouldInvokeFixtureObjectThreeTimes() {
    dpHandler.runQueryDataProvider(cut,'queryEcho','q');

  }


function sanity() {
 assertSame( dpHandler , dpHandler );
}

function spyTest() {
	/*
   dpSpy.mock().invokeComponentForQueryProvider('{any}','{any}','{any}');
   dpSpy.setContext(variables);
   dpSpy.runQueryDataProvider(cut,'queryEcho','q');
   debug( dpSpy.debugMock() );
   dpSpy.verifyAtLeast(1).invokeComponentForQueryProvider('{any}','{any}','{any}');
*/
}


  function setUp(){
    dpHandler = createObject('component', 'mxunit.framework.DataproviderHandler').init(variables);
    //dpSpy = createObject('component', 'mightymock.MightyMock').createSpy('mxunit.framework.DataproviderHandler');
    //What I want to do is overide the behavior of this method in the component
    //under test, AND be able to verify it was called n times.
    // mock._invokeComponentForQueryProvider('{any}','{any}','{any}','{any}').returns();
    //debug( mock.debugMock() );
   // dpHandler.override('_invokeComponentForQueryProvider',override);
    cut = createObject('component', 'mxunit.tests.framework.fixture.DataProviderFixture');

  }

  function tearDown(){

  }



</cfscript>

<cf_querysim>
q
col1,col2,col3,col4
1|1.2|1.3|1.4
2|2.2|2.3|2.4
3|3.2|3.3|3.4
</cf_querysim>

</cfcomponent>