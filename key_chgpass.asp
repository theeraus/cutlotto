
<!--#include virtual="masterpage.asp"-->

<% Sub HTML2 ' เปลี่ยนรหัสผ่านเรียบร้อยแล้ว  %>
<center>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">เปลี่ยนรหัสผ่านเรียบร้อยแล้ว</td>
		</tr>
	</table>
</center>

<% End sub %>

<% Sub HTML3 ' รหัสผ่านเดิมไม่ถูกต้อง %>
<center>
	<br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td class="tdbody">รหัสผ่านเดิมไม่ถูกต้อง</td>
		</tr>
	</table>
</center>
<% End sub %>

<% Sub HTML %>
<center>
<form name="form1" action="key_chgpass.asp" method="post" onSubmit="return clicksubmit()">
	<br><br><br>
	<table  border="0"  cellpadding="1" cellspacing="0" width="300">
		<tr>
			<td align="center" class="btn-warning " colspan="2"><strong>เปลี่ยน Password</strong><tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">รหัสผ่าน เดิม :</td>
			<td><input type="password" size="15" maxlength="20" name="old_password" class="input1"></td>
		</tr>
		<tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">รหัสผ่าน ใหม่ :</td>
			<td><input type="password" size="15" maxlength="20" name="new_password" class="input1"></td>
		</tr>
		<tr>
			<td class="tdbody">&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="tdbody">ยืนยัน รหัสผ่านใหม่ :</td>
			<td><input type="password" size="15" maxlength="20" name="confirm_password" class="input1"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				&nbsp;</td>			
		</tr>
		<tr>
			<td colspan="2" align="center" class="btn-warning ">
				<input type="hidden" name="save" value="ok">
				<input type="submit" class="btn btn-primary" value="บันทึก" style="cursor:hand;width: 75px;">
			</td>			
		</tr>
	</table>
	
</form>
</center>
<%
end sub
%>

<% Sub ContentPlaceHolder() %>
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

<% end sub %>