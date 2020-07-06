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
dim objRec
dim recNumType
dim recPlay
dim strSql, sql2
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
Dim isCalculate 
isCalculate = false
mode=Request("mode")
	
	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNumType = Server.CreateObject ("ADODB.Recordset")
	Set recPlay = Server.CreateObject ("ADODB.Recordset")

	strOpen="เปิดรับแทง"
	if CheckGame(Session("uid"))="OPEN" then strOpen="ปิดรับแทง"

	sql2 = "select* from tb_usercredit where game_id=" & Session("gameid") 
	objRec.Open sql2, conn
	if not objRec.eof then
		isCalculate = true
	end if
	objRec.close

	if Request("chk1")="ตรวจเลข" then
		Server.ScriptTimeout = 2400		
		'jum เพิ่มให้เก็บจำนวนเงิน 2008-12-08
		strSql = "exec spA_CheckDealorCredit " & Session("uid") & ", " & Session("gameid") 
		objRec.Open strSql, conn
		if not objRec.eof then
			if objRec("overlimit") = "yes" then
				response.redirect("notify_notcredit.asp")
				response.end
			end if
		end if
		objRec.close

		conn.Execute(strSql)	
		'jum เพิ่มให้เก็บจำนวนเงิน 2008-12-08
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
		Dim Client_IP
		Client_IP=Request.ServerVariables("REMOTE_ADDR") 
		comm.CommandText = "spCheckLottoNumber(" & Session("gameid") & ", 0,'" & Client_IP & "' )"
'response.write "spCheckLottoNumber(" & Session("gameid") & ", 0)"
'response.end
		comm.CommandType = adCmdStoredProc
		comm.Execute

' update ส่ง พิมพ์
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
' 157 = gameid ของส่งพิมพ์

' ไม่คิดแล้วคิดรวมกับข้างบนเลย
'		comm.CommandText = "spCheckLottoNumber(157, " & Session("gameid") & ")"
'		comm.CommandType = adCmdStoredProc
'		comm.Execute

		Server.ScriptTimeout = 60
'	Else
'		strSql = "exec spA_ChangePasswordOverLimit " &  Session("uid") & ", " & Session("gameid") 
'		set recPlay = conn.Execute(strSql)
	end if   ' ตรวจเลข

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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>


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
		document.all.form1.chk1.value="ตรวจเลข";
		document.all.form1.submit();
	}
}
</script>
    <style type="text/css">
        .auto-style1 {
            color: #009900;
        }
        .auto-style2 {
            color: #FF0000;
        }
        .auto-style3 {
            width: 31px;
        }
    </style>

<BODY topmargin=0 leftmargin=0 onLoad="document.form1.txt3up.focus();">
	<% if isCalculate= false then %>
	<br>
		<CENTER><FONT SIZE="+1" COLOR="#FF0000"><B>กรุณาตรวจสอบข้อมูลให้ถูกต้องก่อนการตรวจเลข</B></FONT></CENTER>
	<br>
	<% else %>
		<CENTER><FONT SIZE="+1" COLOR="green"><B>ออกผลรางวัลแล้ว</B></FONT></CENTER>
	<% end if %>
	<FORM METHOD=POST ACTION="dealer_check_number.asp" name="form1">
	<input type="hidden" name="mode" value="click_submit">	
	<INPUT TYPE="hidden" name="chk1" id="chk1" value="">
	<TABLE  align=center class="table" width="55%">        	
		<tr align=center bgColor=red  class=head_white>
			<td colspan=7 >วันที่&nbsp;&nbsp;&nbsp;<%=formatdatetime(now(),2)%></td>
		</tr>
		<tr align=center bgColor=#ffd8cc>
			<td class="auto-style1"><strong>3 บน ออก</strong></td>
			<td><INPUT TYPE="text" id="txt3up" NAME="txt3up" size=3 style="width:32;" maxlength=3 value="<%=num3up%>" onKeyUp="txt3up_checkkey();"></td>
			<td class="auto-style2"><strong>2 ล่าง ออก</strong></td>
			<td><INPUT TYPE="text" NAME="txt2down" size=2 style="width:22;" maxlength=2 value="<%=num2down%>" onKeyUp="txt2down_checkkey();"></td>
			<td class="auto-style2"><strong>3 ล่าง ออก</strong></td>
			<td><INPUT TYPE="text" NAME="txt3down1" size=3 style="width:32;" maxlength=3 value="<%=num3down1%>" onKeyUp="txt3down1_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down2" size=5 maxlength=3 style="width:32;" value="<%=num3down2%>" onKeyUp="txt3down2_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down3" size=5 maxlength=3 style="width:32;" value="<%=num3down3%>" onKeyUp="txt3down3_checkkey();">&nbsp;<INPUT TYPE="text" NAME="txt3down4" size=5 style="width:32;" maxlength=3 value="<%=num3down4%>" onKeyUp="txt3down4_checkkey();"></td>
			<td></td>
		</tr>
	</table>
	<div style="text-align: center;">
		<input type="button" class="btn btn-primary" id="calculate_lotto"  
		   <% if isCalculate=true then %> disabled <% end if %>
		   style="cursor:hand; width: 205px;" name="chk" value="ตรวจเลข">
	</div>
	</FORM>

	<%
