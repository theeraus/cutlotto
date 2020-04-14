<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>
<!--#include file="activate_time.asp"-->
<html>
<head>
<title>.:: ดูยอดเงินของลูกค้าย่อย ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>


</head>
<body topmargin="0"  leftmargin="0">
	<center><br>
	<table  border="0" cellspacing="1" cellpadding="1" >
		<tr>
			<td colspan="2" class="head_black">กรุณาเลือกลูกค้าย่อย</td>
		</tr>
		<tr valign="top">
			<td width="300" >
			<!--- แสดงข้อมูลรายชื่อลูกค้าย่อย--->
			<%
			Dim objRS , objDB , SQL, user_id
			user_id=Request("uid")
			set objDB=Server.CreateObject("ADODB.Connection")       
			objDB.Open Application("constr")
			objDB.CursorLocation = 3 
			Set objRS =Server.CreateObject("ADODB.Recordset")	
			SQL="select * from sc_user where create_by_player=" & user_id & " order by login_id"
			Set objRS=objDB.Execute(SQL)	
			If Not objRS.eof Then
				Response.Write "<table border='0' cellspacing='1' cellpadding='1' bgcolor='#606060'>"
				Response.Write "<tr><td class='tdbody1' bgcolor='#CD9BFF'>หมายเลข</td> <td class='tdbody1' bgcolor='#CD9BFF'>ชื่อ</td></tr>"
				While not objRS.eof 
					%><tr style="cursor:hand;"  bgcolor="#FFFFFF" onclick="window.open('amt_player_show_level2.asp?uid=<%=objRS("user_id")%>&show_type=<%=Request("show_type")%>','show_revenue');"><td><%=objRS("login_id")%></td><td><%=objRS("user_name")%></td></tr><%
					objRS.MoveNext

				Wend 
				Response.Write "</table>"
			End If 

			%>

			</td>
			<td width="530" >
			<!--  แสดงข้อมูล ยอดเงิน -->
				<div id="show_revenue"></div>
				<iframe src ="amt_player_show_level2.asp?uid=-1" width="100%" height="650px" name="show_revenue" frameborder="0">
				  <p>Your browser does not support iframes.</p>
				</iframe>				 
			</td>
		</tr>

	</table>	
	</form>
	</center>
</body>
</html>

