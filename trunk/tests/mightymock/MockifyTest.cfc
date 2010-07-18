<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function testMockify() {
     mockifyThis = createObject('component','mxunit.tests.mightymock.fixture.Mockify');

     mocker = $();

     cfc= mocker.mockify(mockifyThis.foo, 'bar' );//.returns('bar');
     //debug(cfc);
     //debug( cfc.getClass().getName());
     udf = createObject('java','coldfusion.runtime.UDFMethod');

     filter = createObject('java','coldfusion.filter.FusionFilter');
     ctx = createObject('java','coldfusion.filter.FusionContext');
     //debug(udf);
     //debug(mockifyThis.foo.getMethodAttributes());
     //debug(filter);
     //debug(ctx);

     //debug(mockifyThis.foo.getClass().getSuperclass().getName());
     //debug(mockifyThis.foo.getClass().getSimpleName());
     //debug(mockifyThis.foo.getSuperScope());
     //debug(mockifyThis.foo.getPagePath());



     //debug( getMetaData(mockifyThis.foo) );

//     debug( getPageContext().getServletConfig().getServletContext() );

     //result = mockifyThis.foo();
    // assertEquals( 'bar', result );

  }



  function setUp(){

  }

  function tearDown(){

  }


</cfscript>



</cfcomponent>