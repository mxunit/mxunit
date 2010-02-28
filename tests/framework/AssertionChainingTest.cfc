<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
   
  function testAssertMethodChainAndPrint(){
     
     println('Added method chaining for assert() only.');
     print('Not sure what value it has unless someone is instantiating Assert separately.');
     
     assert(true, "should be true")
     .assert(1 eq 1, "better be true")
     .assert('asd' is 'asd', "should be true");
  
   }
  

  
  function setUp(){
  
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>