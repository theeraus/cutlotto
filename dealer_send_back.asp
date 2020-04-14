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
Dim objRec
dim recCut
dim recNum
Dim strSql
Dim cntApp
dim chkRow
dim strdel
dim strTmp
dim sumall
dim strOpen
dim strOrder
dim stsend
dim ststatus
dim cutid
dim cntBack
dim cntBackAll
dim sumBack
dim refreshtime

dim tud1
dim tud2
dim tud3
dim tud4 
dim tud5
dim tud6
dim tud7
dim tud8

dim i
	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNum = Server.CreateObject ("ADODB.Recordset")
	Set recCut = Server.CreateObject ("ADODB.Recordset")
	if Request("cutid") <> "" then
		Session("p5cutid")=Request("cutid")
	end if

'	tud1=0:tud2=0:tud3=0:tud4=0:tud5=0:tud6=0:tud7=0:tud8=0	
'	if Request("act")="tud" then
'		tud1=cint(Request("txttud1"))
'		tud2=cint(Request("txttud2"))
'		tud3=cint(Request("txttud3"))
'		tud4=cint(Request("txttud4"))
'		tud5=cint(Request("txttud5"))
'		tud6=cint(Request("txttud6"))
'		tud7=cint(Request("txttud7"))
'		tud8=cint(Request("txttud8"))
'	end if
	refreshtime=""
	if Session("stoprefresh") <> "1" then
		refreshtime = Session("refreshtime")
	end If

%>
<HTML>
<HEAD>
<!-- <meta http-equiv="refresh" content="<%=refreshtime%>" /> -->
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script Language="VBScript" >	
	sub cutid_onChange()
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

	function click_stop_refresh(flg) {
		document.all.form1.stoprefresh.value = flg;
		document.all.form1.submit();
	}


	function convert_number(obj){
	var value=obj;
		if(value!=""){							
			return formatnum(value) ;		   
		}
	}	

