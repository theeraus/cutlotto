<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<html>
<head>
<title>.:: �����ôԵ ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<%
		Dim objRS , objDB , SQL, UID,user_name,save,increase_credit, objRS1
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		Set objRS1 =Server.CreateObject("ADODB.Recordset")	
			
		save=Request("save")
		if save="ok" Then
			login_id=Request("login_id")
			increase_credit=Request("increase_credit")
			dim login_id 
			SQL="select user_id from sc_user where login_id='" & login_id & "' and create_by='" & Session("uid") & "' and user_type='P' and create_by_player=0 and user_disable=0 "
'response.write SQL
'response.end
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				UID =objRS("user_id")
			else
				response.write "<br><br><br><br><br><center><span class=head_red>�������ö�����ôԵ�� ���ͧ�ҡ��辺���� " & login_id & "</span></center>"
				response.end
			end if 	
'response.end
			'��Ǩ�ͺ��͹ ����Թ�������óշ����� ����蹵�			
			SQL="select create_by_player from sc_user where user_id=" & UID
			Dim agent_limit_play,Can_Increase,create_by_player, alert_mess, UID_limit_play
			create_by_player=0
			Can_Increase=0
			agent_limit_play=0
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				create_by_player=objRS("create_by_player")
				If objRS("create_by_player")>0 Then '��·��������ôԵ�� ��Ҫԡ 
					SQL="select limit_play from sc_user where user_id="	& UID
					Set objRS1=objDB.Execute(SQL)
					If Not objRS1.eof Then
						UID_limit_play=objRS1("limit_play")
					End If 

					SQL="select limit_play from sc_user where user_id="	& create_by_player
					Set objRS1=objDB.Execute(SQL)
					If Not objRS1.eof Then
						agent_limit_play=objRS1("limit_play")
					End If 
					'�ôԵ���������١������������ �������
					Dim play2_sum_credit, remain_credit , can_credit
					remain_credit=0
					play2_sum_credit=0	
					SQL="select sum(limit_play) as slimit_play from sc_user where create_by_player=" & create_by_player
					set objRS=objDB.Execute(SQL)
					If Not objRS.eof Then
						play2_sum_credit=objRS("slimit_play") & ""
					End If 
					'�ôԵ ��褹ᷧ������� 
					Dim sum_play	
					SQL="exec spJSelectPlayerDet " & create_by_player & ", " & Session("gameid")	
					set objRS=objDB.Execute(SQL)
					If Not objRS.eof Then
						If CDbl(objRS("sum_play"))>0 then
							sum_play=objRS("sum_play")
						Else
							sum_play=0
						End If								
					End If
					remain_credit=agent_limit_play - play2_sum_credit
					'can_credit=CDbl(remain_credit)  -  Cdbl(sum_play)
					can_credit=CDbl(agent_limit_play)  -  Cdbl(sum_play)
					'response.write "can_credit" & can_credit & "remain_credit" & remain_credit & "play2_sum_credit" & play2_sum_credit
			'		response.end
					If CDbl(can_credit)>CDbl(increase_credit) Then
						Can_Increase=1
						If CDbl(UID_limit_play)+CDbl(increase_credit)>=0 Then
							Can_Increase=1
						Else
							Can_Increase=0
							alert_mess="�������öŴ�ôԵ�����¡��� 0 ��"
						End If
					Else 
						alert_mess="�������ö �����ôԵ�� ��ҹ���ôԵ������� " & agent_limit_play
					End If 
					If Can_Increase=1 Then
					'����Ҷ����Ҫԡ�ա��ᷧ�������������Ŵ�ôԵ
						SQL="select top 1 *  from tb_ticket where player_id=" & UID & " and game_id=" &  Session("gameid")
						Set objRS=objDB.Execute(SQL)
						If Not objRS.eof Then
							if CDbl(increase_credit)< 0 Then
								Can_Increase=0
								alert_mess="�Դ��Ҵ : �������öŴ�ôԵ��Ҫԡ��¹�������ͧ�ҡ�ա��ᷧ������!! "
							end if
						End If 
					End If 

				Else '��·��������� ����蹵�
					Can_Increase=1
				End If 
			End if 

			If Can_Increase=1 then
				SQL="update sc_user set limit_play=limit_play+" & increase_credit & " where user_id=" & UID
				objDB.Execute(SQL)
				If create_by_player<>0 Then ' ����繡�������֤õԴ�����Ҫԡ ���Ŵ�ôԵ�ͧ����蹵�ŧ����
					'//If increase_credit>0 Then ' ����� ź ��͡������Թ�͡�ҡ ��Ҫԡ
						SQL="update sc_user set limit_play=limit_play - (" & increase_credit & ") ,  limit_play_original=limit_play_original - (" & increase_credit & ") where user_id=" & create_by_player
						objDB.Execute(SQL)
					'//End If 
				End If 
				'%%%%%%%%%%%%%%% ���͡���͡��§ҹ�ôԵ %%%%%%%%%%%%%%%%%%%%
				Dim Client_IP
				Client_IP=Request.ServerVariables("REMOTE_ADDR") 
				SQL="insert into tb_usercredit_det(user_id,game_id,adj_date,adj_credit,ip_address) values( "
				SQL=SQL & UID & ", "
				SQL=SQL &  Session("gameid")	& ", "
				SQL=SQL &  "getdate(), "
				SQL=SQL & increase_credit & ", "
				SQL=SQL & "'" & Client_IP & "' ) "
				objDB.Execute(SQL)
				'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			%>
			<script language="javascript">
				window.opener.location.reload();
				self.close();
			</script>
			<%
			Else ' ���������Թ
			%>
			<script language="javascript">
				alert('�Դ��Ҵ : <%=alert_mess%>');
			</script>
			<%
			End If 	
		end if
		
%>

<body topmargin="0" leftmargin="0" scroll = no  style="border : solid #606060; border-width : 1px;" bgcolor="#DBDBDB">
	<form name="form1" action="credit_increase_by_loginno.asp" method="post">
	
	<input type="hidden" name="save" value="ok">
		<center>	<br>
		<table >
			<tr>
				<td align="center" class=head_red><font size=+2>���� </font></td>
				<td><input type="text" name="login_id" class="textbig_red" onKeyDown="chkEnter();"></td>
			</tr>
			<tr>
				<td colspan="2" align="center" class=head_red><hr></td>
			</tr>
			<tr>
				<td class="head_blue" align="center">�����ôԵ</td>
				<td align="center"><input type="text" name="increase_credit" class="textbig_red"></td>
			</tr>
			
			<tr>
				<td align="center" colspan="2"><input type="button" value="��ŧ" style="cursor:hand;width:90;" onclick="chknum();"></td>
			</tr>
			
		</table>	
		</center>
	</form>
</body>
</html>
<script>
	function chknum(){
		if(isNaN(document.form1.increase_credit.value)){
			alert('�Դ��Ҵ : ��س��ôԵ�繵���Ţ��ҹ�� !!!')
			document.form1.increase_credit.focus();
			return false;
		}
		document.form1.submit();
	}
function chkEnter(){
		var k=event.keyCode	
		if (k == 13){	
			document.form1.increase_credit.focus();
		}
}
</script>

<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">	
	document.form1.login_id.focus();
</SCRIPT>