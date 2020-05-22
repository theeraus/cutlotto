<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<html>

<head>
	<title>คีย์แทงโพย : คนแทง</title>
	<meta http-equiv="Content-Type" content="text/html; charset=urf-8">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="expires" content="-1">
	<script language="javascript">
		// เก็บส่วนลดเอาไว้ ในการคิด เครดิต 
		var ar_discount = new Array()
		var idx = 0;
		var idx_limit_number = 0;
		var idx_limit_numbermoney = 0;
		var ar_limit = new Array()
		var ar_limitmoney = new Array()
		// เก็บจำนวนเงินสูงสุด 
		var ar_maxMoney = new Array()
		var ar_limitnummoney = new Array()
	</script>

	<script language="javascript">
		function chgcolor(obj) {

			var id, oth_button, i
			for (i = 1; i <= 31; i++) {
				id = "but" + i
				oth_button = document.getElementById(id)
				if (oth_button != null) {
					oth_button.className = "inputB"
				}

			}

			but3.className = "inputB"
			but4.className = "inputB"
			but5.className = "inputB"
			but7.className = "inputB"
			but8.className = "inputB"
			but20.className = "inputB"
			but27.className = "inputB"
			but24.className = "inputB"
			but25.className = "inputB"
			but26.className = "inputB"
			but29.className = "inputB"
			but32.className = "inputB"

			obj.className = "input_yellow"
		}
	</script>

	<!--#include file="mdlGeneral.asp"-->
	<%
	'--2007-10-01 แก้ไข ถ้า login มาจาก เจ้ามือ key_id ให้เป็น เจ้ามือคีย์เอง
	If Session("utype")="K" Then 
		Session("key_id")=Session("key_id")
	else
		Session("key_id")=Session("uid")  'jum เอาออก 2008-09-18
	End if
	Dim var_discount, var_maxMoney, var_limit_number ,var_limit_numbermoney
	Dim Client_IP
	Client_IP=Request.ServerVariables("REMOTE_ADDR") 
	'Response.Write " IP " & Client_IP
%>

	<link href="include/code.css" rel="stylesheet" type="text/css">
	<script language="JavaScript" src="include/dialog.js"></script>
	<script src="include/js_function.js" language="javascript"></script>

	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	<script language="javascript">
		function click_login() {
			if (document.form2.login_id.value == "") {
				alert("กรุณากรอก รหัสคนคีย์");
				document.form2.login_id.focus();
				return false;
			}
			if (document.form2.user_password.value == "") {
				alert("กรุณากรอก รหัสผ่านคนคีย์");
				document.form2.user_password.focus();
				return false;
			}
			document.form2.submit();
		}
	</script>

	<style type="text/css">
		.auto-style1 {
			width: 98px;
		}

		.auto-style2 {
			width: 10px;
		}
	</style>

</head>

<body topmargin="0" leftmargin="0" onload="default_up_type_label()">
	<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	Dim before_ticket_number
	before_ticket_number=request("before_ticket_number")
	If before_ticket_number="" Then before_ticket_number=0
	Dim 	updown_type_col1 , key_number , key_money ,updown_type, key_seq, number_status
	Dim ticket_number, game_id , rec_status, ticket_id, send_status, key_from, key_id, player_id
	Dim key_number_ok, j, player_name
	Dim total_play
	Dim call_from
	Dim limit_play,can_play
	Dim tnumber, send,receive,wait,ret,total, open_game
	Dim mess ' ให้แสดง ใบที่ ซ้ำ jum
	mess=request("mess")
	Dim save_type
	save_type=request("save_type")
	call_from = "key"  'อนนท์ เพิ่ม ไว้ตรวจสอบตอนส่งค่า ตอนเลือก palyer
	'game_id=Session("gameid")	
	'//jum ก่อนจะทำการบันทึกให้หา game_id ใหม่ทุกครั้ง 2009-05-26
	dim new_game_id, change_game
	change_game=0
	new_game_id=GetValueFromTable("tb_open_game","game_id","dealer_id=" & Session("uid") & " and game_active='A' ")
	if game_id<>new_game_id then
		Session("gameid")=new_game_id
		game_id=new_game_id
		change_game=1
	end if
	'//jum ก่อนจะทำการบันทึกให้หา game_id ใหม่ทุกครั้ง 2009-05-26
	Dim save,i
	Dim dealer_id ' id ของ user ที่ login คือ dealer
	dealer_id=Session("uid")	
	
	Dim game_type
	game_type=1 'ไม่ได้ใช้อะไรส่งไปหาค่า sum มาแสดง
	Dim line_per_page,col_per_page
	line_per_page=33
	col_per_page=3
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")

	'2009-08-20 จำกัดเงินแทง 
	Dim limit_number_for ' 1=ใช้ทั้งหมด 2=ใช้กับคนแทง
	Dim limit_number_thispage, active_LimitMoney
	limit_number_thispage=1
	SQL="select active_LimitMoney, limit_number_for from sc_user where user_id=" & dealer_id
	set objRS=objDB.Execute(SQL)
	if Not objRS.eof Then
		limit_number_for=objRS("limit_number_for")
		active_LimitMoney=objRS("active_LimitMoney") ' 1 ใช้ 0 ไม่ใช้
	End If 
	'2009-08-20 จำกัดเงินแทง 

	'เช็คก่อนว่าปิดรับ คีย์หรือ ยัง
	SQL="select * from tb_open_game where game_status=0 and game_id=" & game_id
	set objRS=objDB.Execute(SQL)
	if Not objRS.eof then
		open_game="close"
		Response.write "<br><br><center><font color='red'>ไม่สามารถ ส่งโพยได้ เนื่องจากเจ้ามือปิดรับแทงแล้ว </font></center>"
		Response.write "<br><br><center>" & ShowBack() & "</center>"
		Response.end
	end if


	'-- เช็คว่าถ้าคนคีย์ยังไม่มีการ login ให้แสดงหน้าให้ loginเพื่อเก็บ session key_id ก่อน
	Dim login, user_password, login_id
	If Session("key_id")="" Then
		login=Request("login")
		login_id=Request("login_id")
		user_password=Request("user_password")
		If login<>"yes" then
		%>
	<form name="form2" action="key_dealer_play.asp" method="post">
		<input type="hidden" name="login" value="yes">
		<table align="center" border="0">
			<tr bgcolor="red">
				<td align="center" colspan="2" class="text_white">
					กรุณากรอกรหัสผ่านคนคีย์
				</td>
			</tr>
			<tr>
				<td class="tdbody">
					ชื่อรหัสคนคีย์
				</td>
				<td>
					<input type="text" size="20" maxlength="5" name="login_id" onKeyDown="chkEnter2(this);">
				</td>
			</tr>
			<tr>
				<td class="tdbody">
					รหัสผ่าน
				</td>
				<td>
					<input type="password" size="20" maxlength="5" name="user_password" onKeyDown="chkEnter2(this);">
				</td>
			</tr>
			<tr>
				<td class="tdbody">
					&nbsp;
				</td>
				<td>
					<input type="button" class="inputM" name="submit2" style="cursor:hand;width:75;" value="ตกลง"
						onClick="click_login();">
				</td>
			</tr>
		</table>
	</form>
	<script language="javascript">
		document.form2.login_id.focus();

		function chkEnter2(obj) {
			var k = event.keyCode
			if (k == 13) {
				if (obj.name == "login_id") {
					document.form2.user_password.focus();
				}
				if (obj.name == "user_password") {
					document.form2.submit2.focus();
				}
			}
		}
	</script>
	<%
			response.end
		Else
		' เช็ค user/pass ของคนคีย์ ถ้าถูกต้อง ให้ redirect ไปที่ key_dealer_play.asp
			SQL="select * from sc_user where user_type='K' and login_id='" & login_id & "'"
			SQL=SQL & " and user_password='" & user_password & "'"
			SQL=SQL & " and create_by=" & dealer_id 
			set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				Session("key_id")=objRS("user_id")
				Set objRS=Nothing
				response.redirect("key_dealer_play.asp")
			Else
				response.write "<br><br><br><center><font color='red'><b>กรุณากรอก รหัสคนคีย์ ให้ถูกต้อง !!"
				response.write "</b></font></center>"
				Set objRS=nothing
				response.end
			End if			
		end if
		
	End If
	'-- end เช็คว่าถ้าคนคีย์ยังไม่มีการ login ให้แสดงหน้าให้ loginเพื่อเก็บ session key_id ก่อน
	
	
	ticket_id=Request("ticket_id")
	save=Request("save")
	
	'-- ต้องไปหามาก่อนว่า login นี้ได้ grame_id หมายเลขอะไร
	'if game_id="" then game_id="1"
	
	player_id=Request("player_id")
	

	if save="save" then
		key_number_ok="no"
		'--- insert into tb_ticket		
		player_id=Request("player_id")
		'//เช็คเลขที่ก่อนถ้าซ้ำให้ีระบบ gen เลขใบต่อไปให้ 
		'//2006-06-24 
		ticket_number= Request("ticket_number") '--Getticket_number(player_id , game_id )
		SQL="select * from tb_ticket where ticket_number='" & ticket_number & "' "
		SQL=SQL & " and player_id=" & player_id & " and game_id=" & game_id

		set objRS=objDB.Execute(SQL)
		If not objRS.eof Then
			ticket_number=Getticket_number(player_id , game_id,"" ,0)
		End if
		'//2009-0527
		'if change_game=1 then
		'	ticket_number=1
		'end if
		rec_status=0  ' ถ้าเจ้ามือเป็นคนคีย์ รับอัตโนมัติ 1 ' ส่ง
		send_status=1  ' ส่งเจ้ามือเจ้าของ
		key_from=1       ' แทงจาก com 
		key_id=Session("key_id") '// 20060509 jum Session("uid")
		for i=1 to 33
			for j=1 to 3
						updown_type=convUpDownType(Request("updown_type_col" & j & i ))
						key_number=Request("key_number_col" & j & i )
						key_money=Request("key_money_col" & j & i )
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_number_ok="ok"
							exit for
						end if
			next
			if key_number_ok="ok" then
				exit for
			end if
		next
		if key_number_ok="ok" then
			'// เก็บข้อมูล หมายเลขคนแทง ที่เจ้ามือคีย์แทงให้
			SQL="exec spInsert_tmp_dealerkey " & dealer_id & "," & player_id
'response.write SQL & "<br>"
'response.end
			set objRS=objDB.Execute(SQL)

			SQL="exec spInsert_tb_ticket " & game_id & ", "  & _
																ticket_number & ", " & _
																player_id & ", " & _
																rec_status  & ", " & _
																send_status	 & ", " & _
																key_from & ", " & _
																key_id
