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
'*********************************************
' 18/10/06		Anon แก้ ทั้งหน้า ลบ tb_ticket.ticket_status = 'A'   ออกทั้งหมด 
' tb_ticket จะไม่มี status = 'D' แล้ว เพราะ จะลบออกไปจริงเลย ส่วนที่ status = 'D' จะมีเฉพาะที่ มี ref_game_id <> null  เป็นการส่งมาจากเจ้ามืออื่น
'*********************************************
Dim objRec
dim recPlayer
dim recNum
Dim strSql
Dim cntApp
dim chkRow
dim strdel
dim strTmp
dim ticketnumber
dim pretid, player_name, player_id
Dim game_type
'jum 20060509
Dim ticket_id
game_type=1 
Dim call_from
call_from = "view"  'อนนท์ เพิ่ม ไว้ตรวจสอบตอนส่งค่า ตอนเลือก palyer

	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNum = Server.CreateObject ("ADODB.Recordset")
	Set recPlayer = Server.CreateObject ("ADODB.Recordset")
'response.write	Request("cmbplayer") & "***" & Session("p2pid")
	if trim(Request("cmbplayer"))<>trim(Session("p2pid")) then Session("p2pid")=Request("cmbplayer")
	
	player_name = Request("player_name")
	strSql = "select user_id,login_id, user_name from sc_user where user_type='P' and create_by=" & Session("uid")

	recPlayer.Open strSql, conn
	if not recPlayer.eof then
		if Session("p2pid")="" then 
			Session("p2pid")=recPlayer("user_id")
			player_name=rtrim(ltrim(recPlayer("login_id"))) & " " & rtrim(ltrim(recPlayer("user_name")))
		end if
	end if
	recPlayer.close
	'--jum 
	Dim game_id
	game_id=Session("gameid")
	if trim(Request("tid"))="" then 
		ticketnumber=GetTicket_Number(Session("p2pid"),game_id) ' 1 jum 20060509
	else
		ticketnumber=cdbl(Request("tid"))
	end If
	
'	do while not recPlayer.eof
'		response.write recPlayer("user_id")&"-*-"&Session("p2pid")&"<br>"
'		response.write selected(recPlayer("user_id"),Session("p2pid"))&"<br>"
'		recPlayer.movenext
'	loop
	
%>
<HTML>

<HEAD>
	<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
	<meta http-equiv="content-type" content="text/html; charset=utf-8">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="-1">

	<script src="include/js_function.js" language="javascript"></script>
	<script language="JavaScript" src="include/normalfunc.js"></script>
	<script language="JavaScript" src="include/dialog.js"></script>

	<link href="include/code.css" rel="stylesheet" type="text/css" />
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	<script language="JavaScript">
		function chkKey() {
			if (document.all) {
				kc = event.keyCode; // IE
			} else {
				kc = e.which; // NS or Others
			}
			// ค่า kc คือค่า Unicode Charactor ที่เป็นตัวเลข

			if (kc == '113') { //F2
				SearchPlayer();
			}

		}

		function SearchPlayer() {

			openDialog(
				'search_player_bydealer.asp?dealer_id=<%=Session("uid")%>&game_type=<%=game_type%>&call_from=<%=call_from%>',
				8, 5, 250, 650);
		}


		function showsum(showtype, ticketid) {
			window.open("dealer_showsum.asp?showtype=" + showtype + "&tid=" + ticketid, "_blank",
				"top=150,left=0,height=250,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0"
			);
		}

		function print_ticket(player) {
			var tkf, tkt
			if ((document.all.form1.tkfrom.value) == "") {
				alert("กรุณาระเลขที่ใบที่ต้องการพิมพ์ !!!");
				document.all.form1.tkfrom.focus();
				exit();
			}
			tkf = document.all.form1.tkfrom.value;
			tkt = document.all.form1.tkto.value;
			window.open("dealer_save_ticket.asp?printtype=printticket&selecttype=select&player=" + player + "&ticket=" + tkf +
				"," + tkt, "_blank",
				"top=20,left=20,height=760,width=1030,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0"
			);
		}

		function selectedplayer() {
			document.form1.submit();
		}
	</script>
	<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
		document.onkeydown = chkKey
		window.focus();
	</SCRIPT>

	<script language="javascript">
		function gototicket(totid) {
			document.form1.tid.value = totid
			document.form1.submit();
		}

		function cmbplayer_onChange() {
			document.form1.submit()
		}
	</script>

	<SCRIPT LANGUAGE="VBScript">
		sub gototicket(totid)
		form1.tid.value = totid
		form1.submit()
		end sub

		sub cmbplayer_onChange()
		form1.submit()
		end sub
	</script>

