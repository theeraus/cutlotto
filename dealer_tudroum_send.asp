<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<%'check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%
' 1. �ó����͡�觢��� web 
' 2. �� submit 令��Ң����� user password ����˹������ web1 ��� �����Ţͧ web 2 �������������
' 3. ��Ң������ҷ������ web 2 �ʴ�� text box 
' 4. �� submit ����� function clicksubmit ���觤�� sendback = yes ������� action ��� web 2 ���
' 5. ������Ҷ֧��� web 2  ����� ���͹� sendback = yes 
' 6. ��Ң����ŷ������ check user � web 2 ��Ҷ١��ͧ�������
' 7. ����� function  senddealer 
' 8. ��� user ��ҹ�������� ˹�� dealer_tudroum ��� form2 submit      **** �ç����ѧ��������ҷӷ�� web �˹
'

%>

<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="JavaScript">

	function clicksubmit(){
		if (!document.FORM1.toweb.value=="") {
//			alert("web1 " + document.FORM1.toweb.value);
//			return;
			document.FORM1.sendback.value = "yes";
			document.FORM1.action = document.FORM1.toweb.value+"dealer_tudroum_send.asp";
		} else {
			if (document.FORM1.txtUserName.value==''){
				alert('��سһ�͹ ���� ���ͪ��� �����ҹ')
				document.FORM1.button1.disabled=false;
				document.FORM1.txtUserName.focus();
				return false
			}
			if (document.FORM1.password1.value==''){
				alert('��سһ�͹ ���ʼ�ҹ')
				document.FORM1.button1.disabled=false;
				document.FORM1.password1.focus();
				return false
			}
		}
		document.FORM1.submit();
	}

	function senddealer(chk, todealer, toplayer,toweb){
		if (chk=="yes") {
			document.FORM2.sendto.value=todealer;
			document.FORM2.sendfrom.value=toplayer;
			document.FORM2.sendweb.value=toweb;
			if (toweb=="") {
				document.FORM2.sendweb2.value="";
			} else {
				document.FORM2.sendweb2.value="yes";
			}		
			//alert(chk+"|"+ todealer+"|"+ toplayer+"|"+toweb);
			document.FORM2.submit();
			window.opener.open(document.FORM2.fromweb.value + "dealer_play_out.asp","_self");
		} else if (chk=="LIMIT"){  //  ���Ţ��� 11/2/53
			if (confirm("��Ǩ�ͺ���Ţ��� �ֹ�ѹ�������Ţ������� �ҡ�׹�ѹ�Ţ��������١��仴��� ?"))			{
				document.FORM2.sendto.value=todealer;
				document.FORM2.sendfrom.value=toplayer;
				document.FORM2.sendweb.value=toweb;
				if (toweb=="") {
					document.FORM2.sendweb2.value="";
				} else {
					document.FORM2.sendweb2.value="yes";
				}		
				document.FORM2.submit();
				window.opener.open(document.FORM2.fromweb.value + "dealer_play_out.asp","_self");				
			} else {
				window.close();

			}
		} else if (chk=="CLOSE")	{
			alert("�������ö�������͹���� ���ͧ�ҡ�����ͻԴ�Ѻᷧ����...");
			window.close();

		} else if (chk=="FULL")	{
			alert("�������ö�������͹���� ���ͧ�ҡ�ôԵ���...");
			window.close();
		} else {
			//document.FORM2.txtdealer.value="";
			document.FORM2.txtUserName="";
			document.FORM2.password1="";
			document.FORM2.sendto.value="";
			document.FORM2.sendfrom.value="";
			document.FORM2.sendweb.value="";
			document.FORM2.sendweb2.value="";
			alert("��� Log In ���١��ͧ ! ��س��ͧ����...");
			window.close();

		}
	}


//function txtdealer_checkkey() {
//var chkkey
//	chkkey = event.keyCode;
//	if (chkkey == 13) {
//		document.all.FORM1.txtUserName.focus();
//	}
//}

function txtUserName_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		document.all.FORM1.password1.focus();
	}
}

function password1_checkkey() {
var chkkey
	chkkey = event.keyCode;
	if (chkkey == 13) {
		clicksubmit();
	}
}

