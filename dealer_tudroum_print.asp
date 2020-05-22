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
dim objRec, objRec2
dim strSql
dim i
dim chkTud
dim cutSeq
dim cutallid
dim sumall 
dim ticketid

dim arrNum
dim arrMoney
dim arrCuttype
	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set objRec2 = Server.CreateObject ("ADODB.Recordset")

	'********** แสดงเพื่อพิมพ์
dim cntcol
dim cntrow
dim chktype
		If Request("resend") = "Y" Then
			if Request("ticketid")<>"" then ticketid=Trim(Request("ticketid"))
		Else 
			cutallid=Session("cutallid")
		End if
		If Request("cutallid")<> "" Then cutallid = Trim(Request("cutallid"))

'		strSql = "Select * from tb_cut_all_det where cutall_id="&cutallid
		strSql = "SELECT     tb_ticket_number.* " _
			& "FROM tb_ticket inner join tb_ticket_key on tb_ticket.ticket_id = tb_ticket_key.ticket_id INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " 
		If Request("resend") = "Y" then
			strSql = strSql & "WHERE     (tb_ticket.ticket_id = "&ticketid&") and tb_ticket_number.sum_flag = 'Y' order by play_type"
		Else
			strSql = strSql & "WHERE     (tb_ticket.ref_cutall_id = "&cutallid&") and tb_ticket_number.sum_flag = 'Y' order by play_type"
		End if
'			เปลี่ยนจาก ref_cutall_id  เป็น ticket_id
'			& "WHERE     (tb_ticket.ref_cutall_id = "&ticketid&") and tb_ticket_number.sum_flag = 'Y' order by play_type"

'showstr "cutid=" & cutallid & "ticket =" & ticketid &  "<br>		" &  strSql

		objRec.Open strSql, conn
		if not objRec.eof then
			strSql = "SELECT     SUM(tb_ticket_number.dealer_rec) AS sum " _
				& "FROM tb_ticket inner join tb_ticket_key on tb_ticket.ticket_id = tb_ticket_key.ticket_id INNER JOIN tb_ticket_number ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id " 
		If Request("resend") = "Y" then
			strSql = strSql &  "WHERE     (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket.ticket_id = " & ticketid & ")"
		Else
			strSql = strSql &  "WHERE     (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket.ref_cutall_id = " & cutallid & ")"
		End if

'			เปลี่ยนจาก ref_cutall_id  เป็น ticket_id
'				& "WHERE     (tb_ticket_number.sum_flag = 'Y') AND (tb_ticket.ref_cutall_id = " & ticketid & ")"
			
			objRec2.Open strSql, conn
			if not objRec2.Eof then
				sumall = objRec2("sum")
			else
				sumall = 0
			end if
			objRec2.close

%>
<HTML>
<HEAD>
<script language=javascript>
	function close_me() {
		opener.window.open("dealer_play_out.asp","bodyFrame")
		window.close();
	}
	function print_me() {
		self.print();
		opener.window.open("dealer_play_out.asp","bodyFrame")
		self.close();
	}
</script>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<BODY topmargin=0 leftmargin=0>

			<TABLE width='650' align=center cellSpacing=0 cellPadding=0  border=0 class=box1>        	
			<tr>
				<td colspan=7 align=center class=text_black style='FONT-SIZE: 12pt;' bgColor=#FFFFFF>จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง<u>&nbsp;&nbsp;&nbsp;<%=sumall%>&nbsp;&nbsp;&nbsp;</u></td>
			</tr>
<%		
			cntcol=0
			cntrow=0
			do while not objRec.eof
				if chktype <> objRec("play_type") then
					if cntrow > 0 then
						call GenEmptyCol(cntcol, cntRow)						
						cntrow=cntrow+1
					end if
					response.write "<tr bgcolor=#FFFFFF><td colspan=6 align=center 			<td width='600' align=center class=head_black  style='FONT-SIZE: 12pt;' height=30>"&GetPlayTypeName(objRec("play_type"))&"</td>"
					chktype=objRec("play_type")
					cntcol=0
					call GenEmptyCol(6, cntRow)
					cntrow=cntrow+1
					response.write "</tr>"
				end if
				if cntcol=0 then response.write "<tr bgcolor=#FFFFFF>"
				response.write "<td width=100 class=text_black style='FONT-SIZE: 12pt;'>"&objRec("play_number")&"="&objRec("play_amt")&"</td>"
				cntcol=cntcol+1
				if cntcol=6 then
					call GenEmptyCol(cntCol, cntRow)
					cntrow=cntrow+1
					response.write "</tr>"
					cntcol=0
				end if
				objRec.MoveNext
			loop
			if cntrow > 0 then
				call GenEmptyCol(cntCol, cntRow)
			end if
			response.write "</table><br><br>"
			response.write "<center><INPUT TYPE='button' class=button_blue value ='  พิ ม พ์  ' onClick='print_me();'>"
			%>
			&nbsp;<input type="button" value="ย้อนไปหน้าแรก" class=button_blue  onClick="close_me();" style="cursor:hand"></center>
			<%
		end if


sub GenEmptyCol(cntCol, cntRow)
dim i
	for i = 1 to (7 - cntCol)
		if i = (7-cntCol) then
			response.write "<td width=50 class=textbig_blue align=center>" & cntRow& "</td>"
		else
			response.write "<td width=100 class=''>&nbsp;</td>"
		end if
	next 
end sub

%>