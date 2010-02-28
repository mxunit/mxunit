<div class="detailSectionHeader">Welcome to CFCDoc Revamped</div>
<div>
<strong>Version: <cfoutput>#cfcDocversion#</cfoutput></strong> 
</div>
<br />
<strong>About</strong><br />
<p>
This version of CFCDOC ('CFCDOC Revamped') was modified and improved by Jax. It is a tool that provides 
code insight , similar to the way Javadoc does.  	
The CFC documenter was originally written by Stephen Milligan Aka Spike (spike@spike.org.uk) and Barney Boisvert a few years back.
<br>  
This version is again released under the terms of the Common Public License. 
Updates and more info will from now on be available at <a href="http://cfcdoc.riaforge.org" target="_blank">http://cfcdoc.riaforge.org</a>. 
It should run on any platform that supports CFMX 6.1 (and higher) including Windows, Linux and OS X.
</p>
<p>
<strong>Notes:</strong><br>	
<ul>
<li>If you have any questions, features requests, or have a bug to report, please do so at <a href="http://cfcdoc.riaforge.org" target="_blank">http://cfcdoc.riaforge.org</a> as well.<br>It is the only way to contact me.</li>
<li>CFCDoc makes uses of the Mootools framework (www.mootools.net)</li>
<li>The icons used in this version are obtained from www.famfamfam.com </li>
</ul>
</p>
<br>
<strong>Release History</strong> <br />
<small>* = changed&nbsp;&nbsp;- = removed&nbsp;&nbsp;+ = added</small>
<p>
<i>August 9,2007 - Version 0.42</i><br>
Requested enhancements implemented:<br />
+ Added lazyload option. Cfcdoc might time out when it tries to separate <br />
&nbsp;&nbsp;interfaces from components in case there are huge amounts of cfc's in a single package.<br />
&nbsp;&nbsp;Setting &lt;lazyLoad&gt; to 'true' in config.xml should improve things.<br /> 
+ Added an option to only load specific roots for specific servers cfcdoc is  run on<br />
&nbsp;&nbsp;See config.xml for an example.  
<br><br>	
<i>August 8,2007 - Version 0.41</i><br>
+ Added an option to start CFCdoc on a specific page.<br />
&nbsp;&nbsp;Add url parameters as following:<br />
&nbsp;&nbsp;startRoot = &lt;name_of_root&gt;><br />
&nbsp;&nbsp;startPackage = &lt;name_of_package&gt;<br />
&nbsp;&nbsp;startComponent =  &lt;name_of_component&gt;<br />	
* If CFCdoc can't find a components supercomponent, it will now<br /> 
&nbsp;&nbsp; show the name in the inheritance tree, but it is no longer a link.	
<br><br>	
<i>August 3,2007 - Version 0.4</i><br>
+ CFCdoc now supports &lt;cfinterface&gt; (CF 8.x)<br />
+ changed look and feel to (more or less) match Adobe's 'Asdoc' utility<br />
+ Use of mootools (v1.1) for showing/hiding code blocks<br />
* reorganised code, cleaned up and created a better tree<br />
* a whole ot of things, mostly layout  :-) <br />

</p>	
<strong>How it works</strong>
<br />
It recursively reads a directory structure looking for CFC files. When it finds one, it stores the path info relative to the root directory in the application scope, and continues looking.
<br />
Once it has parsed the directory tree, it displays a list of all the directories in the top left frame as packages, and all the components in the bottom left frame.
<br />
When you click on a component name it goes off, finds that file and parses out it's contents to display as documentation similar to javadoc.
<br />
<br />


<strong>Configuration</strong>
<p>
To add new root paths to the list, you'll need to <strong>edit <a href="../config/config.xml">config.xml</a></strong> which you can find in the config directory.
</p>
<p>
There are pretty obvious comments in there telling you what to do.
</p>
<p>
File names are cached in the application scope, so if you're running multiple versions you'll probably want to change the application name in application.cfm
</p>
<p>
You can refresh the cached list at any time by adding ?refresh to the URL.
Or click <a href="../index.cfm?refresh" target="top">here</a>.
</p>
<br />
<br />