</Script>
<%Response.Buffer = True%>
<%
	dim rs
	dim strSql
	dim strTitle
	dim strMsg 
	dim strGoto
	dim RndPw
	dim strPw
	dim chkOk
	dim buser
	dim bpass
	dim bdealer
	dim bplayer
	dim bweb
	dim objRS, objRS4
	dim sendweb
	Dim limit_play
	Dim sum_play
	Dim can_play
	Dim sumChkCr
	Dim arrMoney
	Dim arrNumber

	Dim arrMoney2up
	Dim arrNumber2up
	Dim arrMoney3up
	Dim arrNumber3up
	Dim arrMoney3tod
	Dim arrNumber3tod
	Dim arrMoney2down
	Dim arrNumber2down
	Dim txt2upNew, txt2upmoneyNew
	Dim txt3upNew, txt3upmoneyNew
	Dim txt3todNew, txt3todmoneyNew
	Dim txt2downNew, txt2downmoneyNew

	Dim i
	if Request("sendback")="yes" then 
		' �����ӷ�� web 2 ����
		' �� user ��� web 2 �ʴ���Ҷ١���Ҩҡ web  1
		' ¡��ԡ �� txtdealer
		chkOk = "no"
		strSql = "SELECT     sc_user.*, sc_user_1.user_name AS dealer_fname FROM         sc_user INNER JOIN sc_user sc_user_1 ON sc_user.create_by = sc_user_1.user_id " _
			& "Where (sc_user.login_id='"& Request("txtUserName") &"') and sc_user.user_password = '" & Request("password1") & "' And sc_user.user_disable=0 "
		strSql = strSql & " and sc_user.user_type='P'"
		'strSql = strSql & " And (sc_user_1.user_name ='" & Request("txtdealer") & "' or sc_user_1.login_id='" & Request("txtdealer") & "') and sc_user.user_type='P'"
