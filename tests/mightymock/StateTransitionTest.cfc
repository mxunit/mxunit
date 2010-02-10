<cfcomponent output="false" extends="BaseTest">
<cfscript>


function testStateTransition(){
  
  mock._$setState('idle');
  
  mock._$setState('registering');
  assertEquals( 'idle' , mock._$getPreviousState() );
  assertEquals( 'registering' , mock._$getState() );
  
  mock._$setState('executing');
  assertEquals( 'registering' , mock._$getPreviousState() );
  assertEquals( 'executing' , mock._$getState() );
  
  
  mock._$setState('verifying');
  assertEquals( 'executing' , mock._$getPreviousState() );
  assertEquals( 'verifying' , mock._$getState() );
  
  mock._$setState('idle');
  assertEquals( 'verifying' , mock._$getPreviousState() );
  assertEquals( 'idle' , mock._$getState() );
  
  mock._$setState('error');
  assertEquals( 'idle' , mock._$getPreviousState() );
  assertEquals( 'error' , mock._$getState() );
}



</cfscript>
</cfcomponent>