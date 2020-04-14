<%OPTION EXPLICIT%>
<script language="javascript">
var line_all=0;
</script>
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	Dim rec_mode
	rec_mode=request("rec_mode")
	Dim col_per_page	
	col_per_page=3
	Dim objRS , objDB , SQL
	Dim 	updown_type_col1 , key_number , key_money ,updown_type, key_seq, number_status
	Dim player_id, ticket_number, game_id , rec_status, ticket_id, send_status, key_from, key_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")

	Dim save,i, line_per_page,j,k
	line_per_page=33
	save=Request("save")
	game_id=Session("gameid")
	'-- ต้องไปหามาก่อนว่า login นี้ได้ grame_id หมายเลขอะไร
	ticket_id=Request("ticket_id")
	if game_id="" then game_id="1"
	player_id=Session("uid")

	if save="save" then		
		'--- insert into tb_ticket		
		ticket_number=Getticket_number(player_id , game_id )
		rec_status=3 ' รับบางส่วน
		send_status=1  ' ส่งเจ้ามือเจ้าของ
		key_from=1       ' แทงจาก com 
		key_id=Session("uid")
		SQL="exec spEdit_tb_ticket " & ticket_id & "," & rec_status
		set objRS=objDB.Execute(SQL)																

		SQL="update tb_ticket set rec_date=GetDate() where ticket_id=" & ticket_id
		set objRS=objDB.Execute(SQL)																

		for i=1 to 33
				updown_type=convUpDownType(Request("updown_type_col1" & i ))
				key_number=Request("key_number_col1" & i )
				key_money=Request("key_money_col1" & i )
				key_seq=Request("key_seq_col1" & i ) '//i				
				number_status=3    '  รับบางส่วน					

				'--- insert into tb_ticket_key
				if updown_type<>"" and key_number<>"" and key_money<>"" then	
					SQL="exec spEdit_tb_ticket_key " & _
								ticket_id & ", " & _
								key_seq & "," & _
								updown_type & ", " & _
								"'" & key_number & "', " & _
								"'" & key_money &  "'," & _
								number_status 	
					set objRS=objDB.Execute(SQL)
				end if	

				'--- แต่ละตัวเลขที่แทงจะต้อง save ลง tb_ticket_number โดยการแยกประเภทการแทง
				updown_type=convUpDownType(Request("updown_type_col2" & i ))
				key_number=Request("key_number_col2" & i )
				key_money=Request("key_money_col2" & i )
				'//key_seq=i+33
				key_seq=Request("key_seq_col2" & i ) 
				number_status=3    '  รับบางส่วน
				if updown_type<>"" and key_number<>"" and key_money<>"" then	
					SQL="exec spEdit_tb_ticket_key " & _
								ticket_id & ", " & _
								key_seq & "," & _
								updown_type & ", " & _
								"'" & key_number & "', " & _
								"'" & key_money &  "'," & _
								number_status 			
					set objRS=objDB.Execute(SQL)
				end if
				updown_type=convUpDownType(Request("updown_type_col3" & i ))
				key_number=Request("key_number_col3" & i )
				key_money=Request("key_money_col3" & i )
				if updown_type<>"" and key_number<>"" and key_money<>"" then						
					'//key_seq=i+33+33
					key_seq=Request("key_seq_col3" & i )
					number_status=3    '  รับบางส่วน
					SQL="exec spEdit_tb_ticket_key " & _
								ticket_id & ", " & _
								key_seq & "," & _
								updown_type & ", " & _
								"'" & key_number & "', " & _
								"'" & key_money &  "'," & _
								number_status 					
					set objRS=objDB.Execute(SQL)
				end if
		Next
		' 2008-03-04  JUM ตรวจดู จำนวนเงินกับตัวเลข ถ้าเหมือนเดิม tb_ticket.rec_status=2 รับทั้งหมด
		SQL="exec spJUpdateRec_Status " & ticket_id
		objDB.Execute(SQL)

		'-- 20070914 ถ้า ref_game_id <> null  update tb_ticket_number.cut_type=1
		SQL="exec spJUpdateCut_Type " & ticket_id
		objDB.Execute(SQL)

		set objRS=nothing
		set objDB=Nothing
