<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="mdlGeneral.asp"-->
<!--#include file="activate_time.asp"-->
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
		SQL="select * from sc_user where user_password='" & old_password & "' and [user_id]=" & player_id 
		set objRS=objDB.Execute(SQL)
		if not objRS.eof then
			SQL="update sc_user set user_password='" & new_password & "' where [user_id]=" & player_id
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">

	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <style type="text/css">
        .style1
        {
            color: #FFFFFF;
        }
    </style>
</head>
<body topmargin="0"  leftmargin="0">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">เปลี่ยนรหัสผ่านเรียบร้อยแล้ว</td>
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="include/code.css" rel="stylesheet" type="text/css">
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</head>
<body topmargin="0"  leftmargin="0">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">รหัสผ่านเดิมไม่ถูกต้อง</td>
		</tr>
	</table>
</body>
</html><%
end sub 
sub HTML
%>
<html>
<head>
<title>คนแทง : เปลี่ยน password</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="include/code.css" rel="stylesheet" type="text/css">
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</head>
<body topmargin="0"  leftmargin="0">
<form name="form1" action="key_chgpass.asp" method="post" onSubmit="return clicksubmit()">
	<center><br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="50%" > 
		<tr>
			<td align="center" bgcolor="red"  colspan="2"><h3 style="color:#fff">เปลี่ยน Password</h3><tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">รหัสผ่าน เดิม :</td>
			<td><input type="password" size="15" maxlength="20" name="old_password" class="form-control"></td>
		</tr>
		<tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">รหัสผ่าน ใหม่ :</td>
			<td><input type="password" size="15" maxlength="20" name="new_password" class="form-control"></td>
		</tr>
		<tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">ยืนยัน รหัสผ่านใหม่ :</td>
			<td><input type="password" size="15" maxlength="20" name="confirm_password" class="form-control"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				&nbsp;</td>			
		</tr>
		<tr>
			<td colspan="2" align="center" >
				<input type="hidden" name="save" value="ok">
				<input type="submit" class="btn btn-primary" value="บันทึก" style="cursor:hand;width: 75px;">
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
			alert('ผิดพลาด : กรุณากรอก รหัสผ่านเดิม')
			document.form1.old_password.focus();
			return false;
		}
		if (document.form1.new_password.value==''){
			alert('ผิดพลาด : กรุณากรอก รหัสผ่านใหม่')
			document.form1.new_password.focus();
			return false;
		}
		if (document.form1.new_password.value!=document.form1.confirm_password.value){
			alert('ผิดพลาด : รหัสผ่านใหม่ ไม่ตรงกับ ยืนยัน รหัสผ่านใหม่ ')
			document.form1.confirm_password.focus();
			return false;
		}
		return true
	}
</script>