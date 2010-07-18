<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="simpleCompareDifferences">
		<cfset assertEquals("aaaaaaa b aaaaaa","aaaaaaa d aaaaaa")>
	</cffunction>
	
	<cffunction name="queryCompareDifferences">
		<cfset var s = makeQueries()>
		<cfset assertEquals(s.one,s.two)>
	</cffunction>
	
	<cffunction name="structCompareDifferences">
		<cfset var s = makeStructures()>
		<cfset assertEquals(s.one,s.two)>
	</cffunction>
	
	
	<cffunction name="makeQueries" access="private">
			<cfset var q = "">
			<cfset var q2 = "">
			<cfset var s = structnew()>
			<cfoutput>
			<cf_querysim>
			q
			one,two,three,four
			1|2|3|4	
			11|22|33|44
			</cf_querysim>
			<cf_querysim>
			q2
			one,two,three,four
			1|2|3.1|4	
			11|22|33|4.4
			</cf_querysim>
			</cfoutput>
			<cfset s.one = q>
			<cfset s.two = q2>
			<cfreturn s>
	</cffunction>
	
	<cffunction name="makeStructures" access="private">
		<cfset var s = StructNew()>
		<cfset var s2 = StructNew()>
		<cfset var combo = StructNew()>
		<cfset s.one = "one">
		<cfset s.two = StructNew()>
		<cfset s2 = duplicate(s)>
		<cfset s2.one = "ona">
		<cfset combo.one = s>
		<cfset combo.two = s2>
		<cfreturn combo>
	</cffunction>
	
	

</cfcomponent>