'response.write SQL & "<br>"
'response.end
'response.flush
			set objRS=objDB.Execute(SQL)																
			if not objRS.EOF then
				ticket_id=objRS("ticket_id")
				SQL="update tb_ticket set ip_address='" & Client_IP & "' where ticket_id=" & ticket_id
				objDB.Execute(SQL)
				key_seq=0
				for i=1 to 33
						updown_type=convUpDownType(Request("updown_type_col1" & i ))
						key_number=Request("key_number_col1" & i )
						key_money=Request("key_money_col1" & i )
						
						number_status=1    '  ส่ง
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
							'response.write SQL & "<br>"
						end If
					Next 
					for i=1 to 33
						'--- แต่ละตัวเลขที่แทงจะต้อง save ลง tb_ticket_number โดยการแยกประเภทการแทง
						updown_type=convUpDownType(Request("updown_type_col2" & i ))
						key_number=Request("key_number_col2" & i )
						key_money=Request("key_money_col2" & i )
						key_seq=i+33
						number_status=1    '  ส่ง
						if updown_type <>""  and  key_number<>"" and  key_money <>"" Then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
							'objDB.Execute(SQL)
						end if
					Next
					for i=1 to 33	
						updown_type=convUpDownType(Request("updown_type_col3" & i ))
						key_number=Request("key_number_col3" & i )
						key_money=Request("key_money_col3" & i )
						key_seq=i+33+33
						number_status=1    '  ส่ง
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
							'objDB.Execute(SQL)
						end if
				Next
				' 2007-07-19 update rec_status หลังจากที่ insert Detail เรียบร้อยแล้ว 
				SQL="update tb_ticket set rec_status=1 where ticket_id=" & ticket_id
				set objRS=objDB.Execute(SQL)
				
				' 2007-07-19 update rec_status หลังจากที่ insert Detail เรียบร้อยแล้ว 
			end if
			'--- ถ้าเป็น user ประเภทรับโพยอัตโนมัติ
			'-- ถ้าเจ้ามือเป็นคนคีย์รับอัตโนมัติ ไม่สนว่าคนแทงจะเป็นประเภทรับอัตโนมัติหรือไม่
			'SQL="select * from sc_user where rec_ticket=1 and user_id=" & player_id ' รับเลย
			SQL="select * from sc_user where user_id=" & dealer_id 
			set objRS=objDB.Execute(SQL)
			if not objRS.eof Then
				If CInt(objRS("rec_ticket_type"))=1 Then 'เลือกเอง
					If CInt(objRS("rec_ticket_dealer"))=1 then
						SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
						objDB.Execute(SQL)					
					End If
				End If 
				'If CInt(objRS("rec_ticket_type"))=2 Then 'แดงทั้งหมด รอรับอยู่แล้ว
				'End If 
				If CInt(objRS("rec_ticket_type"))=3 Then 'เขียวทั้งหมด
						SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
						objDB.Execute(SQL)
				End If 
				'---- เดิม
				'If CInt(objRS("rec_ticket_dealer"))=1 then
				'	SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
				'	set objRS=objDB.Execute(SQL)					
				'End If
				
			end if
		end if	

	If CDbl(ticket_number)<>CDbl(Request("ticket_number")) Then	
		mess="ใบที่ " & Request("ticket_number") & " ซ้ำ ระบบสร้างให้เป็น ใบที่ " & ticket_number
	End if

	Response.Redirect("key_dealer_play.asp?mess=" & mess & "&save_type=" & save_type & "&before_ticket_number=" & ticket_number)	
	end if
	if player_id="" then '// ถ้าเป็นการเข้ามาครั้งแรก โดยไม่มีชื่อคนแทง จะหาจากข้อมูลเดิม
		'jum 2007-05-21
        SQL="exec spJGetLastPlayerByKeyID "	& Session("key_id")  & ", " & game_id

		set objRS=objDB.Execute(SQL)
		if not objRS.eof then
			player_id=objRS("user_id")
		

			player_name=rtrim(ltrim(objRS("login_id"))) & " " & rtrim(ltrim(objRS("user_name")))
			total_play=GetTotalPlay(player_id,game_id)		
			'// หาเพิ่ม 2006-01-11 ว่า เป็นใบโพยที่เท่าไหร
			send=GetSend(player_id,game_id)
			receive=GetReceive(player_id,game_id)
			ret=GetReturn(player_id,game_id)
			tnumber=Getticket_number(player_id,game_id,save_type,before_ticket_number)
			total=formatnumber(GetTotalPlay(player_id,game_id),0) 
			wait=Clng(send) - Clng(receive)
			'// 2007-08-21 หา เครดิตสูงสุด ยอดแทง เครดิตคงเหลือ
			If CDbl(objRS("limit_play"))	>0 Then
				limit_play=FormatNumber(objRS("limit_play"),0)
			Else
				limit_play=0
			End if
			If ( CDbl(objRS("limit_play"))	 - CDbl(objRS("sum_play"))	 ) >0  Then
				can_play=formatnumber( CDbl(objRS("limit_play"))	 - CDbl(objRS("sum_play"))	 ,0 )
			Else
				can_play=0
			End If
			'=== หา ส่วนลด และ จำนวนแทงสูงสุดที่ กำหนด 
			SQL="exec spJGetPriceDisc " & player_id & ", " & Session("gameid")
			set objRS=objDB.EXecute(SQL)
			var_discount=""
			while not objRS.eof
				var_discount=var_discount & ", " & objRS("play_type") & "|" & objRS("discount_amt")
				%>
	<script language="javascript">
		ar_discount[idx] = '<%=objRS("play_type")%>|<%=objRS("discount_amt")%>'
		idx = parseInt(idx) + 1;
	</script>
	<%
				objRS.MoveNext
			wend 
			var_limit_number=""
			SQL="exec spJ_GetNumberLimitMoney " & player_id & ", " & Session("gameid")
			'response.write SQL
			Set objRS=objDB.Execute(SQL)
			While Not objRS.eof
				If objRS("number_up2")<>"" then
					var_limit_number=var_limit_number & ", " & "1"  & "|" & objRS("number_up2")
				End If
				If objRS("number_down2")<>"" then
					var_limit_number=var_limit_number & ", " & "7"  & "|" & objRS("number_down2")
				End If
				If objRS("number_up3")<>"" then
					var_limit_number=var_limit_number & ", " & "2"  & "|" & objRS("number_up3")
				End If
				If objRS("number_tod3")<>"" then
					var_limit_number=var_limit_number & ", " & "3"  & "|" & objRS("number_tod3")
				End if
				%>
	<!-- เก็บข้อมูลใน java เอาไว้เช็คตอน คีย์ ห้ามแทงเลขที่ limit ไว้ -->
	<script language='javascript'>
		if ('<%=objRS("number_up2")%>' != '') {
			ar_limit[idx_limit_number] = '<%="1"%>|<%=objRS("number_up2")%>';
			idx_limit_number = parseInt(idx_limit_number) + 1;
		}
		if ('<%=objRS("number_down2")%>' != '') {
			ar_limit[idx_limit_number] = '<%="7" %>|<%=objRS("number_down2")%>';
			idx_limit_number = parseInt(idx_limit_number) + 1;
		}
		if ('<%=objRS("number_up3")%>' != '') {
			ar_limit[idx_limit_number] = '<%="2" %>|<%=objRS("number_up3")%>';
			idx_limit_number = parseInt(idx_limit_number) + 1;
		}
		if ('<%=objRS("number_tod3")%>' != '') {
			ar_limit[idx_limit_number] = '<%="3" %>|<%=objRS("number_tod3")%>';
			idx_limit_number = parseInt(idx_limit_number) + 1;
		}
	</script>
	<%
				objRS.MoveNext
			wend

            		var_limit_numbermoney=""

			SQL="exec spJ_GetMoneyBalanceNumber " & player_id & ", " & Session("gameid")
			'response.write SQL play_type,limit_number,balance_amt
			Set objRS=objDB.Execute(SQL)
			While Not objRS.eof
				If objRS("play_type")<>"" then
					var_limit_numbermoney=var_limit_numbermoney & "," & objRS("play_type")  & "|" & objRS("limit_number") & "|" & objRS("balance_amt")
				End If
				%>
	<!-- เก็บข้อมูลใน java เอาไว้เช็คตอน คีย์ ห้ามแทงเลขที่ limit ไว้ -->
	<script language='javascript'>
		if ('<%=objRS("play_type")%>' != '') {
			ar_limitnummoney[idx_limit_numbermoney] =
				'<%=objRS("play_type")%>|<%=objRS("limit_number")%>|<%=objRS("balance_amt")%>';
			idx_limit_numbermoney = parseInt(idx_limit_numbermoney) + 1;
		}
	</script>
	<%
				objRS.MoveNext
			wend


			%>
	<script language="javascript">
		idx = 0;
	</script>
	<%	
			SQL="exec spJChkMaxMoney " & player_id & ", " & Session("gameid")
			set objRS=objDB.Execute(SQL)
			var_maxMoney=""
			While Not  objRS.eof 
				var_maxMoney=var_maxMoney & "," & objRS("play_type") & "|" & objRS("maxMoney") & "|" & objRS("play_desc")
				%>
	<script language="javascript">
		ar_maxMoney[idx] = '<%=objRS("play_type")%>|<%=objRS("maxMoney")%>|<%=objRS("play_desc")%>'
		idx = parseInt(idx) + 1;
	</script>
	<%
				objRS.MoveNext
			wend
			'=== หา ส่วนลด และ จำนวนแทงสูงสุดที่ กำหนด 
		end if
	else
		SQL="select [user_id],login_id,[user_name] from "
		SQL=SQL & " sc_user"
		SQL= SQL & " where [user_id]=" & player_id
		set objRS=objDB.Execute(SQL)
		if not objRS.eof then
			player_id=objRS("user_id")
			player_name=rtrim(ltrim(objRS("login_id"))) & " " & rtrim(ltrim(objRS("user_name")))
			total_play=GetTotalPlay(player_id,game_id)		
		end if
	end if
	set objRS=nothing
	set objDB=nothing

Function GetMess_TicketNumber(ticket_id, ticket_number)
	'//ticket_number = หมายเลขที่ user key ไม่ตรงกับในระบบ -> ระบบ gen ให้
	Dim objRS , objDB , SQL,new_no
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select * from tb_ticket where ticket_id=" & ticket_id
	set objRS=objDB.Execute(SQL)
	if Not objRs.EOF Then
		new_no=objRs("ticket_number")
		If CStr(new_no)<>CStr(ticket_number) then
			GetMess_TicketNumber ="ใบที่ " & ticket_number & " ซ้ำระบบสร้างให้เป็น " & new_no 
		End if
	end if
	set objRS=nothing
	set objDB=nothing
End Function

Function CheckTicketNum(p,g,t)
	Dim objRS , objDB , SQL,new_no
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select * from tb_ticket where game_id=" & g 
	SQL=SQL & " and player_id=" & p
	SQL=SQL & " and ticket_number='" & t & "'"
	set objRS=objDB.Execute(SQL)
	if objRs.EOF then
		CheckTicketNum =t
	else
		new_no=Getticket_number(p, g,save_type)
		CheckTicketNum=new_no
		mess="ใบที่ " & t & " ซ้ำระบบสร้างให้เป็น " & new_no 
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetSend(p,g)
	if p="" then
		GetSend=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetSend " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetSend = objRS("send")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReceive(p,g)
	if p="" then
		GetReceive=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReceive " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReceive = objRS("receive")
	else
		GetReceive=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReturn(p,g)
	if p="" then
		GetReturn=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReturn " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReturn = objRS("returned")
	else
		GetReturn=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetTotalPlay(p,g)
	if p="" then
		GetTotalPlay=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetTotalPlay " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalPlay = objRS("total_play_amt")
	else
		GetTotalPlay=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function convUpDownType(t)
	Select Case t
		Case "ล" 
			convUpDownType=1
		Case "บ" 
			convUpDownType=2
		Case "บ+ล" 
			convUpDownType=3
	End Select
	
	'if t="ล" then
	'	convUpDownType=1	
	'end if
	'if t="บ" then
	'	convUpDownType=2
	'end if
	'if t="บ+ล" then
	'	convUpDownType=3
	'end If
	
End Function
Function Getticket_number( p, g, save_type, before_ticket_number )
	Dim objRS , objDB , SQL, type_number
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	If save_type<>"" Then
		type_number=0
	Else
		type_number=1
	End if
	SQL="exec spGetticket_Key " & p & "," & g & "," & type_number & " ," & before_ticket_number 
