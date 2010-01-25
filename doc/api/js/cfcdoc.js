var liveDocsBaseUrl = "http://http://www.cfquickdocs.com/";

window.addEvent('domready', function(){
	var slides = new Array();
	$$('.codeTrigger').each(function(trigger, pos) {
		slides.push(new Fx.Slide(trigger.getNext()));
		slides[pos].hide();
		trigger.addEvent('click', function(e) {
			slides[pos].toggle();
			if (slides[pos].open){
				this.childNodes[1].nodeValue = " Show code ";
				this.childNodes[0].setAttribute("src","../images/open.jpg");
			} else {
				this.childNodes[1].nodeValue = " Hide code ";
				this.childNodes[0].setAttribute("src","../images/close.jpg");
			}
			
		});
	});
});


window.addEvent('domready', function(){
	var notImplementedTip = new Tips($$('.notImplemented'), {
		className: 'notImplementedTip'
		});
});

function findObject(objId) {
	if (document.getElementById)
		return document.getElementById(objId);

	if (document.all)
		return document.all[objId];
}



function showTitle(title) {
		top.document.title = title;
}

function findTitleTableObject(id)
{
		return parent.titlebar.document.getElementById(id);
}

function titleBar_setSubTitle(title)
{
	if (parent.titlebar)
		findTitleTableObject("subTitle").childNodes.item(0).data = title;
}

