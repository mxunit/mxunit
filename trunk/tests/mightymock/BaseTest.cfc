<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
   sys = createObject('java','java.lang.System');
	 mName = 'foo';
	 args = {a=[1,2,3],s='some value'};
  	id =  '$' & sys.identityHashCode(mName) & '_' & sys.identityHashCode(args);
    a = [1,2,3,4];
    q = queryNew('asd');
    x = xmlnew();
    x.xmlRoot = XmlElemNew(x,"MyRoot");
    dummy = 'mxunit.tests.mightymock.fixture.Dummy';
    mockery = 'mxunit.tests.mightymock.fixture.Mockery';
    mock = createObject('component','mxunit.framework.mightymock.MightyMock').init();
    s = {a=123,b='asd'};

    mockFactory = createObject('component','mxunit.framework.mightymock.MightyMockFactory').init();
    $ = mockFactory.create; //jQuery-like alias for multi-mock creation
    $$ = mockFactory.createSpy; //jQuery-like alias for multi-mock creation
</cfscript>

  <cffunction name="getQ" access="private">
		<cfargument name="flag" required="false" default="1">
		<cfif (arguments.flag eq 1)>
			<cf_querysim>
			user
			id,f_name,l_name,group
			1|pocito|mock|33
			2|mighty|mock|33
			3|mitee|mock|33
			</cf_querysim>
		<cfelse>
			<cf_querysim>
			user
			id,f_name,l_name,group
			1|bobo|the assclown|22
			2|mighty|mouse|22
			3|pocito|mas|22
			4|kwai chang|caine|22
			</cf_querysim>
		</cfif>

		<cfreturn user>
	</cffunction>
</cfcomponent>