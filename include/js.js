
//Contents for menu 1 : �Ԩ���� -> user
var menu1=new Array()
menu1[0]='<span id=memusub1 onMouseover="mouseon(this)" onMouseout="mouseout(this)" onclick=goFrame("add_activity.htm")>&nbsp;&nbsp;<img src="images/type_mu.gif" align="absmiddle"> �����Ԩ����</span><br>'
menu1[1]='<span id=memusub2 onMouseover="mouseon(this)" onMouseout="mouseout(this)" onclick=goFrame("manage_activity.htm")>&nbsp;&nbsp;<img src="images/type_mu.gif" align="absmiddle"> �Ѵ��áԨ����</span><br>'
menu1[2]='<span id=memusub2 onMouseover="mouseon(this)" onMouseout="mouseout(this)" onclick=goFrame("show_main_activity.htm")>&nbsp;&nbsp;<img src="images/type_mu.gif" align="absmiddle"> �ʴ��Ԩ����</span><br>'


function changeStyle(obj, cla) {
	obj.className = cla
}

function goPage(url) {
	window.open(url, 'mainFrame');
}

function goFrame(url) {
	window.open(url, 'displayFrame');
}