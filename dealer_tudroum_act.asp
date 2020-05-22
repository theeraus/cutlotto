<!-- <FRAMESET ROWS="," COLS=",">
 	<FRAME SRC="" NAME="">
 	<FRAME SRC="" NAME="">
 </FRAMESET> -->
<%@ Language=VBScript CodePage = 65001  %>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->

<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<%Response.Buffer = True%>
<%
dim objRec
dim strSql
dim i
dim chkTud
dim cutSeq
dim cutallid
dim ticketid
dim sumall 
dim sendtype
dim sendto
dim sendweb
dim sendfrom

dim arrNum
dim arrMoney
dim arrCuttype
dim userchkgame
dim gamesendto
	'*** Open the database.	
		Set objRec = Server.CreateObject ("ADODB.Recordset")

		sendfrom=Request("sendfrom")
		if Request("sendtype")="2" then
			sendto = userPrintID
			userchkgame = Session("uid")
			call CheckGame(userchkgame)
			gamesendto = Session("gameid")
			call CheckGame(sendfrom)  ' �׹��� game id �ͧ�����ͻѨ�غѹ
			cutSeq=GenMaxID("tb_cut_all", "cut_seq", "game_id="&gamesendto&" and dealer_id="&userchkgame)
		elseif Request("sendweb2") <> "" and Request("sendweb")="" then
		'�ó���͹��Ѻ�Ҩҡ web 2 ������Ҥ�ҡ�Ѻ�Һѹ�֡��� web 1
			sendto = Session("user_send_toweb")   'userWebID   '��Ǻ͡��� ��价���è����
			sendfrom  = Session("uid")
			call CheckGame(sendfrom)  ' �׹��� game id �ͧ�����ͻѨ�غѹ
			gamesendto = Session("gameid")
			cutSeq=GenMaxID("tb_cut_all", "cut_seq", "game_id="&gamesendto&" and dealer_id="&sendfrom)
		elseif Request("sendweb")<>"" then
			'�ó��� ���� web �ӷ�� web 2
			sendto = Request("sendto")
			userchkgame = sendto
			call CheckGame(sendto)  ' get ��� game id �ͧ �����ͷ�����件֧
			gamesendto = Session("gameid")
			call CheckGame(Session("uid"))  ' �׹��� game id �ͧ�����ͻѨ�غѹ
			cutSeq=GenMaxID("tb_cut_all", "cut_seq", "game_id="&gamesendto&" and dealer_id="&userchkgame)
		else
			sendto = Request("sendto")
			call CheckGame(Session("uid"))  ' �׹��� game id �ͧ�����ͻѨ�غѹ
			gamesendto = Session("gameid")
			userchkgame = Session("uid")
			cutSeq=GenMaxID("tb_cut_all", "cut_seq", "game_id="&gamesendto&" and dealer_id="&userchkgame)
		end if	
		sendweb = Request("sendweb")
		chkTud=false
		If Request("resend")="Y" Then '�ó��繡�������
			sendfrom=Request("sendfrom")  'send to dealer
			sendto = Request("sendto")			' send to player
			cutallid = Request("cutallid")
			sendtype=Request("sendtype")			
			ticketid = Request("tkid")
			strSql = "spCutAllToTicket_Resend(" & cutallid & ", '"& sendtype &"', "& sendto &", " & sendfrom & ", " & Session("gameid") & ", " & ticketid & ")"
'showstr strSql			
			comm.CommandText = strSql
			comm.CommandType = adCmdStoredProc
			comm.Execute

		Else

			'============  ��Ѻ�Ţ�óշ������麹 ===============  26/10/52
			'����Ѻ�Ţ�¡�� �ӹǹ�Թ�����������Ţ * �ӹǹ����  / ���¨ӹǹᷧ�͡
			'get ��� �ӹǹ���� ��� �ӹǹᷧ�͡

			' *** ����ͧ�ӹǹ �ӹǹ���� ��� ᷧ�͡���� ���ͧ�ҡ �ӹǳ�����������ͧ����ҡ�� ��ͧ ������������� 8/2/53 anon


