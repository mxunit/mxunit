
<cfcomponent  extends="mxunit.framework.TestCase">

<cffunction name="testGetConfigElement">
 Tests whether or not UseRemoteFacadeObjectCache element returns true.
 <cfscript>
  node = cm.getConfigElement("userConfig","componentRoot");
  dump(node);
  assertEquals("mxunit",node[1].xmlAttributes["value"]);
  assertEquals("false",node[1].xmlAttributes["override"]);
 </cfscript>

</cffunction>


<cffunction name="testGetConfigElementValue">
 Tests whether or not UseRemoteFacadeObjectCache element returns true.
 <cfscript>
  val = cm.getConfigElementValue("pluginControl","UseRemoteFacadeObjectCache");
  assertTrue(val, "Value returned from xml config is not true, but should be");
 </cfscript>

</cffunction>

<cffunction name="testGetVersion">
 Tests that the version in the config file is 1.0.0 //Maybe should use version.properties instead
 <cfscript>
  val = cm.getConfigElementValue("meta","version");
  assertEquals("1.0.0",val, "Value returned from xml config is not 0.9, but should be");
 </cfscript>

</cffunction>

<cffunction name="testGetConfigElements">
 <cfset var assertionExtensionXpath =  "/mxunit-config/config-element[@type='assertionExtension' and @autoload='true']"  />
  Tests how many assertion config elements are returned for a given xpath (1).
 <cfscript>
  var elements = cm.getConfigElements(assertionExtensionXpath);
  addtrace( arraylen(elements) );
  assertTrue(arraylen(elements), 1, "More than one element returned from config");
 </cfscript>
</cffunction>

<cffunction name="testGetConfigElementAttributeCollection">
 <cfscript>
  val = cm.getConfigElementAttributeCollection("newFramework","constructorArgs");
  assertEquals(1,StructCount(val));
  assertEquals("constructorArg1",val.arg1);
 </cfscript>
</cffunction>

<cffunction name="setUp">
   <cfset  variables.cm = createObject("component","mxunit.framework.ConfigManager").ConfigManager() />

</cffunction>

</cfcomponent>
