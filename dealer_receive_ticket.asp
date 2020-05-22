<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim ticket_id, line_per_page,i,j,k , dealer_id
		dealer_id	=Session("uid")
		line_per_page=33
		ticket_id=Request("ticket_id")
		if ticket_id="" then
			response.write "ไม่มี ticket_id"
			response.end
		end if

		Dim objRS , objDB , SQL		
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Dim status_ticket 	

		status_ticket=Request("status_ticket")
		
		if status_ticket="exit_ticket" then
			set objRS=nothing
			set objDB=nothing
			response.redirect ("firstpage_dealer.asp")
		end if

'		objRS.close

		if status_ticket="receive_ticket" then
			'------ update รับหมดที่ tb_ticket , tb_ticket_key , tb_ticket_number
			SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
			set objRS=objDB.Execute(SQL)

			SQL = "Update tb_ticket set rec_date=GetDate() where ticket_id = "  & ticket_id
			set objRS=objDB.Execute(SQL)
			
			set objRS=nothing
			set objDB=nothing
			response.redirect ("firstpage_dealer.asp")
			' กลับไปหน้าแรก
		end if

		if status_ticket="edit_ticket" then
			response.redirect("key_dealer.asp?ticket_id=" & ticket_id )
		end if
			
		if status_ticket="return_ticket" then '----- ไม่รับ
			SQL="exec spUpdReject_ticket_status_by_ticket_id " & ticket_id
			set objRS=objDB.Execute(SQL)
			SQL = "Update tb_ticket set rec_date=GetDate() where ticket_id = "  & ticket_id
			set objRS=objDB.Execute(SQL)
			
			set objRS=nothing
			set objDB=nothing
			response.redirect ("firstpage_dealer.asp")
		end if
%>			
<html>
<head>
<title>.:: คิวโพยเข้า : เจ้ามือ ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="include/code.css" rel="stylesheet" type="text/css">

<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

<script>
function change (picurl,n) {
	if (n==1){	
		document.pictureGov.src = picurl;
	}
	if (n==2){	
		document.pictureTos.src = picurl;
	}
	if (n==3){	
		document.pictureOth.src = picurl;
	}
}
</script>
</head>
<body topmargin="0"  leftmargin="0">
	<center>
	<form name="form1" action="dealer_receive_ticket.asp" method="post">
	<input type="hidden" name="status_ticket" >
	<input type="hidden" name="ticket_id" value="<%=ticket_id%>">
	<table border=0>
		<tr valign="center">			
			<td>
	<%
		Dim player_id, game_id
		SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
		set objRS=objDB.Execute(SQL)	
		if not objRS.eof Then
			player_id=objRS("player_id")
			game_id=objRS("game_id")
			%>
			<table  border="0"  cellpadding="1" cellspacing="0" width="500">
				<tr>
					<td class="tdbody_red">เลขที่  &nbsp;<%=objRS("login_id")%></td>
					<td class="tdbody_red">ชื่อ &nbsp;<%=objRS("player_name")%></td>
					<td class="tdbody">ใบที่ &nbsp;<%=objRS("ticket_number")%></td>
					<td class="tdbody">ยอดแทงรวม  &nbsp;<%=formatnumber(GetTotalPlay(objRS("player_id"),objRS("game_id")),0)%></td>
					<td class="tdbody">ยอดใบนี้ &nbsp;<%=formatnumber(objRS("total_play_amt"),0)%></td>
				</tr>
			</table><br>
			<%
			SQL="exec spGet_tb_ticket_key_by_ticket_id " & ticket_id

'response.write SQL
			set objRS=objDB.Execute(SQL)
			Dim ar_disp
			reDim ar_disp(99,4)
			Dim type_show
			i=1
			if not objRS.eof then
				while not objRS.eof
					ar_disp(i,1)=objRS("updown_type")
					type_show=objRS("str_updown_type")
					If InStr( objRS("str_updown_type"),"ล") Then 
						type_show=Replace(type_show,"ล","<font color='red'>ล</font>")
					End if
					ar_disp(i,2)=type_show

