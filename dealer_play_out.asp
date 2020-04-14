<!--#include virtual="masterpage.asp"-->

<%

dim objRec
dim recNum
dim strSql
dim stsend
dim ststatus
dim sumout

	
dim strOpen
dim strOrder
dim cntRow
dim pAmt
dim tmpClass
dim tmpColColor
Dim CntTicket
tmpColColor="#99FFFF" 

%>
<% Sub ContentPlaceHolder() %>

<%

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNum = Server.CreateObject ("ADODB.Recordset")

	strOpen="เปิดรับแทง"
	strOrder="เรียงเลข"
	if CheckGame(Session("uid"))="OPEN" then strOpen="ปิดรับแทง"

'	if Session("gameid") > 0 then
'		strSql = "spDeleteCutAllNoComplete("&Session("gameid")&")"
'		comm.CommandText = strSql
'		comm.CommandType = adCmdStoredProc
'		comm.Execute
'	end if

%>

<script Language="VBScript" >	
	sub cmborder_onChange()
		form1.submit()
	end sub

	sub cmbnumtype_onChange()
		form1.submit()
	end sub

	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>
<Script Language=JavaScript>
//var arrSum1 = new Array();

//	function setsum(cnt,valsum) {
//		arrSum1[cnt]=valsum;
//	}

//	function showsumcut() {
//	var i

//		for (i=1;i <= arrSum1.length;i++) {
		//			alert(document.all.sumbackshow[i].value);
//			if (i==1) {document.all.sumbackshow1.innerText=convert_number(arrSum1[i]);	}
//			if (i==2) {document.all.sumbackshow2.innerText=convert_number(arrSum1[i]);	}
//			if (i==3) {document.all.sumbackshow3.innerText=convert_number(arrSum1[i]);	}
//			if (i==4) {document.all.sumbackshow4.innerText=convert_number(arrSum1[i]);	}
//			if (i==5) {document.all.sumbackshow5.innerText=convert_number(arrSum1[i]);	}
//			if (i==6) {document.all.sumbackshow6.innerText=convert_number(arrSum1[i]);	}
//			if (i==7) {document.all.sumbackshow7.innerText=convert_number(arrSum1[i]);	}
//			if (i==8) {document.all.sumbackshow8.innerText=convert_number(arrSum1[i]);	}
//			if (i==9) {document.all.sumbackshow9.innerText=convert_number(arrSum1[i]);	}
//			if (i==10) {document.all.sumbackshow10.innerText=convert_number(arrSum1[i]);	}
//		}
//	}

	function convert_number(obj){
	var value=obj;
		if(value!=""){							
			return formatnum(value) ;		   
		}
	}	

function gosendtype(tkid,st,sdfrom) {
//	document.form2.sendfrom.value=sdfrom;
//	document.form2.ticketid.value=tkid;
//	document.form2.sendtype.value=st;
//	document.form2.submit();
	NewWindowOpen('dealer_tudroum_print.asp?ticketid='+tkid+'&cutallid=&resend=Y')
}

