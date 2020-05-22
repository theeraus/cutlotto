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
		if trim(Session("uid"))="" then
%>
	<script language=javascript>
			self.close();
	</script>
<%		
		end if
		Server.ScriptTimeout = 600
		Dim ticket_id, line_per_page,i,j,k
		dim gameid
		Dim objRS , objDB , SQL, rsTk, Rs
		dim arrPlayer, arrTkFrom, arrTkTo, printType, selectType, strCri, arrTk
		dim saveid
		dim savetkid
		dim savename

		line_per_page=33
		saveid = Request("saveid")
		
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 		
		Set rsTk =Server.CreateObject("ADODB.Recordset")		





%>			
<html>
<head>
<title>.:: เก็บข้อมูล ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
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
<body topmargin="0"  leftmargin="0">
	<center>

<%
		SQL="Select save_tk_id from tb_save_ticket where save_id = " & saveid
		SQL = SQL & " Order by player_id, save_tk_id"
'showstr SQL
		set rsTk=objDB.Execute(SQL)	
		if not rsTk.eof then
			do while not rsTk.eof
				'Response.write "<PB>"
				call ShowTicket(rsTk("save_tk_id"))
				Response.Flush
				rsTk.MoveNext
				if not rsTk.Eof then
					Response.write "<br style='page-break-before:always;'>"
				end if
			loop

		end if

%>
	</form>
	</center>
</body>
</html>
<%

function ShowTicket(ticket_id)
	dim objRS, objDB, Rs
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")	
	Set Rs =Server.CreateObject("ADODB.Recordset")	
	
%>
	<table>
		<tr valign="top">
			<td>
	<%
		SQL="select * from tb_save_ticket where save_tk_id = " & ticket_id
		set objRS=objDB.Execute(SQL)	
		if not objRS.eof then
			%>
			<table  border="0"  cellpadding="1" cellspacing="0" width="600">
				<tr>
					<td class="tdbody" colspan=12><%=objRS("ticket_header")%></td>
				</tr>
				<tr>
					<td class="tdbody" colspan=12><%=objRS("ticket_header2")%></td>
				</tr>

			</table><br>
			<%
			SQL="select * from tb_save_number where save_tk_id =" & ticket_id
			set objRS=objDB.Execute(SQL)
			Dim ar_disp,tmpColor1
			reDim ar_disp(99,5)
			i=1
			if not objRS.eof then
				while not objRS.eof
					if i <=99 then 
						ar_disp(i,1)=objRS("updown_type")
						ar_disp(i,2)=objRS("str_updown_type")						
						ar_disp(i,3)=objRS("key_number")
						ar_disp(i,4)=objRS("key_money")
						ar_disp(i,5)=objRS("check_status")
					end if
					i=i+1
					objRS.MoveNext
				wend
				'---- แสดงโพย แถวละ 33 ค่า
				%><table  border="0"  cellpadding="1" cellspacing="1" width="100%" bgcolor="#D4D4D4" class="table"><%
				for i=1 to 33
					j=i+line_per_page
					k=j+line_per_page					
				%>
				<tr>					
					<td class="tdbody_blue" width="40" align="center" nowrap>&nbsp;
					<%  if ar_disp(i,2) <> "" then
							'Response.write ar_disp(i,2)
							If ar_disp(i,2)="บ" Then
								Response.write "<font color='#000000'>" & ar_disp(i,2) & "</font>"								
							End If
							If ar_disp(i,2)="ล" Then
								Response.write "<font color='red'>" & ar_disp(i,2) & "</font>"								
							End if							
							If ar_disp(i,2)="บ+ล" Then
								Response.write "<font color='#000000'>บ</font>+<font color='red'>ล</font>"								
							End if
						else
							Response.write "-"
						end if						
						tmpColor1="#FFFFFF"
						if ar_disp(i,5) = "1" then tmpColor1="#51CAC4"						
					%>
					</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="40" align="right">&nbsp;<%=ar_disp(i,3)%></td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" align="center">&nbsp;=</td>
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=replace(ar_disp(i,4),".00","")%></td>
				
					<td class="tdbody_blue" width="40"  align="center" nowrap>&nbsp;
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
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=replace(ar_disp(j,4),".00","")%></td>

					<td class="tdbody_blue" width="40"  align="center" nowrap>&nbsp;
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
					<td class="tdbody1" bgColor="<%=tmpColor1%>" width="100">&nbsp;<%=replace(ar_disp(k,4),".00","")%></td>

					<td class="tdbody_blue" width="20" align="right"><%=i%></td>
				</tr>
				<%
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