</HEAD>

<BODY topmargin=0 leftmargin=0>
	<%


dim sumall
dim sumticket
dim typenum1, typenum2, typenum3, typenum4, typenum5, typenum6, typenum7, typenum8
dim strOpen
dim strOrder

	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	' jum เอาเลขที่คืนทั้งใบมาแสดงด้วย แต่ให้ตัวเลขเป็นสีแดง
	strSql = "SELECT SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE (tb_ticket.game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status in (2,3))  and (tb_ticket.player_id=" & Session("p2pid") & ") AND (sum_flag = 'Y')  "
    'response.write(strSql)
	objRec.Open strSql, conn
	if not objRec.eof then
		sumall=objRec("sum_amt")
	end if
	objRec.Close
'		do while not objRec.eof
'			'if objRec("play_type")=1 then
'			select case objRec("play_type")				
'				case 1
'					typenum1 = objRec("sum_amt")
'				case 2
'					typenum2 = objRec("sum_amt")
'				case 3
'					typenum3 = objRec("sum_amt")
'				case 4
'					typenum4 = objRec("sum_amt")
'				case 5
'					typenum5 = objRec("sum_amt")
'				case 6
'					typenum6 = objRec("sum_amt")
'				case 7
'					typenum7 = objRec("sum_amt")
'				case 8
'					typenum8 = objRec("sum_amt")
'			end select
'			sumall=sumall + objRec("sum_amt")
'			objRec.movenext
'		loop
'	end if


%>
	<!-- 	<TABLE width='95%' align=center class=table_blue>        	
		<tr align=center class=head_white>
			<td>&nbsp;</td>
			<td bgColor=#66CCFF>ยอดแทง</td>
			<td bgColor=red>2 บน</td>
			<td bgColor=black>3 บน</td>
			<td bgColor=red>3 โต๊ด</td>
			<td bgColor=black>2 โต๊ด</td>
			<td bgColor=red>วิ่งบน</td>
			<td bgColor=black>วิ่งล่าง</td>
			<td bgColor=red>2 ล่าง</td>
			<td bgColor=black>3 ล่าง</td>
		</tr>
		<tr align=center bgColor=#66CCFF  class=head_black>
			<td>ทั้งหมด</td>
			<td><%=sumall%></td>
			<td><%=typenum1%></td>
			<td><%=typenum2%></td>
			<td><%=typenum3%></td>
			<td><%=typenum4%></td>
			<td><%=typenum5%></td>
			<td><%=typenum6%></td>
			<td><%=typenum7%></td>
			<td><%=typenum8%></td>
		</tr> -->
	<%
'	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	
	strSql = "SELECT tb_ticket.ticket_id,SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE (tb_ticket.game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status in (2, 3) ) and (tb_ticket.player_id=" &Session("p2pid")& ") and (tb_ticket.ticket_number="&ticketnumber&") AND (sum_flag = 'Y') " _
		& "  and ( isnull(cut_type,0) in (0,1,2))  group by tb_ticket.ticket_id "
' anon แก้กลับแล้ว  old JUM 20080204		& "  and ( isnull(cut_type,0)=0 or isnull(cut_type,0)=1)  group by tb_ticket.ticket_id "

'showstr strSql
	objRec.Open strSql, conn
	if not objRec.eof then
		if not isnull(objRec("sum_amt")) then
			sumticket=objRec("sum_amt")
			ticket_id=objRec("ticket_id") ' jum
		else
			sumticket=0		
		end if
	end if
	objRec.Close

'		do while not objRec.eof
'			'if objRec("play_type")=1 then
'			select case objRec("play_type")				
'				case 1
'					typenum1 = objRec("sum_amt")
'				case 2
'					typenum2 = objRec("sum_amt")
'				case 3
'					typenum3 = objRec("sum_amt")
'				case 4
'					typenum4 = objRec("sum_amt")
'				case 5
'					typenum5 = objRec("sum_amt")
'				case 6
'					typenum6 = objRec("sum_amt")
'				case 7
'					typenum7 = objRec("sum_amt")
'				case 8
'					typenum8 = objRec("sum_amt")
'			end select
'			sumall=sumall + objRec("sum_amt")
'			objRec.movenext
'		loop
'	end if

