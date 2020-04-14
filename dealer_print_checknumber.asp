<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
dim objRec,objRS
dim recNumType
dim recPlay
dim strSql
dim i
dim strOpen

	
	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set objRS= Server.CreateObject ("ADODB.Recordset")
	Set recNumType = Server.CreateObject ("ADODB.Recordset")
	Set recPlay = Server.CreateObject ("ADODB.Recordset")

	strOpen="เปิดรับแทง"
	if CheckGame(Session("uid"))="OPEN" then strOpen="ปิดรับแทง"


%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language=JavaScript>
function doPrint()   {  
	if(self.print)   {  
		self.print();  
		//self.close();  
		return false;  
	}  
}
</script>
<BODY topmargin=0 leftmargin=0  onLoad="doPrint();">
<%		
	if Request("printtype") = "1" then 
%>
	<br><br>
	<TABLE align=center class=table_blue width=900>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>ใบสรุปยอดเงิน</td>
			<td colspan=3>ยอดทั้งหมด</td>
			<td colspan=3>แทงออก</td>
			<td colspan=3>รับไว้</td>
		</tr>
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td >ชนิด</td>
			<td >แทงหัก %</td>
			<td >ถูก</td>
			<td >สุทธิ</td>
			<td >แทงหัก %</td>
			<td >ถูก</td>
			<td >สุทธิ</td>
			<td >แทงหัก %</td>
			<td >ถูก</td>
			<td >สุทธิ</td>
		</tr>

<%
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
			strsql = "exec spA_GetSumAmt_for_CheckNumber " & Session("gameid") & ", 'all', 0" 

'showstr strsql
			set recPlay = conn.Execute(strSql)

		strSql = "select ref_code, ref_det_desc from mt_reference_det where ref_id=8 order by ref_code"
		recNumType.open strSql,conn
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
			sumAllPlay=0.00: sumAllPaid=0.00: sumAllDisc=0.00
			sumOutPlay=0.00: sumOutPaid=0.00: sumOutDisc=0.00
			sumselfOutPlay=0.00: sumselfOutPaid=0.00: sumselfOutDisc=0.00
			response.write "<tr class=text_blue>"
			response.write "	<td bgColor=#FFFFCC>"&recNumType("ref_det_desc")&"</td>"
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

				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)))+(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))))-(((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))+(cdbl(sumOutPaid)+cdbl(sumselfOutPaid)))),2)&"</td>"
'เลขแทงออก
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(-1*(cdbl(sumOutPlay)+cdbl(sumselfOutPlay)),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((cdbl(sumOutPaid)+cdbl(sumselfOutPaid)),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber(((cdbl(sumOutPaid)+cdbl(sumselfOutPaid))-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
'เลขรับรับไว้		
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))),2)&"</td>"
				response.write "<td bgColor=#E2E2E2 align=right>"&formatnumber((((cdbl(sumAllPlay)-(cdbl(sumOutPlay)+cdbl(sumselfOutPlay))))-((cdbl(sumAllPaid)-(cdbl(sumOutPaid)+cdbl(sumselfOutPaid))))),2)&"</td>"
				recPlay.Movenext
				end if
			else
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"				
				response.write "<td bgColor=#E2E2E2>&nbsp;</td>"
			end if
			response.write "</tr>"
			recNumType.MoveNext
		loop
		recNumType.close
		recPlay.close
		'Total
		response.write "<tr class=head_black>"
		response.write "	<td bgColor=#66CCFF align=center>รวม</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalAllPlay,2)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalAllPaid,2)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalAllDisc,2)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalOutPlay,2)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalOutPaid,2)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalOutDisc,2)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalselfOutPlay,2)&"</td>"
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalselfOutPaid,2)&"</td>"				
		response.write "	<td bgColor=#66CCFF align=right>"&formatnumber(totalselfOutDisc,2)&"</td>"
		response.write "</tr>"
%>	
	</Table>

	<br><br>
<%
	elseif Request("printtype") = "2" then 
