<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<html>
<head>
<title>.:: ยอดแทงรวม : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
</head>
<body topmargin="0"  leftmargin="0">	
<%
	Dim user_id
	user_id=Session("uid")	
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_total_play_by_user_id_all " & user_id
'response.write SQL
'response.end
	set objRS=objDB.Execute(SQL)
	Dim grand_total
	grand_total=0
	%>
	<center><br>
	<table width="320"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
		<tr>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="150">&nbsp;</td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="170">ยอด</td>
		</tr>
	<%
	if not objRS.eof then
		while not objRS.eof
			if objRS("ref_det_desc")<>" " then
				grand_total=grand_total+objRS("play_amt")
			%>
			<tr>
				<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;<%=objRS("ref_det_desc")%></td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;<%=FormatN(objRS("play_amt"),0)%>&nbsp;&nbsp;&nbsp;</td>
			</tr>    
			<%
			else %>
			<tr>
				<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;</td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;</td> 
			</tr>    
			<%
			end if
			objRS.MoveNext
		wend
		%>
		<tr>
			<td class="tdbody1" bgcolor="#B3FFD9" align="center" colspan="1"><b>รวม</b>&nbsp;</td>
			<td class="tdbody1" bgcolor="#B3FFD9" align="right"><b><u><%=FormatN(grand_total,0)%></u></b>&nbsp;&nbsp;&nbsp;</td> 
		</tr> 
		</table><br>
		<input type="button" value="ปิดหน้าต่างนี้" onClick="window.close();" style="cursor:hand;">
		</center>
		<%
	end if
	set objRS=nothing
	set objDB=nothing
%>
</body>
</html>
<%
function FormatN(n,dot)
	if n=0 or n="" then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
end function
%>