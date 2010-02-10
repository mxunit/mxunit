<cfcomponent output="false" extends="BaseTest">
<cfscript>

function mockShouldBeCaseInsensitive(){
   m = $('bar');
   m.foo('bar').returns(true);
   
   m.foo('bar');
   m.foo('Bar');
   m.fOo('BaR');
   m.fOO('bAr');
   m.verifyTimes(4).foo('bar');
}


  function setUp(){
   
  }

  function tearDown(){

  }



</cfscript>

</cfcomponent>
