<%@ Language=VBScript CodePage = 65001  %>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%
	if Request("status")="change" then
		dim strSql
		dim rs
		Set rs = server.createobject("ADODB.Recordset")

		strSql = "select * from sc_user where user_id = " & Session("uid") & " and user_password = '"  & Request("txtoldpassword") & "'"
		rs.Open strSql,conn
		if rs.Eof then
			strMsg = "Password ������١��ͧ��سҵ�Ǩ�ͺ���� !"
			call showmessage(strMsg&"&nbsp;&nbsp;[<a href='change_password.asp'>��͹��Ѻ</a>]")
			Response.end		
		else
			strSql  = "Update sc_user set user_password = '" & Request("txtnewpassword") & "' where user_id = " & Session("uid")
			comm.CommandText = StrSql
			comm.CommandType = adCmdText
			comm.Execute
			Response.write "<script language=javascript>window.close();</script>"
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

<SCRIPT LANGUAGE=JavaScript>
function txtoldpassword_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.txtnewpassword.focus();
	}
}

function txtnewpassword_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.txtconfpassword.focus();
	}
}

function txtconfpassword_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		clicksubmit();
	}
}

</SCRIPT>

</HEAD>
<BODY onLoad="document.all.FORM1.txtoldpassword.focus();" topmargin=0 leftmargin=0>
<P>&nbsp;</P>
<FORM id=FORM1 name=FORM1 action="change_password.asp" target="_top" method=post>
<input type=hidden name=chkid value=<%=Session.SessionID%>>
<INPUT TYPE="hidden" name="status" value="change">
<TABLE WIDTH="300" ALIGN=center BORDER=4 CELLSPACING=0 CELLPADDING=0 style="WIDTH: 300px">
	<TR>
		<TD>

<TABLE WIDTH="100%" BORDER=0 CELLSPACING=0 CELLPADDING=0 bgColor=white>
	<TR class=head_white bgColor=#6495ed>
		<TD align=middle colspan=3>����¹ Password</TD>
	</TR>
	<TR class=text_blue>
		<TD colspan=3 align=middle>   &nbsp;</TD>
		
	</TR>
	<TR class=text_blue>
		<TD> ���ʼ�ҹ���</TD>
		<TD><INPUT id=text1 type=password name=txtoldpassword style="WIDTH: 130px" 
            width=200 onKeyDown="txtoldpassword_checkkey();"></TD>
		<TD></TD>
	</TR>
	<TR class=text_blue>
		<TD> ���ʼ�ҹ����</TD>
		<TD><INPUT id=text2 type=password name=txtnewpassword style="WIDTH: 130px" 
            width=200 onKeyDown="txtnewpassword_checkkey();"></TD>
		<TD></TD>
	</TR>
	<TR class=text_blue>
		<TD> �׹�ѹ��������</TD>
		<TD><INPUT id=text3 type=password 
            name=txtconfpassword style="WIDTH: 130px; HEIGHT: 22px" width=200 size=21 onKeyDown="txtconfpassword_checkkey();"></TD>
		<TD></TD>
	</TR>
        <TR>
          
          <TD colspan=3 align=middle><INPUT id=button1 type=button align=left value="  ����¹���ʼ�ҹ  " name=button1 onClick="return clicksubmit();"></TD></TR>
</TABLE>
</TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
<script language="javascript">
	function clicksubmit(){
		if (document.FORM1.txtoldpassword.value ==""){
			alert('��س��к� ���ʼ�ҹ��� !!!')
			document.FORM1.txtoldpassword.focus();
			return false
		}
		if (document.FORM1.txtnewpassword.value ==""){
			alert('��س��к� ���ʼ�ҹ����ͧ�������¹ !!!')
			document.FORM1.txtnewpassword.focus();
			return false
		}
		if (document.FORM1.txtconfpassword.value ==""){
			alert('��س��׹�ѹ ���ʼ�ҹ !!!')
			document.FORM1.txtconfpassword.focus();
			return false
		}
		if (document.FORM1.txtnewpassword.value != document.FORM1.txtconfpassword.value){
			alert('�׹�ѹ�������� ���١��ͧ !!!')
			document.FORM1.txtnewpassword.focus();
			return false
		}
		document.FORM1.submit();
		//var txtnewpassword=document.FORM1.txtnewpassword.value
		//var txtconfpassword=document.FORM1.txtconfpassword.value
		//var txtoldpassword=document.FORM1.txtoldpassword.value

		//window.close();
		//window.open("mdlCheckUser.asp?txtnewpassword="+txtnewpassword+"&txtconfpassword="+txtconfpassword+"&txtoldpassword="+txtoldpassword     ,"_blank", "scrollbars=no, status=0, fullscreen=1, location=0, toolbar=0, titlebar=0, width=1020, height=740, top=0, left=0");	

	}
</script>