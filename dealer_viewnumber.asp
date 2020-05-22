<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
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
	'*** Open the database.	
	call CheckGame(Session("uid"))
	gameid=Session("gameid")
	playnum = Request("pnum")
	playtype = Request("ptype")
	numtype =  Request("numtype")
	Set objRec = Server.CreateObject ("ADODB.Recordset")
%>
<HTML>

<HEAD>
	<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="-1">
	<LINK href="include/code.css" type=text/css rel=stylesheet>
	<script language="JavaScript" src="include/normalfunc.js"></script>


</HEAD>

<BODY topmargin=0 leftmargin=0>


	<%
	sumplay=0
	sumcut=0
	if numtype <> "all" then
'		strSql = "SELECT tb_ticket_number.play_number, tb_ticket_number.play_type, tb_ticket.ref_game_id, SUM(tb_ticket_number.dealer_rec) AS playamt " _
'			& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
'			& "WHERE     (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y') " _
'			& "GROUP BY tb_ticket_number.play_number, tb_ticket_number.play_type, tb_ticket.ref_game_id " _
'			& "Having (tb_ticket_number.play_number = N'"&playnum&"') AND (tb_ticket_number.play_type = N'"&playtype&"') AND (tb_ticket.ref_game_id = "&gameid&")" 
		strSql = "SELECT     mt_reference_num.ref_number AS play_number, tb_ticket_number.play_type, tb_ticket.ref_game_id, SUM(tb_ticket_number.dealer_rec) AS playamt " _
			& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN mt_reference_num ON tb_ticket_number.play_number = mt_reference_num.real_num " _
			& "WHERE     (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y') AND (mt_reference_num.ref_code = N'"&playtype&"') AND (tb_ticket_number.play_number = N'"&playnum&"') " _
			& "GROUP BY mt_reference_num.ref_number, tb_ticket_number.play_type, tb_ticket.ref_game_id " _
			& "HAVING (tb_ticket_number.play_type = N'"&playtype&"') AND (tb_ticket.ref_game_id = "&gameid&")"
'showstr strSql
		objRec.Open strSql, conn, 3, 1
		if not objRec.eof then
			sumcut = objRec("playamt")
		end if
	objRec.Close
	end if
	'	strSql = "select tb_ticket_number.play_number, tb_ticket_number.play_type, tb_ticket.game_id, Sum(tb_ticket_number.dealer_rec) as playamt, sc_user.user_name, sc_user.login_id " _
	'		& "FROM tb_ticket_number INNER JOIN  tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
	'		& "WHERE     (tb_ticket_number.number_status IN (2, 3)) AND (tb_ticket_number.sum_flag = 'Y') " _
	'		& "GROUP BY tb_ticket_number.play_number, tb_ticket_number.play_type, tb_ticket.game_id, sc_user.user_name " _
	'		& "Having (tb_ticket_number.play_number = N'"&playnum&"') AND (tb_ticket_number.play_type = N'"&playtype&"') AND (tb_ticket.game_id = "&gameid&") ORDER BY SUM(tb_ticket_number.dealer_rec) DESC"
	strSql = "SELECT mt_reference_num.ref_number AS play_number, tb_ticket_number.play_type, tb_ticket.game_id, SUM(tb_ticket_number.dealer_rec) AS playamt, sc_user.user_name, sc_user.login_id  " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id INNER JOIN mt_reference_num ON tb_ticket_number.play_number = mt_reference_num.real_num " _
		& "WHERE (tb_ticket_number.number_status IN (2, 3)) AND (tb_ticket_number.sum_flag = 'Y') AND (mt_reference_num.ref_code = N'"&playtype&"') " _
		& "GROUP BY mt_reference_num.ref_number, tb_ticket_number.play_type, tb_ticket.game_id, sc_user.user_name, sc_user.login_id " _
		& "HAVING (tb_ticket_number.play_type = N'"&playtype&"') AND (tb_ticket.game_id = "&gameid&") AND (mt_reference_num.ref_number = N'"&playnum&"') " _
		& "ORDER BY SUM(tb_ticket_number.dealer_rec) DESC"
	objRec.Open strSql, conn
	if not objRec.eof then
%>
	<TABLE width='95%' align=center class=table_blue bgcolor=white>
		<tr align=center class=head_black>
			<td bgColor=#CCFFCC colspan=3><%=GetPlayTypeName(playtype)%>
				<%="   หมายเลข  " &objRec("play_number")%></td>
		</tr>
		<tr align=center class=head_black>
			<td bgColor=#CCFFCC>รหัส</td>
			<td bgColor=#CCFFCC>ผู้แทง</td>
			<td bgColor=#CCFFCC>จำนวนเงิน</td>
		</tr>

		<%
		do while not objRec.eof
			Response.write "<tr align=center class=head_black>"
			Response.write "<td bgColor=#CCFFFF>"&objRec("login_id")&"</td>"	
			Response.write "<td bgColor=#CCFFFF>"&objRec("user_name")&"</td>"
			Response.write "<td bgColor=#CCFFFF>"&formatnumber(objRec("playamt"),0)&"</td>"
			Response.write "</tr>"
			sumplay = sumplay + objRec("playamt")
			objRec.movenext
		loop
		'if numtype="rec" or numtype="out" then
			Response.write "<tr align=center class=head_black>"
			Response.write "<td bgColor=#CCFFFF colspan=2>แทงออก</td>"
			Response.write "<td bgColor=#CCFFFF>"&formatnumber(sumcut,0)&"</td>"
			Response.write "</tr>"
		'end if
%>
		<tr align=center class=head_black>
			<td bgColor=#CCFFCC colspan=2>รวมเงิน</td>
			<td bgColor=#CCFFCC><%=formatnumber(sumplay-sumcut,0)%></td>
		</tr>

	</TABLE>
	<%
	else
		showmessage "ไม่พบจำนวนเงินแทง !!!"
	end if
	objRec.Close
	
%>
</BODY>

</HTML>
<%
	set objRec = nothing
	set conn   = nothing	
%>