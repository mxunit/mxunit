<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent  extends="mxunit.framework.TestCase">

<!--- Begin Specific Test Cases --->
<cffunction name="testTagSoup">
 <cfscript>
     var util = createObject("component","mxunit.framework.ComponentUtils");
     var root =  util.getInstallRoot();
     var dom = xmlNew();
     var tidy = javacast("null","java.lang.Object");
     var paths = arrayNew(1);
     var loader = javacast("null","java.lang.Object");
     var bais = javacast("null","java.lang.Object");
     var baos = javacast("null","java.lang.Object");

	   paths[1] = expandPath("#root#/framework/lib/tagsoup-1.2.jar");
	   paths[2] = expandPath("#root#/framework/lib/xom-1.2.6.jar");
	   loader = createObject("component", "/#root#/framework/javaloader/JavaLoader").init(paths);
	   soup = loader.create("org.ccil.cowan.tagsoup.Parser").init();
	   soup.setFeature("http://xml.org/sax/features/namespace-prefixes", false);
	   soup.setFeature("http://xml.org/sax/features/namespaces", false);

     htmlData = mxunit;
     readBuffer = CreateObject("java","java.lang.String").init(htmlData).getBytes();
		 bais = createobject("java","java.io.ByteArrayInputStream").init(readBuffer);

	   context = loader.create("nu.xom.XPathContext").init("html", "http://www.w3.org/1999/xhtml");
	   doc = loader.create("nu.xom.Document");
	   builder = loader.create("nu.xom.Builder").init(soup);
	   //queryUtil = loader.create("nux.xom.xquery.XQueryUtils").init();

	   //can also use inputstream ...?
	  // doc = builder.build("http://mxunit.org");
	   doc = builder.build(bais);
	   // Maybe we can skip the cf dom parser altogether ....
	   xpath = "/html/body/h1";
	   //Hmmm.... not finding anything ...
	   elements = doc.query(xpath);
	   dom = xmlParse(doc.toXml());
	   //debug(dom);
	    el = xmlsearch(dom,"/html/body/h1");
</cfscript>
<!--- <cfdump var="#doc#"> --->
</cffunction>

	<cffunction name="setUp" access="public" returntype="void">
	<cffile action="read" file="#expandPath("/mxunit/tests/framework/fixture/xpath/mxunit.org.html")#" variable="variables.mxunit">
  </cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>


</cfcomponent>
