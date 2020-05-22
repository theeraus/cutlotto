<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->
<%
	'// 2009-08-20 เพิ่ม ใบขอสมาชิกรวมเข้าไปด้วย
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim dealer_id, game_id, player_id
	Dim p_name
	player_id=Request("player_id")
	game_id=Session("gameid")
	SQL="select * from sc_user where user_id=" & player_id
	Set objRS=objDB.Execute(SQL)
	If Not objRS.eof Then
		p_name=objRS("user_name")
	End if

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<TITLE> :: ยอดสรุปเป็นใบ : คนแทง :: </TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script src="include/js_function.js" language="javascript"></script>
</HEAD>

<BODY>
<iframe name="f_hidden" width="0" height="0"></iframe>
<table width="100%" cellpadding="1" cellspacing="1">
	<tr>
		<td colspan="2" class="head_blue">
			<%=p_name %>
		</td>
	<tr>
	<tr valign="top">
		<td width="50%">
			<TABLE width="100%" cellpadding="0" cellspacing="0">
			<TR class="text_black">
				<TH>ใบที่</TH>
				<TH align="right">ยอดแทง</TH>
				<TH align="right">ยอดหัก%</TH>
				<TH align="right">ยอดถูก</TH>
			</TR>
			<%
				if len(trim(Session("logid"))) <8 then
					SQL="exec spJGetSumTicketByPlayer " & player_id & ", " & game_id
				else
					SQL="exec spJGetSumTicketByPlayerLevel2 " & player_id & ", " & game_id
				end if	


'response.write SQL
				Set objRS=objDB.Execute(SQL)
				Dim cntTicket, dealer_rec, dis, pay_amt
				cntTicket=0 
				dealer_rec=0
				dis=0
				pay_amt=0
				While Not objRS.eof
				cntTicket= cntTicket +1 
				dealer_rec=dealer_rec+objRS("dealer_rec")
				dis=dis+objRS("dis")
				pay_amt=pay_amt+objRS("pay_amt")
			%>
			<TR style="height:22;">
				<TD class="text_small_u" align="center"><%=objRS("ticket_number")%></TD>
				<TD class="text_small_u" align="right"><%=FormatNumber(objRS("dealer_rec"),2)%>&nbsp;</TD>
				<TD class="text_small_u" align="right"><%=FormatNumber(objRS("dis"),2)%>&nbsp;</TD>
				<TD class="text_small_u" align="right"><%=FormatNumber(objRS("pay_amt"),2)%>&nbsp;</TD>
			</TR>
			<%
					objRS.MoveNext
				Wend
				'//ส่วนของ สมาชิก
				if len(trim(Session("logid"))) <8 Then '// แสดงเฉพาะเอเยนต์ โดยใช้ราคาของเอเยนต์
					SQL="exec spJGetSumTicketByPlayerMember " & player_id & ", " & game_id
					Set objRS=objDB.Execute(SQL)
					While Not objRS.eof
						cntTicket= cntTicket +1 
						dealer_rec=dealer_rec+objRS("dealer_rec")
						dis=dis+objRS("dis")
						pay_amt=pay_amt+objRS("pay_amt")
				%>
				<TR style="height:22;">
					<TD class="text_small_u" align="center"><%=objRS("ticket_number")%>(<%=objRS("login_id")%>)</TD>
					<TD class="text_small_u" align="right"><%=FormatNumber(objRS("dealer_rec"),2)%>&nbsp;</TD>
					<TD class="text_small_u" align="right"><%=FormatNumber(objRS("dis"),2)%>&nbsp;</TD>
					<TD class="text_small_u" align="right"><%=FormatNumber(objRS("pay_amt"),2)%>&nbsp;</TD>
				</TR>
				<%
						objRS.MoveNext
					Wend
				end if					
			%>
			</TABLE>
		</td>
		<td align="center">
			<table cellpadding="0" cellspacing="0" class="head_black" width="250">
				<tr>
					<td>รวม</td>
					<td  align="right"><%=cntTicket%>&nbsp;&nbsp;</td>
					<td>ใบ</td>
				</tr>
				<tr>
					<td>ยอดแทง</td>
					<td align="right"><%=FormatNumber(dealer_rec,2)%>&nbsp;&nbsp;</td>
					<td>บาท</td>
				</tr>
				<tr>
					<td>ยอดหัก%</td>
					<td align="right"><%=FormatNumber(dis,2)%>&nbsp;&nbsp;</td>
					<td>บาท</td>
				</tr>
				<tr>
					<td>ยอดถูก</td>
					<td align="right"><%=FormatNumber(pay_amt,2)%>&nbsp;&nbsp;</td>
					<td>บาท</td>
				</tr>
				<tr style="height:29;">
					<td><strong>สรุป</strong></td>
					<td align="right"><%=FormatNumber(dis-pay_amt,2)%>&nbsp;&nbsp;</td>
					<td>บาท</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<input type="button" style="cursor:hand;width:70" value="พิมพ์" class="btt"
			onClick="self.print();"
			>
		</td>
	</tr>
	
</table>

</BODY>
</HTML>
