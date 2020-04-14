<%OPTION EXPLICIT%>
<!--#include file="mdlGeneral.asp"-->
<script language="javascript">
	// เก็บส่วนลดเอาไว้ ในการคิด เครดิต 
	var ar_discount =new Array()		
	var idx=0;
	var idx_limit_number=0;
	// เก็บจำนวนเงินสูงสุด 
	var ar_maxMoney =new Array()		
	var ar_limit =new Array()
</script>
<%
		Dim str_price
		str_price="xx"
		Dim var_discount, var_maxMoney, var_limit_number

		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		Dim player_id, call_from
		player_id=Request("player_id")
		call_from=Request("call_from")
		Dim login_id, player_name,send, receive, wait, ret, total, ticket_number, limit_play	
		'SQL="select login_id from sc_user where  create_by_player=0 and user_id=" & player_id 
		'Set objRS=objDB.Execute(SQL)
		'If Not objRS.eof Then
				SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	 ' คนแทง
		'Else
		'		SQL="exec spJSelectPlayerDetLevel2 " & player_id & ", " & Session("gameid")	 ' ย่อย
		'End If 
		


		
		Set objRS=objDB.Execute(SQL)
	
		Dim can_play,sum_play
		If Not objRS.eof Then
			login_id=objRS("login_id")
			player_name=objRS("player_name")
			send=objRS("send")
			receive=objRS("receive")
			wait=Clng(send) - Clng(receive)
			ret=objRS("returned")
			total=objRS("total")
			ticket_number=objRS("ticket_number")
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
'response.write		SQL & " "  &		objRS("sum_play")						
'response.end
										
			'=== หา ส่วนลด และ จำนวนแทงสูงสุดที่ กำหนด 
			SQL="exec spJGetPriceDisc " & player_id & ", " & Session("gameid")
			set objRS=objDB.EXecute(SQL)
			var_discount=""
			while not objRS.eof
				var_discount=var_discount & ", " & objRS("play_type") & "|" & objRS("discount_amt")
				%>
				<script language="javascript">
					ar_discount[idx]='<%=objRS("play_type")%>|<%=objRS("discount_amt")%>'
					idx=parseInt(idx)+1;
				</script>
				<%
				objRS.MoveNext
			wend 
			%>
			<script language="javascript">			
					idx=0;
				</script>	
			<%	
			SQL="exec spJChkMaxMoney " & player_id & ", " & Session("gameid")
			set objRS=objDB.Execute(SQL)
			var_maxMoney=""
			While Not  objRS.eof 
				var_maxMoney=var_maxMoney & "," & objRS("play_type") & "|" & objRS("maxMoney") & "|" & objRS("play_desc")
				%>
				<script language="javascript">
					ar_maxMoney[idx]='<%=objRS("play_type")%>|<%=objRS("maxMoney")%>|<%=objRS("play_desc")%>'
					idx=parseInt(idx)+1;
				</script>
				<%
				objRS.MoveNext
			wend
			'=== หา ส่วนลด และ จำนวนแทงสูงสุดที่ กำหนด 

			'== limit_number
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
					if('<%=objRS("number_up2")%>'!=''){
					ar_limit[idx_limit_number]='<%="1"%>|<%=objRS("number_up2")%>';idx_limit_number=parseInt(idx_limit_number)+1; }
					if('<%=objRS("number_down2")%>'!=''){
					ar_limit[idx_limit_number]='<%="7" %>|<%=objRS("number_down2")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
					if('<%=objRS("number_up3")%>'!=''){
					ar_limit[idx_limit_number]='<%="2" %>|<%=objRS("number_up3")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
					if('<%=objRS("number_tod3")%>'!=''){
					ar_limit[idx_limit_number]='<%="3" %>|<%=objRS("number_tod3")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
					</script>
				<%
				objRS.MoveNext
			wend
		End if
%>

<%
Call PrintPrice(Session("did"), player_id, Session("gameid"))
Sub PrintPrice(dealer_id, player_id, game_id)
	str_price=""
	Dim i
	If player_id="" Then Exit Sub 
	Dim objRS , objDB , SQL, login_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim game_type
	'-- แสดงก็ต่อเมื่อ เจ้า กำหนดให้แสดง ราคา ส่วนลด
	'SQL="select * from sc_user where user_id=" & dealer_id  & " and show_price_player=1 " 
	SQL="select a.* from sc_user a inner join sc_user b on a.user_id=b.create_by "
	SQL=SQL & " where b.user_id=" & player_id  & " and a.show_price_player=1 " 
	'response.write SQL
	Set objRS=objDB.Execute(SQL)
	If objRS.eof Then
		Exit sub
	End If 

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
	str_price=str_price &	"<table width='250'  border='0' cellspacing='1' cellpadding='1' bgcolor='#E8E8E8'>"
				Dim bgcolor
				select case game_type
						case 1
							bgcolor="#CD9BFF"
						case 2
							bgcolor="#F3A44B"
						case 3
							bgcolor="#339900"					
				end select
				
				str_price=str_price & "<tr>"
				str_price=str_price & "	<td class='tdbody1' align='left' bgcolor='" & bgcolor & "' colspan='3'>"
						GetGameDesc(game_type)		
				str_price=str_price & "	</td>"
				str_price=str_price & "</tr>"
				str_price=str_price & "<tr>"
				str_price=str_price & "<td class='tdbody1' bgcolor='#B3FFD9' align='left'>หมายเลข : " & login_id & "</td>"
				str_price=str_price & "	<td class='tdbody1'  bgcolor='#B3FFD9' align='left' colspan='2'>ชื่อ : " & GetPlayerName(player_id) & "</td>"
				str_price=str_price & "</tr>"
				str_price=str_price & "<tr>"
				str_price=str_price & "	<td class='tdbody1' bgcolor='#FFFFA4' align='center'>ชนิด</td>"
				str_price=str_price & "	<td class='tdbody1' bgcolor='#FFFFA4' align='center'>จ่าย</td>"
				str_price=str_price & "	<td class='tdbody1' bgcolor='#FFFFA4' align='center'>ลด (%)</td>"
				str_price=str_price & "</tr>"
				'	If Len(login_id)>6 then
				'		SQL="exec spGetPlayPrice_Level2 " & 	dealer_id & "," & player_id & "," & game_type
				'	Else 
						dealer_id=GetValueFromTable("sc_user", "create_by", "user_id=" & player_id)
						SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
				'	End If 
	'response.write SQL
					set objRS=objDB.Execute(SQL)
					i=1
					while not objRS.eof
						if objRS("ref_det_desc")=" " then
						str_price=str_price & "<tr>"
						str_price=str_price & "<td class='tdbody1' bgcolor='#FFFFA4' align='center'>&nbsp;</td>"
						str_price=str_price & "<td bgcolor='#B3FFD9' align='center' >&nbsp;</td>"
						str_price=str_price & "<td bgcolor='#B3FFD9' align='center'>&nbsp;</td>"
					str_price=str_price & "</tr>"

						else

					str_price=str_price & "<tr>"
					str_price=str_price & "	<td class='tdbody1' bgcolor='#FFFFA4' align='center'>&nbsp;" & objRS("ref_det_desc") & "</td>"
					str_price=str_price & "	<td bgcolor='#B3FFD9' align='center' >"
					str_price=str_price & "		<input type='text' name='p" & objRS("play_type") & "'  value='" & objRS("pay_amt") & "' class='input1' size='5' maxLength='3' id='idL" & i  & "' onKeyDown='chkEnter(this);' > "
					str_price=str_price & "	</td>"
					str_price=str_price & "<td bgcolor='#B3FFD9' align='center'> "
					str_price=str_price & "<input type='text' name='d" & objRS("play_type") & "' value='" & objRS("discount_amt") & "' class='input1' size='5' maxLength='2' id='idR" & i & "' onKeyDown='chkEnter(this);'>"
					str_price=str_price & "</td>"
					str_price=str_price & "</tr>"
						i=i+1
					end if
					objRS.MoveNext
					wend

			str_price=str_price & "</table>"		
			str_price=str_price & "	<table>"
				
					'If Len(login_id)>6 Then ' รายย่อย
					'	SQL="exec spJSelectPlayerDetLevel2 " & player_id & ", " & Session("gameid")	
					'else
						SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	
					'End If
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
							can_play=CDbl(objRS("limit_play")) - CDbl(objRS("sum_play"))
						Else
							can_play=0
						End If
					End If 

					'str_price=str_price & "<tr class='head_black'>"
					'str_price=str_price & "<td>" 
					'str_price=str_price & "เครดิต :</td><td align='right'>"  & FormatNumber(limit_play,0)
					'str_price=str_price & "</td>"
					'str_price=str_price & "</tr>"
					'str_price=str_price & "<tr class='head_black'>"
					'str_price=str_price & "<td>"
					'str_price=str_price & "คงเหลือ : </td><td align='right'>" &  FormatNumber(can_play,0)
					'str_price=str_price & "</td>"
					'str_price=str_price & "</tr> "

			str_price=str_price & "</table>"		
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

<script language="javascript">
//alert(parent.document.form1.player_id.value)
		parent.document.form1.player_id.value=<%=player_id %>
		parent.document.form1.player_name.value='<%=login_id & " " & player_name %>'
		if ('<%=call_from %>'=="key") {
			parent.document.all.send.innerText='<%=send %>'
			parent.document.all.receive.innerText='<%=receive %>'
			parent.document.all.wait.innerText='<%=wait %>'
			parent.document.all.ret.innerText='<%=ret %>'		
			parent.document.all.total.innerText='<%=FormatNumber(total,0)	%>'	
			parent.document.all.ticket_number.value='<%=ticket_number%>'
			parent.document.all.form1.key_number_col11.focus();
			//2007-08-21
			if(typeof(parent.document.all.limit_play) == "object"){
				parent.document.all.limit_play.innerText='<%=limit_play %>'
			}
			//if(typeof(parent.document.all.sum_play) == "object"){
			//	parent.document.all.sum_play.innerText=sum_play
			//}
			if(typeof(parent.document.all.can_play) == "object"){
				parent.document.all.can_play.innerText='<%=can_play %>'
			}

			//2009-01-31 ต้องเปลี่ยนค่า 
			parent.document.all.obj_maxMoney.value=ar_maxMoney;
			parent.document.all.obj_discount.value=ar_discount;
			parent.document.all.obj_limit_number.value=ar_limit;
			parent.document.all.show_price.innerHTML="<%=str_price  %>";
			//alert(parent.document.all.show_price.innerHTML)

		} else if ('<%=call_from %>'=="view") {		
			//alert('ccc')
			if(typeof(parent.document.all.form1.key_number_col11) == "object"){
				parent.document.all.form1.key_number_col11.focus();
			}
			parent.document.form1.cmbplayer.value='<%=player_id%>'
			parent.document.all.form1.submit();
		} 
		
		parent.closeDialog();

</script>