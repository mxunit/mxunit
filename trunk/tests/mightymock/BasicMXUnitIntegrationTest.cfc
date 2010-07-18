<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  

  
  function setUp(){
    myMock = mock("s.s.s");  
    myMock.one().returns();
    myMock.two().returns();
    myMock.three().returns();
    myMock.four().returns();
    myMock.one();
    myMock.two();
    myMock.three();
    myMock.four(); 
    
  }

  function tearDown(){
    myMock.reset();
  }  
  
  function smoke(){
    myMock.verify().two();
    
  }
  

 function testOrderedExpectationRange(){
    order = '';
    order = orderedExpectation(myMock);
    order.one().four().verify();
    //debug( myMock.debugMock() );
  }
 

 function testOrderedExpectationWorks(){
     order = orderedExpectation(myMock);
     order.one().two().three().verify();
  }

  
  function testOrderedExpectationIsAlive(){
     order = orderedExpectation(myMock);
  }

</cfscript>
<cffunction name="outOfOrderShouldFail" >
	<cfscript>
	order = '';
    order = orderedExpectation(myMock);
    try{
    order.four().one().verify();
    }
    catch(mxunit.exception.AssertionFailedError e){}
	</cfscript>
</cffunction>

</cfcomponent>