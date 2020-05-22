<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"

Dim objRec
dim recPlayer
dim recNum
Dim strSql
Dim cntApp
dim playnum
dim playtype
dim gameid
dim sumplay	
dim sumcut
dim numtype
	'Server.ScriptTimeout=1200
	'*** Open the database.	
	call CheckGame(Session("uid"))
	gameid=Session("gameid")
	Set objRec = Server.CreateObject ("ADODB.Recordset")
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script language=javascript>

	function clicksave() {
	var cnt, str, i, strTkF,  strTkT
	var chkprn, chkto, chkselect, savename
		cnt = document.all.form1.chkselect.length;
		str=""; strTkF="";strTkT="";
		for (i=0;i<=cnt-1;i++) {
			if (document.all.form1.chkselect[i].checked==true) {
				if (! str=="") {
					str=str+","
					strTkF=strTkF + ","
					strTkT=strTkT + ","
				}
				str = str + document.all.form1.chkselect[i].value;
				if (isNaN(document.all.form1.txtticketfrom[i].value)) {
					strTkF = strTkF + "";
				} else {
					strTkF = strTkF + document.all.form1.txtticketfrom[i].value;
				}
				if (isNaN(document.all.form1.txtticketto[i].value)) {
					strTkT = strTkT + "";
				} else {
					strTkT = strTkT + document.all.form1.txtticketto[i].value;
				}
			}
		}
		
		chkprn = "";
		chkto = "";
		chkselect = false;
		if (document.all.form1.chkprnall.checked==true) {
			document.all.form1.printall.value="yes";
			chkprn = "all";
		}
		if (document.all.form1.chkprnselect.checked==true) {
			document.all.form1.printselect.value="yes";
			chkprn = "select";
		}
		if (document.all.form1.chktoprn.checked==true) {
			document.all.form1.printtoprinter.value="yes";
			chkto = "printer";
		}
		if (document.all.form1.chkprnfile.checked==true) {
			document.all.form1.printtofile.value="yes";
			chkto = "file";
		}
		if (! str=="" ) {
			//alert(str);
			chkselect = true;
		}
		if (!chkprn=="" && !chkto=="") {
			if (chkto=="file" && document.all.form1.savename.value=="" ) {
					alert("กรุณาระบุชื่อที่ต้องการจัดเก็บ !!!");
					return false;
			}
			savename = document.all.form1.savename.value;

			if (document.all.form1.printselect.value=="yes") {
				if (chkselect == false ) {
					alert("กรุณาเลือก คนแทงที่ต้องการจัดเก็บ !!!");
				} else {
					window.open("dealer_save_ticket.asp?printtype="+chkto+"&selecttype="+chkprn+"&player="+str+"&ticketfrom="+strTkF+"&ticketto="+strTkT+"&savename="+savename, "_blank","top=20,left=20,height=760,width=1030,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0");
					//document.all.form1.submit();
				}
			} else {
				window.open("dealer_save_ticket.asp?printtype="+chkto+"&selecttype="+chkprn+"&player="+str+"&ticketfrom="+strTkF+"&ticketto="+strTkT+"&savename="+savename, "_blank","top=20,left=20,height=760,width=1030,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0");
				//document.all.form1.submit();
			}
		} else {
			if (chkprn=="") {	alert("กรุณาเลือกประเภทการ ออกเครื่องพิมพ์ หรือ เก็บเป็นไฟล์ !!!");}
			if (chkto=="") {	alert("กรุณาเลือกประเภท เก็บทั้งหมด หรือ เก็บที่เลือก !!!");}
		}

	}

	function chkprnall_check() {

		if (document.all.form1.chkprnselect.checked==true) {
			document.all.form1.chkprnselect.checked=false;
		}
	}

	function chkprnselect_check() {

		if (document.all.form1.chkprnall.checked==true) {
			document.all.form1.chkprnall.checked=false;
		}
	}

	function chktoprn_check() {

		if (document.all.form1.chkprnfile.checked==true) {
			document.all.form1.chkprnfile.checked=false;
		}
	}

	function chkprnfile_check() {

		if (document.all.form1.chktoprn.checked==true) {
			document.all.form1.chktoprn.checked=false;
		}
	}

