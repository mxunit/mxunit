<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent  extends="mxunit.framework.TestCase">

 <cffunction name="testFile" access="public" returntype="void">
	To Do: Address dir location accross systems
  <cfscript>
     //var a = assertXPath("/html/head/title", "file:///coldfusion8/wwwroot/mxunit/tests/framework/fixture/xpath/mxunit.org.html");
     //debug(a);
   </cfscript>
	</cffunction>

 <cffunction name="testFindGoogleInTitle">
    <cfscript>
      a = assertXpath('/html/head/title', "http://google.com", "Google");
      //debug(a);
     </cfscript>
  </cffunction>

   <cffunction name="testFindMXUnitInTitle">
    <cfscript>
      //addAssertDecorator("mxunit.framework.XPathAssert");
      a = assertXpath('/html/head/title', "http://mxunit.org", "MXUnit - Unit Test Framework and Eclipse Plugin for Adobe ColdFusion");
     </cfscript>
  </cffunction>

 <cffunction name="testSSLUrl">
    <cfscript>
      a = assertXpath('/html/head', "http://amazon.com");
      //debug(a);
     </cfscript>
  </cffunction>
  <cffunction name="testWrapScriptTagInCDATA">
	<cfset var mxunit = "" />
    <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/mxunit.org.html")#" variable="mxunit">
    <cfscript>
    newMxunit = wrapScriptTagInCDATA(mxunit);
  </cfscript>

  </cffunction>

  <cffunction name="testFindTitleInUrl">
    <cfscript>
      a = assertXpath('/html/body', "http://adobe.com");
      //debug(a);
     </cfscript>
  </cffunction>

  <cffunction name="testFindNode1">
	<cfset var nodes = "" />
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/nodes.html")#" variable="nodes">
    <cfscript>
      //dom = buildXMLDom(nodes);
      //debug(tostring(dom));
      //debug(dom);
      a = assertXpath('/html/body/ul/li', nodes);
      //debug(a);
     </cfscript>
  </cffunction>

  <cffunction name="testFindNode1_WithPreBuiltXMLObject">
	<cfset var nodes = "" />
	<cfset var xml = "">
 	<cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/nodes.html")#" variable="nodes">
    <cfset xml = xmlParse(nodes)>
	<cfset assertXPath('/ul/li',xml)>
  </cffunction>



  <cffunction name="testFindNode2">
	<cfset var mxunit = "" />
   <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/mxunit.org.html")#" variable="mxunit">
    <cfscript>
      //var dom = buildXMLDom(google);
      //debug(tostring(dom));
      //debug(dom);
       a = assertXpath('/html/body/', mxunit);
      //debug(a);
     </cfscript>

  </cffunction>

  <cffunction name="testIsWrapped">
	<cfset var mxunit = "" />
	<cfset var google = "" />
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/google.com.html")#" variable="google">
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/mxunit.org.html")#" variable="mxunit">
    <cfscript>
    wrapped = isWrapped(google);
    //debug(wrapped);
    //debug(google);
    assertFalse(wrapped,"Should not contain CDATA in script tag");


    wrapped = isWrapped(mxunit);
    //debug(wrapped);
    //debug(mxunit);
    assertFalse(wrapped,"Should not contain CDATA in script tag");
  </cfscript>

  </cffunction>


  <cffunction name="testBuildXmlDom">
	<cfset var mxunit = "" />
	<cfset var google = "" />
	<cfset var nodes = "" />
	<cfset var assertionpatterns = "" />
	<cfset var testsuites = "" />
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/mxunit.org.html")#" variable="mxunit">
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/google.com.html")#" variable="google">
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/nodes.html")#" variable="nodes">
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/assertionpatterns.html")#" variable="assertionpatterns">
  <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/testsuites.html")#" variable="testsuites">
    <cfscript>

      try{
      dom = buildXMLDom(fred);
      }
      catch(any e){
      }
      //debug(dom);

      dom = buildXMLDom(mxunit);
      assertIsXmlDoc(dom);
      //debug(dom);
      //writeoutput(dom);

       dom = buildXMLDom(google);
       assertIsXmlDoc(dom);

      dom = buildXMLDom(nodes);
      assertIsXmlDoc(dom);
      //debug(dom);
      // dom = buildXMLDom(adobe);
      dom = buildXMLDom(assertionpatterns);
      //debug(dom);

      dom = buildXMLDom(testsuites);
      //debug(dom);
      // assertIsXmlDoc(testsuites);
      //build from url
      dom = buildXMLDom("http://google.com",true);
      //debug(dom);

      dom = buildXMLDom("http://hotchickswithdouchebags.com/",true);
      //debug(dom);
    </cfscript>
  </cffunction>


	<cffunction name="setUp" access="public" returntype="void">
	  <!--- Place additional setUp and initialization code here --->
      <cfset addAssertDecorator("mxunit.framework.XPathAssert") />
      <!---
		<cfset var adobe = "" />
	    <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/adobe.com.html")#" variable="adobe">
      <!--- Bad or illegal html. Cannot parse--->
      <cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/fredfrap.com.html")#" variable="fred">



 --->
  </cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>


</cfcomponent>