'showstr SQL
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	else
		Getticket_number=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%><iframe name="f_hidden" width="0" height="0"></iframe>
	<form name="form1" action="key_dealer_play.asp" method="post">

		<input type="hidden" name="obj_maxMoney" value="<%=var_maxMoney%>">
		<input type="hidden" name="obj_discount" value="<%=var_discount%>">
		<input type="hidden" name="obj_limit_number" value="<%=var_limit_number%>">
		<input type="hidden" name="obj_limit_numbermoney" value="<%=var_limit_numbermoney%>">
		<input type="hidden" name="gbl_cankeynextrow" value="1">
		<input type="hidden" name="first_send" value="yes">
		<input type="hidden" name="master_pay_type">
		<input type="hidden" name="where_cursor" value='c1201'>
		<input type="hidden" name="oldmoney" value='0'>
		<input type="hidden" name="save_type">
		<input type="hidden" name="keep_old_value">

		<table border="0" width="890" class="table" cellpadding="0" cellspacing="0" align="center">
			<!----  table top Level 1  ---->
			<tr valign="top">
				<td align="left">
					<table border="0" cellpadding="1" cellspacing="0">
						<!----  table top Level 2 ทางซ้าย  ---->
						<tr>
							<td align="right">
								<table border=0 cellpadding="0" cellspacing="1" width="100%">
									<tr height="22">
										<td align="right" class=text_blue>
											<table width="100%" cellpadding="1" cellspacing="1">
												<tr height="20">
													<td>
														<strong style="width: 100%;" class="btn btn-danger btn-wide">
															<%=Session("logid") & " " & Session("uname") %>
														</strong>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr height="30">
							<td class="tdbody" align="center">
								<font color="red"><b>F2 = เลือกชื่อลูกค้า</b></font>
							</td>

						</tr>
						<tr>
							<td>
								<input type="hidden" name="player_id" style="width:100%;" value="<%=player_id%>">
								<input type="text" class="btn btn-primary btn-sm" name="player_name" size="14"
									readonly="true" style="width:100%;" bgcolor="#FFFF00" onclick="SearchPlayer();"
									value="<%=player_name%>" style="cursor:hand;">
							</td>
						</tr>
						<tr valign="top">
							<td align="right">
								<table border="0" width=150 cellpadding="0" cellspacing="0">

									<tr>
										<%
								'jum 2007-08-21
								Dim pic
								SQL="exec spGetGame_Type_by_dealer_id " & dealer_id
								Set objRS=conn.Execute(SQL)
								if not objRS.eof then
									game_type=objRS("game_type")
									select case  CInt(game_type)
									case 1
										pic="images/price_gov.jpg"
									case 2
										pic="images/price_tos.jpg"
									case 3
										pic="images/price_oth.jpg"
									end select
								End If
								objRS.close
								'jum 2007-08-21
								%>
										<td colspan="4" align="right" height="0">
											<img src="<%=pic%>" name="mypic" width="0" height="0" border="0">
										</td>
									</tr>
									<tr>
										<td colspan="4" class="tdbody" align="center" style="width:100%;">
											<font color="red"><b>F7 = ขณะนี้ใบที่ </b></font>
											<input type="text" style="width:100%; text-align: center;"
												name="ticket_number" onKeyDown="chkEnterNumber(this);"
												class="form-control">
										</td>
									</tr>


									<tr>
										<td class="tdbody" colspan="4" align="right"><b>ยอดใบนี้</b></td>
									</tr>
									<tr height="21">
										<td colspan="4" class="tdbody" align="right">
											<b>
												<span id="this_play_amt"></span>
												<span id="this_play_disc" style="display:none"></span>
											</b>
										</td>
									</tr>
									<tr>
										<td class="tdbody" align="right">ส่ง</td>
										<td class="tdbody" align="right">=</td>
										<td class="tdbody" align="right"><span id="send"></span></td>
										<td class="tdbody" align="right">ใบ</td>
									</tr>
									<tr>
										<td class="tdbody" align="right">รับแล้ว</td>
										<td class="tdbody" align="right">=</td>
										<td class="tdbody" align="right"><span id="receive"></span></td>
										<td class="tdbody" align="right">ใบ</td>
									</tr>
									<tr>
										<td class="tdbody" align="right">รอรับ</td>
										<td class="tdbody" align="right">=</td>
										<td class="tdbody" align="right"><span id="wait"></span></td>
										<td class="tdbody" align="right">ใบ</td>
									</tr>
									<tr>
										<td class="tdbody" align="right">เลขคืน</td>
										<td class="tdbody" align="right">=</td>
										<td class="tdbody" align="right"><span id="ret"></span></td>
										<td class="tdbody" align="right">ใบ</td>
									</tr>
									<tr>
										<td colspan="4" ALIGN=RIGHT>
											<table>
												<tr bgcolor="red">
													<td class="tdbody1" align="right" nowrap>
														<font color=yellow><b>&nbsp;ยอดแทงรวม&nbsp;</b></font>
													</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td colspan="4" class="tdbody" align="right"><b>
												<span id="total">
													<%=formatnumber(total_play,0)%>
												</span>&nbsp;</b>
										</td>
									</tr>


									<tr>
										<td height="30" colspan="4" align="right">
											<img src="images/upp.jpg" name="b_updown_type" style="cursor:hand;"
												onclick="click_updown_type_label()"></td>
									</tr>
									<tr>
										<td colspan="4" align="right">
											<table cellpadding=0 cellspacing=2>
												<tr>
													<td colspan=2 class="tdbody" align="right">
														<% Response.Write " ip: " & Client_IP %></td>
												</tr>
												<tr valign="top">
													<td class="auto-style1">
														&nbsp;</td>
													<td>
														<input type="button" class="btn btn-primary btn-sm"
															value="F10=ส่ง" style="cursor:hand; width: 75px;"
															onClick="clicksubmit()">
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="4" align="right">
											<span id="wait_save" class="textbig_red"></span>
											<a href="key.html" target="_blank"><input type="button"
													class="btn btn-primary btn-sm" value="วิธีกดแทงโพย"
													style="cursor:hand; width: 100px;"></a></td>
									</tr>
									<tr height="45">
										<td colspan="4" align="right">
											<div id="show_price">
												<% Call PrintPrice(Session("did"), player_id, Session("gameid"),"no","1") %>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="4" align="right">
											<b>เครดิต : <span id="limit_play"></span></b>
										</td>
									</tr>
									<tr>
										<td colspan="4" align="right">
											คงเหลือ : <span id="can_play"></span>
										</td>
									</tr>
									<tr>
										<td align="right" colspan="4">
											<input type="button" class="btn btn-primary btn-sm"
												value="โทรเพิ่มเครดิตเพิ่มแล้วกด" style="cursor:hand; width: 170px;"
												onClick="click_credit();">
											<script language="javascript">
												function click_credit() {
													var player_id = document.form1.player_id.value;
													window.open('get_creditlimit.asp?player_id=' + player_id, 'f_hidden');
												}
											</script>
										</td>
									</tr>
									<tr height="30" width="100%">
										<td colspan="4" align="right">
											<TABLE width="100%" border="0" cellSpacing=0 cellPadding=0>
												<% 
								Call PrintLimitNumber( game_id) 
							            %>
											</TABLE>
										</td>
									</tr>
									<tr>
										<td colspan="4" align="right">
											<!--<a href="วิธีกดแทงโพย.rtf"><img src="images/help.gif" border="0"></a> -->
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<!----  table top Level 2 ทางซ้าย  ---->
				</td>
				<td>
					<table border="0" cellpadding="1" cellspacing="0">
						<!----  table top Level 2 ทางขวาใช้ในการคีย์ข้อมูล ---->
						<!--
					<tr>
						<td class="tdbody" align="right" colspan="18"><b>ใบที่  
						<input type="text" size="3" name="ticket_number" onKeyDown="chkEnterNumber(this);" ></b></td>
					</tr> -->
						<%
						i=1
						while i<=33
					%>
						<tr>
							<td align="center" style="padding: 15px 0;">
								<input type="hidden" name="updown_type_col1<%=i%>" id="c11<%=right("00" & i,2)%>">
								<span class="input2" id="signUp1<%=right("00" & i,2)%>" style="width:27"></span>
								<span id="signDw1<%=right("00" & i,2)%>"></span>
							</td>
							<td><input type="text" style="width:65;" maxLength="4" name="key_number_col1<%=i%>"
									class="form-control" onKeyUp="return autoTab(this, 3, event) , pressPlus(this) ;  "
									onKeyDown="chkEnter(this,1);" id="c12<%=right("00" & i,2)%>"
									onClick="click_shwSign('c11',1);"></td>

							<td width="20" align="center" class="tdbody" style="padding: 12px 0;">=</td>
							<td><input type="text" style="width:98;" maxLength="14" class="form-control"
									name="key_money_col1<%=i%>" onKeyDown="chkEnter(this,2);"
									id="c13<%=right("00" & i,2)%>" onFocus="iBlur(this)" onKeyUp="pressPlus(this)"
									onBlur="chkSum(this)" pattern="[0-9]*"></td>

							<!------------------- ถ้าเป็นโทรศัพท์ไม่ต้องแสดง 2  column นี้ ------------------------>
							<td>&nbsp;</td>
							<td align="center" bgcolor="red" style="padding: 15px 0;"></td>
							<input type="hidden" name="updown_type_col2<%=i%>" id="c21<%=right("00" & i,2)%>" readonly>
							<td align="center" nowrap style="width:27;padding: 15px 0;">
								<span class="input2" id="signUp2<%=right("00" & i,2)%>" style="width:27"></span>
								<span id="signDw2<%=right("00" & i,2)%>"></span>
							</td>
							<td><input type="text" style="width:65" maxLength="4" class="form-control"
									name="key_number_col2<%=i%>"
									onKeyUp="return autoTab(this, 3, event) , pressPlus(this);"
									onKeyDown="chkEnter(this,1);" id="c22<%=right("00" & i,2)%>" onBlur="iBlur(this)"
									onClick="click_shwSign('c21',1);"></td>
							<td width="20" align="center" class="tdbody" style="padding: 15px 0;">=</td>
							<td><input type="text" style="width:98;" maxLength="14" class="form-control"
									name="key_money_col2<%=i%>" id="c23<%=right("00" & i,2)%>" onFocus="iBlur(this)"
									onKeyUp="pressPlus(this)" onKeyDown="chkEnter(this,2);" onBlur="chkSum(this)"
									pattern="[0-9]*"></td>

							<td width="10">&nbsp;</td>
							<td align="center" bgcolor="red"></td>

							<td align="center" style="width:31;padding: 15px 0;" nowrap >
								<input type="hidden" name="updown_type_col3<%=i%>" id="c31<%=right("00" & i,2)%>">
								<span class="input2" id="signUp3<%=right("00" & i,2)%>" style="width:27;"></span>
								<span id="signDw3<%=right("00" & i,2)%>"></span>
							</td>
							<td><input type="text" style="width:65;" maxLength="4" class="form-control" 
									name="key_number_col3<%=i%>"
									onKeyUp="return autoTab(this, 3, event) , pressPlus(this);"
									onKeyDown="chkEnter(this,1);" id="c32<%=right("00" & i,2)%>" onBlur="iBlur(this)"
									onClick="click_shwSign('c31',1);"></td>
							<td width="20" align="center" class="tdbody" style="padding: 15px 0;">=</td>
							<td><input type="text" style="width:98;" maxLength="14" class="form-control"
									name="key_money_col3<%=i%>" onKeyDown="chkEnter(this,2);"
									id="c33<%=right("00" & i,2)%>" onFocus="iBlur(this)" onKeyUp="pressPlus(this)"
									onBlur="chkSum(this)" pattern="[0-9]*"></td>
							<td class="tdbody" align="center">
								<p style="background-color:#ff9999; margin-left:10px; padding:5px; color: #0000FF;">
									<%=i%></p>
							</td>
							<!------------------- ถ้าเป็นโทรศัพท์ไม่ต้องแสดง 2  column นี้ ------------------------>
						</tr>
						<%
							i=i+1
						wend
					%>
					</table>
					<!----  table top Level 2 ทางขวาใช้ในการคีย์ข้อมูล ---->
				</td>

			</tr>
		</table>
		<!----  table top Level 1  ---->

		<input type="hidden" name="save" value="save">

	</form>

	<%
	If mess<>"" Then
	%>
	<script language="javascript">
		window.open("win_alert.asp?mess=<%=mess%>", "f_hidden")
	</script>
	<%
	End If

	%>

