<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>

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
		strSql = "exec spA_FightDown " & Session("gameid") & "," &  Session("uid") & ", '" & strNumType & "'"
		set objRec = conn.Execute(strSql)
		'objRec.Close()
	end if

%>

<LINK href="include/code.css" type=text/css rel=stylesheet>

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
		//window.open("dealer_tudroum_send.asp", "_blank","top=200,left=200,height=180,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
		window.open("blank.htm", "_targetA","top=200,left=200,height=180,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
		document.form2.target = "_targetA";
		document.form2.Action = "dealer_tudroum_send.asp";
		document.form2.submit();

	}

	function txtsuu_keypress() {
	var keys = event.keyCode;
		if (keys==13) {
			document.form1.act.value = "suu";
			document.form1.submit();
		}
	}
	function convert_number(obj){
		var value=obj;
			if(value!=""){		
				return formatnum(value) ;		   
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

	function gosendtype(st,uid) {	
		if (confirm("คุณยืนยันที่จะทำการพิมพ์ออก หรือไม่ ?")) {	
			document.form2.sendtype.value=st;
			document.form2.sendto.value=999;
			document.form2.sendfrom.value=uid;
			document.form2.target="";
			document.form2.action="dealer_tudroum_act.asp";
			document.form2.submit();
		}
	}

	function open_analysis(){
		var suu=document.form1.txtsuu.value;
		var ses=document.form1.cmbtudses.value;
		if (suu=="")
		{
			suu=0;
		}
		window.open("dealer_fight_analysis.asp?uptype=D&suu="+suu+"&ses="+ses, "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

</script>

<%
	strSql = "exec spA_GetFightInfo  " & Session("gameid") & ",'D'"
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
	<FORM METHOD=POST ACTION="dealer_fight_down.asp" name="form1">			
	<INPUT TYPE="hidden" name="act" value="">

	<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
		<TR>
			<Td colspan=2 bgColor="#4f4f4f">
				<TABLE width='100%' align=center >
					<TR>
						<td width="25%" align=right class="head_white">รวมเงินแทงล่าง&nbsp;
						</td>
						<td width="25%"><INPUT TYPE="text" NAME="" readonly value= "<%=formatnumber(sumbefor,0)%>" style="width:120;text-align:right">
						</td>
						<td width="25%" align=right class="head_white">ตั้งสู้&nbsp;
						</td>
						<td width="25%" class="head_white"><INPUT TYPE="text" NAME="txtsuu" value="<%=Request("txtsuu")%>" style="width:120;text-align:right" onKeyPress="txtsuu_keypress();">&nbsp;บาท
						</td>
					</TR>
					<TR>
						<td width="25%" align=right class="head_white">รวมเงินหักส่วนลด&nbsp;
						</td>
						<td width="25%"><INPUT TYPE="text" NAME="" readonly style="width:120;text-align:right" value="<%=formatnumber(sumamt,0)%>">
						</td>
						<td width="25%" align=right class="head_white"><!-- จำนวนทุน -->&nbsp;
						</td>
						<td width="25%">&nbsp;<!-- <INPUT TYPE="text" NAME="" readonly style="width:120;text-align:right" value="0"> -->
						</td>
					</TR>
				</Table>
			</td>
		</TR>
		<TR>
			<TD width="150" bgColor="#4f4f4f" valign=top>
					<TABLE width='100%' align=center >
						<TR>
							<Td class="head_white">ตัดเศษ
							</Td>
						</TR>
						<TR>	
							<TD>
<%
	dim vTudses
	if Request("cmbtudses") <> "" then
						strSql = "update sc_user set geb_ses=" & Request("cmbtudses") & " where user_id=" & Session("uid") 
						conn.Execute(strSql)
						Session("geb_ses") = Request("cmbtudses")	
	elseif Session("geb_ses") <> "" then
	else
		Session("geb_ses") = 1
	end if
	vTudses = Session("geb_ses")
%>
								<select style="width:100" name="cmbtudses" onChange="cmbtudses_change();">
									<option value="1" <%=selected(vTudses,"1")%>>1</option>
									<option value="5" <%=selected(vTudses,"5")%>>5</option>
									<option value="10" <%=selected(vTudses,"10")%>>10</option>
									<option value="20" <%=selected(vTudses,"20")%>>20</option>
									<option value="50" <%=selected(vTudses,"50")%>>50</option>
									<option value="100" <%=selected(vTudses,"100")%>>100</option>
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
							<TD><INPUT TYPE="button" class="inputE" value="วิเคราะห์ล่าง"  onClick="open_analysis();"  style="cursor:hand; width: 100px;"> 
							</TD>
						</TR>

					</TABLE>
			</TD>
	</FORM>
			<TD bgColor="#FFFFFF">
					<TABLE width='100%' align=center>  	
						<tr bgcolor='#FFFFFF'>
<%		
			strSql = "exec spA_GetFightNumber " & Session("gameid") & "," &  Session("uid") & ",'D', '" & strOrder & "'"
			set objRec = conn.Execute(strSql)
			dim playamt
			dim numcolor
			cntcol=0
			cntrow=0
			playamt=0
			do while not objRec.eof
				playamt =  clng(objRec("play_amt"))
				numcolor = ""
				if clng(objRec("play_amt")) < 0 then 
					numcolor = "#FF0000"
					playamt =  clng(objRec("play_amt")) 
				end if

				if cntcol=0 then 
					response.write "<td  class='box2' width='20%'>"
					response.write "	<TABLE width='100%' align=center >"
				end if
				response.write "		<tr bgcolor=#FFFFFF>"
				response.write "<td width='20%' class='text_black'>"&objRec("play_number")&"<font color='#0000FF'> = </font><font color="&numcolor&">"&formatnumber(playamt,0)&"</font></td>"
				response.write "		</tr>"
				cntcol=cntcol+1
				if cntcol=20 then
					cntrow=cntrow+1
					response.write "	</table>"
					response.write "</td>"
					cntcol=0
				end if
				objRec.MoveNext
			loop
			objRec.Close
			%>

					</Table>
<!-- **************************************   ตั้งสู้ **************************************** -->
	<%
					if Request("act") = "suu" and Request("txtsuu") <> "" then

						strSql = "exec spA_DownTungSuu " & Session("gameid") & ", 'D', " & Request("txtsuu") & ", " & vTudses
'showstr strSql
						set objRec = conn.Execute(strSql)

%>		
				<FORM METHOD=POST name="form2" ACTION="dealer_tudroum_send.asp" target=""> <!--  ACTION="dealer_tudroum_act.asp" -->
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
							<td colspan=8 height=20 align=center><FONT SIZE="3" COLOR="">จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<span id="sumsend"></span></font></td>
						</tr>
						<tr bgcolor='#FFFFFF' height=30>
							<td colspan=6 align=center class=box1b><FONT SIZE="3" COLOR="">สองตัวล่าง</FONT></td>
						</tr>
<%
						cntcol=0
						cntrow=0
						playamt=0
						sumamt = 0
						do while not objRec.eof
							playamt =  clng(objRec("play_suu"))
							if playamt > 0 then ' กรณีตัดเศษแล้วเป็น 0 ต้องไม่แสดง
								sumamt = sumamt + clng(objRec("play_suu"))
								if cntcol=0 then 
									response.write "		<tr bgcolor=#FFFFFF>" & chr(13)
								end if
								response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt2down' value='" & objRec("play_number") & "' size=2 readonly>=<input type='text' NAME='txt2downmoney' value='" & playamt & "' size=7></td>" & chr(13)
								response.write "<input type=hidden name='2downcuttype' value='1'>"
								cntcol=cntcol+1
								if cntcol=6 then
									cntrow=cntrow+1
									response.write "		</tr>" & chr(13)
									cntcol=0
								end if
							end if
							objRec.MoveNext
						Loop
						'jum 2006-12-20
						Dim j,k
						For j=1 To 5
							response.write "<tr>"
							For k=1 To 6
								response.write "<td width='16%' class='text_black'><INPUT TYPE='text' NAME='txt2down'  size=2 id=" & j & k & "n onKeyDown='chkEnter(this);'>=<input type='text' NAME='txt2downmoney' size=7 id=" & j & k & "m onKeyDown='chkEnter(this);'></td>" & chr(13)
										response.write "<input type=hidden name='2downcuttype' value='2'>"
							Next
							response.write "</tr>"
						Next
						'jum 2006-12-20
%>
						<tr>		
							<input type=hidden name="sendfrom">
							<input type=hidden name="sendto">
							<input type=hidden name="sendtype">
							<input type=hidden name="sendweb">			
							<input type=hidden name="sendweb2">			
							<td class=textbig_blue align=center colspan=6 ><INPUT TYPE="button" name="btSend" value="ส่งเจ้ามืออื่น" class="inputP"  style="cursor:hand; width: 100px;" onClick=showsendto()>&nbsp;&nbsp;<INPUT TYPE="button" name="btPrint" value="พิมพ์ออก" class="inputR"  style="cursor:hand; width: 100px;" onClick=gosendtype("2",<%=Session("uid")%>)></td>
						</tr>
					</Table>
					<script language=javascript>document.all.sumsend.innerText= '<%=formatnumber(sumamt)%>';</script>
				</Form>
<%

						objRec.Close

					end if
%>
<!-- **************************************  end  ตั้งสู้ **************************************** -->
			</TD>
		</TR>
	</Table>

<script language="javascript">
	function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			var id=obj.id
			n1=id.substring(0,1)
			n2=id.substring(1,2)
			n3=id.substring(2,3)
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
		    next_id=n1+''+n2+''+n3;
			next_obj = document.getElementById(  next_id )	
			next_obj.focus()
		}
	}
</script>
<!-- jum 2006-12-20 -->
<% End sub %>