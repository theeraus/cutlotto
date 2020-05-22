<%@ Language=VBScript CodePage = 65001  %>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="JavaScript" src="include/normalfunc.js"></script>
 <script language='JavaScript' src='include/popcalendar.js' type='text/javascript'></script>
<LINK href="include/code.css" type=text/css rel=stylesheet>
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<TITLE>Admin Clear Key</TITLE>
<%
Dim objRec , objDB , SQL , strSql
set objDB=Server.CreateObject("ADODB.Connection")       
objDB.Open Application("constr")
Set objRec =Server.CreateObject("ADODB.Recordset")
	
Dim overlimit,  limit, sumplay
Dim save, end_date
save=Request("save")

If save="yes" Then

		'ล้างเลขอันตรายด้วย anon 060209
		strSql="delete tb_danger_number where dealer_id=" & Session("uid")
		objDB.Execute(strSql)	

		'เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		
		strSql = "select 'yes' as overlimit, admin_limit as  limit, play_amt as sumplay "
		strSql =strSql & " from tb_clear_number where dealer_id=" & Session("uid") & " and game_id=" & Session("gameid") 
		set objRec=conn.Execute(strSql)	
		If Not objRec.eof Then
			overlimit=objRec("overlimit")
			limit=objRec("limit")
			sumplay=objRec("sumplay")
		End If 
		'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		

		strSql = "exec spA_ChangePasswordOverLimit " & Session("uid") & ", " & Session("gameid") 
		set objRec=conn.Execute(strSql)			

		strSql = "exec spDealerClearNumber " & Session("gameid")
    	set objRec=conn.Execute(strSql)	

        Response.Write "<br><br><br><center><span class='head_red'>ระบบทำการล้างเลข เรียบร้อยแล้ว</span></center>"
	    Response.End	
    END IF
%>
</HEAD>
<BODY>
	<form name="form1" action="" method="post">
		<input type="hidden" name="save" value="yes">
	<center>
	<table width="550" cellpadding="3" cellspacing="3">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<fieldset>
					<table>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>			
							<td class="text_black" align="center" colspan="2">ยืนยันการล้างเลข หรือไม่?</td>
						</tr>
						<tr><td align="center" colspan="2">&nbsp;</td></tr>
						<tr><td align="center"><input type="button" class="btn btn-primary btn-sm" style="width:90;cursor:hand;" value="เก็บโพยก่อน" onclick="opensave();"></td><td align="center"><input type="button" class="btn btn-danger btn-sm" style="width:80;cursor:hand;" value="ล้างเลข" onclick="click_ok();"></td></tr>
					</table>
				</fieldset>
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
	</table>
	</center>
	</form>
</BODY>
</HTML>
<script language="javascript">
	function click_ok(){
		document.form1.submit();
	}
	function opensave() {
	    window.open("dealer_save_data.asp", "_blank", "top=150,left=150,height=350,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}
</script>

