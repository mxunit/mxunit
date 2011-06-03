
<cfparam name="url.print_js_resources" type="boolean" default="true" />
<cfparam name="url.toggledebug" type="boolean" default="true" />

<cfinclude template="resources/theme/header.cfm" />
<cftry>
	<cfset cfMajorVersion = listFirst(server.coldfusion.productversion, ",.") />
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

	<div  style="font-size:1.25em;color:#01010;text-decoration:italic">
		Below is a simple test suite to verify your installation. Note that there are
		intentional failures and errors so you can see what they're supposed to look like.
	</div>

	<p><hr color="#eaeaea" noshade="true" size="1" /></p>

	<cfset testCase = '<cfcomponent displayname="MxunitInstallVerificationTest" extends="mxunit.framework.TestCase">
			<cffunction name="testThis" >
				<cfset assertEquals("this","this") />
			</cffunction>

			<cffunction name="testThat" >
				<cfset assertEquals("this","that", "This is an intentional failure so you see what it looks like") />
			</cffunction>

			<cffunction name="testSomething" >
			   <cfset a = arrayNew(1)>
			   <cfset a[1] = "some debug traces" />
			    <cfset debug(a) />
				<cfset assertEquals(1,1) />
			</cffunction>

			<cffunction name="testSomethingElse">
				<cfset assertTrue(true) />
			</cffunction>

			<cffunction name="testIntentionalError">
				<cfset foo = bar />
			</cffunction>

		</cfcomponent>' />

	<cffile action="write" file="#context#MXUnitInstallTest.cfc" output="#testCase#" />

	<cfset testSuitePath = 'mxunit.framework.TestSuite' />
	<cfset testSuite = createObject("component", testSuitePath).TestSuite() />
	<cfset installTest = createObject("component", "mxunit.MXUnitInstallTest") />
	<cfset installTestMetaData = getMetadata(installTest) />
	<cfset testSuite.addAll("MXUnitInstallTest", installTest) />
	<cfset results = testSuite.run() />


	<div>
		<cfoutput>
			#results.getResultsOutput('rawhtml')#
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

		<h2 class="error">Ooops!</h2>

		<p>
			There was a problem with running the <strong>installation test</strong>.
			The installation might be fine. Try to run the <a href="samples/samples.cfm">samples</a>. If it still
			doesn't work, <a href="http://groups.google.com/group/mxunit/">drop us a note</a>. We'll make sure you can get set up!
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
			If the error is from not having write permissions most of the framework
			should still function. Some features will not function, such as
			making private functions public for testing.
		</p>

		<p>
			Also, make sure you or CFML engine has write access to this directory
			in order to run this installation test.
		</p>
	</cfcatch>
</cftry>

<cfinclude template="resources/theme/footer.cfm" />