'response.end
		If rec_mode="rec" Then
			response.redirect("dealer_ticket.asp") 
		else
			response.redirect("firstpage_dealer.asp")
		End if
	end if
Function GetSend(p,g)
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
	if t="ล" then
		convUpDownType=1
	end if
	if t="บ" then
		convUpDownType=2
	end if
	if t="บ+ล" then
		convUpDownType=3
	end if
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

if ticket_id<>"" then
'-------- ถ้าเป็นการแก้ไข ticket จะไปนำข้อมูลเดิมมาแสดง

	SQL="exec spGet_tb_ticket_key_by_ticket_id " & ticket_id
	'response.write SQL
	'response.end
	set objRS=objDB.Execute(SQL)
	Dim ar_disp
	reDim ar_disp(99,5)

	i=1
	if not objRS.eof then
		while not objRS.eof
			ar_disp(i,1)=objRS("updown_type")			
			ar_disp(i,2)=objRS("str_updown_type")
			ar_disp(i,3)=objRS("key_number")
			If rec_mode="rec" Then
				ar_disp(i,4)=objRS("dealer_rec")
			else
				ar_disp(i,4)=objRS("key_money")
			End If
			ar_disp(i,5)=objRS("key_seq")			
			i=i+1
%>
<script language="javascript">
line_all=<%=i%>
</script>
<%
			objRS.MoveNext
		wend
	end if
