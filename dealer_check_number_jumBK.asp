<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
dim objRec
dim recNumType
dim recPlay
dim strSql
dim i
dim strOpen

dim num2up
dim num3up
dim num2down
dim num3down1
dim num3down2
dim num3down3
dim num3down4
Dim mode
mode=Request("mode")
	
	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNumType = Server.CreateObject ("ADODB.Recordset")
	Set recPlay = Server.CreateObject ("ADODB.Recordset")

	strOpen="�Դ�Ѻᷧ"
	if CheckGame(Session("uid"))="OPEN" then strOpen="�Դ�Ѻᷧ"

	if Request("chk1")="��Ǩ�Ţ" then
'showstr Session("gameid")
		Server.ScriptTimeout = 600		
		
		strSql="Update tb_open_game set " _
		& "up2='"&Right(Request("txt3up"),2)&"', " _
		& "up3='"&Request("txt3up")&"', " _
		& "down2='"&Request("txt2down")&"', " _
		& "down3_1='"&Request("txt3down1")&"', " _
		& "down3_2='"&Request("txt3down2")&"', " _
		& "down3_3='"&Request("txt3down3")&"', " _
		& "down3_4='"&Request("txt3down4")&"' " _
		& "Where game_id="&Session("gameid")

		comm.CommandText = StrSql
		comm.CommandType = adCmdText
		comm.Execute

		comm.CommandText = "spCheckLottoNumber(" & Session("gameid") & ", 0)"
		comm.CommandType = adCmdStoredProc
		comm.Execute

' update �� �����
		strSql="Update tb_open_game set " _
		& "up2='"&Right(Request("txt3up"),2)&"', " _
		& "up3='"&Request("txt3up")&"', " _
		& "down2='"&Request("txt2down")&"', " _
		& "down3_1='"&Request("txt3down1")&"', " _
		& "down3_2='"&Request("txt3down2")&"', " _
		& "down3_3='"&Request("txt3down3")&"', " _
		& "down3_4='"&Request("txt3down4")&"' " _
		& "Where game_id=157"
		comm.CommandText = StrSql
		comm.CommandType = adCmdText
		comm.Execute
' 157 = gameid �ͧ�觾����
		comm.CommandText = "spCheckLottoNumber(157, " & Session("gameid") & ")"
'showstr "spCheckLottoNumber(14, " & Session("gameid") & ")"
		comm.CommandType = adCmdStoredProc
		comm.Execute

		Server.ScriptTimeout = 60
	end if

	num2up="": num3up="": num2down="": num3down1="": num3down2="": num3down3="": num3down4=""
	strSql="Select * from tb_open_game where game_id="&Session("gameid")
	objRec.Open strSql, conn
	if not objRec.eof then
		num2up=objRec("up2")
		num3up=objRec("up3")
		num2down=objRec("down2")
		num3down1=objRec("down3_1")
		num3down2=objRec("down3_2")
		num3down3=objRec("down3_3")
		num3down4=objRec("down3_4")
	end if
	objRec.close
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language=Javascript>
	function print_summoney() {
			window.open("dealer_print_checknumber.asp?printtype=1", "_blank","top=0,left=0,height=500,width=800,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0");
	}

	function print_sumkeep() {
			window.open("dealer_print_checknumber.asp?printtype=2", "_blank","top=0,left=0,height=500,width=800,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0");
	}

function txt3up_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.form1.txt2down.focus();
//	}


	if(document.all.form1.txt3up.value.length==3) {
		document.all.form1.txt2down.focus();
	}
}
function txt2down_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.form1.txt3down1.focus();
//	}
	if(document.all.form1.txt2down.value.length==2) {
		document.all.form1.txt3down1.focus();
	}
}

