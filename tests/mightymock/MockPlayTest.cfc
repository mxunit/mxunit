<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>

function $peepArgumentCollection(){
  var ac = createObjecT('java','coldfusion.runtime.ArgumentCollection');
  //dump(ac);
  var ss = {z='z', a='a', hubuh='321', oof='aff' };
  _peep(1,'a','zoo','A');

}

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
   var ss = {z='z', a='a', hubuh='321', oof='aff' };
   var newArgs = createObject( 'java', 'java.util.TreeMap' ).init(ss);
   debug(newArgs);

 }

  function peepSortedStruct(){
    var s = {z='z', a='a', hubuh='321', oof='aff' };
    argumentCollection=s;
    dumpArgs(argumentCollection);

  }


  function setUp(){

  }

  function tearDown(){

  }


</cfscript>

<cffunction name="dumpArgs" access="package" output="false">
	<cfset debug(arguments)>
</cffunction>

<!---
If a method is defined with named args, the values are naturally sorted.
If not, the order is not guaranteed, but the keys are able to be sorted:
2,1,3,4, etc.

 --->
<cffunction access="private" name="_peep">

 <cfscript>
 var set = arguments.values();
 var it = set.iterator();
 while(it.hasNext()){
  dump( it.next().toString() );
 }
  dump(it);
 </cfscript>
</cffunction>

</cfcomponent>