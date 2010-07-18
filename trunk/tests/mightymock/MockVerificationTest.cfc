<cfcomponent output="false" extends="BaseTest">
<cfscript>

function howToHandlePatternVerification(){
  mock.foo('{string}').returns('asd');
  mock.foo('asd');
  mock.verify().foo('{string}');
  //mock.verify('times',1).foo('asd');

  //To Do:
  debug('Record all literal invocations and add a column for pattern id if invoked via a pattern match.');
}


function verifyShouldAcceptZeroOrMoreParams(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.verify(1).foo(1);
  mock.verifyTimes(1).foo(1);
}


function testThatEmptyVerifyWorksTheSameAsTimesOne(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.verify().foo(1);
  mock.verifyTimes(1).foo(1);
}




function testThatMultipleInteractionsAndChainedVerifications(){
  mock.foo(1).returns('bar');
  mock.bar('bar').returns('foo');
  mock.foo('{struct}').returns('no');

  mock.foo(1);
  mock.foo(1);
  mock.bar('bar');
  mock.foo(1);
  mock.foo(1);
  mock.bar('bar');
  mock.foo(1);

  debug(mock._$debugInvoke());

 mock.verifyTimes(5).foo(1).
      verifyTimes(2).bar('bar')  .
      verifyNever().foo('{struct}');

}


function testThatMultipleChainedVerificationsWork(){
  mock.foo(1).returns('bar');

  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  mock.foo(1);
  debug(mock._$debugInvoke());

 mock.verifyTimes(5).foo(1).
      verifyAtLeast(1).foo(1) .
      verifyAtMost(5).foo(1)  ;

}


function verifyExceptionThrown(){
  debug('is this redundant?');
  mock.foo(1).throws('YouSuckAtUnitTestingException');
  try{
    mock.foo(1);
    fail('should not get here');
   }
   catch(YouSuckAtUnitTestingException e){
   }
   mock.verify().foo(1);
}

function verifyCounts(){
  mock.foo(1).returns('bar');
  mock.foo(1);
  mock.verifyTimes(1).foo(1);
  mock.verifyAtLeast(1).foo(1);
  mock.verifyAtMost(1).foo(1);
  mock.verifyOnce().foo(1);
  mock.verifyNever(0).asdasdasdasdasdasdasd(1);
}

function verifyNever(){
  mock.verifyNever().foo(1);

}

function verify25MockIterations(){
  var i = 1;
  mock.foo(1).returns('bar');
  for(i; i < 26; i++){
   mock.foo(1);
  }
  mock.verifyTimes(25).foo(1);
 }






  function setUp(){
    mock = createObject('component','mxunit.framework.mightymock.MightyMock').init('verify.me');
  }

  function tearDown(){
    mock.reset();
  }


</cfscript>
</cfcomponent>