<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


 function $printPrettyFailureMessage(){
  try{
    order.one().four( ).three( ).verify();
   }
   catch(mxunit.exception.AssertionFailedError e){
     debug(e); 
   }
  
  debug( order.getInvocations() );
  debug( order.getExpectations() );

 }

 function simpleVerify(){
   order.one().two().three().verify();
 }

  function $verifyExact(){
   order.one().two().three().verifyExact();
   //To Do:
   debug('to do');
  }


  function testGetInvocationTime(){
   var t = order.getInvocationTime('ONE_3938'); //upper case!
    order.one().
     			two().
     			three();
   debug( order.getExpectations() );
   debug(t);
   assert( isnumeric(t) );
  }


function FailWhenExpectationsAreNotMet(){

  try{
     order.one().
           two().
           four().
           three().
     	     verify();
     	fail('should not get here');
    }
    catch(mxunit.exception.AssertionFailedError e){
      debug(e);
    }
   }



function passWhenExpectationsMet(){
     order.one().
           two().
           three().
     	     verify();
 }




  function failWhenExpectationNotFound(){
    try{
	     order.foo().
           meh().  //doesn't exist
     	     verify();
	    fail('should not get here.');
     }
     catch(mxunit.exception.AssertionFailedError e){}

  }




  function setUp(){
    mock1 = createObject('component','mxunit.framework.mightymock.MightyMock').init('mock1');
    mock2 = createObject('component','mxunit.framework.mightymock.MightyMock').init('mock2');
    mock3 = createObject('component','mxunit.framework.mightymock.MightyMock').init('mock3');
    //define behavior
    mock1.one().returns();
    mock1.two().returns();
    mock2.three().returns();
    mock3.four().returns();
    //execute and record
    mock1.one();
    mock1.two();
    mock2.three();
    mock3.four();

    //instantiate order verification object
    order = createObject('component','mxunit.framework.mightymock.OrderedExpectation').init(mock1,mock2,mock3);
  }

  function tearDown(){

  }


</cfscript>


<cffunction name="__throw" access="private">
 <cfargument name="message" />
 <cfargument name="detail" />
 <cfthrow type="mxunit.exception.AssertionFailedError" message="#arguments.message#" detail="#arguments.detail#" />
</cffunction>
</cfcomponent>