<cfcomponent extends="BaseTest">
<cfscript>
function testDebug(){
    assertIsTypeOf( mockBug, 'mxunit.framework.mightymock.MockDebug');
}



function dumpMockBugs() {
 m = $('snicker');
 m.foo().returns();
 m.bar(123).throws('eek-a-mouse');
 a = [1,2,3,4,5];
 m.foobar('asd').returns(a);

 debug( mockBug.debug(m,true) );
}


function setUp() {
  mockBug = createObject('component', 'mxunit.framework.mightymock.MockDebug');



}
</cfscript>
</cfcomponent>