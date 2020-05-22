<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% 'check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
Session("p1recmulti") = "true"
Dim strSql
Dim st_blink, 	ed_blink
'-- jum 2007-08-21
Dim mode,game_type
mode=request("mode")
game_type=request("game_type")
If mode="chg_game_type" Then
	strSql="update tb_open_game set game_type=" & game_type & " where dealer_id=" & Session("uid")	 & _
	" and game_active='A' "
	conn.Execute(strSql)
End If
Dim objRS
Set objRS =Server.CreateObject("ADODB.Recordset")		
strSql="exec spGetGame_Type_by_dealer_id " & Session("uid")	
Set objRS=conn.Execute(strSql)
if not objRS.eof then
	game_type=objRS("game_type")
End If
objRS.close

'-- jum 2007-08-21
Dim objRec
dim recNum

Dim cntApp
dim chkRow
dim strdel
dim strTmp
dim cutInd
dim arrCut
dim orderby
dim refreshtime
dim tmpColColor
dim i
Set objRec = Server.CreateObject ("ADODB.Recordset")
Set recNum = Server.CreateObject ("ADODB.Recordset")

tmpColColor= "#FFFFFF" '"#99FFFF"

	redim arrCut(1,1)
	'*** Open the database.	

	
'	Session("p1order")=Request("cmborder")
'	Session("p1numtype")=Session("p1numtype")

	if Request("p1order")="num" then 
		Session("p1order")="money"
	elseif Request("p1order")="money" then
		Session("p1order")="num"
	elseif Request("p1order")="" then
		if Session("p1order")="" then
			Session("p1order")="money"
		end if
	end if
	if Request("cmbnumtype")="" then
		Session("p1numtype")="rec"
	else
		Session("p1numtype")=Request("cmbnumtype")
	end if
'	if Request("p1numtype")="all" then 
'		Session("p1numtype")="rec"
'	elseif Request("p1numtype")="rec" then 
'		Session("p1numtype")="out"
'	elseif Request("p1numtype")="out" then
'		Session("p1numtype")="all"
'	elseif Request("p1numtype")="" then
'		if 	Session("p1numtype")="" then
'			Session("p1numtype")="rec"
'		end if
'	end if

	if Request("stoprefresh")  <> "" then
		Session("stoprefresh") = Request("stoprefresh")
	end if
	refreshtime=""
	if Session("stoprefresh") <> "1" then
		refreshtime = Session("refreshtime")
	end if
	if Request("recmulti") <> "" then
		Session("p1recmulti") = Request("recmulti")
	end if
	if Session("p1recmulti")="true" then
		refreshtime=Session("refreshtime") '//  2006-12-20
		'Session("stoprefresh")="1"
	else
		if Session("stoprefresh") <> "1" then
			refreshtime = Session("refreshtime")
		end if
	end if
%>
<HTML>
<HEAD>
<meta http-equiv="refresh" content="" />
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="JavaScript" src="include/js_function.js"></script>
<script Language="VBScript" >	
	'sub cmborder_onClick()
	'	form1.submit()
	'end sub

	'sub cmbnumtype_onClick()
	'	form1.submit()
	'end sub
</script>

<script language="JavaScript">

