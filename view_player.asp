<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->
<%
		dim refreshtime
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim IsTelephone
		Dim first_time
		IsTelephone=Session("istelephone") 'Request("istelephone")
		Dim objRS , objDB , SQL		
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Dim status_ticket , nextTicket, prevTicket	, ticket_number
		Dim ticket_id, line_per_page,i,j,k,game_id,player_id
		game_id=Session("gameid")
		player_id=Session("uid")
		ticket_number=Request("ticket_number")
		ticket_id=Request("ticket_id")
		first_time=Request("first_time")
		if ticket_number<>"" then
			SQL="select ticket_id,ticket_number from tb_ticket where ticket_number='" & ticket_number & "' and game_id=" & game_id & " and player_id=" & player_id
			set objRS=objDB.Execute(SQL)
			if not objRS.eof then
				ticket_id=objRS("ticket_id")
			else
				Response.write "ไม่พบโพย x" & ticket_number
				Response.end
			end if
		Else
				If ticket_id="" Then
					If first_time="" then
					ticket_id=GetTicket_ID(player_id, game_id)
					End if
				End if
				ticket_number=GetTicket_Number(ticket_id)
		end if
		
		if IsTelephone=1 then
			line_per_page=25
		else
			line_per_page=33
		end if

		'--- ถ้า ticket_id ที่เข้ามาเป็น ticket_id ที่ไม่ได้อยู่ใน status เลขคืนแล้ว ส่งเจ้ามืออื่นไปแล้ว ไม่ต้องแสดงให้กลับไปหาที่ใบใหม่
		
		prevTicket=GetPreTicket_Number( ticket_number,player_id, game_id)
		nextTicket=GetNextTicket_Number( ticket_number,player_id, game_id)
						
%>			
<%
Function GetKey(ticket_id)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select "
	SQL=SQL & " b.[user_name] "
	SQL=SQL & " from tb_ticket a "
	SQL=SQL & " inner join sc_user b on a.key_id=b.user_id "
	SQL=SQL & " where a.ticket_id=" & ticket_id

	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetKey = objRS("user_name")
	end if
	set objRS=nothing
	set objDB=nothing
End Function

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
Function GetTotalDealer_Rec(p,g)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetTotal_dealer_rec " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalDealer_Rec = objRS("total_dealer_rec")
	else
		GetTotalDealer_Rec=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function FormatN(n,dot)
	if n=0 or n=""  then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
End Function

Function GetTotalPlayAmt(ticket_id)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_total_play_amt_by_ticket_id " & ticket_id
'response.write SQL
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalPlayAmt = objRS("sum_play_amt")
	else
		GetTotalPlayAmt=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetTicketStatus(ticket_id)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetTicketStatus_by_ticket_id " & ticket_id
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTicketStatus = objRS("rec_status")
	else
		GetTicketStatus=""
	end if
	set objRS=nothing
	set objDB=nothing
End Function

	refreshtime=""
	if Request("stoprefresh") <> "1" then
		refreshtime = Session("refreshtime")
	end if
%>
<html>
<head>
<title>.:: ดูโพย : คนแทง ::. </title>
<meta http-equiv="refresh" content="<%=refreshtime%>" />
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script src="include/js_function.js" language="javascript"></script>
<script language="JavaScript">
	function print_ticket(player) {
	var tkf, tkt
		if ((document.all.form1.tkfrom.value)=="" ) {
			alert("กรุณาระเลขที่ใบที่ต้องการพิมพ์ !!!");
			document.all.form1.tkfrom.focus();
			exit();
		}
		tkf = document.all.form1.tkfrom.value;
		tkt = document.all.form1.tkto.value;
		window.open("dealer_save_ticket.asp?printtype=printticket&selecttype=select&player="+player+"&ticket="+tkf+","+tkt, "_blank","top=20,left=20,height=760,width=1030,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=1,status=0,toolbar=0");	
	}
</script>
    <style type="text/css">
        .auto-style1 {
            color: #FFFFFF;
        }
    </style>