%>

	<TABLE width='650' align=center class=table_blue>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>ใบสรุปยอดเก็บ</td>
		</tr>
	</TABLE>
	<TABLE width='650' align=center class=table_blue>        
		<tr bgColor=#66CCFF  class=head_black align=center>
			<td>ยอดเก็บ</td>
			<td>ยอดจ่าย</td>
			<td>หมายเลข - ชื่อ</td>
		</tr>
<%
'JUM 2008-03-03
'	strSql = "SELECT sc_user.first_name, sc_user.user_name, sc_user.nick_name, SUM(round(tb_ticket_number.dealer_rec,2)) AS summoney, SUM(round(tb_ticket_number.pay_amt,2)) AS sumpay, SUM(round(tb_ticket_number.discount_amt,2)) AS sumdisc, sc_user.login_id " _
'		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
'		& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3, 5)) " _
'		& "GROUP BY sc_user.login_id, sc_user.first_name, sc_user.user_name, sc_user.nick_name order by case when isnumeric(login_id)=1 then cast(login_id as int) else login_id end"																																											 
	strSql = "SELECT sc_user.first_name, sc_user.user_name, sc_user.nick_name, SUM(round(tb_ticket_number.dealer_rec,2)) AS summoney, SUM(round(tb_ticket_number.pay_amt,2)) AS sumpay, SUM(round(tb_ticket_number.discount_amt,2)) AS sumdisc, sc_user.login_id " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE  (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3, 5)) " _
		& "GROUP BY sc_user.login_id, sc_user.first_name, sc_user.user_name, sc_user.nick_name order by case when isnumeric(login_id)=1 then cast(login_id as int) else login_id end"																																											 

'************************************
dim Jgame_type,SQL
SQL="select * from tb_open_game where game_id=" & Session("gameid")
set objRS=conn.Execute(SQL)
if not objRS.eof then Jgame_type=objRS("game_type")

strSql =" SELECT sc_user.first_name, sc_user.user_name, sc_user.nick_name, "
strSql =strSql  & " SUM((tb_ticket_number.dealer_rec)) AS summoney, "
strSql =strSql  & " SUM((tb_ticket_number.pay_amt)) AS sumpay, "
strSql =strSql  & " SUM((tb_ticket_number.discount_amt)) AS sumdiscO, sc_user.login_id , "
strSql =strSql  & " sum(tb_ticket_number.dealer_rec*(d.discount_amt/100)	)	as sumdisc "
strSql =strSql  & " FROM tb_ticket_number INNER JOIN  "
strSql =strSql  & " tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN  "
strSql =strSql  & " tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN  "
strSql =strSql  & " sc_user ON tb_ticket.player_id = sc_user.user_id  "
strSql =strSql  & " inner join tb_price_player d on d.game_type=" & Jgame_type
strSql =strSql  & " 	and d.player_id=tb_ticket.player_id and d.play_type=tb_ticket_number.play_type "
strSql =strSql  & " 	and d.dealer_id=sc_user.create_by "
strSql =strSql  & " WHERE (tb_ticket.game_id = " & Session("gameid") & ")"
strSql =strSql  & " AND (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket_number.number_status IN (2, 3,5)) "
strSql =strSql  & " GROUP BY sc_user.login_id, sc_user.first_name, sc_user.user_name, sc_user.nick_name order by  "
strSql =strSql  & " login_id "


'**************** JUM 2008-03-18 *******
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
		Response.write "	<td bgColor=#FFFFCC align=right>"
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
		Response.write "	<td bgColor=#FFFFCC align=right>"
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
		Response.write "	<td bgColor=#FFFFCC align=right>"&formatnumber(totalAllPlay,2)&"</td>"	
		Response.write "	<td bgColor=#CCFFCC align=right>"&formatnumber(totalAllPaid,2)&"</td>"	
		Response.write "	<td bgColor=#E2E2E2 align=center>"&formatnumber((totalAllPlay - totalAllPaid),2)&"</td>"	
		Response.write "</tr>"

%>
	</TABLE>
	<table align=center><tr><td align=center colspan=3><input type=button value='  พิมพ์  ' onClick="print_sumkeep();"></td></tr></table>
	<%
	End if
	%>

</body>
</html>