var start=new Date();
	start=Date.parse(start)/1000;
	var counts="<%=refreshtime%>";
	function CountDown(){
		if (!isNaN(parseInt(counts))) {
			var now=new Date();
			now=Date.parse(now)/1000;
			var x=parseInt(counts-(now-start),10);
			if(document.form1){document.form1.clock.value = x;}
			if(x>0){
				timerID=setTimeout("CountDown()", 100)
			}else{
				location.href="firstpage_dealer.asp"
			}
		} else {
			document.form1.clock.value = "";
		}
	}

	function click_stop_refresh(flg) {
		document.all.form1.stoprefresh.value = flg;
		document.all.form1.submit();
	}

	function changeorder(gorder) {
		document.all.p1order.value=gorder;
		document.all.form1.submit();
	}

	function changenumtype(gorder) {
		document.all.p1numtype.value=gorder;
		document.all.form1.submit();
	}

	function cleargame() {
		if (confirm("�س��ͧ��þ���� ���� �������������� ?")) {
			opensave();
		} else {
			if (confirm("�׹�ѹ�����ҧ�Ţ ?")) {
				document.all.gamestatus.value = "delete"    //"close";
				document.all.form1.submit();		
			}
		}
	}

	function receive_click() {
//		var str, cnt, i
//		cnt = document.form1.multitkid.length;
//		for (i=0;i<=cnt-1;i++) {
//			if (document.form1.multitkid[i].checked) {
//				if (! str=="") {
//					str=str+","
//				}
//				str = str + document.form1.multitkid[i].value;
//			}
//		}
		document.form1.gamestatus.value = "receivemulti";
//		document.form1.multiticket.value = str;
		document.all.form1.submit();		
	}

	function recmulti_click() {
		if (document.all.form1.recmulti.value =="false") {
			document.all.form1.recmulti.value ="true";
		} else {
			document.all.form1.recmulti.value ="false";
		}
		document.all.form1.submit();		
	}

	function changegamestatus(gstatus) {
	var myVal;
		myVal = gstatus.value;
		if (myVal=="�Դ������") {
		//	if (confirm("�س��ͧ��÷ӡ�ûԴ�Ѻᷧ ��������� ?")) {
				document.all.gamestatus.value = "open"    //"close";
				document.all.form1.submit();
		//	}
		} else if (myVal=="�Դ������") {
		//	if (confirm("�س��ͧ��÷ӡ���Դ������ ��������� ?")) {
				document.all.gamestatus.value ="close" // "open";
				document.all.form1.submit();
		//	}
		} else if (myVal=="�Դ��ᷧ����Դ������") {
				document.all.gamestatus.value ="key" // "key";
				document.all.form1.submit();
		}

	}

	function shownum(pnum,ptype,numtype) {
		window.open("dealer_viewnumber.asp?pnum="+pnum+"&ptype="+ptype+"&numtype="+numtype,"_blank","top=150,left=150,height=220,width=350,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function opensave() {
		window.open("dealer_save_data.asp","_blank","top=150,left=150,height=350,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}


	function openold() {
		window.open("dealer_open_old.asp","_blank","top=150,left=150,height=350,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}
	
	function change_password () {
		window.open("change_password.asp", "_blank","top=200,left=200,height=180,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function showsendto(gosuu){
		window.open("dealer_check_suu.asp?gosuu="+gosuu, "_blank","top=200,left=200,height=150,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	window.setTimeout('CountDown()',100);
</script>
<script type="text/javascript">
function blinkIt() {
 if (!document.all) return;
 else {
   for(i=0;i<document.all.tags('blink').length;i++){
      s=document.all.tags('blink')[i];
      s.style.visibility=(s.style.visibility=='visible')?'hidden':'visible';
   }
 }
}
</script>
</HEAD>
<BODY topmargin=0 leftmargin=0 onload="setInterval('blinkIt()',500)">
<%
dim sumall
dim typenum1, typenum2, typenum3, typenum4, typenum5, typenum6, typenum7, typenum8
dim strOpen
dim strOrder

	if Request("gamestatus") = "open" then
		strSql = "Update tb_open_game set game_status=1 Where game_id="&Session("gameid")
		comm.CommandText = strSql
		comm.CommandType = adCmdText
		comm.Execute

'		strSql = "Insert Into tb_open_game(dealer_id, game_type, set_date, game_status,	game_active) values " _
'			& "("&Session("uid")&", 1, GetDate(), 1,'A')"
'		comm.CommandText = strSql
'		comm.CommandType = adCmdText
'		comm.Execute
		
		Response.redirect "firstpage_dealer.asp"		
	elseif Request("gamestatus") = "close" then
		strSql = "Update tb_open_game set close_date=Getdate(), game_status=0 Where game_id="&Session("gameid")
		comm.CommandText = strSql
		comm.CommandType = adCmdText
		comm.Execute
		
		Response.redirect "firstpage_dealer.asp"	
	elseif Request("gamestatus") = "key" then
		strSql = "Update tb_open_game set close_date=Getdate(), game_status=2 Where game_id="&Session("gameid")
		comm.CommandText = strSql
		comm.CommandType = adCmdText
		comm.Execute
		
		Response.redirect "firstpage_dealer.asp"	
	elseif Request("gamestatus") = "delete" then
		strSql = "exec spA_ChangePasswordOverLimit " & Session("uid") & ", " & Session("gameid") 
		set objRec=conn.Execute(strSql)			

		strSql = ""
		comm.CommandText = "spDealerClearNumber"
		comm.CommandType = adCmdStoredProc
		comm.Parameters.Append comm.CreateParameter("@gameid"		,adInteger  ,adParamInput, ,Session("gameid"))
		comm.Execute
		
		Response.redirect "firstpage_dealer.asp"	
	elseif Request("gamestatus") = "receivemulti" then
		dim tkid, arrTk
		tkid = Request("multitkid")
		if tkid <> "" then
			arrTk = split(tkid,",")
			for i = 0 to Ubound(arrTk)
				strSql="exec spUpd_ticket_status_by_ticket_id " & arrTk(i)
				set objRec=conn.Execute(strSql)

				strSql = "Update tb_ticket set rec_date=GetDate() where ticket_id = "  & arrTk(i)
				set objRec=conn.Execute(strSql)			
			next
			Response.redirect "firstpage_dealer.asp"	
		end if
	end if

	strOpen="�Դ������"
	strOrder="���§�Ţ"
	if CheckGame(Session("uid"))="OPEN" then strOpen="�Դ������"
	if CheckGame(Session("uid"))="KEY" then strOpen="�Դ��ᷧ����Դ������"
	'//----- jum edit 2005-07-27 -----
	Dim op1,op2, op3
	op1=""
	op2=""
	op3=""
	select case strOpen 
		case "�Դ������"
			op1="selected"
		case "�Դ������"
			op2="selected"
		case "�Դ��ᷧ����Դ������"
			op3="selected"
	end select
	'//----- jum edit 2005-07-27 -----
	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	strSql=""
	if Session("p1numtype")="all" or Session("p1numtype")="" then	
'		strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
'			& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
'			& "WHERE (tb_ticket.game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status in (2,3)) AND (tb_ticket_number.sum_flag = 'Y')  " _   
'			& "GROUP BY tb_ticket_number.play_type"
			'And (tb_ticket.ticket_status='A')
			strSql = "exec spA_GetSumAmt_by_Type " & Session("gameid") & ", 'all'" 
	elseif Session("p1numtype")="rec" then
'		strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
'			& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
'			& "WHERE (tb_ticket.game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status in (2,3)) AND (tb_ticket_number.sum_flag = 'Y')  " _
'			& "GROUP BY tb_ticket_number.play_type"
			' And (tb_ticket.ticket_status='A')
			strSql = "exec spA_GetSumAmt_by_Type " & Session("gameid") & ", 'rec'" 
	elseif Session("p1numtype")="out" then
'		strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
'			& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
'			& "WHERE (tb_ticket.ref_game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y')  And (tb_ticket.ticket_status='A') " _
'			& "GROUP BY tb_ticket_number.play_type"
			strSql = "exec spA_GetSumAmt_by_Type " & Session("gameid") & ", 'cut'"

'		strSql = "SELECT     tb_cut_all.game_id, tb_cut_all_det.play_type, SUM(tb_cut_all_det.play_amt) AS sum_amt " _
'			& "FROM         tb_cut_all INNER JOIN  tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'			& "GROUP BY tb_cut_all.game_id, tb_cut_all_det.play_type " _
'			& "HAVING      (tb_cut_all.game_id = "& Session("gameid") &") " _
'			& "ORDER BY tb_cut_all_det.play_type " 
	end if
'showstr strSql
	set objRec=conn.Execute(strSql)
	if not objRec.eof then
		do while not objRec.eof
			'if objRec("play_type")=1 then
			select case objRec("play_type")				
				case 1
					typenum1 = objRec("sum_amt")
				case 2
					typenum2 = objRec("sum_amt")
				case 3
					typenum3 = objRec("sum_amt")
				case 4
					typenum4 = objRec("sum_amt")
				case 5
					typenum5 = objRec("sum_amt")
				case 6
					typenum6 = objRec("sum_amt")
				case 7
					typenum7 = objRec("sum_amt")
				case 8
					typenum8 = objRec("sum_amt")
			end select
			sumall=sumall + objRec("sum_amt")
			objRec.movenext
		loop
	end if
	objRec.Close
	

'******************* �ҹ��� ��������� 
if 1=0 then
	if Session("p1numtype")="rec" or Session("p1numtype")="all" then
'		strSql = "SELECT     tb_cut_all.game_id, tb_cut_all_det.play_type, SUM(tb_cut_all_det.play_amt) AS sum_amt " _
'			& "FROM         tb_cut_all INNER JOIN  tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id " _
'			& "GROUP BY tb_cut_all.game_id, tb_cut_all_det.play_type " _
'			& "HAVING      (tb_cut_all.game_id = "& Session("gameid") &") " _
'			& "ORDER BY tb_cut_all_det.play_type " 
		if Session("p1numtype")="rec" then
			strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
				& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
				& "WHERE (tb_ticket.ref_game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y')  And (tb_ticket.ticket_status='A') " _
				& "GROUP BY tb_ticket_number.play_type"
		elseif  Session("p1numtype")="all"  then 
			strSql = "SELECT tb_ticket_number.play_type, (SUM(tb_ticket_number.dealer_rec) * -1) AS sum_amt " _
				& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
				& "WHERE (tb_ticket.ref_game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y')  And (tb_ticket.ticket_status='A') " _
				& "GROUP BY tb_ticket_number.play_type"
		end if
'showstr strSql
		objRec.Open strSql, conn
		if not objRec.eof then
			do while not objRec.eof
				'if objRec("play_type")=1 then
				select case cint(objRec("play_type"))
					case 1
						typenum1 = typenum1-objRec("sum_amt")
					case 2
						typenum2 = typenum2-objRec("sum_amt")
					case 3
						typenum3 = typenum3-objRec("sum_amt")
					case 4
						typenum4 = typenum4-objRec("sum_amt")
					case 5
						typenum5 = typenum5-objRec("sum_amt")
					case 6
						typenum6 = typenum6-objRec("sum_amt")
					case 7
						typenum7 = typenum7-objRec("sum_amt")
					case 8
						typenum8 = typenum8-objRec("sum_amt")
				end select
				sumall=sumall - objRec("sum_amt")
				objRec.movenext
			loop
		end if
		objRec.Close
	end if
end if   '************** ���������   
%>
<FORM id=form1 name=form action="firstpage_dealer.asp" method=post>
	<input type="hidden" name="mode">
	<input type="hidden" name="game_type">
	
	<TABLE width='95%' align=center class=table_blue border="0">      
 			<tr>
				<td colspan=1 class=button_green onClick="gotoPage('dealer_tudroum.asp')" align=center 
					onMouseOver="changeStyle(this,'button_green_over')"
					onMouseOut="changeStyle(this,'button_green')">�Ѵ�Ţ</td>
				<td colspan=5 class=button_green onClick="showsendto('U')" align=center
					onMouseOver="changeStyle(this,'button_green_over')"
					onMouseOut="changeStyle(this,'button_green')"
				>��麹</td>
				<td colspan=2 class=button_green onClick="showsendto('D')" align=center
					onMouseOver="changeStyle(this,'button_green_over')"
					onMouseOut="changeStyle(this,'button_green')">�����ҧ</td>
				<td colspan=1 class=button_green onClick="gotoPage('dealer_tudroum.asp?act=out')" 			align=center
					onMouseOver="changeStyle(this,'button_green_over')"
					onMouseOut="changeStyle(this,'button_green')"
				>ᷧ�Ţ�͡</td>
			</tr>   
	<%	'if Request("stoprefresh")="1" then	%>
<!-- 			<tr>
				<td colspan=9 align=right><input type=button name=cmdrefresh value="Refresh �ѵ��ѵ�" class=button_red onClick="click_stop_refresh('0')"></td>
			</tr> -->
	<%	'else	%>
<!-- 			<tr>
				<td colspan=9 align=right><input type=button name=cmdrefresh value="��ش Refresh �ѵ��ѵ�" class=button_red onClick="click_stop_refresh('1')"></td>
			</tr> -->
	<%	'end if	%>
		<tr align=center bgColor=#66CCFF  class=head_black>
			<td width=100><%=sumall%></td>
			<td><%=typenum1%></td>
			<td><%=typenum2%></td>
			<td><%=typenum3%></td>
			<td><%=typenum4%></td>
			<td><%=typenum5%></td>
			<td><%=typenum6%></td>
			<td><%=typenum7%></td>
			<td><%=typenum8%></td>
		</tr>
		<tr align=center class=head_white>
			<td bgColor=#66CCFF><font color="black">�ʹᷧ</font></td>
			<td bgColor=red>2 ��</td>
			<td bgColor=black>3 ��</td>
			<td bgColor=red>3 ��</td>
			<td bgColor=black>2 ��</td>
			<td bgColor=red>��觺�</td>
			<td bgColor=black>�����ҧ</td>
			<td bgColor=red>2 ��ҧ</td>
			<td bgColor=black>3 ��ҧ</td>
		</tr>
		<tr>
			<td valign=top bgcolor=#C0C0C0> <!-- column �á ���� -->
				
				<INPUT TYPE="hidden" name="p1order">
				<INPUT TYPE="hidden" name="p1numtype">
				<INPUT TYPE="hidden" name="multiticket">
				<INPUT TYPE="hidden" name="stoprefresh" value="">
				<INPUT TYPE="hidden" name="recmulti" value="<%=Session("p1recmulti")%>">
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
					<tr>
						<td class=head_blue>
						<input type="button" value="���ê" style="cursor:hand;" onClick="window.open('firstpage_dealer.asp','_self')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						>
						&nbsp;<INPUT TYPE="text" NAME="clock" style="width:45;align:right" VALUE="10"> 
						</td>
					</tr>
					<tr>
						<td>
						<!--
						<input type=button value="<%=strOpen%>" onClick="changegamestatus(this);" Name="cmdgame" class=button_red>
						-->
						<!-------------Jum edit 2005-07-27 ------------------>
						<select name="cmdgame" style="width:100" onChange="changegamestatus(this);" >
							<option value="�Դ������" <%=op1%>>�Դ������</option>
							<option value="�Դ������" <%=op2%>>�Դ������</option>
							<option value="�Դ��ᷧ����Դ������" <%=op3%>>�Դᷧ�Դ����</option>
						</select>
						<INPUT TYPE="hidden" name="gamestatus" value="">
						<!-------------Jum edit 2005-07-27 ------------------>
						</td>
					</tr>
					<tr>
						<td>
<%
								strTmp=""
								if Session("p1order")="num" then 
									strTmp="���§����Ţ"
								elseif Session("p1order")="money" then
									strTmp="���§����Թ"
								end if
%>
							<!----
							<input type=button name="cmborder" value="<%=strTmp%>" class=button_blue onClick="changeorder('<%=Session("p1order")%>');">
							-->
							<!---------------Jum edit 2005-07-27 --------------->
							<%
							Dim selord1, selord2
							select case Session("p1order")
								case "num"
									selord1="selected"
								case "money"
									selord2="selected"
							end select
							%>
							<select style="width:100" name="cmborder" onChange="changeorder('<%=Session("p1order")%>');">
								<option value="num" <%=selord1%>>���§����Ţ</option>
								<option value="money" <%=selord2%>>���§����Թ</option>
							</select>
							<!---------------Jum edit 2005-07-27 --------------->
						</td>
					</tr>
					<tr>
						<td>
<%
								strTmp=""
								if Session("p1numtype")="all" then 
									strTmp="�Ţ�Ѻ������"
								elseif Session("p1numtype")="rec" then 
									strTmp="�Ţ�Ѻ���"
								elseif Session("p1numtype")="out" then 
									strTmp="�Ţᷧ�͡"
								end if

%>
<!---
								<input type=button name="cmbnumtype" value="<%=strTmp%>" class=button_blue onClick="changenumtype('<%=Session("p1numtype")%>');">
-->

								<!-------------------- Jum edit 2005-07-27 ---------------------------->
								<%
								Dim sel1,sel2,sel3
								sel1=""
								sel2=""
								sel3=""
								select case Session("p1numtype")
									case "all"
										sel1="selected"
									case "rec"
										sel2="selected"
									case "out"
										sel3="selected"
									case else
										sel2="selected"
								end select

								%>
								<select style="width:100" name="cmbnumtype" onChange="changenumtype('<%=Session("p1numtype")%>');">
									<option value="all" <%=sel1%>>�Ţ�Ѻ������</option>
									<option value="rec" <%=sel2%>>�Ţ�Ѻ���</option>
									<option value="out" <%=sel3%>>�Ţᷧ�͡</option>
								</select>
								<!-------------------- Jum edit 2005-07-27 ---------------------------->
						</td>
					</tr>
					<tr>
						<td width=20>&nbsp;</td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdsetplayer value="��� WEB ᷧ�͡"  style="width:100" style="cursor:hand;" onClick="gotoPage('dealer_web_config.asp')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdsetplayer value="��駤�ᷧ"  style="width:100" style="cursor:hand;" onClick="gotoPage('price_player_config.asp')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdsetplayer value="��駤�����"  style="width:100" style="cursor:hand;" onClick="gotoPage('user_key.asp')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdbingo value="�Ţ�͡/��Ǩ" style="width:100" style="cursor:hand;" onClick="gotoPage('dealer_check_number.asp')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdalert value="���»�С��" style="width:100" style="cursor:hand;" onClick="gotoPage('mt_alert.asp')"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdclarticket value="��ҧ�Ţ" style="width:100" style="cursor:hand;" onClick="cleargame();"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdclarticket value="�红�����" style="width:100" style="cursor:hand;" onClick="opensave();"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdclarticket value="�٢����ŷ����" style="width:100" style="cursor:hand;" onClick="openold();"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdclarticket value="����¹ Password" style="width:100" style="cursor:hand;" onClick="change_password();"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdclarticket value="�Ըա�ᷧ��" style="width:100" style="cursor:hand;" onClick="download_manual();"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdPrice value="����Ҥҡ�ҧ" style="width:100" style="cursor:hand;"  onClick="gotoPage('price_player_config_dealer.asp?dealer_id=<%=Session("uid")	%>&game_type=<%=game_type%>');"
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"></td>
					</tr>
					<%
					' Jum 2007-08-21 -----
					Dim  pic, SQL
					SQL="exec spGetGame_Type_by_dealer_id " & Session("uid")	
					Set objRec=conn.Execute(SQL)
					if not objRec.eof then
						game_type=objRec("game_type")
						select case  game_type
							case 1
								pic="images/price_gov.jpg"
							case 2
								pic="images/price_tos.jpg"
							case 3
								pic="images/price_oth.jpg"
						end select
					End if
					%>
					<tr>
						<td width=20><img src="<%=pic%>" name="mypic" width="100"  border="0" style="cursor:hand;" onClick="clickpic(<%=game_type%>)"></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdDanger  value="�Ţ�ѹ����" style="width:100" style="cursor:hand;COLOR: red;font-weight:bold;"
						onClick="gotoPage('frmDanger.asp?dealer_id=<%=Session("uid") %>')"	
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20><input type=button name=cmdSum  value="�ʹ��ػ���" style="width:100" style="cursor:hand;"
						onClick="click_cntTicketPlayer('<%=Session("uid") %>')"	
						onMouseOver="changeStyle(this,'button_over')"
						onMouseOut="changeStyle(this,'')"
						></td>
					</tr>
					<tr>
						<td width=20>&nbsp;</td>
					</tr>
				</table>
			</td> <!-- �� column ���� -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ 2 �� -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					dim pAmt
					dim tmpClass
					set objRec = nothing
					set recNum = nothing
					Set objRec = Server.CreateObject ("ADODB.Recordset")
					Set recNum = Server.CreateObject ("ADODB.Recordset")

					'mlnPlayType2Up  Session("gameid")
'//JUM 2008-05-06
strSql = "exec spGetPlayNumber_ALLTYPE " & Session("gameid") & ",'" &  Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
'response.write strSQL
dim myArray 'U MUST DECLARE ARRAYS!
dim x, y, next_x
x=0
next_x=0
set objRec = conn.Execute(strSql)
if not objRec.eof then
    myArray=objRec.getrows()
end if
					
					if Session("p1order")="money" then					
if isarray(myArray) then
    for x=0 to ubound(myArray,2) 'loop rows
       if myArray(0,x)=mlnPlayType2Up then
	pAmt = myArray(3,x) '//objRec("total_money")
	If Cint(myArray(1,x))=1 then ' //objRec("is_danger")
	   st_blink="<blink>"
	   ed_blink="</blink>"
	Else
	   st_blink=""
	   ed_blink=""
	End if	
	tmpClass="text_black"					
	if myArray(6,x)= 1 then tmpClass="text_red"   '//objRec("check_status")   objRec("play_number")
	response.write "<tr  class="&tmpClass&"><td class="&tmpClass&"><td  style='cursor:hand;'  onClick=shownum('"&myArray(2,x)&"','"&mlnPlayType2Up&"','"&Session("p1numtype")&"') ><b>" & st_blink & myArray(2,x)&"="&pAmt & ed_blink & "</b></td></tr>"
      else
          exit for
      end if
   next
end if


						

					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType2Up & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"
							if isarray(myArray) then
								if recNum("ref_number")=myArray(2,x) and myArray(0,x)=mlnPlayType2Up then								
									pAmt =myArray(3,x)  '// objRec("total_money")
									tmpClass="text_black"									
									if myArray(6,x) = 1 then tmpClass="text_red" '//objRec("check_status") 
									x=x+1
'								else
'									response.write recNum("ref_number")&"="& myArray(2,x)   '//objRec("play_number")
								end if
							end if
				
'							tmpColColor="#99FFFF"
'							if pAmt > 0 then tmpColColor = "#99FFFF"							
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType2Up&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop
						objRec.close
						recNum.close
					end if
					next_x=x

				%>
				</table>
			</td><!-- ���Ţ 2 �� -->

			<td valign=top  bgColor="<%=tmpColColor%>"><!-- �Ţ 3 �� -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					'//strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Up & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "

					'//set objRec = conn.Execute(strSql)


					if Session("p1order")="money" then	
if isarray(myArray) then
    for x=next_x to ubound(myArray,2) 'loop rows
       if myArray(0,x)=mlnPlayType3Up then
	pAmt = myArray(3,x) '//objRec("total_money")
	If Cint(myArray(1,x))=1 then ' //objRec("is_danger")
	   st_blink="<blink>"
	   ed_blink="</blink>"
	Else
	   st_blink=""
	   ed_blink=""
	End if	
	tmpClass="text_black"					
	if myArray(6,x)= 1 then tmpClass="text_red"   '//objRec("check_status")   objRec("play_number")
	response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&myArray(2,x)&"','"&mlnPlayType3Up&"','"&Session("p1numtype")&"')><b>" & st_blink &myArray(2,x)&"="&pAmt& ed_blink & "</b></td></tr>"
      else
          exit for
      end if
   next
end if

					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType3Up & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"
							'//if not objRec.Eof then
							if isarray(myArray) then
								if recNum("ref_number")=myArray(2,x) and myArray(0,x)=mlnPlayType3Up  then '//objRec("play_number") then
									pAmt = myArray(3,x) '//objRec("total_money")
									tmpClass="text_black"
									if Cint(myArray(6,x))= 1 then tmpClass="text_red"
									x=x+1
								end if
							end if
'							tmpColColor="#FFFF99"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType3Up&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop		
						recNum.close
					end if
next_x=x

				%>
				</table>
			</td><!-- ���Ţ 3 �� -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ 3 �� -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					'//strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Tod & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					'//set objRec = conn.Execute(strSql)
					if Session("p1order")="money" then					
if isarray(myArray) then
    for x=next_x to ubound(myArray,2) 'loop rows
       if myArray(0,x)=mlnPlayType3Tod then
	pAmt = myArray(3,x) '//objRec("total_money")
	If Cint(myArray(1,x))=1 then ' //objRec("is_danger")
	   st_blink="<blink>"
	   ed_blink="</blink>"
	Else
	   st_blink=""
	   ed_blink=""
	End if	
	tmpClass="text_black"					
	if myArray(6,x)= 1 then tmpClass="text_red"   '//objRec("check_status")   objRec("play_number")
	response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"& myArray(2,x) &"','"&mlnPlayType3Tod&"','"&Session("p1numtype")&"')><b>" & st_blink &myArray(2,x)&"="&pAmt& ed_blink & "</b></td></tr>"
      else
          exit for
      end if
   next
end if

					else
						strSql = "Select distinct ref_number From mt_reference_num Where ref_code = '" & mlnPlayType3Tod & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"							
							if isarray(myArray) then
								if recNum("ref_number")=myArray(2,x) and myArray(0,x)=mlnPlayType3Tod then '//objRec("play_number") then
									pAmt = myArray(3,x) '//objRec("total_money")
									tmpClass="text_black"
									if Cint(myArray(3,x)) = 1 then tmpClass="text_red"
									x=x+1
'								else
'									Response.write recNum("ref_number")&"-"& myArray(2,x) '//objRec("play_number")
								end if
							end if
'							tmpColColor="#FFFFFF"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType3Tod&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop			
						recNum.close
					end if
next_x=x
				%>
				</table>
			</td><!-- ���Ţ 3 �� -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ 2 �� -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					'//strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Tod & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					'//set objRec = conn.Execute(strSql)
					if Session("p1order")="money" then					
if isarray(myArray) then
    for x=next_x to ubound(myArray,2) 'loop rows
       if myArray(0,x)=mlnPlayType2Tod then
	pAmt = myArray(3,x) '//objRec("total_money")
	If Cint(myArray(1,x))=1 then ' //objRec("is_danger")
	   st_blink="<blink>"
	   ed_blink="</blink>"
	Else
	   st_blink=""
	   ed_blink=""
	End if	
	tmpClass="text_black"					
	if myArray(6,x)= 1 then tmpClass="text_red"   '//objRec("check_status")   objRec("play_number")
	response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&myArray(2,x) &"','"&mlnPlayType2Tod&"','"&Session("p1numtype")&"')><b>"& st_blink &myArray(2,x) &"="&pAmt& ed_blink & "</b></td></tr>"
      else
          exit for
      end if
   next
end if

						
					else					
						strSql = "Select distinct ref_number From mt_reference_num Where ref_code = '" & mlnPlayType2Tod & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"
							if isarray(myArray) then
								if recNum("ref_number")=myArray(2,x) and myArray(0,x)=mlnPlayType2Tod  then '//objRec("play_number") then
									pAmt =  myArray(3,x) '//objRec("total_money")
									tmpClass="text_black"
									if Cint(myArray(3,x))  = 1 then tmpClass="text_red"
									x=x+1
								end if
							end if
'							tmpColColor="#FFFF99"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType2Tod&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop				
						recNum.close
					end if
next_x=x

				%>
				</table>
			</td><!-- ���Ţ 2 �� -->
			<td valign=top colspan=2>
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<tr>
					<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ ��觺� -->
						<TABLE width='100%' align=center class=table_blue>        	
						<%
								strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunUp & ",'" & Session("p1numtype") & "', 'number', 'no' "
								set objRec = conn.Execute(strSql)
								strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayTypeRunUp & "' order by ref_number"
								recNum.Open strSql, conn
								do while not recNum.eof
									pAmt=0
									tmpClass="text_black"
									if not objRec.Eof then
										if recNum("ref_number")=objRec("play_number") then
											pAmt = objRec("total_money")
											tmpClass="text_black"
											if objRec("check_status") = 1 then tmpClass="text_red"
											objRec.Movenext
										end if
									end if
									If isDanger(recNum("ref_number"), mlnPlayTypeRunUp)=1 Then
										st_blink="<blink>"
										ed_blink="</blink>"
									Else
										st_blink=""
										ed_blink=""
									End If
									response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayTypeRunUp&"','"&Session("p1numtype")&"')><b>" & st_blink &recNum("ref_number")&"="&pAmt& ed_blink & "</b></td></tr>"
									recNum.movenext
								loop					
								objRec.close
								recNum.close

%>
						</table>
					</td><!-- ���Ţ��觺� -->
					<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ �����ҧ -->
						<TABLE width='100%' align=center class=table_blue>        						
						<%
								strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunDown & ",'" & Session("p1numtype") & "', 'number', 'no' "
								set objRec = conn.Execute(strSql)
								strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayTypeRunDown & "' order by ref_number"
								recNum.Open strSql, conn

								do while not recNum.eof
									pAmt=0
									tmpClass="text_black"
									if not objRec.Eof then
										if recNum("ref_number")=objRec("play_number") then
											pAmt = objRec("total_money")
											tmpClass="text_black"
											if objRec("check_status") = 1 then tmpClass="text_red"
											objRec.Movenext
										end if
									end if
'									tmpColColor="#FFFF99"
'									if pAmt > 0 then tmpColColor = "#99FFFF"
									'blink
									If isDanger(recNum("ref_number"), mlnPlayTypeRunDown)=1 Then
									'If objRec("is_danger")=1 then
										st_blink="<blink>"
										ed_blink="</blink>"
									Else
										st_blink=""
										ed_blink=""
									End If

									response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayTypeRunDown&"','"&Session("p1numtype")&"')><b>" & st_blink &recNum("ref_number")&"="&pAmt& ed_blink & "</b></td></tr>"
									recNum.movenext
								loop
								objRec.close
								recNum.close
'							end if							
						%>
						</table>
					</td><!-- ���Ţ�����ҧ -->				
				</tr>
<%
	dim strRecTk
	strRecTk = "�Ѻ��ҷ�����"
	if Session("p1recmulti") = "true" then strRecTk = "�Ѻ���������"
%>
				<tr>
					<!-- �ʴ� �������� -->
					<td valign=top colspan=2>
						<TABLE width='100%' align=center class=table_blue>   
							<!---- 2006-12-20
							<tr><td class=head_white bgcolor=red align=center colspan=2 style="cursor:hand;" onClick="recmulti_click();"><%=strRecTk%></a></td></tr> -->
							<tr><td class=head_white bgcolor=blue align=center colspan=2>��������</a></td></tr>
<%

						strSql = "SELECT tb_open_game.game_id, tb_open_game.dealer_id, tb_ticket.ticket_id, tb_ticket.ticket_number, sc_user.user_name, tb_ticket.rec_status, tb_ticket.ticket_date " _
							& "FROM  dbo.tb_ticket INNER JOIN dbo.tb_open_game ON dbo.tb_ticket.game_id = dbo.tb_open_game.game_id INNER JOIN dbo.sc_user ON dbo.tb_ticket.player_id = dbo.sc_user.user_id INNER JOIN  dbo.tb_ticket_key ON dbo.tb_ticket.ticket_id = dbo.tb_ticket_key.ticket_id " _
							& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_open_game.dealer_id = " & Session("uid") & ") AND (tb_ticket.rec_status = " & mlnStatusSend & ") " _
							& "GROUP BY dbo.tb_open_game.game_id, dbo.tb_open_game.dealer_id, dbo.tb_ticket.ticket_id, dbo.tb_ticket.ticket_number, dbo.sc_user.user_name, dbo.tb_ticket.rec_status, dbo.tb_ticket.ticket_date " _
							& "order by ticket_date desc"
'						showstr strSql
						objRec.Open strSql, conn
						do while not objRec.eof
							if strRecTk = "�Ѻ���������" then
								response.write "<tr><td class=text_red bgcolor=#99FFFF><a href='dealer_receive_ticket.asp?ticket_id="&objRec("ticket_id")&"'><input type=checkbox value='" &objRec("ticket_id")& "' name=multitkid> ("&objRec("ticket_number")&") "&objRec("user_name")&"</a></td>"
								response.write "    <td class=text_red bgcolor=#99FFFF align=right>"&formatdatetime(objRec("ticket_date"),4)&"</td></tr>"
							else
								response.write "<tr><td class=text_red bgcolor=#99FFFF><a href='dealer_receive_ticket.asp?ticket_id="&objRec("ticket_id")&"'>("&objRec("ticket_number")&") "&objRec("user_name")&"</a></td>"
								response.write "    <td class=text_red bgcolor=#99FFFF align=right>"&formatdatetime(objRec("ticket_date"),4)&"</td></tr>"
							end if
							objRec.MoveNext
						loop
						objRec.close	
%>						
<%
							if strRecTk = "�Ѻ���������" then
%>
							<tr><td class=head_white bgcolor=red align=center colspan=2><input type=button value="�Ѻ��" onClick="receive_click();" style="width:80;"></a></td></tr>
<%								
							end if
%>
						</table>
					</td>
				</tr>
				</table>
			</TD> <!-- �� ��觺� �����ҧ -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ 2 ��ҧ -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Down & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					set objRec = conn.Execute(strSql)

					if Session("p1order")="money" then		
			
						do while not objRec.eof
							pAmt=0
							pAmt = objRec("total_money")
'							tmpColColor=""
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							'blink
							'If isDanger(objRec("play_number"), mlnPlayType2Down)=1 Then
                       						If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End If

							tmpClass="text_black"
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType2Down&"','"&Session("p1numtype")&"')><b>" & st_blink &objRec("play_number")&"="&pAmt& ed_blink & "</b></td></tr>"
							objRec.movenext
						loop
						objRec.close
					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType2Down & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"
							if not objRec.Eof then
								if recNum("ref_number")=objRec("play_number") then
									pAmt = objRec("total_money")
									tmpClass="text_black"
									if objRec("check_status") = 1 then tmpClass="text_red"
									objRec.Movenext
								end if
							end if
'							tmpColColor="#FFFFFF"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType2Down&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop				
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- ���Ţ 2 ��ҧ -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- �Ţ 3 ��ҧ -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Down & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					set objRec = conn.Execute(strSql)

					if Session("p1order")="money" then					
						do while not objRec.eof
							pAmt=0
							pAmt = objRec("total_money")
'							tmpColColor=""
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							'blink
							'If isDanger(objRec("play_number"), mlnPlayType3Down)=1 Then
                       						If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End If

							tmpClass="text_black"
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType3Down&"','"&Session("p1numtype")&"')><b>" & st_blink &objRec("play_number")&"="&pAmt & ed_blink &"</b></td></tr>"
							objRec.movenext
						loop
						objRec.close
					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType3Down & "' order by ref_number"
						recNum.Open strSql, conn

						do while not recNum.eof
							pAmt=0
							tmpClass="text_black"
							if not objRec.Eof then
								if recNum("ref_number")=objRec("play_number") then
									pAmt = objRec("total_money")
									tmpClass="text_black"
									if objRec("check_status") = 1 then tmpClass="text_red"
									objRec.Movenext
								end if
							end if
'							tmpColColor="#FFFF99"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType3Down&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop				
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- ���Ţ 3 ��ҧ -->
		</tr>
	</table>	
	</form>


</BODY>
</HTML>
<%
	set objRec = nothing
	set recNum = nothing
	set conn   = nothing	
%>
<script language="javascript">
	function download_manual(){
		window.open("help.xls",null,'left=400, top=0, height=400, width= 400, status=yes, resizable= yes, scrollbars= no, toolbar= yes,location= no, menubar= yes' )
	}

	function clickpic(p){
		var t=p

		//alert(t)
		// �Ѱ���
		if (t==1){
			document.mypic.src ="images/price_tos.jpg"
			document.form1.game_type.value="2"
		}
		// ����Թ
		if (t==2){
			document.mypic.src = "images/price_oth.jpg";
			document.form1.game_type.value="3"
		}
		// ����
		if (t==3){
			document.mypic.src = "images/price_gov.jpg"
			document.form1.game_type.value="1"
		}
		document.form1.mode.value="chg_game_type";
		document.form1.submit();
	}	
	function click_cntTicketPlayer(dealer_id){
		var ParmA = ""; //document.form1.proj_code.value;
		var ParmB = "";
		var ParmC = '';
		var MyArgs = new Array(ParmA, ParmB, ParmC);

		MyArgs=window.showModalDialog('cntTicketPlayer.asp', '', 'dialogTop:'+0+'px;dialogLeft:'+140+'px;dialogHeight:720px;dialogWidth:330px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');
		if (MyArgs == null)
		{
		//	window.alert(
		//	  "Nothing returned from child. No changes made to input boxes")
		}
		else
		{
			//document.form1.proj_code.value=MyArgs[0].toString();
		}

	}
</script>
<%
' ��Ǩ�ͺ�������Ţ�ѹ�����������
Function isDanger(play_number, play_type)
	Dim tmpRS , tmpDB , tmpSQL
	set tmpDB=Server.CreateObject("ADODB.Connection")       
	tmpDB.Open Application("constr")
	Set tmpRS =Server.CreateObject("ADODB.Recordset")
	tmpSQL="select  * from tb_danger_number where dealer_id=" & Session("uid")	
	tmpSQL=tmpSQL & " and play_type=" & play_type 
	tmpSQL=tmpSQL & " and danger_number='" & play_number & "'"
	set tmpRS=tmpDB.Execute(tmpSQL)
	if Not tmpRS.EOF Then
		isDanger=1
	Else
		isDanger=0
	end if
	set tmpRS=nothing
	set tmpDB=nothing
End Function
%>