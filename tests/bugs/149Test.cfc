<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function AssertNotequalsFailureMessageShouldBeMeaningful() {
     try{
      assertNotEquals(1,1);
     }
     catch(mxunit.exception.AssertionFailedError e){
			debug(e);
			assert(find('These values should not be the same', e.message) , 'partial expected failure message not found' );
     }

  }

  function AsserEqualsFailureMessageShouldBeMeaningful() {
		try{
      assertEquals(1,2);
     }
     catch(mxunit.exception.AssertionFailedError e){
       assert(find('These values should be the same', e.message) , 'partial expected failure message not found' );
     }

  }



</cfscript>
</cfcomponent>