<cfcomponent hint="Core class for ColdDoc documentation generation framework" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ColdDoc" output="false">
	<cfscript>
		variables.instance = {};

		return this;
	</cfscript>
</cffunction>

<cffunction name="generate" hint="generates the documentation" access="public" returntype="void" output="false">
	<cfargument name="inputSource" hint="either, the string directory source, OR an array of structs containing inputDir and inputMapping key" type="any" required="yes">
	<cfargument name="inputMapping" hint="the base mapping for the folder. Only required if the inputSource is a string." type="string" required="false" default="">
	<cfscript>
		var qMetaData = 0;
		var source = 0;

		if(NOT hasStrategy())
		{
			throwException("colddoc.StrategyNotSetException", "No Template Strategy has been set.",
							"Create a Template Strategy, and set it with setStrategy() before calling generate()");
		}

		if(isSimpleValue(arguments.inputSource))
		{
			source = [{ inputDir=arguments.inputSource, inputMapping=arguments.inputMapping }];
		}
		else
		{
			source = arguments.inputSource;
		}

		qMetaData = buildMetaDataCollection(source);

		getStrategy().run(qMetaData);
	</cfscript>
</cffunction>

<cffunction name="getStrategy" hint="Returns the current document templating strategy that is being userd" access="public" returntype="any" output="false"
			colddoc:generic="colddoc.strategy.AbstractTemplateStrategy">
	<cfreturn instance.strategy />
</cffunction>

<cffunction name="setStrategy" hint="Set the document templating strategy that is going to be used" access="public" returntype="void" output="false">
	<cfargument name="strategy" hint="The strategy object that is called to generate the doc. Usually extends colddoc.strategy.AbstractTemplateStrategy."
				type="any" required="true" colddoc:generic="colddoc.strategy.AbstractTemplateStrategy">
	<cfset instance.strategy = arguments.strategy />
</cffunction>

<cffunction name="hasStrategy" hint="whether this object has a strategy" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "strategy") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildMetaDataCollection" hint="builds the searchable meta data collection" access="private" returntype="query" output="false">
	<cfargument name="inputSource" hint="an array of structs containing inputDir and inputMapping" type="array" required="yes"> <!--- of struct --->

	<cfscript>
		var qFile = 0;
		var qMetaData = QueryNew("package,name,extends,metadata");
		var cfcPath = 0;
		var packagePath = 0;
		var cfcName = 0;
		var meta = 0;
		var i = 0;
	</cfscript>

    <cfloop index="i" from="1" to="#ArrayLen(arguments.inputSource)#">

        <cfdirectory action="list" directory="#arguments.inputSource[i].inputDir#" recurse="true" name="qFiles" filter="*.cfc">

        <cfloop query="qFiles">
            <cfscript>
                currentPath = replace(directory, arguments.inputSource[i].inputDir, "");
                currentPath = reReplace(currentPath, "[/\\]", "");
                currentPath = reReplace(currentPath, "[/\\]", ".", "all");

                if(len(currentPath))
                {
                    packagePath = ListAppend(arguments.inputSource[i].inputMapping, currentPath, ".");
                }
                else
                {
                    packagePath = arguments.inputSource[i].inputMapping;
                }

                cfcName = ListGetAt(name, 1, ".");

				try
				{
	                if (Len(packagePath)) {
	                    meta = getComponentMetaData(packagePath & "." & cfcName);
	                }
	                else {
	                    meta = getComponentMetaData(cfcName);
	                }

					QueryAddRow(qMetaData);
	                QuerySetCell(qMetaData, "package", packagePath);
	                QuerySetCell(qMetaData, "name", cfcName);
	                QuerySetCell(qMetaData, "metadata", meta);

	                //so we cane easily query direct desendents
	                if(StructKeyExists(meta, "extends"))
	                {
	                    QuerySetCell(qMetaData, "extends", meta.extends.name);
	                }
	                else
	                {
	                    QuerySetCell(qMetaData, "name", "-");
	                }

				}
				catch(Any exc)
				{
					warnError(packagePath & "." & cfcName, exc);
				}

            </cfscript>
        </cfloop>

	</cfloop>

	<cfreturn qMetaData />
</cffunction>

<cffunction name="warnError" hint="Warn the user that there was an error through cftrace" access="private" returntype="void" output="false">
	<cfargument name="cfcName" hint="the name of the cfc" type="string" required="Yes">
	<cfargument name="error" hint="the error struct" type="any" required="Yes">
	<cfset var dump = 0 />
	<!---<cfsavecontent variable="dump">
		<cfdump var="#arguments.error#" >
	</cfsavecontent>--->
	<cftrace category="ColdDoc" inline="true" type="Warning" text="Warning, the following script has errors: #arguments.cfcName#, #toString(arguments.error)#">
</cffunction>

<cffunction name="_trace">
	<cfargument name="s">
	<cfset var g = "">
	<cfsetting showdebugoutput="true">
	<cfsavecontent variable="g">
		<cfdump var="#arguments.s#">
	</cfsavecontent>
	<cftrace text="#g#">
</cffunction>

<cffunction name="_dump">
	<cfargument name="s">
	<cfargument name="abort" default="true">
	<cfset var g = "">
		<cfdump var="#arguments.s#">
		<cfif arguments.abort>
		<cfabort>
		</cfif>
</cffunction>

<cffunction name="throwException" access="private" hint="Throws an Exception" output="false">
	<cfargument name="type" hint="The type of exception" type="string" required="Yes">
	<cfargument name="message" hint="The message to accompany the exception" type="string" required="Yes">
	<cfargument name="detail" type="string" hint="The detail message for the exception" required="No" default="">
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
</cffunction>


</cfcomponent>