'			If Request("fromFgUp")="yes" Then		
'				Dim  rsPricePO
'				Dim pay2up, pay3up, pay3tod, pay2tod, pay1up
'				Dim out2up, out3up, out3tod, out2tod, out1up
'
'				strSql = "exec spA_Get_PriceDealer_Pay_Out " & Session("gameid") & "," & Session("uid")  
'				set rsPricePO = conn.execute(strSql,,1)
'				if not rsPricePO.Eof then
'					pay2up=trim(rsPricePO("pay2up"))
'					pay3up=trim(rsPricePO("pay3up"))
'					pay3tod=trim(rsPricePO("pay3tod"))
'					pay2tod=trim(rsPricePO("pay2tod"))
'					pay1up=trim(rsPricePO("pay1up"))
'					out2up=trim(rsPricePO("out2up"))
'					out3up=trim(rsPricePO("out3up"))
'					out3tod=trim(rsPricePO("out3tod"))
'					out2tod=trim(rsPricePO("out2tod"))
'					out1up=trim(rsPricePO("out1up"))
'				End If 
'			End If
			'============  ��Ѻ�Ţ�óշ������麹 ===============  26/10/52

				strSql = "Insert Into tb_cut_all (game_id, cut_date, dealer_id, cut_seq, curr_send_to) values "	_
					& "("&gamesendto&", GetDate(), "&Session("uid")&", "&cutSeq&", "& sendto &")"
				comm.CommandText = StrSql
				comm.CommandType = adCmdText
				comm.Execute

				cutallid=GenMaxID("tb_cut_all", "cutall_id","")-1
				'2up
				arrNum=split(Request("txt2up"),",")
				arrMoney=split(Request("txt2upmoney"),",")
				arrCuttype=split(Request("2upcuttype"),",")
				Dim TudAmt
				If Request("tud1") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud1")
				End if
				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 Then
			' *** ����ͧ�ӹǹ �ӹǹ���� ��� ᷧ�͡���� ���ͧ�ҡ �ӹǳ�����������ͧ����ҡ�� ��ͧ ������������� 8/2/53 anon
'						If Request("fromFgUp")="yes" Then		
'							If pay2up > 0 And out2up > 0 Then 
'								arrMoney(i)=Round(((arrMoney(i) * pay2up) / out2up),0)
'							End If
'						End If 
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType2Up&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
		'showstr "sql  : " & strSql
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next

				'3up
				arrNum=split(Request("txt3up"),",")
				arrMoney=split(Request("txt3upmoney"),",")
				arrCuttype=split(Request("3upcuttype"),",")
				If Request("tud2") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud2")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 Then
			' *** ����ͧ�ӹǹ �ӹǹ���� ��� ᷧ�͡���� ���ͧ�ҡ �ӹǳ�����������ͧ����ҡ�� ��ͧ ������������� 8/2/53 anon
'						If Request("fromFgUp")="yes" Then		
'							If pay3up > 0 And out3up > 0 Then 
'								arrMoney(i)=Round(((arrMoney(i) * pay3up) / out3up),0)
'							End If
'						End If 					
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType3Up&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'3tod
				arrNum=split(Request("txt3tod"),",")
				arrMoney=split(Request("txt3todmoney"),",")
				arrCuttype=split(Request("3todcuttype"),",")
				If Request("tud3") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud3")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 Then
			' *** ����ͧ�ӹǹ �ӹǹ���� ��� ᷧ�͡���� ���ͧ�ҡ �ӹǳ�����������ͧ����ҡ�� ��ͧ ������������� 8/2/53 anon
'						If Request("fromFgUp")="yes" Then		
'							If pay3tod > 0 And out3tod > 0 Then 
'								arrMoney(i)=Round(((arrMoney(i) * pay3tod) / out3tod),0)
'							End If
'						End If 					
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType3Tod&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'2tod
				arrNum=split(Request("txt2tod"),",")
				arrMoney=split(Request("txt2todmoney"),",")
				arrCuttype=split(Request("2todcuttype"),",")
				If Request("tud4") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud4")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 then
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType2Tod&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'1up
				arrNum=split(Request("txt1up"),",")
				arrMoney=split(Request("txt1upmoney"),",")
				arrCuttype=split(Request("1upcuttype"),",")
				If Request("tud5") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud5")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 Then
			' *** ����ͧ�ӹǹ �ӹǹ���� ��� ᷧ�͡���� ���ͧ�ҡ �ӹǳ�����������ͧ����ҡ�� ��ͧ ������������� 8/2/53 anon
