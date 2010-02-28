<!--- These UDFs are just wrappers for some cf tags that have no cfscript equivalent --->

<cffunction name="cfparam">
	<cfargument name="name" required="true" type="string" >
	<cfargument name="default" required="false" type="any" >
	<cfparam name="#arguments.name#" default="#arguments.default#">
</cffunction>

<cffunction name="cfthrow" output="false" returnType="void" hint="CFML Throw wrapper">
	<cfargument name="type" type="string" required="false" default="Application" hint="Type for Exception">
	<cfargument name="message" type="string" required="false" default="" hint="Message for Exception">
	<cfargument name="detail" type="string" required="false" default="" hint="Detail for Exception">
	<cfargument name="errorCode" type="string" required="false" default="" hint="Error Code for Exception">
	<cfargument name="extendedInfo" type="string" required="false" default="" hint="Extended Info for Exception">
	<cfargument name="object" type="any" hint="Requires the value of the cfobject tag 'name' attribute. Throws a Java exception from a CFML tag.">

	<cfif not StructKeyExists(arguments,"object")>
		<cfthrow type="#type#" message="#message#" detail="#detail#" errorCode="#errorCode#" extendedInfo="#extendedInfo#">
	<cfelse>
		<cfthrow object="#arguments.object#">
	</cfif>
</cffunction>

<cffunction name="cfdump" output="true" returntype="void" hint="CFDump wrapper for cfscript">
	<cfargument name="var" required="true" type="any" >
	<cfargument name="expand" required="false" default="true" type="boolean" >
	<cfargument name="label" required="false" default="" type="string" >
	<cfargument name="top" required="false" type="numeric" default="9999" >
	<cfargument name="abort" required="false" default="false" type="boolean" >

	<cfdump var="#arguments.var#" expand="#arguments.expand#" label="#arguments.label#" >
	<cfif arguments.abort>
		<cfabort >
	</cfif>
</cffunction>


<!--- form helpers --->
<cffunction name="lorem" output="false" returntype="string" hint="returns blather.">
	<cfargument name="length" required="false" default="500" type="numeric" >
	<cfargument name="english" required="false" default="true" >
	<cfset var txt= "">
	<cfset var lenList= "">
	<cfset var textLen= "">
	<cfset var charCount= "">
	<cfset var retVal= "">
	<cfset var ii= "">
	<cfset var kk= "">

	<cfscript>
		txt = arrayNew(1);
		txt[1] = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
		txt[2] = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?";
		txt[3] = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
		txt[4] = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?";
		txt[5] = "On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. The wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.";
		lenList = "446,865,844,970,996";
		txtLen = listToArray(lenList);

		charCount = arguments.length;
		retVal = "";

		if (english)
		{
			while(charCount gt 0)
			{
				ii = int(randRange(4,5));
				if (charCount gt txtLen[ii])
				{
					retVal = retVal & txt[ii];
					charCount = charCount - txtLen[ii];

				} else {
					retVal = retVal & left(txt[ii],charCount);
					charCount = 0;
				}
			}
		} else {
			while(charCount gt 0)
			{
				kk = int(randRange(1,3));
				if (charCount gt txtLen[kk])
				{
					retVal = retVal & txt[kk];
					charCount = charCount - txtLen[kk];
				} else {
					retVal = retVal & left(txt[kk],charCount);
					charCount = 0;
				}
			}
		}

		return retVal;
	</cfscript>

</cffunction>

<cffunction name="checked">
	<cfargument name="v1" >
	<cfargument name="v2" >
	<cfset var attrib = "" >

	<cfif NOT structKeyExists(arguments,"v2")>
		<cfif IsBoolean(arguments.v1)>
			<cfif arguments.v1>
				<cfset attrib = 'checked="true"' >
			</cfif>
		<cfelse>
			<cfthrow message="The parameter passed to the checked udf was not boolean" >
		</cfif>
	<cfelse>
		<cfif arguments.v1 eq arguments.v2>
			<cfset attrib = 'checked="true"' >
		</cfif>
	</cfif>

	<cfreturn attrib >
</cffunction>

<cffunction name="selected">
	<cfargument name="v1" >
	<cfargument name="v2" >
	<cfset var attrib = "" >

	<cfif NOT structKeyExists(arguments,"v2")>
		<cfif IsBoolean(arguments.v1)>
			<cfif arguments.v1>
				<cfset attrib = 'selected="true"' >
			</cfif>
		<cfelse>
			<cfthrow message="The parameter passed to the selected udf was not boolean" >
		</cfif>
	<cfelse>
		<cfif arguments.v1 eq arguments.v2>
			<cfset attrib = 'selected="true"' >
		</cfif>
	</cfif>

	<cfreturn attrib >
</cffunction>

<cffunction name="disabled">
	<cfargument name="v1" >
	<cfargument name="v2" >
	<cfset var attrib = "" >

	<cfif NOT structKeyExists(arguments,"v2")>
		<cfif IsBoolean(arguments.v1)>
			<cfif arguments.v1>
				<cfset attrib = 'disabled="true"' >
			</cfif>
		<cfelse>
			<cfthrow message="The parameter passed to the DISABLED udf was not boolean" >
		</cfif>
	<cfelse>
		<cfif arguments.v1 eq arguments.v2>
			<cfset attrib = 'disabled="true"' >
		</cfif>
	</cfif>

	<cfreturn attrib >
</cffunction>