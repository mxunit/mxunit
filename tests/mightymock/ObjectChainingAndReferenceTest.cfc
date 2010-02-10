<cfcomponent output="false" extends="mxunit.framework.TestCase">
  <!---
   MightyMock should support creating and collaboration of multiple
   mocks. So, if an object under test is dependent on another object,
   which uses yet another object, this should be able to be mocked
   easily!

   Example:

   CUT Logger depends on Controller which depends on Foobar

   Logger.testMe() calls Controller.foo() which calls Foobar.bar() ...

   Logger.testMe(){
     ...
     Controller.foo().bar();
   }

	<cffunction name="LoggerShouldBeAbleLogTrace" access="public" returntype="void" output="false">
		<cftry>
			<cfset testLogger.trace("TRACE Message") />

			<cfcatch type="Any">
				<cfset fail("trace() failed")>
			</cfcatch>
		</cftry>
	</cffunction>
   --->
<cfscript>

  function testRegisterMockAsCollaboratorParameter(){
     foo = $('foo');
     bar = $('bar');
     bar.barbar().returns(true);

     foo.setBar('i see the light').returns(bar);
     foo.asd(bar).returns('asd');
     b = foo.getBar().returns(bar);
    // only valid when creating type-safe mocks
    // assertIsTypeOf(b,'bar');
     debug(b);
     debug(foo.debugMock());
     debug(bar.debugMock());

     assertEquals( 1,1 );

  }

  function testDeepChainedCollaborators(){
     foo = $('foo');
     bar = $('bar');

     foo.setBar(bar).returns(chr(0));
     foo.getBar().returns(bar);

     debug(foo.debugMock());
     debug(bar.debugMock());

     foo.setBar(bar);
     b = foo.getBar();

     debug(b);

  }

  function loggerTraceShouldDoSomething() {
     uuid = createUUID();
     logMessage = 'messy bed; messy head';
     mmFactory = createObject('component','mxunit.framework.mightymock.MightyMockFactory');
     //jQuery-like alias - makes is cleaner, imo.
     $ = mmFactory.create;

     esapi            = $('org.owasp.esapi.ESAPI');
     sessionFacade    = $('org.owasp.esapi.SessionFacade');
     authenticator    = $('org.owasp.esapi.Authenticator');
     securityConfig   = $('org.owasp.esapi.SecurityConfiguration');
     encoder          = $('org.owasp.esapi.Encoder');
     user             = $('org.owasp.esapi.User');

     //define behaviours
     esapi.setSecurityConfiguration(securityConfig).returns();
     esapi.securityConfiguration().returns(securityConfig);

     esapi.setSessionFacade(sessionFacade).returns();
     esapi.sessionFacade().returns(sessionFacade);

     esapi.setEncoder(encoder).returns();
     esapi.encoder().returns(encoder);

     esapi.setAuthenticatior(authenticator).returns();
     esapi.authenticator().returns(authenticator);

     encoder.encodeForHTML(logMessage).returns(logMessage);

     securityConfig.getProperty('LogEncodingRequired').returns(false);
     sessionFacade.getProperty("loggingID").returns(uuid);

     authenticator.setCurrentUser(user).returns();
     authenticator.getCurrentUser().returns(user);
     user.getUserName().returns('the_mighty_mock');
     user.getLastHostAddress().returns('127.0.0.1');

     //inject mock into mock; aka, mock acrobatics
     esapi.setEncoder(encoder);
     esapi.setSessionFacade(sessionFacade);
     esapi.setAuthenticatior(authenticator);

     //instantiate CUT
     logger = createObject('component','mxunit.tests.mightymock.fixture.Logger').init('mylogger','debug',esapi);
     logger.setLevel('trace');

     //exercise method
     logger.trace(logMessage) ;


     //Not a whole lot of verification. Just wanted the mock to work.
     esapi.verify().sessionFacade();
     user.verify().getUserName();

	 ordered = createObject('component','mxunit.framework.mightymock.OrderedExpectation').init(esapi,user);
     ordered.sessionFacade().
			 securityConfiguration().
			 getLastHostAddress().
             verify();

  }


  function testLoggerSimplePhoLogger() {
     uuid = createUUID();
     esapi = $('org.owasp.esapi.ESAPI');
     sessionFacade = $('org.owasp.esapi.SessionFacade');

     sessionFacade.getProperty("loggingID").returns(uuid);

     esapi.setSessionFacade(sessionFacade).returns();
     esapi.sessionFacade().returns(sessionFacade);

     esapi.setSessionFacade(sessionFacade);
     //sf = esapi.sessionFacade();
     //debug(sf);

    //
    logger = createObject('component','mxunit.tests.mightymock.fixture.Logger').init('mylogger','warn',esapi);
    result = logger.logTest('trace me') ;
    assertEquals( uuid,result );

     /* debug(logger);
       r = logger.trace('trace me') ;    debug( isdefined('r'));
     */

     debug(esapi.debugMock());
     debug(sessionFacade.debugMock());

     esapi.verify().sessionFacade();

  }



  function setUp(){
  	mmFactory = createObject('component','mxunit.framework.mightymock.MightyMockFactory');
    $ = mmFactory.create;
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>