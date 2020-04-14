<%@ Language=VBScript %>
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
		if trim(Session("uid"))="" then
%>
	<script language=javascript>
			self.close();
	</script>
<%		
		end if
		Server.ScriptTimeout = 0		
		Dim ticket_id, line_per_page,i,j,k
		dim gameid
		Dim objRS , objDB , SQL, rsTk, Rs, Rs2
		dim arrPlayer, arrTkFrom, arrTkTo, printType, selectType, strCri, arrTk
		dim saveid
		dim savetkid
		dim savename

		line_per_page=33
		ticket_id=Request("ticket_id")
		gameid=Session("gameid")

		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 		
		Set rsTk =Server.CreateObject("ADODB.Recordset")		
		Set Rs =Server.CreateObject("ADODB.Recordset")		

		Dim status_ticket 	
		savename = Request("savename")

		arrPlayer = split(Request("player"),",")
		arrTkFrom = split(Request("ticketfrom"),",")
		arrTkTo = split(Request("ticketto"),",")
		
		printType  = Request("printtype")
		selectType = Request("selecttype")

		if printtype = "printticket" then  'มาจากหน้าพิมพ์โพยเจ้ามือ

			arrTk = split(Request("ticket"),",")
			strCri = " And player_id = " & arrPlayer(0)
			if arrTk(1) = "" then
				strCri = strCri & " And ticket_number = " & arrTk(0)
			else
				strCri = strCri & " And ticket_number between " & arrTk(0) & " And " & arrTk(1)
			end if
		elseif selectType = "select" then

			for i = 0 to Ubound(arrPlayer)
				if strCri = "" then
					strCri = " And ("
				else
					strCri = strCri & " Or "
				end if
				if Ubound(arrTkFrom) >= i then
					if trim(arrTkFrom(i)) <> "" and trim(arrTkTo(i)) <> "" then
						strCri = strCri & " (player_id = " & arrPlayer(i) & " And (ticket_number between " & arrTkFrom(i) & " And " & arrTkTo(i) & "))"
					else
						strCri = strCri & " (player_id = " & arrPlayer(i) & ")"
					end if
				else
					strCri = strCri & " (player_id = " & arrPlayer(i) & ")"
				end if
			next
			strCri = strCri & ")"
		end if
		'showstr "print " &  printType & " select " & selectType
%>			
<html>
<head>
<title>.:: เก็บข้อมูล ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<STYLE>
   PB { page-break-after: always }
</STYLE>
<script language=JavaScript>
function doPrint()   {  
	if(self.print)   {  
		self.print();  
		self.close();  
		return false;  
	}  
}
</script>
</head>
<%	
	saveid = 0
	if printType = "printer" or printType = "printticket" then %>
<body topmargin="0"  leftmargin="0" onLoad="doPrint();">
<%	else %>
<body topmargin="0"  leftmargin="0">
<%	
		'********** save game
		SQL = "exec spInsertTBSaveGame '" & savename & "', " & gameid & ", " &  Session("uid") & ", ''"
		set Rs=objDB.Execute(SQL)			
		if not Rs.EOF then
			saveid=clng(Rs("save_id"))

			SQL = "exec spInsertTBSaveGameTicketNew " & gameid & ", " & saveid & ", '" & strCri & "' "
'response.write SQL
'response.end
			set Rs2=objDB.Execute(SQL)			

		end if
		Rs.Close
		'Rs2.Close
'เพิ่มใหม่ ให้ save อย่างเดียวแล้วจบเลย
		Response.write "<script language=javascript>alert('ทำการบันทึกข้อมูลเรียบร้อยแล้ว !'); window.opener.close(); window.close();</script>"
		response.end
	end if
%>
	<center>
	<form name="form1" action="dealer_save_ticket.asp" method="post">
<%
		SQL="Select ticket_id, rec_status from tb_ticket where game_id = " & gameid 
		SQL=SQL & " and rec_status in (2,3) " 	
		if strCri <> "" then SQL = SQL & strCri
		SQL = SQL & " Order by player_id, ticket_number"