%>
	<!-- 		<tr align=center bgColor=#66CCFF  class=head_black>
			<td>โพยปัจจุบัน ใบที่&nbsp;:&nbsp;<%=ticketnumber%> </td>
			<td><%=sumall%></td>
			<td><%=typenum1%></td>
			<td><%=typenum2%></td>
			<td><%=typenum3%></td>
			<td><%=typenum4%></td>
			<td><%=typenum5%></td>
			<td><%=typenum6%></td>
			<td><%=typenum7%></td>
			<td><%=typenum8%></td>
		</tr> -->
	<%

%>
	<TABLE border=0 align="center">
		<tr valign="top">
			<td>
				<TABLE width=890 align=center border="0">
					<tr>
						<td valign=top bgcolor=#ffffff width=150>
							<!-- column แรก เมนู -->
							<form name="form1" action="dealer_ticket.asp" method="post">
								<input type=hidden name=tid>
								<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>
									<tr>
										<td align="left" class="tdbody" nowrap>
											<br>
											<input type="hidden" name="player_id" value="<%=player_id%>">
											<input type="hidden" name="cmbplayer" value="<%=Session("p2pid")%>">
											<!--
							ชื่อคนแทง
							-->
											<input type="text" class="btn btn-primary" name="player_name" size="14"
												readonly="true" style="width:100%;" value="<%=player_name%>"
												style="cursor:hand;" onClick="SearchPlayer();" />
										</td>
										<!-- 						<td class=head_blue>คนแทง&nbsp;<SELECT NAME="cmbplayer">
<%
'						if not recPlayer.eof then
'							do while not recPlayer.eof
'								response.write "<option value='"&recPlayer("user_id")&"' "&selected(recPlayer("user_id"),Session("p2pid"))&">"&recPlayer("user_name")&"</option>"
'								recPlayer.movenext
'							loop
'						end if

%>
										</SELECT>
						</td> -->
									</tr>
									<tr>
										<td height=100 align="center">
											<table border="0">
												<tr>
													<td><input type="button" class="btn btn-warning" value="คืนทั้งใบ"
															style="cursor:hand; width: 75px;"
															onClick="click_ret_all('<%=ticket_id%>')">
													</td>
												</tr>
												<tr>
													<td><input type="button" class="btn btn-warning" value="แก้ไข"
															style="cursor:hand; width: 75px;"
															onClick="click_edit('<%=ticket_id%>')">
													</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td valign=top>
											<%							' สรุปจำนวนโพย
dim cntall
dim cntrec
dim cntwait
dim cntreject
	cntall=0: cntrec=0: cntwait=0: cntreject=0
							strSql = "SELECT game_id, player_id, rec_status, COUNT(ticket_number) AS cntticket " _
								& "FROM tb_ticket Where rec_status>0  GROUP BY game_id, player_id, rec_status " _
								& "HAVING (game_id = "&Session("gameid")&") AND (player_id = "&Session("p2pid")&")"
'response.write strSql 
							objRec.Open strSql, conn
							do while not objRec.eof
								select case objRec("rec_status")
									case 1
										cntwait=objRec("cntticket")
									case 2
										cntrec=cntrec+objRec("cntticket")
									case 3
										cntrec=cntrec+objRec("cntticket")
									case 4
										'cntreject=objRec("cntticket")
										'jum comment แก้ 2006-06-28
								end Select
								If CInt(objRec("rec_status"))=CInt(3) Or CInt(objRec("rec_status"))=CInt(4) Then
									cntreject=cntreject+objRec("cntticket")
								End if
								cntall=cntall+objRec("cntticket")
								objRec.movenext
							loop
							objRec.close