end if
%>
<html>
<head>
<title>.:: คีย์แทงโพย : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0"  leftmargin="0">
	<form name="form1" action="key_dealer.asp" method="post">
	<input type="hidden" name="rec_mode" value="<%=rec_mode%>">
	<input type="hidden" name="master_pay_type">
	<input type="hidden" name="where_cursor">
	<input type="hidden" name="ticket_id" value="<%=ticket_id%>">
	<table border="0" width="100%"  align="absmiddle"><!----  table top Level 1  ---->
		<tr>
			<td width="200" align="right">
			
			</td>
		</tr>
		<tr valign="top">
			<td width="280" align="left"><br><br><br>
				<table  border="0"  cellpadding="1" cellspacing="0" width="100%"><!----  table top Level 2 ทางซ้าย  ---->
					<tr>
						<td height="30" align="right">
						<input  size="20" type="hidden" name="b_updown_type" value="  ล่าง " class="button_lower"  style="cursor:hand;" onclick="click_updown_type()" readonly></td>
					</tr>
					<tr>
						<td align="right">
						<input type="button" class="inputE" value="บันทึก" style="cursor:hand; width: 75px;" onClick="clicksubmit()">
						</td>
					</tr>								
				</table> <!----  table top Level 2 ทางซ้าย  ---->
			</td>
			<td>
			<%
			SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
			
			set objRS=objDB.Execute(SQL)	
			if not objRS.eof then
				%>
				<table  border="0"  cellpadding="1" cellspacing="0" width="500">
					<tr>
						<td class="tdbody_red">เลขที่ &nbsp;<%=objRS("login_id")%></td>
						<td class="tdbody_red">ชื่อ &nbsp;<%=objRS("player_name")%></td>
						<td class="tdbody">ใบที่ &nbsp;<%=objRS("ticket_number")%></td>
						<td class="tdbody">ยอดแทงรวม  &nbsp;<%=formatnumber(GetTotalPlay(objRS("player_id"),objRS("game_id")),0)%></td>
						<td class="tdbody">ยอดใบนี้ &nbsp;<%=formatnumber(objRS("total_play_amt"),0)%></td>
					</tr>
				</table><br>
			<%
			end if
			%>
				<table border="0"  cellpadding="1" cellspacing="0" width="500">
				<!----  table top Level 2 ทางขวาใช้ในการคีย์ข้อมูล ---->
					<tr>
						<td class="tdbody" align="right" colspan="18"><b>ใบที่ <%=objRS("ticket_number")%></b></td>
					</tr>
					<%
						Dim readonly1, readonly2, readonly3
						Dim show_up1, show_down1
						Dim show_up2, show_down2
						Dim show_up3, show_down3
						i=1
						while i<=33
						j=i+line_per_page
						k=j+line_per_page	
						if ar_disp(i,3)="" then
							readonly1="readonly class='input_disable'"
						else
							readonly1="class='input1'"
						end if
						if ar_disp(j,3)="" then
							readonly2="readonly class='input_disable'"
						else
							readonly2="class='input1'"
						end if
						if ar_disp(k,3)="" then
							readonly3="readonly class='input_disable'"
						else
							readonly3="class='input1'"
						end If
						show_up1=""
						show_down1=""
						show_up2=""
						show_down2=""
						show_up3=""
						show_down3=""
						If ar_disp(i,2)<>"" then
							If InStr(ar_disp(i,2),"ล")>0 Then
								show_down1="<font color='red'>ล</font>"
								If InStr(ar_disp(i,2),"บ")>0 Then
									show_up1="บ+"
								End If
							else
								If InStr(ar_disp(i,2),"บ")>0 Then
									show_up1="บ"
								End if							
							End If 
							show_up1=show_up1 & show_down1
						End If 

						If ar_disp(j,2)<>"" then
							If InStr(ar_disp(j,2),"ล")>0 Then
								show_down2="<font color='red'>ล</font>"
								If InStr(ar_disp(j,2),"บ")>0 Then
									show_up2="บ+"
								End If
							else
								If InStr(ar_disp(j,2),"บ")>0 Then
									show_up2="บ"
								End if							
							End If 
							show_up2=show_up2 & show_down2
						End If 
						If ar_disp(k,2)<>"" then
							If InStr(ar_disp(k,2),"ล")>0 Then
								show_down3="<font color='red'>ล</font>"
								If InStr(ar_disp(k,2),"บ")>0 Then
									show_up3="บ+"
								End If
							else
								If InStr(ar_disp(k,2),"บ")>0 Then
									show_up3="บ"
								End if							
							End If 
							show_up3=show_up3 & show_down3
						End If 

					%>
					<tr>
						<td align="center" nowrap>
						<input type="hidden" name="key_seq_col1<%=i%>"  value="<%=ar_disp(i,5)%>"> <!-- key_seq -->
						<input type="hidden" size="2" class="input2" name="updown_type_col1<%=i%>"  id="c11<%=right("00" & i,2)%>" value="<%=ar_disp(i,2)%>" readonly style="width:35; ">
						<span style="width:35; " class="input2" id="signUp1<%=right("00" & i,2)%>" ><%=show_up1%></span>
						</td>
						<!-- return autoTab(this, 3, event), --->
						<td><input type="text" size="2" maxLength="3" name="key_number_col1<%=i%>" onKeyUp="pressPlus(this);"  
						onKeyDown="chkEnter(this);" id="c12<%=right("00" & i,2)%>"  onBlur="iBlur(this)" value="<%=ar_disp(i,3)%>" <%=readonly1%> class="input_disable"
						style="width:35;">
						</td>

						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="15"  name="key_money_col1<%=i%>" onKeyDown="chkEnter(this);" 
						id="c13<%=right("00" & i,2)%>" onBlur="iBlur(this)" value="<%=ar_disp(i,4)%>" 
						onKeyUp="pressPlus(this);" <%=readonly1%>></td>

						<!------------------- ถ้าเป็นโทรศัพท์ไม่ต้องแสดง 2  column นี้ ------------------------>
						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="red"></td>
						<input type="hidden" name="key_seq_col2<%=i%>"  value="<%=ar_disp(j,5)%>"> <!-- key_seq -->
						<td align="center" nowrap>&nbsp;&nbsp;<input type="hidden" size="2" class="input2" name="updown_type_col2<%=i%>"  id="c21<%=right("00" & i,2)%>" value="<%=ar_disp(j,2)%>" readonly style="width:35;">
						<span  style="width:35; "  class="input2" id="signUp2<%=right("00" & i,2)%>" style="width:20"><%=show_up2%></span>
						</td>
						
						<td><input type="text" size="2" maxLength="3"  name="key_number_col2<%=i%>" 
						onKeyUp="pressPlus(this);" onKeyDown="chkEnter(this);" id="c22<%=right("00" & i,2)%>" onBlur="iBlur(this)" value="<%=ar_disp(j,3)%>" <%=readonly2%> style="width:35;"></td>

						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="15" name="key_money_col2<%=i%>" onKeyDown="chkEnter(this);" 
						id="c23<%=right("00" & i,2)%>" onBlur="iBlur(this)" value="<%=ar_disp(j,4)%>"  
						onKeyUp="pressPlus(this);" <%=readonly2%>></td>

						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="red"></td>
						<td align="center" nowrap>&nbsp;&nbsp;<input type="hidden" size="2" class="input2" name="updown_type_col3<%=i%>" id="c31<%=right("00" & i,2)%>" value="<%=ar_disp(k,2)%>" readonly style="width:35;">
						<span  style="width:35; " class="input2" id="signUp3<%=right("00" & i,2)%>" style="width:20"><%=show_up3%></span>
						</td>
						<td>
						<input type="hidden" name="key_seq_col3<%=i%>"  value="<%=ar_disp(k,5)%>"> <!-- key_seq -->
						<input type="text" size="2" maxLength="3"  name="key_number_col3<%=i%>" 
						onKeyUp="pressPlus(this);" onKeyDown="chkEnter(this);" id="c32<%=right("00" & i,2)%>" onBlur="iBlur(this)" value="<%=ar_disp(k,3)%>" <%=readonly3%> style="width:35;">
						</td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="15" name="key_money_col3<%=i%>" onKeyDown="chkEnter(this);"
						id="c33<%=right("00" & i,2)%>" onBlur="iBlur(this)" value="<%=ar_disp(k,4)%>" 
						onKeyUp="pressPlus(this);" <%=readonly3%>></td>
						<td class="tdbody_blue" align="right"><%=i%></td>
						<!------------------- ถ้าเป็นโทรศัพท์ไม่ต้องแสดง 2  column นี้ ------------------------>
					</tr>
					<%
							i=i+1
						wend
					%>					
				</table> <!----  table top Level 2 ทางขวาใช้ในการคีย์ข้อมูล ---->
			</td>
		</tr>
	</table> <!----  table top Level 1  ---->
	<input type="hidden" name="save" value="save">
	</form>