'showstr SQL
		set rsTk=objDB.Execute(SQL)	
		if not rsTk.eof Then
			' วนแสดงทีละ ticket
			do while not rsTk.eof
				'Response.write "<PB>"
				If rsTk("rec_status")="2" Or rsTk("rec_status")="3" then
					call ShowTicket(rsTk("ticket_id"), saveid)
				Else
					call ShowTicketReject(rsTk("ticket_id"), saveid) ' CASE ที่ไม่รับ / รอรับ
				End if
				rsTk.MoveNext
				if not rsTk.Eof then
					Response.write "<br style='page-break-before:always;'>"
				end if
			loop
		end If
		'ส่วนของใบที่ ไม่รับ / รอรับ
		SQL="Select ticket_id, rec_status from tb_ticket where game_id = " & gameid 
		SQL=SQL & " and rec_status not in (2,3) " 	
		if strCri <> "" then SQL = SQL & strCri
		SQL = SQL & " Order by player_id, ticket_number"
		set rsTk=objDB.Execute(SQL)	
		if not rsTk.eof then
			do while not rsTk.eof
				call ShowTicketReject(rsTk("ticket_id"), saveid) ' CASE ที่ไม่รับ / รอรับ
				rsTk.MoveNext
				if not rsTk.Eof then
					Response.write "<br style='page-break-before:always;'>"
				end if
			loop
		end If


		' เพิ่ม การบันทึกตัด
		if printType = "file" and saveid > 0  then
			SQL = "exec spInsertTBSaveCut " & saveid & "," & gameid & ""
'			showstr SQL
			set Rs=objDB.Execute(SQL)			
			'Rs.Close
			Response.write "<script language=javascript>alert('ทำการบันทึกข้อมูลเรียบร้อยแล้ว !'); window.opener.close(); window.close();</script>"
		end if
%>
	</form>
	</center>
</body>
</html>
<%

function ShowTicket(ticket_id, saveid)
	dim objRS, objDB, Rs
	dim saveticketid
	dim savetickethead
	dim savetickethead2
	dim recstatus
	dim keyer
	dim saveplayerid
	dim saveplayer
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")	
	Set Rs =Server.CreateObject("ADODB.Recordset")	
	
%>
	<table>
		<tr valign="top">
			<td>
	<%
		Dim rec_status
		SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
		set objRS=objDB.Execute(SQL)	
		if not objRS.eof Then
				rec_status=objRS("rec_status")
				if objRS("rec_status") = 0 then 
					recstatus = "ยังไม่ส่ง"
				elseif objRS("rec_status") = 1 then 
					recstatus = "ส่ง ยังไม่ได้รับ"
				elseif objRS("rec_status") = 2 then 
					recstatus = "รับทั้งหมด"
				elseif objRS("rec_status") = 3 then 
					recstatus = "รับบางส่วน"
				elseif objRS("rec_status") = 4 then 
					recstatus = "ไม่รับ"
				end if
				keyer = GetValueFromTable("sc_user", "user_name", "user_id=" & objRS("key_id") )
				savetickethead  = "เลขที่ " & objRS("login_id") & "   ชื่อ " & objRS("player_name") & "   ใบที่ "  & objRS("ticket_number") & "   ยอดแทงรวม  " &  formatnumber(GetTotalPlay(objRS("player_id"),objRS("game_id")),0)  & "  ยอดใบนี้  " & formatnumber(objRS("total_play_amt"),0)
				savetickethead2  = "วันที่  "  & objRS("ticket_date") & "    ส่ง  "  & objRS("ticket_time") & "    รับ  " &  objRS("rec_time")  & "    คนคีย์  " & keyer & "    สถานะ  " & recstatus
				saveplayerid = objRS("player_id")
				saveplayer = objRS("player_name")
'********* เปลี่ยนการ save ไป save ใน store ทั้งหมดทีเดียว   09/02/10
'				if saveid > 0 then 
'					'********** save game
'					SQL = "exec spInsertTBSaveGameTicket " & saveid & ", " & objRS("player_id") & ", '" & objRS("player_name") & "', " & ticket_id & ", '" & savetickethead & "', '" & savetickethead2 & "'"
'					set Rs=objDB.Execute(SQL)			
'					saveticketid = 0
'					if not Rs.EOF then
'						saveticketid=clng(Rs("save_tk_id"))
'					end if
'					Rs.Close
'				end if
			%>
			<table  border="0"  cellpadding="1" cellspacing="0" width="800">
				<tr>
					<td class="tdbody" colspan=12><%=savetickethead%></td>
<!-- 					<td class="tdbody" colspan=12>เลขที่&nbsp;<%=objRS("login_id")%>&nbsp;&nbsp;&nbsp;ชื่อ&nbsp;<%=objRS("player_name")%>&nbsp;&nbsp;&nbsp;ใบที่ &nbsp;<%=objRS("ticket_number")%>&nbsp;&nbsp;&nbsp;ยอดแทงรวม  &nbsp;<%=formatnumber(GetTotalPlay(objRS("player_id"),objRS("game_id")),0)%>&nbsp;ยอดใบนี้ &nbsp;<%=formatnumber(objRS("total_play_amt"),0)%></td> -->
				</tr>
				<tr>
					<td class="tdbody" colspan=12><%=savetickethead2%></td>
				</tr>
			</table><br>
			<%