'	If mode="click_submit" then

'ชนิดเลขแทง
dim sumAllPlay
dim sumAllPaid
dim sumAllDisc
dim sumOutPlay
dim sumOutPaid
dim sumOutDisc
dim sumselfOutPlay
dim sumselfOutPaid
dim sumselfOutDisc
Dim totalRec

dim totalAllPlay
dim totalAllPaid
dim totalAllDisc
dim totalOutPlay
dim totalOutPaid
dim totalOutDisc
dim totalselfOutPlay
dim totalselfOutPaid
dim totalselfOutDisc

		totalAllPlay=0: totalAllPaid=0: totalAllDisc=0
		totalOutPlay=0: totalOutPaid=0: totalOutDisc=0
		totalselfOutPlay=0: totalselfOutPaid=0: totalselfOutDisc=0
		totalRec = 0

		strsql = "exec spA_UpdateDiscount_for_CheckNumber " & Session("gameid") 
'showstr strsql
		set recPlay = conn.Execute(strSql)

		strSql = "select ref_code, ref_det_desc from mt_reference_det where ref_id=8 order by ref_code"
		recNumType.open strSql,conn
		if not recNumType.Eof then
	%>
	<TABLE align=center class="table" width ="65%">        
		<tr bgColor=#ff7777  class=head_black align=center>
			<td>ใบสรุปยอดเงิน</td>
			<td colspan=3>ยอดทั้งหมด</td>
			<td colspan=3>แทงออก</td>
			<td colspan=3>รับไว้</td>
		</tr>
		<tr bgColor=#ffd8cc  class=head_black align=center>
			<td >ชนิด</td>
			<td >แทงหัก %</td>
			<td class="auto-style3" >ถูก</td>
			<td >สุทธิ</td>
			<td >แทงหัก %</td>
			<td >ถูก</td>
			<td >สุทธิ</td>
			<td >แทงหัก %</td>
			<td >ถูก</td>
			<td >สุทธิ</td>
		</tr>

<%
		end if
		strsql = "exec spA_GetSumAmt_for_CheckNumber " & Session("gameid") & ", 'all',0" 
'showstr strsql
		set recPlay = conn.Execute(strSql)

		do while not recNumType.Eof
			if recNumType("ref_code")="6" then
				response.write "<tr class=text_blue>"
				response.write "	<td bgColor=#ffcccc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "	<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "</tr>"
			end if
			sumAllPlay=0.00: sumAllPaid=0.00: sumAllDisc=0.00
			sumOutPlay=0.00: sumOutPaid=0.00: sumOutDisc=0.00
			sumselfOutPlay=0.00: sumselfOutPaid=0.00: sumselfOutDisc=0.00
			response.write "<tr class=text_blue>"
			response.write "	<td bgColor=#ffcccc>"&recNumType("ref_det_desc")&"</td>"
