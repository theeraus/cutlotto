<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
		dim refreshtime
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>
		<!--#include file="activate_time.asp"-->
<%
		Dim IsTelephone
		IsTelephone=Session("istelephone") 

		Dim objRS , objDB , SQL		
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Dim status_ticket , nextTicket, prevTicket	

		Dim ticket_id, line_per_page,i,j,k,game_id,player_id, ticket_number
		Dim arrRet, table_width
		if IsTelephone=1 then
			table_width="300"
			line_per_page=25
		else
			table_width="500"
			line_per_page=33
		end if
		ticket_id=Request("ticket_id")
		'--- ถ้า ticket_id ที่เข้ามาเป็น ticket_id ที่ไม่ได้อยู่ใน status เลขคืนแล้ว ส่งเจ้ามืออื่นไปแล้ว ไม่ต้องแสดงให้กลับไปหาที่ใบใหม่
		if ticket_id<>"" then 'jum  or send_status=3 2010-04-17
			SQL="select * from tb_ticket where (send_status=1 or send_status=3) and ticket_id=" & ticket_id
			set objRS=objDB.Execute(SQL)
			if objRS.eof then
				ticket_id=""
			end if
		end if
		game_id=Session("gameid")
		player_id=Session("uid")
		if game_id=0 then game_id=1

		nextTicket = ticket_id
		prevTicket= ticket_id
		if  ticket_id<>"" then
			
			ticket_number=GetTicket_Number(ticket_id)
			prevTicket=GetPreTicket_Number( ticket_number,player_id, game_id)
			nextTicket=GetNextTicket_Number( ticket_number,player_id, game_id)

		else	
			'--- ถ้าเป็นหน้าเลขคืนให้แสดง ticket ใบแรก
			SQL="exec spGet_ret_tb_ticket_by_player_id_game_id " & player_id & ", " & game_id
			set objRS=objDB.Execute(SQL)
			if not objRS.eof then
				if ticket_id="" then
					ticket_id=objRS("ticket_id")
				end if
				reDim arrRet(objRS.RecordCount)
				i=1
				while not objRS.eof
					if ticket_id=objRS("ticket_id") then
						j=i
					end if 
					arrRet(i)=objRS("ticket_id")
					i=i+1
					objRS.MoveNext				
				wend
				k=j  +1
				if Cint(k)>Cint(objRS.RecordCount) then 
					k=objRS.RecordCount
				end if
				nextTicket=arrRet(k)
				k=j -1
				if k<1 then k=1
				prevTicket=arrRet(k)
				'--- ใส่ array เอาไว้ next
			end if
		end if				
%>			
<%
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

	refreshtime=""
	if Request("stoprefresh") <> "1" then
		refreshtime = Session("refreshtime")
	end if
%>
<html>
<head>
<title>.:: คิวโพยเข้า : เจ้ามือ ::. </title>
<meta http-equiv="refresh" content="<%=refreshtime%>" />
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
    <style type="text/css">
        .style1
        {
            color: #FFFFFF;
        }
    </style>
