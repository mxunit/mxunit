<cfcomponent extends="ParentWithPrivateMethods">
	
	
	<cffunction name="aPrivateMethod" access="private" returntype="string">
		<cfargument name="arg1" type="string" required="true">
		<cfargument name="arg2" type="string" required="true">
		<cfargument name="sep" type="string" required="false" default="_">
		<cfreturn arg1 & sep & arg2>
	</cffunction>
	
	<cffunction name="privateAddition" output="false" access="private" returntype="any" hint="">    
    	<cfargument name="val1" type="numeric" required="true">
    	<cfargument name="val2" type="numeric" required="true">
		<cfreturn val1 + val2>
    </cffunction>
    
	<cffunction name="privateStructAndArrayArgs" output="false" access="private" returntype="any" hint="">    
    	<cfargument name="val1" type="struct" required="false" default="#structNew()#"/>
    	<cfargument name="val2" type="array" required="true" default="#arrayNew(1)#"/>
		
		<cfset val1["array"] = val2>
		<cfreturn val1>
    </cffunction>

	<cffunction name="aNoArgPrivateMethod" access="private" returntype="string">
		<cfreturn "boo">
	</cffunction>

	<cffunction name="aPrivateMethodNoRT" access="private">
		<cfset var purpose = "no return type specified">
		<cfreturn purpose>
	</cffunction>

	<cffunction name="aPrivateMethodReturnArray" access="private">
		<cfreturn ArrayNew(1)>
	</cffunction>

	<cffunction name="aPrivateMethodReturnArray2" returntype="array" access="private">
		<cfreturn ArrayNew(1)>
	</cffunction>
	
	<cffunction name="aPrivateMethodVariedArguments" returntype="struct" access="private" output="false" hint="I return a struct matching arguments passed and/or defined by default attribute.">
		<cfargument name="arg1" type="string" required="true">
		<cfargument name="arg2" type="string" required="false" default="arg2_val">
		<cfargument name="arg3" type="string" required="false">
		
		<cfset var args = structNew()>
		<cfset var key = "">
		
		<cfloop collection="#arguments#" item="key">
			<cfif structKeyExists(arguments, key)><!--- all cfargument tags have a struct key in arguments, even when not passed and no default --->
				<cfset args[key] = arguments[key]>
			</cfif>
		</cfloop>
		
		<cfreturn args>
	</cffunction>

	<!--- this will run as constructor code --->
	<cfset this.x = 1>
	<cffunction name="aPrivateVoid" access="private" returntype="void">
		<cfset this.x = 5>
	</cffunction>



</cfcomponent>