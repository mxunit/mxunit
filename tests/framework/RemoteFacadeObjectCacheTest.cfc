<cfcomponent extends="mxunit.framework.TestCase">

	<cfset cache = "">

	<cffunction name="setup">
		<cfset variables.cache = createObject("component", "mxunit.framework.RemoteFacadeObjectCache")>
	</cffunction>


	<cffunction name="testStartTestRun">
		<cfset var new1 = "" />
		<cfset var new2 = "" />
		<cfset var final = "" />
		<cfset var initial = variables.cache.getSuitePoolCount()>
		<cfset new1 = variables.cache.startTestRun()>
		<cfset new2 = variables.cache.startTestRun()>
		<cfset final = variables.cache.getSuitePoolCount()>
		<cfset variables.cache.endTestRun(new1)>
		<cfset variables.cache.endTestRun(new2)>
		<cfset assertEquals(initial+2,final,"added 2, so suite should be 2 larger")>
	</cffunction>

	<cffunction name="testEndTestRun">
		<cfset var new1 = "" />
		<cfset var new2 = "" />
		<cfset var final = "" />
		<cfset var initial = variables.cache.getSuitePoolCount()>
		<cfset new1 = variables.cache.startTestRun()>
		<cfset new2 = variables.cache.startTestRun()>
		<cfset variables.cache.endTestRun(new1)>
		<cfset variables.cache.endTestRun(new2)>
		<cfset final = variables.cache.getSuitePoolCount()>
		<cfset assertEquals(initial,final,"added 2, then removed them, so suite should be same as when it started")>
	</cffunction>

	<cffunction name="testPurgeStaleTests">
		<cfset var purged = "" />
		<cfset var pool = "" />
		<!--- ensure everything that needs to go is gone--->
		<cfset variables.cache.purgeStaleTests()>
		<cfset pool = variables.cache.getSuitePool()>
		<cfset pool.blah1 = structnew()>
		<cfset pool.blah1.lastaccessed = dateAdd("n",-100,now())>
		<cfset pool.blah2 = structnew()>
		<cfset pool.blah2.lastaccessed = dateAdd("n",-100,now())>

		<cfset purged = variables.cache.purgeStaleTests()>

		<cfset assertEquals(2,purged,"")>
	</cffunction>

	<cffunction name="testPurgeSuitePool">
		<cfset var current = "" />
		<cfset current = variables.cache.purgeSuitePool()>
		<cfset assertEquals(0,current,"shouldn't be a pool no mo'")>
	</cffunction>

	<cffunction name="testGetObjectNotInCache">
		<cfset var path = "mxunit.PluginDemoTests.SingleMethodTest">
		<cfset var obj = variables.cache.getObject(path,"")>
		<cfset var md = getMetadata(obj)>
		<cfset assertEquals(path, md.name)>
		<cfset variables.cache.purgeSuitePool()>
	</cffunction>

	<cffunction name="testGetObjectWhenCachePurged">
		<cfset var path = "mxunit.PluginDemoTests.SingleMethodTest">
		<cfset var key = variables.cache.startTestRun()>
		<!--- we need getBaseTarget because by the time the test gets run, it'll possibly be wrapped in a decorator --->
		<cfset var obj = variables.cache.getObject(path, key).getBaseTarget()>
		<cfset var md = getMetadata(obj)>
		<cfset assertEquals(path, md.name)>

		<cfset variables.cache.purgeSuitePool()>

		<cfset obj = variables.cache.getObject(path, key).getBaseTarget()>
		<cfset md = getMetadata(obj)>
		<cfset assertEquals(path, md.name)>

		<cfset variables.cache.purgeSuitePool()>
	</cffunction>

</cfcomponent>