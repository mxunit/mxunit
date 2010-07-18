<cfcomponent hint="" output="false">
	<cffunction name="sendNotifications" output="false" access="public" returntype="void" hint="sends notifications about the results of file system cleanup">
		<cfargument name="body" type="string" required="true">
		<cfargument name="subject" type="string" required="true">
		<cfargument name="sender" type="string" required="true">
		<cfargument name="recipients" type="string" required="true"/>
		<!--- <cfmail from="#arguments.sender#" to="#arguments.recipients#" subject="#arguments.subject#" type="html">
		#arguments.body#
		</cfmail> --->
	</cffunction>
</cfcomponent>