function gosendtype(tkid,st,sdfrom,formname) {
		document.forms(formname).action='dealer_tudroum_act.asp';
		document.forms(formname).sendtype.value=st;
		document.forms(formname).sendto.value=999;
		document.forms(formname).sendfrom.value=sdfrom;
		document.forms(formname).target="";
		//alert(document.form2.Action);
		document.forms(formname).submit();
}

	function showsendto(formname){
		document.forms(formname).action='dealer_tudroum_send.asp';
		document.forms(formname).sendtype.value="1";
		document.forms(formname).sendto.value="";
		window.open("blank.htm", "_targetA","top=200,left=200,height=180,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
		document.forms(formname).target = "_targetA";
		document.forms(formname).submit();
	}


</Script>
    <style type="text/css">
        .style1
        {
            color: #FFFFFF;
        }
    </style>
</HEAD>
<BODY topmargin=0 leftmargin=0>

<%

	strOpen="เปิดรับแทง"
	strOrder="เรียงเลข"
	if CheckGame(Session("uid"))="OPEN" then strOpen="ปิดรับแทง"

	sumall=0
	strSql = "SELECT cutall_id, cut_seq, dealer_id, game_id FROM tb_cut_all " _
		& "WHERE (dealer_id = "&Session("uid")&") AND (game_id = "&Session("gameid")&")"
	recCut.Open strSql, conn
'	response.write "<FORM name='form1' id='form1' action='dealer_send_back.asp' method=post>"
'	response.write "<INPUT TYPE='hidden' name='stoprefresh' value='0'>"
'	response.write "<TABLE width='95%' align=center class=table_blue>"        	
'	response.write "	<tr class=head_black bgColor=#FFFFCC>"
'	response.write "		<td class=text_blue colspan=2> เลือกการตัดครั้งที่&nbsp;&nbsp;"


'	response.write "<select name=cutid>"
'	response.write "<option></option>"

	if not recCut.eof then 
'		if Session("p5cutid") <> "" then
'			cutid=cint(Session("p5cutid"))			
'		else
'			cutid=cint(recCut("cutall_id"))
'		end if
'	end if
	cntBack=0: cntBackAll=0
	do while not recCut.eof
'		response.write "<option value="&recCut("cutall_id")&" "&">"&recCut("cut_seq")&"</option>"
		call ShowReturnDetail(recCut("cutall_id"))
		recCut.MoveNext
	Loop
	Else
		response.write "ไม่มีเลขคืน"
	end if
	recCut.Close
'	response.write "</select>"
'	response.write "</td>"

%>
<%
'	response.write "</tr></table>"
'	response.write "</form>"
	cutid=0
	if trim(Request("cutid"))<>"" then
		cutid=cint(Request("cutid"))
'	else
'		cutid=cint(Session("p5cutid"))
	end if

	
function ShowReturnDetail(mycutid)	

'	response.write "<FORM name='form2' Action='dealer_send_back_act.asp' METHOD='post'  Target=''>"
	
	strSql = "SELECT     tb_ticket.ticket_id, tb_cut_all.curr_send_to, tb_cut_all.cutall_id, SUM(tb_ticket_number.play_amt - tb_ticket_number.dealer_rec) AS sum_amt " _
		& "FROM         tb_ticket INNER JOIN  tb_cut_all ON tb_ticket.ref_cutall_id = tb_cut_all.cutall_id INNER JOIN  tb_ticket_key ON tb_ticket.ticket_id = tb_ticket_key.ticket_id INNER JOIN  tb_ticket_number ON tb_ticket_key.ticket_key_id = tb_ticket_number.ticket_key_id " _ 
		& "where ref_cutall_id=" & mycutid & " and sum_flag='Y' and send_status in (" & mlnSendOtherDealer & "," & mlnSendOut &") and rec_status in ("&mlnStatusRecPart&","&mlnStatusRecNoRec&") " _
		& "GROUP BY tb_ticket.ticket_id, tb_cut_all.curr_send_to, tb_cut_all.cutall_id " _
		& "order by tb_ticket.ticket_id desc"
'showstr strSql   
	recNum.Open strSql, conn, 3, 1
	if not recNum.Eof then 
		cntBack=cntBack+1
		'recNum.MoveLast
		cntBackAll=recNum.RecordCount
		'recNum.MoveFirst
	else
		recNum.Close
		exit function
	end if
%>
		<form  method="post" name="<%="form" & (cntBack+1)%>"  id="<%="form" & (cntBack+1)%>">
<%

	do while not recNum.eof
		sumBack=0
		'response.write "ticket id ="&recNum("ticket_id")

		if recNum("curr_send_to")=0 then
			stsend="พิมพ์"
		else
			stsend=GetValueFromTable("sc_user", "user_name", "user_id="&recNum("curr_send_to"))
		end if
		ststatus = GetReceiveStatus(GetValueFromTable("tb_ticket", "rec_status", "ticket_id="&recNum("ticket_id")))
%>
	<TABLE width='95%' align=center class=table_red>     
		<tr>					
			<INPUT TYPE=hidden name='tud1' value="">
			<INPUT TYPE=hidden name='tud2' value="">
			<INPUT TYPE=hidden name='tud3' value="">
			<INPUT TYPE=hidden name='tud4' value="">
			<INPUT TYPE=hidden name='tud5' value="">
			<INPUT TYPE=hidden name='tud6' value="">
			<INPUT TYPE=hidden name='tud7' value="">
			<INPUT TYPE=hidden name='tud8' value="">
			<INPUT TYPE=hidden name='sendweb'>
			<INPUT TYPE=hidden name="sendweb2">			
			<INPUT TYPE=hidden name="fromweb">			
			<INPUT TYPE=hidden name="sendfrom">
			<INPUT TYPE=hidden name="sendto">
			<INPUT TYPE=hidden name="sendtype">
			<INPUT TYPE=hidden name="ticketid" value=<%=recNum("ticket_id")%>>
			<td colspan=6 class=textbig_blue align=left>เลขคืนครั้งที่&nbsp;&nbsp;&nbsp;<%=cntBack%>&nbsp;&nbsp;&nbsp;ส่ง<u>&nbsp;&nbsp;&nbsp;<%=stsend%>&nbsp;&nbsp;&nbsp;</u>สถานะ<u>&nbsp;&nbsp;&nbsp;<%=ststatus%>&nbsp;&nbsp;&nbsp;</u></td>
			<td colspan=2 class=textbig_blue align=right><INPUT TYPE="button" name="actsend" value="ส่งเจ้ามืออื่น" class="inputE" style="cursor:hand;width:80;"  onClick="showsendto('<%="form" & (cntBack+1)%>')">&nbsp;&nbsp;<INPUT TYPE="button" name="actprint" value="พิมพ์ออก" class="inputR" style="cursor:hand;width:80;" onClick="gosendtype('<%=recNum("ticket_id")%>','2','<%=Session("uid")%>','<%="form" & (cntBack+1)%>')"></td>
		</tr>	
	</Table>
	<TABLE width='95%' align=center class=table_red>   
		<tr class=textbig_blue>
			<td colspan=8 height=20 align=center>จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<%=formatnumber(recNum("sum_amt"),0)%></span> </td>
		</tr>	
		<tr align=center  bgColor=red >
			<td width="13%" class="style1"><strong>2 บน</strong></td>
			<td width="12%" class="style1"><strong>3 บน</strong></td>
			<td width="13%" class="style1"><strong>3 โต๊ด</strong></td>
			<td width="12%" class="style1"><strong>2 โต๊ด</strong></td>
			<td width="13%" class="style1"><strong>วิ่งบน</strong></td>
			<td width="12%" class="style1"><strong>วิ่งล่าง</strong></td>
			<td width="13%" class="style1"><strong>2 ล่าง</strong></td>
			<td width="12%" class="style1"><strong>3 ล่าง</strong></td>
		</tr>
		<tr>
			<td valign=top><!-- เลข 2 บน -->
				<%
					dim pAmt
					dim tmpClass
					strSql = "exec spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType2Up
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0						

'						pAmt = objRec("sum_money")
						pAmt = clng(objRec("ret_money"))
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt2up' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='2upcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 2 บน -->
			<td valign=top bgColor='#FFFF99'><!-- เลข 3 บน -->
				<%
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType3Up
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = clng(objRec("ret_money"))
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt3up' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='3upcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 3 บน -->
			<td valign=top><!-- เลข 3 โต๊ด -->
				<%
'					strSql = "SELECT     game_id, dealer_id, number_status, play_number, play_amt, (play_amt-dealer_rec) AS sum_money, player_id " _
'						& "FROM vTicketToNumber " _
'						& "WHERE (play_type = " & mlnPlayType3Tod & ") AND (vTicketToNumber.ticket_id = " & recNum("ticket_id") & ") and (sum_flag='Y') " _						
'						& "and (vTicketToNumber.number_status in ("&cint(mlnNumStatusNoRec)&","&cint(mlnNumStatusRecPart)&")) " _
'						& "ORDER BY (play_amt-dealer_rec) desc"
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType3Tod
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = clng(objRec("ret_money"))
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt3tod' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='3todcuttype' value="2">
<%					
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 3 โต๊ด -->
			<td valign=top bgColor='#FFFF99'><!-- เลข 2 โต๊ด -->
				<%
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType2Tod
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = objRec("ret_money")
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt2tod' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt2todmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='2todcuttype' value="2">
<%					
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 2 โต๊ด -->
			<td valign=top><!-- เลข วิ่งบน -->
				<%

					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayTypeRunUp
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = objRec("ret_money")
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt1up' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt1upmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='1upcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลขวิ่งบน -->
			<td valign=top bgColor='#FFFF99'><!-- เลข วิ่งล่าง -->
				<%
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayTypeRunDown
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = objRec("ret_money")
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt1down' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt1downmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='1downcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลขวิ่งล่าง -->				
			<td valign=top><!-- เลข 2 ล่าง -->
				<%
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType2Down
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = objRec("ret_money")
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt2down' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt2downmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='2downcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 2 ล่าง -->
			<td valign=top bgColor='#FFFF99'><!-- เลข 3 ล่าง -->
				<%
					strSql = "spA_Get_tb_ticket_key_by_ticket_id_Ret " & recNum("ticket_id") & ", " & mlnPlayType3Down
					set objRec = conn.Execute(strSql)
					If Not objRec.Eof Then
%>
					<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
<%					
					do while not objRec.eof
						pAmt=0
'						pAmt = objRec("sum_money")
						pAmt = objRec("ret_money")
						sumBack=sumBack+pamt
'						if objRec("number_status")=4 then pAmt = objRec("play_amt")
						if clng(objRec("dealer_rec"))=0 then pAmt = objRec("key_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("key_number")&"="&pAmt&"</td></tr>"
%>
<INPUT TYPE=hidden name='txt3down' value="<%=objRec("key_number")%>">
<INPUT TYPE=hidden name='txt3downmoney' value="<%=pAmt%>">
<INPUT TYPE=hidden name='3downcuttype' value="2">
<%
						objRec.movenext
					loop
					objRec.close
	
				%>
				</table>
<%
					End If 
%>
			</td><!-- จบเลข 3 ล่าง -->
		</tr>

	</table>	
	<br><br>

<%
		'Response.write "<Script Language='JavaScript'>setsum("&cntBack&","&sumBack&");</Script>" & vbCrlf
		cntBackAll=cntBackAll-1
		recNum.MoveNext
	loop
	recNum.Close
%>
	</FORM>
<%
	end function
%>	
</BODY>
</HTML>
<%
	set objRec = nothing
	set conn   = nothing	
%>	