%>
											<TABLE class="table" cellSpacing=1 cellPadding=0 border=0 align=center
												width=200 bgcolor=#ffd8cc>
												<tr class=text_black>
													<td align=right width="50%">ส่ง&nbsp;</td>
													<td width=10>=</td>
													<td>&nbsp;<%=cntall%></td>
												</tr>
												<tr class=text_black>
													<td align=right>รับแล้ว&nbsp;</td>
													<td>=</td>
													<td>&nbsp;<%=cntrec%></td>
												</tr>
												<tr class=text_black>
													<td align=right>รอรับ&nbsp;</td>
													<td>=</td>
													<td>&nbsp;<%=cntwait%></td>
												</tr>
												<tr class=text_black>
													<td align=right>เลขคืน&nbsp;</td>
													<td>=</td>
													<td>&nbsp;<%=cntreject%></td>
												</tr>
												<tr class=textbig_red>
													<td align=center bgcolor=#ff9999 colspan=3
														onMouseOver="changeStyle(this,'textbig_red_over')"
														onMouseOut="changeStyle(this,'textbig_red')"
														style="cursor:hand;"><a href="#"
															onClick="showsum('all',0)">ยอดแทงรวม</a></td>
												</tr>
												<%	if sumall > 0 then %>
												<tr class=textbig_red>
													<td align=center bgcolor=#ff9999 colspan=3><a href="#"
															onClick="showsum('all',0)"><%=formatnumber(sumall,0)%></a>
													</td>
												</tr>
												<%	else %>
												<tr class=textbig_red>
													<td align=center bgcolor="#ff9999" colspan=3><a href="#"
															onClick="showsum('all',0)"><%=0%></a></td>
												</tr>
												<%	end if %>
												<tr class=text_black>
													<td align=center bgcolor=#ffd8cc colspan=3><a href="#"
															onClick="showsum('ticket','<%=ticketnumber%>')">ยอดใบนี้</a>
													</td>
												</tr>
												<tr class=text_black>
													<td align=center bgcolor=#ffd8cc colspan=3><a href="#"
															onClick="showsum('ticket','<%=ticketnumber%>')"><%=formatnumber(sumticket,0)%></a>
													</td>
												</tr>

											</table>
										</td>
									</tr>
									<tr>
										<td height=30>&nbsp;</td>
									</tr>
									<tr>
										<td height=30>&nbsp;คนคีย์ :
											<strong><%=GetKey_Name(ticket_id)%></strong>
										</td>
									</tr>
									<tr>
										<td align=center class="kt-label-font-color-2  kt-label-bg-color-2" height=25
											style="padding: 10px;">
											<p style="color: #fff;">ใบที่&nbsp;</p>
											<input type="text" class="form-control" value="<%=ticketnumber%>"
												style="width: 80%; text-align:center;" name="ticketnumber" size="5"
												maxlength="5" onKeyDown="chkEnter(this)">
										</td>
									</tr>
									<tr>
										<td class=textbig_red align=center>
											<%

							if Cdbl(ticketnumber)=1 then 
								pretid=1
							else
								pretid =GetPreTicket_Number(ticketnumber)   ' jum 20060509 ticketnumber - 1
							end If
							Dim NextTicket_Number
							NextTicket_Number= GetNextTicket_Number(ticketnumber)   ' jum 20060509

%>
											&nbsp;เลื่อนโพย&nbsp;
											<table>
												<tr>
													<td><A HREF="#" onClick="gototicket('<%=pretid%>')">
															<div class="arrow-up"></div>
														</A></td>
												</tr>
												<tr>
													<td><A HREF="#" onClick="gototicket('<%=NextTicket_Number%>')">
															<div class="arrow-down"></div>
														</A></td>
												</tr>
											</table>

										</td>
									</tr>
									<tr>
										<td height=30>
											<table class=table_blue width=100%>
												<tr class=text_blue align="center">
													<td align=center>
														<p>พิมพ์ใบที่</p>
														<input type=textbox name=tkfrom size=3 style="width:50"
															class="form-control">
														<p>ถึง</p>
														<input type=textbox name=tkto size=3 style="width:50"
															class="form-control">
													</td>
												</tr>
												<tr>
													<td align=center><input type=button class="btn btn-primary btn-sm "
															style="cursor:hand; width:150" value="พิมพ์โพย"
															onClick="print_ticket('<%=Session("p2pid")%>');"></td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</form>
						</td> <!-- จบ column เมนู -->
						<td valign=top colspan=9>
							<!-- แสดงโพย -->
							<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center bgcolor=#C0C0C0
								class="table">
								<tr>
									<td class=text_blue align=right colspan=4 bgcolor=#ffffff nowrap><span
											id=showtime>&nbsp;&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>
								</tr>
								<tr>
									<%
					dim pAmt
					dim tmpClass
					dim i
					dim xi


					strSql = "SELECT  tb_ticket.ip_address,tb_ticket_key.is_chg_number,   tb_ticket.game_id, tb_ticket.player_id, tb_ticket.ticket_number, tb_ticket_key.key_seq, tb_ticket_key.updown_type, tb_ticket_key.key_number, tb_ticket_key.dealer_rec, tb_ticket_key.number_status, tb_ticket.ticket_date, tb_ticket.rec_date, tb_ticket.ticket_id, MAX(tb_ticket_number.check_status) AS check_number , tb_ticket.rec_status, tb_ticket_key.number_status " _
						& "FROM         tb_ticket INNER JOIN tb_ticket_key ON tb_ticket.ticket_id = tb_ticket_key.ticket_id INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id  and isnull(tb_ticket_number.cut_type,0) in (0,1,2) " _
						& "GROUP BY tb_ticket_key.is_chg_number, tb_ticket.game_id, tb_ticket.player_id, tb_ticket.ticket_number, tb_ticket_key.key_seq, tb_ticket_key.updown_type, tb_ticket_key.key_number, tb_ticket_key.dealer_rec, tb_ticket_key.number_status, tb_ticket.ticket_date, tb_ticket.rec_date, tb_ticket.ticket_id , tb_ticket.rec_status , tb_ticket_key.number_status, tb_ticket.ip_address " _
						& "Having (tb_ticket.game_id = "&Session("gameid")&") AND (tb_ticket.player_id = "&Session("p2pid")&") AND (tb_ticket.ticket_number = '"&ticketnumber&"') AND (tb_ticket_key.number_status in (2,3,4)) " _
						& "  order by key_seq"
