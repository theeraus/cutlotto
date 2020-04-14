	

function changeStyle(obj, cla) {
	obj.className = cla
}

function goPage(url) {
	window.open(url, '_self');
}

function divDisplay(obj) {
	obj.style.display = "block";
}
function mhHover(tbl, idx, cls)
{
	var t = document.getElementById(tbl);
	if (t == null) return;
	var d = t.getElementsByTagName("TD");
	if (d == null) return;
	if (d.length <= idx) return;
	d[idx].className = cls;
}