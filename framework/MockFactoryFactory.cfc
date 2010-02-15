<cfcomponent displayname="MockFactoryFactory" output="false">
	
	<cfset variables.componentUtils = createObject("component","ComponentUtils") />
	<cfset variables.Factory = 'mxunit.framework.mightymock.MightyMock' />
	
	<cffunction name="MockFactoryFactory">
		<cfargument name="frameworkName" required="false" default="" />
		<cfset variables.mockFactoryInfo = variables.componentUtils.getMockFactoryInfo(arguments.frameworkName) />
		<cfset setFactory(variables.mockFactoryInfo.factoryPath) />
		<cfif Len(variables.mockFactoryInfo.constructorName)>
			<cfif StructCount(variables.mockFactoryInfo.constructorArgs)>
				<cfinvoke component="#variables.Factory#" method="#variables.mockFactoryInfo.constructorName#" argumentcollection="#variables.mockFactoryInfo.constructorArgs#" />
			<cfelse>
				<cfinvoke component="#variables.Factory#" method="#variables.mockFactoryInfo.constructorName#" />
			</cfif>
		</cfif>
		<cfreturn this />
	</cffunction>

	<cfscript>
		//injectable for cleaner design and testing
		function setFactory( mockPath ){
		   variables.Factory = createObject("component", mockPath );
		}
		
		//more dependency injection
		function setComponentUtils(o){
		  variables.componentUtils = o;
		}
		
		function getFactory() {
			return variables.Factory;
		}
		
		function getConfig(name) {
			return variables.mockFactoryInfo[name];
		}
			
	</cfscript>	

</cfcomponent>