'showstr strSql
		set rs = conn.execute(strsql,,1)
		if not rs.Eof then
			chkOK = "yes"
			bdealer=rs("create_by")
			bplayer=rs("user_id")
			'comment �����ѧ�������˵ؼ�
			Session("uid") = rs("create_by")
			if CheckGame(bdealer)<>"OPEN" then
				chkOk = "CLOSE"
			end if
			'��Ǩ�ͺ �ӹǹ�Թ limite credit
			strSql = "exec spJSelectPlayerDet " & bplayer & ", " & Session("gameid")
			Dim objRS3
			can_play=0
			set objRS3 = conn.execute(strsql,,1)
			If Not objRS3.Eof Then
				If CDbl(objRS3("limit_play"))>0 then
					limit_play=FormatNumber(objRS3("limit_play"),0)
				Else
					limit_play=0
				End if
				If CDbl(objRS3("sum_play"))>0 then
					sum_play=FormatNumber(objRS3("sum_play"),0)
				Else
					sum_play=0
				End If								
				If ( CDbl(objRS3("limit_play")) - CDbl(objRS3("sum_play")) ) > 0 Then
					can_play=FormatNumber(CDbl(objRS3("limit_play")) - CDbl(objRS3("sum_play")),0)
				Else
					can_play=0
				End If				
			End If
			If can_play <= 0  Then
				chkOk = "FULL"
			Else 
				sumChkCr = 0
				arrMoney=split(Request("txt2upmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt3upmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt3todmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt2todmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt1upmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt1downmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt2downmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				arrMoney=split(Request("txt3downmoney"),",")
				for i = 0 to Ubound(arrMoney)
					if len(trim(arrMoney(i)))<>0 then
						sumChkCr = sumChkCr + arrMoney(i)
					else
						exit for
					end if
				next						
				If CDbl(can_play) < CDbl(sumChkCr) Then chkOk = "FULL"
			End If 
			' Check Credit ��͹ ���������ǡ������ �Ţ���  11/2/53
			txt2upNew = "": txt2upmoneyNew = ""
			txt3upNew = "": txt3upmoneyNew = ""
			txt3todNew = "": txt3todmoneyNew = ""
			txt2downNew = "": txt2downmoneyNew = ""
			If chkOK <> "FULL" And chkOK <> "CLOSE" Then 
				strSql="exec spJ_GetNumberLimitMoney "  & bplayer & ", " & Session("gameid")
				'get ��� �Ţ����� 11/2/53
				Set objRS4=conn.execute(strSql)
				If Not objRS4.eof Then
					'����Ţ���еѴ�� �礡Ѻ �Ţ��� ��Ҿ���еѴ�͡�ҡ����� 11/2/53
					arrNumber2up=split(Request("txt2up"),",")
					arrMoney2up=split(Request("txt2upmoney"),",")						
					arrNumber3up=split(Request("txt3up"),",")
					arrMoney3up=split(Request("txt3upmoney"),",")						
					arrNumber3tod=split(Request("txt3tod"),",")
					arrMoney3tod=split(Request("txt3todmoney"),",")						
					arrNumber2down=split(Request("txt2down"),",")
					arrMoney2down=split(Request("txt2downmoney"),",")						
					While Not objRS4.eof
					'check �Ţ��� 2 ��
						for i = 0 to Ubound(arrNumber2up)
							if trim(arrNumber2up(i)) = Trim(objRs4("number_up2")) then
								arrNumber2up(i) = ""
								arrMoney2up(i)=""
								chkOk = "LIMIT"
								Exit For 
							End If 
						Next
					'check �Ţ��� 3 ��
						for i = 0 to Ubound(arrNumber3up)
							if trim(arrNumber3up(i)) = Trim(objRs4("number_up3")) then
								arrNumber3up(i) = ""
								arrMoney3up(i)=""
								chkOk = "LIMIT"
								Exit For 
							End If 
						Next
					'check �Ţ��� 3 ��
						for i = 0 to Ubound(arrNumber3tod)
							if trim(arrNumber3tod(i)) = Trim(objRs4("number_tod3")) then
								arrNumber3tod(i) = ""
								arrMoney3tod(i)=""
								chkOk = "LIMIT"
								Exit For 
							End If 
						Next
					'check �Ţ��� 2 ��ҧ
						for i = 0 to Ubound(arrNumber2down)
							if trim(arrNumber2down(i)) = Trim(objRs4("number_down2")) then
								arrNumber2down(i) = ""
								arrMoney2down(i)=""
								chkOk = "LIMIT"
								Exit For 
							End If 
						Next
						
						objRS4.MoveNext
					Wend
					'�Ѵ�Ţ��� 2 �� �͡
					for i = 0 to Ubound(arrNumber2up)
						If arrNumber2up(i) <> "" Then 
							If txt2upNew <> "" Then txt2upNew = txt2upNew & ","
							If txt2upmoneyNew <> "" Then txt2upmoneyNew = txt2upmoneyNew & ","
							
							txt2upNew = txt2upNew & arrNumber2up(i)
							txt2upmoneyNew = txt2upmoneyNew & arrMoney2up(i)
						End if
					Next								
					'�Ѵ�Ţ��� 3 �� �͡
					for i = 0 to Ubound(arrNumber3up)
						If arrNumber3up(i) <> "" Then 
							If txt3upNew <> "" Then txt3upNew = txt3upNew & ","
							If txt3upmoneyNew <> "" Then txt3upmoneyNew = txt3upmoneyNew & ","
							
							txt3upNew = txt3upNew & arrNumber3up(i)
							txt3upmoneyNew = txt3upmoneyNew & arrMoney3up(i)
						End if
					next
					'�Ѵ�Ţ��� 3 �� �͡
					for i = 0 to Ubound(arrNumber3tod)
						If arrNumber3tod(i) <> "" Then 
							If txt3todNew <> "" Then txt3todNew = txt3todNew & ","
							If txt3todmoneyNew <> "" Then txt3todmoneyNew = txt3todmoneyNew & ","
							
							txt3todNew = txt3todNew & arrNumber3tod(i)
							txt3todmoneyNew = txt3todmoneyNew & arrMoney3tod(i)
						End if
					next
					'�Ѵ�Ţ��� 2 ��ҧ �͡
					for i = 0 to Ubound(arrNumber2down)
						If arrNumber2down(i) <> "" Then 
							If txt2downNew <> "" Then txt2downNew = txt2downNew & ","
							If txt2downmoneyNew <> "" Then txt2downmoneyNew = txt2downmoneyNew & ","
							
							txt2downNew = txt2downNew & arrNumber2down(i)
							txt2downmoneyNew = txt2downmoneyNew & arrMoney2down(i)
						End if
					next														
				End if
			End If 
			response.write "<script language='JavaScript'>alert('������� '" & can_play & ")</script>"

			'check ���ʹ֧ game id �ͧ user �Ѩ�غѹ����
			call CheckGame(Session("uid"))

		end if

%>
<FORM id=FORM2 name=FORM2 action="<%=Request("toweb")%>dealer_tudroum_act.asp" method=post>
<INPUT TYPE=hidden name='tud1' value="<%=Request("tud1")%>">
<INPUT TYPE=hidden name='tud2' value="<%=Request("tud2")%>">
<INPUT TYPE=hidden name='tud3' value="<%=Request("tud3")%>">
<INPUT TYPE=hidden name='tud4' value="<%=Request("tud4")%>">
<INPUT TYPE=hidden name='tud5' value="<%=Request("tud5")%>">
<INPUT TYPE=hidden name='tud6' value="<%=Request("tud6")%>">
<INPUT TYPE=hidden name='tud7' value="<%=Request("tud7")%>">
<INPUT TYPE=hidden name='tud8' value="<%=Request("tud8")%>">
<INPUT TYPE=hidden name='2upcuttype' value="<%=Request("2upcuttype")%>">
<INPUT TYPE=hidden name='3upcuttype' value="<%=Request("3upcuttype")%>">
<INPUT TYPE=hidden name='3todcuttype' value="<%=Request("3todcuttype")%>">
<INPUT TYPE=hidden name='2downcuttype' value="<%=Request("2downcuttype")%>">
<%
	If txt2upNew <> "" then
%>
<INPUT TYPE=hidden name='txt2up' value="<%=txt2upNew%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=txt2upmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt2up' value="<%=Request("txt2up")%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=Request("txt2upmoney")%>">
<%
	End If 
	If txt3upNew <> "" then
%>
<INPUT TYPE=hidden name='txt3up' value="<%=txt3upNew%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=txt3upmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt3up' value="<%=Request("txt3up")%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=Request("txt3upmoney")%>">
<%
	End If 
	If txt3todNew <> "" then
%>
<INPUT TYPE=hidden name='txt3tod' value="<%=txt3todNew%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=txt3todmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt3tod' value="<%=Request("txt3tod")%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=Request("txt3todmoney")%>">
<%
	End If 
	If txt2downNew <> "" then
%>
<INPUT TYPE=hidden name='txt2down' value="<%=txt2downNew%>">
<INPUT TYPE=hidden name='txt2downmoney' value="<%=txt2downmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt2down' value="<%=Request("txt2down")%>">
<INPUT TYPE=hidden name='txt2downmoney' value="<%=Request("txt2downmoney")%>">
<%
	End If 
%>
<INPUT TYPE=hidden name='txt2tod' value="<%=Request("txt2tod")%>">
<INPUT TYPE=hidden name='txt2todmoney' value="<%=Request("txt2todmoney")%>">
<INPUT TYPE=hidden name='2todcuttype' value="<%=Request("2todcuttype")%>">
<INPUT TYPE=hidden name='txt1up' value="<%=Request("txt1up")%>">
<INPUT TYPE=hidden name='txt1upmoney' value="<%=Request("txt1upmoney")%>">
<INPUT TYPE=hidden name='1upcuttype' value="<%=Request("1upcuttype")%>">
<INPUT TYPE=hidden name='txt1down' value="<%=Request("txt1down")%>">
<INPUT TYPE=hidden name='txt1downmoney' value="<%=Request("txt1downmoney")%>">
<INPUT TYPE=hidden name='1downcuttype' value="<%=Request("1downcuttype")%>">
<INPUT TYPE=hidden name='txt3down' value="<%=Request("txt3down")%>">
<INPUT TYPE=hidden name='txt3downmoney' value="<%=Request("txt3downmoney")%>">
<INPUT TYPE=hidden name='3downcuttype' value="<%=Request("3downcuttype")%>">

<INPUT TYPE=hidden name='sendfrom' value="<%=Request("sendfrom")%>">
<INPUT TYPE=hidden name='sendto' value="<%=Request("sendto")%>">
<INPUT TYPE=hidden name='sendtype' value="<%=Request("sendtype")%>">			
<INPUT TYPE=hidden name='sendweb' value="<%=Request("sendweb")%>">
<INPUT TYPE=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
<INPUT TYPE=hidden name="fromweb" value="<%=Request("fromweb")%>">			
</FORM>
<%

		response.write "<script language='JavaScript'>senddealer('"&chkOK&"',"&bdealer&","&bplayer&",'"&Request("toweb")&"');</script>"
	end if
	if Request("act")="log" then
			buser=""
			bpass=""
			bdealer=""
			bweb = ""
			sendweb = ""
		if trim(Request("sendweb")) <> "" then
			strSql = "select * from sc_user where user_id = " & Request("sendweb")
			set objRS = conn.execute(strSql,,1)
			if not objRS.Eof then
				buser=trim(objRS("login_id"))
				bpass=trim(objRS("user_password"))
				bdealer=trim(objRS("nick_name"))		
				bweb = trim(objRS("address_1"))
				sendweb = objRS("user_id")
				Session("user_send_toweb") = sendweb
			end if
		else  ' ��������͡ �������
			buser=trim(Request("txtUserName"))
			bpass=trim(Request("password1"))
			'bdealer=trim(Request("txtdealer"))		
			bweb = trim(Request("sendweb"))
			sendweb = Request("sendweb")

			chkOk = "no"
			Set rs = server.createobject("ADODB.Recordset")
			'��� User name �繪�ͧ��ҧ�ʴ������ ������ ���������� �Ѻ �������������ҧ
			'��� ������ ��ҧ user �����ҧ ������������ҧ �� admin
			'��������ҧ��� ��� �繤�ᷧ
			'¡��ԡ
			if 1=0 then
			if buser = "" and bdealer <> "" and bpass <> "" then ' ������
				response.write "<script language='JavaScript'>alert('��سҵ�Ǩ�ͺ��� Log In ��س� Log In �繤�ᷧ�ͧ�����ͷ���ͧ�����...');document.FORM1.button1.disabled=false;</script>"
			elseif buser <> "" and bdealer = "" and bpass <> "" then ' admin
				response.write "<script language='JavaScript'>alert('��سҵ�Ǩ�ͺ��� Log In ��س� Log In �繤�ᷧ�ͧ�����ͷ���ͧ�����...');document.FORM1.button1.disabled=false;</script>"
			elseif buser <> "" and bdealer <> "" and bpass <> "" then '��ᷧ
				strSql = "SELECT     sc_user.*, sc_user_1.user_name AS dealer_fname FROM         sc_user INNER JOIN sc_user sc_user_1 ON sc_user.create_by = sc_user_1.user_id " _
					& "Where (sc_user.user_name='" & buser & "' or sc_user.login_id='"& buser &"')  And sc_user.user_disable=0 "
				strSql = strSql & " And (sc_user_1.user_name ='" & bdealer & "' or sc_user_1.login_id='" & bdealer & "') and sc_user.user_type='P'"
			end if
			end if
			strSql = "Select * From sc_user Where user_type<>'W' and login_id='" & buser & "' and user_password='" & bpass & "' "
			if trim(strSql) <> "" then
				bdealer=0
				bplayer=0

				rs.Open strSql,conn
				if not rs.eof then
					RndPw = Mid(rs("user_password"),1,1)
					strPw = Request("password1")
					if strPw = rs("user_password") then
						chkOk = "yes"
						bdealer=rs("create_by")
						bplayer=rs("user_id")
						if bweb <> "" then
							'comment �����ѧ�������˵ؼ�  ��������͡���� web
							Session("uid") = rs("create_by")
						end if
						if CheckGame(bdealer)<>"OPEN" then
							chkOk = "CLOSE"
						end If
						'��Ǩ�ͺ �ӹǹ�Թ limite credit
						strSql = "exec spJSelectPlayerDet " & bplayer & ", " & Session("gameid")
						Dim objRS2 
						can_play=0
						set objRS2 = conn.execute(strsql,,1)
						If Not objRS2.Eof Then
							If CDbl(objRS2("limit_play"))>0 then
								limit_play=CDbl(objRS2("limit_play"))
							Else
								limit_play=0
							End if
							If CDbl(objRS2("sum_play"))>0 then
								sum_play=CDbl(objRS2("sum_play"))
							Else
								sum_play=0
							End If								
							If ( CDbl(objRS2("limit_play")) - CDbl(objRS2("sum_play")) ) > 0 Then
								can_play=CDbl(objRS2("limit_play")) - CDbl(objRS2("sum_play"))
							Else
								can_play=0
							End If				
						End If
						If can_play <= 0  Then 
							chkOk = "FULL"
						Else
							sumChkCr = 0
							arrMoney=split(Request("txt2upmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt3upmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt3todmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt2todmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt1upmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt1downmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt2downmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							arrMoney=split(Request("txt3downmoney"),",")
							for i = 0 to Ubound(arrMoney)
								if len(trim(arrMoney(i)))<>0 then
									sumChkCr = sumChkCr + arrMoney(i)
								else
									exit for
								end if
							next						
							If can_play < sumChkCr Then chkOk = "FULL"
						End If 				
						' Check Credit ��͹ ���������ǡ������ �Ţ���  11/2/53
						txt2upNew = "": txt2upmoneyNew = ""
						txt3upNew = "": txt3upmoneyNew = ""
						txt3todNew = "": txt3todmoneyNew = ""
						txt2downNew = "": txt2downmoneyNew = ""
						If chkOK <> "FULL" And chkOK <> "CLOSE" Then 
							strSql="exec spJ_GetNumberLimitMoney "  & bplayer & ", " & Session("gameid")
							'get ��� �Ţ����� 11/2/53
							Set objRS4=conn.execute(strSql)
							If Not objRS4.eof Then
 								'����Ţ���еѴ�� �礡Ѻ �Ţ��� ��Ҿ���еѴ�͡�ҡ����� 11/2/53
								arrNumber2up=split(Request("txt2up"),",")
								arrMoney2up=split(Request("txt2upmoney"),",")						
								arrNumber3up=split(Request("txt3up"),",")
								arrMoney3up=split(Request("txt3upmoney"),",")						
								arrNumber3tod=split(Request("txt3tod"),",")
								arrMoney3tod=split(Request("txt3todmoney"),",")						
								arrNumber2down=split(Request("txt2down"),",")
								arrMoney2down=split(Request("txt2downmoney"),",")						
								While Not objRS4.eof
 								'check �Ţ��� 2 ��
									for i = 0 to Ubound(arrNumber2up)
										if trim(arrNumber2up(i)) = Trim(objRs4("number_up2")) then
											arrNumber2up(i) = ""
											arrMoney2up(i)=""
											chkOk = "LIMIT"
											Exit For 
										End If 
									Next
 								'check �Ţ��� 3 ��
									for i = 0 to Ubound(arrNumber3up)
										if trim(arrNumber3up(i)) = Trim(objRs4("number_up3")) then
											arrNumber3up(i) = ""
											arrMoney3up(i)=""
											chkOk = "LIMIT"
											Exit For 
										End If 
									Next
 								'check �Ţ��� 3 ��
									for i = 0 to Ubound(arrNumber3tod)
										if trim(arrNumber3tod(i)) = Trim(objRs4("number_tod3")) then
											arrNumber3tod(i) = ""
											arrMoney3tod(i)=""
											chkOk = "LIMIT"
											Exit For 
										End If 
									Next
 								'check �Ţ��� 2 ��ҧ
									for i = 0 to Ubound(arrNumber2down)
										if trim(arrNumber2down(i)) = Trim(objRs4("number_down2")) then
											arrNumber2down(i) = ""
											arrMoney2down(i)=""
											chkOk = "LIMIT"
											Exit For 
										End If 
									Next
									
									objRS4.MoveNext
								Wend
 								'�Ѵ�Ţ��� 2 �� �͡
								for i = 0 to Ubound(arrNumber2up)
									If arrNumber2up(i) <> "" Then 
										If txt2upNew <> "" Then txt2upNew = txt2upNew & ","
										If txt2upmoneyNew <> "" Then txt2upmoneyNew = txt2upmoneyNew & ","
										
										txt2upNew = txt2upNew & arrNumber2up(i)
										txt2upmoneyNew = txt2upmoneyNew & arrMoney2up(i)
									End if
								Next								
 								'�Ѵ�Ţ��� 3 �� �͡
								for i = 0 to Ubound(arrNumber3up)
									If arrNumber3up(i) <> "" Then 
										If txt3upNew <> "" Then txt3upNew = txt3upNew & ","
										If txt3upmoneyNew <> "" Then txt3upmoneyNew = txt3upmoneyNew & ","
										
										txt3upNew = txt3upNew & arrNumber3up(i)
										txt3upmoneyNew = txt3upmoneyNew & arrMoney3up(i)
									End if
								next
 								'�Ѵ�Ţ��� 3 �� �͡
								for i = 0 to Ubound(arrNumber3tod)
									If arrNumber3tod(i) <> "" Then 
										If txt3todNew <> "" Then txt3todNew = txt3todNew & ","
										If txt3todmoneyNew <> "" Then txt3todmoneyNew = txt3todmoneyNew & ","
										
										txt3todNew = txt3todNew & arrNumber3tod(i)
										txt3todmoneyNew = txt3todmoneyNew & arrMoney3tod(i)
									End if
								next
 								'�Ѵ�Ţ��� 2 ��ҧ �͡
								for i = 0 to Ubound(arrNumber2down)
									If arrNumber2down(i) <> "" Then 
										If txt2downNew <> "" Then txt2downNew = txt2downNew & ","
										If txt2downmoneyNew <> "" Then txt2downmoneyNew = txt2downmoneyNew & ","
										
										txt2downNew = txt2downNew & arrNumber2down(i)
										txt2downmoneyNew = txt2downmoneyNew & arrMoney2down(i)
									End if
								next														
							End if
						End If 
						'���� �������ҧ��ҧ��������Ѻ �Թᷧ����Թ limit ��  11/2/53
%>
<FORM id=FORM2 name=FORM2 action="dealer_tudroum_act.asp" method=post>
<INPUT TYPE=hidden name='tud1' value="<%=Request("tud1")%>">
<INPUT TYPE=hidden name='tud2' value="<%=Request("tud2")%>">
<INPUT TYPE=hidden name='tud3' value="<%=Request("tud3")%>">
<INPUT TYPE=hidden name='tud4' value="<%=Request("tud4")%>">
<INPUT TYPE=hidden name='tud5' value="<%=Request("tud5")%>">
<INPUT TYPE=hidden name='tud6' value="<%=Request("tud6")%>">
<INPUT TYPE=hidden name='tud7' value="<%=Request("tud7")%>">
<INPUT TYPE=hidden name='tud8' value="<%=Request("tud8")%>">
<INPUT TYPE=hidden name='2upcuttype' value="<%=Request("2upcuttype")%>">
<INPUT TYPE=hidden name='3upcuttype' value="<%=Request("3upcuttype")%>">
<INPUT TYPE=hidden name='3todcuttype' value="<%=Request("3todcuttype")%>">
<INPUT TYPE=hidden name='2downcuttype' value="<%=Request("2downcuttype")%>">
<%
	If txt2upNew <> "" then
%>
<INPUT TYPE=hidden name='txt2up' value="<%=txt2upNew%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=txt2upmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt2up' value="<%=Request("txt2up")%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=Request("txt2upmoney")%>">
<%
	End If 
	If txt3upNew <> "" then
%>
<INPUT TYPE=hidden name='txt3up' value="<%=txt3upNew%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=txt3upmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt3up' value="<%=Request("txt3up")%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=Request("txt3upmoney")%>">
<%
	End If 
	If txt3todNew <> "" then
%>
<INPUT TYPE=hidden name='txt3tod' value="<%=txt3todNew%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=txt3todmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt3tod' value="<%=Request("txt3tod")%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=Request("txt3todmoney")%>">
<%
	End If 
	If txt2downNew <> "" then
%>
<INPUT TYPE=hidden name='txt2down' value="<%=txt2downNew%>">
<INPUT TYPE=hidden name='txt2downmoney' value="<%=txt2downmoneyNew%>">
<%
	Else 
%>
<INPUT TYPE=hidden name='txt2down' value="<%=Request("txt2down")%>">
<INPUT TYPE=hidden name='txt2downmoney' value="<%=Request("txt2downmoney")%>">
<%
	End If 
%>
<INPUT TYPE=hidden name='txt2tod' value="<%=Request("txt2tod")%>">
<INPUT TYPE=hidden name='txt2todmoney' value="<%=Request("txt2todmoney")%>">
<INPUT TYPE=hidden name='2todcuttype' value="<%=Request("2todcuttype")%>">
<INPUT TYPE=hidden name='txt1up' value="<%=Request("txt1up")%>">
<INPUT TYPE=hidden name='txt1upmoney' value="<%=Request("txt1upmoney")%>">
<INPUT TYPE=hidden name='1upcuttype' value="<%=Request("1upcuttype")%>">
<INPUT TYPE=hidden name='txt1down' value="<%=Request("txt1down")%>">
<INPUT TYPE=hidden name='txt1downmoney' value="<%=Request("txt1downmoney")%>">
<INPUT TYPE=hidden name='1downcuttype' value="<%=Request("1downcuttype")%>">
<INPUT TYPE=hidden name='txt3down' value="<%=Request("txt3down")%>">
<INPUT TYPE=hidden name='txt3downmoney' value="<%=Request("txt3downmoney")%>">
<INPUT TYPE=hidden name='3downcuttype' value="<%=Request("3downcuttype")%>">

<INPUT TYPE=hidden name='sendfrom' value="<%=Request("sendfrom")%>">
<INPUT TYPE=hidden name='sendto' value="<%=Request("sendto")%>">
<INPUT TYPE=hidden name='sendtype' value="<%=Request("sendtype")%>">			
<INPUT TYPE=hidden name='sendweb' value="<%=Request("sendweb")%>">
<INPUT TYPE=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
<INPUT TYPE=hidden name="fromweb" value="<%=Request("fromweb")%>">			
<INPUT TYPE=hidden name="cutallid" value="<%=Request("cutallid")%>">			
<INPUT TYPE=hidden name="tkid" value="<%=Request("tkid")%>">			
<INPUT TYPE=hidden name="resend" value="<%=Request("resend")%>">			
</FORM>

<%
						' ############ end  ���� �������ҧ��ҧ��������Ѻ �Թᷧ����Թ limit �� 11/2/53

						'response.write "��������� " & can_play & " limit  " & limit_play & " sum " & sum_play & " cut " & Request("cutallid")
						'response.end
						'check ���ʹ֧ game id �ͧ user �Ѩ�غѹ����
						call CheckGame(Session("uid"))
					end if
				end if
				set rs = nothing
'showstr "here   "  & chkOk
				response.write "<script language='JavaScript'>senddealer('"&chkOk&"',"&bdealer&","&bplayer&",'"&bweb&"');</script>"
			end if  '  strsql <> ''
		end if   ' ��������͡ �������


'				else
'					response.redirect bweb & "dealer_tudroum_send.asp?chk="&chkOk&"&todealer="&bdealer&"&sendfrom="&bplayer&"&toweb="&bweb&"&sendback=yes"
'				end if
'			end if

	end if
%>

<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<STYLE TYPE="text/css">
	<!--
    A:link {text-decoration: none;}  
    A:visited {text-decoration: none;}   
	-->
</STYLE>
<SCRIPT FOR=window EVENT=onload LANGUAGE="JScript">
	document.FORM1.txtUserName.focus();
</SCRIPT>

</HEAD>
<BODY leftmargin=0 topmargin=0>

<FORM id=FORM1 name=FORM1 action="dealer_tudroum_send.asp" method=post>

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



<TABLE WIDTH="400" height="160" ALIGN=center BORDER=1 CELLSPACING=0 CELLPADDING=0 >
	<TR>
		<TD>

<TABLE WIDTH="100%" BORDER=0 CELLSPACING=0 CELLPADDING=0 bgColor=white>
	<TR class=head_white bgColor=red>
		<TD align=middle colspan=4>��س� Log in ���� User <br>�ͧ�����ͷ��س��ͧ����觵��</TD>
	</TR>
	<TR class=text_blue>
		<TD colspan=1 align=middle>�觢��� WEB ��</TD>		
		<TD colspan=3 align=middle>   &nbsp;</TD>		
	</TR>
	<TR class=text_blue>
		<TD rowspan=4>
<%
	if sendweb <> "" and bweb = "" then sendweb = ""
	call ShowListView("sc_user", "user_name", "user_id", "sendweb", sendweb, "create_by=" & Session("uid") & " and user_type='W'" ,true, 150, "onChange='document.FORM1.submit();'")
%>					
		</TD>
<!-- 	��Ѻ����� login ��  2  box  ����͹��� login ���� 6/6/09	
		<TD>&nbsp;&nbsp;�����</TD>
		<TD><INPUT id=text1 name=txtdealer style="WIDTH: 130px" 
            width=200 onKeyDown="txtdealer_checkkey();" value="<%=bdealer %>"></TD>
		<TD></TD>
	</TR>
	<TR class=text_blue> -->
		<TD>&nbsp;&nbsp;���ͼ����</TD>
		<TD><INPUT id=text1 name=txtUserName style="WIDTH: 130px" 
            width=200 onKeyDown="txtUserName_checkkey();" value="<%=buser%>" readonly></TD>
		<TD></TD>
	</TR>
	<TR class=text_blue>
		<TD>&nbsp;&nbsp;���ʼ�ҹ</TD>
		<TD><INPUT id=password1 type=password 
            name=password1 style="WIDTH: 130px; HEIGHT: 22px" width=200 size=21 
            onKeyDown="password1_checkkey();" value="<%=bpass%>" readonly></TD>
		<TD></TD>
	</TR>
        <TR>
          
          <TD colspan=3 align=middle><INPUT id=button1 type=button align=left value="��������" class="inputE" name=button1 style="cursor:hand; width: 100px;"  onClick="document.FORM1.button1.disabled=true;return clicksubmit();"><input type=button value=" �Դ " class="inputR" style="cursor:hand; width: 90px;" onClick="window.close();" ></TD></TR>
</TABLE>

</TD>
	</TR>
</TABLE>
<!-- <input type=hidden name="sendfrom" value="<%=Request("sendfrom")%>">
<input type=hidden name="sendto" value="<%=Request("sendto")%>">
<input type=hidden name="sendtype" value="<%=Request("sendtype")%>"> -->
<input type=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
<input type=hidden name="fromweb" value="<%=Session("web1url")%>">			

<Input type=hidden name=act value="log">
<Input type=hidden name=sendback value="">
<Input type=hidden name=toweb value="<%=bweb%>">
<Input type=hidden name=mygoto value='dealer_tudroum.asp'>
<Input type=hidden name=cutallid value='<%=Request("cutallid")%>'>
<Input type=hidden name=tkid value='<%=Request("tkid")%>'>
<Input type=hidden name=resend value='<%=Request("resend")%>'>
</FORM>
</BODY>
</HTML>
