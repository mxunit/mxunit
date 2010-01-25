hell from fixture

  <cfscript>
    getPageContext().include("test.cfm");
  </cfscript>

<cfdump var="#getPageContext().getRequest().getHttpRequest()#">  