</body>
<script language="javascript">
	function pressPlus(o) {
		var k = event.keyCode
		if (k == 107) {
			o.value = lefty(o.value, parseInt(o.value.length) - 1)
		}
	}

	function lefty(instring, num) {
		var outstr = instring.substring(instring, num);
		return (outstr);
	}
	// เช็คกรณีที่ไม่มีการกด enter ใช้ mourse ชี้เพื่อเปลี่ยน box ในการคีย์ เช่นกลับไปแก้ไขจำนวนเงิน
	function chkSum(obj) {
		var gbl_cankeynextrow = document.form1.gbl_cankeynextrow.value;
		if (gbl_cankeynextrow != 1) {
			return;
		}
		var k = event.keyCode
		var o = obj;
		var l, c;
		var i = o.id;
		l = i.substring(3, 5); // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม่
		c = lefty(i, 2); // ชื่อของ id ที่เรา enter มา c1 
		//--- เพิ่มจำนวนเงินของ ใบโพย	
		//alert('o' + o.value + '/' + c + '/' + l)
		sum_PlayAmt(o.value, c, l); // ส่งจำนวนเงินที่ คีย์แล้วไป 

	}

	//document.onkeydown = Function ('checkEnter(event.keyCode)');
	function chkEnter(obj, col_enter) {
		var k = event.keyCode
		var o = obj
		var i = o.id
		var id, next_obj
		var n, l, m, c, strl, prev, Len
		var onumber, tmpobj
		// c1    1   01    =  ชุดที่ 1        บน/ล่าง      บรรทัดที่     c m n
		//-- กรณีที่ user กดคีย์ # , + จะเป็นการสลับ  บ ล หรือ บ+ล
		if (k == 107) {
			click_updown_type(obj)
		}
		if (k == 13) {
			if (obj.value.indexOf(' ') >= 0) {
				alert("ผิดพลาด : เลขแทงห้ามมีช่องว่าง");
				return;
			}
			if (document.form1.player_id.value == "") {
				alert("ผิดพลาด : กรุณาเลือก คนแทงก่อน");
				return;
			}
			document.form1.gbl_cankeynextrow.value = 0;
			document.form1.keep_old_value.value = "no";
			//---- ถ้าเป็นการคีย์ตัวแรกค่าเงินต้องห้ามว่าง
			if (i == 'c1301') {
				if (o.value == '') {
					alert('ผิดพลาด : กรุณากรอกเงินแทง !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false
				}
			}
			l = i.substring(3, 5); // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม่
			c = lefty(i, 2); // ชื่อของ id ที่เรา enter มา c1 			
			m = i.substring(2, 3);
			//---- เช็คการคีย์ข้อมูลที่ช่อง เลขแทงต้องเป็นตัวเลขเท่านั้น 
			if (parseInt(m) == 2) {
				var chkO = o.value
				if (chkO.indexOf('.') >= 0) {
					alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false
				}

				if (o.value == '') {
					alert('ผิดพลาด : กรุณากรอกเลขแทง !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false
				}

				if (isNaN(lefty(o.value, 3))) {
					alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false
				}
				id = c + '1' + l
				next_obj = document.getElementById(id)
				// เลขแทง กรอก 123* ได้  ตัวที่ 4 เป็น * ได้เท่านั้น
				if (o.value.length == 4) {
					if (o.value.substring(3, 4) != "*" && o.value.substring(3, 4) != ' ') {
						alert('ผิดพลาด : ถ้าต้องการแทงเลขวงกลม ต้องคีย์แบบ  123*  !!!')
						document.form1.gbl_cankeynextrow.value = 0;
						return false
					}
					if (next_obj.value != "บ") {
						alert('ผิดพลาด : วงกลม แทงได้เฉพาะ บน เท่านั้น !!!')
						document.form1.gbl_cankeynextrow.value = 0;
						return false
					}
					var n1, n2, n3
					n1 = o.value.substring(0, 1)
					n2 = o.value.substring(1, 2)
					n3 = o.value.substring(2, 3)
					if (n1 == n2 && n2 == n3 && n1 == n3) {
						document.form1.gbl_cankeynextrow.value = 0;
						alert('ผิดพลาด : เลขตองไม่ต้องแทงแบบวงกลม  !!!')
						return false
					}

				}
				// การแทง บ+ล ห้ามคีย์เลข 3 ตัว 

				//if (next_obj.value=="บ+ล"){
				//	if (o.value.length>=3){
				//		alert('ผิดพลาด : แทง บ+ล ห้ามคีย์เลขแทง 3 หลัก !!!')
				//		return false
				//}
				//} 

			}
			//-- ช่องที่เป็นจำนวนเงินแทง ต้องเป็น ตัวเลข * เท่านั้น
			if (parseInt(m) == 3) {
				//--- ช่องหลังถ้าใส่เลขแทงแล้วไม่ใส่เงินแทงกดผ่าน ให้ใส่เงินแทงเหมือนบรรทัดบน 
				id = c + 3 + l
				next_obj = document.getElementById(id)
				if (l != "01") {
					if (next_obj.value == "") {
						id = c + 3 + desc1(l) // desc1 เป็น fumction ลบ 1 
						next_obj.value = document.getElementById(id).value
					}
				} else {
					if (next_obj.value == "") {
						var ta = parseInt(i.substring(1, 2)) - 1; // ลด 1 เป็น column ก่อนหน้า 
						id = "c" + ta + '333'
						tmpobj = document.getElementById(id).value
						next_obj.value = tmpobj
					}
				}
				//--- ช่องหลังถ้าใส่เลขแทงแล้วไม่ใส่เงินแทงกดผ่าน ให้ใส่เงินแทงเหมือนบรรทัดบน 

				if (canKeyNumber(o.value)) {
					// ถ้าเป็น บ+ล สามารถคีย์จำนวนเงินแทงเป็น  71=100/400 บน 100 ล่าง 400
					id = c + '1' + l
					next_obj = document.getElementById(id)
					id = c + '2' + l
					onumber = document.getElementById(id)
					// 2007-02-23
					if (next_obj.value == "บ+ล") {
						x = o.value
						x2 = x.indexOf('*')
						x3 = x.indexOf('/')
						if (x2 == 0) {
							alert('ผิดพลาด : ป้อนจำนวนเงินแทงไม่ถูกต้อง !!!')
							document.form1.gbl_cankeynextrow.value = 0;
							return false
						}
					}
					if (next_obj.value == "บ+ล" && onumber.value.length <= 3) {
						if (canKeyUPDN(o.value)) {
							alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] , * หรือ / เท่านั้น !!!')
							document.form1.gbl_cankeynextrow.value = 0;
							return false;
						}
					} else {
						alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] หรือ * เท่านั้น !!!')
						document.form1.gbl_cankeynextrow.value = 0;
						return false;
					}
				}
				//--- เช็คตัวเลขแทงกรณีที่คีย์ เงินแทงเป็น 19*900 จะต้องคีย์เลขแทงเป็น 1 หลักเท่านั้น	
				id = c + '2' + l
				next_obj = document.getElementById(id)

				if (next_obj.value.length == 4) {
					if (isNaN(o.value)) {
						alert('ผิดพลาด : วงกลม เลขแทง ต้องเป็นตัวเลขเท่านั้น !!!')
						document.form1.gbl_cankeynextrow.value = 0;
						return false
					}
				}

				if (lefty(o.value, 3) == '19*') {
					if (next_obj.value.length > 1) {
						alert(
							'ผิดพลาด : กรุณากรอกข้อมูลให้ถูกต้อง \n ถ้าต้องการแทง 19 หางต้องคีย์เลขแทง 1 หลักเท่านั้น !!!'
						)
						document.form1.gbl_cankeynextrow.value = 0;
						return false;
					}
				}
				x = o.value
				if (x.substring(x.length - 1, x.length) == "*") {
					alert('ผิดพลาด : กรุณากรอกข้อมูลให้ถูกต้อง \n ถ้าต้องการแทงโต๊ด พิมพ์ *999 หรือ 999*999 !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false;
				}
				//ที่ช่องจำนวนเงิน ห้ามคีย์  * 2 ครั้ง 
				if (!canKeyStar(o.value)) {
					alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงให้ถูกต้อง !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false;
				}
				// จำนวนเงินแทงต้อง มากกว่า 0 เริ่มเช็ค 8/5/49
				if (o.value <= 0) {
					alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงต้องมากกว่า 0 !!!')
					document.form1.gbl_cankeynextrow.value = 0;
					return false;
				}


			}

			m = parseInt(m) + 1
			if (m > 3) {
				//------- validate data อีกรอบ
				var o1 = document.getElementById(c + 1 + l)
				var o2 = document.getElementById(c + 2 + l)
				var o3 = document.getElementById(c + 3 + l)
				if (!validate_1(o1, o2, o3)) {
					document.form1.gbl_cankeynextrow.value = 0;
					return false
				}
				//---- start  เช็คจำนวนเงิน ตั้งราคาและตั้งแทงสูงสุด ข้อ 61
				if (!GetPlayType_Money(o1, o2, o3)) {
					document.form1.gbl_cankeynextrow.value = 0;
					//alert(' ===> '+document.form1.gbl_cankeynextrow.value)
					return false;
				}
				//---- finish เช็คจำนวนเงิน ตั้งราคาและตั้งแทงสูงสุด ข้อ 61
				//-------

				//--- เพิ่มจำนวนเงินของ ใบโพย				
				//sum_PlayAmt();
				//sum_PlayAmt(o.value,c,l); // ส่งจำนวนเงินที่ คีย์แล้วไป 
				// เปลี่ยนไปเช็คตอน onBlur
				//--------------------------------------------

				if (l == "08") {
					l = "8"
				} // bug 
				if (l == "09") {
					l = "9"
				} // bug	
				l = parseInt(l) + 1
				if (l <= 9) {
					l = "0" + l
				}
				m = 2;
				if (l > 33) {
					l = "01"
					c = parseInt(i.substring(1, 2)) + 1;
					if (c > 3) {
						alert("บันทึกข้อมูล")
						document.form1.save_type.value = "over_page";
						clicksubmit()
						return;
					}
					c = "c" + c;
				}
				// ถ้าเป็นการ enter ที่จำนวนเงิน ให้เอา บน/ล่าง ใส่ที่ pay_type
				id = c + 1 + l
				next_obj = document.getElementById(id)
				next_obj.value = document.form1.master_pay_type.value;
				displayUPDW(id, next_obj.value)
			}
			id = c + m + l
			next_obj = document.getElementById(id)
			next_obj.focus()
			document.form1.gbl_cankeynextrow.value = 1;
			if (col_enter == 2) {
				//alert(obj+' '+ obj.value)
				chkSum(obj);
			}
			document.form1.keep_old_value.value = "yes";

		}
	}

	function click_shwSign(c, l) {
		id = c + Right('0' + l, 2);
		if (c == 'c21' && l == 1) {
			c = 'c11';
			l = 34;
		}
		if (c == 'c31' && l == 1) {
			c = 'c21';
			l = 34;
		}
		pid = c + Right('0' + (l - 1), 2);
		next_obj = document.getElementById(id)

		if (next_obj.value == "") {
			next_obj.value = document.getElementById(pid).value;
			obj = document.getElementById(id);
			displayUPDW(id, next_obj.value)
		}
	}

	function sum_PlayAmt(nmoney, c, l) {

		/*
    //	 จำนวนเงินก่อนคีย์
    var omoney=document.form1.oldmoney.value
		
    //alert('sum_PlayAmt ' + omoney)
    var m
    //alert(getMoney(omoney,c,l))
    if (document.all.this_play_amt.innerText==""){ document.all.this_play_amt.innerText=0 }
    m=document.all.this_play_amt.innerText 
    m=(parseInt(m) - parseInt(getMoney(omoney,c,l)) ) + parseInt(getMoney(nmoney,c,l) )
    document.all.this_play_amt.innerText=m		
    */
		//	 จำนวนเงินก่อนคีย์


		var omoney = document.form1.oldmoney.value
		var m

		//alert(document.form1.oldmoney.value);

		if (document.all.this_play_amt.innerText == "") {
			document.all.this_play_amt.innerText = 0
		}
		m = document.all.this_play_amt.innerText
		m = (parseFloat(m) - parseFloat(getMoney(omoney, c, l))) + parseFloat(getMoney(nmoney, c, l))
		document.all.this_play_amt.innerText = m

		if (document.all.this_play_disc.innerText == "") {
			document.all.this_play_disc.innerText = 0
		}
		m = document.all.this_play_disc.innerText
		//formatnum ปัดเศษออก
		//if (!CalcPlayDiscount(nmoney,c,l)){
		m = parseFloat(m) + ((CalcPlayDiscount(nmoney, c, l)) - (CalcPlayDiscount(omoney, c, l)))
		document.all.this_play_disc.innerText = m
		//}


	}
	//--20071112
	function GetDiscount(play_type) {
		var tmp_name = play_type;
		var i = 0
		var count = 0;
		string = "";
		ar_discount = (document.all.obj_discount.value).split(",");
		for (i = 0; i < ar_discount.length; i++) {
			string = ar_discount[i].split("|");
			if (string[0] == tmp_name) {
				return string[1];
			}
		}
	}

	function ChkMaxMoney(play_type, money, money_focus, key_number, key_money) {
		string = "";
		var tmp_name = play_type;
		ar_maxMoney = (document.all.obj_maxMoney.value).split(",");
		for (i = 0; i < ar_maxMoney.length; i++) {
			string = ar_maxMoney[i].split("|");
			if (parseFloat(string[1]) != 0) { // ถ้ากำหนดเป็น 0 = ไม่มีการกำหนดแทงสูงสุด
				if (string[0] == tmp_name) {
					if (parseFloat(string[1]) < parseFloat(money)) {
						alert("ผิดพลาด : จำนวนเงินแทง " + string[2] + " ต้องไม่เกิน " + string[1]);
						money_focus.focus();
						return false;
					}
				}
			}
		}
		return chk_limit_number(play_type, key_number.value, key_money)
		return true;
	}

	//แยกจำนวนเงิน เพื่อใช้ในการตรวจสอบ จำนวนเงินที่แทงได้สูงสุด
	function GetPlayType_Money(obj1, obj2, obj3) {
		var key_money = obj3.value;
		//var calcMoney=0;
		//-- จำนวนเงินรวมของใบนี้ที่หักส่วนลดแล้ว
		updown_type = obj1; //document.getElementById(  id ) // PlayType
		key_number = obj2; //document.getElementById(  id ) //เลขแทง
		var money_focus
		money_focus = obj3; //document.getElementById(  id ) // จำนวนเงิน ที่จะ set focus กลับ

		if ((key_number.value.length) == 1 && (updown_type.value == "ล" || updown_type.value == "บ+ล") && !isNaN(
				key_money)) { // --- วิ่ง ล่าง
			play_type = 6
			money = key_money
			return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
		}

		if ((key_number.value.length) == 1 && (updown_type.value == "บ" || updown_type.value == "บ+ล") && !isNaN(
				key_money)) { // --- วิ่ง บน
			play_type = 5
			money = key_money
			return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
		}

		if ((key_number.value.length) == 2 && !isNaN(key_money)) { //  2   ล่าง  คีย์จำนวนเงินเป็นตัวเลข 

			if (updown_type.value == 'ล') {
				play_type = 7 //-- 2 ล่าง
				money = key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}

			if (updown_type.value == 'บ') {
				play_type = 1 // -- 2 บน
				money = key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}

			if (updown_type.value == 'บ+ล') {
				play_type = 7 //-- 2 ล่าง
				money = key_money
				tmp7 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 1 // -- 2 บน
				money = key_money
				tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				tmp = tmp7 && tmp1
				return tmp
			}


		}

		//----- start แทง 2 บน 19 หาง 
		if ((key_number.value.length) == 1 && isNaN(key_money) && key_money.indexOf('19*') == 0) {
			tmp_key_money = key_money.substring(3, key_money.length)
			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 7 //--- 2 ล่าง *19 เพราะมี 19 ตัว 
				money = tmp_key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}

			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 1 //--- 2 บน  *19 เพราะมี 19 ตัว 
				money = tmp_key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
		}
		//----- end แทง 2 บน 19 หาง 		

		//--- start 2 ตัวตรง +โต๊ด     12 = 100*200
		if ((key_number.value.length) == 2 && !isNaN(key_number.value) && key_money.indexOf('*') > 0 &&
			key_money.indexOf('19*') == -1) {

			if (updown_type.value == 'ล') {
				play_type = 7 //-- 2 ตัวล่าง * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง
				tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				play_type = 7 //-- 2 ล่าง
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				tmp = tmp1 && tmp2
				return tmp;
			}
			if (updown_type.value == 'บ') {
				play_type = 1 //-- 2 ตัวบน * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง
				tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 1 //-- 2 บน				
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				tmp = tmp1 && tmp2
				return tmp;
			}
			if (updown_type.value == 'บ+ล') {
				play_type = 7 //-- 2 ตัวล่าง * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง

				tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				play_type = 7 //-- 2 ล่าง
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)

				tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 1 //-- 2 ตัวบน * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง
				tmp3 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 1 //-- 2 บน				
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				tmp4 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				tmp = tmp1 && tmp2 && tmp3 && tmp4;
				return tmp;
			}

		}

		//--- start 2 โต๊ด     12 =*200	
		if ((key_number.value.length) == 2 && key_money.indexOf('*') == 0) {
			calcMoney = 0;
			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 4 //-- 2 ตัวโต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 4 //-- 2 ตัวโต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length);
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
		}
		//-- start 3 ตัวธรรมดา 123 = 999
		if ((key_number.value.length) == 3 && !isNaN(key_money)) {
			if (updown_type.value == 'ล') {
				play_type = 8 //-- 8 3 ล่าง
				money = key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
			if (updown_type.value == 'บ') {
				play_type = 2 //-- 3 บน
				money = key_money
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
			if (updown_type.value == 'บ+ล') {
				play_type = 8 //-- 8 3 ล่าง
				money = key_money
				tmp8 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 2 //-- 3 บน
				money = key_money
				tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
				tmp = tmp8 && tmp2;
				return tmp;
			}
		}
		//---- start  แทง 3 ตรง โต๊ด     123 =200*200
		if ((key_number.value.length) == 3 && isNaN(key_money) && key_money.indexOf('*') > 0 &&
			key_money.indexOf('19*') == -1 && key_money.indexOf('/') == -1) {
			if (updown_type.value == 'บ') {
				play_type = 2 //--  3 บน
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง					
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

				play_type = 3 //---- ส่วนของโต๊ด ----
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length) //-- จำนวนเงินของตัวตรง					
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

			}
		}

		//--- start   * 3 โต๊ด 123 = *990
		if ((key_number.value.length) == 3 && key_money.indexOf('*') == 0 &&
			key_money.indexOf('/') == -1) {
			if (updown_type.value == 'บ') {
				play_type = 3 //--  3 โต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			}
		}
		//--- start 3 วงกลม
		if ((key_number.value.substring(3, 4) == '*') && (key_number.value.length) == 4 &&
			key_money.indexOf('*') == -1 && !isNaN(key_money)) {
			if (updown_type.value == 'บ') {
				play_type = 2 //--  3 บน

				n1 = key_number.value.substring(0, 1)
				n2 = key_number.value.substring(1, 2)
				n3 = key_number.value.substring(2, 3)
				//ถ้ามีเหมือนการ 2 ตัว จะมี 3 ตัวเลข 
				if (n1 == n2 || n1 == n3 || n2 == n3) {
					multi = 3
				} else {
					multi = 6
				}
				money = parseFloat(key_money) * parseFloat(multi)
				//ถ้าไม่เหมือนกันจะมี 6
				return ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

			}
		}

		//--- start บ+ล 71=100/400 -----
		if ((key_number.value.length) == 2 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1) {

			play_type = 1 // --  2 บน
			money = key_money.substring(0, key_money.indexOf('/')) //-- จำนวนเงินของตัวหน้า
			tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			//---ทำส่วน ล่าง---			
			play_type = 7 //--  2 ล่าง
			money = key_money.substring(key_money.indexOf('/') + 1, key_money.length)
			tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			tmp = tmp2 && tmp1
			return tmp;
		}
		//-- 125=100/200 -----
		if ((key_number.value.length) == 3 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1 && key_money
			.indexOf('*') == -1) {
			play_type = 2 //--  3 บน		
			money = key_money.substring(0, key_money.indexOf('/')) //-- จำนวนเงินของตัวหน้า
			tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

			play_type = 8 //--  3 ล่าง
			money = key_money.substring(key_money.indexOf('/') + 1, key_money.length)
			tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			tmp = tmp1 && tmp2
			return tmp;
		}

		//-- 125 = 100*100/50 2006-09-07

		if ((key_number.value.length) == 3 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1 && key_money
			.indexOf('*') > -1) {
			//---ทำส่วน บน ก่อน  100  ---			
			play_type = 2 //--  3 บน
			money = key_money.substring(0, key_money.indexOf('*')) //- จำนวนเงินของตัวหน้า
			tmp1 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			//--- เลขหลัง * = 3 โต๊ด  *100  
			slash = key_money.indexOf('/')
			star = key_money.indexOf('*')
			money = key_money.substring(star + 1, slash)
			play_type = 3 //--  3 โต๊ด
			tmp2 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);

			money = key_money.substring(slash + 1, key_money.length)
			play_type = 8 //-- 8 3 ล่าง			
			tmp3 = ChkMaxMoney(play_type, money, money_focus, key_number, key_money);
			tmp = tmp1 && tmp2 && tmp3;
			return tmp;
		}

		return true;
	} //end function

	function CalcPlayDiscount(nmoney, c, l) {
		var key_money = nmoney
		var calcMoney = 0;
		//-- จำนวนเงินรวมของใบนี้ที่หักส่วนลดแล้ว
		id = c + '1' + l
		updown_type = document.getElementById(id) // PlayType
		id = c + '2' + l
		key_number = document.getElementById(id) //เลขแทง
		var money_focus
		id = c + '3' + l
		money_focus = document.getElementById(id) // จำนวนเงิน ที่จะ set focus กลับ

		if ((key_number.value.length) == 1 && (updown_type.value == "ล" || updown_type.value == "บ+ล") && !isNaN(
				key_money)) { // --- วิ่ง ล่าง
			play_type = 6
			money = key_money
			calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
		}

		if ((key_number.value.length) == 1 && (updown_type.value == "บ" || updown_type.value == "บ+ล") && !isNaN(
				key_money)) { // --- วิ่ง บน
			play_type = 5
			money = key_money
			calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
		}

		if ((key_number.value.length) == 2 && !isNaN(key_money)) { //  2   ล่าง  คีย์จำนวนเงินเป็นตัวเลข 

			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 7 //-- 2 ล่าง
				money = key_money
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}

			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 1 // -- 2 บน
				money = key_money
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}


		}

		//----- start แทง 2 บน 19 หาง 
		if ((key_number.value.length) == 1 && isNaN(key_money) && key_money.indexOf('19*') == 0) {
			tmp_key_money = key_money.substring(3, key_money.length)
			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 7 //--- 2 ล่าง *19 เพราะมี 19 ตัว 
				money = tmp_key_money * 19
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}

			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 1 //--- 2 บน  *19 เพราะมี 19 ตัว 
				money = tmp_key_money * 19
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}
		}
		//----- end แทง 2 บน 19 หาง 		

		//--- start 2 ตัวตรง +โต๊ด     12 = 100*200
		if ((key_number.value.length) == 2 && !isNaN(key_number.value) && key_money.indexOf('*') > 0 &&
			key_money.indexOf('19*') == -1) {

			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 7 //-- 2 ตัวล่าง * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

				play_type = 7 //-- 2 ล่าง
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			}
			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 1 //-- 2 ตัวบน * 2 มี 2 ตัว
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

				play_type = 1 //-- 2 บน				
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}



		}

		//--- start 2 โต๊ด     12 =*200	
		if ((key_number.value.length) == 2 && key_money.indexOf('*') == 0) {
			calcMoney = 0;
			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 4 //-- 2 ตัวโต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			}
			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 4 //-- 2 ตัวโต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length);
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}
		}
		//-- start 3 ตัวธรรมดา 123 = 999
		if ((key_number.value.length) == 3 && !isNaN(key_money)) {
			if (updown_type.value == 'ล' || updown_type.value == 'บ+ล') {
				play_type = 8 //-- 8 3 ล่าง
				money = key_money
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}
			if (updown_type.value == 'บ' || updown_type.value == 'บ+ล') {
				play_type = 2 //-- 3 บน
				money = key_money
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}

		}
		//---- start  แทง 3 ตรง โต๊ด     123 =200*200
		if ((key_number.value.length) == 3 && isNaN(key_money) && key_money.indexOf('*') > 0 &&
			key_money.indexOf('19*') == -1 && key_money.indexOf('/') == -1) {
			if (updown_type.value == 'บ') {
				play_type = 2 //--  3 บน
				money = lefty(key_money, key_money.indexOf('*')) //-- จำนวนเงินของตัวตรง					
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

				play_type = 3 //---- ส่วนของโต๊ด ----
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length) //-- จำนวนเงินของตัวตรง					
				calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			}
		}

		//--- start   * 3 โต๊ด 123 = *990
		if ((key_number.value.length) == 3 && key_money.indexOf('*') == 0 &&
			key_money.indexOf('/') == -1) {
			if (updown_type.value == 'บ') {
				play_type = 3 //--  3 โต๊ด
				money = key_money.substring(key_money.indexOf('*') + 1, key_money.length)
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			}
		}
		//--- start 3 วงกลม
		if ((key_number.value.substring(3, 4) == '*') && (key_number.value.length) == 4 &&
			key_money.indexOf('*') == -1 && !isNaN(key_money)) {
			if (updown_type.value == 'บ') {
				play_type = 2 //--  3 บน

				n1 = key_number.value.substring(0, 1)
				n2 = key_number.value.substring(1, 2)
				n3 = key_number.value.substring(2, 3)
				//ถ้ามีเหมือนการ 2 ตัว จะมี 3 ตัวเลข 
				if (n1 == n2 || n1 == n3 || n2 == n3) {
					multi = 3
				} else {
					multi = 6
				}
				money = parseFloat(key_money) * parseFloat(multi)
				//ถ้าไม่เหมือนกันจะมี 6
				calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			}
		}

		//--- start บ+ล 71=100/400 -----
		if ((key_number.value.length) == 2 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1) {

			play_type = 1 // --  2 บน
			money = key_money.substring(0, key_money.indexOf('/')) //-- จำนวนเงินของตัวหน้า
			calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
			//---ทำส่วน ล่าง---			
			play_type = 7 //--  2 ล่าง
			money = key_money.substring(key_money.indexOf('/') + 1, key_money.length)
			calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
		}
		//-- 125=100/200 -----
		if ((key_number.value.length) == 3 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1 && key_money
			.indexOf('*') == -1) {
			play_type = 2 //--  3 บน		
			money = key_money.substring(0, key_money.indexOf('/')) //-- จำนวนเงินของตัวหน้า
			calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			play_type = 8 //--  3 ล่าง
			money = key_money.substring(key_money.indexOf('/') + 1, key_money.length)
			calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)
		}

		//-- 125 = 100*100/50 2006-09-07

		if ((key_number.value.length) == 3 && updown_type.value == 'บ+ล' && key_money.indexOf('/') > -1 && key_money
			.indexOf('*') > -1) {
			//---ทำส่วน บน ก่อน  100  ---			
			play_type = 2 //--  3 บน
			money = key_money.substring(0, key_money.indexOf('*')) //- จำนวนเงินของตัวหน้า
			calcMoney = parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			//--- เลขหลัง * = 3 โต๊ด  *100  
			slash = key_money.indexOf('/')
			star = key_money.indexOf('*')
			money = key_money.substring(star + 1, slash)
			play_type = 3 //--  3 โต๊ด
			calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

			money = key_money.substring(slash + 1, key_money.length)
			play_type = 8 //-- 8 3 ล่าง			
			calcMoney = calcMoney + parseFloat(money) - (parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100)

		}
		if (key_money == "") {
			calcMoney = 0;
		}
		return calcMoney;
	} //end function
	//--20071112

	function getMoney(x, c, l) {
		//x=จำนวนเงินที่คีย์มา
		var id, i, j, o, p_slash
		o = x;
		if (x != '') {
			x2 = x.indexOf('*')
			p_slash = x.indexOf('/')
			if (x2 == 0) {
				x3 = x.substring(x2 + 1, x.length)
				x = parseInt(x3)
			}
			if (x2 > 0) {
				x1 = x.substring(0, x2)
				x3 = x.substring(x2 + 1, x.length)
				if (x1 == '19') {
					x = parseInt(x1) * parseInt(x3)
				} else {
					x = parseInt(x1) + parseInt(x3)
				}
			}
			//----- ถ้าเป็น บ+ล จะต้องบวก เงินเพิ่ม
			//บ+ล	13	=	100*200
			id = c + '1' + l
			up_down = document.getElementById(id)
			if (up_down.value == 'บ+ล') {
				x = parseInt(x) * 2
			}
			//--- 2005-07-01 // 
			//-- ถ้าเป็นกรณีการคีย์วงกลม 123*=100  , 223*=100
			id = c + '2' + l
			next_obj = document.getElementById(id)

			n1 = next_obj.value.substring(0, 1)
			n2 = next_obj.value.substring(1, 2)
			n3 = next_obj.value.substring(2, 3)
			if (next_obj.value.substring(3, 4) == '*') {
				if (n1 != n2 && n2 != n3 && n1 != n3) {
					x = parseInt(x) * 6
				} else {
					x = parseInt(x) * 3
				}
			}

			// ถ้าเป็นกรณี คีย์ บ+ล เงิน 100/200 
			x2 = o.indexOf('/')
			if (x2 > 0) {
				x1 = o.substring(0, x2)
				x3 = o.substring(x2 + 1, o.length)
				x = parseInt(x1) + parseInt(x3)
			}
		}
		if (x == '') {
			x = 0;
		}

		x2 = o.indexOf('*')
		p_slash = o.indexOf('/')
		if (x2 > 0 && p_slash > 0) {
			m1 = o.substring(0, x2)
			m2 = o.substring(x2 + 1, p_slash)
			m3 = o.substring(p_slash + 1, o.length)
			x = parseFloat(m1) + parseFloat(m2) + parseFloat(m3)
		}
		return x
	} //end function


	function canKeyNumber(v) {
		var LengthStr = v.length
		var i
		for (i = 0; i <= LengthStr - 1; i++) {
			a = v.substring(i, parseInt(i) + 1)
			if (!(!isNaN(a) || a == '*')) {
				return true
			}
		}
		return false
	}

	function canKeyUPDN(v) {
		var LengthStr = v.length
		for (i = 0; i <= LengthStr - 1; i++) {
			a = v.substring(i, parseInt(i) + 1)
			if (!(!isNaN(a) || a == '*' || a == '/')) {
				//ถ้าเป็น บ+ล สามารถคีย์เป็น 71-100/400 ได้ = แทง 2 บน 100 2 ล่าง 400
				return true
			}
		}
		return false
	}

	function canKeyStar(v) {
		var LengthStr = v.length
		var star = ''
		var slash = ''
		var i, a, pos_star, pos_slash
		for (i = 0; i <= LengthStr - 1; i++) {
			a = v.substring(i, parseInt(i) + 1)
			if (a == '*') {
				star = star + a
				pos_star = i
			}
			if (a == '/') {
				slash = slash + a
				pos_slash = i
			}
		}
		//-- comment 2006-09-06 
		// ในการคีย์จำนวนเงินต้องมี * / อย่างใดอย่างหนึ่งเท่านั้น
		//if (star!='' && slash!=''){
		//	return false
		//}
		// * มาก่อน /
		if (pos_slash <= pos_star) {
			return false
		}

		if ((star == '*' || star == '') && (slash == '/' || slash == '')) {
			return true
		} else {
			return false
		}
	}

	function click_updown_type(obj) {
		var t = document.b_updown_type.src;
		t = t.substring(t.length - 7, t.length);
		var b = document.getElementById("b_updown_type")
		var l, id, chkcol_money
		var k = event.keyCode
		//--- หาว่า ประเภทการแทง บรรทัดต่อไป
		n = obj.id
		var col = lefty(n, 2) //n.substring(1,2) 
		l = n.substring(3, 5); // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
		var csign = n.substring(1, 2);

		id = col + '1' + l
		next_obj = document.getElementById(id)

		if (t == "low.jpg") {
			document.b_updown_type.src = "images/upp.jpg"
			document.form1.master_pay_type.value = "บ";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ";
			sign_obj.className = "text_blackup";
			sign_obj.style.width = "27"
			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"
		}
		if (t == "upp.jpg") {
			document.b_updown_type.src = "images/ulo.jpg"
			document.form1.master_pay_type.value = "บ+ล";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ+";
			sign_obj.className = "text_black_bg";
			sign_obj.style.width = "17"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_red_bg";
			sign_obj.style.width = "10"
		}
		if (t == "ulo.jpg") {
			document.b_updown_type.src = "images/low.jpg"
			document.form1.master_pay_type.value = "ล";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_reddw";
			sign_obj.style.width = "27"
		}
		// พร้อมกับเปลี่ยน ค่าของ pay_type ของบันทัดนั้นด้วย
		next_obj.value = document.form1.master_pay_type.value
		// กลับไป set focus ที่เดิม
		next_obj = document.getElementById(n)
		if (k != 107) { // ถ้าเป็นการกด + ไม่ต้องเลื่อน focus
			next_obj.focus();
		}
	}

	function displayUPDW(n, updw) {
		var id;
		var csign = n.substring(1, 2)
		var l = n.substring(3, 5); // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
		if (updw == "บ") {
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ";
			sign_obj.className = "text_blackup";
			sign_obj.style.width = "27"
			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"
		}
		if (updw == "บ+ล") {
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ+";
			sign_obj.className = "text_black_bg";
			sign_obj.style.width = "17"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_red_bg";
			sign_obj.style.width = "10"
		}
		if (updw == "ล") {
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_reddw";
			sign_obj.style.width = "27"
		}
	}

	function click_updown_type_label() {
		var t = document.b_updown_type.src;
		t = t.substring(t.length - 7, t.length);
		var b = document.getElementById("b_updown_type")
		var n = document.form1.where_cursor.value

		var l, id, chkcol_money
		var k = event.keyCode
		//--- หาว่า ประเภทการแทง บรรทัดต่อไป
		var col = n.substring(1, 2)
		l = n.substring(3, 5); // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
		var csign = n.substring(1, 2);
		id = 'c' + col + '1' + l;
		next_obj = document.getElementById(id)

		if (t == "low.jpg") {

			document.b_updown_type.src = "images/upp.jpg"
			document.form1.master_pay_type.value = "บ";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ";
			sign_obj.className = "text_blackup";
			sign_obj.style.width = "27"
			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"

		}
		if (t == "upp.jpg") {
			document.b_updown_type.src = "images/ulo.jpg"
			document.form1.master_pay_type.value = "บ+ล";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "บ+";
			sign_obj.className = "text_black_bg";
			sign_obj.style.width = "17"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_red_bg";
			sign_obj.style.width = "10"
		}
		if (t == "ulo.jpg") {

			document.b_updown_type.src = "images/low.jpg"
			document.form1.master_pay_type.value = "ล";
			id = 'signUp' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "";
			sign_obj.className = "";
			sign_obj.style.width = "0"

			id = 'signDw' + csign + l
			sign_obj = document.getElementById(id)
			sign_obj.innerText = "ล";
			sign_obj.className = "text_reddw";
			sign_obj.style.width = "27"

		}
		// พร้อมกับเปลี่ยน ค่าของ pay_type ของบันทัดนั้นด้วย
		next_obj.value = document.form1.master_pay_type.value
		// กลับไป set focus ที่เดิม
		next_obj = document.getElementById(n)
		if (k != 107) { // ถ้าเป็นการกด + ไม่ต้องเลื่อน focus
			next_obj.focus();
		}
	}