</head>
<body topmargin="0"  leftmargin="0">
	<center>
	<form name="form1" action="ret_number.asp" method="post">
	<INPUT TYPE='hidden' name='stoprefresh' value='0'>	
	<input type="hidden" name="status_ticket" >
	<input type="hidden" name="ticket_id" value="<%=ticket_id%>">
	<%
	if ticket_id="" then
		Response.write  "<span class='tdbody'>ไม่มีเลขคืน</span>"
		Response.end
	end if
	SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
	set objRS=objDB.Execute(SQL)	
	if not objRS.eof then
	%>
	<table border="0" width="890" class=table_red>
		<tr valign="top">
			<td><br><br><br>
				<table width="170">					
					<tr>
						<td align="right" colspan="4">
						<input type=button class="inputE" style="cursor:hand; width:100" value="ออก"  onClick="click_exit();">
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
						<td class="tdbody" align="right"><%=GetSend(player_id,game_id) - GetReceive(player_id,game_id) %></td> <!-- 20060929 jum -GetReturn(player_id,game_id)---->
						<td class="tdbody" align="right">ใบ</td>
					</tr>
					<tr>
						<td class="tdbody" align="right">เลขคืน</td>
						<td class="tdbody" align="right">=</td>
						<td class="tdbody" align="right"><%=GetReturn(player_id,game_id)%></td>
						<td class="tdbody" align="right">ใบ</td>
					</tr>	
					<tr>
						<td align="right" colspan="4" height="20">
						    &nbsp;</td>
					</tr>
					<tr>
						<td align="right" colspan="4">
						<input type=button class="inputP" value="พิมพ์ส่ง" style="cursor:hand;width:100";" onClick="print2External();">
						</td>
					</tr>
					<tr>
						<td align="right" colspan="4">
						<input type=button class="inputG" value="ส่งเจ้าอื่น" style="cursor:hand;width:100";" onClick="SendNewDealer()">
						</td>
					</tr>			
					<tr>
						<td align="right" colspan="4" height="20" >
						    &nbsp;</td>
					</tr>			
					<tr>
						<td align="center" colspan="4" bgcolor="Red" >
						    <span class="style1">เลขคืนใบที่</span> <%=objRS("ticket_number")%>
						</td>
					</tr>
					<tr>
						
						<td align="right" colspan="4"><a href="ret_number.asp?ticket_id=<%=prevTicket%>">
						<div class="arrow-up"></div></a></td>
						
					</tr>
					<tr>
                    <td align="right" colspan="4">
						<%
						If nextTicket="" Then
						%>
							<a href="#">	
							<div class="arrow-down"></div></a>
						<%
						else
						%>
							<a href="ret_number.asp?ticket_id=<%=nextTicket%>">	
							<div class="arrow-down"></div></a>
						<%
						End if
						%>
                        </td>
					</tr>
				</table>
			</td>
			<td>

			<table  border="0"  cellpadding="1" cellspacing="0">
				<tr>
					<td bgcolor="Red"><span class="style1">เลขที่</span> &nbsp;<%=objRS("login_id")%></td>
					<td bgcolor="Red"><span class="style1">ชื่อ </span>&nbsp;<%=objRS("player_name")%></td>
		<%	if Request("stoprefresh")="1" then	%>
					<td align=right><input type=button name=cmdrefresh value="Refresh อัตโนมัติ" class=inputR style="cursor:hand;width:120;" onClick="click_stop_refresh('0')"></td>
		<%	else	%>
					<td align=right><input type=button name=cmdrefresh value="หยุด Refresh อัตโนมัติ" class=inputR style="cursor:hand;width:140;" onClick="click_stop_refresh('1')"></td>
		<%	end if	%>
				</tr>
			</table>
			<%
			SQL="exec spGet_tb_ticket_key_by_ticket_id_Ret " & ticket_id
			'response.write SQL
'			response.end
			set objRS=objDB.Execute(SQL)
			Dim ar_disp
			reDim ar_disp(99,4)
			i=1
			if not objRS.eof then
				while not objRS.eof
					If objRS("str_updown_type")="บ+ล" Then
						ar_disp(i,2)="บ<font color='red'>+ล</font>"
					End if
					If objRS("str_updown_type")="ล" Then
						ar_disp(i,2)="<font color='red'>ล</font>"
					End If
					If objRS("str_updown_type")="บ" Then
						ar_disp(i,2)="บ"
					End If
					ar_disp(i,1)=objRS("updown_type")				
					ar_disp(i,3)=objRS("key_number")
					ar_disp(i,4)=objRS("Ret_money")
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1"  bgcolor="#D4D4D4"><%
				for i=1 to line_per_page  '33
					j=i+line_per_page
					k=j+line_per_page
				%>
				<tr>					
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=ar_disp(i,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="tdbody" align="center">=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(i,4)%></td>
					<%
					if line_per_page=33 then
					%>
					<td class="tdbody_red" width="30" align="center">&nbsp;<%=ar_disp(j,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(j,3)%></td>
					<td class="tdbody" align="center">=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(j,4)%></td>

					<td class="tdbody_red" width="30" align="center">&nbsp;<%=ar_disp(k,2)%></td>
					<td class="tdbody" width="40" align="right">&nbsp;<%=ar_disp(k,3)%></td>
					<td class="tdbody" align="center">=</td>
					<td class="tdbody" width="100">&nbsp;<%=ar_disp(k,4)%></td>
					<%
					end if
					%>	
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
	function print2External(){
		window.open("print_ret_number.asp?ticket_id=<%=ticket_id%>" ,'_blank',						"top=0,height=670,width=500,status=no,toolbar=yes,menubar=no,location=no");
	}
		function SendNewDealer(){
		openDialog('sendNewDealer.asp?ticket_id=<%=ticket_id%>', 8, 5, 300, 200);

		//window.open("sendNewDealer.asp?ticket_id=<%=ticket_id%>" ,'_blank',						//"top=5,left=5,height=300,width=300,status=no,toolbar=no,menubar=no,location=no");
	}
</script>
<%
Function GetTicket_Number( ticket_id)
	If ticket_id="" then
		GetTicket_Number=""
	else
		Dim objRS , objDB , SQL
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")
		SQL="select  ticket_number from tb_ticket a "
		SQL=SQL & " where  ticket_id=" & ticket_id
		
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
		SQL=SQL & " where ticket_status='A'  and "
		SQL=SQL & " rec_status in (3,4) and "
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
		SQL=SQL & " where ticket_status='A'  and "
		SQL=SQL & " rec_status in (3,4) and "
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