function txt3down1_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.form1.txt3down2.focus();
//	}
	if(document.all.form1.txt3down1.value.length==3) {
		document.all.form1.txt3down2.focus();
	}
}
function txt3down2_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.form1.txt3down3.focus();
//	}
	if(document.all.form1.txt3down2.value.length==3) {
		document.all.form1.txt3down3.focus();
	}
}
function txt3down3_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.form1.txt3down4.focus();
//	}
	if(document.all.form1.txt3down3.value.length==3) {
		document.all.form1.txt3down4.focus();
	}
}
function txt3down4_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.form1.chk1.value="��Ǩ�Ţ";
		document.all.form1.submit();
	}
}
</script>
<BODY topmargin=0 leftmargin=0 onLoad="document.form1.txt3up.focus();">
	<FORM METHOD=POST ACTION="dealer_check_number.asp" name="form1">
	<input type="hidden" name="mode" value="click_submit">	
	<INPUT TYPE="hidden" name="chk1" value="">
	<TABLE  align=center class=table_blue>        	
		<tr align=center bgColor=#66CCFF  class=head_white>
			<td colspan=7 >�ѹ���&nbsp;&nbsp;&nbsp;<%=formatdatetime(now(),2)%></td>
		</tr>
		<tr align=center bgColor=#66CCFF  class=head_blue>
			<td>3 �� �͡</td>
			<td><INPUT TYPE="text" id="txt3up" NAME="txt3up" size=3 style="width:32;" maxlength=3 value="<%=num3up%>" onKeyUp="txt3up_checkkey();"></td>
			<td>2 ��ҧ �͡</td>
			<td><INPUT TYPE="text" NAME="txt2down" size=2 style="width:22;" maxlength=2 value="<%=num2down%>" onKeyUp="txt2down_checkkey();"></td>
			<td>3 ��ҧ �͡</td>
			<td><INPUT TYPE="text" NAME="txt3down1" size=3 style="width:32;" maxlength=3 value="<%=num3down1%>" onKeyUp="txt3down1_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down2" size=5 maxlength=3 style="width:32;" value="<%=num3down2%>" onKeyUp="txt3down2_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down3" size=5 maxlength=3 style="width:32;" value="<%=num3down3%>" onKeyUp="txt3down3_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down4" size=5 style="width:32;" maxlength=3 value="<%=num3down4%>" onKeyUp="txt3down4_checkkey();"></td>
			<td><input type=button onClick="document.all.form1.chk1.value='��Ǩ�Ţ'; document.all.form1.submit();" name="chk" value="��Ǩ�Ţ"></td>
		</tr>
	</table>
	</FORM>
	<br><br>
	<%
'	If mode="click_submit" then

'��Դ�Ţᷧ
dim sumAllPlay
dim sumAllPaid
dim sumOutPlay
dim sumOutPaid
dim sumAllDisc
dim sumOutDisc

dim totalAllPlay
dim totalAllPaid
dim totalOutPlay
dim totalOutPaid
dim totalAllDisc
dim totalOutDisc
		totalAllPlay=0: totalAllPaid=0
		totalOutPlay=0: totalOutPaid=0
		totalAllDisc=0: totalOutDisc=0
		strSql = "select ref_code, ref_det_desc from mt_reference_det where ref_id=8 order by ref_code"
		recNumType.open strSql,conn
		if not recNumType.Eof then
	%>
	<TABLE align=center class=table_blue>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>���ػ�ʹ�Թ</td>
			<td colspan=3>�ʹ������</td>
			<td colspan=3>ᷧ�͡</td>
			<td colspan=3>�Ѻ���</td>
		</tr>
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td >��Դ</td>
			<td >ᷧ�ѡ %</td>
			<td >�١</td>
			<td >�ط��</td>
			<td >ᷧ�ѡ %</td>
			<td >�١</td>
			<td >�ط��</td>
			<td >ᷧ�ѡ %</td>
			<td >�١</td>
			<td >�ط��</td>
		</tr>

<%
		end if

		do while not recNumType.Eof
			if recNumType("ref_code")="6" then
				response.write "<tr class=text_blue>"
				response.write "	<td bgColor=#FFFFCC>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "	<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "</tr>"
			end if
			sumAllPlay=0: sumAllPaid=0
			sumOutPlay=0: sumOutPaid=0
			sumAllDisc=0: sumOutDisc=0
			response.write "<tr class=text_blue>"
			response.write "	<td bgColor=#FFFFCC>"&recNumType("ref_det_desc")&"</td>"
