<%@ Language=VBScript CodePage = 65001  %>
<% Response.CodePage = 65001%>
<%OPTION EXPLICIT%>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
 <HEAD>
  <TITLE> New Document </TITLE>
  <META NAME="Generator" CONTENT="EditPlus">
	<META HTTP-EQUIV='Refresh' CONTENT='300;'> 
	<LINK href="include/code.css" type=text/css rel=stylesheet>
</HEAD>

 <BODY scroll=no topmargin=0 leftmargin=0 >
  <%
dim objRec
dim strSql

dim bMsg
	bMsg=""

	if Session("uid")<>"0"  And Session("uid")<>"" Then '--jum ���� And Session("uid")<>""
		if Session("utype")="A" then
		else
            if Session("utype")="P" then
				strSql = "Select top(1) * From tb_system_alert "
			elseif Session("utype")="D" Or Session("utype")="K"  then
				strSql = "Select top(1) * From tb_system_alert "
			end if	
			set objRec = Server.CreateObject("ADODB.Recordset")
			objRec.Open strSql, conn, adOpenForwardOnly, adLockReadOnly
			if Not objRec.EOF then	
				bMsg=""&objRec("message")
			end if		
		end if
	end if
	set objRec = nothing
	set conn = nothing
	if bMsg <> "" then
%>

				<marquee direction=left width="100%" height=20 scrollamount="2" scrolldelay="30" onMouseOver=stop(); onMouseOut=start();  id=MARQUEE1 class=textbig_red><%=bMsg%>
				</marquee>	

<%	end If %>
 </BODY>
</HTML>
