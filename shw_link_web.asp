<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<!--#include file="include/config.inc"-->
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	, tmp_Color
		Dim is_dealer
		is_dealer=Request("is_dealer")
		SQL="select * from tb_link_web where is_dealer=" & is_dealer
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		
%>
<html>
<head>
<title>.:: ดูยอดเงิน : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
</head>
<body topmargin="0"  leftmargin="0">
	<center><br><br>
	<table width="90%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">
	<%
	Set objRS=objDB.Execute(SQL)
	While Not objRS.eof
		%>
		<tr bgcolor="#CACAFF">
			<td>
				<a href="<%=objRS("url_name")%>" target="_blank"><%=objRS("url_name")%></a>
				&nbsp;&nbsp; : <font color="#336600"><%=objRS("url_desc")%></font>
			</td>
		</tr>
		<%
		objRS.moveNext
	wend
	%>
	</table>
	</center>
</body>
</html>
			
