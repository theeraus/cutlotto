<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->

<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<%Response.Buffer = True%>
<%
dim objRec
dim strSql
dim i
dim chkTud
dim cutSeq
dim cutallid
dim sumall 
dim sendtype
dim sendto


dim arrNum
dim arrMoney
dim arrCuttype
	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")

		sendtype=Request("sendtype")
		if sendtype="2" then
			sendto = 999
		else
			sendto = Request("sendto")
		end if

'showstr "send to "&sendto

		comm.CommandText = "spSendBackToTicket"
		comm.CommandType = adCmdStoredProc
		comm.Parameters.Append comm.CreateParameter("@senddealer"	,adInteger  ,adParamInput, ,sendto)
		comm.Parameters.Append comm.CreateParameter("@ticketid	"	,adInteger  ,adParamInput, ,Request("ticketid"))
		comm.Parameters.Append comm.CreateParameter("@sendtype"		,adChar		,adParamInput,1,sendtype)
		comm.Parameters.Append comm.CreateParameter("@playerid"		,adInteger  ,adParamInput, ,Request("sendfrom"))
		comm.Parameters.Append comm.CreateParameter("@refgameid"	,adInteger  ,adParamInput, ,Session("gameid"))
		comm.Execute


	if Request("sendtype")="2" then
		Session("cutallid")=Request("ticketid")
		Response.write "<script language=JavaScript>NewWindowOpen('dealer_tudroum_print.asp');</script>"	
		Response.write "<script language=JavaScript>NewOpen('dealer_play_out.asp');</script>"	
	elseif Request("sendtype")="1" then
		Session("cutallid")=Request("ticketid")
		Response.write "<script language=JavaScript>NewOpen('dealer_play_out.asp');</script>"	
	end if



sub GenEmptyCol(cntCol)
dim i
	for i = 1 to (8 - cntCol)
		response.write "<td width=93 class=text_blue>&nbsp;</td>"
	next 
end sub

%>