<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%'check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<script language="JavaScript">

	function clicksubmit(){
		if (document.FORM1.password1.value==''){
			alert('กรุณาป้อน รหัสผ่าน')
			document.FORM1.password1.focus();
			return false
		}
		document.FORM1.submit();
	}

	function senddealer(chk, gosuu){
		if (chk=="yes") {
			if (gosuu=="U") {
				opener.window.open("dealer_fight_up.asp?act=cal","bodyFrame");
			} else if (gosuu=="D") {
				opener.window.open("dealer_fight_down.asp?act=cal","bodyFrame");
			} else if (gosuu=="S") {
				opener.open_setvalue(<%=Session("uid")%>);
			}
			window.close();
		} else if (chk=="no") {
			alert("การ Log In ไม่ถูกต้อง ! กรุณาลองใหม่...");
		}
	}

function txtdealer_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.txtUserName.focus();
	}
}

function txtUserName_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.password1.focus();
	}
}

function password1_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		clicksubmit();
	}
}

</Script>
<%Response.Buffer = True%>
<%
	dim rs
	dim strSql
	dim strTitle
	dim strMsg 
	dim strGoto
	dim RndPw
	dim strPw
	dim chkOk
	dim buser
	dim bpass
	dim bdealer
	dim bplayer
	dim gosuu
	if Request("act")="log" then
		bpass=trim(Request("password1"))
		gosuu = Request("gosuu")
		chkOk = "no"
			Set rs = server.createobject("ADODB.Recordset")
			'strSql = "SELECT     sc_user.*	FROM         sc_user  " _
			'	& "Where user_id = " & Session("uid") & " and sum_password='"& bpass &"'  And sc_user.user_disable=0 "
			'rs.Open strSql,conn
			'if not rs.eof then
			'	chkOk = "yes"
			'end If
			chkOk = "yes"
			set rs = nothing
			Response.write "<script language=javascript>senddealer('" & chkOk & "', '" & gosuu & "');</script>"
	else
		gosuu = Request("gosuu")
		chkOk = ""
		if gosuu = "S" then
			chkOk=""
		else
			Set rs = server.createobject("ADODB.Recordset")
			'strSql = "SELECT     sc_user.*	FROM         sc_user  " _
			'	& "Where user_id = " & Session("uid") & " and sum_password='0'  And sc_user.user_disable=0 "
'showstr strSql
			'rs.Open strSql,conn
			'if not rs.eof then
			'	chkOk = "yes"
			'end if
		end if	
		chkOk = "yes"
		set rs = nothing
		if chkOk="yes" then
			Response.write "<script language=javascript>senddealer('" & chkOk & "', '" & gosuu & "');</script>"		
		end if
	end if
%>


<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<STYLE TYPE="text/css">
	<!--
    A:link {text-decoration: none;}  
    A:visited {text-decoration: none;}   
	-->
</STYLE>
<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.FORM1.password1.focus();
</SCRIPT>

</HEAD>
<BODY leftmargin=0 topmargin=0>

<FORM id=FORM1 name=FORM1 action="dealer_check_suu.asp" method=post>
<TABLE WIDTH="300" height="150" ALIGN=center BORDER=4 CELLSPACING=0 CELLPADDING=0 >
	<TR>
		<TD>

<TABLE WIDTH="100%" BORDER=0 CELLSPACING=0 CELLPADDING=0 bgColor=white>
	<TR class=head_white bgColor=#6495ed>
		<TD align=middle colspan=3>กรุณาระบุรหัสลัพธ์ ของคุณ</TD>
	</TR>
	<TR class=text_blue>
		<TD colspan=3 align=middle>   &nbsp;</TD>		
	</TR>
	<TR class=text_blue>
		<TD>&nbsp;&nbsp;รหัสผ่าน</TD>
		<TD><INPUT id=password1 type=password 
            name=password1 style="WIDTH: 130px; HEIGHT: 22px" width=200 size=21 
            onKeyDown="password1_checkkey();"></TD>
		<TD></TD>
	</TR>
        <TR>
          
          <TD colspan=3 align=middle><INPUT id=button1 type=button align=left value="  ตกลง  " name=button1  onClick="return clicksubmit();"><input type=button value=" ปิด " onClick="window.close();" ></TD></TR>
</TABLE>

</TD>
	</TR>
</TABLE>
<Input type=hidden name=act value="log">
<Input type=hidden name=gosuu value="<%=Request("gosuu")%>"
</FORM>
</BODY>
</HTML>
