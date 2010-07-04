<cfcomponent  extends="mxunit.framework.TestCase">

<!--- 	<cffunction name="testSomething" access="public" returntype="void">
	
  <cffunction name="init" output="true" returntype="any" hint="Creates a CFC using an absolute or a relative path">
	<cfargument name="filePath" type="string" required="true" hint="The path to the CFC you wish to create.">
	<cfargument name="isRelativePath" type="boolean" required="false" default="true" hint="Whether or not the path is a relative path.">

	<cfset var proxy = "">
	<cfset var func = "">

	<cfif arguments.isRelativePath>
		<cfset proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(ExpandPath(arguments.filePath), this)>
	<cfelse>
		<cfset proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(arguments.filePath, this)>
	</cfif>

	<!--- In order to work around some scope quirks, copy the functions to this component //--->
	<cfloop collection="#proxy.getThisScope()#" item="func">
		<cfset SetVariable("this.#func#", proxy.getMethod(func))>
	</cfloop>
	
	<cfreturn this>	
</cffunction>
  
  
	</cffunction> --->

  
 <cffunction name="testPathFunctions">
  <cfoutput>
  <xmp style="font-size:11px">
   getDirectoryFromPath(getCurrentTemplatePath()) == #getDirectoryFromPath(getCurrentTemplatePath())#<br />
   getCurrentTemplatePath() == #getCurrentTemplatePath()# <br />
   ExpandPath("../framework/TestSuite.cfc") == #ExpandPath("../framework/TestSuite.cfc")#<br />
   ExpandPath("./framework/TestSuite.cfc") == #ExpandPath("./framework/TestSuite.cfc")#<br />
   ExpandPath("../tests/framework/fixture/") == #ExpandPath("../tests/framework/fixture/")#<br />
   getPageContext().getRequest().getContextPath() == #getPageContext().getRequest().getContextPath()#
  </xmp>
  </cfoutput> 
 </cffunction>

  
<cffunction name="testCFCProxy" access="public" returntype="void">
  <cfscript>
    //To Do (bill): Need to run /mxunit/index.cfm to create mxunit.MXunitInstallTest
    proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(ExpandPath("/mxunit/framework/TestSuite.cfc"));
    args = arrayNew(1);
    args[1] = "mxunit.MXUnitInstallTest";
    s = structNew();
    s = proxy.invoke("addAll",args);
    results = s.run();
    //debug(s);
     //debug(results);
  </cfscript>

	</cffunction>
  
  <cffunction name="testCFCProxy2" access="public" returntype="void">
  <cfscript>
    proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(expandPath("/mxunit/tests/framework/fixture/NewCFComponent.cfc"));
    args = arrayNew(1);
    s = proxy.invoke("init",args);
    md = getMetaData(s);
    debug( md );
    assertEquals("mxunit.tests.framework.fixture.NewCFComponent", md.name);
    
    proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init(expandPath("/mxunit/framework/ComponentUtils.cfc"));
   // proxy = CreateObject("java", "coldfusion.cfc.CFCProxy").init("C:\\ColdFusion8\\wwwroot\\mdist\\foo\\mxunit\\framework\\ComponentUtils.cfc");
    args = arrayNew(1);
    args[1] = md.name;
    s = structNew();
    s = proxy.invoke("ComponentUtils",args);
    md = getMetaData(s);
    debug( md );
    
  </cfscript>

	</cffunction>
	

	

</cfcomponent>
