var theDialog = document.createElement("IFRAME");

theDialog.className = "dialogBox";

theDialog.scrolling = "no";

theDialog.id = "_DIALOGBOX";



function openDialog(_url, x, y, w, h) {


  if (!document.all["_DIALOGBOX"])

	document.body.appendChild(theDialog);

  document.all["_DIALOGBOX"].style.visibility = "visible";

  theDialog.src = _url;

  if (x != null)

    theDialog.style.left = x;

  if (y != null)

    theDialog.style.top = y;

  if (w != null)

    theDialog.width = w;

  else

    theDialog.width = 100;

  if (h != null)

    theDialog.height = h;

  else

    theDialog.height = 100; 
 

}



function closeDialog (i) {

  if (i)

    location.reload();

  if (document.all["_DIALOGBOX"]) {

    document.all["_DIALOGBOX"].style.visibility = "hidden";

    document.all["_DIALOGBOX"].src = "blank.htm";

    theDialog.removeNode (true);

  }

}  