</head>
<body topmargin="0"  leftmargin="0">
	<center>
	<form name="form1" action="" method="post">
	<INPUT TYPE='hidden' name='stoprefresh' value='0'>	
	<input type="hidden" name="status_ticket" >
	<input type="hidden" name="ticket_id" value="<%=ticket_id%>">
	<%
	if ticket_id="" then
		Response.write  "<span class='tdbody'>ไม่มีโพย</span>"
		Response.end
	end if
	SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
	set objRS=objDB.Execute(SQL)	
	if not objRS.eof then
	%>
	<table border="0" width="890" class=table_red >
		<tr valign="top">
			<td><br><br><br>
				<table>					
					<tr>
						<td align="right" colspan="4">
						<input type=button class="inputE" style="cursor:hand; width:100" value="ออก" onClick="click_exit();">						
						</td>
					</tr>

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
						<td class="tdbody" align="right"><%
						If GetSend(player_id,game_id) - GetReceive(player_id,game_id) - GetReturn(player_id,game_id) < 0 Then 
							response.write "0"
						Else
							response.write GetSend(player_id,game_id) - GetReceive(player_id,game_id) - GetReturn(player_id,game_id)
						End if
						%></td>
						<td class="tdbody" align="right">ใบ</td>
					</tr>
					<tr>
						<td class="tdbody" align="right">เลขคืน</td>
						<td class="tdbody" align="right">=</td>
						<td class="tdbody" align="right"><%=GetReturn(player_id,game_id)%></td>
						<td class="tdbody" align="right">ใบ</td>
					</tr>							
					<tr >
						<td bgcolor="#66CCFF"  
						align="center" colspan="4"
						class="textbig_red" style="cursor:hand;" onClick="showsum('player',0)"
						onMouseOver="changeStyle(this,'textbig_red_over')"
						onMouseOut="changeStyle(this,'textbig_red')"><b>ยอดแทงรวม</b></td>
					</tr>
					<tr>
						<td class="tdbody1" align="center" colspan="4"><b><%=FormatN(GetTotalDealer_Rec(player_id,game_id),0)%></b></td>
					</tr>
					<tr >
						<td bgcolor="#66CCFF"  style="cursor:hand;" align="center" colspan="4"
						class="textbig_red"
							onClick="showsum('player','<%=objRS("ticket_number")%>')"
							onMouseOver="changeStyle(this,'textbig_red_over')"
							onMouseOut="changeStyle(this,'textbig_red')"
						><b>ยอดใบนี้</b></td>
					</tr>
					<tr>
						<td class="tdbody" align="center" colspan="4"><b><%=FormatN(GetTotalPlayAmt(ticket_id),0)%></b></td>
					</tr>
					<tr>
						<td class="tdbody" align="center" colspan="4"><font color="#FF0000">* <%=GetTicketStatus(ticket_id)%> *</b></td>
					</tr>
					<tr height="25"><td colspan="4">&nbsp;</tr>
					<tr>
						<td align="center" colspan="4" bgcolor="Red" >
						    <span class="auto-style1">ใบที่</span> <input type="text" name="ticket_number" size="5" class="input1" maxlength="5"
						value="<%=objRS("ticket_number")%>" onKeyDown="chkEnter(this)">
						</td>
					</tr>
					<tr>						
						<td align="center" colspan="4"><a href="view_player.asp?ticket_id=<%=prevTicket%>">
						<div class="arrow-up"></div></a></td>					
					</tr>
					<tr>	
                    <td align="center" colspan="4">				
						<%
						If nextTicket="" Then
						%>
						<a href="#">	
						<div class="arrow-down"></div></a>	
						<%
						else
						%>
						<a href="view_player.asp?ticket_id=<%=nextTicket%>&first_time=no">	
						<div class="arrow-down"></div></a>	
						<%
						End if
						%>
                        </td>	
					</tr>
					<tr>
						<td height=30 colspan=4>
						<table class=table_blue width=100%>
							<tr class=text_blue>
								<td align=center>พิมพ์ใบที่&nbsp;&nbsp;&nbsp;<input type=textbox name=tkfrom size=3>&nbsp;&nbsp; ถึง &nbsp;&nbsp;<input type=textbox name=tkto size=3></td>
							</tr>
							<tr>
								<td align=center><input type=button class="inputP" style="width:150" value="พิมพ์โพย" onClick="print_ticket('<%=player_id%>');"></td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
			</td>
			<td>

			<table  border="0"  cellpadding="1" cellspacing="0">
				<tr>
					<td bgcolor="Red" class="auto-style1" >เลขที่ &nbsp;<%=objRS("login_id")%></td>
					<td bgcolor="Red" class="auto-style1" >ชื่อ &nbsp;<%=objRS("player_name")%></td>
					<!---- เอาปุ่ม refresh ออก 2006-07-04 Jum ตาม แก้ไข49_015.xls -------->
					<%	'if Request("stoprefresh")="1" then	%>
								<!---td align="left"><input type=button name=cmdrefresh value="Refresh อัตโนมัติ" class=button_red onClick="click_stop_refresh('0')"></td --->
					<%	'else	%>
								<!---td align="left"><input type=button name=cmdrefresh value="หยุด Refresh อัตโนมัติ" class=button_red onClick="click_stop_refresh('1')"></td --->
					<%	'end if	%>
					<!---- เอาปุ่ม refresh ออก 2006-07-04 Jum ตาม แก้ไข49_015.xls -------->
					<td  align="right" class="tdbody1" nowrap>
					วันที่ <%=objRS("ticket_date")%>
					ส่ง <%=objRS("ticket_time")%>
					&nbsp;
					เวลารับโพย <%=objRS("rec_time")%>
					&nbsp; 
					คีย์ <%= GetKey(ticket_id) %>
					<%=" ip: " & GetValueFromTable("tb_ticket","ip_address","ticket_id=" & ticket_id) %>
					</td>

				</tr>
			</table>
			<%
			SQL="exec spGet_tb_ticket_key_by_ticket_id " & ticket_id
