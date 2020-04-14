// return page home.php
function home() {
    parent.document.all.bodyFrame.src = "home.php";
    //window.location="home.php";
}

function gotoPage(url) {
    console.log(url)
    // $("#content_main" ).html("<div>Loadding . . .</div>");
    // $("#content_main" ).load( url );
    //parent.document.all.bodyFrame.src = url;
   // $("#main_frame").attr("src",url)
    //window.location=url;
}


function gotoPageOnTop(url) {
    eval(top.location = url);
}

function NewOpen(url) {

    window.open(url, '_self');
}
function NewWindowOpen(url) {

    window.open(url, '_blank');
}

String.prototype.trim = function () {
    a = this.replace(/^\s+/, '');
    return a.replace(/\s+$/, '');
};

function Left(str, n) {
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else
        return String(str).substring(0, n);
}
function Right(str, n) {
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else {
        var iLen = String(str).length;
        return String(str).substring(iLen, iLen - n);
    }
}

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
        }
    }
};

// $(function(){
//     var page = getUrlParameter('page');
//     if(page !==""){
//         $("#content_main" ).load(page);
//     }
// });
