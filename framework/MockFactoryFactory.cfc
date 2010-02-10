<cfcomponent displayname="MockFactoryFactory" output="false">

	<cffunction name="MockFactoryFactory">
		<cfargument name="frameworkName" required="false" default="" />
		<cfset var utils = createObject("component","ComponentUtils") />
		<cfset variables.mockFactoryInfo = utils.getMockFactoryInfo(arguments.frameworkName) />
		<cfset variables.Factory = createObject("component",variables.mockFactoryInfo.factoryPath) />
		<cfif Len(mockFactoryInfo.constructorName)>
			<cfif StructCount(mockFactoryInfo.constructorArgs)>
				<cfinvoke component="#variables.Factory#" method="#variables.mockFactoryInfo.constructorName#" argumentcollection="#variables.mockFactoryInfo.constructorArgs#" />
			<cfelse>
				<cfinvoke component="#variables.Factory#" method="#variables.mockFactoryInfo.constructorName#" />
			</cfif>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cfscript>
		
		function getFactory() {
			return variables.Factory;
		}
		
		function getConfig(name) {
			return variables.mockFactoryInfo[name];
		}
	
	</cfscript>	

</cfcomponent>