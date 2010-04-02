<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  
  
  function setUp(){
    myMock = mock("s.s.s");  
    myMock.one().returns();
    myMock.two().returns();
    myMock.three().returns();
  }

  function tearDown(){
    myMock.reset();
  }  
  
  function smoke(){
    myMock.two();
    myMock.verify().two();
    
  }
  


 function testOrderedExpectationWorks(){
     myMock.one();
     myMock.two();
     myMock.three();
     order = orderedExpectation(myMock);
     order.one().two().three().verify();
  }

  
  function testOrderedExpectationIsAlive(){
     order = orderedExpectation(myMock);
  }

</cfscript>
</cfcomponent>