'response.write SQL
			set objRS=objDB.Execute(SQL)
			Dim show_type
			Dim ar_disp
			reDim ar_disp(99,8)
			i=1
			if not objRS.eof then
				while not objRS.eof
					ar_disp(i,1)=objRS("updown_type")
					ar_disp(i,2)=objRS("str_updown_type")
					ar_disp(i,3)=objRS("key_number")				
					ar_disp(i,4)=objRS("dealer_rec")
					ar_disp(i,5)=objRS("check_status")
					ar_disp(i,6)=objRS("key_money")
					ar_disp(i,7)=objRS("is_chg_number")
					ar_disp(i,8)=objRS("number_status")
'if objRS("number_status")=3 then
'response.write "xxx"
'end if
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1"  bgcolor="#D4D4D4"><%
				Dim tmpColor1, tmpColor2, tmpColor3, tmpColor4, tmpColor5, tmpColor6, tmpColor7

				Dim l,tmpColor42 ,tmpColor43
				l=4
				SQL="select rec_status from tb_ticket where ticket_id=" & ticket_id
				set objRS=objDB.Execute(SQL)
				if not objRS.eof then
					if objRS("rec_status")=1 then ' รอรับ 				
						l=6
					end if
				end if
			
				for i=1 to line_per_page
					j=i+line_per_page
					k=j+line_per_page					
					tmpColor1="#FFFFFF"
					tmpColor2="#FFFFFF"
					tmpColor3="#FFFFFF"
					tmpColor4=""
					tmpColor42=""
					tmpColor43=""
					if ar_disp(i,5)=1 then
						tmpColor1="#00C1C1"
					end If
					tmpColor5="#000000"
					If ar_disp(i,7)="1" Then
						tmpColor5="red"
					End If
					
					if ar_disp(j,5)=1 then
						tmpColor2="#51CAC4"
					end If
					tmpColor6="#000000"
					If ar_disp(j,7)="1" Then
						tmpColor6="red"
					End If

					if ar_disp(k,5)=1 then
						tmpColor3="#51CAC4"
					end If
					tmpColor7="#000000"
					If ar_disp(k,7)="1"   Then
						tmpColor7="red"
					End If
					'jum 20070913
					'If ar_disp(i,8)=3  or ar_disp(i,8)=4  Then
						'tmpColor1="red"
					'End If
					'if ar_disp(j,8)=3 or ar_disp(j,8)=4 then
					'	tmpColor2="red"
					'End If						
					'if ar_disp(k,8)=3 or ar_disp(k,8)=4 then
					'	tmpColor3="red"
				'	End If						
					'jum 20070913

					if ar_disp(i,4)<>ar_disp(i,6) then
						tmpColor4="#FF0000"
					end If
					if ar_disp(j,4)<>ar_disp(j,6) then
						tmpColor42="#FF0000"
					end If
					if ar_disp(k,4)<>ar_disp(k,6) then
						tmpColor43="#FF0000"
					end If
					
					if l=6 then tmpColor4="#8F8F8F"
					if IsTelephone=1 then 
				%>
				<tr>
					<%
					if ar_disp(i,1)=1 then ' ล่าง
						show_type="<font color='red'>ล</font>"
					else
						if ar_disp(i,1)=3 then ' บน + ล่าง
							show_type="บ+<font color='red'>ล</font>"
						else
							show_type= ar_disp(i,2)
						end if
					end  if 
					%>	
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=show_type%></td>

					<td class="tdbody1" width="40" align="right" bgcolor="<%=tmpColor1%>">&nbsp;<font color="<%=tmpColor5%>"><%=ar_disp(i,3)%></font></td>
					<td class="tdbody1" align="center" bgcolor="<%=tmpColor3%>">=</td>
					<td class="tdbody1" width="70" bgcolor="<%=tmpColor3%>">&nbsp;
					<font color=<%=tmpColor4%>><%=ar_disp(i,l)%></font>
					</td>
					<td class="tdbody_red" width="20" align="right"><%=i%></td>
				</tr>
				<%
					else
				%>
				<tr>			
					<%
					if ar_disp(i,1)=1 then ' ล่าง
						show_type="<font color='red'>ล</font>"
					else
						if ar_disp(i,1)=3 then ' บน + ล่าง
							show_type="บ+<font color='red'>ล</font>"
						else
							show_type= ar_disp(i,2)
						end if
					end if 
					%>	
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=show_type%></td>
					
					<td class="tdbody1" width="40" align="right" bgcolor="<%=tmpColor1%>">&nbsp;<font color="<%=tmpColor5%>"><%=ar_disp(i,3)%></font></td>
					<td class="tdbody1" align="center" bgcolor="<%=tmpColor1%>">=</td>
					<td class="tdbody1" width="100" nowrap  bgcolor="<%=tmpColor1%>">&nbsp;
					<font color=<%=tmpColor4%>><%=ar_disp(i,l)%></font>
					</td>			
					<%
					if ar_disp(j,1)=1 then ' ล่าง
						show_type="<font color='red'>ล</font>"
					else
						if ar_disp(j,1)=3 then ' บน + ล่าง
							show_type="บ+<font color='red'>ล</font>"
						else
							show_type= ar_disp(j,2)
						end if
					end if 
					%>	
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=show_type%></td>
					<td class="tdbody1" width="40" align="right" bgcolor="<%=tmpColor2%>">&nbsp;<font color="<%=tmpColor6%>"><%=ar_disp(j,3)%></font></td>
					<td class="tdbody1" align="center" bgcolor="<%=tmpColor2%>">=</td>
					<td class="tdbody1" width="100" nowrap  bgcolor="<%=tmpColor2%>">&nbsp;

					<font color=<%=tmpColor42%>><%=ar_disp(j,l)%></font>
					</td>

					<%
					if ar_disp(k,1)=1 then ' ล่าง
						show_type="<font color='red'>ล</font>"
					else
						if ar_disp(k,1)=3 then ' บน + ล่าง
							show_type="บ+<font color='red'>ล</font>"
						else
							show_type= ar_disp(k,2)
						end if
					end if 
					%>	
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=show_type%></td>
					<td class="tdbody1" width="40" align="right" bgcolor="<%=tmpColor3%>">&nbsp;<font color="<%=tmpColor7%>"><%=ar_disp(k,3)%></font></td>
					<td class="tdbody1" align="center" bgcolor="<%=tmpColor3%>">=</td>
					<td class="tdbody1" width="100" nowrap bgcolor="<%=tmpColor3%>" >&nbsp;

					<font color=<%=tmpColor43%>><%=ar_disp(k,l)%></font>
					
					</td>
					<td class="tdbody_red" width="20" align="right"><%=i%></td>
				</tr>
				<%
					end if
				next
				%></table><%
			end if
		end if
		set objRS=nothing
		set objDB=nothing
	%>
			</td>
			<td>
				<br>
				<% call PrintPrice(Session("did"), player_id, game_id,"yes","0")

					%>
			</td>
		</tr>
	</table>
	</form>
	</center>