'response.write strSql 
					objRec.Open strSql, conn
					Dim ReturnAll,number_class
					ReturnAll="no"
					if not objRec.eof Then
						If objRec("rec_status")=CInt("4") Then ' คืนทั้งใบ
							ReturnAll="yes"
							number_class="input1_red"
						Else
							'response.write objRec("number_status")
							If objRec("number_status")=CInt("3") then
								number_class="input1_red"
							else
								number_class="input1"								
							End if
						End If					
						'JUM 2009-02-11
						'strSql =formatdatetime(objRec("ticket_date"),2) & " ส่ง " & formatdatetime(objRec("ticket_date"),4) 
						strSql =" ส่ง " & formatdatetime(objRec("ticket_date"),2) & " " & FormatDateTime(objRec("ticket_date"),4) & " ip: " & objRec("ip_address")
						if Not Isnull(objRec("rec_date")) then
							'strSql = strSql & "   รับ " & cstr(formatdatetime(objRec("rec_date"),4)) 
							strSql = strSql & "   รับ " & FormatDateTime(objRec("rec_date"),2) & " " & FormatDateTime(objRec("rec_date"),4)
						end if
						response.write "<script language=javascript>document.all.showtime.innerText='"&strSql &"';</script>"
					end if
					Dim tmpColor1, tmpColor2, tmpColor3, tmpColor4,show_type,vdealer_rec
					for xi = 1 to 4
						tmpClass="4%"
						if xi < 4 then tmpClass="32%"
						Response.write "<td width='"&tmpClass&"' valign=top>"
						Response.write "<table cellSpacing=1 cellPadding=1 width='100%' border=0 bgcolor='#ffffff'>"
						for i = 1 to 33				
							if xi < 4 then
								if not objRec.eof Then
									'jum
									If Not ReturnAll="yes" then
										If objRec("number_status")=CInt("3") then
											number_class="input1_red"
										else
											number_class="input1"								
										End If
									End If
									'jum 2007-07-30 ถ้ามีการแก้ไขโพย
									If objRec("is_chg_number")=CInt("1") Then
										number_class="input1_red"
									End If 
									if objRec("updown_type")=1 then ' ล่าง
										show_type="<font color='red'>ล</font>"
									else
										if objRec("updown_type")=3 then ' บน + ล่าง
											show_type="บ+<font color='red'>ล</font>"
										else
											show_type= "บ"
										end if
									end  if 
									tmpColor1="#FFFFFF"
									if objRec("check_number") = 1 then tmpColor1="#51CAC4"
									Response.write "<tr  height=20>"
									Response.write "<td class=tdbody_red align=center width=30 nowrap>"& show_type &"</td>"

									Response.write "<td class=" & number_class & " bgColor="&tmpColor1&" align=right width=50>"&objRec("key_number")  &"</td>"
									Response.write "<td  class=tdbody bgColor="&tmpColor1&" align=center width=10>=</td>"
									if isnull(objRec("dealer_rec")) then
									 	vdealer_rec=0
									else
										vdealer_rec=objRec("dealer_rec") 
									end if 
									Response.write "<td class=" & number_class & " bgColor="&tmpColor1&" >"&replace(vdealer_rec,".00","")&"</td>"								
									Response.write "</tr>"
									objRec.movenext
								else
									tmpColor1="#FFFFFF"
									Response.write "<tr  height=20>"
									Response.write "<td class=tdbody_red align=center width=30>&nbsp;</td>"
									Response.write "<td class=input1 bgColor="&tmpColor1&" width=50>&nbsp;</td>"
									Response.write "<td class=tdbody bgColor="&tmpColor1&" align=center width=10>=</td>"
									Response.write "<td class=input1 bgColor="&tmpColor1&">&nbsp;</td>"									
									Response.write "</tr>"
								end if
							else
								Response.write "<tr class='tdbody_red' height=20><td align=center>"&i&"</td></tr>"
							end if
						next 
						Response.write "</table>"
						Response.write "</td>"
					next 
				%>
									<!-- แสดงโพย -->
						</td>
					</tr>
				</table>

			</td>
			<td>
				<% Call  PrintPrice(Session("uid"), Session("p2pid"), game_id,"yes","1") %>
			</td>
		</tr>
	</table>