'�Ţ�Ѻ������
			strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS summoney, SUM(isnull(tb_ticket_number.pay_amt,0)) AS sumpay, SUM(tb_ticket_number.discount_amt) AS sumdisc " _
				& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id " _
				& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') and (tb_ticket_number.number_status in ("&mlnNumStatusRecAll&", "&mlnNumStatusRecPart&")) " _
				& "GROUP BY tb_ticket_number.play_type " _
				& "Having play_type = "&cint(recNumType("ref_code"))

			recPlay.open strSql,conn
			if not recPlay.eof then
				if not IsNull(recPlay("summoney")) then sumAllPlay=recPlay("summoney")
				if not IsNull(recPlay("sumpay")) then 	sumAllPaid=recPlay("sumpay")
				if not IsNull(recPlay("sumdisc")) then 	sumAllDisc=recPlay("sumdisc")
				sumAllPlay = sumAllPlay - sumAllDisc
				totalAllPlay = totalAllPlay + sumAllPlay
				totalAllPaid = totalAllPaid + sumAllPaid
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(sumAllPlay,0)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(sumAllPaid,0)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((sumAllPlay-sumAllPaid),0)&"</td>"
			else
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
			end if
			recPlay.close
'�Ţᷧ�͡
			'strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS summoney, SUM(tb_ticket_number.pay_amt) AS sumpay, SUM(tb_ticket_number.discount_amt) AS sumdisc " _
			'	& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id " _
			'	& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.ref_game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') and (tb_ticket_number.number_status in ("&mlnNumStatusRecAll&", "&mlnNumStatusRecPart&")) " _
			'	& "GROUP BY tb_ticket_number.play_type " _
			'	& "Having play_type = "&cint(recNumType("ref_code"))
'	����¹�Ըա�ô֧ ᷧ�͡ ��������Ҥ�Ŵ ���� ��ͧ�Դ�ҡ�Ҥҡ�ҧ
			
			strSql = "exec spA_GetPlayOutForCheckNumber " & Session("gameid") & ", " & recNumType("ref_code")
			set recPlay = conn.Execute(strSql)
'showstr strSql
			'recPlay.open strSql,conn
			if not recPlay.eof then
				if not IsNull(recPlay("summoney")) then 	sumOutPlay=CDbl(recPlay("summoney"))  'jum CDbl
				if not IsNull(recPlay("sumpay")) then		sumOutPaid=CDbl(recPlay("sumpay"))
				if not IsNull(recPlay("sumdisc")) then 		sumOutDisc=CDbl(recPlay("sumdisc"))
				sumOutPlay = sumOutPlay - sumOutDisc
				totalOutPlay = totalOutPlay + sumOutPlay
				totalOutPaid = totalOutPaid + sumOutPaid
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(sumOutPlay,0)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(sumOutPaid,0)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((sumOutPaid-sumOutPlay),0)&"</td>"
			else
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
			end if
			recPlay.close
'�Ţ�Ѻ�Ѻ���		
			response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((sumAllPlay-sumOutPlay),0)&"</td>"
			response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((sumAllPaid-sumOutPaid),0)&"</td>"
			response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(((sumAllPlay-sumAllPaid)-(sumOutPlay-sumOutPaid)),0)&"</td>"

			response.write "</tr>"
			
			recNumType.MoveNext
		loop
		recNumType.close
		'Total
		response.write "<tr class=head_black>"
		response.write "	<td bgColor=#66CCFF align=center>���</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalAllPlay,0)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalAllPaid,0)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber((totalAllPlay-totalAllPaid),0)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalOutPlay,0)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalOutPaid,0)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber((totalOutPaid-totalOutPlay),0)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber((totalAllPlay-totalOutPlay),0)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber((totalAllPaid-totalOutPaid),0)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber((totalAllPlay-totalAllPaid)-(totalOutPlay-totalOutPaid),0)&"</td>"
		response.write "</tr>"
%>	

	</Table>
		<table align=center><tr><td align=center colspan=3><input type=button value='  �����  ' onClick="print_summoney();"></td></tr></table>
	<br><br>

<%
	strSql = "SELECT     sc_user.first_name, sc_user.user_name, sc_user.nick_name, SUM(tb_ticket_number.dealer_rec) AS summoney, SUM(tb_ticket_number.pay_amt) AS sumpay, SUM(tb_ticket_number.discount_amt) AS sumdisc, sc_user.login_id " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3)) " _
		& "GROUP BY sc_user.login_id, sc_user.first_name, sc_user.user_name, sc_user.nick_name"

	objRec.Open strSql, conn
	if  not objRec.Eof then
%>
	<TABLE width='40%' align=center class=table_blue>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>���ػ�ʹ��</td>
		</tr>
	</TABLE>
	<TABLE width='40%' align=center class=table_blue>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>�ʹ��</td>
			<td>�ʹ����</td>
			<td>�����Ţ - ����</td>
		</tr>