'						If Request("fromFgUp")="yes" Then		
'							If pay1up > 0 And out1up > 0 Then 
'								arrMoney(i)=Round(((arrMoney(i) * pay1up) / out1up),0)
'							End If
'						End If 					
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayTypeRunUp&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'1down
				arrNum=split(Request("txt1down"),",")
				arrMoney=split(Request("txt1downmoney"),",")
				arrCuttype=split(Request("1downcuttype"),",")
				If Request("tud6") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud6")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 then
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayTypeRunDown&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'2down
				arrNum=split(Request("txt2down"),",")
				arrMoney=split(Request("txt2downmoney"),",")
				arrCuttype=split(Request("2downcuttype"),",")
				If Request("tud7") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud7")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 then
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType2Down&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next
				'3down
				'showstr "3 up  "  &Request("txt3down")
				arrNum=split(Request("txt3down"),",")
				arrMoney=split(Request("txt3downmoney"),",")
				arrCuttype=split(Request("3downcuttype"),",")
				If Request("tud8") = "" Then
					TudAmt = 0
				else
					TudAmt = Request("tud8")
				End if

				for i = 0 to Ubound(arrNum)
					if len(trim(arrNum(i)))<>0 then
						chkTud=true
						strSql = "Insert into tb_cut_all_det (cutall_id, play_type, play_number, play_amt, cut_amt, cut_type) values " _				
							& "("&cutallid&", '"&mlnPlayType3Down&"', '"&trim(arrNum(i))&"', "&arrMoney(i)&", "&TudAmt&", "&arrCuttype(i)&")"
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute
					else
						exit for
					end if
				next

				if Not chkTud then
					if trim(cutallid) <> "" then  
						strSql = "Delete from tb_cut_all where cutall_id=" & cutallid
						comm.CommandText = StrSql
						comm.CommandType = adCmdText
						comm.Execute			
					end if
				end if
				sendtype=Request("sendtype")

		'response.write "spCutAllToTicket(" & cutallid & ", '"& sendtype &"', "& Session("uid") &")"
		'response.end
		'showstr Request("sendfrom")
				dim atweb2
				atweb2 = ""
				if Request("sendweb2") <> "" and Request("sendweb")="" then
					atweb2 = "no"
				elseif sendweb <> "" then 
					atweb2 = "yes"
				end if
		strSql = "spCutAllToTicket(" & cutallid & ", '"& sendtype &"', "& sendfrom &", '" & atweb2 & "','" & Session("cutperctype") & "', " & Session("cutperc") & ")"
		comm.CommandText = strSql
		comm.CommandType = adCmdStoredProc
		comm.Execute
	
	End If   ' �ó�������������

	'ticketid = GetValueFromTable("tb_ticket", "ticket_id", "ref_cutall_id=" & cutallid)
	'����¹���� cut all id 
	'ticketid = cutallid
'showstr "spCutAllToTicket(" & cutallid & ", '"& sendtype &"', "& Session("uid") &")"
	if Request("sendtype")="2" then
		Session("cutallid")=cutallid
		Response.write "<script language=JavaScript>NewWindowOpen('dealer_tudroum_print.asp');</script>"	
		Response.write "<script language=JavaScript>NewOpen('dealer_play_out.asp');</script>"	
	elseif Request("sendtype")="1" then
		Session("cutallid")=cutallid
		if sendweb = "" Then
			Response.write "<script language=JavaScript>window.close();</script>"	
			Response.write "<script language=JavaScript>NewOpen('dealer_play_out.asp');</script>"	
		else
