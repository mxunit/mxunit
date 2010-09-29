<cfcomponent extends="BaseTest">
<cfscript>
function testThatMockIsDesiredType(){
   m1 = $(dummy, true);
   m2 = $(mockery, true);
   m1.foo().returns('bar');
   m2.bar().returns('foo');

   //debug(m1);
   //debug(m2);
   debug( m1.debugMock() );
   debug( m2.debugMock() );

  assertIsTypeOf(m1, 'mxunit.tests.mightymock.fixture.Dummy');
  assertIsTypeOf(m2, 'mxunit.tests.mightymock.fixture.Mockery');
  //assertIsTypeOf(mock, 'mxunit.tests.mightymock.fixture.Dummy');

}

function testThatInitIsCallingCreateTypeSafeMocks(){


}

function testCreateTypeSafeMock(){
  mymock =  createObject('component','mxunit.framework.mightymock.MightyMock').createTypeSafeMock(dummy);
  mymock2 =  createObject('component','mxunit.framework.mightymock.MightyMock').createTypeSafeMock(mockery);
  assertIsTypeOf(mymock, 'mxunit.tests.mightymock.fixture.Dummy');
  assertIsTypeOf(mymock2, 'mxunit.tests.mightymock.fixture.Mockery');
 // assertIsTypeOf(mock, 'mxunit.tests.mightymock.fixture.Dummy');

}

function testCreateTypeSafeMockWithObject(){
  dummy =  createObject('component',dummy);
  mockery =  createObject('component',mockery);
  mymock =  createObject('component','mxunit.framework.mightymock.MightyMock').createTypeSafeMock(dummy);
  mymock2 =  createObject('component','mxunit.framework.mightymock.MightyMock').createTypeSafeMock(mockery);
  assertIsTypeOf(mymock, 'mxunit.tests.mightymock.fixture.Dummy');
  assertIsTypeOf(mymock2, 'mxunit.tests.mightymock.fixture.Mockery');
 // assertIsTypeOf(mock, 'mxunit.tests.mightymock.fixture.Dummy');

}

</cfscript>


<cffunction name="foo" access="private">
 <cfargument name="asd" type="mightymock.test.fixture.Dummy">

</cffunction>

</cfcomponent>