</script>
<!--<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.form1.updown_type_col11.value="บ"
	document.form1.master_pay_type.value=document.form1.updown_type_col11.value
	document.form1.all.signUp101.innerText=document.form1.updown_type_col11.value
	document.form1.all.signUp101.className="text_blackup";
	document.form1.key_number_col11.focus();
</SCRIPT>-->
<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	var isNN = (navigator.appName.indexOf("Netscape") != -1);

	function autoTab(input, len, e) {}

	function XautoTab(input, len, e) {
		var keyCode = (isNN) ? e.which : e.keyCode;
		var filter = (isNN) ? [0, 8, 9] : [0, 8, 9, 16, 17, 18, 37, 38, 39, 40, 46];

		if (input.value.length >= len && !containsElement(filter, keyCode)) {
			if (isNaN(input.value)) {
				alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น !!!')
				return false
			}
			input.value = input.value.slice(0, len);
			input.form[(getIndex(input) + 1) % input.form.length].focus();
		}

		function containsElement(arr, ele) {
			var found = false,
				index = 0;
			while (!found && index < arr.length)
				if (arr[index] == ele)
					found = true;
				else
					index++;
			return found;
		}

		function getIndex(input) {
			var index = -1,
				i = 0,
				found = false;
			while (i < input.form.length && index == -1)
				if (input.form[i] == input) index = i;
				else i++;
			return index;
		}
		return true;
	}
