<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<HEAD>
<TITLE>Welcome</TITLE>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
<STYLE TYPE="text/css">
	<!--
    A:link {text-decoration: none;}  
    A:visited {text-decoration: none;}   
	-->
</STYLE>

<script>

function txtUserName_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.password1.focus();
	}
}

function password1_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		clicksubmit();
	}
}

</script>

</HEAD>

<BODY onLoad="document.all.FORM1.txtUserName.focus();" style="background-image:url(images/bg.png);">
<P>&nbsp;</P>
<div style="width:550px; border:0px; margin:100px auto auto auto; padding-top:20px; padding-bottom:10px;">
<FORM id=FORM1 name=FORM1 action="mdlCheckUser.asp" target="_self" method=post>
<input type=hidden name=chkid value=<%=Session.SessionID%>>

<table width="400" border="0" align="center" cellpadding="0" cellspacing="1">
  <tr>
    <td>
      <table width="100%" border="0" align="center" cellpadding="1" cellspacing="0"  class="alert alert-info">
        <tr class="btn-info">
          <td height="35" colspan="2" align="center"><h4>Member Login</h4>
          <hr></td>
           <tr height="30" >
          <td width="100" align="right"><h5>Username :</h5></td>
          <td><input id=text1 name=txtUserName style="width:200px" class="form-control" onKeyDown="txtUserName_checkkey();"></td>
        </tr>
        <tr height="30" >
          <td align="right"><h5>Password :</h5></td>
          <td><input id=password1 type="password" name=password1 class="form-control" style="width:200px" onKeyDown="password1_checkkey();"></td>
        </tr>
        <tr height="20" >
          <td align="right">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr height="40" >
          <td colspan="2" align="center">
            <input id=button1 type=button  class="btn btn-warning  w-50" value="LOG IN" onClick="return clicksubmit();">
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>



</FORM>
</div>
</BODY>

</HTML>
<script language="javascript">
	function clicksubmit(){
		if (document.FORM1.txtUserName.value==''){
			alert('กรุณาป้อน รหัส หรือชื่อ ผู้ใช้งาน')
			document.FORM1.txtUserName.focus();
			return false
		}
		if (document.FORM1.password1.value==''){
			alert('กรุณาป้อน รหัสผ่าน')
			document.FORM1.password1.focus();
			return false
		}
		//document.FORM1.submit();
		var txtUserName=document.FORM1.txtUserName.value
		var password1=document.FORM1.password1.value
//		var txtdealer=document.FORM1.txtdealer.value

		window.open("mdlCheckUser.asp?txtUserName=" + txtUserName + "&password1=" + password1);
		//, "_blank", "scrollbars=no, status=0, fullscreen=0, location=0, toolbar=0, titlebar=0, width=1020, height=740, top=0, left=0"
		//window.location = "mdlCheckUser.asp?txtUserName=" + txtUserName + "&password1=" + password1;
		//return false;
	
		//top.window.opener = window;
		//top.close();
		//window.open('close.html', '_parent');
				
	}


</script>