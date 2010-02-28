<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="setUp" output="false" access="public" returntype="void" hint="">
		
	</cffunction>
	
	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">
		
	</cffunction>
	
	<cffunction name="testError" output="false" access="public" returntype="void" hint="">
		<cfthrow message="This error is intentional">
	</cffunction>	

</cfcomponent>