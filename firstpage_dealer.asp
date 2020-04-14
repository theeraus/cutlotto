
<!--#include virtual="masterpage.asp"-->

<%
'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		
Dim overlimit,  limit, sumplay, mess_over_limit , limit_play,can_play
overlimit=Request("overlimit")
limit=Request("limit")
sumplay=Request("sumplay")
If overlimit="yes" Then
	mess_over_limit=""
	mess_over_limit=mess_over_limit & "  <div style='position: absolute; "
	mess_over_limit=mess_over_limit & "              left: 300px; "
	mess_over_limit=mess_over_limit & "              top: 250px; "
	mess_over_limit=mess_over_limit & "              width: 250px; "
	mess_over_limit=mess_over_limit & "              height: 110px; "
	mess_over_limit=mess_over_limit & "              border-top: 1px solid black; "
	mess_over_limit=mess_over_limit & "              border-bottom: 1px solid black; "
	mess_over_limit=mess_over_limit & "              border-right: 1px solid black; "
	mess_over_limit=mess_over_limit & "              border-left: 1px solid black'> "
	mess_over_limit=mess_over_limit & "	<table align=center><tr><td colspan=2 align=center>"
	mess_over_limit=mess_over_limit & "	<font color=red><b>ยอดเกิน</b></font> "
	mess_over_limit=mess_over_limit & "	</td></tr>"
	mess_over_limit=mess_over_limit & "	<tr><td>"
	mess_over_limit=mess_over_limit & "	ยอด  </td><td align=right>&nbsp;" & FormatNumber(limit,2)
	mess_over_limit=mess_over_limit & "	</td></tr>"
	mess_over_limit=mess_over_limit & "	<tr><td>"
	mess_over_limit=mess_over_limit & "	ใช้จริง  </td><td align=right>&nbsp;" & FormatNumber(sumplay,2)
	mess_over_limit=mess_over_limit & "	</td></tr>"
	mess_over_limit=mess_over_limit & "	<tr><td colspan=2 align=center>"
	mess_over_limit=mess_over_limit & "	<font color=red><b>'' กรุณาติดต่อผู้ดูแลระบบ ''</b></font> "
	mess_over_limit=mess_over_limit & "	</td></tr>"
	mess_over_limit=mess_over_limit & "	</table>"
	mess_over_limit=mess_over_limit & "</div> "

	response.write mess_over_limit
End If 

'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		
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
		Session("p1numtype")="all"
	else
		Session("p1numtype")=Request("cmbnumtype")
	end if


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
<%
' ตรวจสอบว่าเป็ยเลขอันตรายหรือไม่
Function isDanger(play_number, play_type)
	Dim tmpRS , tmpDB , tmpSQL
	set tmpDB=Server.CreateObject("ADODB.Connection")       
	tmpDB.Open Application("constr")
	Set tmpRS =Server.CreateObject("ADODB.Recordset")
	tmpSQL="select dg_id,dealer_id,play_type,danger_number from tb_danger_number where dealer_id=" & Session("uid")	
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

<% Sub ContentPlaceHolder() %>


