<cfcomponent output="false" extends="BaseTest">
<cfscript>

function doVerifyShouldExecuteTargets(){
  mr.addInvocationRecord('foo',args,'ok');
  verifier.doVerify('verify', 'foo', args, 1, mr );

  verifier.doVerify('verifyTimes', 'foo', args, 1, mr );
  
  verifier.doVerify('verifyAtLeast', 'foo', args, 1, mr );
  
  verifier.doVerify('verifyAtMost', 'foo', args, 1, mr );
  
  verifier.doVerify('verifyNever', 'bah', args, 0, mr );
  
  verifier.doVerify('verifyOnce', 'foo', args, 1, mr );
  
}

function verifyShouldActAsVerifyTimes(){
    mr.addInvocationRecord('foo',args,'ok');
    verifier.verify( 1, 'foo', args, mr );
}


function testNewVerifyTimes(){
    mr.addInvocationRecord('foo',args,'ok');
    verifier.verifyTimes( 1, 'foo', args, mr );
}

function peepVerifyOnceFailure(){
  try{
    verifier.verifyOnce('foo', args, mr );
   }
   catch(mxunit.exception.AssertionFailedError e){
   debug(e);
  }
}

function peepVerifyAtLeastFailure(){
  try{
   verifier.verifyAtleast(1, 'foo', args, mr );
   }
   catch(mxunit.exception.AssertionFailedError e){
   debug(e);
  }
}



  function testVerifyOnce() {
    mr.addInvocationRecord('foo',args,'ok');
    r = verifier.verifyOnce('foo', args, mr );
    debug(r);
    assert(r);
  }

function testVerifyTimes(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verifyTimes( 4, 'foo', args, mr );
  debug(r);
  assert(r);

 }


function testVerifyPeriodically(){
 var i = 1;
  for(i; i < 20; i++){
   mr.addInvocationRecord('foo',args,'ok');
   r = verifier.verifyTimes(i, 'foo', args, mr );
   assert(r);
  }

 }

 function testVerifyCount(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verifyTimes( 4, 'foo', args, mr );
  debug(r);
  assert(r);

 }


 function testVerifyAtLeast(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verifyAtLeast(4, 'foo', args, mr );
  assert(r);
  debug(r);
  r = verifier.verifyAtLeast(1, 'foo', args, mr );
  assert(r);

  try{
   r = verifier.verifyAtLeast(5, 'foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}
 }


 function testVerifyAtMost(){
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  mr.addInvocationRecord('foo',args,'ok');
  r = verifier.verifyAtMost( 12, 'foo', args, mr );
  assert(r);

  try{
   r = verifier.verifyAtMost( 5, 'foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}

 }


function testVerifyNever(){
  r = verifier.verifyNever('foo', args, mr );
  assert(r);
  debug(r);

  mr.addInvocationRecord('foo',args,'ok');
  try{
   r = verifier.verifyNever('foo', args, mr );
   assert(r);
  }
  catch(mxunit.exception.AssertionFailederror e){}

 }


  function setUp(){
    verifier = createObject('component','mxunit.framework.mightymock.Verifier');
    mr = createObject('component','mxunit.framework.mightymock.MockRegistry');
  }

  function tearDown(){

  }


</cfscript>


</cfcomponent>