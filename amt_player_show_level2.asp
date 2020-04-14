<%OPTION EXPLICIT%>
<%
   response.ContentType="text/html; charset=windows-874" 
%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		
		Dim objRS , objDB , SQL, user_id	, player_name	, RndPw ,strPw
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		

		user_id=Request("uid")
		If user_id="" Then Response.end
		Dim game_id
		game_id=Session("gameid")
		If Request("show_type")="1" Then Response.write "<br><br>"
		call HTML
%>			
<%
Function GetOldRemain(user_id)
	Dim objRS1 , objDB1 , SQL
	set objDB1=Server.CreateObject("ADODB.Connection")       
	objDB1.Open Application("constr")
	Set objRS1 =Server.CreateObject("ADODB.Recordset")
	SQL="select isnull(old_remain,0) old_remain from sc_user where user_id=" & user_id
	set objRS1=objDB1.Execute(SQL)
	if not objRs1.EOF then
		GetOldRemain = objRS1("old_remain")
	end if
	set objRS1=nothing
	set objDB1=nothing
End Function

sub HTML
%>
<html>
<head>
<title>.:: ดูยอดเงิน : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
</head>
<body topmargin="0"  leftmargin="0">
	<center>
	
	<form name="form1" action="amt_player_show.asp?uid=<%=user_id%>" method="post" target="_blank">
		<input type="hidden" name="p_prn">
	<table width="500"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
		<tr>
			<td class="tdbody1" align="right" bgcolor="#FFFFA4" width="160">ยอดเก่า&nbsp;&nbsp;&nbsp;</td>
			<td class="tdbody1" align="right" bgcolor="#FFFFA4" colspan="2"><%=FormatN(GetOldRemain(user_id),0)%>&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<%
		SQL="select * from sc_user where user_id=" & user_id
		set objRS=objDB.Execute(SQL)
		if not objRS.eof then
		%>
		<tr>
			<td class="tdbody1" bgcolor="#CD9BFF">หมายเลข : <%=objRS("login_id")%></td>
			<td class="tdbody1" bgcolor="#CD9BFF" colspan="2">ชื่อ : <%=objRS("user_name")%></td>
		</tr>
		<%
		end if
		%>
		<tr>
			<td class="tdbody1" bgcolor="#B3FFD9" align="right">ยอดจ่าย&nbsp;&nbsp;&nbsp;</td>
			<!--- ยอดแทง หัก ยอดถูก ----->
			<td class="tdbody1" bgcolor="#B3FFD9" colspan="2"  align="right"><b><%=FormatN(GetDiffTotal(user_id),0)%></b>&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody1" bgcolor="#CD9BFF" align="center"><b>แทง</b></td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="170">แทง - %</td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="170">ยอดหัก %</td>
		</tr>
			<%
			SQL="exec spGet_total_play_by_user_id_level2 " & user_id
'response.write SQL
'response.end

			set objRS=objDB.Execute(SQL)
			Dim grand_total
			grand_total=0
			if not objRS.eof then
				while not objRS.eof
					if objRS("ref_det_desc")<>" " then
						grand_total=grand_total+objRS("play_diff_percent")
					%>
					<tr>
						<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;<%=objRS("ref_det_desc")%></td>
						<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;<%=FormatN(objRS("play_amt"),0)%> 
						&nbsp;&nbsp; - &nbsp; <%=objRS("play_percent")%> % &nbsp;&nbsp;&nbsp;
						</td>
						<td class="tdbody1" bgcolor="#B3FFD9" align="right"><%=FormatN(objRS("play_diff_percent"),0)%>&nbsp;&nbsp;&nbsp;</td> 
					</tr>    
					<%
					else %>
					<tr>
						<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;</td>
						<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;	</td>
						<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;</td> 
					</tr>    
					<%
					end if
					objRS.MoveNext
				wend
				%>
				<tr>
					<td class="tdbody1" bgcolor="#FFFFFF" align="center" colspan="2">&nbsp;</td>
					<td class="tdbody1" bgcolor="#FFFFA4" align="right"><b><u><%=FormatN(grand_total,0)%></u></b>&nbsp;&nbsp;&nbsp;</td> 
				</tr> 
				<%
			end if
			%>
		</tr>
	</table><br>
	<%
		SQL="exec spGet_total_correct_by_user_id_level2  " & user_id & "," & game_id
		set objRS=objDB.Execute(SQL)
			
	%>
	<table width="500"  border="0" cellspacing="1" cellpadding="0" bgcolor="#606060">
		<tr>
			<td class="tdbody1" bgcolor="#CD9BFF" align="center" width="160"><b>ถูก</b></td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="170">ยอดถูก x จ่าย</td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="center" width="170">เงินถูก</td>
		</tr>
		<%
		grand_total=0
		while not objRS.eof
			if objRS("ref_det_desc")<>" " then
				grand_total=grand_total+objRS("pay_total")
			%>
			<tr>
				<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;<%=objRS("ref_det_desc")%></td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="center">
					<table bgcolor="#B3FFD9" width="100%" border =0>
						<tr>
							<td class="tdbody1" align="right" width="85"><%=FormatN(objRS("correct_total"),0)%></td>
							<td class="tdbody1" align="center">x</td>
							<td class="tdbody1" align="right" width="60"><%=objRS("pay_amt")%>&nbsp;</td>
						</tr>
					</table>
				</td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="right"><%=FormatN(objRS("pay_total"),0)%>&nbsp;&nbsp;&nbsp;</td> 
			</tr>    
			<%
			else %>
			<tr>
				<td class="tdbody1" bgcolor="#FFFFA4" align="center" >&nbsp;</td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;	</td>
				<td class="tdbody1" bgcolor="#B3FFD9" align="right">&nbsp;</td> 
			</tr>    
			<%
			end if
			objRS.MoveNext
		wend
		%>
		<tr>
			<td class="tdbody1" bgcolor="#FFFFFF" align="center" colspan="2">&nbsp;</td>
			<td class="tdbody1" bgcolor="#FFFFA4" align="right"><b><u><%=FormatN(grand_total,0)%></u></b>&nbsp;&nbsp;&nbsp;</td> 
		</tr> 
		
	</table><br>	
	<%
	If Request("p_prn")<>"prn" Then
	%>
	<table width="500"  border="0" cellspacing="1" cellpadding="0" bgcolor="#FFFFFF">
		<tr bgcolor="#FFFFFF">
			<td align=right><input type="button" value="พิมพ์" style="cursor:hand;width:90" onClick="click_prn();"></td>
		</tr>
	</table>
	<% End If %>
	</form>
	</center>
</body>
</html>
<%
	If Request("p_prn")="prn" Then
	%>
		<script language="javascript">
			self.print();
		</script>	
	<%
	End if
end sub
function FormatN(n,dot)
	if isnull(n) then n=0
	if n=0 or n="" then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
end function
%>
<%

Function GetDiffTotal(u)
	Dim objRS1 , objDB1 , SQL
	set objDB1=Server.CreateObject("ADODB.Connection")       
	objDB1.Open Application("constr")
	Set objRS1 =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_DiffTotal_by_userid_level2 " & u  & "," & Session("gameid")
'response.write SQL
	set objRS1=objDB1.Execute(SQL)
	if not objRS1.EOF then
		GetDiffTotal = objRS1("diff_total")
	end if
	set objRS1=nothing
	set objDB1=nothing
End Function
%>
<script language="javascript">
	function click_prn(){
		document.form1.p_prn.value="prn";
		document.form1.submit();
	}
</script>