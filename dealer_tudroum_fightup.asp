<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
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
			//alert("web1 " + document.FORM1.toweb.value);
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
//			window.close();
		} else if (chk=="CLOSE")	{
			alert("�������ö�������͹���� ���ͧ�ҡ�����ͻԴ�Ѻᷧ����...");
		} else {
			//document.FORM2.txtdealer.value="";
			document.FORM2.txtUserName="";
			document.FORM2.password1="";
			document.FORM2.sendto.value="";
			document.FORM2.sendfrom.value="";
			document.FORM2.sendweb.value="";
			document.FORM2.sendweb2.value="";		
			alert("��� Log In ���١��ͧ ! ��س��ͧ����...");
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
	dim objRS
	dim sendweb
	if Request("sendback")="yes" then 
		' �����ӷ�� web 2 ����
		' �� user ��� web 2 �ʴ���Ҷ١���Ҩҡ web  1
		' ¡��ԡ �� txtdealer

		chkOk = "no"
		strSql = "SELECT     sc_user.*, sc_user_1.user_name AS dealer_fname FROM         sc_user INNER JOIN sc_user sc_user_1 ON sc_user.create_by = sc_user_1.user_id " _
			& "Where (sc_user.user_name='" & Request("txtUserName") & "' or sc_user.login_id='"& Request("txtUserName") &"') and sc_user.user_password = '" & Request("password1") & "' And sc_user.user_disable=0 "
		strSql = strSql & " and sc_user.user_type='P'"
		'strSql = strSql & " And (sc_user_1.user_name ='" & Request("txtdealer") & "' or sc_user_1.login_id='" & Request("txtdealer") & "') and sc_user.user_type='P'"
'showstr strSql
		set rs = conn.execute(strsql,,1)
		if not rs.Eof then
			chkOK = "yes"
			bdealer=rs("create_by")
			bplayer=rs("user_id")
			' comment �����ѧ�������˵ؼ�
			Session("uid") = rs("create_by")
			if CheckGame(bdealer)<>"OPEN" then
				chkOk = "CLOSE"
			end if
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
<INPUT TYPE=hidden name='sendweb' value="<%=Request("sendweb")%>">
<INPUT TYPE=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
<INPUT TYPE=hidden name="fromweb" value="<%=Request("fromweb")%>">			
</FORM>
<%
		'showstr Request("txt2up")

		response.write "<script language='JavaScript'>senddealer('"&chkOK&"',"&bdealer&","&bplayer&",'"&Request("toweb")&"');</script>"
	end if
	if Request("act")="log" then
			buser=""
			bpass=""
			bdealer=""
			bweb = ""
			sendweb = ""
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
<INPUT TYPE=hidden name='sendweb' value="<%=Request("sendweb")%>">
<INPUT TYPE=hidden name="sendweb2" value="<%=Request("sendweb2")%>">			
<INPUT TYPE=hidden name="fromweb" value="<%=Request("fromweb")%>">			
</FORM>
	<%
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
							'comment �����ѧ�������˵ؼ�
							'Session("uid") = rs("create_by")
						end if
						if CheckGame(bdealer)<>"OPEN" then
							chkOk = "CLOSE"
						end if
						'check ���ʹ֧ game id �ͧ user �Ѩ�غѹ����
						call CheckGame(Session("uid"))
					end if
				end if
				set rs = nothing

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
<!--
============  ��Ѻ�Ţ�óշ������麹 ===============  26/10/52
����Ѻ�Ţ�¡�� �ӹǹ�Թ�����������Ţ * �ӹǹ����  / ���¨ӹǹᷧ�͡

get ��� �ӹǹ���� ��� �ӹǹᷧ�͡
-->
<%
Dim  rsPricePO
Dim pay2up, pay3up, pay3tod, pay2tod, pay1up
Dim out2up, out3up, out3tod, out2tod, out1up
Dim arrMoney
Dim txtReturn2Up, txtReturn3Up, txtReturn3Tod, txtReturn1Up
Dim txtNewVal, i

			strSql = "exec spA_Get_PriceDealer_Pay_Out " & Session("gameid") & "," & Session("uid")  
			set rsPricePO = conn.execute(strSql,,1)
			if not rsPricePO.Eof then
				pay2up=trim(rsPricePO("pay2up"))
				pay3up=trim(rsPricePO("pay3up"))
				pay3tod=trim(rsPricePO("pay3tod"))
				pay2tod=trim(rsPricePO("pay2tod"))
				pay1up=trim(rsPricePO("pay1up"))
				out2up=trim(rsPricePO("out2up"))
				out3up=trim(rsPricePO("out3up"))
				out3tod=trim(rsPricePO("out3tod"))
				out2tod=trim(rsPricePO("out2tod"))
				out1up=trim(rsPricePO("out1up"))

				' �ӹǹ 2up
				If pay2up > 0 And out2up > 0 Then 
					arrMoney=split(Request("txt2upmoney"),",")
					for i = 0 to Ubound(arrMoney)
						if len(trim(arrMoney(i)))<>0 Then
							txtNewVal=Round(((arrMoney(i) * pay2up) / out2up),0)
						else
							txtNewVal = arrMoney(i)
						end If
						If i > 0 Then txtReturn2Up=txtReturn2Up & ","
						txtReturn2Up=txtReturn2Up & txtNewVal
					next
				Else 
					txtReturn2Up=Request("txt2upmoney")
				End if

				' �ӹǹ 3up
				If pay3up > 0 And out3up > 0 Then 
					arrMoney=split(Request("txt3upmoney"),",")
					for i = 0 to Ubound(arrMoney)
						if len(trim(arrMoney(i)))<>0 Then
							txtNewVal=Round(((arrMoney(i) * pay3up) / out3up),0)
						else
							txtNewVal = arrMoney(i)
						end If
						If i > 0 Then txtReturn3Up=txtReturn3Up & ","
						txtReturn3Up=txtReturn3Up & txtNewVal
					next
				Else 
					txtReturn3Up=Request("txt3upmoney")
				End if

				' �ӹǹ 3tod
				If pay3tod > 0 And out3tod > 0 Then 
					arrMoney=split(Request("txt3todmoney"),",")
					for i = 0 to Ubound(arrMoney)
						if len(trim(arrMoney(i)))<>0 Then
							txtNewVal=Round(((arrMoney(i) * pay3tod) / out3tod),0)
						else
							txtNewVal = arrMoney(i)
						end If
						If i > 0 Then txtReturn3Tod=txtReturn3Tod & ","
						txtReturn3Tod=txtReturn3Tod & txtNewVal
					next
				Else 
					txtReturn3Tod=Request("txt3todmoney")
				End if

				' �ӹǹ 1up
				If pay1up > 0 And out1up > 0 Then 
					arrMoney=split(Request("txt1upmoney"),",")
					for i = 0 to Ubound(arrMoney)
						if len(trim(arrMoney(i)))<>0 Then
							txtNewVal=Round(((arrMoney(i) * pay1up) / out1up),0)
						else
							txtNewVal = arrMoney(i)
						end If
						If i > 0 Then txtReturn1Up=txtReturn1Up & ","
						txtReturn1Up=txtReturn1Up & txtNewVal
					next
				Else 
					txtReturn1Up=Request("txt1upmoney")
				End if
			
			end If  ' end rsPricePO EOF  , , , 
'response.write  txtReturn2Up & "<br>"			
'response.write  txtReturn3Up & "<br>"			
'response.write  txtReturn3Tod & "<br>"			
'response.write  txtReturn1Up & "<br>"			
%>
<INPUT TYPE=hidden name='tud1' value="<%=Request("tud1")%>">
<INPUT TYPE=hidden name='tud2' value="<%=Request("tud2")%>">
<INPUT TYPE=hidden name='tud3' value="<%=Request("tud3")%>">
<INPUT TYPE=hidden name='tud4' value="<%=Request("tud4")%>">
<INPUT TYPE=hidden name='tud5' value="<%=Request("tud5")%>">
<INPUT TYPE=hidden name='tud6' value="<%=Request("tud6")%>">
<INPUT TYPE=hidden name='tud7' value="<%=Request("tud7")%>">
<INPUT TYPE=hidden name='tud8' value="<%=Request("tud8")%>">
<INPUT TYPE=hidden name='txt2up' value="<%=Request("txt2up")%>">
<INPUT TYPE=hidden name='txt2upmoney' value="<%=txtReturn2Up%>">
<INPUT TYPE=hidden name='2upcuttype' value="<%=Request("2upcuttype")%>">
<INPUT TYPE=hidden name='txt3up' value="<%=Request("txt3up")%>">
<INPUT TYPE=hidden name='txt3upmoney' value="<%=txtReturn3Up%>">
<INPUT TYPE=hidden name='3upcuttype' value="<%=Request("3upcuttype")%>">
<INPUT TYPE=hidden name='txt3tod' value="<%=Request("txt3tod")%>">
<INPUT TYPE=hidden name='txt3todmoney' value="<%=txtReturn3Tod%>">
<INPUT TYPE=hidden name='3todcuttype' value="<%=Request("3todcuttype")%>">
<INPUT TYPE=hidden name='txt2tod' value="<%=Request("txt2tod")%>">
<INPUT TYPE=hidden name='txt2todmoney' value="<%=Request("txt2todmoney")%>">
<INPUT TYPE=hidden name='2todcuttype' value="<%=Request("2todcuttype")%>">
<INPUT TYPE=hidden name='txt1up' value="<%=Request("txt1up")%>">
<INPUT TYPE=hidden name='txt1upmoney' value="<%=txtReturn1Up%>">
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
		<TD rowspan=5>
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
          
          <TD colspan=3 align=middle><INPUT id=button1 type=button align=left value="��������" class="inputE" name=button1 style="cursor:hand; width: 100px;"  onClick="document.FORM1.button1.disabled=true;return clicksubmit();"><input type=button class="inputR" value=" �Դ " style="cursor:hand; width: 90px;" onClick="window.close();" ></TD></TR>
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
</FORM>
</BODY>
</HTML>
