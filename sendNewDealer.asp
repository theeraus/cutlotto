<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim ticket_id , user , pass, dealer_id, mess, RndPw, strPw, new_ticket_id, i
		mess=""	
		Dim ticket_number, rec_status, send_status, key_from, key_id
		Dim updown_type, key_number,	key_money, key_seq, number_status, delaer_name,user_id

		Dim objRS , objDB , SQL, objRS1		
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		Set objRS1 =Server.CreateObject("ADODB.Recordset")	
		Dim from_click_submit , player_id , game_id, login_ok
		from_click_submit=Request("from_click_submit")
		ticket_id=Request("ticket_id")
		dealer_id=Request("dealer_id")
		user=Request("user_x")
		pass=Request("pass_x")
		if  from_click_submit="yes" then
			'// กรณีที่ ต้องนำเลขคืนไป แทง กับเจ้ามืออื่น 			
			SQL="select a.user_id,a.create_by, a.user_password from sc_user a "
			SQL=SQL & " inner join sc_user b on a.create_by=b.user_id "
			SQL=SQL & " where ( a.login_id='" &  user &  "' or a.user_name='" & user & "' ) and a.user_password='" & pass & "' and "
			SQL=SQL & " (b.login_id='" & 	dealer_id & "' or b.user_name='" & dealer_id & "' )"
'response.write SQL
'response.end
			Set objRS=objDB.Execute(SQL)
			login_ok="no"

			if not objRS.eof then
				login_ok="ok"
				user_id=objRS("user_id")
			else
				SQL="select * from sc_user a "
				SQL=SQL & " inner join sc_user b on a.create_by=b.user_id "
				SQL=SQL & "where a.login_id='" & user & "' and a.user_password='" & pass & "'"
				SQL=SQL & " and ("
				SQL=SQL & " b.login_id='" & 	dealer_id & "' or b.user_name='" & dealer_id & "'"
				SQL=SQL & ")"
				Set objRS=objDB.Execute(SQL)
				if not objRS.eof then
					login_ok="ok"
					user_id=objRS("user_id")
				end if				
			end if
			if login_ok="ok" then
				player_id=objRS("user_id")
				SQL="exec spChkUser_Dealer '" & dealer_id & "','" & user_id & "'"
				'response.write SQL
				'response.end
				Set objRS=objDB.Execute(SQL)
				if not objRS.eof then
					'-- หา gameID
					dealer_id=objRS("user_id")
					SQL = "select * from tb_open_game where dealer_id=" & dealer_id & " And game_active='A'"
					Set objRS=objDB.Execute(SQL)
					if not objRS.eof then
						game_id=objRS("game_id")
					else
						mess="ผิดพลาด : เจ้ามือปิดรับแล้ว !!"
					end if
				else
					mess="ผิดพลาด : เลือกเจ้ามือ กับ ชื่อ/รหัสผ่าน ไม่ถูกต้อง "			
				end if
			else
				mess="ผิดพลาด : ชื่อ รหัสผ่านไม่ถูกต้อง !!"
			end if
			if mess<>"" then
				%><script language="javascript">
					alert('<%=mess%>')
					</script>
				<%
			else	
				'// ถ้า user/pass และรหัสเจ้ามือถูกต้อง 
				'--- insert into tb_ticket		
				ticket_number=Getticket_number(player_id , game_id )
				rec_status=1 ' ส่ง
				send_status=1     ' 2 = ส่งต่อเจ้ามืออื่น // 1  ' ส่งเจ้ามือเจ้าของ
				key_from=1       ' แทงจาก com 
				key_id=Session("uid")
				SQL="exec spInsert_tb_ticket " & game_id & ", "  & _
																	ticket_number & ", " & _
																	player_id & ", " & _
																	rec_status  & ", " & _
																	send_status	 & ", " & _
																	key_from & ", " & _
																	key_id
				set objRS=objDB.Execute(SQL)																
				if not objRS.EOF then
					new_ticket_id=objRS("ticket_id")
					'// update รหัสโพยอ้างอิงกับโพยใบเดิมที่ถูกเจ้ามือเก่าคืนเลขมา
					SQL="update tb_ticket set old_ref_id=" & ticket_id & " where ticket_id=" & ticket_id
					set objRS1=objDB.Execute(SQL)

					'// insert  tb_ticket_key 
					SQL="exec spGet_tb_ticket_key_by_ticket_id_Ret " & ticket_id
					set objRS1=objDB.Execute(SQL)
					i=1
					while not objRS1.eof
						updown_type=objRS1("updown_type")
						key_number=objRS1("key_number")
						key_money=objRS1("Ret_money")
						key_seq=i
						number_status=1    '  ส่ง
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										new_ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
						end if
						objRS1.MoveNext
					wend
					'---  update tb_ticket .send_status = 2 ส่งต่อเจ้ามืออื่น ที่ ticket ใบเดิม
					SQL="update tb_ticket set send_status=2 where ticket_id=" & ticket_id
					set objRS=objDB.Execute(SQL)

					SQL="select rtrim(ltrim(first_name))+' '+	rtrim(ltrim(last_name)) delaer_name from sc_user where user_id=" & dealer_id
					set objRS=objDB.Execute(SQL)
					if not objRS.eof then
						delaer_name=objRS("delaer_name")
					end if
					'// เก็บ ประวัติการส่งเจ้ามืออื่นเอาไว้ เพื่อใช้ในการแสดงชื่อเจ้ามือ ตอนส่งเจ้าอื่น ครั้งต่อไป
					SQL="insert into send_new_dealer ([user_id],dealer_id) values (" & Session("uid") & ", " & dealer_id & ")"
					set objRS=objDB.Execute(SQL)
				end if
				%>
				<script language="javascript">
					alert('ได้ทำการส่งเจ้ามือ <%=delaer_name%> \n เรียบร้อยแล้ว')		
					//parent.closeDialog();
					window.open('index.asp?page=ret_number.asp','_top')
					//refreshParent() 
					// ต้องเลื่อนเลขคืนเป็นใบแรก หลังจากที่ส่งเจ้ามืออื่นแล้วจะไม่แสดงที่เลขคืน
				</script>
				<%	
			end if
		end if '// end กด click OK 