</BODY>

</HTML>
<%
	set objRec = nothing
	set recNum = nothing
	set conn   = nothing	
%>
<script language="javascript">
	function chkEnter(obj) {
		var k = event.keyCode
		if (k == 13) {
			document.form1.tid.value = obj.value
			document.form1.submit();
		}
	}
</script>
<%
'jum 20060509
Function GetKey_Name( ticket_id)
	If ticket_id="" then
		GetKey_Name=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select b.[user_name] from tb_ticket a "
		SQL=SQL & " inner join sc_user b on a.key_id=b.[user_id] " '-----and user_type='K' "
		SQL=SQL & " where a.ticket_id=" & ticket_id
		'response.write SQL
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetKey_Name = objRS("user_name")
		else
			GetKey_Name=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function

Function GetPreTicket_Number( ticket_id)
	If ticket_id="" then
		GetPreTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_number from tb_ticket a "
		SQL=SQL & " where  "
		SQL=SQL & " rec_status in (2,3,4) and "
		SQL=SQL & " player_id=" &Session("p2pid")& "  And "
		SQL=SQL & " game_id = " & Session("gameid") 
		SQL=SQL & " and convert(money,ticket_number) < " & ticket_id 
		SQL=SQL & " order by convert(money,ticket_number) desc"
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetPreTicket_Number = objRS("ticket_number")
		else
			GetPreTicket_Number=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function

Function GetNextTicket_Number( ticket_id)
	If ticket_id="" then
		GetNextTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_number from tb_ticket a "
		SQL=SQL & " where  "
		SQL=SQL & " rec_status in (2,3,4) and "
		SQL=SQL & " player_id=" &Session("p2pid")& "  And "
		SQL=SQL & " game_id = " & Session("gameid") 
		SQL=SQL & " and convert(money,ticket_number) >" & ticket_id 
		SQL=SQL & " order by convert(money,ticket_number) "
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetNextTicket_Number = objRS("ticket_number")
		else
			GetNextTicket_Number=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function
Function GetTicket_Number( player_id, game_id)
	If player_id="" then
		GetTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_number from tb_ticket a "
		SQL=SQL & " where  "
		SQL=SQL & " rec_status in (2,3,4) and "   'jum เพิ่ม ไม่รับ แต่แสดงเป็นสีแดง
		SQL=SQL & " player_id=" & player_id & "  And "
		SQL=SQL & " game_id = " & game_id 
		SQL=SQL & " order by convert(money,ticket_number) "
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetTicket_Number = objRS("ticket_number")
		else
			GetTicket_Number=0
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function
%>
<script language="javascript">
	function click_ret_all(ticket_id) {
		if (ticket_id == "") {
			return;
		}
		if (confirm("คุณต้องการ คืนทั้งใบ ?")) {
			window.open("ret_all.asp?ticket_id=" + ticket_id, "_self")
		}
	}

	function click_edit(ticket_id) {
		if (ticket_id == "") {
			alert('xx');
			return;
		}
		if (confirm("คุณต้องการ แก้ไขโพยที่รับแล้ว ?")) {
			window.open("key_dealer.asp?ticket_id=" + ticket_id + "&rec_mode=rec", "_self")
		}
	}
</script>