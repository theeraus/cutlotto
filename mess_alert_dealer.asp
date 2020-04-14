<%@ Language=VBScript %>
<%OPTION EXPLICIT%>

<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->

<%
dim objRec
dim strSql

dim bMsg
	bMsg=""

	if Session("uid")<>"0"  And Session("uid")<>"" Then 
		if Session("utype")="A" then
		else
			if Session("utype")="P" then
				strSql = "Select * From tb_dealer_alert Where dealer_id= " & Session("did") & " "
			elseif Session("utype")="D" Or Session("utype")="K"  then
				strSql = "Select * From tb_dealer_alert Where dealer_id= " & Session("uid") & " "		
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

  <link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<marquee direction=left width="100%" scrollamount="4" scrolldelay="20" onMouseOver=stop(); 
	onMouseOut=start();  id=MARQUEE1 class="textbig_blue">การ<%=bMsg%></marquee>	

<%	end If %>