</body>
</html>

<script language="javascript">
	function click_stop_refresh(flg) {
		document.all.form1.stoprefresh.value = flg;
		document.all.form1.submit();
	}
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
		document.form1.action="key_player.asp"
		document.form1.submit();
	}
	function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){
			document.form1.submit();
		}
	}
</script>
<%
Function GetTicket_ID( player_id, game_id)
	If player_id="" then
		GetTicket_ID=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_id from tb_ticket a "
'//JUM 2008-04-01		SQL=SQL & " where ticket_status='A'  and " มีปัญหาเรื่อง ticket_status=D
		SQL=SQL & " where "
		SQL=SQL & " player_id=" & player_id & "  And "
		SQL=SQL & " game_id = " & game_id 
		SQL=SQL & " order by convert(money,ticket_number) "
'response.write SQL
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetTicket_ID = objRS("ticket_id")
		else
			GetTicket_ID=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function
Function GetTicket_Number( ticket_id)
	If ticket_id="" then
		GetTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_number from tb_ticket a "
		SQL=SQL & " where ticket_id= " & ticket_id
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetTicket_Number = objRS("ticket_number")
		else
			GetTicket_Number=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function
Function GetPreTicket_Number( ticket_number,player_id, game_id)
	If ticket_number="" then
		GetPreTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_id from tb_ticket a "
