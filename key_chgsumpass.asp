<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="mdlGeneral.asp"-->
<%
	Dim save, old_password, new_password, player_id
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	save=Request("save")
	if save="ok" then
		old_password=Request("old_password")
		new_password=Request("new_password")
		player_id=Session("uid")
		SQL="select * from sc_user where sum_password='" & old_password & "' and [user_id]=" & player_id 
		set objRS=objDB.Execute(SQL)
		if not objRS.eof then
			SQL="update sc_user set sum_password='" & new_password & "' where [user_id]=" & player_id
			set objRS=objDB.Execute(SQL)
			call HTML2			
		else
			call HTML3
		end if
	else
		call HTML
	end if
sub HTML2 ' เปลี่ยนรหัสผ่านเรียบร้อยแล้ว %>
<html>
<head>
<title>.:: คนแทง : เปลี่ยน password ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0"  leftmargin="0">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">เปลี่ยนรหัสดูยอดเงินเรียบร้อยแล้ว</td>
		</tr>
	</table>
</body>
</html>
<%
end sub 
sub HTML3 ' รหัสผ่านเดิมไม่ถูกต้อง %>
<html>
<head>
<title>.:: คนแทง : เปลี่ยน password ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0"  leftmargin="0">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">รหัสดูยอดเงินเดิมไม่ถูกต้อง</td>
		</tr>
	</table>
</body>
</html><%
end sub 
sub HTML
%>
<html>
<head>
<title>.:: คนแทง : เปลี่ยน รหัสดูยอดเงิน ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0"  leftmargin="0">
<form name="form1" action="key_chgsumpass.asp" method="post" onSubmit="return clicksubmit()">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="350">
		<tr>
			<td colspan="2"><img src="images/chgsumpass.jpg"><td>
		</tr>
		<tr>
			<td class="tdbody">รหัสดูยอดเงิน เดิม</td>
			<td><input type="password" size="15" maxlength="20" name="old_password" class="input1"></td>
		</tr>
		<tr>
			<td class="tdbody">รหัสดูยอดเงิน ใหม่</td>
			<td><input type="password" size="15" maxlength="20" name="new_password" class="input1"></td>
		</tr>
		<tr>
			<td class="tdbody">ยืนยัน รหัสดูยอดเงินใหม่</td>
			<td><input type="password" size="15" maxlength="20" name="confirm_password" class="input1"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="hidden" name="save" value="ok">
				<input type="submit" value=" ตกลง " style="cursor:hand;">
			</td>			
		</tr>
	</table>
	</center>
</form>
</body>
</html>
<%
end sub
%>
<script language="javascript">
	function clicksubmit(){
		if (document.form1.old_password.value==''){
			alert('ผิดพลาด : กรุณากรอก รหัสดูยอดเงินเดิม')
			document.form1.old_password.focus();
			return false;
		}
		if (document.form1.new_password.value==''){
			alert('ผิดพลาด : กรุณากรอก รหัสดูยอดเงินใหม่')
			document.form1.new_password.focus();
			return false;
		}
		if (document.form1.new_password.value!=document.form1.confirm_password.value){
			alert('ผิดพลาด : รหัสดูยอดเงินใหม่ ไม่ตรงกับ ยืนยัน รหัสดูยอดเงินใหม่ ')
			document.form1.confirm_password.focus();
			return false;
		}
		return true
	}
</script>