'�ó��觢������ ����觢����ŷ�������Ѻ������ tb_ticket ������  1 
%>
		<FORM id=FORM2 name=FORM2 action="<%=Request("fromweb")%>dealer_tudroum_act.asp" method=post>
		<INPUT TYPE=hidden name='tud1' value="<%=Request("tud1")%>">
		<INPUT TYPE=hidden name='tud2' value="<%=Request("tud2")%>">
		<INPUT TYPE=hidden name='tud3' value="<%=Request("tud3")%>">
		<INPUT TYPE=hidden name='tud4' value="<%=Request("tud4")%>">
		<INPUT TYPE=hidden name='tud5' value="<%=Request("tud5")%>">
		<INPUT TYPE=hidden name='tud6' value="<%=Request("tud6")%>">
		<INPUT TYPE=hidden name='tud7' value="<%=Request("tud7")%>">
		<INPUT TYPE=hidden name='tud8' value="<%=Request("tud8")%>">
		<INPUT TYPE=hidden name='txt2up' value="<%=Request("txt2up")%>">
		<INPUT TYPE=hidden name='txt2upmoney' value="<%=Request("txt2upmoney")%>">
		<INPUT TYPE=hidden name='2upcuttype' value="<%=Request("2upcuttype")%>">
		<INPUT TYPE=hidden name='txt3up' value="<%=Request("txt3up")%>">
		<INPUT TYPE=hidden name='txt3upmoney' value="<%=Request("txt3upmoney")%>">
		<INPUT TYPE=hidden name='3upcuttype' value="<%=Request("3upcuttype")%>">
		<INPUT TYPE=hidden name='txt3tod' value="<%=Request("txt3tod")%>">
		<INPUT TYPE=hidden name='txt3todmoney' value="<%=Request("txt3todmoney")%>">
		<INPUT TYPE=hidden name='3todcuttype' value="<%=Request("3todcuttype")%>">
		<INPUT TYPE=hidden name='txt2tod' value="<%=Request("txt2tod")%>">
		<INPUT TYPE=hidden name='txt2todmoney' value="<%=Request("txt2todmoney")%>">
		<INPUT TYPE=hidden name='2todcuttype' value="<%=Request("2todcuttype")%>">
		<INPUT TYPE=hidden name='txt1up' value="<%=Request("txt1up")%>">
		<INPUT TYPE=hidden name='txt1upmoney' value="<%=Request("txt1upmoney")%>">
		<INPUT TYPE=hidden name='1upcuttype' value="<%=Request("1upcuttype")%>">
		<INPUT TYPE=hidden name='txt1down' value="<%=Request("txt1down")%>">
		<INPUT TYPE=hidden name='txt1downmoney' value="<%=Request("txt1downmoney")%>">
		<INPUT TYPE=hidden name='1downcuttype' value="<%=Request("1downcuttype")%>">
		<INPUT TYPE=hidden name='txt2down' value="<%=Request("txt2down")%>">
		<INPUT TYPE=hidden name='txt2downmoney' value="<%=Request("txt2downmoney")%>">
		<INPUT TYPE=hidden name='2downcuttype' value="<%=Request("2downcuttype")%>">
		<INPUT TYPE=hidden name='txt3down' value="<%=Request("txt3down")%>">
		<INPUT TYPE=hidden name='txt3downmoney' value="<%=Request("txt3downmoney")%>">
		<INPUT TYPE=hidden name='3downcuttype' value="<%=Request("3downcuttype")%>">

		<INPUT TYPE=hidden name='sendfrom' value="<%=Request("sendfrom")%>">
		<INPUT TYPE=hidden name='sendto' value="<%=Request("sendto")%>">
		<INPUT TYPE=hidden name='sendtype' value="<%=Request("sendtype")%>">			
<%'��˹����  sendweb = ""  �����������Դ���ǹ�ǹ��%>
		<INPUT TYPE=hidden name='sendweb' value="">
		<INPUT TYPE=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
		<INPUT TYPE=hidden name="fromweb" value="<%=Request("fromweb")%>">			
		</FORM>
<%
		'showstr Request("txt2up")

			response.write "<script language='JavaScript'>document.FORM2.submit();</script>"
			'Response.write "<script language=JavaScript>NewOpen('" &Request("sendweb")& "dealer_play_out.asp');</script>"	
		end if
	end if



sub GenEmptyCol(cntCol)
dim i
	for i = 1 to (8 - cntCol)
		response.write "<td width=93 class=text_blue>&nbsp;</td>"
	next 
end sub

%>