'//JUM 2008-04-01		SQL=SQL & " where ticket_status='A'  and " มีปัญหาเรื่อง ticket_status='D'
		SQL=SQL & " where "
		SQL=SQL & " player_id=" & player_id & "  And "
		SQL=SQL & " game_id = " & game_id
		SQL=SQL & " and convert(money,ticket_number) < " & ticket_number 
		SQL=SQL & " order by convert(money,ticket_number) desc"
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetPreTicket_Number = objRS("ticket_id")
		else
			GetPreTicket_Number=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function

Function GetNextTicket_Number( ticket_number,player_id, game_id)
	If ticket_number="" then
		GetNextTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_id from tb_ticket a "
'//JUM 2008-04-01		SQL=SQL & " where ticket_status='A'  and " มีปัญหาเรื่อง ticket_status='D'
		SQL=SQL & " where "
		SQL=SQL & " player_id=" & player_id & "  And "
		SQL=SQL & " game_id = " & game_id 
		SQL=SQL & " and convert(money,ticket_number) >" & ticket_number 
		SQL=SQL & " order by convert(money,ticket_number) "
		set objRS=objDB.Execute(SQL)
		if not objRs.EOF then
			GetNextTicket_Number = objRS("ticket_id")
		else
			GetNextTicket_Number=""
		end if
		set objRS=nothing
		set objDB=Nothing
	End if
End Function
%>
<script language="javascript">
	function showsum(showtype,ticketid) {
		window.open("dealer_showsum.asp?showtype="+showtype+"&tid="+ticketid,"_blank","top=150,left=0,height=250,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}
</script>