'response.write objRS("str_updown_type")  & "<br>"

					ar_disp(i,3)=objRS("key_number")
					ar_disp(i,4)=objRS("key_money")
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1" width="500" bgcolor="#D4D4D4" class="table"><%
				for i=1 to 33
					j=i+line_per_page
					k=j+line_per_page					
				%>
				<tr>					
					<td class="tdbody_red" width="40" align="center" nowrap>&nbsp;<%=ar_disp(i,2)%>&nbsp;</td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(i,4)%></td>
				
					<td class="tdbody_red" width="40" align="center" nowrap>&nbsp;<%=ar_disp(j,2)%>&nbsp;</td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(j,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(j,4)%></td>

					<td class="tdbody_red"  width="40"  align="center" nowrap>&nbsp;<%=ar_disp(k,2)%>&nbsp;</td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(k,3)%></td>
					<td class="tdbody" align="center">&nbsp;=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(k,4)%></td>

					<td class="tdbody_red" width="20" align="right"><%=i%></td>
				</tr>
				<%
				next
				%></table><%
			end if
		end if
		set objRS=nothing
		set objDB=nothing
	%>
			</td>
			<td>
				<table class="table">
					<tr>
						<td>
						<input type="button" class="inputG" value="รับ" onClick="click_receive();" style="cursor:hand;width: 75px; ">
						</td>
					</tr>
					<tr>
						<td>
						<input type="button" class="inputE" value="แก้ไข/รับ" onClick="click_edit();" style="cursor:hand;width: 75px; ">
						</td>
					</tr>
					<tr>
						<td>
						<input type="button" class="inputR" value="ไม่รับ" onClick="click_return();" style="cursor:hand;width: 75px; ">
						</td>
					</tr>
					<tr><td>	&nbsp;</td></tr>
					<tr><td>	&nbsp;</td></tr>
					<tr>
						<td>
						<input type="button" class="inputE" value="ออก" onClick="click_exit();" style="cursor:hand;width: 75px; ">
						</td>
					</tr>
				</table>
			</td>
			<!-- แสดงอัตราจ่าย -->
			<td>
				<table height="100%">
					<tr>
						<td>
						<% Call PrintPrice(dealer_id, player_id, game_id) %>
						</td>
					</tr>
				</table>
			</td>
			<!-- แสดงอัตราจ่าย -->
		</tr>
	</table>

	</form>
	</center>
</body>
</html>
<%

Function GetTotalPlay(p,g)
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
%>
<script language="javascript">
	function click_receive(){
		document.form1.status_ticket.value="receive_ticket";	
		document.form1.submit();
	}
	function click_edit(){
		document.form1.status_ticket.value="edit_ticket";	
		document.form1.submit();
	}
	function click_return(){
		document.form1.status_ticket.value="return_ticket";	
		document.form1.submit();
	}
	function click_exit(){
		document.form1.status_ticket.value="exit_ticket";	
		document.form1.submit();
	}
	
</script>
<%
Sub PrintPrice(dealer_id, player_id, game_id)
	Dim objRS , objDB , SQL, login_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim game_type
	SQL="select game_type from tb_open_game where game_id=" & game_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		game_type=objRS("game_type")
	End If 
	SQL="select login_id from sc_user where user_id=" & player_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		login_id=objRS("login_id")
	End If 
	%>		
		<table width="300"  border="0" cellspacing="1" cellpadding="1" bgcolor="#E8E8E8">
				<%
				Dim bgcolor
				select case game_type
						case 1
							bgcolor="red"
						case 2
							bgcolor="red"
						case 3
							bgcolor="red"					
				end select
				%>
				<tr>
					<td class="tdbody1" align="left" bgcolor="<%=bgcolor%>" colspan="3">
						<%=GetGameDesc(game_type)%>		
					</td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#ff9999" align="left">หมายเลข : <%=login_id%></td>
					<td class="tdbody1" bgcolor="#ff9999" align="left" colspan="2">ชื่อ : <%=GetPlayerName(player_id)%></td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">ชนิด</td>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">จ่าย</td>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">ลด (%)</td>
				</tr>
				<%
					SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
					set objRS=objDB.Execute(SQL)
					i=1
					while not objRS.eof
						if objRS("ref_det_desc")=" " then
				%>
					<tr>
						<td class="tdbody1" bgcolor="#ffd8cc" align="center">&nbsp;</td>
						<td bgcolor="#ff9999" align="center" >&nbsp;</td>
						<td bgcolor="#ff9999" align="center">&nbsp;</td>
					</tr>
				<%
						else
				%>
					<tr>
						<td class="tdbody1" bgcolor="#ffd8cc" align="center">&nbsp;<%=objRS("ref_det_desc")%></td>
						<td bgcolor="#ff9999" align="center" >
							<input type="text" name="p<%=objRS("play_type")%>"  value="<%=objRS("pay_amt")%>" class="input1" size="5" maxLength="3" id="idL<%=i%>" onKeyDown="chkEnter(this);" >
						</td>
						<td bgcolor="#ff9999" align="center">
							<input type="text" name="d<%=objRS("play_type")%>" value="<%=objRS("discount_amt")%>" class="input1" size="5" maxLength="2" 
							id="idR<%=i%>" onKeyDown="chkEnter(this);">
						</td>
					</tr>
				<%
						i=i+1
					end if
					objRS.MoveNext
					wend
				%>
			</table>		
			<table>
				
					<%
					SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	
					Set objRS=objDB.Execute(SQL)
					Dim limit_play
					Dim can_play,sum_play
					If Not objRS.eof Then						
						If CDbl(objRS("limit_play"))>0 then
							limit_play=FormatNumber(objRS("limit_play"),0)
						Else
							limit_play=0
						End if
						If CDbl(objRS("sum_play"))>0 then
							sum_play=FormatNumber(objRS("sum_play"),0)
						Else
							sum_play=0
						End If								
						If ( CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")) ) > 0 Then
							can_play=FormatNumber(CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")),0)
						Else
							can_play=0
						End If
					End If 
					%>
				<tr class="head_black">
					<td>
						เครดิต :</td><td align="right"><%=FormatNumber(limit_play,0)%>
					</td>
				</tr>
				<tr class="head_black">
					<td>
						คงเหลือ : </td><td align="right"><%=FormatNumber(can_play,0)%>
					</td>
				</tr>
			</table>		
		<%
	set objRS=nothing
	set objDB=nothing
End Sub 
Function GetGameDesc(g)
	select case g
		case 1 
			GetGameDesc="รัฐบาล"
		case 2
			GetGameDesc="ออมสิน/ธกส"
		case 3
			GetGameDesc="ตั้งราคาอื่น"
		case else
			GetGameDesc=""
	end select
End Function
Function GetPlayerName(p)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_PlayerName " & p
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetPlayerName = objRS("player_name")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>