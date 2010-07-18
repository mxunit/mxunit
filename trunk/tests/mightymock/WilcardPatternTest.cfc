<cfcomponent output="false" extends="BaseTest">
<cfscript>

mainRetVal = [1,2,3,4,5,6,7,8,9];

function $wilcardPatternSmokeTest(){
     mock.foo('{+}').returns(mainRetVal);
     reg = mock._$getRegistry();
     args = {1={1='asdasd'}};
     p = reg.findByPattern('foo',args);
     debug( p );
     debug( reg );
     
     v = mock.foo('asdasd');
     debug(v);
     assertEquals(mainRetVal,v);
}


function emptyParamsShouldWork(){
   mock.foo('{*}').returns(mainRetVal);
   v = mock.foo();
   assertEquals(mainRetVal,v);
}

function multipleParamsShouldWorkWithOneOrMoreWildCard(){
   mock.foo('{+}').returns(mainRetVal);
   v = mock.foo('asdasd');
   assertEquals(mainRetVal,v);
   v = mock.foo('asdasd',4564);
   debug(v);
   assertEquals(mainRetVal,v);
   
   v = mock.foo('asdasd',4564,'dfgdfg',345345,this);
   debug(v);
   assertEquals(mainRetVal,v);
      
}


function multipleParamsShouldWorkWithZeroOrMoreWildCard(){
   mock.foo('{*}').returns(mainRetVal);
   v = mock.foo('asdasd');
   assertEquals(mainRetVal,v);
   v = mock.foo('asdasd',4564);
   debug(v);
   assertEquals(mainRetVal,v);
   
   v = mock.foo(mainRetVal,4564,'dfgdfg',345345,this);
   debug(v);
   assertEquals(mainRetVal,v);
   debug(mock.debugMock());
      
}


 function setUp(){
    mock.reset();

  }

  function tearDown(){

  }


</cfscript>

</cfcomponent>