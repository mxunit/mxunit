<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>

function whenShouldSetStateToRegistering(){
  cut = mock( 'com.foo.bar' );
  cut.when();
  assert( cut._$getState()=='registering' );
  debug( cut.debugMock() );
}
  

function testWhenSomethingIsCalled(){
  cut = mock( 'com.foo.bar' );
  cut.when().doSomething().returns(true);
  assert( cut.doSomething() );
}
  
  
 function guaranteeSortedStruct(){
   var ss = {'z'='z', 'a'='a', 'hubuh'='321', 'oof'='aff' };
   var newArgs = createObject( 'java', 'java.util.TreeMap' ).init(ss);
   debug(newArgs);
 
 }
  
  function peepSortedStruct(){
    var s = {'z'='z', 'a'='a', 'hubuh'='321', 'oof'='aff' };
    argumentCollection=s;
    dumpArgs(argumentCollection);
  
  }
  
   function dumpArgs(foo){
    debug(arguments);
  }
  
  function setUp(){

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>