<%
	end if
	totalAllPlay=0: totalAllPaid=0
	do while not objRec.Eof
		sumAllPlay=0: sumAllPaid=0: sumAllDisc=0
		if not IsNull(objRec("summoney")) then sumAllPlay=objRec("summoney")
		if not IsNull(objRec("sumpay")) then sumAllPaid=objRec("sumpay")
		if not IsNull(objRec("sumdisc")) then sumAllDisc=objRec("sumdisc")
		sumAllPlay = sumAllPlay - sumAllDisc		
		Response.write "<tr class=text_black>"
		Response.write "	<td bgColor=#FFFFCC align=right>"
		if sumAllPaid < sumAllPlay then
			Response.write formatnumber((sumAllPlay- sumAllPaid),0)
			totalAllPlay = totalAllPlay + (sumAllPlay- sumAllPaid)
		else
			Response.write "0"
		end if
		Response.write "	</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"
		if sumAllPaid > sumAllPlay then
			Response.write formatnumber((sumAllPaid - sumAllPlay ),0)
			totalAllPaid = totalAllPaid + (sumAllPaid - sumAllPlay )
		else
			Response.write "0"			
		end if
		Response.write "	</td>"	
		Response.write "	<td bgColor=#E2E2E2>"&objRec("login_id")&"-"&objRec("user_name")&"</td>"	
		Response.write "</tr>"
		objRec.MoveNext
	Loop
	objRec.Close
'�ʴ���ǹ�Ѵ�͡
	strSql = "SELECT sc_user.user_name, sc_user.user_id, SUM(tb_ticket_number.dealer_rec) AS summoney, SUM(tb_ticket_number.pay_amt) AS sumpay, SUM(tb_ticket_number.discount_amt) AS sumdisc " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN tb_open_game ON tb_ticket.game_id = tb_open_game.game_id INNER JOIN sc_user ON tb_open_game.dealer_id = sc_user.user_id " _
		& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.ref_game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3)) " _
		& "GROUP BY  sc_user.user_name, sc_user.user_id "
'showstr strsql
	objRec.Open strSql, conn
	do while not objRec.Eof
		sumAllPlay=0: sumAllPaid=0: sumAllDisc=0
		if not IsNull(objRec("summoney")) then sumAllPlay=objRec("summoney")
		if not IsNull(objRec("sumpay")) then sumAllPaid=objRec("sumpay")
		if not IsNull(objRec("sumdisc")) then sumAllDisc=objRec("sumdisc")
		sumAllPlay = sumAllPlay - sumAllDisc	
'showstr "disc " & sumAllDisc
		Response.write "<tr class=text_black>"
		Response.write "	<td bgColor=#FFFFCC align=right>"
		'�ʴ���Ѻ�ѹ�����ҧ��ᷧ �Ѻᷧ�͡ �ʹ�Ѻ ��� �ʹ���� �ʹ���¤���ʹ�Ѻ
		if sumAllPaid > sumAllPlay then
			Response.write formatnumber((sumAllPaid - sumAllPlay ),0)
			totalAllPlay = totalAllPlay + (sumAllPaid - sumAllPlay )			
		else
			Response.write "0"			
		end if

		Response.write "	</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"
		if sumAllPaid < sumAllPlay then
			Response.write formatnumber((sumAllPlay- sumAllPaid),0)
			totalAllPaid = totalAllPaid + (sumAllPlay- sumAllPaid)

		else
			Response.write "0"
		end if
		Response.write "	</td>"	
		if objRec("user_id") = 999 then 
			Response.write "	<td bgColor=#E2E2E2>�����ᷧ�͡</td>"	
		else
			Response.write "	<td bgColor=#E2E2E2>ᷧ�͡ "&objRec("user_name")&"</td>"	
		end if
		Response.write "</tr>"
		objRec.MoveNext
	Loop

		Response.write "<tr class=head_black>"
		Response.write "	<td bgColor=#FFFFCC align=right>"&formatnumber(totalAllPlay,0)&"</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"&formatnumber(totalAllPaid,0)&"</td>"	
		Response.write "	<td bgColor=#E2E2E2 align=center>"&formatnumber((totalAllPlay - totalAllPaid),0)&"</td>"	
		Response.write "</tr>"

%>
	</TABLE>
	<table align=center><tr><td align=center colspan=3><input type=button value='  �����  ' onClick="print_sumkeep();"></td></tr></table>
	<%
'	End if
	%>
</body>
</html>