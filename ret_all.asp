<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		Dim ticket_id
		ticket_id=Request("ticket_id")
		If ticket_id="" Then response.end
		SQL="exec spReturnTicket " & ticket_id
		set objRS=objDB.Execute(SQL)
		Set objRS=nothing
		Set objDB=Nothing
		Response.redirect("dealer_ticket.asp")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
</HEAD>

<BODY>

</BODY>
</HTML>
