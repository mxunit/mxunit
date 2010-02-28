 <cfcomponent  extends="mxunit.framework.TestCase">
 


<cffunction name="testThatAssertEqualsFailureMessageIsMessageActualExpected">
  <cfscript>
     try{
      assertEquals(1,2, "my message");
     }
     catch(any e){
      actual = e.getMessage();
     }
     expected = "my message::[1] NOT EQUAL TO [2]"; 
     debug(expected);
     debug(actual);
      assertEquals(expected, actual, "Failure message outputs should be the same");
  </cfscript>
</cffunction>


<cffunction name="testNormalizeArgumants">
  <cfscript>
    pub = makePublic(this,"normalizeArguments");
    args = structNew();
    args.expected = 1;
    args.actual = 2;
    args.message ="my message";
    newArgs = pub.normalizeArguments("equals",args); 
    debug(newArgs);
    
  </cfscript>

</cffunction>



  <cffunction name="setUp" access="public" returntype="void">
    <cfset this.setTestStyle("default") />
  </cffunction>

  

</cfcomponent>