</script>

<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
</HEAD>
<form name="form1" method="post" action="dealer_save_ticket.asp">
<BODY topmargin=0 leftmargin=0>
	<table align="center" cellpadding="0" cellspacing="1" width="100%" border="0" bgcolor=#ffffff>
	<tr class=head_black height=20>
		<td colspan=5 align=center><font size=3>เก็บข้อมูล</font></td>
	</tr>
	<tr class=head_black>
		<td colspan=2><input type=checkbox name='chkprnall' onClick="chkprnall_check();">พิมพ์ทั้งหมด</td>
		<INPUT TYPE="hidden" name="printall">
		<td colspan=3><input type=checkbox name='chktoprn' onClick="chktoprn_check();">พิมพ์ออกเครื่องพิมพ์</td>
		<INPUT TYPE="hidden" name="printtoprinter">
	</tr>
	<tr class=head_black>
		<td colspan=2><input type=checkbox name='chkprnselect' onClick="chkprnselect_check();">พิมพ์ที่เลือก</td>
		<INPUT TYPE="hidden" name="printselect">
		<td colspan=3><input type=checkbox name='chkprnfile' onClick="chkprnfile_check();">พิมพ์เก็บเป็นไฟล์ &nbsp; <INPUT TYPE="text" name="savename" size="25"></td>
		<INPUT TYPE="hidden" name="printtofile">

	</tr>
	<tr class=head_black>
		<td colspan=2>&nbsp;</td>
		<INPUT TYPE="hidden" name="printselect">
		<td colspan=2>&nbsp;</td>		
		<td align=right><input type=button name='cmdsave' class="inputG" style="cursor:hand; width: 75px;" onClick="clicksave();" value = "ตกลง"></td>
	</tr>
	<tr bgcolor="#4f4f4f" class=head_black>
		<td colspan=5></td>
	</tr>
</table>
<table align="center" cellpadding="0" cellspacing="1" width="100%" border="0" bgcolor=#ffffff>
	<tr bgcolor="#ff7777" class=head_black height=20>
		<td bgColor=#ff7777 align=center>เลือก</td>
		<td bgColor=#ff7777 align=center>แผ่นที่</td>
		<td bgColor=#ff7777 align=center colspan=2>รายชื่อคนแทง</td>
		<td bgColor=#ff7777 align=center>จำนวนใบ</td>
	</tr>
<%
	strSql = "SELECT     tb_open_game.game_id, sc_user.user_id, sc_user.login_id, sc_user.user_name, COUNT(tb_ticket.ticket_id) AS cnt_ticket " _
		& "FROM         tb_open_game INNER JOIN tb_ticket ON tb_open_game.game_id = tb_ticket.game_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE     (tb_open_game.game_active = 'A') " _
		& "GROUP BY tb_open_game.game_id, sc_user.user_id, sc_user.login_id, sc_user.user_name " _
		& "HAVING      (tb_open_game.game_id = " & gameid & ") order by login_id"
		objRec.Open strSql, conn, 3, 1
		if not objRec.eof then
			do while not objRec.eof
				response.write "<tr class=text_blue>"
				response.write "<td align=center><input type=checkbox name=chkselect value="&objRec("user_id")&"></td>"
				response.write "<td align=center><input type=textbox name='txtticketfrom' size=2> ถึง <input type=textbox name='txtticketto' size=2></td>"
				response.write "<td bgcolor=#ffd8cc>"&objRec("login_id")&"</td>"
				response.write "<td bgcolor=#ffd8cc>"&objRec("user_name")&"</td>"
				response.write "<td bgcolor=#ffd8cc align=center>"&objRec("cnt_ticket")&"</td>"
				response.write "</tr>"
				objRec.MoveNext
			Loop

		end if
%>
	</table>
</form>
</body>
</html>