//  End -->
function clicksubmit(){	
	
	// เช็คจำนวนเงินต้องไม่เกิน limit_play  หักส่วนลดแล้ว
	if(parseFloat(replaceChars(document.all.this_play_disc.innerText)) > 			parseFloat(replaceChars(document.all.can_play.innerText))){
		alert("เครดิตเต็ม");
		return false;
	}


	if(isNaN(document.form1.ticket_number.value)){
		alert("กรุณากรอก ใบที่ เป็นตัวเลขเท่านั้น!!");
		return false;
	}
	if (document.form1.player_id.value==""){
		alert('กรุณาเลือกคนแทง');
	}
	else{
		if (document.form1.key_number_col11.value==''){
			alert('กรุณาพิมพ์เลขแทง !!!');
			document.form1.key_number_col11.focus();
		}else{
			if (validate_input_data()){
				if(document.form1.first_send.value=="yes"){
					document.form1.first_send.value=""
					document.all.wait_save.innerText="กรุณารอสักครู่"
					document.form1.key_money_col333.readOnly=true;
					document.form1.submit()
				}

		}}
	}
}
function validate_input_data(){
	var id, i, j,ne ,next_obj, obj2,o1,o2,o,onumber
	for (j=1; j<= <%=col_per_page%>; j++){
	    for (i=1; i<=<%=line_per_page%> ; i++){
			id = 'c'+j+'2'+ inc1(i-1) ; 
			o1 = document.getElementById(  id )
			id = 'c'+j+'3'+ inc1(i-1) ; 
			o2 = document.getElementById(  id )
			
			// ถ้าว่างทั้งเงินแทง และเลขแทงไม่เป็นไรผ่านได้
			if (1==1){
				//-- jum 2007-09-10
				id = 'c'+j+'2'+ inc1(i-1) ; 
				o = document.getElementById(  id )	
				if ((o.value).indexOf('.') >=0){
					alert('ผิดพลาด : ป้อนเลขแทงเป็นตัวเลข เท่านั้น !!!')
					o.focus();
					return false
				}	
				//-- jum 2007-09-10

				id = 'c'+j+'3'+ inc1(i-1) ; 
				next_obj = document.getElementById(  id )
				if ( canKeyNumber(next_obj.value) ){
					// ถ้าเป็น บ+ล สามารถคีย์จำนวนเงินแทงเป็น  71=100/400 บน 100 ล่าง 400
					id = 'c'+j+'1'+ inc1(i-1) ; 
					o = document.getElementById(  id )	
					id = 'c'+j+'2'+ inc1(i-1) ; 
					onumber= document.getElementById(  id )			
					// 2007-02-23
					if (o.value=="บ+ล" ){
						x=next_obj.value						
						x2=x.indexOf('*')
						x3=x.indexOf('/')
						if(x2==0){
							alert('ผิดพลาด : ป้อนจำนวนเงินแทงไม่ถูกต้อง !!!')
							return false
						}
						//2007-03-19   บ+ล 999 =999*999/999
						if (x2!=-1 && x3!=-1 && onumber.value.length<3){
							alert('ผิดพลาด : ป้อนจำนวนเงินแทงไม่ถูกต้อง !!! '+x)
							onumber.focus();
							return false
						}
						if (x2>x3 && onumber.value.length<=3){
							alert('ผิดพลาด : ป้อนจำนวนเงินแทงไม่ถูกต้อง !!! 999=999*999/999')
							return false
						}
						//2007-03-19   บ+ล 999 =999*999/999
					}

					if (o.value=="บ+ล" && onumber.value.length<=3){
						if ( canKeyUPDN(next_obj.value) ){
							alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] , * หรือ / เท่านั้น !!!')
							return false;
						}
					}else{
						alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] หรือ * เท่านั้น !!!')
						return false;
					}
					
				}

				id = 'c'+j+'2'+ inc1(i-1) ; 
				obj2 = document.getElementById(  id )
				if( isNaN(lefty(obj2.value,3))){
					alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น \n ถ้าต้องการแทงเลขวงกลม ต้องคีย์แบบ  123*')
					obj2.focus();
					return false
				}	
				// ให้ผ่านได้  2005-07-20
				//if (obj2.value!=''){
				//	if (next_obj.value==''){
				//		alert('ผิดพลาด : กรุณาตรวจสอบจำนวนเงินแทง xxx!!!')
				//		next_obj.focus();
				//		return false
				//	}
				//}
				// ให้ผ่านได้  2005-07-20
				id = 'c'+j+'1'+ inc1(i-1) ; 
				o = document.getElementById(  id )	
				// เลขแทง กรอก 123* ได้  ตัวที่ 4 เป็น * ได้เท่านั้น
				if (obj2.value.length==4){
					if (obj2.value.substring(3,4)!="*" && obj2.value.substring(3,4)!=' ' ){
						alert('ผิดพลาด : ถ้าต้องการแทงเลขวงกลม ต้องคีย์แบบ  123* !!!')
						obj2.focus();
						return false
					}	
					if (o.value!='บ'){
						alert('ผิดพลาด : วงกลมแทงได้เฉพาะ บน เท่านั้น !!!')
						return false
					}					
					var n1,n2,n3
					n1=obj2.value.substring(0,1)
					n2=obj2.value.substring(1,2)
					n3=obj2.value.substring(2,3)
					if (n1==n2 && n2==n3 && n1==n3){
						alert('ผิดพลาด : เลขตองไม่ต้องแทงแบบวงกลม  !!!')
						return false
					}

					if( isNaN(next_obj.value)){
						alert('ผิดพลาด : วงกลม เลขแทง ต้องเป็นตัวเลขเท่านั้น !!!')
						next_obj.focus();
						return false
					}
				}
				// การแทง บ+ล ห้ามคีย์เลข 3 ตัว 
				//if (o.value=="บ+ล"){
				//	if (obj2.value.length>=3){
				//		alert('ผิดพลาด : แทง บ+ล ห้ามคีย์เลขแทง 3 หลัก !!!')
				//		return false
				//	}
				//} 
				// ให้ผ่านได้  2005-07-20
				//if (next_obj.value!=''){
				//	if (obj2.value==''){
				//		alert('ผิดพลาด : กรุณาตรวจสอบ เลขแทง !!!')
				//		obj2.focus();
				//		return false
				//	}
				//}
				// ให้ผ่านได้  2005-07-20
				//ที่ช่องจำนวนเงิน ห้ามคีย์  * 2 ครั้ง 
				if (!canKeyStar(next_obj.value)){
					alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงให้ถูกต้อง !!!')
					return false;
				}

				// จำนวนเงินแทงต้อง มากกว่า 0 เอากลับมาเช็คใหม่ 8/5/49
				if (obj2.value!=''){
					if (next_obj.value<=0){
						alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงต้องมากกว่า 0 !!!')
						return false;
					}
				}
				//----------------------------------
				id = 'c'+j+'1'+ inc1(i-1) ; 
				o1 = document.getElementById(  id )
				id = 'c'+j+'2'+ inc1(i-1) ; 
				o2 = document.getElementById(  id )
				id = 'c'+j+'3'+ inc1(i-1) ; 
				o3 = document.getElementById(  id )
				if (o1.value!='' && o2.value!='' && o3.value!=''){
					if ( ! validate_1(o1,o2,o3)){
						o3.focus();
						return false
					}
				}
				//jum 2007-11-12
				if(!(GetPlayType_Money(o1,o2,o3))){
					o3.focus();
					return false
				}
				//----------------------------------
			}			
		}
	}
	return true
}
function validate_1(o1,o2,o3){
	// เป็น function ที่เหมือนกับ validate_input_data แต่ทำแค่ 1 รายการ ให้ ตรวจสอบกับกรณีที่มีการ copy จำนวนเงินจากบรรทัดบน
	if (o1.value=='บ'){
		if ( !isNaN(o2.value) && !isNaN(o3.value) ){
			return true;
		}
		if (o2.value.length>1  && o3.value.indexOf('*') >0 && lefty(o3.value,3)!='19*' ){
			return true;
		}
		if (o2.value.length==1  && lefty(o3.value,3)=='19*'){
			return true;
		}
		if (o2.value.indexOf('*') >0   && !isNaN(o3.value)  ){
			return true;
		}
		if (o2.value.length>1 && o3.value.indexOf('*') ==0 ){
			return true;			
		}
	}
	if (o1.value=='บ+ล'){

		if (o2.value.length>1 && o2.value.length<3  && o3.value.indexOf('*') > 0  ){
			return true;
		}
		if (o2.value.length>1  && !isNaN(o3.value)  ){
			return true;
		}
		if (o2.value.length>1   && o3.value.indexOf('/') >0    ){
			return true;
		}
	
	}
	if (o1.value=='ล'){
		if ( !isNaN(o2.value) && !isNaN(o3.value) ){
			return true;
		}
		if (o2.value.length==1  && lefty(o3.value,3)=='19*'){
			return true;
		}
		if (o2.value.length==2  && o3.value.indexOf('*') >0 && lefty(o3.value,3)!='19*'){
			return true;
		}
	}
	alert('ผิดพลาด : การคีย์แทงอยู่นอกเหนือจากที่กำหนด');
	return false;
}
function iBlur(o){
		//if (document.form1.keep_old_value.value=="yes")
		//{
		document.form1.where_cursor.value=o.id
		document.form1.oldmoney.value=o.value
		//}
	//alert(o.value + " oldmoney onBlur")
}
function desc1(l) {
	if (l=="08"){l="8"}
	if (l=="09"){l="9"}
	l=parseInt(l)-1
	if (l <=9){ 
		l="0" + l
	}
	return (l);	
}
function inc1(l) {
	if (l=="08"){l="8"}
	if (l=="09"){l="9"}
	l=parseInt(l) +1
	if (l <=9){ 
		l="0" + l
	}
	return (l);	
}

