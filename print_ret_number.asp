<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
		Dim objRS , objDB , SQL	
		Dim ticket_id, line_per_page,i,j,k,game_id,player_id
		Dim arrRet

		line_per_page=33
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		ticket_id=Request("ticket_id")
		SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
		set objRS=objDB.Execute(SQL)	
		if not objRS.eof then
%>
<html>
<head>
<title>.:: พิมพ์ส่ง : ต่อเจ้ามืออื่น (นอกระบบ) ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">

</head>
<body topmargin="0"  leftmargin="0" onafterprint="window.close();">
	<center><br>
			<table  border="0"  cellpadding="1" cellspacing="0" width="500">
				<tr>
					<td class="tdbody_navy" width="60">เลขที่ &nbsp;<%=objRS("login_id")%></td>
					<td class="tdbody_navy" width="160">ชื่อ &nbsp;<%=objRS("player_name")%></td>
					<td>&nbsp;</td>
				</tr>
			</table>
			<%
			SQL="exec spGet_tb_ticket_key_by_ticket_id_Ret " & ticket_id
			set objRS=objDB.Execute(SQL)
			Dim ar_disp
			reDim ar_disp(99,4)
			i=1
			if not objRS.eof then
				while not objRS.eof
					ar_disp(i,1)=objRS("updown_type")
					ar_disp(i,2)=objRS("str_updown_type")
					ar_disp(i,3)=objRS("key_number")
					ar_disp(i,4)=objRS("Ret_money")
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1" width="500" bgcolor="#D4D4D4"><%
				for i=1 to 33
					j=i+line_per_page
					k=j+line_per_page					
				%>
				<tr>					
					<td class="tdbody_blue" width="30" align="center">&nbsp;<%=ar_disp(i,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(i,4)%></td>
				
					<td class="tdbody_blue" width="30" align="center">&nbsp;<%=ar_disp(j,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(j,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(j,4)%></td>

					<td class="tdbody_blue" width="30" align="center">&nbsp;<%=ar_disp(k,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(k,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(k,4)%></td>

					<td class="tdbody_blue" width="20" align="right"><%=i%></td>
				</tr>
				<%
				next
				%></table><%
			end if
		end if
		set objRS=nothing
		set objDB=nothing
	%>
			</td>
		</tr>
	</table>
		</center>
</body>
</html>
<script language="javascript">
	window.print();
</script>