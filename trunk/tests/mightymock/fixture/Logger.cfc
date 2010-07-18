<cfcomponent displayname="Logger" output="true">
	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfargument name="name" type="string" required="true" hint="Logger Name" />
		<cfargument name="level" type="string" required="false" default="0" hint="The log level of this logger" />
		<cfargument name="ESAPI" required="true" hint="Pass in the ESAPI Service Locator" />

		<cfset variables.ESAPI = arguments.ESAPI />
		<cfset variables.name = arguments.name />

		<cfset variables.levels = StructNew() />
		<cfset variables.levels.all = -1 />
		<cfset variables.levels.trace = 0 />
		<cfset variables.levels.debug = 1 />
		<cfset variables.levels.info = 2 />
		<cfset variables.levels.warn = 3 />
		<cfset variables.levels.error = 4 />
		<cfset variables.levels.fatal = 5 />
		<cfset variables.levels.off = 6 />
		<cfset variables.levelVal = "" />

		<cfset setLevel(arguments.level) />

		<cfreturn this />
	</cffunction>

	<cffunction name="getLevel" access="public" returntype="string" output="false">
		<cfreturn lcase(variables.level) />
	</cffunction>

	<cffunction name="setLevel" access="public" returntype="void" output="false">
		<cfargument name="level" type="String" required="false" default="info" />

		<cftry>
			<cfset variables.levelVal = StructFind(variables.levels, arguments.level) />
			<cfset variables.level = arguments.level />
			<cfcatch>
				<cfset createObject("component", "org.owasp.esapi.errors.LoggerException").init("Invalid Log Level") />
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="getLevelVal" access="private" returntype="numeric" output="false">
		<cfreturn variables.levelVal />
	</cffunction>

	<cffunction name="trace" access="public" returntype="any" output="true">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isTraceEnabled()>
			<cfset logEntry("TRACE", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="debug" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isDebugEnabled()>
			<cfset logEntry("DEBUG", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="info" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isInfoEnabled()>
			<cfset logEntry("INFO", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="warn" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isEnabledFor("warn")>
			<cfset logEntry("WARN", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="error" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isEnabledFor("error")>
			<cfset logEntry("ERROR", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="fatal" access="public" returntype="void" output="false">
		<cfargument name="message" type="string" required="true" hint="The message to log">

		<cfif isEnabledFor("fatal")>
			<cfset logEntry("FATAL", arguments.message) />
		</cfif>
	</cffunction>

	<cffunction name="isTraceEnabled" access="public" returntype="boolean" output="false">
		<cfif getLevelVal() LTE variables.levels.trace>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="isDebugEnabled" access="public" returntype="boolean" output="false">
		<cfif getLevelVal() LTE variables.levels.debug>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="isInfoEnabled" access="public" returntype="boolean" output="false">
		<cfif getLevelVal() LTE variables.levels.info>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="isEnabledFor" access="public" returntype="boolean" output="false">
		<cfargument name="level" type="String" required="true" hint="" />

		<cftry>
			<cfif getLevelVal() LTE StructFind(variables.levels, arguments.level)>
				<cfreturn true />
			<cfelse>
				<cfreturn false />
			</cfif>

			<cfcatch><cfreturn false /></cfcatch>
		</cftry>
	</cffunction>

   <cffunction name="logTest" hint="testing sanity check ... that's it.">
    <cfargument name="type">
    <cfargument name="message">
    <cfset var userSessionLoggingID = variables.ESAPI.sessionFacade().getProperty("loggingID") />
    <cfreturn userSessionLoggingID />
   </cffunction>

	<cffunction name="logEntry" access="public" returntype="any" output="true">
		<cfargument name="type" type="String" required="true" hint="The log type that was used (i.e. INFO, DEBUG)">
		<cfargument name="message" type="string" required="false" default="No Message Passed" />

		<!--- local vars --->
		<cfset var logMessage = "" />
		<cfset var clean = "" />

		<!--- Get the sessions unique logging ID (We don't use the sessionID because it can be used for session hijaking) --->
		<cfset var userSessionLoggingID = variables.ESAPI.sessionFacade().getProperty("loggingID") />

		<!--- Get the current User   --->
		<cfset var user = variables.ESAPI.authenticator().getCurrentUser() />
   

		<!--- Set a local variable to hold ColdFusions non-standard log levels --->
		<cfset  var cfType = "" />


    <!--- Determine which non-standard CF Log Level to use --->
		<cfswitch expression="#arguments.type#">
			<cfcase value="fatal"><cfset cfType = "fatal"></cfcase>
			<cfcase value="error"><cfset cfType = "error"></cfcase>
			<cfcase value="warn"><cfset cfType = "warning"></cfcase>
			<cfdefaultcase><cfset cfType="information"></cfdefaultcase>
		</cfswitch>


  

		<!--- Clean CRLF from the message --->
		<cfset logMessage = replace(arguments.message,"\n", "_", "all") />
		<cfset logMessage = replace(logMessage, "\r", "_", "all") />



    <!--- If HTMLEncoding Log entries is required --->
    <cfif variables.ESAPI.securityConfiguration().getProperty("LogEncodingRequired")>
      <cfset clean = variables.ESAPI.encoder().encodeForHTML(logMessage) />
      <cfif Compare(logMessage, clean)>
        <cfset logMessage = clean & " (Encoded)" />
      </cfif>
    </cfif>




		<!--- Make log entry --->
		<cflog type="warn"
			application="true"
			file="security"
			text="Level: #arguments.type# - Logger Name: #variables.name# - 
            Username:  #user.getUserName()# - Host: #user.getLastHostAddress()# -
            Session Logging ID: #userSessionLoggingID# - Message: logMessage" />

	</cffunction>
</cfcomponent>