function convert_number(obj){
	var value=obj;
		if(value!=""){							
			return formatnum(value) ;		   
		}
	}	
function replaceChars(entry) {//obj
		out = ","; // replace this
		add = ""; // with this
		temp = "" + entry ; // temporary holder
		
				while (temp.indexOf(out)>-1) {
					pos= temp.indexOf(out);
					temp = "" + (temp.substring(0, pos) + add + 
					temp.substring((pos + out.length), temp.length));
				}
		return temp;
	}	
</script>
<script language="vbscript">
	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>
<script language="javascript">
	// open search player name
    function SearchPlayer() {

            openDialog('search_player_bydealer.asp?dealer_id=<%=dealer_id%>&game_type=<%=game_type%>&call_from=<%=call_from%>', 8, 5, 250, 650);

        }  
</script>
<script language="JavaScript">

    function chkKey(e) {
        var kc;
    if (window.event){
        kc = window.event.keyCode;
    }
    else {
        kc = e.which;
    }

	 //if (document.all){
	 // kc = event.keyCode; // IE
	 //}else{
	 // kc = e.which; // NS or Others
	 //} 
	 // ค่า kc คือค่า Unicode Charactor ที่เป็นตัวเลข
	 
	if (kc=='121' ){ //F10
	    clicksubmit();
	}	
	
	if (kc=='113' ){ //F2
		SearchPlayer();
	}
	if (kc=='118' ){ //F7
		document.form1.ticket_number.focus();
	}
}
	document.onkeydown=chkKey
	window.focus();
	//-- user key ticket number เอง
	//document.all.tnumber.innerText="<%=tnumber%>"
	document.all.ticket_number.value="<%=tnumber%>"
	document.all.send.innerText="<%=send%>"
	document.all.receive.innerText="<%=receive%>"
	document.all.wait.innerText="<%=wait%>"
	document.all.ret.innerText="<%=ret%>"		
	document.all.total.innerText="<%=total%>"	
	document.all.limit_play.innerText="<%=limit_play%>"	
	document.all.can_play.innerText="<%=can_play%>"	
	
	function chkEnterNumber(obj){
		
			var k=event.keyCode
			if (k == 13){	
				id='c1201';
				next_obj = document.getElementById( id )	
				next_obj.focus();
			}

	}

