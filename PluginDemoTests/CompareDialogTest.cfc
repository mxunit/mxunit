<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">

	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">

	</cffunction>

	<cffunction name="simpleCompareDifferences">
		<cfset assertEquals("aaaaaaa b aaaaaa","aaaaaaa d aaaaaa")>
	</cffunction>

	<cffunction name="queryCompareDifferences">
		<cfset var queries = makeQueries()>
		<cfset assertQueryEquals(queries.one, queries.two)>
	</cffunction>

	<cffunction name="queryMismatchingColumns">
   	 	<cfset var queries = makeQueries()>
		<cfset assertQueryEquals(queries.one, queries.three)>
    </cffunction>

	<cffunction name="structCompareDifferences">
		<cfset var s = makeStructures()>
		<cfset assertStructEquals(s.one, s.two)>
	</cffunction>

	<cffunction name="arrayCompareDifferences">
		<cfset var a1 = [1,2,3,4,5,"a","b","c"]>
		<cfset var a2 = [1,2,3,4,6,"a","b","c","d","e","f"]>
		<cfset debug("Check debug output!")>
		<cfset assertEquals( a1, a2 )>
	</cffunction>

	<cffunction name="arrayCompareDifferences2">
		<cfset var a1 = [1,2,3,4,6,"a","b","c","d","e","f"]>
		<cfset var a2 = [1,2,3,4,5,"a","b","c"]>
		<cfset debug("Check debug output!")>
		<cfset assertEquals( a1, a2 )>
	</cffunction>

	<cffunction name="arrayCompareDifferencesComplex">
		<cfset var s = makeStructures()>
		<cfset var a1 = [1,2,3,4,6,"a","b","c", s.one, "d"]>
		<cfset var a2 = [1,2,3,4,5,"a","b","c", s.two, "e"]>
		<cfset debug("Check debug output!")>
		<cfset assertEquals( a1, a2 )>
	</cffunction>


	<cffunction name="makeQueries" access="private">
			<cfset var q = "">
			<cfset var q2 = "">
			<cfset var q3 = "">
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
			<cf_querysim>
			q3
			on3,two,three,four,five
			1|2|3.1|4
			11|22|33|4.4
			</cf_querysim>
			</cfoutput>
			<cfset s.one = q>
			<cfset s.two = q2>
			<cfset s.three = q3>
			<cfreturn s>
	</cffunction>

	<cffunction name="makeStructures" access="private">
		<cfset var s = StructNew()>
		<cfset var s2 = StructNew()>
		<cfset var combo = StructNew()>
		<cfset s.nested = StructNew()>
		<cfset s.nested.someValue = 5>
		<cfset s.one = "one">
		<cfset s.two = StructNew()>
		<cfset s2 = duplicate(s)>
		<cfset s2.one = "ona">
		<cfset s2.nested.someValue = 50000>
		<cfset combo.one = s>
		<cfset combo.two = s2>
		<cfset s2.KeyNotInS1 = "hi mom!">
		<cfset s.KeyNotInS2 = "hi dad!">


		<cfreturn combo>
	</cffunction>



</cfcomponent>