<script language="JavaScript">

	var start=new Date();
	start=Date.parse(start)/1000;
	var counts = "<%=Session("refreshtime")%>";
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

	function refresh() {
		document.all.form1.submit();
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

	function cleargame(chkover) {

			if (confirm("คุณต้องการพิมพ์ หรือ เก็บโพยไว้หรือไม่ ?")) {
				opensave();
			} else {
				if (confirm("ยืนยันการล้างเลข ?")) {
					document.all.gamestatus.value = "delete"    //"close";
					document.all.form1.submit();		
				}
			}
	}

	function receive_click() {
		var str, cnt, i
		cnt = document.all.form1.multitkid.length;
		for (i=0;i<cnt;i++) {
		    if (document.all.form1.multitkid[i].checked) {
				if (! str=="") {
					str=str+","
				}
				str = str + document.all.form1.multitkid[i].value;
			}
		}
		document.all.gamestatus.value = "receivemulti";
		document.all.form1.multiticket.value = str;
		document.all.form1.submit();

	}

	function recmulti_click() {
	    var str2, cnt2, i2
	   
	    cnt2 = document.all.form1.multitkid.length;
	    for (i2 = 0; i2 < cnt2; i2++) {
	        if (document.all.form1.multirecchk.checked) {
	                document.all.form1.multitkid[i2].checked = true;
	        } else {
	                document.all.form1.multitkid[i2].checked = false;
	        }
	    }
	    document.form1.submit();
	
	}

	function changegamestatus(gstatus) {
		var myVal= gstatus.value;
		if (myVal=="เปิดทั้งหมด") {
				document.all.gamestatus.value = "open"    //"close";
				document.all.form1.submit();
		} else if (myVal=="ปิดทั้งหมด") {
				document.all.gamestatus.value ="close" // "open";
				document.all.form1.submit();
		} else if (myVal=="ปิดเอเย่นต์และเปิดคนคีย์") {
				document.all.gamestatus.value ="key" // "key";
				document.all.form1.submit();
		}

	}

	function shownum(pnum,ptype,numtype) {
		var url = "dealer_viewnumber.asp?pnum="+pnum+"&ptype="+ptype+"&numtype="+numtype ;
		$("#modalbody" ).html("<div>Loadding . . .</div>");
    	$("#modalbody" ).load( url );
		$("#numberModal").modal("show");
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

// funtion กระพริบ blink///////////////////
blink(0.3);

function blink(speed) {

    if (speed) {
        if (document.getElementsByTagName('blink'))
            setInterval("blink()", speed * 2000);

        return;
    }

    var blink = document.getElementsByTagName('blink');

    for (var i = 0; i < blink.length; i++) {
        blink[i].style.visibility = blink[i].style.visibility == "" ? "hidden" : "";
    }
}

</script>


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
	elseif Request("gamestatus") = "delete" Then
		'ล้างเลขอันตรายด้วย anon 060209
		strSql="delete tb_danger_number where dealer_id=" & Session("uid")
		conn.Execute(strSql)	

		'20110606 ล้างเลขแล้วให้เลขอั้นไว้คงเดิม 
		'ให้ล้างเลขเต็มไปด้วย 2008-12-03
		'strSql="delete from tb_limit_number where dealer_id=" & Session("uid")
		'conn.Execute(strSql)
	
		'20110627 ยกเลิกการเคียร์จำนวนเงินที่อั้น
		'strSql="update sc_user set up2=0,up3=0,tod3=0,down2=0 where user_id=" & Session("uid")
		'conn.Execute(strSql)	

		'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		
		'strSql = "exec spA_ChangePasswordOverLimitChk " & Session("uid") & ", " & Session("gameid") 
		strSql = "select 'yes' as overlimit, admin_limit as  limit, play_amt as sumplay "
		strSql =strSql & " from tb_clear_number where dealer_id=" & Session("uid") & " and game_id=" & Session("gameid") 
		set objRec=conn.Execute(strSql)	
		If Not objRec.eof Then
			overlimit=objRec("overlimit")
			limit=objRec("limit")
			sumplay=objRec("sumplay")
		End If 
		'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 		

		strSql = "exec spA_ChangePasswordOverLimit " & Session("uid") & ", " & Session("gameid") 
		set objRec=conn.Execute(strSql)			

		strSql = ""
		comm.CommandText = "spDealerClearNumber"
		comm.CommandType = adCmdStoredProc
		comm.Parameters.Append comm.CreateParameter("@gameid"		,adInteger  ,adParamInput, ,Session("gameid"))
		comm.Execute
		'jum 2008-10-09 เช็คว่ายอดเกิน หรือไม่ เพื่อใช้แสดง ยอดที่ใช้เกิน และยอดที่ admin กำหนดให้ใช้ได้ 	
		'Response.redirect "firstpage_dealer.asp"
		Response.redirect "firstpage_dealer.asp?overlimit=" & overlimit & "&limit=" & limit & "&sumplay=" & sumplay
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

	strOpen="ปิดทั้งหมด"
	strOrder="เรียงเลข"
	if CheckGame(Session("uid"))="OPEN" then strOpen="เปิดทั้งหมด"
	if CheckGame(Session("uid"))="KEY" then strOpen="ปิดเอเย่นต์และเปิดคนคีย์"
	'//----- jum edit 2005-07-27 -----
	Dim op1,op2, op3
	op1=""
	op2=""
	op3=""
	select case strOpen 
		case "เปิดทั้งหมด"
			op1="selected"
		case "ปิดทั้งหมด"
			op2="selected"
		case "ปิดเอเย่นต์และเปิดคนคีย์"
			op3="selected"
	end select
	'//----- jum edit 2005-07-27 -----
	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	strSql=""
'    strSql = "exec spA_GetSumAmt_by_Type " & Session("gameid") & ", 'all'" 
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
	if Session("p1numtype")="all" or Session("p1numtype")="" then
        Session("rsumall") = sumall
    end if

'******************* อานนท์ ไม่ใช้แล้ว 
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
end if   '************** ไม่ใช้แล้ว   
%>
    <%
								strTmp=""
								if Session("p1numtype")="all" then 
									strTmp="เลขรับทั้งหมด"
								elseif Session("p1numtype")="rec" then 
									strTmp="เลขรับไว้"
								elseif Session("p1numtype")="out" then 
									strTmp="เลขแทงออก"
								end if

                                    strTmp=""
								if Session("p1order")="num" then 
									strTmp="เรียงตามเลข"
								elseif Session("p1order")="money" then
									strTmp="เรียงตามเงิน"
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

                              Dim selord1, selord2
							select case Session("p1order")
								case "num"
									selord1="selected"
								case "money"
									selord2="selected"
							end select

								%>

<FORM id=form1 name=form action="firstpage_dealer.asp" method=post>
<div class="row">

	<div class="col-lg-12 col-xl-12 ">
		<div class="row">
			<div class="col-lg-3 col-xl-3 order-lg-1 order-xl-1">
				<!--begin::Portlet-->
				<div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid short-box" data-search="all">
					<div class="kt-portlet__body kt-portlet__body--fluid">
						<div class="kt-widget-3 kt-widget-3--primary">
							<div class="kt-widget-3__content">
								<div class="kt-widget-3__content-info">
									<div class="kt-widget-3__content-section">
										<div class="kt-widget-3__content-title">ยอดแทง</div>
										<div class="kt-widget-3__content-desc ">TOTAL</div>
									</div>
									<div class="kt-widget-3__content-section">

										<span class="kt-widget-3__content-number taskref0"><%=FormatNumber(sumall,0)%></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--end::Portlet-->
			</div>
			<div class="col-lg-3 col-xl-3 order-lg-1 order-xl-1">
				<!--begin::Portlet-->
				<div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid short-box" data-search="onprocess">
					<div class="kt-portlet__body kt-portlet__body--fluid">
						<div class="kt-widget-3 kt-widget-3--warning">
							<div class="kt-widget-3__content">
								<div class="kt-widget-3__content-info">
									<div class="kt-widget-3__content-section">
										<div class="kt-widget-3__content-title">เครดิต</div>
										<div class="kt-widget-3__content-desc">CREDIT</div>
									</div>
									<div class="kt-widget-3__content-section">

										<span class="kt-widget-3__content-number taskref1"><%=FormatNumber(Session("limit_play"),0)%></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--end::Portlet-->
			</div>
			<div class="col-lg-3 col-xl-3 order-lg-1 order-xl-1">
				<!--begin::Portlet-->
				<div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid short-box" data-search="waiting">
					<div class="kt-portlet__body kt-portlet__body--fluid">
						<div class="kt-widget-3 kt-widget-3--dark">
							<div class="kt-widget-3__content">
								<div class="kt-widget-3__content-info">
									<div class="kt-widget-3__content-section">
										<div class="kt-widget-3__content-title">ยอดสูงสุด</div>
										<div class="kt-widget-3__content-desc">MAX TOTAL</div>
									</div>
									<div class="kt-widget-3__content-section">

										<span class="kt-widget-3__content-number taskref2"><%=FormatNumber(Session("rsumall"),0)%></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--end::Portlet-->
			</div>
			<div class="col-lg-3 col-xl-3 order-lg-1 order-xl-1">
				<!--begin::Portlet-->
				<div class="kt-portlet kt-portlet--fit kt-portlet--height-fluid short-box" data-search="approved">
					<div class="kt-portlet__body kt-portlet__body--fluid">
						<div class="kt-widget-3 kt-widget-3--info">
							<div class="kt-widget-3__content">
								<div class="kt-widget-3__content-info">
									<div class="kt-widget-3__content-section">
										<div class="kt-widget-3__content-title">ยอดคงเหลือ</div>
										<div class="kt-widget-3__content-desc">BALANCE</div>
									</div>
									<div class="kt-widget-3__content-section">

										<span class="kt-widget-3__content-number taskref3"><%=FormatNumber(Session("limit_play")-Session("rsumall"),0)%></span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!--end::Portlet-->
			</div>
		</div>
	</div>

	<div class="col-xl-12 col-lg-12">
		<!--begin::Portlet-->
		<div class="kt-portlet">
			<div class="kt-portlet__body">
				<div class="form-group row" style="margin-bottom: 0;">
					<div class="col-lg-3">
						<select name="cmdgame" class="form-control kt_selectpicker" onChange="changegamestatus(this);" >
							<option value="เปิดทั้งหมด" <%=op1%>>เปิดทั้งหมด</option>
							<option value="ปิดทั้งหมด" <%=op2%>>ปิดทั้งหมด</option>
							<option value="ปิดเอเย่นต์และเปิดคนคีย์" <%=op3%>>ปิดแทงเปิดคีย์</option>
						</select>
					</div>
					<div class="col-lg-3">
						<select  class="form-control kt_selectpicker" name="cmborder" onChange="changeorder('<%=Session("p1order")%>');">
								<option value="num" <%=selord1%>>เรียงตามเลข</option>
								<option value="money" <%=selord2%>>เรียงตามเงิน</option>
						</select>
					</div>
					<div class="col-lg-3">
						<select class="form-control kt_selectpicker" name="cmbnumtype" onChange="changenumtype('<%=Session("p1numtype")%>');">
									<option value="all" <%=sel1%>>เลขรับทั้งหมด</option>
									<option value="rec" <%=sel2%>>เลขรับไว้</option>
									<option value="out" <%=sel3%>>เลขแทงออก</option>
						</select>
					</div>
	
					<div class="col-lg-3">
						<span style="overflow: visible; position: relative;" onclick="refresh()">			
								 <a class="btn btn-sm btn-brand btn-icon" type="button" > 
									 <i class="flaticon-refresh"></i>
								</a>
						</span>
                    </div>
				</div>

			</div>
		</div>
		<!--end::Portlet-->
	</div>


	<input type="hidden" name="mode">
	<input type="hidden" name="game_type">
	<INPUT TYPE="hidden" name="p1order">
	<INPUT TYPE="hidden" name="p1numtype">
	<INPUT TYPE="hidden" name="multiticket">
	<INPUT TYPE="hidden" name="stoprefresh" value="">
	<INPUT TYPE="hidden" name="recmulti" value="<%=Session("p1recmulti")%>">
	<INPUT TYPE="hidden" name="gamestatus" value="" />
	<div class="table-responsive">
		
	<TABLE id="dtHorizontalExample"  class=" table table-striped table-bordered table-sm" cellspacing="0" width="100%">     
		<tr>
			<td colspan=5 class="btn-primary" align=center height="25">สู้บน</td>
			<td colspan=3 class="btn-success" align=center height="25">สู้ล่าง</td>
			<td rowspan=3 class="btn-metal" style="text-align: center;vertical-align: middle;"> แถว</td>
		</tr>   

		<tr align=center  class="btn-dark ">
			<td class="style1"><font color="white"><%=typenum1%></font></td>
			<td><font color="white"><%=typenum2%></font></td>
			<td><font color="white"><%=typenum3%></font></td>
			<td><font color="white"><%=typenum4%></font></td>
			<td><font color="white"><%=typenum5%></font></td>
			<td><font color="white"><%=typenum6%></font></td>
			<td><font color="white"><%=typenum7%></font></td>
			<td><font color="white"><%=typenum8%></font></td>
		</tr>
		<tr align=center >
			<td class="btn-primary"><font color="yellow">2 บน</font></td>
			<td class="btn-danger">3 บน</td>
			<td class="btn-primary"><font color="yellow">3 โต๊ด</font></td>
			<td class="btn-danger">2 โต๊ด</td>
			<td class="btn-primary"><font color="yellow">วิ่งบน</font></td>
			<td class="btn-danger">วิ่งล่าง</td>
			<td class="btn-primary"><font color="yellow">2 ล่าง</font></td>
			<td class="btn-danger">3 ล่าง</td>
		</tr>
		<tr>

			<td  bgColor="<%=tmpColColor%>"><!-- เลข 2 บน -->
				<TABLE class="table table-bordered table-hover table-in">        	
				<%
					dim pAmt
					dim tmpClass
					set objRec = nothing
					set recNum = nothing
					Set objRec = Server.CreateObject ("ADODB.Recordset")
					Set recNum = Server.CreateObject ("ADODB.Recordset")

					
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Up & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					set objRec = conn.Execute(strSql)

					if Session("p1order")="money" then					
						if not objRec.eof then
						do while not objRec.eof
							pAmt=0							
							pAmt = objRec("total_money")

							
                       		If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End if
							tmpClass="text_black"					
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td  style='cursor:hand;'  onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType2Up&"','"&Session("p1numtype")&"') ><b>" & st_blink & objRec("play_number")&"="&pAmt & ed_blink & "</b></td></tr>"

							objRec.movenext
						loop
						end if
						objRec.close
					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType2Up & "' order by ref_number"
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
							
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType2Up&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- จบเลข 2 บน -->

			<td valign=top  bgColor="<%=tmpColColor%>"><!-- เลข 3 บน -->
				<TABLE class="table table-bordered table-hover table-in">      	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Up & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "

					set objRec = conn.Execute(strSql)


					if Session("p1order")="money" then					
						do while not objRec.eof
							pAmt=0
							pAmt = objRec("total_money")
'							tmpColColor=""
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							' blink 
							'If isDanger(objRec("play_number"), mlnPlayType3Up)=1 Then
							If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End If
							
							tmpClass="text_black"
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType3Up&"','"&Session("p1numtype")&"')><b>" & st_blink &objRec("play_number")&"="&pAmt& ed_blink & "</b></td></tr>"
							objRec.movenext
						loop
						objRec.close
					else
						strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayType3Up & "' order by ref_number"
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
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType3Up&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop		
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- จบเลข 3 บน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Tod & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					set objRec = conn.Execute(strSql)
					if Session("p1order")="money" then					
						do while not objRec.eof
							pAmt=0
							pAmt = objRec("total_money")
'							tmpColColor=""
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							' blink 
							'If isDanger(objRec("play_number"), mlnPlayType3Tod)=1 Then
							If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End If

							tmpClass="text_black"
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType3Tod&"','"&Session("p1numtype")&"')><b>" & st_blink &objRec("play_number")&"="&pAmt& ed_blink & "</b></td></tr>"
							objRec.movenext
						loop
						objRec.close
					else
						strSql = "Select distinct ref_number From mt_reference_num Where ref_code = '" & mlnPlayType3Tod & "' order by ref_number"
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
'								else
'									Response.write recNum("ref_number")&"-"&objRec("play_number")
								end if
							end if
'							tmpColColor="#FFFFFF"
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType3Tod&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop			
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- จบเลข 3 โต๊ด -->
			<td valign=top bgColor="<%=tmpColColor%>" style="padding:0"><!-- เลข 2 โต๊ด -->
				<TABLE class="table table-bordered table-hover table-in">       	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Tod & ",'" & Session("p1numtype") & "', '" & Session("p1order") & "', 'no' "
					set objRec = conn.Execute(strSql)
					if Session("p1order")="money" then					
						do while not objRec.eof
							pAmt=0
							pAmt = objRec("total_money")
'							tmpColColor=""
'							if pAmt > 0 then tmpColColor = "#99FFFF"
							'blink
							'If isDanger(objRec("play_number"), mlnPlayType2Tod)=1 Then
							If objRec("is_danger")=1 then
								st_blink="<blink>"
								ed_blink="</blink>"
							Else
								st_blink=""
								ed_blink=""
							End If

							tmpClass="text_black"
							if objRec("check_status") = 1 then tmpClass="text_red"
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&objRec("play_number")&"','"&mlnPlayType2Tod&"','"&Session("p1numtype")&"')><b>"& st_blink &objRec("play_number")&"="&pAmt& ed_blink & "</b></td></tr>"
							objRec.movenext
						loop
						objRec.close
					else					
						strSql = "Select distinct ref_number From mt_reference_num Where ref_code = '" & mlnPlayType2Tod & "' order by ref_number"
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
							response.write "<tr class="&tmpClass&"><td style='cursor:hand;' onClick=shownum('"&recNum("ref_number")&"','"&mlnPlayType2Tod&"','"&Session("p1numtype")&"')><b>"&recNum("ref_number")&"="&pAmt&"</b></td></tr>"
							recNum.movenext
						loop				
						objRec.close
						recNum.close
					end if
				%>
				</table>
			</td><!-- จบเลข 2 โต๊ด -->
			<td valign=top colspan=2 style="padding:0">
				<TABLE class="table table-bordered table-hover table-in">         	
				<tr>
					<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งบน -->
						<TABLE width='100%' align=center class=table_blue>        	
						<%
								strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunUp & ",'" & Session("p1numtype") & "', 'number', 'no' "
'showstr strSql
'response.write mlnPlayTypeRunUp 
								set objRec = conn.Execute(strSql)
								strSql = "Select * From mt_reference_num Where ref_code = '" & mlnPlayTypeRunUp & "' order by ref_number"
								recNum.Open strSql, conn

								do while not recNum.eof
									pAmt=0
									tmpClass="text_black"
									if not objRec.Eof then
'response.write recNum("ref_number")
										if trim(recNum("ref_number"))=trim(objRec("play_number")) then
											pAmt = objRec("total_money")
											tmpClass="text_black"
											if objRec("check_status") = 1 then tmpClass="text_red"
											objRec.Movenext
										end if
									end if
'									tmpColColor="#FFFFFF"
'									if pAmt > 0 then tmpColColor = "#99FFFF"
									'blink
									If isDanger(recNum("ref_number"), mlnPlayTypeRunUp)=1 Then
	  								'If objRec("is_danger")=1 then
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
'							end if
%>
						</table>
					</td><!-- จบเลขวิ่งบน -->
					<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งล่าง -->
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
					</td><!-- จบเลขวิ่งล่าง -->				
				</tr>
<%
	dim strRecTk
	strRecTk = "รับเข้าทีละโพย"
	if Session("p1recmulti") = "true" then strRecTk = "รับเข้าหลายโพย"
    
%>
				<tr>
					<!-- แสดง คิวโพยเข้า -->
					<td valign=top colspan=2>
						<TABLE width='100%' align=center class=table_blue>   
                            <tr>
                            <td class=head_white bgcolor=blue align=center colspan=2 style="cursor:hand;" ><a>คิวโพยเข้า</a></td></tr>
                            <tr>
<!--                        <td style="font-size:14px; color:#fff; font-weight:bold;" bgcolor="#0099FF" align="left" colspan="2"><input name="multirecchk" onClick="recmulti_click();" type="checkbox">เลือกทั้งหมด</td>-->
                <!--</tr>-->
<%
                dim fsti,fcord,strhtm1,strhtm2
                fsti = 0
                fcord = 0
						strSql = "SELECT tb_open_game.game_id, tb_open_game.dealer_id, tb_ticket.ticket_id, tb_ticket.ticket_number, sc_user.user_name, tb_ticket.rec_status, tb_ticket.ticket_date, case isnull(tb_ticket.cutauto_type,'') when '' then  '' else '['+tb_ticket.cutauto_type+' | '+cast(tb_ticket.cutauto_perc as nvarchar(5))+']' end as cutauto " _
							& "FROM  dbo.tb_ticket INNER JOIN dbo.tb_open_game ON dbo.tb_ticket.game_id = dbo.tb_open_game.game_id INNER JOIN dbo.sc_user ON dbo.tb_ticket.player_id = dbo.sc_user.user_id INNER JOIN  dbo.tb_ticket_key ON dbo.tb_ticket.ticket_id = dbo.tb_ticket_key.ticket_id " _
							& "WHERE (tb_ticket.ticket_status <> 'D') And (tb_open_game.dealer_id = " & Session("uid") & ") AND (tb_ticket.rec_status = " & mlnStatusSend & ") " _
							& "GROUP BY dbo.tb_open_game.game_id, dbo.tb_open_game.dealer_id, dbo.tb_ticket.ticket_id, dbo.tb_ticket.ticket_number, dbo.sc_user.user_name, dbo.tb_ticket.rec_status, dbo.tb_ticket.ticket_date , tb_ticket.cutauto_type, tb_ticket.cutauto_perc " _
							& "order by ticket_date desc"
'						showstr strSql
						objRec.Open strSql, conn
						do while not objRec.eof
                            
							'if strRecTk = "รับเข้าหลายโพย" then
								strhtm2 = strhtm2 &  "<tr><td class=text_red bgcolor=#99FFFF><a href='dealer_receive_ticket.asp?ticket_id="&objRec("ticket_id")&"'><input type='checkbox' value='" &objRec("ticket_id")& "' name='multitkid'> ("&objRec("ticket_number")&") "&objRec("user_name")&" "&objRec("cutauto") &"</a></td>"
								strhtm2 = strhtm2 &  "    <td class=text_red bgcolor=#99FFFF align=right>"&formatdatetime(objRec("ticket_date"),4)&"</td></tr>"
							'else
							'	response.write "<tr><td class=text_red bgcolor=#99FFFF><a href='dealer_receive_ticket.asp?ticket_id="&objRec("ticket_id")&"'>("&objRec("ticket_number")&") "&objRec("user_name")&" "&objRec("cutauto")&"</a></td>"
							'	response.write "    <td class=text_red bgcolor=#99FFFF align=right>"&formatdatetime(objRec("ticket_date"),4)&"</td></tr>"
							'end if
                            fsti = fsti + 1
							objRec.MoveNext
						loop
						objRec.close

                        if fsti < 2 then
                                strhtm1 = "</tr>"
                        else        
                                strhtm1 = strhtm1 & "<td style='font-size:14px; color:#fff; font-weight:bold;' bgcolor=#0099FF align='left' colspan='2'><input name='multirecchk' onClick='recmulti_click();' type='checkbox'>เลือกทั้งหมด</td>"
                                strhtm1 = strhtm1 & "</tr>"
                        end if

                        response.write strhtm1 & strhtm2
%>						
<%
							if strRecTk = "รับเข้าหลายโพย" then
%>
							<tr><td class=head_white bgcolor=red align=center colspan=2><input type=button value="รับโพย" onClick="receive_click();" style="width:80;"></a></td></tr>
<%								
							end if
%>
						</table>
					</td>
				</tr>
				</table>
			</TD> <!-- จบ วิ่งบน วิ่งล่าง -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 ล่าง -->
				<TABLE class="table table-bordered table-hover table-in">       	
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
			</td><!-- จบเลข 2 ล่าง -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 ล่าง -->
				<TABLE class="table table-bordered table-hover table-in">        	
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
			</td><!-- จบเลข 3 ล่าง -->
			<td valign=top bgColor="#ffffff"  class="left_red" style="width: 40px;"><!-- running number -->
				<TABLE class="table table-bordered table-hover table-in">       	
<%
	dim icnt
	for icnt=1 to 1000
%>
					<tr height="16" class="text_red"><td><b><%=icnt%></b></td>	</tr>
<%
	next
%>
				</Table>
			</td>

		</tr>
	</table>		
	</div></div>
	</form>
<!-- Modal -->
<div class="modal fade" id="numberModal" tabindex="-1" role="dialog" aria-labelledby="numberModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">

      <div id="modalbody" class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
      </div>
    </div>
  </div>
</div>
		

<%
	set objRec = nothing
	set recNum = nothing
	set conn   = nothing	
%>
<script language="javascript">
	function download_manual(){
		window.open("key.html",null,'left=400, top=0, height=600, width= 700, status=yes, resizable= yes, scrollbars= no, toolbar= yes,location= no, menubar= yes' )
	}

	function clickpic(p){
		var t=p

		//alert(t)
		// รัฐบาล
		if (t==1){
			document.mypic.src ="images/price_tos.jpg"
			document.form1.game_type.value="2"
		}
		// ออมสิน
		if (t==2){
			document.mypic.src = "images/price_oth.jpg";
			document.form1.game_type.value="3"
		}
		// อื่นๆ
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

	    //	MyArgs=window.showModalDialog('cntTicketPlayer.asp', '', 'dialogTop:'+0+'px;dialogLeft:'+140+'px;dialogHeight:720px;dialogWidth:330px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');
	    location = "cntTicketPlayer.asp";
	    //	window.open('index.asp?page=cntTicketPlayer.asp', '_blank');

	    if (MyArgs == null) {
	        //	window.alert(
	        //	  "Nothing returned from child. No changes made to input boxes")
	    }
	    else {
	        //document.form1.proj_code.value=MyArgs[0].toString();
	    }

	}
</script>

<% End Sub %>