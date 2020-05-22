<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
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
dim strOrder, strNumType
	
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
	if Request("act")="cal" then
		'คำนวน หา จำนวนเงินรับไว้
		strSql = "exec spA_FightUp " & Session("gameid") & "," &  Session("uid") & ", '" & strNumType & "'"
'showstr strSql
		set objRec = conn.Execute(strSql)
		'objRec.Close()
	end if

%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
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

	function showsendto(){
			document.form2.sendtype.value="1";
			document.form2.sendto.value="";
			window.open("dealer_tudroum_fightup.asp", "_blank","top=200,left=200,height=180,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
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
	function convert_number(obj){
		var value=obj;
			if(value!=""){		
				return formatnum(value) ;		   
			}
		}	

	function gosendtype(st,uid) {
		if (confirm("คุณยืนยันที่จะทำการพิมพ์ออก หรือไม่ ?")) {	
			document.form2.sendtype.value=st;
			document.form2.sendto.value=999;
			document.form2.sendfrom.value=uid;
			document.form2.submit();
		}
	}

	function open_setvalue(){
		window.open("dealer_setvalue_fight.asp", "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function open_analysis(){
		window.open("dealer_fight_analysis.asp?uptype=U", "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
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

	<TABLE width='100%' align=center class=table_blue bgColor="#FFFFFF">
		<TR>
			<Td colspan=2 bgColor="#E0E0E0">
				<TABLE width='100%' align=center >
					<TR>
						<td width="25%" align=right class="head_black">รวมเงินแทงบน&nbsp;
						</td>
						<td width="25%"><INPUT TYPE="text" NAME="" readonly value= "<%=formatnumber(sumbefor,0)%>" style="width:120;text-align:right">
						</td>
						<td width="25%" align=right class="head_black">ตั้งสู้&nbsp;
						</td>
						<td width="25%" class="head_black"><INPUT TYPE="text" NAME="txtsuu" value="<%=Request("txtsuu")%>" style="width:120;text-align:right" onKeyPress="txtsuu_keypress();">&nbsp;บาท
						</td>
					</TR>
					<TR>
						<td width="25%" align=right class="head_black">รวมเงินหักส่วนลด&nbsp;
						</td>
						<td width="25%"><INPUT TYPE="text" NAME="" readonly style="width:120;text-align:right" value="<%=formatnumber(sumamt,0)%>">
						</td>
						<td width="25%" align=right class="head_black"><!-- จำนวนทุน -->&nbsp;
						</td>
						<td width="25%">&nbsp;<!-- <INPUT TYPE="text" NAME="" readonly style="width:120;text-align:right" value="0"> -->
						</td>
					</TR>
				</Table>
			</td>
		</TR>
		<TR>
			<TD width="150" bgColor="#E0E0E0" valign=top>
					<TABLE width='100%' align=center >
						<TR>
							<Td class="head_black">ตัดเศษ
							</Td>
						</TR>
						<TR>	
							<TD>
								<select style="width:100" name="cmbtudses" onChange="cmbtudses_change();">
									<option value="1" <%=selected(Request("cmbtudses"),"1")%>>1</option>
									<option value="5" <%=selected(Request("cmbtudses"),"5")%>>5</option>
									<option value="10" <%=selected(Request("cmbtudses"),"10")%>>10</option>
									<option value="20" <%=selected(Request("cmbtudses"),"20")%>>20</option>
									<option value="50" <%=selected(Request("cmbtudses"),"50")%>>50</option>
									<option value="100" <%=selected(Request("cmbtudses"),"100")%>>100</option>
								</select>								
							</TD>
						</TR>
						<TR>
							<TD>
								<select style="width:100" name="cmborder" onChange="cmborder_onChange();">
									<option value="money" <%=selected(Request("cmborder"),"money")%>>เรียงตามเงิน</option>
									<option value="num" <%=selected(Request("cmborder"),"num")%>>เรียงตามเลข</option>
								</select>								
							</TD>
						</TR>
						<TR>
							<TD>
								<select style="width:100" name="cmbnumtype" onChange="cmbnumtype_change();">
									<option value="rec" <%=selected(Request("cmbnumtype"),"rec")%>>เลขรับไว้</option>
									<option value="all" <%=selected(Request("cmbnumtype"),"all")%>>เลขรับทั้งหมด</option>
									<option value="out" <%=selected(Request("cmbnumtype"),"out")%>>เลขแทงออก</option>
								</select>								
							</TD>
						</TR>

						<TR>
							<TD><INPUT TYPE="button" class=button_blue value="ตั้งค่า" onClick="open_setvalue();" style="width:100"> 
							</TD>
						</TR>
						<TR>
							<TD><INPUT TYPE="button" class=button_blue value="วิเคราะห์บน" onClick="open_analysis();" style="width:100"> 
							</TD>
						</TR>
					</TABLE>
			</TD>
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
				playamt =  clng(objRec("play_amt"))
				numcolor = ""
				if clng(objRec("play_amt")) < 0 then 
					numcolor = "#FF0000"
					playamt =  clng(objRec("play_amt")) 
				end if

				if cntcol=0 then 
					response.write "		<tr bgcolor=#FFFFFF>"
				end if
				response.write "<td class='text_black' nowrap>"&objRec("play_number")&" <font color='#0000FF'> = </font><font color="&numcolor&">"&formatnumber(playamt,0)&"</font>&nbsp;</td>"
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
					if Request("act") = "suu" and Request("txtsuu") <> "" then
dim tmpType
dim frmNo
dim chkEnd
						strSql = "exec spA_UpTungSuu " & Session("gameid") & ",  " & Session("uid") & " , " & Request("txtsuu") & ", " & Request("cmbtudses") 
'showstr strSql
						set objRec = conn.Execute(strSql)

%>		
				<FORM METHOD=POST name="form2" ACTION="dealer_tudroum_act.asp" target="_blank">
					<INPUT TYPE="hidden" name="tud1" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud2" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud3" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud4" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud5" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud6" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud7" value="<%=Request("txtsuu")%>">
					<INPUT TYPE="hidden" name="tud8" value="<%=Request("txtsuu")%>">

					<TABLE width='100%' align=center class=box1 >  	
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
							<td colspan=6 align=center class=box1><FONT SIZE="3" COLOR=""><%=GetValueFromTable("mt_reference_det", "ref_det_desc", "ref_id=8 and ref_code='" &objRec("play_type")& "'")%></FONT></td>
						</tr>

<%
							end if
							playamt =  clng(objRec("play_suu"))
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
											<td class=textbig_blue align=center colspan=6 ><INPUT TYPE="button" name="action" value="ส่งเจ้ามืออื่น" class=button_blue onClick=showsendto()>&nbsp;&nbsp;<INPUT TYPE="button" name="action" value="พิมพ์ออก" class=button_red onClick=gosendtype("2",<%=Session("uid")%>)></td>
										</tr> 
									</Table>
									<script language=javascript>document.all.sumsend2.innerText=convert_number('<%=sumamt%>');</script>
								</Form><br><br>
<%

					end if
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
</script>
<!-- jum 2006-12-20 -->