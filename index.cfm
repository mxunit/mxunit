<cfparam name="url.output" default="extjs" />

<cfinclude template="resources/theme/header.cfm" />

<cftry>
	<!--- TODO This will probably break once past CF 9 --->
	<cfset cfMajorVersion = left(server.coldfusion.productversion, 1) />
	<cfset cfEngine =  server.coldfusion.productname />
	
	<!--- Check what engine --->
	<cfif find("BlueDragon", cfEngine)>
		<cfset cfEngine = 'Blue Dragon' />
	<cfelseif cfEngine NEQ 'Railo'>
		<cfset cfEngine = 'ColdFusion' />
	</cfif>
	
	<!--- Check for older CF Versions --->
	<cfif cfEngine EQ 'ColdFusion' AND cfMajorVersion lt 7>
		<cfthrow type="mxunit.exception.UnsupportedCFVersionException">
	</cfif>
	
	<h2>Welcome, <cfoutput>#cfEngine#</cfoutput> User!</h2>
	
	<p>
		Here is a sample of the test suite to verify your installation works:
	</p>
	
	<cfset testCase = '<cfcomponent displayname="MxunitInstallVerificationTest" extends="mxunit.framework.TestCase">
			<cffunction name="testThis" >
				<cfset assertEquals("this","this") />
			</cffunction>
			
			<cffunction name="testThat" >
				<cfset assertEquals("this","that", "This is an intentional failure so you see what it looks like") />
			</cffunction>
			
			<cffunction name="testSomething" >
				<cfset assertEquals(1,1) />
			</cffunction>
			
			<cffunction name="testSomethingElse">
				<cfset assertTrue(true) />
			</cffunction>
		</cfcomponent>' />
	
	<cffile action="write" file="#context#MXUnitInstallTest.cfc" output="#testCase#" />
	
	<cfset testSuitePath = 'framework.TestSuite' />
	<cfset testSuite = createObject("component", testSuitePath).TestSuite() />
	
	<!--- Get the meta information from the test suite --->
	<cfset testSuiteMeta = getMetaData(testSuite) />
	
	<!--- Determine the component path to use --->
	<cfset componentPath = left(testSuiteMeta.name, len(testSuiteMeta.name) - len(testSuitePath)) />
	
	<cfset testSuite.addAll("#componentPath#MXUnitInstallTest") />
	
	<cfset results = testSuite.run() />
	
	<div>
		<cfoutput>
			#results.getResultsOutput(url.output)#
		</cfoutput>
	</div>
	
	<cfcatch type="mxunit.exception.UnsupportedCFVersionException">
		<h2 class="error">Unsupported Version</h2>
		
		<p>
			This installation verification page does not support your verion of ColdFusion
			(<strong><cfoutput>#server.coldfusion.productversion#</cfoutput></strong>).
		</p>
		
		<p>
			The MXUnit framework was likely installed
			with success and can be used with the Eclipse
			Plug-in, but <em>this page</em> was designed 
			for CFMX7 and later.
		</p>
	</cfcatch>
	
	<cfcatch type="any">
		<!--- TODO Remove --->
		<cfdump var="#cfcatch#" />
		<cfabort />
		
		<h2 class="error">Ooops!</h2>
		
		<p>
			There was a problem with running the installation test:
		</p>
		
		<cfoutput>
			<ul class="error">
				<li>
					<strong>Type:</strong><br />
					<code>#cfcatch.type#</code>
				</li>
				<li>
					<strong>Message:</strong><br />
					<code>#cfcatch.message#</code>
				</li>
				<li>
					<strong>Detail:</strong><br />
					<pre><code>#cfcatch.Detail#</code></pre>
				</li>
			</ul>
		</cfoutput>
		
		<p>
			Also, make sure you or CFML engine has write access to this directory
			in order to run this installation test.
		</p>
	</cfcatch>
</cftry>

<cfinclude template="resources/theme/footer.cfm" />