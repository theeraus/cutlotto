<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<%

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim dealer_id, game_id 
	dealer_id=Session("uid")
	game_id=Session("gameid")
	
Function GetSend(p,g)
	if p="" then
		GetSend=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetSend " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetSend = objRS("send")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>
<html>
<head>
<title>.:: เลขคืน : เจ้ามือ ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
</head>
<body topmargin="0"  leftmargin="0">
	<form name="form1" action="key_dealer_play.asp" method="post">
	<table border="1" width="100%"  align="absmiddle" class=table_blue>
	<%
	SQL="exec spGetReturn_by_PlayerID_GameID " & dealer_id & "," & game_id
	set objRS=objDB.Execute(SQL)
	if not objRS.eof then
		while not objRS.eof
			%>
			<tr>
				<td>
					
				</td>			
			</tr>
			<%
			objRS.MoveNext
		wend
	else
		'--- ไม่มีเลขคืน
	end if

	%>
		
	</table>
	
	</form>
</body>
<script language="javascript">
	
</script>