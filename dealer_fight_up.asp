<%@ Language=VBScript CodePage = 65001  %>
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
Dim objRs
Dim strSql
dim cntrow, cntcol
dim strOrder, strNumType, status20
	
	if Request("cmborder") = "" then 
		strOrder="money"
	else
		strOrder=Request("cmborder")
	end if
	if Request("cmbnumtype") = "" then 
		strNumType="rec"
	else
		strNumType=Request("cmbnumtype")
	end if

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set objRs = Server.CreateObject ("ADODB.Recordset")

	strSql="select login_id, isnull(use_20,'N') as use20 from sc_user where user_id=" & Session("uid") 
	set objRec=conn.Execute(strSql)
	if not objRec.eof Then
		If objRec("use20")="Y" Then
			status20 = 0.2
		Else
			status20 = 0
		End if
	end If
	if Request("act")="cal" then
		'คำนวน หา จำนวนเงินรับไว้
		strSql = "exec spA_FightUp " & Session("gameid") & "," &  Session("uid") & ", '" & strNumType & "'"
		set objRec = conn.Execute(strSql)
	end if

%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

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

<script language="javascript">
	function showsendto(formno){
		window.open("blank.htm", "_targetA","top=200,left=200,height=180,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
		if (formno==2) {
			document.form2.sendtype.value="1";
			document.form2.sendto.value="";
			document.form2.target = "_targetA";
			document.form2.action = "dealer_tudroum_fightup.asp";		
			document.form2.submit();
		} else if (formno==3) {
			document.form3.sendtype.value="1";
			document.form3.sendto.value="";
			document.form3.target = "_targetA";
			document.form3.action = "dealer_tudroum_fightup.asp";		
			document.form3.submit();
		} else if (formno==4) {
			document.form4.sendtype.value="1";
			document.form4.sendto.value="";
			document.form4.target = "_targetA";
			document.form4.action = "dealer_tudroum_fightup.asp";		
			document.form4.submit();
		} else if (formno==5) {
			document.form5.sendtype.value="1";
			document.form5.sendto.value="";
			document.form5.target = "_targetA";
			document.form5.action = "dealer_tudroum_fightup.asp";		
			document.form5.submit();
		} else if (formno==6) {
			document.form6.sendtype.value="1";
			document.form6.sendto.value="";
			document.form6.target = "_targetA";
			document.form6.action = "dealer_tudroum_fightup.asp";		
			document.form6.submit();
		}


//		window.open("dealer_tudroum_fightup.asp?formno="+formno, "_blank","top=200,left=200,height=180,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function txtsuu_keypress() {
	var keys = event.keyCode;
		if (keys==13) {
			document.form1.act.value = "suu";
			document.form1.submit();
		}
	}
	function cmbtudses_change() {
		document.form1.act.value = "suu";
		document.form1.submit();
	}

	function cmbnumtype_change() {
		document.form1.act.value = "cal";
		document.form1.submit();
	}
	function cmbformtype_change() {
		document.form1.act.value = "suu";
		document.form1.submit();
	}
	function convert_number(obj){
		var value=obj;
			if(value!=""){		
				return formatnum(value) ;		   
			}
		}	

	function gosendtype(st,uid,formno) {
	//return false;
		if (formno==2) {		
			document.form2.sendtype.value=st;
			document.form2.sendto.value=999;
			document.form2.sendfrom.value=uid;
			document.form2.target="_self";
			document.form2.action="dealer_tudroum_act.asp";			
			document.form2.submit();
		} else if (formno==3) {
			document.form3.sendtype.value=st;
			document.form3.sendto.value=999;
			document.form3.sendfrom.value=uid;
			document.form3.target="_self";
			document.form3.action="dealer_tudroum_act.asp";
			document.form3.submit();
		} else if (formno==4) {
			document.form4.sendtype.value=st;
			document.form4.sendto.value=999;
			document.form4.sendfrom.value=uid;
			document.form4.target="_self";
			document.form4.action="dealer_tudroum_act.asp";
			document.form4.submit();
		} else if (formno==5) {
			document.form5.sendtype.value=st;
			document.form5.sendto.value=999;
			document.form5.sendfrom.value=uid;
			document.form5.target="_self";
			document.form5.action="dealer_tudroum_act.asp";
			document.form5.submit();
		} else if (formno==6) {
			document.form6.sendtype.value=st;
			document.form6.sendto.value=999;
			document.form6.sendfrom.value=uid;
			document.form6.target="_self";
			document.form6.action="dealer_tudroum_act.asp";
			document.form6.submit();
		} 
	} 
	function open_setvalue(uid){
		window.open("dealer_setvalue_fight.asp?uid="+uid+"&fromup=Y", "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function checksetvalue(){
		window.open("dealer_check_suu.asp?gosuu=S", "_blank","top=200,left=200,height=150,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function open_analysis(){
		var suu=document.form1.txtsuu.value;
		var ses=document.form1.cmbtudses.value;
		if (suu=="")
		{
			suu=0;
		}
		window.open("dealer_fight_analysis.asp?uptype=U&suu="+suu+"&ses="+ses, "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

</script>
</HEAD>
<BODY topmargin=0 leftmargin=0 onLoad="document.all.txtsuu.focus();">
<%

	strSql = "exec spA_GetFightInfo  " & Session("gameid") & ",'U'"
'showstr strSql
	set objRs = conn.Execute(strSql)
	dim sumamt
	dim sumbefor
	sumamt = 0
	if Not objRs.Eof then
		sumamt = objRs("sum_receive")
		sumbefor = objRs("sum_befordisc")
	end if
	objRs.Close
%>
	<FORM METHOD=POST ACTION="dealer_fight_up.asp" name="form1">			
	<INPUT TYPE="hidden" name="act" value="">

	<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
		<TR>
			<Td colspan=2 bgColor="#4f4f4f">
				<TABLE width='100%' align=center >
					<TR>
						<td class="head_white" align="">รวมเงินแทงบน&nbsp;</td>
						<td class="head_white" align=""><INPUT TYPE="text" NAME="" readonly value= "<%=formatnumber(sumbefor,0)%>" style="width:120;text-align:right"></td>
						<td class="head_white" align="" rowspan=2>ตั้งสู้บน&nbsp;<INPUT TYPE="text" NAME="txtsuu" value="<%=Request("txtsuu")%>" style="width:120;text-align:right;height:30;FONT-SIZE: 14pt;COLOR: #000066;" onKeyPress="txtsuu_keypress();">&nbsp;บาท</td>
						<td class="head_white" align="">ตัดเศษ&nbsp;</td>
						<td class="head_white" align="">
<%
	dim vTudses
	if Request("cmbtudses") <> "" then
						strSql = "update sc_user set geb_ses=" & Request("cmbtudses") & " where user_id=" & Session("uid") 
						conn.Execute(strSql)
						Session("geb_ses") = Request("cmbtudses")	
'		Session("p7tudses") = Request("cmbtudses")
'		vTudses = Request("cmbtudses")
	elseif Session("geb_ses") <> "" then
		'vTudses = Session("geb_ses")
	else
		Session("geb_ses") = 1
	end if
	vTudses = Session("geb_ses")
%>
										<select style="width:130" name="cmbtudses" onChange="cmbtudses_change();">
											<option value="1" <%=selected(vTudses,"1")%>>1</option>
											<option value="5" <%=selected(vTudses,"5")%>>5</option>
											<option value="10" <%=selected(vTudses,"10")%>>10</option>
											<option value="20" <%=selected(vTudses,"20")%>>20</option>
											<option value="50" <%=selected(vTudses,"50")%>>50</option>
											<option value="100" <%=selected(vTudses,"100")%>>100</option>
										</select>&nbsp;
						</td>
						<td class="head_white" align="">ประเภท&nbsp;</td>
						<td class="head_white" align="">										
										<select style="width:100" name="cmbnumtype" onChange="cmbnumtype_change();">
											<option value="rec" <%=selected(Request("cmbnumtype"),"rec")%>>เลขรับไว้</option>
											<option value="all" <%=selected(Request("cmbnumtype"),"all")%>>เลขรับทั้งหมด</option>
											<option value="out" <%=selected(Request("cmbnumtype"),"out")%>>เลขแทงออก</option>
										</select>&nbsp;
						</td>
						<td class="head_white" align=""><INPUT TYPE="button" class="inputP" value="ตั้งค่า" onClick="open_setvalue(<%=Session("uid")%>);" style="cursor:hand; width: 100px;">&nbsp;</td>
					</TR>
					<TR>
						<td class="head_white" align="">รวมเงินหักส่วนลด&nbsp;</td>
						<td class="head_white" align=""><INPUT TYPE="text" NAME="" readonly style="width:120;text-align:right" value="<%=formatnumber(sumamt,0)%>">&nbsp;</td>
						<td class="head_white" align="">การส่งโพย&nbsp;</td>
						<td class="head_white" align="">										
										<select style="width:130" name="formtype" onChange="cmbformtype_change();">
											<option value="1" <%=selected(Request("formtype"),"1")%>>รวมส่งเจ้ามือเดียว</option>
											<option value="2" <%=selected(Request("formtype"),"2")%>>แยกส่งหลายเจ้ามือ</option>
										</select>&nbsp;
						</td>
						<td class="head_white" align="">เรียง&nbsp;</td>
						<td class="head_white" align="">
										<select style="width:100" name="cmborder" onChange="cmborder_onChange();">
											<option value="money" <%=selected(Request("cmborder"),"money")%>>เรียงตามเงิน</option>
											<option value="num" <%=selected(Request("cmborder"),"num")%>>เรียงตามเลข</option>
										</select>								
						&nbsp;</td>
						<td class="head_white" align=""><INPUT TYPE="button" class="inputE" value="วิเคราะห์บน" onClick="open_analysis();" style="cursor:hand; width: 100px;"> &nbsp;</td>
					</TR>
				</Table>
			</td>
		</TR>
		<TR>
	</FORM>
			<TD bgColor="#FFFFFF">
					<TABLE width='100%' align=center>  	
						<tr bgcolor='#FFFFFF'>
							<td>
<%		
			strSql = "exec spA_GetFightNumber " & Session("gameid") & "," &  Session("uid") & ",'U', '" & strOrder & "'"
'showstr strSql
			set objRec = conn.Execute(strSql)
			dim playamt
			dim numcolor
			cntcol=0
			cntrow=0
			playamt=0
			response.write "	<TABLE  align=center >"
			do while not objRec.eof
				playamt = clng(objRec("play_amt"))
				numcolor = ""
				if clng(objRec("play_amt")) < 0 then 
					numcolor = "#FF0000"
					playamt =  clng(objRec("play_amt")) * -1
				end if

				if cntcol=0 then 
					response.write "		<tr bgcolor=#FFFFFF>"
				end if
				response.write "<td width='150' class='box3'>"&objRec("play_number")&" = <font color="&numcolor&">"&FormatNumber(playamt,0)&"</font></td>"
				cntcol=cntcol+1
				if cntcol=10 then
					cntrow=cntrow+1
					response.write "		</tr>"
					cntcol=0
				end if
				objRec.MoveNext
			loop
			response.write "	</table>"
			objRec.Close
			%>
							</td>
						</Tr>
					</Table>
<!-- **************************************   ตั้งสู้ **************************************** -->
<%
dim tmpType
dim frmNo
dim chkEnd

					if Request("act") = "suu"  and Request("txtsuu")<>"" then
					
						strSql = "exec spA_UpTungSuu " & Session("gameid") & ",  " & Session("uid") & " , " & Request("txtsuu") & ", " & vTudses
						set objRec = conn.Execute(strSql)

%>		
<%
'****************  กรณีรวม form formtype = 1   กรณีแยก form  formtype = 2 \

'****************  กรณีแยก form 
						if Request("formtype") = "2" then
								frmNo = 1
								do while not objRec.eof
									if tmpType <> objRec("play_type") then
										cntcol=0
										cntrow=0
										playamt=0
										sumamt = 0
										tmpType = objRec("play_type")
										if tmpType = "1" then
											frmNo = 2
										elseif tmpType = "5" then
											frmNo = 3
										elseif tmpType = "3" then
											frmNo = 4
										elseif tmpType = "2" then
											frmNo = 5
										end if

%>
						<FORM METHOD=POST name="form<%=frmNo%>" action="dealer_tudroum_fightup.asp" target=""> <!--  ACTION="dealer_tudroum_act.asp" -->
							<INPUT TYPE="hidden" name="tud1" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud2" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud3" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud4" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud5" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud6" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud7" value="<%=Request("txtsuu")%>">
							<INPUT TYPE="hidden" name="tud8" value="<%=Request("txtsuu")%>">

							<TABLE width='100%' align=center class=box1b >  	
								<tr class=text_black >
									<td colspan=8 height=20 align=center><FONT SIZE="3" COLOR="">จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<span id="sumsend<%=frmNo%>"></span></font></td>
								</tr>
								<tr bgcolor='#FFFFFF' height=30>
									<td colspan=5 align=center class=box1b><FONT SIZE="3" COLOR=""><%=GetValueFromTable("mt_reference_det", "ref_det_desc", "ref_id=8 and ref_code='" &objRec("play_type")& "'")%></FONT></td>
									<td class="box1b"><INPUT TYPE="button" name="btSend<%=frmNo%>" value="ส่งเจ้ามืออื่น" class="inputP" style="cursor:hand; width: 100px;" onClick=showsendto(<%=frmNo%>)>&nbsp;&nbsp;<INPUT TYPE="button" name="btPrint<%=frmNo%>" value="พิมพ์ออก" class="inputR" style="cursor:hand; width: 100px;" onClick=gosendtype("2",<%=Session("uid")%>,<%=frmNo%>)></td>
								</tr>

<%
									end if
									playamt =  clng(objRec("play_suu"))
									playamt = Round(playamt + (playamt * status20))
									sumamt = sumamt + playamt

									if cntcol=0 then 
										response.write "		<tr bgcolor=#FFFFFF>" & chr(13)
									end if
									if tmpType = "1" then
										response.write "<INPUT TYPE='hidden' name='txt1up' value=''><INPUT TYPE='hidden' name='txt1upmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3tod' value=''><INPUT TYPE='hidden' name='txt3todmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3up' value=''><INPUT TYPE='hidden' name='txt3upmoney' value=''>" & chr(13)
										response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt2up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt2upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
										response.write "<input type=hidden name='2upcuttype' value='1'>" & chr(13)
									elseif tmpType = "5" then
										response.write "<INPUT TYPE='hidden' name='txt2up' value=''><INPUT TYPE='hidden' name='txt2upmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3tod' value=''><INPUT TYPE='hidden' name='txt3todmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3up' value=''><INPUT TYPE='hidden' name='txt3upmoney' value=''>" & chr(13)
										response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt1up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt1upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
										response.write "<input type=hidden name='1upcuttype' value='1'>" & chr(13)
									elseif tmpType = "3" then
										response.write "<INPUT TYPE='hidden' name='txt1up' value=''><INPUT TYPE='hidden' name='txt1upmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt2up' value=''><INPUT TYPE='hidden' name='txt2upmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3up' value=''><INPUT TYPE='hidden' name='txt3upmoney' value=''>" & chr(13)
										response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3tod' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt3todmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
										response.write "<input type=hidden name='3todcuttype' value='1'>"
									elseif tmpType = "2" then
										response.write "<INPUT TYPE='hidden' name='txt1up' value=''><INPUT TYPE='hidden' name='txt1upmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt3tod' value=''><INPUT TYPE='hidden' name='txt3todmoney' value=''>" & chr(13)
										response.write "<INPUT TYPE='hidden' name='txt2up' value=''><INPUT TYPE='hidden' name='txt2upmoney' value=''>" & chr(13)
										response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt3upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
										response.write "<input type=hidden name='3upcuttype' value='1'>" & chr(13)
									end if
									cntcol=cntcol+1
									if cntcol=6 then
										cntrow=cntrow+1
										response.write "		</tr>" & chr(13)
										cntcol=0
									end if
									objRec.MoveNext
									chkEnd = "No"
									if objRec.Eof   then
										chkEnd = "Yes"
									else
										if tmpType <> objRec("play_type") then
											chkEnd = "Yes"
										end if
									end if
									if chkEnd = "Yes" Then
										Call shwBlankBox(tmpType,"") 
%>
												<tr>		
													<input type=hidden name="sendfrom">
													<input type=hidden name="sendto">
													<input type=hidden name="sendtype">
													<input type=hidden name="sendweb">			
													<input type=hidden name="sendweb2">			
													<INPUT TYPE="hidden" name="fromFgUp" value="yes">

													<td class=textbig_blue align=center colspan=6 ><!--<INPUT TYPE="button" name="action" value="ส่งเจ้ามืออื่น" class=button_blue onClick=showsendto(<%=frmNo%>)>&nbsp;&nbsp;<INPUT TYPE="button" name="action" value="พิมพ์ออก" class=button_red onClick=gosendtype("2",<%=Session("uid")%>,<%=frmNo%>)>--></td>
												</tr>
											</Table>

											<script language=javascript>document.all.sumsend.innerText='<%=formatnumber(sumamt)%>';</script>
										</Form><br><br>
<%
									end if
								loop
								objRec.Close
								'*******************  จบ กรณีแยก form
						else 
								'*******************  กรณีรวม form
%>
							<form name="form6"  method="post" action="dealer_tudroum_act.asp">
								<INPUT TYPE="hidden" name="tud1" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud2" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud3" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud4" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud5" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud6" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud7" value="<%=Request("txtsuu")%>">
								<INPUT TYPE="hidden" name="tud8" value="<%=Request("txtsuu")%>">

								<TABLE width='100%' align=center class=box1b >  	
									<tr class=text_black >
										<td colspan=8 height=20 align=center><FONT SIZE="3" COLOR="">จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<span id="sumsend2"></span></font></td>
									</tr>

			<%
									Dim otmpType
									otmpType=""
									frmNo = 1 ' เปลี่ยนจากส่งได้หลายเจ้า เป็นส่งแค่ 1 เจ้า
									sumamt = 0
									do while not objRec.eof
										if tmpType <> objRec("play_type") then
											cntcol=0
											cntrow=0
											playamt=0
											tmpType = objRec("play_type")

											If otmpType<>"" Then Call shwBlankBox(otmpType,"")  'jum 2006-12-20

			%>						
									<tr bgcolor='#FFFFFF' height=30>
										<td colspan=6 align=center class=box1b><FONT SIZE="3" COLOR=""><%=GetValueFromTable("mt_reference_det", "ref_det_desc", "ref_id=8 and ref_code='" &objRec("play_type")& "'")%></FONT></td>
									</tr>

			<%
										end if
										playamt =  clng(objRec("play_suu"))
										playamt = Round(playamt + (playamt * status20))

										if playamt > 0 then ' กรณีตัดเศษแล้วเป็น 0 ต้องไม่แสดง							
												sumamt = sumamt + clng(objRec("play_suu"))
												if cntcol=0 then 
													response.write "		<tr bgcolor=#FFFFFF>" & chr(13)
												end if
												if tmpType = "1" then
													response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt2up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt2upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
													response.write "<input type=hidden name='2upcuttype' value='1'>" & chr(13)
												elseif tmpType = "5" then
													response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt1up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt1upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
													response.write "<input type=hidden name='1upcuttype' value='1'>" & chr(13)
												elseif tmpType = "3" then
													response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3tod' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt3todmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
													response.write "<input type=hidden name='3todcuttype' value='1'>"
												elseif tmpType = "2" then
													response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3up' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt3upmoney' value='" & playamt & "' size=7 ></td>" & chr(13)
													response.write "<input type=hidden name='3upcuttype' value='1'>" & chr(13)
												end if
												cntcol=cntcol+1
												if cntcol=6 then
													cntrow=cntrow+1
													response.write "		</tr>" & chr(13)
													cntcol=0
												end If
												otmpType=tmpType
										end if
										objRec.MoveNext
															
									loop
									objRec.Close
									Call shwBlankBox(otmpType,"") 
			%>
									
													<tr>		
														<input type=hidden name="sendfrom">
														<input type=hidden name="sendto">
														<input type=hidden name="sendtype">
														<input type=hidden name="sendweb">			
														<input type=hidden name="sendweb2">		
														<INPUT TYPE="hidden" name="fromFgUp" value="yes">
														
														<td class=textbig_blue align=center colspan=6 ><INPUT TYPE="button" name="senddealer" value="ส่งเจ้ามืออื่น" class="inputE" style="cursor:hand; width: 100px;" onClick=showsendto(6)>&nbsp;&nbsp;<INPUT TYPE="button" name="printout" value="พิมพ์ออก" class="inputR" style="cursor:hand; width: 100px;" onClick=gosendtype("2",<%=Session("uid")%>,6)></td>
													</tr> 
												</Table>
												<script language=javascript>document.all.sumsend2.innerText='<%=formatnumber(sumamt)%>';</script>
											</form><br><br>
			<%



								'*******************  จบ กรณีรวม form
						end if

					end if
'showstr " ses "  & Session("geb_ses") 					
					
%>
<!-- **************************************  end  ตั้งสู้ **************************************** -->
			</TD>
		</TR>
	</Table>
</Body>
</Html>
<%
sub GenEmptyCol(cntCol, cntRow)
dim i
	for i = 1 to (5 - cntCol)
		response.write "<td width=100 class=box2>&nbsp;</td>"
	next 
end Sub
' jum 2006-12-20
Sub shwBlankBox(tmpType, playamt)
	Dim i, j
		For j=1 To 5
		Response.write "<tr>"
		For i=1 To 6
			if tmpType = "1" then
				response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt2up'  size=2 onKeyDown='chkEnter(this);' id=" & j&i & "n" & tmpType &">=<input type='text' NAME='txt2upmoney' value='" & playamt & "' size=7 onKeyDown='chkEnter(this);' id=" & j&i & "m" & tmpType &"></td>" & chr(13)
				response.write "<input type=hidden name='2upcuttype' value='2'>" & chr(13)
			elseif tmpType = "5" then
				response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt1up'  size=2 onKeyDown='chkEnter(this);' id=" & j&i & "n" & tmpType &">=<input type='text' NAME='txt1upmoney' value='" & playamt & "' size=7 onKeyDown='chkEnter(this);' id=" & j&i & "m" & tmpType &"></td>" & chr(13)
				response.write "<input type=hidden name='1upcuttype' value='2'>" & chr(13)
			elseif tmpType = "3" then
				response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3tod' size=2 onKeyDown='chkEnter(this);' id=" & j&i & "n" & tmpType &">=<input type='text' NAME='txt3todmoney' value='" & playamt & "' size=7 onKeyDown='chkEnter(this);' id=" & j&i & "m" & tmpType &"></td>" & chr(13)
				response.write "<input type=hidden name='3todcuttype' value='2'>"
			elseif tmpType = "2" then
				response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt3up' size=2 onKeyDown='chkEnter(this);' id=" & j&i & "n" & tmpType &">=<input type='text' NAME='txt3upmoney' value='" & playamt & "' size=7 onKeyDown='chkEnter(this);' id=" & j&i & "m" & tmpType &"></td>" & chr(13)
				response.write "<input type=hidden name='3upcuttype' value='2'>" & chr(13)
			end If
		next
		Response.write "</tr>"	
	next
End sub
%>
<script language="javascript">
	function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			var id=obj.id
			n1=id.substring(0,1)
			n2=id.substring(1,2)
			n3=id.substring(2,3)
			n4=id.substring(3,4)
			if(n3=="n"){
				n3="m";
			}else{
				n3="n";
				n2=parseInt(n2)+1;
			}
			if(parseInt(n2)>6){
				n3='n';
				n2=1;
				n1=parseInt(n1)+1;			
			}
			if(n1>5){ return true;}
		    next_id=n1+''+n2+''+n3+''+n4;
			next_obj = document.getElementById(  next_id )	
			next_obj.focus()
		}
	}
	function submitallform(){
		 showsendto(2);
		 showsendto(3);
		 showsendto(4);
		 showsendto(5);
	}
	
</script>
<!-- jum 2006-12-20 -->