<cfcomponent output="false" extends="BaseTest">
<cfscript>


 function simpleMockTestWithNoReturns() {
    m1 = $();
    //register
    m1.foo().returns(); //should be same as m1.foo().returns();
    debug(m1.debugMock());
    //invoke
    assert( m1.foo() == '' );
    //verify
    m1.verify().foo();

    m1.reset();
    m1.foo().returns('bah');
    assert( m1.foo() == 'bah');

    m1.reset();
    m1.writeToLog ('Hello.');
    m1.writeToLog ('Goodbye.');

    m1.writeToLog ('Hello.');
    m1.writeToLog ('Goodbye.');

    m1.verify().writeToLog ('Hello.');
    m1.verify().writeToLog ('Goodbye.');

    // m1.verifyTimes(2).writeToLog ('{string}');




 }


  function fastMocksShouldNotalterMetaDataAndReturnUniqueObjects() {
     m1 = $();
     md1=getMetaData(m1);
     //debug( md1 );
     m2 = $('foo.a.bar');
     md2=getMetaData(m2);
     //debug( md2 );
     assertEquals( 'mxunit.framework.mightymock.MightyMock' , md1.name );
     assertEquals( 'mxunit.framework.mightymock.MightyMock' , md2.name );
     assertEquals( md1.name , md2.name );
     assertNotSame(m1,m2);
  }

 function initFastMockShouldSetMockProperty() {
   m = $('ass.clown');
   debug(m.debugMock());
   assertEquals( 'ass.clown' , m.getMocked().name );
 }

 function simpleFastMockSmokeTest() {
   m = $('ass.clown');
   m.foo(1,2,3).returns('bar');
   assertEquals( 'bar' , m.foo(1,2,3) );
 }

 function type_safeMockShouldBeKnownType() {
   mock = $('mxunit.tests.mightymock.fixture.Dummy',true);
   assertIsTypeOf(mock,'mxunit.tests.mightymock.fixture.Dummy');
 }

 function typesafeMockShouldBeAcceptedByTypedArg() {
   strict = createObject('component', 'mxunit.tests.mightymock.fixture.AcceptStrictType');
   mock = $('mxunit.tests.mightymock.fixture.Dummy',true);
   retVal = strict.echoCFC(mock);
   assertSame(mock,retVal);
 }

 function typesafeMockSmokeTest() {
   mock = $('mxunit.tests.mightymock.fixture.Dummy',true);
   mock.foo('{string}').returns('yow!');
   assertEquals( 'yow!' , mock.foo('asdasd') );
   mock.verify().foo('{string}');

 }

  function setUp(){

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>