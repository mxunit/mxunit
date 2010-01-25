function toggle(frm)
{
	for ( ii=0 ; ii < frm.tableNameList.length ; ii++)
	{
		frm.tableNameList[ii].checked = frm.all.checked;
	}
}

function suggest(frm,target,delim)
{
	if (delim == "file")
	{
		target.value = frm.value + "/tests";
	} else {
		target.value = frm.value + ".tests";
	}
}
