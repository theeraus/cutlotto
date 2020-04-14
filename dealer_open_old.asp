<!--#include virtual="masterpage.asp"-->


<%
Dim objRec
dim recPlayer
dim recNum
Dim strSql
Dim cntApp
dim playnum
dim playtype
dim gameid
dim sumplay	
dim sumcut
dim numtype
	'*** Open the database.	

%>

<% Sub ContentPlaceHolder() %>

<% 
	call CheckGame(Session("uid"))
	gameid=Session("gameid")
	Set objRec = Server.CreateObject ("ADODB.Recordset")

	if Request("act") = "del" then
		strSql = "Delete From tb_save_game where save_id = " & Request("delid")
		comm.CommandText = StrSql
		comm.CommandType = adCmdText
		comm.Execute

	end if
%>

<script language="JavaScript" >
	function deletedata(delid) {
		if (confirm("คุณจะไม่สามารถย้อนกลับมาดูข้อมูลนี้ได้อีก ยืนยันการลบข้อมูลนี้ !!!")) {
				document.all.form1.act.value = "del";
				document.all.form1.delid.value = delid;
				document.all.form1.submit();
				return true;
		}
	}
</script>

<form name="form1" method="post" action="dealer_open_old.asp">
<input type="hidden" name="act" value="">
<input type="hidden" name="delid" value="">

<table align="center" cellpadding="0" cellspacing="1" width="100%" border="0" bgcolor=#ffffff>
	<tr class=head_black height=30>
		<td colspan=5 align=center><font size=3>เปิดข้อมูลที่เก็บ</font></td>
	</tr>
</table>
<table align="center" cellpadding="0" cellspacing="1" width="100%" border="0" bgcolor=#ffffff class="table_red" >
	<tr bgcolor="#ff7777" class=head_black height=20>
		<td bgColor=#ff7777 align=center>#</td>
		<td bgColor=#ff7777 align=center>วันที่บันทึก</td>
		<td bgColor=#ff7777 align=center>ชื่อที่บันทึก</td>
		<td bgColor=#ff7777 align=center>&nbsp;</td>
	</tr>
<%

		strSql = "Select * From tb_save_game Where dealer_id = " & Session("uid") & " Order by save_date desc"
		objRec.Open strSql, conn, 3, 1
		if not objRec.eof then
			cntApp = 0 
			do while not objRec.eof
				cntApp = cntApp + 1
				response.write "<tr class=text_blue>"
				response.write "<td align=center style='cursor:hand' onClick=""" & "NewWindowOpen('dealer_view_old.asp?saveid=" & objRec("save_id") & "')"">" & cntApp & "</td>"
				response.write "<td align=center style='cursor:hand' onClick=""" & "NewWindowOpen('dealer_view_old.asp?saveid=" & objRec("save_id") & "')"">" & formatdatetime(objRec("save_date"), 2) & "</td>"
				response.write "<td style='cursor:hand'						  onClick=""" & "NewWindowOpen('dealer_view_old.asp?saveid=" & objRec("save_id") & "')"">&nbsp;"&objRec("save_name")&"</td>"
				response.write "<td align=center><input type='button' class='inputR' name='del' value='ลบที่บันทึก' style='cursor:hand; width: 90px;' onClick='deletedata(" & objRec("save_id") & ");' ></td>"
				response.write "</tr>"
				objRec.MoveNext
			Loop

		end if
%>
	</table>
</form>

<% End Sub %>
