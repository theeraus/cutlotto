<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_user_id
		Dim user_name, user_password, sum_password, old_remain, login_id, address_1

		mode=Request("mode")
		edit_user_id=Request("edit_user_id")
		if edit_user_id="" then edit_user_id=0
	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		dealer_id=Session("uid")
		game_type=Request("game_type")
%>
<html>
<head>
<title>.:: config price ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
</head>
<script language=JavaScript>
function doPrint()   {  
	if(self.print)   {  
		self.print();  
		self.close();  
		return false;  
	}  
}
</script>
<body topmargin="0"  leftmargin="0" onLoad="doPrint();">
	<form name="form1" action="dealer_print_player.asp" method="post">
	<center><br>
			<table  border="0"  cellpadding="0" cellspacing="0"  width="100%">
				<tr>
					<td class="table_blue" class="head_blue" align="center" colspan="3"><%=FormatDateTime(Now(),1)%></td>
					<td class="table_blue" align="center" width=20>1</td>
					<td class="table_blue" align="center" width=20>2</td>
					<td class="table_blue" align="center" width=20>3</td>
					<td class="table_blue" align="center" width=20>4</td>
					<td class="table_blue" align="center" width=20>5</td>
					<td class="table_blue" align="center" width=20>6</td>
					<td class="table_blue" align="center" width=20>7</td>
					<td class="table_blue" align="center" width=20>8</td>
					<td class="table_blue" align="center" width=20>9</td>
					<td class="table_blue" align="center" width=20>10</td>
				</tr>
				<%
				SQL="select  * from sc_user where user_type='K' and create_by=" & dealer_id & " order by login_id "
				set objRS=objDB.Execute(SQL)
				while not objRS.eof
				
						'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
						%>
						<tr>
							<td class="table_blue" align="left" width="60"><%=objRS("login_id")%>	</td>
							<td class="table_blue" align="left" width="145" nowrap><%=objRS("user_name")%>	</td>
							<td class="table_blue" align="left" nowrap>&nbsp;<%=objRS("address_1")%></td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
							<td class="table_blue" align="center">&nbsp;</td>
						</tr>
						<!----------------------------------------------------------->
						<%

					objRS.MoveNext
				wend 
				%>
			</table>
	</center>
	</form>
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