</body>
<script language="javascript">
	function pressPlus(o){
		var k=event.keyCode
		if ( k==107  ) {
			o.value=lefty(o.value, parseInt(o.value.length) - 1)
		}
	}

	function lefty (instring, num){
		var outstr=instring.substring(instring, num);
		return (outstr);
	}

//--jum
function chkEnter(obj){
		document.form1.where_cursor.value=obj.id
		var k=event.keyCode
		var o=obj
		var i=o.id
		var id, next_obj
		var n , l, m , c, strl , prev , Len
		var onumber,tmpobj
		// c1    1   01    =  ชุดที่ 1        บน/ล่าง      บรรทัดที่     c m n
		//-- กรณีที่ user กดคีย์ # , + จะเป็นการสลับ  บ ล หรือ บ+ล
		if ( k==107  ) {
			click_updown_type(obj)
		}
		if (k == 13){	
			//---- ถ้าเป็นการคีย์ตัวแรกค่าเงินต้องห้ามว่าง
			if (i=='c1301'){
				if (o.value=='' ){
					alert('ผิดพลาด : กรุณากรอกเงินแทง !!!')
					return false
				}
			}
			l=i.substring(3,5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม่
			c=lefty(i,2);			  // ชื่อของ id ที่เรา enter มา c1 			
			m=i.substring(2,3); 	
			//---- เช็คการคีย์ข้อมูลที่ช่อง เลขแทงต้องเป็นตัวเลขเท่านั้น 
			if (parseInt(m)==2){				
				if (o.value=='' ){
					alert('ผิดพลาด : กรุณากรอกเลขแทง !!!')
					return false
				}

				if( isNaN(lefty(o.value,3))){
					alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น !!!')
					return false
				}
				id=c+'1'+l
				next_obj = document.getElementById(  id )	
				// เลขแทง กรอก 123* ได้  ตัวที่ 4 เป็น * ได้เท่านั้น
				if (o.value.length==4){
					if (o.value.substring(3,4)!="*" && o.value.substring(3,4)!=' ' ){
						alert('ผิดพลาด : ถ้าต้องการแทงเลขวงกลม ต้องคีย์แบบ  123*  !!!')
						return false
					}			
					if (next_obj.value!="บ"){
						alert('ผิดพลาด : วงกลม แทงได้เฉพาะ บน เท่านั้น !!!')
						return false
					}
					var n1,n2,n3
					n1=o.value.substring(0,1)
					n2=o.value.substring(1,2)
					n3=o.value.substring(2,3)
					if (n1==n2 && n2==n3 && n1==n3){
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
			if (parseInt(m)==3){				
				//--- ช่องหลังถ้าใส่เลขแทงแล้วไม่ใส่เงินแทงกดผ่าน ให้ใส่เงินแทงเหมือนบรรทัดบน 
				id = c + 3 + l				
				next_obj = document.getElementById(  id )	
				if (l!="01"){								
					if (next_obj.value=="" ){										
						id = c + 3 + desc1(l)    // desc1 เป็น fumction ลบ 1 
						next_obj.value = document.getElementById(  id ).value				
					}
				}else{					
					if (next_obj.value=="" ){
						var ta =parseInt(i.substring(1,2)) -1 ;  // ลด 1 เป็น column ก่อนหน้า 
						id="c"+ta+'333'	
						tmpobj = document.getElementById(  id ).value
						next_obj.value =tmpobj 
					}
				}				
				//--- ช่องหลังถ้าใส่เลขแทงแล้วไม่ใส่เงินแทงกดผ่าน ให้ใส่เงินแทงเหมือนบรรทัดบน 
				if ( canKeyNumber(o.value) ){
					// ถ้าเป็น บ+ล สามารถคีย์จำนวนเงินแทงเป็น  71=100/400 บน 100 ล่าง 400
					id=c+'1'+l
					next_obj = document.getElementById(  id )	
					id=c+'2'+l
					onumber= document.getElementById(  id )	
					if (next_obj.value=="บ+ล" && onumber.value.length<=3){
						if ( canKeyUPDN(o.value) ){
							alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] , * หรือ / เท่านั้น !!!')
							return false;
						}
					}else{
						alert('ผิดพลาด : กรุณาป้อนจำนวนเงินแทงเป็นตัวเลข [0-9] หรือ * เท่านั้น !!!')
						return false;
					}
				}
				//--- เช็คตัวเลขแทงกรณีที่คีย์ เงินแทงเป็น 19*900 จะต้องคีย์เลขแทงเป็น 1 หลักเท่านั้น	
				id= c+'2'+l
				next_obj = document.getElementById(  id )	
				if(next_obj.value.length==4){
					if( isNaN(o.value)){
						alert('ผิดพลาด : วงกลม เลขแทง ต้องเป็นตัวเลขเท่านั้น !!!')
						return false
					}
				}
				if (lefty(o.value,3)=='19*'){
					if (next_obj.value.length>1){
						alert('ผิดพลาด : กรุณากรอกข้อมูลให้ถูกต้อง \n ถ้าต้องการแทง 19 หางต้องคีย์เลขแทง 1 หลักเท่านั้น !!!')
						return false;
					}
				}
				x=o.value
				if (x.substring(x.length-1,x.length)=="*"){
					alert('ผิดพลาด : กรุณากรอกข้อมูลให้ถูกต้อง \n ถ้าต้องการแทงโต๊ด พิมพ์ *999 หรือ 999*999 !!!')
					return false;
				}
				//ที่ช่องจำนวนเงิน ห้ามคีย์  * 2 ครั้ง 
				if (!canKeyStar(o.value)){
					alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงให้ถูกต้อง !!!')
					return false;
				}
				// จำนวนเงินแทงต้อง มากกว่า 0 เริ่มเช็ค 8/5/49
				//เอาออก 2006-11-18
				//if (o.value<=0){
				//	alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงต้องมากกว่า 0 !!!')
				//	return false;
				//}

			}
			
			m=parseInt(m)+1
			if (m>3){ 										
				//------- validate data อีกรอบ
				var o1=document.getElementById(  c+1+l )
				var o2=document.getElementById(  c+2+l )
				var o3=document.getElementById(  c+3+l )
				if ( ! validate_1(o1,o2,o3)){
					return false
				}
				//-------
				
				//--- เพิ่มจำนวนเงินของ ใบโพย				
				//sum_PlayAmt();
				//sum_PlayAmt(o.value,c,l); // ส่งจำนวนเงินที่ คีย์แล้วไป 
				// เปลี่ยนไปเช็คตอน onBlur
				//--------------------------------------------
				
				if (l=="08"){l="8"}   // bug 
				if (l=="09"){l="9"}   // bug	
				l=parseInt(l)+1
				if (l <=9){ 
					l="0" + l
				}
				m=2;
				if (l><%=line_per_page%>){
					l="01"
					c = parseInt(i.substring(1,2) )  + 1  ; 
					if (c> <%=col_per_page %>) {
						alert( "บันทึกข้อมูล")
						clicksubmit()
						return;
					}
					c="c"  +  c ;				
				}
				// ถ้าเป็นการ enter ที่จำนวนเงิน ให้เอา บน/ล่าง ใส่ที่ pay_type
				//-- jum
				//id = c + 1 + l
				//next_obj = document.getElementById(  id )
				//next_obj.value=document.form1.master_pay_type.value;				
				//-- jum displayUPDW(id,next_obj.value)
			}
			id = c + m + l
			next_obj = document.getElementById(id)
			next_obj.focus()
		}  
	}

function XchkEnter(obj){
		var k=event.keyCode
		var o=obj
		var i=o.id
		var id, next_obj
		var n , l, m , c
		if ( k==13  ) {
			l=i.substring(3,5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
			l=inc1(l)
			c=lefty(i,3)+l
			if (l>33){
				l="01"
				c = parseInt(i.substring(1,2) )  + 1  ; 
				if (c>3) {
					alert( "บันทึกข้อมูล")
					document.form1.submit();
					return;
				}
				c="c"  +  c +'3'+l;				
			}
			if (o.value=='' ){
				alert('ผิดพลาด : กรุณากรอกเงินแทง !!!')
				return false
			}
			// c1    1   01    =  ชุดที่ 1        บน/ล่าง      บรรทัดที่     c m n
			id= c
			next_obj = document.getElementById(  id )
			next_obj.focus();
	}
}


function sum_PlayAmt(){
		//  id = "c3301"   c3101 c3201 - c3233  
		var id, sumVar,x ,x2,x3,o
		var up_down
		var n1,n2,n3
		sumVar=0
		if (document.all.this_play_amt.innerText==""){ document.all.this_play_amt.innerText=0 }
		// ถ้าเป็น โทรศัพท์จะเป็นการคีย์ แถวเดียว
		
		for (i=1; i<= <%=col_per_page %> ; i++){
				for (j=0; j< <%=line_per_page %> ; j++){
					id='c'+i+'3'+inc1(j)
					next_obj = document.getElementById(  id )
					next_obj.value = document.getElementById(  id ).value
					x=next_obj.value
					o=next_obj.value

					if (x!='' ){
						x2=x.indexOf('*')
						if (x2==0){
							x3=x.substring(x2+1,x.length)						
							x=parseInt(x3)
						}
						if (x2>0){
							x1=x.substring(0,x2)					
							x3=x.substring(x2+1,x.length)						
							if (x1=='19'){
								x=parseInt(x1) * parseInt(x3)
							}else {
								x=parseInt(x1) + parseInt(x3)
							}
						}
						//----- ถ้าเป็น บ+ล จะต้องบวก เงินเพิ่ม
						//บ+ล	13	=	100*200
						id='c'+i+'1'+inc1(j)					
						up_down	= document.getElementById(  id )
						if (up_down.value=='บ+ล'){
							x = parseInt(x)	* 2
						}
						//--- 2005-07-01 // 
						//-- ถ้าเป็นกรณีการคีย์วงกลม 123*=100  , 223*=100
						id='c'+i+'2'+inc1(j)
						next_obj = document.getElementById(  id )
						
						n1=next_obj.value.substring(0,1)
						n2=next_obj.value.substring(1,2)
						n3=next_obj.value.substring(2,3)
						if (next_obj.value.substring(3,4)=='*'){
							if (n1!=n2 && n2!=n3 && n1!=n3){
								x=parseInt(x) * 6
							}else{
								x=parseInt(x) * 3
							}
						}

						// ถ้าเป็นกรณี คีย์ บ+ล เงิน 100/200 
						x2=o.indexOf('/')
						if (x2>0){
							x1=o.substring(0,x2)					
							x3=o.substring(x2+1,o.length)						
							x=parseInt(x1) + parseInt(x3)
						}						
						sumVar=parseInt(sumVar) + parseInt(x)
						}
				} //for
		}

		document.all.this_play_amt.innerText=convert_number(sumVar)
	}

function canKeyUPDN(v ){
		var LengthStr = v.length			
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  (! ( !  isNaN(a)   || a=='*' || a=='/' ) ) {
				//ถ้าเป็น บ+ล สามารถคีย์เป็น 71-100/400 ได้ = แทง 2 บน 100 2 ล่าง 400
				return true
			}					
		}		
		return false
	}
	function canKeyNumber(v ){
		var LengthStr = v.length			
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  (! ( !  isNaN(a)   || a=='*' ) ) {
				//ถ้าเป็น บ+ล สามารถคีย์เป็น 71-100/400 ได้ = แทง 2 บน 100 2 ล่าง 400

				return true
			}					
		}		
		return false
	}

	function canKeyStar(v ){
		var LengthStr = v.length		
		var star=''
		var slash=''
		var i, a
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  ( a=='*' )  {
				star=star + a
			}		
			if  ( a=='/' )  {
				slash=slash + a
			}		
		}		
		// ในการคีย์จำนวนเงินต้องมี * / อย่างใดอย่างหนึ่งเท่านั้น
		//if (star!='' && slash!=''){
		//	return false
		//}
		if ( (star=='*' || star=='') && (slash=='/' || slash=='') )  {
			return true
		}else{
			return false
		}
	}

function click_updown_type(){
		var t=document.form1.b_updown_type.value;	
		var b = document.getElementById("b_updown_type") 
		var n =document.form1.where_cursor.value 
		var l 	, id , chkcol_money
		var k=event.keyCode
		//--- หาว่า ประเภทการแทง บรรทัดต่อไป
		var col = n.substring(1,2) 
		l=n.substring(3,5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
		var csign=n.substring(1,2);
		id = 'c'+col + '1'+ l ; 
		next_obj = document.getElementById(  id )

		if (t=="  ล่าง "){
			document.form1.b_updown_type.value="  บน  ";		
			document.form1.master_pay_type.value="บ";
			b.className="button_upper" ;

			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerHTML="บ"; 
			

		}
		if (t=="  บน  "){
		    document.form1.b_updown_type.value=" บ+ล ";		
			document.form1.master_pay_type.value="บ+ล";
			b.className="button_ul" ;

			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerHTML="บ+<font color='red'>ล</font>";


			

		}
		if (t==" บ+ล "){
			document.form1.b_updown_type.value="  ล่าง ";		
			document.form1.master_pay_type.value="ล";
			b.className="button_lower" ;

			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerHTML="<font color='red'>ล</font>";

		}
		// พร้อมกับเปลี่ยน ค่าของ pay_type ของบันทัดนั้นด้วย
		next_obj.value=document.form1.master_pay_type.value
		// กลับไป set focus ที่เดิม
		next_obj = document.getElementById( n)
		if (k!=107){ // ถ้าเป็นการกด + ไม่ต้องเลื่อน focus
			next_obj.focus();
		}

	}
</script>
<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	<%if ticket_id="" then %>
	document.form1.updown_type_col11.value="ล"
	<% end if%>
	document.form1.master_pay_type.value=document.form1.updown_type_col11.value
	document.form1.key_number_col11.focus();
	document.form1.where_cursor.value='c1201' //20070730
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!-- Original:  Cyanide_7 (leo7278@hotmail.com) -->
<!-- Web Site:  http://members.xoom.com/cyanide_7 -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var isNN = (navigator.appName.indexOf("Netscape")!=-1);
function autoTab(input,len, e) {
var keyCode = (isNN) ? e.which : e.keyCode; 
var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];
if(input.value.length >= len && !containsElement(filter,keyCode)) {
input.value = input.value.slice(0, len);
input.form[(getIndex(input)+1) % input.form.length].focus();
}
function containsElement(arr, ele) {
var found = false, index = 0;
while(!found && index < arr.length)
if(arr[index] == ele)
found = true;
else
index++;
return found;
}
function getIndex(input) {
var index = -1, i = 0, found = false;
while (i < input.form.length && index == -1)
if (input.form[i] == input)index = i;
else i++;
return index;
}
return true;
}
//  End -->
function clicksubmit(){	
	if (validate_input_data()){
		document.form1.submit()
	}
}

function validate_input_data(){
	var id, i, j,ne ,next_obj, obj2,o1,o2,o,onumber
	var kk=0;
	for (j=1; j<= <%=col_per_page%>; j++){
		for (i=1; i<= <%=line_per_page%> ; i++){
			kk=parseFloat(kk)+1;
			id = 'c'+j+'2'+ inc1(i-1) ; 
			o1 = document.getElementById(  id )
			id = 'c'+j+'3'+ inc1(i-1) ; 
			o2 = document.getElementById(  id )
if( parseFloat(kk)<parseFloat(line_all)  && (o1.value=="" || o2.value=="") ) {
alert('ผิดพลาด : ห้ามลบเลขแทง !!!' + (line_all))
o1.focus();
return false;
}
			// ถ้าว่างทั้งเงินแทง และเลขแทงไม่เป็นไรผ่านได้
			if (1==1){
				id = 'c'+j+'3'+ inc1(i-1) ; 
				next_obj = document.getElementById(  id )

				if ( canKeyNumber(next_obj.value) ){
					// ถ้าเป็น บ+ล สามารถคีย์จำนวนเงินแทงเป็น  71=100/400 บน 100 ล่าง 400
					id = 'c'+j+'1'+ inc1(i-1) ; 
					o = document.getElementById(  id )	
					id = 'c'+j+'2'+ inc1(i-1) ; 
					onumber= document.getElementById(  id )	
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
						alert('ผิดพลาด : ถ้าต้องการแทงเลขวงกลม ต้องคีย์แบบ  123* xxxxxx!!!')
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
				//เอาออก 20061118
				//if (obj2.value!=''){
				//	if (next_obj.value<=0){
				//		alert('ผิดพลาด :  กรุณากรอกจำนวนเงินแทงต้องมากกว่า 0 !!!')
				//		return false;
				//	}
				//}

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
	document.form1.where_cursor.value=o.id
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