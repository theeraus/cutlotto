<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<html>
<head>

<title>����ᷧ�� : ��ᷧ</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<!--#include file="mdlGeneral.asp"-->
<%

	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>
	<!--#include file="activate_time.asp"-->
<%
    Dim var_limit_numbermoney
	Dim save_type
	save_type=request("save_type")
	Dim before_ticket_number
	before_ticket_number=request("before_ticket_number")
	If before_ticket_number="" Then before_ticket_number=0
	Dim Client_IP
	Client_IP=Request.ServerVariables("REMOTE_ADDR") 
	'Response.Write " IP " & Client_IP

	Dim IsTelephone, line_per_page, col_per_page
	IsTelephone=Session("istelephone") 'Request("istelephone")
	if IsTelephone=1 then
		line_per_page=25
		col_per_page=1
	else
		line_per_page=33
		col_per_page=3
	end if

	Dim save,i
	ticket_id=Request("ticket_id")
	save=Request("save")
	game_id=Session("gameid")
	'-- ��ͧ����ҡ�͹��� login ����� grame_id �����Ţ����
	if game_id="" then
		response.redirect "signin.asp"
	end if
	player_id=Session("uid")
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	'---- �礡�͹��� �������Դ�Ѻ������������ ��һԴ �������ö�������
	Dim did, open_game, gif_open_game
	Dim mess ' ����ʴ� 㺷�� ��� jum
	mess=request("mess")

	open_game="open"
	gif_open_game="images/open_game.gif"
	did=Session("did")
	SQL="select * from tb_open_game where game_status=1 and game_id=" & game_id
	set objRS=objDB.Execute(SQL)
	if objRS.eof then
		open_game="close"
		gif_open_game="images/close_game.gif"
		Response.write "<br><br><center><font color='red'>�������ö ������ ���ͧ�ҡ�����ͻԴ�Ѻᷧ���� </font></center>"
		Response.write "<br><br><center>" & ShowBack() & "</center>"
		Response.end
	end If
'=========start ����ǹŴ������ 㹡�äԴ �ôԵ 
%>
	<script language="javascript">
		// ����ǹŴ������ 㹡�äԴ �ôԵ 
		var ar_discount =new Array()		
		var idx=0;
		var idx_limit_number=0;
		var idx_limit_numbermoney = 0;
		var ar_limit =new Array()
		var ar_limit2 =new Array()
		var ar_limitnummoney = new Array()		
	</script>	
    
