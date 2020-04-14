<%@ Language=VBScript %>
<%OPTION EXPLICIT%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%

	dim srcPage
	if Trim(Request("page"))="" then
		Session("uid")=0
		Session("uname")=""
		Session("utype")=""
		Session("cutallid")=0
	end if
		if Trim(Session("uid"))="" then
		response.redirect "signin.asp"
		end if
'showstr "type "&Session("utype")
%>
<HTML>
<HEAD>

<script type="text/javascript" src="include/switch.js"></script>
<script language=javascript>
function ClickRefresh(url,rf_rate) {
	if (document.all.cmdrefresh.value=="Refresh ?????????") {
		document.all.cmdrefresh.value="???? Refresh ?????????";
		rf_rate="0";
	} else {
		document.all.cmdrefresh.value="Refresh ?????????";
		rf_rate="1";
	}
	url = url + '?stoprefresh='+rf_rate;
	parent.document.all.bodyFrame.src = url;
}
	function showsendto(gosuu){
		window.open("dealer_check_suu.asp?gosuu="+gosuu, "_blank","top=200,left=200,height=150,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}


</script>
<script type="text/javascript">
//close window
//function window.onload()
//{
//    window.attachEvent("onbeforeunload", Close);
//}

function Close()
{
return 'Are you sure you want to close my lovely window?'
}
function closer() 
{
	//<%
	//if Trim(Request("page"))<>"" and Trim(Request("page"))<>"signin.asp" Then
	//	'response.write " alert(' index This window is about to close.' ); " 
	//	response.write  "window.open('logout.asp');"
	//end if 
	//%>
}


</script>

<LINK href="include/code.css" type=text/css rel=stylesheet>
<LINK href="include/stylesmenu.css" type=text/css rel="stylesheet">
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="JavaScript" src="include/js_function.js"></script>
<TITLE>Welcome Cut Lotto</TITLE>

</HEAD>

 <BODY topmargin=0 leftmargin=0 scroll=no onbeforeunload="closer();"> 


<TABLE width=100% height=100% border=0  >
<%
if Trim(Request("page"))<>"" and Trim(Request("page"))<>"signin.asp" Then
%>


<TR height="30px" align="center" >
	<TD class="style1" colspan="2" height="20px">
        <div style="overflow=hidden;">
        <IFRAME marginWidth=0 src="mess_alert.asp" frameBorder=1  
        height="100%" name="mess" style="width: 100%; float: right;">
        </IFRAME>
        </div>
    </TD>
</TR>

<TR height="30px" align="center" >
	<TD class="style1" colspan="2" bgcolor="#c0c0c0" height="20px">
        <div style="overflow=hidden;">
        <IFRAME marginWidth=0 src="mess_alert_dealer.asp" frameBorder="1" 
        width="100%" height="100%" name="mess" style="width: 100%; float: right;">
        </IFRAME>
        </div>
    </TD>
</TR>
<%
End if
%>
			
<%	
	if Trim(Request("page"))<>"" and Trim(Request("page"))<>"signin.asp" then
%>

<TR height="100%" >
	<TD  width="13%" valign="top" align ="right" >
		<%Call ShowMenu2(Session("utype"))%>
	</TD>
<%	
end if
%>
<!--</TD>
<TR height="100%" >-->

	<TD width="87%" >
<%

		if Trim(Request("page"))="" then
			srcPage="signin.asp"
		else
			srcPage=Request("page")
		end if
%>		

		<IFRAME marginWidth=0 marginHeight=0 src="<%=srcPage%>" frameBorder=no width="100%" height="100%" name="bodyFrame" align="left">
		</IFRAME>
	</TD>
</TR>
</TABLE>

</BODY>
</HTML>
<%
	if Trim(Request("page"))<>"" and Trim(Request("page"))<>"signin.asp" Then
%>

<%
	End if
%>