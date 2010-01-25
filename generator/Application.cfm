<cfapplication 
	name               = "MXUnitTestGenerator" 
	applicationtimeout = "#createTimespan(0,2,0,0)#"
	clientmanagement   = "false" 
	sessionmanagement  = "false">

<!--- Ok, maybe we add a few udfs here --->
<cfinclude template="lib_cfscript.cfm">
<cffunction name="argType">
	<cfargument name="column" required="true" type="string" />
	<cfargument name="data_type" required="true" type="string" />
	<cfset var arg = "" />
	<cfswitch expression="#arguments.data_type#">
		<cfcase value="varchar,char">
			<cfset arg = '		~cfargument name="#arguments.column#" required="false" default="" type="string" />#chr(13)##chr(10)#'>
		</cfcase>
		<cfcase value="int,tinyint">
			<cfset arg = '		~cfargument name="#arguments.column#" required="false" default="0" type="numeric" />#chr(13)##chr(10)#'>
		</cfcase>
		<cfcase value="bit">
			<cfset arg = '		~cfargument name="#arguments.column#" required="false" default="false" type="boolean" />#chr(13)##chr(10)#'>
		</cfcase>
		<cfcase value="datetime">
			<cfset arg = '		~cfargument name="#arguments.column#" required="false" default="" type="date" />#chr(13)##chr(10)#'>
		</cfcase>
	</cfswitch>
	<cfreturn arg />
</cffunction>

<cffunction name="queryParamType">
	<cfargument name="column" required="true" type="string" />
	<cfargument name="data_type" required="true" type="string" />
	<cfargument name="is_nullable" required="true" type="string" />
	<cfargument name="maxLength" required="true" type="string" />
	<cfargument name="scale" required="true" type="string" />
	<cfset var qparam = "" />
	<cfswitch expression="#arguments.data_type#">
		<cfcase value="varchar,char,ntext">
			<cfif arguments.is_nullable is 'yes'>
				<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" maxLength="#arguments.maxLength#" null="##NOT len(trim(get#column#()))##" />'>
			<cfelse>
				<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" maxLength="#arguments.maxLength#" />'>
			</cfif>
		</cfcase>
		<cfcase value="int">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_integer" />'>
		</cfcase>
		<cfcase value="tinyint,smallint">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" />'>
		</cfcase>
		<cfcase value="bit">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" />'>
		</cfcase>
		<cfcase value="datetime">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_date" />'>
		</cfcase>
		<cfcase value="float,real">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" />'>
		</cfcase>
		<cfcase value="numeric,decimal">
			<cfset qparam = '~cfqueryparam value="##arguments.obj.get#arguments.column#()##" cfsqltype="cf_sql_#arguments.data_type#" scale="#arguments.scale#" />'>
		</cfcase>
	</cfswitch>
	<cfreturn qparam />
</cffunction>

<cffunction name="cfDataType" output="false">
	<cfargument name="sqlDatatype" required="true" type="string" />
	<cfswitch expression="#arguments.sqlDatatype#">
		<cfcase value="varchar,char,nvarchar,nchar,text,ntext">
			<cfreturn "string" />
		</cfcase>
		<cfcase value="int,tinyint,real,float">
			<cfreturn "numeric" />
		</cfcase>
		<cfcase value="bit">
			<cfreturn "boolean" />
		</cfcase>
		<cfcase value="datetime">
			<cfreturn "date" />
		</cfcase>
		<cfcase value="image">
			<cfreturn "binary" />
		</cfcase>

	</cfswitch>
</cffunction>

<!--- Set profile path --->
<cffunction name="getProfilePath" output="false">
	<cfif isDefined("application._profilePath")>
		<cfreturn application._profilePath />
	<cfelse>
		<cfset application._profilePath = getDirectoryFromPath(getCurrentTemplatePath()) & 'setup.ini'/>
		<cfreturn getProfilePath()/>
	</cfif>
</cffunction>