function showsendto(cutall_id, tkid){
	window.open("dealer_tudroum_send.asp?cutallid="+cutall_id+"&tkid="+tkid+"&sendtype=1&resend=Y", "_blank","top=200,left=200,height=180,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
}
//เปลี่ยนจากส่งแต่ cutall_id เป็นส่ง ticket id ด้วย เพื่อให้แยกใบ

</Script>
		


	<TABLE width='95%' align=center class=table_red>        	
<%

		strSql = "select count(a.ticket_id) as cnt " _
		& " From (SELECT tb_ticket.ticket_id " _
		& " FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id  " _
		& " INNER JOIN tb_ticket INNER JOIN tb_open_game ON tb_ticket.game_id = tb_open_game.game_id ON tb_ticket_key.ticket_id = tb_ticket.ticket_id  " _
		& " Where tb_ticket_number.sum_flag='Y'  " _
		& " GROUP BY tb_ticket.ref_cutall_id,tb_open_game.dealer_id, tb_ticket.ticket_id, tb_ticket.ref_game_id,  " _
		& " tb_ticket.rec_status, tb_ticket.send_status HAVING (tb_ticket.ref_game_id =  "&Session("gameid")&")) as a "
		recNum.Open strSql, conn
		if not recNum.eof Then
			CntTicket = recNum("cnt")
		End If 
		recNum.Close

		cntRow = 0
		'strSql = "Select * From tb_cut_all where game_id="&Session("gameid")&" and dealer_id="&Session("uid")&" order by cut_seq desc"
		strSql = "SELECT    tb_ticket.ref_cutall_id,  tb_ticket.ticket_id, tb_open_game.dealer_id AS curr_send_to, tb_ticket.ref_game_id, tb_ticket.rec_status, SUM(tb_ticket_number.play_amt)  AS sum_play, tb_ticket.send_status " _
			& "FROM         tb_ticket_key INNER JOIN  tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id INNER JOIN tb_ticket INNER JOIN  tb_open_game ON tb_ticket.game_id = tb_open_game.game_id ON tb_ticket_key.ticket_id = tb_ticket.ticket_id " _
			& "Where tb_ticket_number.sum_flag='Y' " _
			& "GROUP BY tb_ticket.ref_cutall_id,tb_open_game.dealer_id, tb_ticket.ticket_id, tb_ticket.ref_game_id, tb_ticket.rec_status, tb_ticket.send_status " _
			& "HAVING      (tb_ticket.ref_game_id = "&Session("gameid")&") ORDER BY tb_ticket.ticket_id desc"
		recNum.Open strSql, conn
		if not recNum.eof then
			do while not recNum.eof
				cntRow = cntRow +1
				sumout = 0
%>	
		<tr class=textbig_blue>
			<td colspan=8 height=20  align=center>จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<%=formatnumber(recNum("sum_play"),2) %>  </td>
		</tr>
		<tr class=textbig_blue>
			<td colspan=8 height=20  align=center bgcolor="#282828">&nbsp;</td>
		</tr>
		<tr align=center  bgColor=#66CCFF  class=head_white>
			<td bgColor=green><font color="yellow">2 บน</font></td>
			<td bgColor=red>3 บน</td>
			<td bgColor=green><font color="yellow">3 โต๊ด</font></td>
			<td bgColor=red>2 โต๊ด</td>
			<td bgColor=green><font color="yellow">วิ่งบน</font></td>
			<td bgColor=red>วิ่งล่าง</td>
			<td bgColor=green><font color="yellow">2 ล่าง</font></td>
			<td bgColor=red>3 ล่าง</td>
		</tr>
		<tr>
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType2Up & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&") and tb_ticket_number.sum_flag='Y'  AND (tb_ticket_number.play_type = N'" & mlnPlayType2Up & "') and play_amt > 0"
					objRec.Open strSql, conn
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 บน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType3Up & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayType3Up & "') and play_amt > 0"

					objRec.Open strSql, conn
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 3 บน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%					
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType3Tod & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayType3Tod & "') and play_amt > 0"
					objRec.Open strSql, conn
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 3 โต๊ด -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType2Tod & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayType2Tod & "') and play_amt > 0"

					objRec.Open strSql, conn
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 โต๊ด -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งบน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayTypeRunUp & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayTypeRunUp & "') and play_amt > 0"

					objRec.Open strSql, conn
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
%>
				</table>
			</td><!-- จบเลขวิ่งบน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayTypeRunDown & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayTypeRunDown & "') and play_amt > 0"

					objRec.Open strSql, conn

					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลขวิ่งล่าง -->				
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType2Down & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayType2Down & "') and play_amt > 0"

					objRec.Open strSql, conn					
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 ล่าง -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
'					strSql = "SELECT     tb_cut_all_det.*, tb_cut_all.game_id, tb_cut_all.cut_seq, tb_cut_all.curr_send_to, tb_cut_all_det.cutall_id " _
'						& "FROM         tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'						& "WHERE     (tb_cut_all_det.cutall_id = "&recNum("cutall_id")&"  AND (tb_cut_all_det.play_type = " & mlnPlayType3Down & "))"
					strSql = "SELECT     tb_ticket_number.* " _
						& "FROM tb_ticket_key INNER JOIN tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _
						& "WHERE     (tb_ticket_key.ticket_id = "&recNum("ticket_id")&")  and tb_ticket_number.sum_flag='Y' AND (tb_ticket_number.play_type = N'" & mlnPlayType3Down & "') and play_amt > 0"

					objRec.Open strSql, conn	
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("play_amt")
						sumout = sumout + pAmt
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
	
				%>
				</table>
			</td><!-- จบเลข 3 ล่าง -->
		</tr>
		<tr>
<%
			if recNum("curr_send_to")=999 then
				stsend="พิมพ์"
			else
				stsend=GetValueFromTable("sc_user", "user_name", "user_id="&recNum("curr_send_to"))
			end if
			ststatus = GetReceiveStatus(recNum("rec_status"))
			if ststatus = "รับหมด" then 
				if GetValueFromTable("sc_user", "user_type", "user_id="&recNum("curr_send_to")) = "W" then
					ststatus = "โทรเช็คปลายทาง"
				end if
			end if

%>
			<td colspan=3 bgColor=#E2E2E2 class=textbig_blue>ครั้งที่<U>&nbsp;&nbsp;&nbsp;<%=CntTicket%>&nbsp;&nbsp;&nbsp;</U>ส่ง<U>&nbsp;&nbsp;&nbsp;<%=stsend%>&nbsp;&nbsp;&nbsp;</U> </td>
			<td colspan=3 bgColor=#FFFFCC class=textbig_blue align=center>สถานะ&nbsp;&nbsp;&nbsp;<%=ststatus%></td>
			<td colspan=2 align=center><INPUT TYPE="button" name="action" value="ส่งใหม่" class=inputP  style="cursor:hand; width: 75px;" onClick=showsendto("<%=recNum("ref_cutall_id")%>","<%=recNum("ticket_id")%>")>&nbsp;&nbsp;<INPUT TYPE="button" name="action" value="พิมพ์ใหม่" class=inputR  style="cursor:hand; width: 75px;" onClick=gosendtype("<%=recNum("ticket_id")%>","2","<%=Session("uid")%>")></td>
			<!-- เปลี่ยนจาก cut all id เป็น ticket id เพื่อให้แยกใบ -->
		</tr>
		<tr>
			<td colspan=8 height=20><hr width="100%"></td>
		</tr>
<%
				'Response.write "<Script Language='JavaScript'>setsum("&cntRow&","&sumout&");</Script>" & vbCrlf
				recNum.MoveNext
				CntTicket = CntTicket - 1
			loop
		end if
%>
	</Table>

	<FORM name=form2 action='dealer_send_back_act.asp' method=post>
			<input type=hidden name="sendfrom">
			<input type=hidden name="sendto">
			<input type=hidden name="sendtype">
			<input type=hidden name="ticketid"> 
			<input type=hidden name="sendweb">			
			<input type=hidden name="sendweb2">			
			<input type=hidden name="resend">			
			<input type=hidden name="cutallid">			
	</Form>

<% End Sub%>



