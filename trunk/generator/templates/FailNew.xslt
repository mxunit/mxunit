<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"  />

<xsl:template match="root">
<xsl:for-each select="//component">
&lt;cfcomponent name="<xsl:value-of select="@name" />Test" extends="mxunit.framework.TestCase"&gt;
	&lt;!--- Begin specific tests ---&gt;
	<xsl:for-each select="method">
	<xsl:sort select="name"/>
	&lt;cffunction name="test<xsl:value-of select="@name"/>" access="public" returnType="void"&gt;
		&lt;cfscript&gt;
			assertFalse(true,"Test not implemented");
		&lt;/cfscript&gt;
	&lt;/cffunction&gt;		
	</xsl:for-each>

	&lt;!--- setup and teardown ---&gt;
	<xsl:call-template name="setup" />
	<xsl:call-template name="teardown" />
&lt;/cfcomponent&gt;
</xsl:for-each>
</xsl:template>


<xsl:template name="setup">
	&lt;cffunction name="setUp" returntype="void" access="public"&gt;
		&lt;cfscript&gt;
			this.myComp = createObject("component","<xsl:value-of select="@fullname" />");		
		&lt;/cfscript&gt;
	&lt;/cffunction&gt;
</xsl:template>

<xsl:template name="teardown">
	&lt;cffunction name="tearDown" returntype="void" access="public"&gt;
		&lt;!--- Any code needed to return your environment to normal goes here ---&gt;
	&lt;/cffunction&gt;
</xsl:template> 

</xsl:stylesheet>