'			SQL="exec spGet_tb_ticket_key_by_ticket_id " & saveid & ", " & ticket_id & ", " & saveplayerid & ", '" & saveplayer & "'"
			SQL="exec spGet_tb_ticket_key_by_ticket_id " & ticket_id 
			set objRS=objDB.Execute(SQL)
			Dim ar_disp, tmpColor1, tmpChk
			reDim ar_disp(99,5)
'			i=1
'			for i=1 to 99
'				ar_disp(i,2)="-"
'			next
			i=1
			if not objRS.eof then
				while not objRS.eof
' anon comment 040209   ย้ายไป save ทีละ ticket ใน spInsertTBSaveGameTicket
'					if  saveticketid > 0 then
'						tmpChk = 1
'						if objRS("check_status")="" or Isnull(objRS("check_status")) then tmpChk = 0
'						SQL = "exec spInsertTBSaveGameNumber " & saveticketid & ", " & objRS("updown_type") & ", '" & objRS("str_updown_type") & "', '" & objRS("key_number") & "', '" & objRS("dealer_rec") & "', " & tmpChk & ""
'						set Rs=objDB.Execute(SQL)			
'					end if
					if i <=99 then 
						ar_disp(i,1)=objRS("updown_type")
						ar_disp(i,2)=objRS("str_updown_type")
						ar_disp(i,3)=objRS("key_number")
						If CInt(rec_status) <= 1  Then ' เจ้ามือยังไม่ได้รับ 
							ar_disp(i,4)=objRS("key_money")  'jum 2007-09-10
						Else
							ar_disp(i,4)=objRS("dealer_rec") ' objRS("key_money") jum 2007-09-10
						End if
						ar_disp(i,5)=objRS("check_status")
					end if
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1" width="600" bgcolor="#D4D4D4"><%
				for i=1 to 33
					j=i+line_per_page
					k=j+line_per_page					
				%>
				<tr>					
					<td class="tdbody_blue" width="35" align="center" nowrap>&nbsp;
					<%  if ar_disp(i,2) <> "" then
							Response.write ar_disp(i,2)
						else
							Response.write "-"
						end if					
						tmpColor1="#FFFFFF"
						if ar_disp(i,5) = "1" then tmpColor1="#51CAC4"						
					%>
					</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(i,4)%></td>
				
					<td class="tdbody_blue" width="35"  align="center" nowrap>&nbsp;
					<%  if ar_disp(j,2) <> "" then
							Response.write ar_disp(j,2)
						else
							Response.write "-"
						end if		
						tmpColor1="#FFFFFF"
						if ar_disp(j,5) = "1" then tmpColor1="#51CAC4"						
					%>

					</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(j,3)%></td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(j,4)%></td>

					<td class="tdbody_blue" width="35"  align="center" nowrap>&nbsp;
					<%  if ar_disp(k,2) <> "" then
							Response.write ar_disp(k,2)
						else
							Response.write "-"
						end if					
						tmpColor1="#FFFFFF"
						if ar_disp(k,5) = "1" then tmpColor1="#51CAC4"
						
					%>

					</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(k,3)%></td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(k,4)%></td>

					<td class="tdbody_blue" width="20" align="right"><%=i%></td>
				</tr>
				<%
							Response.flush

				next
				%></table><%
			end if
		end if
		set objRS=nothing
		set objDB=nothing
		Server.ScriptTimeout = 60
	%>
			</td>
		</tr>
	</table>
<%
end Function
function ShowTicketReject(ticket_id, saveid) ' แสดงข้อมูล ticket ที่ไม่รับ  rec_status=4
	dim objRS, objDB, Rs
	dim saveticketid
	dim savetickethead
	dim savetickethead2
	dim recstatus
	dim keyer
	dim saveplayerid
	dim saveplayer
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")	
	Set Rs =Server.CreateObject("ADODB.Recordset")	
	
%>
	<table>
		<tr valign="top">
			<td>
	<%
		Dim rec_status
		SQL="exec spGettb_ticket_by_ticket_id " & ticket_id
		set objRS=objDB.Execute(SQL)	
		if not objRS.eof Then
				rec_status=objRS("rec_status")
				if objRS("rec_status") = 0 then 
					recstatus = "ยังไม่ส่ง"
				elseif objRS("rec_status") = 1 then 
					recstatus = "ส่ง ยังไม่ได้รับ"
				elseif objRS("rec_status") = 2 then 
					recstatus = "รับทั้งหมด"
				elseif objRS("rec_status") = 3 then 
					recstatus = "รับบางส่วน"
				elseif objRS("rec_status") = 4 then 
					recstatus = "ไม่รับ"
				end if
				keyer = GetValueFromTable("sc_user", "user_name", "user_id=" & objRS("key_id") )
				savetickethead  = "เลขที่ " & objRS("login_id") & "   ชื่อ " & objRS("player_name") & "   ใบที่ "  & objRS("ticket_number") & "   ยอดแทงรวม  " &  formatnumber(GetTotalPlay(objRS("player_id"),objRS("game_id")),0)  & "  ยอดใบนี้  " & formatnumber(objRS("total_play_amt"),0)
				savetickethead2  = "วันที่  "  & objRS("ticket_date") & "    ส่ง  "  & objRS("ticket_time") & "    รับ  " &  objRS("rec_time")  & "    คนคีย์  " & keyer & "    สถานะ  " & recstatus
				saveplayerid = objRS("player_id")
				saveplayer = objRS("player_name")
