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
<TITLE>::: Admin Clear Credit :::</TITLE>
<%
Dim objRS , objDB , SQL
set objDB=Server.CreateObject("ADODB.Connection")       
objDB.Open Application("constr")
Set objRS =Server.CreateObject("ADODB.Recordset")
	
Dim save, end_date
save=Request("save")
end_date=Request("end_date")
If save="yes" Then
	SQL="exec spJClsCredit '" & end_date & "'"
	objDB.Execute(SQL)
	Response.Write "<br><br><br><center><span class='head_red'>ระบบทำการลบข้อมูลเครดิต เรียบร้อยแล้ว</span></center>"
	Response.End	
End If 
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
							<td class="text_black">ตั้งแต่เริ่ม จนถึงวันที่ &nbsp;</td>
							<td> <input type=text name='end_date'   value=""  maxlength='20' size='10'  readonly class="text_black"><a href="javascript:"> <img src='images/cal.gif' align='absbottom' border="0" onclick="popUpCalendar(this,end_date,'dd-mm-yyyy');"></a> </td>
							<td>
								<input type="button" class="btn btn-primary btn-sm" style="width:80;cursor:hand;" value="ตกลง" onclick="click_ok();">
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
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
		if(document.form1.end_date.value==""){
			alert("ผิดพลาด : กรุณาระบุวันที่ ที่ต้องการลบข้อมูลเครดิต");
			return false;
		}
		document.form1.submit();
	}
</script>