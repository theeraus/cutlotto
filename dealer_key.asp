<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%

	Dim save,i
	save=Request("save")
	game_id=Session("gameid")
	'-- ต้องไปหามาก่อนว่า login นี้ได้ grame_id หมายเลขอะไร
	if game_id="" then game_id="1"
	player_id=Session("uid")

	if save="save" then
		Dim objRS , objDB , SQL
		Dim 	updown_type_col1 , key_number , key_money ,updown_type, key_seq, number_status
		Dim player_id, ticket_number, game_id , rec_status, ticket_id, send_status, key_from, key_id
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		'--- insert into tb_ticket		
		ticket_number=Getticket_number(player_id , game_id )
		rec_status=1 ' ส่ง
		send_status=1  ' ส่งเจ้ามือเจ้าของ
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
			ticket_id=objRS("ticket_id")
			for i=1 to 33
					updown_type=convUpDownType(Request("updown_type_col1" & i ))
					key_number=Request("key_number_col1" & i )
					key_money=Request("key_money_col1" & i )
					key_seq=i
					number_status=1    '  ส่ง
					if updown_type <>""  and  key_number<>"" and  key_money <>"" then
						'--- insert into tb_ticket_key
						SQL="exec spInsert_tb_ticket_key " & _
									ticket_id & ", " & _
									key_seq & "," & _
									updown_type & ", " & _
									"'" & key_number & "', " & _
									"'" & key_money &  "'," & _
									number_status 					
						set objRS=objDB.Execute(SQL)
						'--- แต่ละตัวเลขที่แทงจะต้อง save ลง tb_ticket_number โดยการแยกประเภทการแทง

					end if
			next
		end if
		set objRS=nothing
		set objDB=nothing
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
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>
<html>
<head>
<title>.:: คีย์แทงโพย : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0"  leftmargin="0">
	<form name="form1" action="key_player.asp" method="post">
	<input type="hidden" name="master_pay_type">
	<input type="hidden" name="where_cursor">
	<table border="0" width="100%"  align="absmiddle"><!----  table top Level 1  ---->
		<tr>
			<td width="200" align="right">
			
			</td>
		</tr>
		<tr valign="top">
			<td width="200" align="right">
				<table  border="0"  cellpadding="1" cellspacing="0"><!----  table top Level 2 ทางซ้าย  ---->
					<tr>
						<td width="100" height="30"><input  size="20" type="button" name="b_updown_type" value="  ล่าง " class="button_lower"  style="cursor:hand;" onclick="click_updown_type()"></td>
					</tr>
					<tr>
						<td><input type="button" name="b_send" value="  ส่ง " class="button_send"  style="cursor:hand;" onClick="clicksubmit()"></td>
					</tr>				
					<tr>
						<td>
							<table width="240">
								<tr>
									<td class="tdbody" align="right">ส่ง</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetSend(player_id,game_id)%></td>
									<td class="tdbody" align="right">ใบ</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">รับแล้ว</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetReceive(player_id,game_id)%></td>
									<td class="tdbody" align="right">ใบ</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">รอรับ</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetSend(player_id,game_id) - GetReceive(player_id,game_id)%></td>
									<td class="tdbody" align="right">ใบ</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">เลขคืน</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetReturn(player_id,game_id)%></td>
									<td class="tdbody" align="right">ใบ</td>
								</tr>
								<tr>
									<td class="tdbody" align="right"><b>ยอดแทงรวม</b></td>
									<td class="tdbody" align="right"><b>=</b></td>
									<td class="tdbody" align="right"><b>
									<%=formatnumber(GetTotalPlay(player_id,game_id),0)%></b></td>
									<td class="tdbody" align="right"><b>บาท</b></td>
								</tr>
								<tr>
									<td class="tdbody" align="right">ยอดใบนี้</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><span id="this_play_amt"></span></td>
									<td class="tdbody" align="right">บาท</td>
								</tr>
							</table>
						</td>
					</tr>
				</table> <!----  table top Level 2 ทางซ้าย  ---->
			</td>
			<td>
				<table border="0"  cellpadding="1" cellspacing="0"><!----  table top Level 2 ทางขวาใช้ในการคีย์ข้อมูล ---->
					<tr>
						<td class="tdbody" align="right" colspan="18"><b>ใบที่ <%=Getticket_number(player_id , game_id )%></b></td>
					</tr>
					<%
						i=1
						while i<=33
					%>
					<tr>
						<td align="center"><input type="text" size="3" class="input1" name="updown_type_col1<%=i%>"  id="c11<%=right("00" & i,2)%>"></td>
						<td><input type="text" size="3" maxLength="3" class="input1" name="key_number_col1<%=i%>" onKeyUp="return autoTab(this, 3, event);"  
								onKeyDown="chkEnter(this);" id="c12<%=right("00" & i,2)%>"  onBlur="iBlur(this)"></td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="11" maxLength="11" class="input1"  name="key_money_col1<%=i%>" onKeyDown="chkEnter(this);" 
						id="c13<%=right("00" & i,2)%>" onBlur="iBlur(this)"></td>

						<!------------------- ถ้าเป็นโทรศัพท์ไม่ต้องแสดง 2  column นี้ ------------------------>
						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="#0F0FF9"></td>
						<td align="center">&nbsp;&nbsp;<input type="text" size="3" class="input1" name="updown_type_col2<%=i%>"  id="c21<%=right("00" & i,2)%>"></td>
						<td><input type="text" size="3" maxLength="3" class="input1"  name="key_number_col2<%=i%>" onKeyUp="return autoTab(this, 3, event);" onKeyDown="chkEnter(this);" id="c22<%=right("00" & i,2)%>" onBlur="iBlur(this)"></td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="11" maxLength="11" class="input1" name="key_money_col2<%=i%>" onKeyDown="chkEnter(this);" 
						id="c23<%=right("00" & i,2)%>" onBlur="iBlur(this)"></td>

						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="#0F0FF9"></td>
						<td align="center">&nbsp;&nbsp;<input type="text" size="3" class="input1" name="updown_type_col3<%=i%>" id="c31<%=right("00" & i,2)%>"></td>
						<td><input type="text" size="3" maxLength="3" class="input1"  name="key_number_col3<%=i%>" onKeyUp="return autoTab(this, 3, event);" onKeyDown="chkEnter(this);" id="c32<%=right("00" & i,2)%>" onBlur="iBlur(this)"></td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="11" maxLength="11" class="input1" name="key_money_col3<%=i%>" onKeyDown="chkEnter(this);"
						id="c33<%=right("00" & i,2)%>" onBlur="iBlur(this)"></td>
						<td class="tdbody" align="right"><%=i%></td>
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
	function comma(v){
		
	}
	function lefty (instring, num){
		var outstr=instring.substring(instring, num);
		return (outstr);
	}
	//document.onkeydown = Function ('checkEnter(event.keyCode)');
	function chkEnter(obj){
		var k=event.keyCode
		var o=obj
		var i=o.id
		var id, next_obj
		var n , l, m , c, strl , prev 
		// c1    1   01    =  ชุดที่ 1        บน/ล่าง      บรรทัดที่     c m n
		
		if (k == 13){	
			l=i.substring(3,5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม่
			c=lefty(i,2);			  // ชื่อของ id ที่เรา enter มา c1 
			m=i.substring(2,3); 	
			m=parseInt(m)+1
			if (m>3){ 					
				//--- ช่องหลังถ้าใส่เลขแทงแล้วไม่มส่เงินแทงกดผ่าน ให้ใส่เงินแทงเหมือนบรรทัดบน 
				id = c + 3 + l
				next_obj = document.getElementById(  id )	
				if (l!="01"){								
					if (next_obj.value=="" ){					
						id = c + 3 + desc1(l)    // desc1 เป็น fumction ลบ 1 
						next_obj.value = document.getElementById(  id ).value				
					}
				}
				//--- เพิ่มจำนวนเงินของ ใบโพย				
				if (document.all.this_play_amt.innerText==""){ document.all.this_play_amt.innerText=0 }
				document.all.this_play_amt.innerText=convert_number(parseInt(
				replaceChars(document.all.this_play_amt.innerText)) +  parseInt(next_obj.value));
				//--------------------------------------------
				if (l=="08"){l="8"}   // bug 
				if (l=="09"){l="9"}   // bug	
				l=parseInt(l)+1
				if (l <=9){ 
					l="0" + l
				}
				m=2;
				if (l>33){
					l="01"
					c = parseInt(i.substring(1,2) )  + 1  ; 
					if (c>3) {
						alert( "send???")
						document.form1.submit();
						return;
					}
					c="c"  +  c ;				
				}
				// ถ้าเป็นการ enter ที่จำนวนเงิน ให้เอา บน/ล่าง ใส่ที่ pay_type
				id = c + 1 + l
				next_obj = document.getElementById(  id )
				next_obj.value=document.form1.master_pay_type.value;
				
			}
			id = c + m + l
			next_obj = document.getElementById(  id )
			next_obj.focus()
		}  
	}
	function click_updown_type(){
		var t=document.form1.b_updown_type.value;	
		var b = document.getElementById("b_updown_type") 
		var n = document.form1.where_cursor.value 
		var l 	, id 
		//--- หาว่า ประเภทการแทง บรรทัดต่อไป
		var col = n.substring(1,2) 
		l=n.substring(3,5);   // บรรทัดที่ เท่าไร  ถ้าเป็น 33 ต้องกลับไปที่ 1 ใหม
		id = 'c'+col + '1'+ l ; 
		next_obj = document.getElementById(  id )
		if (t=="  ล่าง "){
			document.form1.b_updown_type.value="  บน  ";		
			document.form1.master_pay_type.value="บ";
			b.className="button_upper" ;
		}
		if (t=="  บน  "){
			document.form1.b_updown_type.value=" บ+ล ";		
			document.form1.master_pay_type.value="บ+ล";
			b.className="button_ul" ;
		}
		if (t==" บ+ล "){
			document.form1.b_updown_type.value="  ล่าง ";		
			document.form1.master_pay_type.value="ล";
			b.className="button_lower" ;
		}
		// พร้อมกับเปลี่ยน ค่าของ pay_type ของบันทัดนั้นด้วย
		next_obj.value=document.form1.master_pay_type.value
		// กลับไป set focus ที่เดิม
		next_obj = document.getElementById(  n)
		next_obj.focus();
	}
</script>
<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.form1.updown_type_col11.value="ล"
	document.form1.master_pay_type.value=document.form1.updown_type_col11.value
	document.form1.key_number_col11.focus();
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
	document.form1.submit()
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