'เลขรับทั้งหมด
			if not recPlay.eof then
				if recPlay("play_type") = recNumType("ref_code")   then
				if not IsNull(recPlay("sum_rec")) then sumAllPlay=recPlay("sum_rec")
				if not IsNull(recPlay("sum_rec_pay")) then 	sumAllPaid=recPlay("sum_rec_pay")
				if not IsNull(recPlay("sum_rec_disc")) then 	sumAllDisc=recPlay("sum_rec_disc")
				if not IsNull(recPlay("sum_out")) then sumOutPlay=recPlay("sum_out")
				if not IsNull(recPlay("sum_out_pay")) then 	sumOutPaid=recPlay("sum_out_pay")
				if not IsNull(recPlay("sum_out_disc")) then 	sumOutDisc=recPlay("sum_out_disc")
				if not IsNull(recPlay("sum_selfout")) then sumselfOutPlay=recPlay("sum_selfout")
				if not IsNull(recPlay("sum_selfout_pay")) then 	sumselfOutPaid=recPlay("sum_selfout_pay")
				if not IsNull(recPlay("sum_selfout_disc")) then 	sumselfOutDisc=recPlay("sum_selfout_disc")
				totalRec = totalRec + cdbl(sumAllPlay)
				sumAllPlay = cdbl(sumAllPlay) - cdbl(sumAllDisc)
				sumOutPlay =cdbl( sumOutPlay) - cdbl(sumOutDisc)
				sumselfOutPlay = cdbl(sumselfOutPlay) -cdbl(sumselfOutDisc)
				'response.write sumAllPlay & "<br>" & strSql
'on error resume next
				totalAllPlay=totalAllPlay + round((((cdbl(sumAllPlay))-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)
				totalAllPaid=totalAllPaid + round((((cdbl(sumAllPaid))-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)
				totalAllDisc=totalAllDisc + round((((cdbl(sumAllPlay))-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))-(((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))),2)

				totalOutPlay=totalOutPlay + round(-1*(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)),2)
				totalOutPaid=totalOutPaid + round((cdbl(sumOutPaid)+cdbl(sumselfOutPaid)),2)
				totalOutDisc=totalOutDisc + round(((cdbl(sumOutPaid)+cdbl(sumselfOutPaid))-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)

				totalselfOutPlay=totalselfOutPlay  + round((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)
				totalselfOutPaid=totalselfOutPaid + round((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)
				totalselfOutDisc=totalselfOutDisc + round((((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))))-((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))))),2)
'if err <> 0 then
'showstr "Error sum number"
'end if
'	on error goto 0

				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber(((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber(((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber((((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))))-(((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))),2)&"</td>"
'เลขแทงออก
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber(-1*(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber((cdbl(sumOutPaid)+cdbl(sumselfOutPaid)),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber(((cdbl(sumOutPaid)+cdbl(sumselfOutPaid))-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
'เลขรับรับไว้		
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)&"</td>"
				response.write "<td bgColor=#ffd8cc align=right>"&formatnumber((((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))))-((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))))),2)&"</td>"
				recPlay.MoveNext
				end if ' ถ้า play_type เดียวกัน
			else
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"				
				response.write "<td bgColor=#ffd8cc>&nbsp;</td>"
			end if
			response.write "</tr>"
			recNumType.MoveNext

		loop
		recNumType.close
		recPlay.close
		'Total
		response.write "<tr class=head_black>"
		response.write "	<td bgColor=#ff7777 align=center>Total</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalAllPlay,2)&"</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalAllPaid,2)&"</td>"				
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalAllDisc,2)&"</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalOutPlay,2)&"</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalOutPaid,2)&"</td>"				
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalOutDisc,2)&"</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalselfOutPlay,2)&"</td>"
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalselfOutPaid,2)&"</td>"				
		response.write "	<td bgColor=#ff7777 align=right>"&formatnumber(totalselfOutDisc,2)&"</td>"
		response.write "</tr>"
%>	

	</Table>
		<table align=center><tr><td align=center colspan=3><input type=button class="btn btn-warning btn-sm" value='พิมพ์' style="cursor:hand; width: 75px;" onClick="print_summoney();">&nbsp;&nbsp;<input type=button class="btn btn-danger btn-sm" value='ใบสรุปยอดเก็บ' style="cursor:hand; width: 120px;" onClick="print_sumkeep();"></td></tr></table>
	<br><br>

<%	if 1 = 0 then %>
	<TABLE width='50%' align=center class=table_red>        
		<tr bgColor=#ff7777  class=head_black align=center>
			<td>ใบสรุปยอดเก็บ</td>
		</tr>
	</TABLE>
	<TABLE width='50%' align=center class=table_red>        
		<tr bgColor=#ffd8cc  class=head_black align=center>
			<td>ยอดเก็บ</td>
			<td>ยอดจ่าย</td>
			<td>หมายเลข - ชื่อ</td>
		</tr>

<%
	strSql = "SELECT sc_user.first_name, sc_user.user_name, sc_user.nick_name, SUM(round(tb_ticket_number.dealer_rec,2)) AS summoney, SUM(round(tb_ticket_number.pay_amt,2)) AS sumpay, SUM(round(tb_ticket_number.discount_amt,2)) AS sumdisc, sc_user.login_id " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3, 5)) " _
		& "GROUP BY sc_user.login_id, sc_user.first_name, sc_user.user_name, sc_user.nick_name order by case when isnumeric(login_id)=1 then cast(login_id as int) else login_id end"																																											 