</script>
<%
Sub PrintLimitNumber(game_id)
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select * from sc_user where user_id=" & Session("uid") & " and active_LimitMoney=1 " 
		Set objRS=objDB.Execute(SQL)
		If Not objRs.eof then
		%>
		<!-- ถ้าเจ้ามือมีการใช้เลขเต็ม -->
		
		<TR>
			<TD align="center" class="head_red" style="background-color:#FCC;"><font size="+2">เลขเต็ม</font></TD>
		</TR>
		<TR>
			<TD>
				<TABLE width="100%" border="1" cellSpacing=0 cellPadding="5" align="center" bordercolor="#0066FF">
					<TR>
						<TD class="head_red" align="center">2 บน</TD>
						<TD class="head_red" align="center">2 ล่าง</TD>
						<TD class="head_red" align="center">3 บน</TD>
						<TD class="head_red" align="center">3 โต๊ด</TD>
					</TR>
					<%
					SQL="exec spJ_GetNumberLimitMoneyByGameID " & Session("uid") & ", " & game_id
					'response.write SQL
					Set objRS=objDB.Execute(SQL)
					While Not objRS.eof
						%>
							<tr>  
								<td class="head_white" align="center"><font color="blue"><%=objRS("number_up2")%></font></td>
								<td class="head_white" align="center"><font color="red"><%=objRS("number_down2")%></font></td>
								<td class="head_white" align="center"><font color="blue"><%=objRS("number_up3")%></font></td>
								<td class="head_white" align="center"><font color="red"><%=objRS("number_tod3")%></font></td>
							</tr>
						<%
						objRS.MoveNext
					wend
					%>
				</TABLE>
			</TD>
			<!-- ถ้าเจ้ามือมีการใช้เลขเต็ม -->
			<%
			End if
			%>
		</TR>
		<%
		set objRS=nothing
		set objDB=Nothing
End Sub 
%>

<script language="javascript">

function chk_limit_number(play_type,key_number,key_money){
		//ถ้าใช้กับคนแทง ไม่ต้องเช็ค	
		//alert("<%=limit_number_for%>"+"xxxxx"+"<%=limit_number_thispage%>")		
		if("<%=active_LimitMoney%>"=="0"){ // ' 1 ใช้ 0 ไม่ใช้
			return true;
		}
		if(!("<%=limit_number_for%>"=="<%=limit_number_thispage%>")){
			return true;
		}
		//090815 เช็ค limit จาก ar_limit 	
		// ใช้ใน ChkMaxMoney
		//ถ้าจำนวนเงินมี * สลับเลขโต๊ดใหม่ 

        ar_limit = (document.all.obj_limit_number.value).split(",");
        ar_limitmoney = (document.all.obj_limit_numbermoney.value).split(",");
		if (key_money.indexOf('*') >=0){
			key_number=tod3order(key_number);
			if(key_number.length==3){
				play_type=3;//alert("test")
			}
		}
		for( i = 0; i < ar_limit.length; i++ ) {				
			string = ar_limit[i].split( "|" ); 
			if( string[0] == play_type ) {
				if(key_number==string[1]){
					alert("เลขเต็มแล้ว !!!");
					return false;
				}
			}
		}

		for( j = 0; j < ar_limitmoney.length; j++ ) {	
		    string2 = ar_limitmoney[j].split( "|" ); 
		    if( string2[0] == play_type ) {
		        if(key_number==string2[1]){
		            if(key_money > string2[2]){
		                alert("ยอดแทงเลขเกินแล้ว !!! เหลือยอดแทง " + string2[2]);
		                return false;
		            }
		        }
		    }
		}//play_type,limit_number,balance_amt

		//++++++++++++++++++++ถ้าตัวเลขมี * ตัด * ออกแล้วหาใหม่ว่าซ้ำหรือไม่  3 กลับ
		if (key_number.indexOf('*') >=0){
			var n_key_number=tod3order(key_number);
			for( i = 0; i < ar_limit.length; i++ ) {				
				string = ar_limit[i].split( "|" ); 
				if( string[0] == 2 ) {
					if(n_key_number==tod3order(string[1])){
						alert("เลขเต็มแล้ว !!!");
						return false;
					}
				}
			}
			for( j = 0; j < ar_limitmoney.length; j++ ) {	
			    string2 = ar_limitmoney[j].split( "|" ); 
			    if( string2[0] == 2 ) {
			        if(n_key_number==tod3order(string2[1])){
			            if(key_money > string2[2]){
			                alert("ยอดแทงเลขเกินแล้ว !!! เหลือยอดแทง " + string2[2]);
			                return false;
			            }
			        }
			    }
			}
		}
		// 2 บน
		if (key_number.length==1 && lefty(key_money,3)=='19*'){ 		
			for( i = 0; i < ar_limit.length; i++ ) {				
				string = ar_limit[i].split( "|" ); 
				if( string[0] == play_type ) {
					if(key_number==string[1].substring(0,1) ){
						alert("เลขเต็มแล้ว !!!");
						return false;
					}
				}
			}
			for( j = 0; j < ar_limitmoney.length; j++ ) {	
			    string2 = ar_limitmoney[j].split( "|" ); 
			    if( string2[0] == play_type ) {
			        if(key_number==string2[1].substring(0,1)){
			            key_money = key_money.substring(key_money.indexOf('*')+1, key_money.length) ;
			            if(key_money > string2[2]){
			                alert("ยอดแทงเลขเกินแล้ว !!! เหลือยอดแทง " + string2[2]);
			                return false;
			            }
			        }
			    }
			}
		}
		//++++++++++++++++++++ถ้าตัวเลขมี * ตัด * ออกแล้วหาใหม่ว่าซ้ำหรือไม่  3 กลับ

		return true;
	}
	function tod3order(obj){
	// เรียงเลขใหม่ 
		var n1,n2,n3, x1,x2,x3,x4,x5,x6, xMin
		n1=obj.substring(0,1)
		n2=obj.substring(1,2)
		n3=obj.substring(2,3)
		x1=n1+n2+n3;
		x2=n1+n3+n2;
		x3=n3+n2+n1;
		x4=n2+n1+n3;
		x5=n2+n3+n1;
		x6=n3+n1+n2;
		xMin=x1;
		if(xMin>x2){xMin=x2;}
		if(xMin>x3){xMin=x3;}
		if(xMin>x4){xMin=x4;}
		if(xMin>x5){xMin=x5;}
		if(xMin>x6){xMin=x6;}
		return xMin;	
	}
	function default_up_type_label() {
	    var t = document.b_updown_type.src;
	    t = t.substring(t.length - 7, t.length);
	    var b = document.getElementById("b_updown_type")
	    var n = document.form1.where_cursor.value

	    var l, id, chkcol_money
	    var k = event.keyCode
	    //--- หาว่า ประเภทการแทง บรรทัดต่อไป
	    var col = n.substring(1, 2)
	    l = n.substring(3, 5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
	    var csign = n.substring(1, 2);
	    id = 'c' + col + '1' + l;
	    next_obj = document.getElementById(id)

	        document.b_updown_type.src = "images/upp.jpg"
	        document.form1.master_pay_type.value = "บ";
	        id = 'signUp' + csign + l
	        sign_obj = document.getElementById(id)
	        sign_obj.innerText = "บ";
	        sign_obj.className = "text_blackup";
	        sign_obj.style.width = "27"
	        id = 'signDw' + csign + l
	        sign_obj = document.getElementById(id)
	        sign_obj.innerText = "";
	        sign_obj.className = "";
	        sign_obj.style.width = "0"

	    // พร้อมกับเปลี่ยน ค่าของ pay_type ของบันทัดนั้นด้วย
	    next_obj.value = document.form1.master_pay_type.value
	    // กลับไป set focus ที่เดิม
	    next_obj = document.getElementById(n)
	    if (k != 107) { // ถ้าเป็นการกด + ไม่ต้องเลื่อน focus
	        next_obj.focus();
	    }
	}
</script>