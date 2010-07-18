<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  function testAbstractMockMetaData(){
    //debug( getMetaData(mock) );
  }
  
  function setUp(){
    mock = createObject('component' ,'mxunit.framework.mightymock.AbstractMock');
  }
  
  
  function tearDown(){
  }  
    
</cfscript>
</cfcomponent>