'showstr strsql
	objRec.Open strSql, conn
	if  not objRec.Eof then
%>
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
		Response.write "	<td bgColor=#ffcccc align=right>"
		if sumAllPaid < sumAllPlay then
			Response.write formatnumber((sumAllPlay- sumAllPaid),2)
			totalAllPlay = totalAllPlay + (sumAllPlay- sumAllPaid)
		else
			Response.write "0"
		end if
		Response.write "	</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"
		if sumAllPaid > sumAllPlay then
			Response.write formatnumber((sumAllPaid - sumAllPlay ),2)
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
'แสดงส่วนตัดออก
	strSql = "SELECT sc_user.user_name, sc_user.user_id, SUM(round(tb_ticket_number.dealer_rec,2)) AS summoney, SUM(round(tb_ticket_number.pay_amt,2)) AS sumpay, SUM(round(tb_ticket_number.discount_amt,2)) AS sumdisc, sc_user.login_id  " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN tb_open_game ON tb_ticket.game_id = tb_open_game.game_id INNER JOIN sc_user ON tb_open_game.dealer_id = sc_user.user_id " _
		& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.ref_game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') " _
		& "GROUP BY  sc_user.user_name, sc_user.user_id, sc_user.login_id " _
		& " Order by right('0000000000' + login_id,10) "
		
		'& " order by case when isnumeric(login_id) = 1 then convert(int,login_id) else login_id end "
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
		Response.write "	<td bgColor=#ffcccc align=right>"
		'แสดงสลับกันระหว่างคนแทง กับแทงออก ยอดรับ คือ ยอดจ่าย ยอดจ่ายคือยอดรับ
		if sumAllPaid > sumAllPlay then
			Response.write formatnumber((sumAllPaid - sumAllPlay ),2)
			totalAllPlay = totalAllPlay + (sumAllPaid - sumAllPlay )			
		else
			Response.write "0"			
		end if

		Response.write "	</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"
		if sumAllPaid < sumAllPlay then
			Response.write formatnumber((sumAllPlay- sumAllPaid),2)
			totalAllPaid = totalAllPaid + (sumAllPlay- sumAllPaid)

		else
			Response.write "0"
		end if
		Response.write "	</td>"	
		if objRec("user_id") = 999 then 
			Response.write "	<td bgColor=#E2E2E2>พิมพ์แทงออก</td>"	
		else
			Response.write "	<td bgColor=#E2E2E2>แทงออก "&objRec("user_name")&"</td>"	
		end if
		Response.write "</tr>"
		objRec.MoveNext
	Loop
		objRec.Close
		Response.write "<tr class=head_black>"
		Response.write "	<td bgColor=#ffcccc align=right>"&formatnumber(totalAllPlay,2)&"</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"&formatnumber(totalAllPaid,2)&"</td>"	
		Response.write "	<td bgColor=#E2E2E2 align=center>"&formatnumber((totalAllPlay - totalAllPaid),2)&"</td>"	
		Response.write "</tr>"

%>
	</TABLE>
	<table align=center><tr><td align=center colspan=3><input type=button class="btn btn-warning btn-sm" value='พิมพ์' style="cursor:hand; width: 75px;" onClick="print_sumkeep();"></td></tr></table>
	<%
	End if   ' 1 = 0
	%>


	<script>
		$("#calculate_lotto").click(function(){
			$.confirm({
			title: 'กรุณายืนยันการตรวจเลขหวย!',
			content: 'โปรดทราบว่าเมื่อคุณกดตรวจเลขแล้วระบบจะทำการหักเครดิตในระบบของคุณตามเงื่อนไขการคิดค่าบริการ และเมื่อคุณกดตรวจเลขแล้วจะไม่สามารถกดซ้ำได้อีกในหวยงวดนั้นๆ',
			buttons: {
				ยืนยัน: function () {
					document.all.form1.chk1.value='ตรวจเลข'; 
					document.all.form1.submit();
				},
				ยกเลิก: function () {}
				}
			});
		});
	</script>
</body>
</html>