%>
<html>
<head>
<title>.:: ส่งเจ้าอื่น : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0" leftmargin="0" scroll = no  style="border : solid #0B02B5; border-width : 1px;">
	<form name="form1" action="sendNewDealer.asp" method="post">
	<table align="center" cellpadding="0" cellspacing="0" width="100%" border="0">
	<tr bgcolor="#0B02B5">
			<td height="25" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td> &nbsp;&nbsp; <span id=search_text></span></td>
						<td  align="right"><img src="images/close.gif" align="absmiddle" style="cursor:hand; " onClick="parent.closeDialog()">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="10">
			<td></td>
		</tr>
		<tr>
			<td align="center" >			
				<table  border="0"  cellpadding="1" cellspacing="0" width="90%">
					<tr>
						<td class="tdbody_navy" width="60" colspan="2">ส่งเจ้าอื่น</td>
					</tr>
					<tr height="35">
						<td class="text_blue">ชื่อ/รหัส เจ้ามือ</td>
						<td><input type="text" name="dealer_id"  size="20" maxlength="20" 
							value="<%=SendNew_Dealer(Session("uid"))%>" onKeyDown="chkEnter(this);" >						
					</tr>
					<tr>
						<td class="text_blue">ชื่อ</td>
						<td><input type="text" name="user_x" size="20" onKeyDown="chkEnter(this);"></td>
					</tr>
					<tr>
						<td class="text_blue">รหัสผ่าน</td>
						<td><input type="password"  name="pass_x" size="20" onKeyDown="chkEnter(this);"></td>
					</tr>
					<tr height="35">
						<input type="hidden" name="from_click_submit" value="yes">
						<input type="hidden" name="ticket_id" value="<%=ticket_id%>">						
						<td colspan="2" align="center"><input type="button" value=" ตกลง " onClick="clickOK()" style="cursor:hand;" id="bok">
						&nbsp;&nbsp;<input type="button" value=" ยกเลิก " onClick="clickCancel()" style="cursor:hand;" id="bcancel">
						</td>
					</tr>
					<tr>
						<td class="tdbody_navy" width="60" colspan="2"> &nbsp;</td>
					</tr>
				</table>
			</td>		
		</tr>
	</table>
	</center>
	</form>
</body>
</html>
<script language="javascript">
	function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			if(obj.name=="dealer_id"){
				document.form1.user_x.focus();
			}
			if(obj.name=="user_x"){
				document.form1.pass_x.focus();
			}
			if(obj.name=="pass_x"){
				document.all.form1.bok.focus();
			}
		}
	}
	function clickOK(){
		if (document.form1.dealer_id.value==''){
			alert('กรุณาป้อน ชื่อ หรือ รหัส เจ้ามือ');
			document.form1.dealer_id.focus();
			return false;
		}
		if (document.form1.user_x.value==''){
			alert('กรุณาป้อน ชื่อ หรือ หมายเลข ของคุณ !!');
			document.form1.user_x.focus();
			return false;
		}
		if (document.form1.pass_x.value==''){
			alert('กรุณาป้อน รหัสผ่าน');
			document.form1.pass_x.focus();
			return false;
		}
		document.form1.submit();
	}
	function clickCancel(){
	parent.closeDialog();
	}
</script>
<%
Function EncryptPws(ByVal inPws, byval RndPw)
Dim LenPws
Dim enPws
Dim I
dim tmp
Dim chkRnd
        If RTrim(inPws) = "" Then
                EncryptPws = ""
                Exit Function
        End If
        chkRnd = RndPw
        LenPws = Len(inPws)
        enPws = chkRnd	
        If chkRnd=1 Then
			tmp=LenPws
			if len(tmp)=1 then tmp = "0" & tmp
			enPws = enPws & tmp          
        End If
        
        For I = LenPws To 1 Step -1
		'	tmp=I
			tmp =(Asc(Mid(inPws, I, 1)) * (chkRnd + 1) + LenPws)
			if len(tmp)=1 then tmp = "00" & tmp
			if len(tmp)=2 then tmp = "0" & tmp
            enPws = enPws & tmp
        Next         
        If chkRnd=0 Then
			tmp=LenPws
			if len(tmp)=1 then tmp = "0" & tmp
            enPws = enPws & tmp
        End If
        EncryptPws = enPws
        
End Function
Function Getticket_number( p, g )
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetticket_number " & p & "," & g & ",1"
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	else
		Getticket_number=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function SendNew_Dealer(u)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetName_NewDealer " & u
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		SendNew_Dealer = objRS("user_name")
	else
		SendNew_Dealer=""
	end if
	set objRS=nothing
	set objDB=nothing
End Function

%>
<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.form1.dealer_id.focus();
</SCRIPT>