<%
	SQL="exec spJGetPriceDisc " & player_id & ", " & game_id
	set objRS=objDB.EXecute(SQL)
	while not objRS.eof
		%>
		<script language="javascript">
			ar_discount[idx]='<%=objRS("play_type")%>|<%=objRS("discount_amt")%>'
			idx=parseInt(idx)+1;
		</script>
		<%
		objRS.MoveNext
	wend 
	'========= end ����ǹŴ������ 㹡�äԴ �ôԵ 

	'// �� �ôԵ�٧�ش
	If Len(Trim(Session("logid")))>6 then
		SQL="exec spGetGame_id_by_player_idLevel2 " & player_id
	else
		SQL="exec spGetGame_id_by_player_id " & player_id
	End if
	Dim limit_play, can_play, sum_play
	set objRS=objDB.Execute(SQL)
	if Not objRS.eof Then
		If CDbl(objRS("limit_play"))>0 then
			limit_play=FormatNumber(objRS("limit_play"),0)
		Else
			limit_play=0
		End if
		If CDbl(objRS("sum_play"))>0 then
			sum_play=FormatNumber(objRS("sum_play"),0)
		Else
			sum_play=0
		End If
		If ( CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")) ) > 0 Then
			can_play=FormatNumber(CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")),0)
		Else
			can_play=0
		End if	
	End If
	'== start ��ҹ��Ҩҡ ��á�˹�ᷧ�٧�ش tb_price_player 
	%>
	<script language="javascript">
		// �纨ӹǹ�Թ�٧�ش 
		var ar_maxMoney =new Array()		
		var idx=0;
	</script>	
	<%
	SQL="exec spJChkMaxMoney " & player_id & ", " & game_id
	set objRS=objDB.Execute(SQL)
	While Not  objRS.eof 
		%>
		<script language="javascript">
			ar_maxMoney['<%=objRS("play_type")%>']='<%=objRS("play_type")%>|<%=objRS("maxMoney")%>|<%=objRS("play_desc")%>'
		</script>
		<%
		objRS.MoveNext
	wend
	'== finish 

	if save="save" then	

		'//���ôԵ�ա���� 
		If CDbl(request("de_credit"))>CDbl(Replace(can_play,",","")) Then
			response.write "<b><br><br><br><center>�ôԵ������� " & can_play & " �Թᷧ㺹�� " & request("de_credit") '//�ӹǹ�Թ�ͧ㺹��Ŵ����
			Response.write "<font color='red'> �������ö�ѹ�֡�������ͧ�ҡ�ôԵ��� !!! </font>"
			Response.write "<br><br><center>" & ShowBack() & "</center></b>"
			Response.End
		End if
		'//���ôԵ�ա���� 

		'//jum ��͹�зӡ�úѹ�֡����� game_id ����ء���� 2009-05-26
		dim new_game_id, change_game
		change_game=0
		new_game_id=GetValueFromTable("tb_open_game","game_id","dealer_id=" & did & " and game_active='A' ")
		if new_game_id<>game_id then
			game_id=new_game_id
			Session("gameid")=game_id
			change_game=1
		end if
		'//jum ��͹�зӡ�úѹ�֡����� game_id ����ء���� 2009-05-26

		Dim 	updown_type_col1 , key_number , key_money ,updown_type, key_seq, number_status
		Dim player_id, ticket_number, game_id , rec_status, ticket_id, send_status, key_from, key_id	
		Dim key_number_ok, j
		key_number_ok="no"
		'--- insert into tb_ticket		
		ticket_number=Request("ticket_number") '---Getticket_number(player_id , game_id )
		'//jum ��͹�зӡ�úѹ�֡����� game_id ����ء���� 2009-05-26
		if change_game=1 then
			ticket_number=1	
		end if 	
		'//jum 2006-06-26 ���������价ӷ�� store proc 	ticket_number=CheckTicketNum(player_id,game_id,ticket_number)
		rec_status=0 ' ��
		send_status=1  ' ����������Ңͧ
		key_from=1       ' ᷧ�ҡ com 
		key_id=Session("uid")
		'-- ��ͧ�礡�͹����ա�ä����Ţ��������� 
		for i=1 to line_per_page
			for j=1 to 3
				updown_type=convUpDownType(Request("updown_type_col" & j & i ))
				key_number=Request("key_number_col" & j & i )
				key_money=Request("key_money_col" & j & i )
				if updown_type <>""  and  key_number<>"" and  key_money <>"" then
					key_number_ok="ok"
					exit for
				end if
			next
			if key_number_ok="ok" then
				exit for
			end if
		next
		if key_number_ok="ok" then
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
				SQL="update tb_ticket set ip_address='" & Client_IP & "' where ticket_id=" & ticket_id
				objDB.Execute(SQL)
				key_seq=0
				for i=1 to line_per_page
						updown_type=convUpDownType(Request("updown_type_col1" & i ))
						key_number=Request("key_number_col1" & i )
						key_money=Request("key_money_col1" & i )
						
						number_status=1    '  ��
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
						end If
				Next 
				for i=1 to line_per_page
						'--- ���е���Ţ���ᷧ�е�ͧ save ŧ tb_ticket_number �¡���¡���������ᷧ
						updown_type=convUpDownType(Request("updown_type_col2" & i ))
						key_number=Request("key_number_col2" & i )
						key_money=Request("key_money_col2" & i )
						number_status=1    '  ��
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
						end If
					Next 
					for i=1 to line_per_page		
						updown_type=convUpDownType(Request("updown_type_col3" & i ))
						key_number=Request("key_number_col3" & i )
						key_money=Request("key_money_col3" & i )
						number_status=1    '  ��
						if updown_type <>""  and  key_number<>"" and  key_money <>"" then
							key_seq=key_seq+1
							'--- insert into tb_ticket_key
							SQL="exec spInsert_tb_ticket_key " & _
										ticket_id & ", " & _
										key_seq & "," & _
										updown_type & ", " & _
										"'" & key_number & "', " & _
										"'" & key_money &  "'," & _
										number_status 					
							set objRS=objDB.Execute(SQL)
						end if
				Next
				'-- 2007-07-19 �ӡ�� update tb_ticket rec_status =1 ��ѧ�ҡ���ѹ�֡������ Detail ���º�������� 
				SQL="update tb_ticket set rec_status=1 where ticket_id=" & ticket_id
				set objRS=objDB.Execute(SQL)

				'--- ����� user �������Ѻ���ѵ��ѵ�
				SQL="select * from sc_user where  user_id=" & player_id ' �Ѻ���
				set objRS=objDB.Execute(SQL)
				if not objRS.eof Then
					If CInt(objRS("rec_ticket_type"))=1 Then '���͡�ͧ
						If CInt(objRS("rec_ticket"))=1 then
							SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
							objDB.Execute(SQL)
						End If
					End if				
					'If CInt(objRS("rec_ticket_type"))=2 Then 'ᴧ������					����ͧ������
					'End If 
					If CInt(objRS("rec_ticket_type"))=3 Then '���Ƿ�����
							SQL="exec spUpd_ticket_status_by_ticket_id " & ticket_id
							objDB.Execute(SQL)
					End If 
				end If
				
			end if
		end if
		set objRS=nothing
		set objDB=Nothing
		mess=GetMess_TicketNumber(ticket_id,ticket_number)
		Response.Redirect("key_player.asp?mess=" & mess & "&save_type=" & save_type & "&before_ticket_number=" & ticket_number)	
	end If
	
Function GetMess_TicketNumber(ticket_id, ticket_number)
	'//ticket_number = �����Ţ��� user key ���ç�Ѻ��к� -> �к� gen ���
	Dim objRS , objDB , SQL,new_no
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select * from tb_ticket where ticket_id=" & ticket_id
	set objRS=objDB.Execute(SQL)
	if Not objRs.EOF Then
		new_no=objRs("ticket_number")
		If CStr(new_no)<>CStr(ticket_number) then
			GetMess_TicketNumber ="㺷�� " & ticket_number & " ����к����ҧ����� " & new_no 
		End if
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function CheckTicketNum(p,g,t)
	Dim objRS , objDB , SQL,new_no
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select * from tb_ticket where game_id=" & g 
	SQL=SQL & " and player_id=" & p
	SQL=SQL & " and ticket_number='" & t & "'"
	set objRS=objDB.Execute(SQL)
	if objRs.EOF then
		CheckTicketNum =t
	else
		new_no=Getticket_number(p, g)
		CheckTicketNum=new_no
		mess="㺷�� " & t & " ����к����ҧ����� " & new_no 
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
'response.write SQL
'response.end
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalPlay = objRS("total_play_amt")
	else
		GetTotalPlay=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function convUpDownType(t)
	if t="�" then
		convUpDownType=1
	end if
	if t="�" then
		convUpDownType=2
	end if
	if t="�+�" then
		convUpDownType=3
	end if
End Function
Function Getticket_number( p, g, save_type, before_ticket_number )
	Dim objRS , objDB , SQL, type_number
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	If save_type<>"" Then
		type_number=0
	Else
		type_number=1
	End if
	SQL="exec spGetticket_Key " & p & "," & g & "," & type_number & " ," & before_ticket_number 
'showstr SQL
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	else
		Getticket_number=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function Getticket_numberX( p, g )
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetticket_number " & p & "," & g & ",1"
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	else
		Getticket_number=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GettDealerName(did )
	if did="" then exit function
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select login_id, user_name from sc_user where [user_id]=" & did
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GettDealerName =  rtrim(ltrim(objRS("login_id")))  & " " & objRS("user_name") & "&nbsp;"
	else
		GettDealerName= ""
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>

<link href="include/code.css" rel="stylesheet" type="text/css">
<script src="include/js_function.js" language="javascript"></script>
</head>
<body topmargin="0"  leftmargin="0" onload ="default_up_type_label()">
<iframe name="f_hidden" width="0" height="0"></iframe>
	<form name="form1" action="key_player.asp" method="post">
	<input type="hidden" name="de_credit" value="0">		
	<input type="hidden" name="gbl_cankeynextrow" value="1">		
	<input type="hidden" name="play_discount" value="0">
    <input type="hidden" name="obj_limit_numbermoney" value="<%=var_limit_numbermoney%>">	
	<input type="hidden" name="first_send" value="yes">
	<input type="hidden" name="master_pay_type">
	<input type="hidden" name="where_cursor"  value='c1201'>
	<input type="hidden" name="oldmoney"  value='0'>
	<input type="hidden" name="oldmoney_disc"  value='0'>
	<input type="hidden" name="keep_old_value">
	<input type="hidden" name="save_type">
	<table border="0" width="890" class=table_red  cellpadding="0" cellspacing="0" align="center"><!----  table top Level 1  ---->		
		<tr valign="top">
			<td align="left">
				<table  border="0"  cellpadding="1" cellspacing="0"><!----  table top Level 2 �ҧ����  ---->	
					<tr>
						<td align="right">
							<table width="100%" border=0 cellpadding="1" cellspacing="0" >
								<tr height="22"  bgcolor="#3333FF">									
									<td align="right" class=text_blue  bgColor=#FFFF00 width="100%" cellpadding="1" cellspacing="1">
									<table class=text_blue  bgColor=#FFFFFF>
                                    <tr height="20"><td bgColor="#FFFFFF"><strong><%=GettDealerName(Session("did"))%></strong>
									</td></tr></table>
									</td>
								</tr>
								<tr bgcolor="#FFFFFF">
									<td align="right">
									<%
									'jum 2007-08-21
									Dim pic,game_type
									SQL="exec spGetGame_Type_by_dealer_id " & Session("did")	
									Set objRS=conn.Execute(SQL)
									if not objRS.eof then
										game_type=objRS("game_type")
										select case  CInt(game_type)
										case 1
											pic="images/price_gov.jpg"
										case 2
											pic="images/price_tos.jpg"
										case 3
											pic="images/price_oth.jpg"
										end select
									End If
									objRS.close
									'jum 2007-08-21
									%>
										<img src="<%=pic%>" name="mypic" width="0"  border="0">
									</td>
								</tr>
								<tr>	
									<td class="tdbody" align="right" colspan="18"><b><font color="#CE243E">F7=��й��㺷�� 
									<input type="text" name="ticket_number" style="BACKGROUND-COLOR: yellow;font-weight:bold;color:'#CE243E'; "
										value="<%=Getticket_number(player_id,game_id,save_type,before_ticket_number)%>"
									size="2"  onKeyDown="chkEnterNumber(this);">
									</b></td>
								</tr>
								<tr>
									<td class="tdbody" align="right" nowrap><b>�ʹ㺹��</b></td>
								</tr>
								<tr>							
									<td class="tdbody" align="right" ><b><span id="this_play_amt"></span>
									<!--<font color="blue"><strong> | </strong></font>-->
									<span id="this_play_disc" style="display:none"></span> 
									
									</b></td>
								</tr>
							</table>
							<table  border="0" width="100%"  cellpadding="0" cellspacing="0">
								<tr>
									<td class="tdbody" align="right">��</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetSend(player_id,game_id)%></td>
									<td class="tdbody" align="right">�</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">�Ѻ����</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetReceive(player_id,game_id)%></td>
									<td class="tdbody" align="right">�</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">���Ѻ</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetSend(player_id,game_id) - GetReceive(player_id,game_id)%></td>
									<td class="tdbody" align="right">�</td>
								</tr>
								<tr>
									<td class="tdbody" align="right">�Ţ�׹</td>
									<td class="tdbody" align="right">=</td>
									<td class="tdbody" align="right"><%=GetReturn(player_id,game_id)%></td>
									<td class="tdbody" align="right">�</td>
								</tr>
								<tr bgcolor="#66CCFF">
										<td class="textbig_red" align="right" colspan="4" nowrap
										bgcolor=#66CCFF	>
										<b>�ʹᷧ���</b></td>
								</tr>
								
								<tr  height="20">									
									<td colspan="4" class="tdbody" align="right"><b>
									<%=formatnumber(GetTotalPlay(player_id,game_id),0) %></b>
									
									</td>
								</tr>	
							</table>
						</td>
					</tr>
					<tr>
						<td class="tdbody" align="right"><% Response.Write " ip: " & Client_IP %></td>
					</tr>
					<tr>
						<td align="right">
<input type="button" class="inputR" value="F10=��" style="cursor:hand; width: 75px;" onClick="clicksubmit()"></td>
					</tr>
					<tr>
						<td align="right"><a href="key.html" target="_blank"><input type="button" class="inputE" value="�Ըա�ᷧ��" style="cursor:hand; width: 100px;"></a></td>
					</tr>
					<tr height="20">
						<td><% Call PrintPrice(Session("did"), player_id, game_id,"no","0")%></td>
					</tr>
					<tr>
						<td align="right">
							<b>�ôԵ�٧�ش : <span id="limit_play"></span></b>
						</td>
					</tr>
					<tr>
						<td align="right">
							������� : <span id="can_play"></span>
						</td>
					</tr>
					<tr>
						<td align="right">
							<input type="button" class="inputM" value="���ôԵ�������ǡ�" style="cursor:hand;width: 170px;"
							onClick="window.open('get_creditlimit.asp','f_hidden')">
						</td>
					</tr>
					<!--
					<tr>
						<td align="right">
							<img src="<%=gif_open_game%>">
						</td>
					</tr> -->
					<tr height="20">
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="right">
						<!--<a href="�Ըա�ᷧ��.rtf"><img src="images/help.gif" border="0"></a> -->
						</td>
					</tr>
					
					<tr>						
						<td height="30" align="right"><img src="images/upp.jpg" name="b_updown_type" style="cursor:hand;" onclick="click_updown_type_label()"></td>
					</tr>
					<!--
					<tr>
						<td>
						lotto station
						</td>
					</tr> -->
					
					
					<tr>						
						<td align="center">
                            <TABLE width="170" border="0" cellSpacing=0 cellPadding=0>
				<%
				SQL="exec spJUsedLimitMoney " & player_id
				Set objRS=objDB.Execute(SQL)

				If Not objRs.eof then
				%>
				<!-- ����������ա�����Ţ��� -->
				
				<TR>
					<TD align="center" class="head_red" style="background-color:#FCC;"><font size="+2">�Ţ���</font></TD>
				</TR>
				<TR>
					<TD>
						<TABLE width="100%" border="1" cellSpacing="0" cellPadding="5" align="center" bordercolor="#0066FF">
							<TR>
						        <TD class="head_red" align="center">2 ��</TD>
						        <TD class="head_red" align="center">2 ��ҧ</TD>
						        <TD class="head_red" align="center">3 ��</TD>
						        <TD class="head_red" align="center">3 ��</TD>
							</TR>
							<%
							SQL="exec spJ_GetNumberLimitMoney " & player_id & ", " & game_id
							'response.write SQL
							Set objRS=objDB.Execute(SQL)
							While Not objRS.eof
								%>
									<!-- �红������ java �������礵͹ ���� ����ᷧ�Ţ��� limit ��� -->
									<script language='javascript'>
									    if('<%=objRS("number_up2")%>'!=''){
									        ar_limit[idx_limit_number]='<%="1"%>|<%=objRS("number_up2")%>';idx_limit_number=parseInt(idx_limit_number)+1; }
									    if('<%=objRS("number_down2")%>'!=''){
									        ar_limit[idx_limit_number]='<%="7" %>|<%=objRS("number_down2")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
									    if('<%=objRS("number_up3")%>'!=''){
									        ar_limit[idx_limit_number]='<%="2" %>|<%=objRS("number_up3")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
									    if('<%=objRS("number_tod3")%>'!=''){
									        ar_limit[idx_limit_number]='<%="3" %>|<%=objRS("number_tod3")%>';idx_limit_number=parseInt(idx_limit_number)+1;}
									</script>
									<tr>  
										<td class="head_white" align="center"><font color="blue"><%=objRS("number_up2")%></font></td>
										<td class="head_white" align="center"><font color="red"><%=objRS("number_down2")%></font></td>
										<td class="head_white" align="center"><font color="blue"><%=objRS("number_up3")%></font></td>
										<td class="head_white" align="center"><font color="red"><%=objRS("number_tod3")%></font></td>
									</tr>
								<%
								objRS.MoveNext
							wend

                            var_limit_numbermoney=""

			        SQL="exec spJ_GetMoneyBalanceNumber " & player_id & ", " & game_id
			        'response.write SQL play_type,limit_number,balance_amt
			        Set objRS=objDB.Execute(SQL)
			        While Not objRS.eof
				        If objRS("play_type")<>"" then
					        var_limit_numbermoney=var_limit_numbermoney & "," & objRS("play_type")  & "|" & objRS("limit_number") & "|" & objRS("balance_amt")
				        End If
				%>
					<!-- �红������ java �������礵͹ ���� ����ᷧ�Ţ��� limit ��� -->
					<script language='javascript'>
					    if ('<%=objRS("play_type")%>' != '') {
					        ar_limitnummoney[idx_limit_numbermoney] = '<%=objRS("play_type")%>|<%=objRS("limit_number")%>|<%=objRS("balance_amt")%>'; idx_limit_numbermoney = parseInt(idx_limit_numbermoney) + 1;
					    }
					</script>
				<%
				objRS.MoveNext
			wend

							%>
						</TABLE>
					</TD>
					<!-- ����������ա�����Ţ��� -->
					<%
					End if
					%>
				</TR>
				</TABLE>

			</td>
					</tr>
										
					
				</table> <!----  table top Level 2 �ҧ����  ---->
			</td>
			<td>
				<table border="0"  cellpadding="1" cellspacing="0"><!----  table top Level 2 �ҧ�����㹡�ä�������� ---->
					<%
						i=1
						while i<=line_per_page
					%>
					<tr>
						<td align="center" nowrap style="width:40">
							<input type="hidden" 
							name="updown_type_col1<%=i%>"  id="c11<%=right("00" & i,2)%>">
							<span class="input2" id="signUp1<%=right("00" & i,2)%>" style="width:28"></span>
							<span id="signDw1<%=right("00" & i,2)%>"></span>
						</td>
						<td>
						<input type="text" 
						style="width:45;height:20;"	
						maxLength="4" class="input1" name="key_number_col1<%=i%>" 	onKeyUp="return autoTab(this, 3, event) , pressPlus(this) ;  "  
						onKeyDown="chkEnter(this,1);" id="c12<%=right("00" & i,2)%>" 
						onBlur="iBlur(this)" onClick="click_shwSign('c11',1);" >
						</td>

						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="14" class="input1"  name="key_money_col1<%=i%>"  onKeyDown="chkEnter(this,2);"  
						id="c13<%=right("00" & i,2)%>" onFocus="iBlur(this);" onKeyUp="pressPlus(this)" 
						onBlur="chkSum(this)"  ></td>
						<%
						if IsTelephone=0 then
						%>
						<!------------------- ��������Ѿ������ͧ�ʴ� 2  column ��� ------------------------>
						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="red"></td>
						<input type="hidden" name="updown_type_col2<%=i%>"  id="c21<%=right("00" & i,2)%>" readonly>
						<td align="center" nowrap style="width:27">
							<span class="input2" id="signUp2<%=right("00" & i,2)%>" style="width:27"></span>
							<span id="signDw2<%=right("00" & i,2)%>"></span>
						</td>
						<td><input type="text" 
						style="width:45;height:20;"	
						maxLength="4" class="input1"  name="key_number_col2<%=i%>" onKeyUp="return autoTab(this, 3, event) , pressPlus(this);" onKeyDown="chkEnter(this,1);" id="c22<%=right("00" & i,2)%>" onBlur="iBlur(this)" onClick="click_shwSign('c21',1);"></td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="14" class="input1" name="key_money_col2<%=i%>" onKeyDown="chkEnter(this,2);" 
						id="c23<%=right("00" & i,2)%>" onFocus="iBlur(this)" onKeyUp="pressPlus(this)"
						onBlur="chkSum(this)"  ></td>

						<td width="20">&nbsp;</td>
						<td align="center" bgcolor="red"></td>
						<td align="center" style="width:31" nowrap>
							<input type="hidden" name="updown_type_col3<%=i%>" id="c31<%=right("00" & i,2)%>" >
							<span class="input2" id="signUp3<%=right("00" & i,2)%>" style="width:27;"></span>
							<span id="signDw3<%=right("00" & i,2)%>"></span>
						</td>

						<td><input type="text" 
						style="width:45;height:20;"	
						maxLength="4" class="input1"  name="key_number_col3<%=i%>" onKeyUp="return autoTab(this, 3, event) , pressPlus(this);" onKeyDown="chkEnter(this,1);" id="c32<%=right("00" & i,2)%>" onBlur="iBlur(this)" onclick="click_shwSign('c31',1);"></td>
						<td width="20" align="center" class="tdbody">=</td>
						<td><input type="text" size="15" maxLength="14" class="input1" name="key_money_col3<%=i%>" onKeyDown="chkEnter(this,2);"
						id="c33<%=right("00" & i,2)%>" onFocus="iBlur(this)" onKeyUp="pressPlus(this)" 
						onBlur="chkSum(this)"  ></td>
						<!------------------- ��������Ѿ������ͧ�ʴ� 2  column ��� ------------------------>
						<%
						end if
						%>
						<td class="tdbody" align="center" >
                            <p style="background-color:#ff9999; margin-left:10px; padding:5px; color: #0000FF;"><%=i%></p></td>
						
					</tr>
					<%
							i=i+1
						wend
					%>					
				</table> <!----  table top Level 2 �ҧ�����㹡�ä�������� ---->
			</td>
			
		</tr>
	</table> <!----  table top Level 1  ---->
	<input type="hidden" name="save" value="save">
	</form>
	<%
	If mess<>"" Then
	%>
	<script language="javascript">
		window.open("win_alert.asp?mess=<%=mess%>","f_hidden")
	</script>
	<%
	End If
	%>
</body>
<script language="javascript">
	function pressPlus(o){
		var k=event.keyCode
		if ( k==107  ) {
			o.value=lefty(o.value, parseInt(o.value.length) - 1)
		}
	}
	function lefty (instring, num){
		var outstr=instring.substring(instring, num);
		return (outstr);
	}
	// �礡óշ������ա�á� enter �� mourse �����������¹ box 㹡�ä��� �蹡�Ѻ���䢨ӹǹ�Թ
	function chkSum(obj){
		var gbl_cankeynextrow=document.form1.gbl_cankeynextrow.value;
		if(gbl_cankeynextrow!=1){
			return;
		}
		var k=event.keyCode
		var o=obj;
		var l, c;
		var i=o.id;
		l=i.substring(3,5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ����
		c=lefty(i,2);			  // ���ͧ͢ id ������ enter �� c1 
		//--- �����ӹǹ�Թ�ͧ ���	
		//alert(obj.value);
		
		sum_PlayAmt(o.value,c,l); // �觨ӹǹ�Թ��� ��������� 
	}

	//document.onkeydown = Function ('checkEnter(event.keyCode)');
	function chkEnter(obj,col_enter){
		var k=event.keyCode
		var o=obj
		var i=o.id
		var id, next_obj
		var n , l, m , c, strl , prev , Len
		var onumber,tmpobj
		// c1    1   01    =  �ش��� 1        ��/��ҧ      ��÷Ѵ���     c m n
		//-- �óշ�� user ������ # , + ���繡����Ѻ  � � ���� �+�
		if ( k==107  ) {
			click_updown_type(obj)
		}
		if (k == 13){	
		  if (obj.value.indexOf(' ') >=0){
			alert("�Դ��Ҵ : �Ţᷧ�����ժ�ͧ��ҧ");
			 return;
		   }
			document.form1.gbl_cankeynextrow.value=0;
			document.form1.keep_old_value.value="no";
			//---- ����繡�ä������á����Թ��ͧ������ҧ
			if (i=='c1301'){
				if (o.value=='' ){
					alert('�Դ��Ҵ : ��سҡ�͡�Թᷧ !!!') 
					document.form1.gbl_cankeynextrow.value=0;
					return false
				}
			}
			l=i.substring(3,5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ����
			c=lefty(i,2);			  // ���ͧ͢ id ������ enter �� c1 			
			m=i.substring(2,3); 	
			//---- �礡�ä�������ŷ���ͧ �Ţᷧ��ͧ�繵���Ţ��ҹ�� 
			if (parseInt(m)==2){				
				var chkO=o.value
				if (chkO.indexOf('.') >=0){
					alert('�Դ��Ҵ : ��سҡ�͡�Ţᷧ�繵���Ţ��ҹ�� !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false
				}
				if (o.value=='' ){
					alert('�Դ��Ҵ : ��سҡ�͡�Ţᷧ !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false
				}

				if( isNaN(lefty(o.value,3))){
					alert('�Դ��Ҵ : ��سҡ�͡�Ţᷧ�繵���Ţ��ҹ�� !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false
				}
				id=c+'1'+l
				next_obj = document.getElementById(  id )	
				// �Ţᷧ ��͡ 123* ��  ��Ƿ�� 4 �� * ����ҹ��
				if (o.value.length==4){
					if (o.value.substring(3,4)!="*" && o.value.substring(3,4)!=' ' ){
						alert('�Դ��Ҵ : ��ҵ�ͧ���ᷧ�Ţǧ��� ��ͧ����Ẻ  123*  !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false
					}			
					if (next_obj.value!="�"){
						alert('�Դ��Ҵ : ǧ��� ᷧ��੾�� �� ��ҹ�� !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false
					}
					var n1,n2,n3
					n1=o.value.substring(0,1)
					n2=o.value.substring(1,2)
					n3=o.value.substring(2,3)
					if (n1==n2 && n2==n3 && n1==n3){
						alert('�Դ��Ҵ : �Ţ�ͧ����ͧᷧẺǧ���  !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false
					}
						
				}
				// ���ᷧ �+� ���������Ţ 3 ��� 
				
				//if (next_obj.value=="�+�"){
				//	if (o.value.length>=3){
				//		alert('�Դ��Ҵ : ᷧ �+� ���������Ţᷧ 3 ��ѡ !!!')
				//		return false
				//}
				//} 

				

			}
			//-- ��ͧ����繨ӹǹ�Թᷧ ��ͧ�� ����Ţ * ��ҹ��
			if (parseInt(m)==3){				
				//--- ��ͧ��ѧ�������Ţᷧ�����������Թᷧ����ҹ �������Թᷧ����͹��÷Ѵ�� 
				id = c + 3 + l				
				next_obj = document.getElementById(  id )						
				if (l!="01"){								
					if (next_obj.value=="" ){										
						id = c + 3 + desc1(l)    // desc1 �� fumction ź 1 
						next_obj.value = document.getElementById(  id ).value				
					}
				}else{					
					if (next_obj.value=="" ){
						var ta =parseInt(i.substring(1,2)) -1 ;  // Ŵ 1 �� column ��͹˹�� 
						id="c"+ta+'333'	
						tmpobj = document.getElementById(  id ).value
						next_obj.value =tmpobj 
					}
				}				
				//--- ��ͧ��ѧ�������Ţᷧ�����������Թᷧ����ҹ �������Թᷧ����͹��÷Ѵ�� 

				if ( canKeyNumber(o.value) ){
					// ����� �+� ����ö����ӹǹ�Թᷧ��  71=100/400 �� 100 ��ҧ 400
					id=c+'1'+l
					next_obj = document.getElementById(  id )	
					id=c+'2'+l
					onumber= document.getElementById(  id )	
					// 2007-02-23
					if (next_obj.value=="�+�" ){
						x=o.value
						x2=x.indexOf('*')
						x3=x.indexOf('/')
						if(x2==0){
							alert('�Դ��Ҵ : ��͹�ӹǹ�Թᷧ���١��ͧ !!!')
							document.form1.gbl_cankeynextrow.value=0;
							return false
						}
					}
					if (next_obj.value=="�+�" && onumber.value.length<=3){
						if ( canKeyUPDN(o.value) ){
							alert('�Դ��Ҵ : ��سһ�͹�ӹǹ�Թᷧ�繵���Ţ [0-9] , * ���� / ��ҹ�� !!!')
							document.form1.gbl_cankeynextrow.value=0;
							return false;
						}
					}else{
						alert('�Դ��Ҵ : ��سһ�͹�ӹǹ�Թᷧ�繵���Ţ [0-9] ���� * ��ҹ�� !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false;
					}
				}
				//--- �礵���Ţᷧ�óշ����� �Թᷧ�� 19*900 �е�ͧ�����Ţᷧ�� 1 ��ѡ��ҹ��	
				id= c+'2'+l
				next_obj = document.getElementById(  id )	

				if(next_obj.value.length==4){
					if( isNaN(o.value)){
						alert('�Դ��Ҵ : ǧ��� �Ţᷧ ��ͧ�繵���Ţ��ҹ�� !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false
					}
				}

				if (lefty(o.value,3)=='19*'){
					if (next_obj.value.length>1){
						alert('�Դ��Ҵ : ��سҡ�͡���������١��ͧ \n ��ҵ�ͧ���ᷧ 19 �ҧ��ͧ�����Ţᷧ 1 ��ѡ��ҹ�� !!!')
						document.form1.gbl_cankeynextrow.value=0;
						return false;
					}
				}
				x=o.value
				if (x.substring(x.length-1,x.length)=="*"){
					alert('�Դ��Ҵ : ��سҡ�͡���������١��ͧ \n ��ҵ�ͧ���ᷧ�� ����� *999 ���� 999*999 !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false;
				}
				//����ͧ�ӹǹ�Թ ��������  * 2 ���� 
				if (!canKeyStar(o.value)){
					alert('�Դ��Ҵ :  ��سҡ�͡�ӹǹ�Թᷧ���١��ͧ !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false;
				}
				// �ӹǹ�Թᷧ��ͧ �ҡ���� 0 ������� 8/5/49
				if (o.value<=0){
					alert('�Դ��Ҵ :  ��سҡ�͡�ӹǹ�Թᷧ��ͧ�ҡ���� 0 !!!')
					document.form1.gbl_cankeynextrow.value=0;
					return false;
				}

			}
			
			m=parseInt(m)+1
			if (m>3){ 										
				//------- validate data �ա�ͺ
				var o1=document.getElementById(  c+1+l )
				var o2=document.getElementById(  c+2+l )
				var o3=document.getElementById(  c+3+l )
				if ( ! validate_1(o1,o2,o3)){
					document.form1.gbl_cankeynextrow.value=0;
					return false
				}
				//---- start  �礨ӹǹ�Թ ����Ҥ���е��ᷧ�٧�ش ��� 61
				if(!GetPlayType_Money(o1,o2,o3)){
					document.form1.gbl_cankeynextrow.value=0;
					//alert(' ===> '+document.form1.gbl_cankeynextrow.value)
					return false;
				}
				//---- finish �礨ӹǹ�Թ ����Ҥ���е��ᷧ�٧�ش ��� 61

				//-------
				
				//--- �����ӹǹ�Թ�ͧ ���				
				//sum_PlayAmt();
				//sum_PlayAmt(o.value,c,l); // �觨ӹǹ�Թ��� ��������� 
				// ����¹��礵͹ onBlur
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
				    if (c> 3) {
				        alert( "�ѹ�֡������")
				        document.form1.save_type.value="over_page";
				        clicksubmit()
				        return;
				    }
				    c="c"  +  c ;				
				}
				// ����繡�� enter ���ӹǹ�Թ ������ ��/��ҧ ����� pay_type
				id = c + 1 + l
				next_obj = document.getElementById(  id )
				next_obj.value=document.form1.master_pay_type.value;				
				displayUPDW(id,next_obj.value)
			}
			id = c + m + l
			next_obj = document.getElementById(  id )
			next_obj.focus()
			document.form1.gbl_cankeynextrow.value=1;
			if(col_enter==2){
				chkSum(obj);
			}
			document.form1.keep_old_value.value="yes";
		}

}

function click_shwSign(c, l) {
    id = c + Right('0' + l, 2);
    if (c == 'c21' && l == 1) { c = 'c11'; l = 34; }
    if (c == 'c31' && l == 1) { c = 'c21'; l = 34; }
    pid = c + Right('0' + (l - 1), 2);
    next_obj = document.getElementById(id)

    if (next_obj.value == "") {
        next_obj.value = document.getElementById(pid).value;
        obj = document.getElementById(id);
        displayUPDW(id, next_obj.value)
    }
}
function sum_PlayAmt(nmoney, c, l) {

    //	 �ӹǹ�Թ��͹����
    var omoney = document.form1.oldmoney.value
    var m

    if (document.all.this_play_amt.innerText == "") { document.all.this_play_amt.innerText = 0 }
    m = document.all.this_play_amt.innerText
    m = (parseFloat(m) - parseFloat(getMoney(omoney, c, l))) + parseFloat(getMoney(nmoney, c, l))
    document.all.this_play_amt.innerText = m

    if (document.all.this_play_disc.innerText == "") { document.all.this_play_disc.innerText = 0 }
    m = document.all.this_play_disc.innerText
    //formatnum �Ѵ����͡
    //if (!CalcPlayDiscount(nmoney,c,l)){
    m = parseFloat(m) + ((CalcPlayDiscount(nmoney, c, l)) - (CalcPlayDiscount(omoney, c, l)))
    document.all.this_play_disc.innerText = m
    //}

}
	function GetDiscount(play_type){
		var tmp_name=play_type;
		var i=0
		var count	= 0;
		string	= ""; 

		for( i = 0; i < ar_discount.length; i++ ) { 
			string = ar_discount[i].split( "|" ); 
			if( string[0] == tmp_name ) {
				return string[1];
			}
		}	
	}
	function ChkMaxMoney(play_type,money,money_focus,key_number,key_money){
		string	= "";
		string = ar_maxMoney[play_type].split( "|" ); 
		if(parseFloat(string[1])!=0){ // ��ҡ�˹��� 0 = ����ա�á�˹�ᷧ�٧�ش
			if(parseFloat(string[1]) < parseFloat(money) ){
				alert("�Դ��Ҵ : �ӹǹ�Թᷧ "+string[2]+" ��ͧ����Թ "+string[1]);
				money_focus.focus();
				return false;
			}
		}
        return chk_limit_number(play_type,key_number.value,key_money)

		return true;
	}
	//�¡�ӹǹ�Թ ������㹡�õ�Ǩ�ͺ �ӹǹ�Թ���ᷧ���٧�ش
	function GetPlayType_Money(obj1,obj2,obj3){ 
		var key_money=obj3.value;
		//var calcMoney=0;
		//-- �ӹǹ�Թ����ͧ㺹�����ѡ��ǹŴ����
		updown_type	= obj1; //document.getElementById(  id ) // PlayType
		key_number = obj2;  //document.getElementById(  id ) //�Ţᷧ
		var money_focus
		money_focus = obj3; //document.getElementById(  id ) // �ӹǹ�Թ ���� set focus ��Ѻ

		if ( (key_number.value.length)==1 && (updown_type.value=="�" || updown_type.value=="�+�") && !isNaN(key_money) ){  // --- ��� ��ҧ
			play_type=6	
			money=key_money			
			return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
		}

		if ( (key_number.value.length)==1 && (updown_type.value=="�" || updown_type.value=="�+�") && !isNaN(key_money) ){  // --- ��� ��
			play_type=5	
			money=key_money
			return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
		}

		if ( (key_number.value.length)==2 && !isNaN(key_money) ){  //  2   ��ҧ  ����ӹǹ�Թ�繵���Ţ 

			if (updown_type.value=='�' ) {		
				play_type=7  //-- 2 ��ҧ
				money=key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			}

			if (updown_type.value=='�') {
				play_type=1 // -- 2 ��
				money=key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			}								

			if (updown_type.value=='�+�') {
				play_type=7  //-- 2 ��ҧ
				money=key_money
				tmp7= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);

				play_type=1 // -- 2 ��
				money=key_money
				tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
				tmp = tmp7 && tmp1
				return tmp
			}								
		
	
		}

		//----- start ᷧ 2 �� 19 �ҧ 
		if ( (key_number.value.length)==1 && isNaN(key_money)  && key_money.indexOf('19*')==0  )  {
			tmp_key_money=key_money.substring(3,key_money.length) 
			if (updown_type.value=='�' || updown_type.value=='�+�' ){
				play_type=7  //--- 2 ��ҧ *19 ������ 19 ��� 
				money=tmp_key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			}

			if (updown_type.value=='�' || updown_type.value=='�+�' ){
				play_type=1  //--- 2 ��  *19 ������ 19 ��� 
				money=tmp_key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			}
		}
		//----- end ᷧ 2 �� 19 �ҧ 		

		//--- start 2 ��ǵç +��     12 = 100*200
		if ((key_number.value.length)==2 && !isNaN(key_number.value) &&  key_money.indexOf('*')>0 && 
		key_money.indexOf('19*')==-1 ) {

			if (updown_type.value=='�' ){	
				play_type=7  //-- 2 �����ҧ * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç
				tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);				
				play_type=7 //-- 2 ��ҧ
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);					
				tmp=tmp1 && tmp2
				return tmp;
			}
			if (updown_type.value=='�' ){	
				play_type=1  //-- 2 ��Ǻ� * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç
				tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);

				play_type=1 //-- 2 ��				
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);								
				tmp=tmp1 && tmp2
				return tmp;
			}
			if (updown_type.value=='�+�'){	
				play_type=7  //-- 2 �����ҧ * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç

				tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);				
				play_type=7 //-- 2 ��ҧ
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 

				tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);					

				play_type=1  //-- 2 ��Ǻ� * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç
				tmp3=ChkMaxMoney(play_type,money,money_focus,key_number,key_money);

				play_type=1 //-- 2 ��				
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				tmp4= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);								
				tmp=tmp1 && tmp2 && tmp3 && tmp4;
				return tmp;
			}

		}
		
		//--- start 2 ��     12 =*200	
		if ((key_number.value.length)==2 &&    key_money.indexOf('*')==0    ){
			calcMoney=0;
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=4   //-- 2 �����
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);		
			}
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=4   //-- 2 �����
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) ;
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	
			}
		}
		//-- start 3 ��Ǹ����� 123 = 999
		if ((key_number.value.length)==3 && !isNaN(key_money)){
			if (updown_type.value=='�'){	
				play_type=8 //-- 8 3 ��ҧ
				money=key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);			
			}
			if (updown_type.value=='�'){	
				play_type=2  //-- 3 ��
				money=key_money
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	
			}
			if (updown_type.value=='�+�'){	
				play_type=8 //-- 8 3 ��ҧ
				money=key_money
				tmp8=ChkMaxMoney(play_type,money,money_focus,key_number,key_money);			

				play_type=2  //-- 3 ��
				money=key_money
				tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	
				tmp=tmp8 && tmp2;
				return tmp;
			}
		}
		//---- start  ᷧ 3 �ç ��     123 =200*200
		if ((key_number.value.length)==3 && isNaN(key_money)  &&  key_money.indexOf('*')>0  &&
		 key_money.indexOf('19*')==-1 &&  key_money.indexOf('/')==-1){
			if (updown_type.value=='�'){
				play_type=2  //--  3 ��
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç					
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);		

				play_type=3  //---- ��ǹ�ͧ�� ----
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) //-- �ӹǹ�Թ�ͧ��ǵç					
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);			

			}
		 }

		//--- start   * 3 �� 123 = *990
		if ((key_number.value.length)==3 && key_money.indexOf('*')==0 &&
		 key_money.indexOf('/')==-1){
			if (updown_type.value=='�'){	
				play_type=3 //--  3 ��
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);		
			}		 
		 }
		//--- start 3 ǧ���
		if ((key_number.value.substring(3,4)=='*')  &&  (key_number.value.length)==4 &&
		key_money.indexOf('*')==-1 && !isNaN(key_money) )		{
			if (updown_type.value=='�'){	
				play_type=2  //--  3 ��
				
				n1=key_number.value.substring(0,1)
				n2=key_number.value.substring(1,2)
				n3=key_number.value.substring(2,3)
				//���������͹��� 2 ��� ���� 3 ����Ţ 
				if(n1==n2 || n1==n3 || n2==n3){
					multi=3
				}else{
					multi=6
				}				
				money=parseFloat(key_money)*parseFloat(multi)
				//����������͹�ѹ���� 6
				return ChkMaxMoney(play_type,money,money_focus,key_number,key_money);		
			}
		}

		//--- start �+� 71=100/400 -----
		if ( (key_number.value.length)==2 && updown_type.value=='�+�' && key_money.indexOf('/')>-1) {
		
				play_type=1   // --  2 ��
				money=key_money.substring(0,key_money.indexOf('/')) //-- �ӹǹ�Թ�ͧ���˹��
				tmp1=ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	
				//---����ǹ ��ҧ---			
				play_type=7    //--  2 ��ҧ
				money=key_money.substring(key_money.indexOf('/')+1, key_money.length) 
				tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	
				tmp=tmp1 && tmp2	
				return tmp;
		}
		//-- 125=100/200 -----
		if ( (key_number.value.length)==3 && updown_type.value=='�+�' && key_money.indexOf('/')>-1 && key_money.indexOf('*')==-1) {
			play_type=2  //--  3 ��		
			money=key_money.substring(0,key_money.indexOf('/')) //-- �ӹǹ�Թ�ͧ���˹��
			tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);	

			play_type=8  //--  3 ��ҧ
			money=key_money.substring(key_money.indexOf('/')+1, key_money.length) 
			tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);		
			tmp=tmp1 && tmp2
			return tmp;
		}

		//-- 125 = 100*100/50 2006-09-07
	
		if ( (key_number.value.length)==3 && updown_type.value=='�+�' && key_money.indexOf('/')>-1 && key_money.indexOf('*')>-1){
			//---����ǹ �� ��͹  100  ---			
			play_type=2  //--  3 ��
			money=key_money.substring(0,key_money.indexOf('*')) //- �ӹǹ�Թ�ͧ���˹��
			tmp1= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			//--- �Ţ��ѧ * = 3 ��  *100  
			slash=key_money.indexOf('/')
			star=key_money.indexOf('*')
			money=key_money.substring(star+1,slash ) 
			play_type=3  //--  3 ��
			tmp2= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			money=key_money.substring(slash+1,key_money.length )   
			play_type=8  //-- 8 3 ��ҧ			
			tmp3= ChkMaxMoney(play_type,money,money_focus,key_number,key_money);
			tmp=tmp1 && tmp2 && tmp3;
			return tmp;
		}

		return true;
	}//end function
	
	function CalcPlayDiscount(nmoney,c,l){
		var key_money=nmoney
		var calcMoney=0;
		//-- �ӹǹ�Թ����ͧ㺹�����ѡ��ǹŴ����
		id=c+'1'+l
		updown_type	= document.getElementById(  id ) // PlayType
		id=c+'2'+l
		key_number = document.getElementById(  id ) //�Ţᷧ
		var money_focus
	    id=c+'3'+l
		money_focus = document.getElementById(  id ) // �ӹǹ�Թ ���� set focus ��Ѻ

		if ( (key_number.value.length)==1 && (updown_type.value=="�" || updown_type.value=="�+�") && !isNaN(key_money) ){  // --- ��� ��ҧ
			play_type=6	
			money=key_money			
			calcMoney =parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
		}

		if ( (key_number.value.length)==1 && (updown_type.value=="�" || updown_type.value=="�+�") && !isNaN(key_money) ){  // --- ��� ��
			play_type=5	
			money=key_money
			calcMoney =parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
		}

		if ( (key_number.value.length)==2 && !isNaN(key_money) ){  //  2   ��ҧ  ����ӹǹ�Թ�繵���Ţ 

			if (updown_type.value=='�' || updown_type.value=='�+�') {		
				play_type=7  //-- 2 ��ҧ
				money=key_money
				calcMoney =parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
			}

			if (updown_type.value=='�' || updown_type.value=='�+�') {
				play_type=1 // -- 2 ��
				money=key_money
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
			}								
		
	
		}

		//----- start ᷧ 2 �� 19 �ҧ 
		if ( (key_number.value.length)==1 && isNaN(key_money)  && key_money.indexOf('19*')==0  )  {
			tmp_key_money=key_money.substring(3,key_money.length) 
			if (updown_type.value=='�' || updown_type.value=='�+�' ){
				play_type=7  //--- 2 ��ҧ *19 ������ 19 ��� 
				money=tmp_key_money * 19
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
			}

			if (updown_type.value=='�' || updown_type.value=='�+�' ){
				play_type=1  //--- 2 ��  *19 ������ 19 ��� 
				money=tmp_key_money * 19
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
			}
		}
		//----- end ᷧ 2 �� 19 �ҧ 		

		//--- start 2 ��ǵç +��     12 = 100*200
		if ((key_number.value.length)==2 && !isNaN(key_number.value) &&  key_money.indexOf('*')>0 && 
		key_money.indexOf('19*')==-1 ) {

			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=7  //-- 2 �����ҧ * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )

				play_type=7 //-- 2 ��ҧ
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
			
			}
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=1  //-- 2 ��Ǻ� * 2 �� 2 ���
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				

				play_type=1 //-- 2 ��				
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				
			}



		}
		
		//--- start 2 ��     12 =*200	
		if ((key_number.value.length)==2 &&    key_money.indexOf('*')==0    ){
			calcMoney=0;
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=4   //-- 2 �����
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				

			}
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=4   //-- 2 �����
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) ;
				calcMoney=calcMoney+parseFloat(money) - 	(   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				
			}
		}
		//-- start 3 ��Ǹ����� 123 = 999
		if ((key_number.value.length)==3 && !isNaN(key_money)){
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=8 //-- 8 3 ��ҧ
				money=key_money
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				
			}
			if (updown_type.value=='�' || updown_type.value=='�+�'){	
				play_type=2  //-- 3 ��
				money=key_money
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )			
			}

		}
		//---- start  ᷧ 3 �ç ��     123 =200*200
		if ((key_number.value.length)==3 && isNaN(key_money)  &&  key_money.indexOf('*')>0  &&
		 key_money.indexOf('19*')==-1 &&  key_money.indexOf('/')==-1){
			if (updown_type.value=='�'){
				play_type=2  //--  3 ��
				money=lefty(key_money,key_money.indexOf('*')) //-- �ӹǹ�Թ�ͧ��ǵç					
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				

				play_type=3  //---- ��ǹ�ͧ�� ----
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) //-- �ӹǹ�Թ�ͧ��ǵç					
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				

			}
		 }

		//--- start   * 3 �� 123 = *990
		if ((key_number.value.length)==3 && key_money.indexOf('*')==0 &&
		 key_money.indexOf('/')==-1){
			if (updown_type.value=='�'){	
				play_type=3 //--  3 ��
				money=key_money.substring(key_money.indexOf('*')+1, key_money.length) 
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				
			}		 
		 }
		//--- start 3 ǧ���
		if ((key_number.value.substring(3,4)=='*')  &&  (key_number.value.length)==4 &&
		key_money.indexOf('*')==-1 && !isNaN(key_money) )		{
			if (updown_type.value=='�'){	
				play_type=2  //--  3 ��
				
				n1=key_number.value.substring(0,1)
				n2=key_number.value.substring(1,2)
				n3=key_number.value.substring(2,3)
				//���������͹��� 2 ��� ���� 3 ����Ţ 
				if(n1==n2 || n1==n3 || n2==n3){
					multi=3
				}else{
					multi=6
				}				
				money=parseFloat(key_money)*parseFloat(multi)
				//����������͹�ѹ���� 6
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				

			}
		}

		//--- start �+� 71=100/400 -----
		if ( (key_number.value.length)==2 && updown_type.value=='�+�' && key_money.indexOf('/')>-1) {
		
				play_type=1   // --  2 ��
				money=key_money.substring(0,key_money.indexOf('/')) //-- �ӹǹ�Թ�ͧ���˹��
				calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )				
				//---����ǹ ��ҧ---			
				play_type=7    //--  2 ��ҧ
				money=key_money.substring(key_money.indexOf('/')+1, key_money.length) 
				calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )			
		}
		//-- 125=100/200 -----
		if ( (key_number.value.length)==3 && updown_type.value=='�+�' && key_money.indexOf('/')>-1 && key_money.indexOf('*')==-1) {
			play_type=2  //--  3 ��		
			money=key_money.substring(0,key_money.indexOf('/')) //-- �ӹǹ�Թ�ͧ���˹��
			calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )		

			play_type=8  //--  3 ��ҧ
			money=key_money.substring(key_money.indexOf('/')+1, key_money.length) 
			calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )			
		}

		//-- 125 = 100*100/50 2006-09-07
	
		if ( (key_number.value.length)==3 && updown_type.value=='�+�' && key_money.indexOf('/')>-1 && key_money.indexOf('*')>-1){
			//---����ǹ �� ��͹  100  ---			
			play_type=2  //--  3 ��
			money=key_money.substring(0,key_money.indexOf('*')) //- �ӹǹ�Թ�ͧ���˹��
			calcMoney=parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )
		
			//--- �Ţ��ѧ * = 3 ��  *100  
			slash=key_money.indexOf('/')
			star=key_money.indexOf('*')
			money=key_money.substring(star+1,slash ) 
			play_type=3  //--  3 ��
			calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )			
			
			money=key_money.substring(slash+1,key_money.length )   
			play_type=8  //-- 8 3 ��ҧ			
			calcMoney=calcMoney+parseFloat(money) - (   parseFloat(money) * parseFloat(GetDiscount(play_type)) / 100 )			

		}
		if(key_money==""){
			calcMoney=0;
		}
		return calcMoney;
	}//end function
	
	function getMoney(x,c,l){
		//x=�ӹǹ�Թ��������
		var id, i ,j,o
		o=x;
		if (x!='' ){
			x2=x.indexOf('*')
			if (x2==0){
				x3=x.substring(x2+1,x.length)						
				x=parseInt(x3)
			}
			if (x2>0){
				x1=x.substring(0,x2)					
				x3=x.substring(x2+1,x.length)						
				if (x1=='19'){
					x=parseInt(x1) * parseInt(x3)
				}else {
					x=parseInt(x1) + parseInt(x3)
				}
			}
			//----- ����� �+� �е�ͧ�ǡ �Թ����
			//�+�	13	=	100*200
			id=c+'1'+l
			up_down	= document.getElementById(  id )
			if (up_down.value=='�+�'){
				x = parseInt(x)	* 2
			}
			//--- 2005-07-01 // 
			//-- ����繡óա�ä���ǧ��� 123*=100  , 223*=100
			id=c+'2'+l
			next_obj = document.getElementById(  id )
			
			n1=next_obj.value.substring(0,1)
			n2=next_obj.value.substring(1,2)
			n3=next_obj.value.substring(2,3)
			if (next_obj.value.substring(3,4)=='*'){
				if (n1!=n2 && n2!=n3 && n1!=n3){
					x=parseInt(x) * 6
				}else{
					x=parseInt(x) * 3
				}
			}

			// ����繡ó� ���� �+� �Թ 100/200 
			x2=o.indexOf('/')
			if (x2>0){
				x1=o.substring(0,x2)					
				x3=o.substring(x2+1,o.length)						
				x=parseInt(x1) + parseInt(x3)
			}									
		}
		if (x==''){
			x=0;
		}
		x2=o.indexOf('*')
		p_slash=o.indexOf('/')
		if(x2>0 && p_slash>0){
			m1=o.substring(0,x2)		
			m2=o.substring(x2+1, p_slash)	
			m3=o.substring(p_slash+1,o.length)
			x=parseFloat(m1)+parseFloat(m2)+parseFloat(m3)		 
		}
		return x
	}//end function

		
	function canKeyUPDN(v ){
		var LengthStr = v.length			
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  (! ( !  isNaN(a)   || a=='*' || a=='/' ) ) {
				//����� �+� ����ö������ 71-100/400 �� = ᷧ 2 �� 100 2 ��ҧ 400
				return true
			}					
		}		
		return false
	}
	function canKeyNumber(v ){
		var LengthStr = v.length			
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  (! ( !  isNaN(a)   || a=='*' ) ) {
				//����� �+� ����ö������ 71-100/400 �� = ᷧ 2 �� 100 2 ��ҧ 400

				return true
			}					
		}		
		return false
	}

	function canKeyStar(v ){
		var LengthStr = v.length		
		var star=''
		var slash=''
		var i, a
		for (i=0; i<=LengthStr - 1 ; i++){
			a = v.substring(i  , parseInt(i)+1 ) 
			if  ( a=='*' )  {
				star=star + a
			}		
			if  ( a=='/' )  {
				slash=slash + a
			}		
		}	
		// comment 2006-0907
		// 㹡�ä���ӹǹ�Թ��ͧ�� * / ���ҧ����ҧ˹����ҹ��
		//if (star!='' && slash!=''){
		//	return false
		//}
		if ( (star=='*' || star=='') && (slash=='/' || slash=='') )  {
			return true
		}else{
			return false
		}
	}
	
	function click_updown_type(obj){
		var t=document.b_updown_type.src;	
		t=t.substring(t.length - 7 ,t.length);
		var b = document.getElementById("b_updown_type") 
		var l 	, id , chkcol_money
		var k=event.keyCode
		//--- ����� ���������ᷧ ��÷Ѵ����
		n=obj.id
		var col = lefty(n,2)    //n.substring(1,2) 
		l=n.substring(3,5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ���
		var csign=n.substring(1,2);

		id=col+'1'+ l
		next_obj = document.getElementById(  id )

		if (t=="low.jpg"){
			document.b_updown_type.src = "images/upp.jpg"
			document.form1.master_pay_type.value="�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�"; 
			sign_obj.className="text_blackup";
			sign_obj.style.width="27"
			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"
		}
		if (t=="upp.jpg"){
			document.b_updown_type.src = "images/ulo.jpg"
			document.form1.master_pay_type.value="�+�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�+";
			sign_obj.className="text_black_bg";
			sign_obj.style.width="17"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_red_bg";
			sign_obj.style.width="10"
		}
		if (t=="ulo.jpg"){
			document.b_updown_type.src = "images/low.jpg"
			document.form1.master_pay_type.value="�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_reddw";
			sign_obj.style.width="27"
		}
		// ������Ѻ����¹ ��Ңͧ pay_type �ͧ�ѹ�Ѵ��鹴���
		next_obj.value=document.form1.master_pay_type.value
		// ��Ѻ� set focus ������
		next_obj = document.getElementById( n)
		if (k!=107){ // ����繡�á� + ����ͧ����͹ focus
			next_obj.focus();
		}
	}
function displayUPDW(n, updw){
	var id;
	var csign=n.substring(1,2)
	var l=n.substring(3,5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ���
	if (updw=="�"){	
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�"; 
			sign_obj.className="text_blackup";
			sign_obj.style.width="27"
			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"
		}
		if (updw=="�+�"){
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�+";
			sign_obj.className="text_black_bg";
			sign_obj.style.width="17"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_red_bg";
			sign_obj.style.width="10"
		}
		if (updw=="�"){
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_reddw";
			sign_obj.style.width="27"
		}
}

function click_updown_type_label(){
		var t=document.b_updown_type.src;	
		t=t.substring(t.length - 7 ,t.length);
		var b = document.getElementById("b_updown_type") 
		var n =document.form1.where_cursor.value 

		var l 	, id , chkcol_money
		var k=event.keyCode
		//--- ����� ���������ᷧ ��÷Ѵ����
		var col = n.substring(1,2) 
		l=n.substring(3,5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ���
		var csign=n.substring(1,2);
		id = 'c'+col + '1'+ l ; 
		next_obj = document.getElementById(  id )

		if (t=="low.jpg"){
		
			document.b_updown_type.src = "images/upp.jpg"
			document.form1.master_pay_type.value="�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�"; 
			sign_obj.className="text_blackup";
			sign_obj.style.width="27"
			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"

		}
		if (t=="upp.jpg"){
			document.b_updown_type.src = "images/ulo.jpg"
			document.form1.master_pay_type.value="�+�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�+";
			sign_obj.className="text_black_bg";
			sign_obj.style.width="17"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_red_bg";
			sign_obj.style.width="10"
		}
		if (t=="ulo.jpg"){
			
			document.b_updown_type.src = "images/low.jpg"
			document.form1.master_pay_type.value="�";
			id='signUp'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="";
			sign_obj.className="";
			sign_obj.style.width="0"

			id='signDw'+csign+ l
			sign_obj = document.getElementById(  id )
			sign_obj.innerText="�";
			sign_obj.className="text_reddw";
			sign_obj.style.width="27"

		}
		// ������Ѻ����¹ ��Ңͧ pay_type �ͧ�ѹ�Ѵ��鹴���
		next_obj.value=document.form1.master_pay_type.value
		// ��Ѻ� set focus ������
		next_obj = document.getElementById( n)
		if (k!=107){ // ����繡�á� + ����ͧ����͹ focus
			next_obj.focus();
		}
	}
</script>
<!--<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.form1.updown_type_col11.value="�"
	document.form1.all.signUp101.innerText=document.form1.updown_type_col11.value
	document.form1.all.signUp101.className="text_blackup";
	document.form1.master_pay_type.value=document.form1.updown_type_col11.value
	document.form1.key_number_col11.focus();
</SCRIPT>-->
<SCRIPT LANGUAGE="JavaScript">
var isNN = (navigator.appName.indexOf("Netscape")!=-1);
function autoTab(input,len, e) {
}
function XautoTab(input,len, e) {
var keyCode = (isNN) ? e.which : e.keyCode; 
var filter = (isNN) ? [0,8,9] : [0,8,9,16,17,18,37,38,39,40,46];

if(input.value.length >= len && !containsElement(filter,keyCode)) {
	if( isNaN(input.value)){
		alert('�Դ��Ҵ : ��سҡ�͡�Ţᷧ�繵���Ţ��ҹ�� !!!')
		return false
	}
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
	// �礨ӹǹ�Թ��ͧ����Թ limit_play  
	// �礨ӹǹ�Թ��ͧ����Թ limit_play  �ѡ��ǹŴ����
	if(parseFloat(replaceChars(document.all.this_play_disc.innerText)) > 			parseFloat(replaceChars(document.all.can_play.innerText))){
		alert("�ôԵ���");
		return false;
	}
	if(isNaN(document.form1.ticket_number.value)){
		alert("��سҡ�͡ 㺷�� �繵���Ţ��ҹ��!!");
		return false;
	}
	if (document.form1.key_number_col11.value==''){
		alert('��سҾ�����Ţᷧ !!!');
		document.form1.key_number_col11.focus();
	}else{

		if (validate_input_data()){
			if(document.form1.first_send.value=="yes"){
				document.form1.first_send.value=""
				document.form1.key_money_col333.readOnly=true;
				document.form1.de_credit.value=document.all.this_play_disc.innerText;
				document.form1.submit()
			}
	}}
}

function validate_input_data(){
	var id, i, j,ne ,next_obj, obj2,o1,o2,o,onumber
	for (j=1; j<= <%=col_per_page%>; j++){
		for (i=1; i<= <%=line_per_page%> ; i++){
			id = 'c'+j+'2'+ inc1(i-1) ; 
			o1 = document.getElementById(  id )
			id = 'c'+j+'3'+ inc1(i-1) ; 
			o2 = document.getElementById(  id )
			// �����ҧ����Թᷧ ����Ţᷧ������ü�ҹ��
			if (1==1){
				//-- jum 2007-09-10
				id = 'c'+j+'2'+ inc1(i-1) ; 
				o = document.getElementById(  id )	
				if ((o.value).indexOf('.') >=0){
					alert('�Դ��Ҵ : ��͹�Ţᷧ�繵���Ţ ��ҹ�� !!!')
					o.focus();
					return false
				}	
				//-- jum 2007-09-10
				id = 'c'+j+'3'+ inc1(i-1) ; 
				next_obj = document.getElementById(  id )

				if ( canKeyNumber(next_obj.value) ){
					// ����� �+� ����ö����ӹǹ�Թᷧ��  71=100/400 �� 100 ��ҧ 400
					id = 'c'+j+'1'+ inc1(i-1) ; 
					o = document.getElementById(  id )	
					id = 'c'+j+'2'+ inc1(i-1) ; 
					onumber= document.getElementById(  id )	
					// 2007-02-23
					if (o.value=="�+�" ){
						x=next_obj.value
						x2=x.indexOf('*')
						x3=x.indexOf('/')
						if(x2==0){
							alert('�Դ��Ҵ : ��͹�ӹǹ�Թᷧ���١��ͧ !!!')
							return false
						}
						//2007-03-19   �+� 999 =999*999/999
						if (x2!=-1 && x3!=-1 && onumber.value.length<3){
							alert('�Դ��Ҵ : ��͹�ӹǹ�Թᷧ���١��ͧ !!! '+x)
							onumber.focus();
							return false
						}
						if (x2>x3 && onumber.value.length<=3){
							alert('�Դ��Ҵ : ��͹�ӹǹ�Թᷧ���١��ͧ !!! 999=999*999/999')
							return false
						}
						//2007-03-19   �+� 999 =999*999/999
					}
					if (o.value=="�+�" && onumber.value.length<=3){
						if ( canKeyUPDN(next_obj.value) ){
							alert('�Դ��Ҵ : ��سһ�͹�ӹǹ�Թᷧ�繵���Ţ [0-9] , * ���� / ��ҹ�� !!!')
							return false;
						}
												
					}else{
						alert('�Դ��Ҵ : ��سһ�͹�ӹǹ�Թᷧ�繵���Ţ [0-9] ���� * ��ҹ�� !!!')
						return false;
					}
				}

				id = 'c'+j+'2'+ inc1(i-1) ; 
				obj2 = document.getElementById(  id )
				if( isNaN(lefty(obj2.value,3))){
					alert('�Դ��Ҵ : ��سҡ�͡�Ţᷧ�繵���Ţ��ҹ�� \n ��ҵ�ͧ���ᷧ�Ţǧ��� ��ͧ����Ẻ  123*')
					obj2.focus();
					return false
				}	
				// ����ҹ��  2005-07-20
				//if (obj2.value!=''){
				//	if (next_obj.value==''){
				//		alert('�Դ��Ҵ : ��سҵ�Ǩ�ͺ�ӹǹ�Թᷧ xxx!!!')
				//		next_obj.focus();
				//		return false
				//	}
				//}
				// ����ҹ��  2005-07-20
				id = 'c'+j+'1'+ inc1(i-1) ; 
				o = document.getElementById(  id )	
				// �Ţᷧ ��͡ 123* ��  ��Ƿ�� 4 �� * ����ҹ��
				if (obj2.value.length==4){
					if (obj2.value.substring(3,4)!="*" && obj2.value.substring(3,4)!=' ' ){
						alert('�Դ��Ҵ : ��ҵ�ͧ���ᷧ�Ţǧ��� ��ͧ����Ẻ  123* xxxxxx!!!')
						obj2.focus();
						return false
					}	
					if (o.value!='�'){
						alert('�Դ��Ҵ : ǧ���ᷧ��੾�� �� ��ҹ�� !!!')
						return false
					}					
					var n1,n2,n3
					n1=obj2.value.substring(0,1)
					n2=obj2.value.substring(1,2)
					n3=obj2.value.substring(2,3)
					if (n1==n2 && n2==n3 && n1==n3){
						alert('�Դ��Ҵ : �Ţ�ͧ����ͧᷧẺǧ���  !!!')
						return false
					}
					if( isNaN(next_obj.value)){
						alert('�Դ��Ҵ : ǧ��� �Ţᷧ ��ͧ�繵���Ţ��ҹ�� !!!')
						next_obj.focus();
						return false
					}
				}
				// ���ᷧ �+� ���������Ţ 3 ��� 
				//if (o.value=="�+�"){
				//	if (obj2.value.length>=3){
				//		alert('�Դ��Ҵ : ᷧ �+� ���������Ţᷧ 3 ��ѡ !!!')
				//		return false
				//	}
				//} 
				// ����ҹ��  2005-07-20
				//if (next_obj.value!=''){
				//	if (obj2.value==''){
				//		alert('�Դ��Ҵ : ��سҵ�Ǩ�ͺ �Ţᷧ !!!')
				//		obj2.focus();
				//		return false
				//	}
				//}
				// ����ҹ��  2005-07-20
				//����ͧ�ӹǹ�Թ ��������  * 2 ���� 
				if (!canKeyStar(next_obj.value)){
					alert('�Դ��Ҵ :  ��سҡ�͡�ӹǹ�Թᷧ���١��ͧ !!!')
					return false;
				}

				// �ӹǹ�Թᷧ��ͧ �ҡ���� 0 ��ҡ�Ѻ�������� 8/5/49
				if (obj2.value!=''){
					if (next_obj.value<=0){
						alert('�Դ��Ҵ :  ��سҡ�͡�ӹǹ�Թᷧ��ͧ�ҡ���� 0 !!!')
						return false;
					}
				}
				//----------------------------------
				id = 'c'+j+'1'+ inc1(i-1) ; 
				o1 = document.getElementById(  id )
				id = 'c'+j+'2'+ inc1(i-1) ; 
				o2 = document.getElementById(  id )
				id = 'c'+j+'3'+ inc1(i-1) ; 
				o3 = document.getElementById(  id )
				if (o1.value!='' && o2.value!='' && o3.value!=''){
					if ( ! validate_1(o1,o2,o3)){
						o3.focus();
						return false
					}
				}
				//jum 2007-11-12
				if(!(GetPlayType_Money(o1,o2,o3))){
					o3.focus();
					return false
				}
				//----------------------------------
			}			
		}
	}
	return true
}

function validate_1(o1,o2,o3){
	// �� function �������͹�Ѻ validate_input_data ����� 1 ��¡�� ��� ��Ǩ�ͺ�Ѻ�óշ���ա�� copy �ӹǹ�Թ�ҡ��÷Ѵ��
	if (o1.value=='�'){
		if ( !isNaN(o2.value) && !isNaN(o3.value) ){
			return true;
		}
		if (o2.value.length>1  && o3.value.indexOf('*') >0 && lefty(o3.value,3)!='19*' ){
			return true;
		}
		if (o2.value.length==1  && lefty(o3.value,3)=='19*'){
			return true;
		}
		if (o2.value.indexOf('*') >0   && !isNaN(o3.value)  ){
			return true;
		}
		if (o2.value.length>1 && o3.value.indexOf('*') ==0 ){
			return true;			
		}
	}
	if (o1.value=='�+�'){

		if (o2.value.length>1 && o2.value.length<3  && o3.value.indexOf('*') > 0  ){
			return true;
		}
		if (o2.value.length>1  && !isNaN(o3.value)  ){
			return true;
		}
		if (o2.value.length>1   && o3.value.indexOf('/') >0    ){
			return true;
		}
	
	}
	if (o1.value=='�'){
		if ( !isNaN(o2.value) && !isNaN(o3.value) ){
			return true;
		}
		if (o2.value.length==1  && lefty(o3.value,3)=='19*'){
			return true;
		}
		if (o2.value.length==2  && o3.value.indexOf('*') >0 && lefty(o3.value,3)!='19*'){
			return true;
		}
	}
	alert('�Դ��Ҵ : ��ä���ᷧ����͡�˹�ͨҡ����˹�');
	return false;
}
function iBlur(o){
	//if (document.form1.keep_old_value.value=="yes")
	//	{
		document.form1.where_cursor.value=o.id
		document.form1.oldmoney.value=o.value
	//alert(o.value + " oldmoney onBlur")
	//	}
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
		temp = "" + entry ; // temporary 
		
				while (temp.indexOf(out)>-1) {
					pos= temp.indexOf(out);
					temp = "" + (temp.substring(0, pos) + add + 
					temp.substring((pos + out.length), temp.length));
				}
		return temp;
}	
function help(){
	window.open("help.asp" ,'_blank',	"top=0,height=670,width=500,status=no,toolbar=yes,menubar=no,location=no");
}
	
</script>
<script language="vbscript">
	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function		
</script>
<script language="JavaScript">
    function chkKey(){

            var kc;
            if (window.event){
                kc = window.event.keyCode;
            }
            else {
                kc = e.which;
            }
	 //if (document.all){
	 // kc = event.keyCode; // IE
	 //}else{
	 // kc = e.which; // NS or Others
	 //} 
	 // ��� kc ��ͤ�� Unicode Charactor ����繵���Ţ
	if (kc=='121' ){
		clicksubmit()
	}	
	if (kc=='118' ){ //F7
		document.form1.ticket_number.focus();
	}
}
	document.all.limit_play.innerText="<%=limit_play%>"	
	document.all.can_play.innerText="<%=can_play%>"	

	document.onkeydown=chkKey
	window.focus();
	function chkEnterNumber(obj){
			var k=event.keyCode
			if (k == 13){	
				id='c1201';
				next_obj = document.getElementById( id )	
				next_obj.focus();
			}
	}
</script>
<script language="JavaScript">
	function showsum(showtype,ticketid) {
		window.open("dealer_showsum.asp?showtype="+showtype+"&tid="+ticketid,"_blank","top=150,left=0,height=250,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}
	function chk_limit_number(play_type,key_number,key_money){
		//090815 �� limit �ҡ ar_limit 	
		// ��� ChkMaxMoney
	    //��Ҩӹǹ�Թ�� * ��Ѻ�Ţ������ 
	    ar_limitmoney = (document.all.obj_limit_numbermoney.value).split(",");
		if (key_money.indexOf('*') >=0){
			key_number=tod3order(key_number);
			if(key_number.length==3){
				play_type=3;//alert("test")
			}
		}
		for( i = 0; i < ar_limit.length; i++ ) {				
			string = ar_limit[i].split( "|" ); 
			if( string[0] == play_type ) {
				if(key_number==string[1]){
					alert("�Ţ������� !!!");
					return false;
				}
			}
		}
		for( j = 0; j < ar_limitmoney.length; j++ ) {	
		    string2 = ar_limitmoney[j].split( "|" ); 
		    if( string2[0] == play_type ) {
		        if(key_number==string2[1]){
		            if(key_money > string2[2]){
		                alert("�ʹᷧ�Ţ�Թ���� !!! ������ʹᷧ " + string2[2]);
		                return false;
		            }
		        }
		    }
		}//play_type,limit_number,balance_amt

		//++++++++++++++++++++��ҵ���Ţ�� * �Ѵ * �͡������������ҫ���������  3 ��Ѻ
		if (key_number.indexOf('*') >=0){
			var n_key_number=tod3order(key_number);
			for( i = 0; i < ar_limit.length; i++ ) {				
				string = ar_limit[i].split( "|" ); 
				if( string[0] == 2 ) {
					if(n_key_number==tod3order(string[1])){
						alert("�Ţ������� !!!");
						return false;
					}
				}
			}
			for( j = 0; j < ar_limitmoney.length; j++ ) {	
			    string2 = ar_limitmoney[j].split( "|" ); 
			    if( string2[0] == 2 ) {
			        if(n_key_number==tod3order(string2[1])){
			            if(key_money > string2[2]){
			                alert("�ʹᷧ�Ţ�Թ���� !!! ������ʹᷧ " + string2[2]);
			                return false;
			            }
			        }
			    }
			}
		}
		// 2 ��
		if (key_number.length==1 && lefty(key_money,3)=='19*'){ 		
			for( i = 0; i < ar_limit.length; i++ ) {				
				string = ar_limit[i].split( "|" ); 
				if( string[0] == play_type ) {
					if(key_number==string[1].substring(0,1) ){
						alert("�Ţ������� !!!");
						return false;
					}
				}
			}
			for( j = 0; j < ar_limitmoney.length; j++ ) {	
			    string2 = ar_limitmoney[j].split( "|" ); 
			    if( string2[0] == play_type ) {
			        if(key_number==string2[1].substring(0,1)){
			            key_money = key_money.substring(key_money.indexOf('*')+1, key_money.length) ;
			            if(key_money > string2[2]){
			                alert("�ʹᷧ�Ţ�Թ���� !!! ������ʹᷧ " + string2[2]);
			                return false;
			            }
			        }
			    }
			}
		}
		//++++++++++++++++++++��ҵ���Ţ�� * �Ѵ * �͡������������ҫ���������  3 ��Ѻ

		return true;
	}
	function tod3order(obj){
	// ���§�Ţ���� 
		var n1,n2,n3, x1,x2,x3,x4,x5,x6, xMin
		n1=obj.substring(0,1)
		n2=obj.substring(1,2)
		n3=obj.substring(2,3)
		x1=n1+n2+n3;
		x2=n1+n3+n2;
		x3=n3+n2+n1;
		x4=n2+n1+n3;
		x5=n2+n3+n1;
		x6=n3+n1+n2;
		xMin=x1;
		if(xMin>x2){xMin=x2;}
		if(xMin>x3){xMin=x3;}
		if(xMin>x4){xMin=x4;}
		if(xMin>x5){xMin=x5;}
		if(xMin>x6){xMin=x6;}
		return xMin;	
	}
	function default_up_type_label() {
	    var t = document.b_updown_type.src;
	    t = t.substring(t.length - 7, t.length);
	    var b = document.getElementById("b_updown_type")
	    var n = document.form1.where_cursor.value

	    var l, id, chkcol_money
	    var k = event.keyCode
	    //--- ����� ���������ᷧ ��÷Ѵ����
	    var col = n.substring(1, 2)
	    l = n.substring(3, 5);   // ��÷Ѵ��� �����  ����� 33 ��ͧ��Ѻ价�� 1 ���
	    var csign = n.substring(1, 2);
	    id = 'c' + col + '1' + l;
	    next_obj = document.getElementById(id)

	    document.b_updown_type.src = "images/upp.jpg"
	    document.form1.master_pay_type.value = "�";
	    id = 'signUp' + csign + l
	    sign_obj = document.getElementById(id)
	    sign_obj.innerText = "�";
	    sign_obj.className = "text_blackup";
	    sign_obj.style.width = "27"
	    id = 'signDw' + csign + l
	    sign_obj = document.getElementById(id)
	    sign_obj.innerText = "";
	    sign_obj.className = "";
	    sign_obj.style.width = "0"

	    // ������Ѻ����¹ ��Ңͧ pay_type �ͧ�ѹ�Ѵ��鹴���
	    next_obj.value = document.form1.master_pay_type.value
	    // ��Ѻ� set focus ������
	    next_obj = document.getElementById(n)
	    if (k != 107) { // ����繡�á� + ����ͧ����͹ focus
	        next_obj.focus();
	    }
	}
</script>