'********* เปลี่ยนการ save ไป save ใน store ทั้งหมดทีเดียว   09/02/10
'				if saveid > 0 then 
'				'********** save game
'					SQL = "exec spInsertTBSaveGameTicket " & saveid & ", " & objRS("player_id") & ", '" & objRS("player_name") & "', " & ticket_id & ", '" & savetickethead & "', '" & savetickethead2 & "'"
'					set Rs=objDB.Execute(SQL)			
'					saveticketid = 0
'					if not Rs.EOF then
'						saveticketid=clng(Rs("save_tk_id"))
'					end if
'					Rs.Close
'				end if
			%>
			<table  border="0"  cellpadding="1" cellspacing="0" width="800">
				<tr>
					<td class="tdbody" colspan=12><%=savetickethead%></td>
				</tr>
				<tr>
					<td class="tdbody" colspan=12><%=savetickethead2%></td>
				</tr>
			</table><br>
			<%
			SQL="exec spGet_tb_ticket_key_by_ticket_id " & ticket_id 
			set objRS=objDB.Execute(SQL)
			Dim ar_disp, tmpColor1, tmpChk
			reDim ar_disp(99,5)
			i=1
			if not objRS.eof then
				while not objRS.eof
' anon comment 040209   ย้ายไป save ทีละ ticket ใน spInsertTBSaveGameTicket
'					if  saveticketid > 0 then
'						tmpChk = 1
'						if objRS("check_status")="" or Isnull(objRS("check_status")) then tmpChk = 0
'						SQL = "exec spInsertTBSaveGameNumber " & saveticketid & ", " & objRS("updown_type") & ", '" & objRS("str_updown_type") & "', '" & objRS("key_number") & "', '" & objRS("dealer_rec") & "', " & tmpChk & ""
'						set Rs=objDB.Execute(SQL)			
'					end if
					if i <=99 then 
						ar_disp(i,1)=objRS("updown_type")
						ar_disp(i,2)=objRS("str_updown_type")
						ar_disp(i,3)=objRS("key_number")
						If CInt(rec_status) <= 1  Then ' เจ้ามือยังไม่ได้รับ 
							ar_disp(i,4)=objRS("key_money")  'jum 2007-09-10
						Else
							ar_disp(i,4)=objRS("dealer_rec") ' objRS("key_money") jum 2007-09-10
						End if
						ar_disp(i,5)=objRS("check_status")
					end if
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1" width="600" bgcolor="#D4D4D4"><%
				for i=1 to 33
					j=i+line_per_page
					k=j+line_per_page					
				%>
				<tr>					
					<td class="text_red" width="35" align="center" nowrap>&nbsp;
					<%  if ar_disp(i,2) <> "" then
							Response.write ar_disp(i,2)
						else
							Response.write "-"
						end if					
						tmpColor1="#FFFFFF"
						if ar_disp(i,5) = "1" then tmpColor1="#51CAC4"						
					%>
					</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="text_red" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(i,4)%></td>
				
					<td class="text_red" width="35"  align="center" nowrap>&nbsp;
					<%  if ar_disp(j,2) <> "" then
							Response.write ar_disp(j,2)
						else
							Response.write "-"
						end if		
						tmpColor1="#FFFFFF"
						if ar_disp(j,5) = "1" then tmpColor1="#51CAC4"						
					%>

					</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(j,3)%></td>
					<td class="text_red" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(j,4)%></td>

					<td class="text_red" width="35"  align="center" nowrap>&nbsp;
					<%  if ar_disp(k,2) <> "" then
							Response.write ar_disp(k,2)
						else
							Response.write "-"
						end if					
						tmpColor1="#FFFFFF"
						if ar_disp(k,5) = "1" then tmpColor1="#51CAC4"
						
					%>

					</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(k,3)%></td>
					<td class="text_red" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="text_red" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=ar_disp(k,4)%></td>

					<td class="text_red" width="20" align="right"><%=i%></td>
				</tr>
				<%
				next
				%></table><%
			end if
		end if
		set objRS=nothing
		set objDB=nothing
		Server.ScriptTimeout = 120
	%>
			</td>
		</tr>
	</table>
<%
end function

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