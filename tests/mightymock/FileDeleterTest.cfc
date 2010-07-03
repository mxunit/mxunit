<cfcomponent output="false" extends="BaseTest">
<cfscript>
  
  
  function testSingleLiteralParameter(){
    nuMock.sendNotifications('asd');
    //debug( nuMock.debugMock() );
    nuMock.verify().sendNotifications('asd');
  }
  
  function testMultipleArguments(){  
    nuMock.sendNotifications("{string}","{string}","{string}","{string}").returns();
    nuMock.sendNotifications('asd','lkj','xyz','foo');
    nuMock.sendNotifications('fgh','ghj','ghjghjghj','ghjghjghjgh8jghjghj');
    nuMock.sendNotifications('ruioty','fg','ghjghjghj','ghjghjghjghj7ghjghj');
    nuMock.sendNotifications('dffgg','ghj','ghjghjghj','ghjghjgh6jghjghjghj');
    nuMock.sendNotifications('uio','ghj','ghj4ghjghj','gh5jghjghjghjghlljghj');
    //debug( nuMock.debugMock() );
    nuMock.verifyTimes(5).sendNotifications("{string}","{string}","{string}","{string}");
  }
  

  
  function setUp(){
   nuMock = $('mxunit.tests.mightymock.fixture.FileDeleter',true);
   nuMock.sendNotifications('asd').returns();
  }
  
  function tearDown(){
    nuMock.reset();
  }    
    
    
</cfscript>
</cfcomponent>