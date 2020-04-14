<!--#include virtual="masterpage.asp"-->
<% 
Dim objRec
dim recNum
Dim strSql
Dim cntApp
dim chkRow
dim strdel
dim strTmp

dim tud1
dim tud2
dim tud3
dim tud4 
dim tud5
dim tud6
dim tud7
dim tud8

Dim cutperctype
Dim cutperc

dim i
dim tmpColColor
tmpColColor="#99FFFF" 
%>
<% Sub ContentPlaceHolder() %>

<%



	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	
	Session("p1order")=Request("cmborder")
	Session("p1numtype")=Request("cmbnumtype")

	cutperctype=Request("cmbcutperctype")
	cutperc=Request("txtperccut")

	Session("cutperctype") = ""
	Session("cutperc") = ""
	If cutperctype <> "" Then
		Session("cutperctype") = cutperctype
		Session("cutperc") = cutperc
	End If 


	'tud1=0:tud2=0:tud3=0:tud4=0:tud5=0:tud6=0:tud7=0:tud8=0	
	if Request("act")="tud" then
		if trim(Request("txttud1")) <> "" then 
			tud1=clng(Request("txttud1"))
		else
			'tud1=0
		end if
		if trim(Request("txttud2")) <> "" then 
			tud2=clng(Request("txttud2"))
		else
			'tud2=0
		end if
		if trim(Request("txttud3")) <> "" then 
			tud3=clng(Request("txttud3"))
		else
			'tud3=0
		end if
		if trim(Request("txttud4")) <> "" then 
			tud4=clng(Request("txttud4"))
		else
			'tud4=0
		end if
		if trim(Request("txttud5")) <> "" then 
			tud5=clng(Request("txttud5"))
		else
			'tud5=0
		end if

		if trim(Request("txttud6")) <> "" then 
			tud6=clng(Request("txttud6"))
		else
			'tud6=0
		end if
		if trim(Request("txttud7")) <> "" then 
			tud7=clng(Request("txttud7"))
		else
			'tud7=0
		end if
		if trim(Request("txttud8")) <> "" then 
			tud8=clng(Request("txttud8"))
		else
			'tud8=0
		end if


	end if
	

%>



<script Language="VBScript" >	
	sub cmborder_onChange()
		form1.submit()
	end sub

	sub cmbnumtype_onChange()
		form1.submit()
	end sub

</script>

<script Language="JavaScript">	

	function click_tudpercent() {
//		document.form1.tudauto.value="up";
		if (document.form1.txtperccut.value=="")
		{
			alert("กรุณาระบุจำนวน % .");
			return false
		} else if (isNaN(document.form1.txtperccut.value))		{
			alert("กรุณาระบุจำนวน % เป็นตัวเลข.");
			return false
		} else if (document.form1.txtperccut.value < 1 || document.form1.txtperccut.value > 99)		{
			alert("กรุณาตรวจสอบุจำนวน % 1 - 99.");
			return false
		}
		document.form1.txttud1.value = "";
		document.form1.txttud2.value = "";
		document.form1.txttud3.value = "";
		document.form1.txttud4.value = "";
		document.form1.txttud5.value = "";
		document.form1.txttud6.value = "";
		document.form1.txttud7.value = "";
		document.form1.txttud8.value = "";
		document.form1.submit();
	}
//	function click_tudall() {
//		document.form1.tudauto.value="all";
//		document.form1.submit();
//	}
//	function click_tuddown() {
//		document.form1.tudauto.value="down";
//		document.form1.submit();
//	}

	function txttud_keypress(obj) {
	var keys = event.keyCode;
		if (keys==13) {
			document.form1.cmbcutperctype.value = "";
			document.form1.txtperccut.value = "";
			document.form1.submit();
		} else if (keys > 57 || keys < 48) {
			alert("กรุณาระบุเป็นตัวเลข");
			obj.focus();

		}
	}

	function txttud_blur(obj) {
		if (obj.value == "") {
			;
		} else {
			if (isNaN(obj.value)) {
				obj.value = "";
			}
		}
	}

	function showsendto(){
		document.form2.sendtype.value="1";
		document.form2.sendto.value="";
		window.open("blank.htm", "_targetA","top=200,left=200,height=180,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
		document.form2.target = "_targetA";
		document.form2.Action = "dealer_tudroum_send.asp";
		document.form2.submit();
	}
<%
if Request("act")="tud" or Request("act")="out" then	 
%>	
	function CheckKeyCode(obj, ind) {
	var keys = event.keyCode;
	var mylen ;
		if (keys==13) {
			if (!isNaN(obj.value) && obj.name=="txt2upmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt3upmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt3todmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt2todmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt1upmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt1downmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt2downmoney")		{calSumCutAll();}
			if (!isNaN(obj.value) && obj.name=="txt3downmoney")		{calSumCutAll();}

			
			if (obj.name=="txt2up" || obj.name=="txt2upmoney")		{mylen=document.all.txt2upmoney.length-1;}
			if (obj.name=="txt3up" || obj.name=="txt3upmoney")		{mylen=document.all.txt3upmoney.length-1;}
			if (obj.name=="txt3tod" || obj.name=="txt3todmoney")	{mylen=document.all.txt3todmoney.length-1;}
			if (obj.name=="txt2tod" || obj.name=="txt2todmoney")	{mylen=document.all.txt2todmoney.length-1;}
			if (obj.name=="txt1up" || obj.name=="txt1upmoney")		{mylen=document.all.txt1upmoney.length-1;}
			if (obj.name=="txt1down" || obj.name=="txt1downmoney")	{mylen=document.all.txt1downmoney.length-1;}
			if (obj.name=="txt2down" || obj.name=="txt2downmoney")	{mylen=document.all.txt2downmoney.length-1;}
			if (obj.name=="txt3down" || obj.name=="txt3downmoney")	{mylen=document.all.txt3downmoney.length-1;}


			//alert("  index ="+obj.value);
			//alert("name ="+obj.name+"  index ="+ind+" len "+mylen);

			if(mylen == ind) {
				if (obj.name=="txt2up") {document.all.txt2upmoney[ind].focus();}
				if (obj.name=="txt3up") {document.all.txt3upmoney[ind].focus();}
				if (obj.name=="txt3tod") {document.all.txt3todmoney[ind].focus();}
				if (obj.name=="txt2tod") {document.all.txt2todmoney[ind].focus();}
				if (obj.name=="txt1up") {document.all.txt1upmoney[ind].focus();}
				if (obj.name=="txt1down") {document.all.txt1downmoney[ind].focus();}
				if (obj.name=="txt2down") {document.all.txt2downmoney[ind].focus();}
				if (obj.name=="txt3down") {document.all.txt3downmoney[ind].focus();}

				if (obj.name=="txt2upmoney") {document.all.txt3up[0].focus();}
				if (obj.name=="txt3upmoney") {document.all.txt3tod[0].focus();}
				if (obj.name=="txt3todmoney") {document.all.txt2tod[0].focus();}
				if (obj.name=="txt2todmoney") {document.all.txt1up[0].focus();}
				if (obj.name=="txt1upmoney") {document.all.txt1down[0].focus();}
				if (obj.name=="txt1downmoney") {document.all.txt2down[0].focus();}
				if (obj.name=="txt2downmoney") {document.all.txt3down[0].focus();}
				if (obj.name=="txt3downmoney") {document.all.action.focus();}
				

			} else {
				if (obj.name=="txt2up") {document.all.txt2upmoney[ind].focus();}
				if (obj.name=="txt3up") {document.all.txt3upmoney[ind].focus();}
				if (obj.name=="txt3tod") {document.all.txt3todmoney[ind].focus();}
				if (obj.name=="txt2tod") {document.all.txt2todmoney[ind].focus();}
				if (obj.name=="txt1up") {document.all.txt1upmoney[ind].focus();}
				if (obj.name=="txt1down") {document.all.txt1downmoney[ind].focus();}
				if (obj.name=="txt2down") {document.all.txt2downmoney[ind].focus();}
				if (obj.name=="txt3down") {document.all.txt3downmoney[ind].focus();}

				if (obj.name=="txt2upmoney")	{document.all.txt2up[ind+1].focus();}
				if (obj.name=="txt3upmoney")	{document.all.txt3up[ind+1].focus();}
				if (obj.name=="txt3todmoney")	{document.all.txt3tod[ind+1].focus();}
				if (obj.name=="txt2todmoney")	{document.all.txt2tod[ind+1].focus();}
				if (obj.name=="txt1upmoney")	{document.all.txt1up[ind+1].focus();}
				if (obj.name=="txt1downmoney")	{document.all.txt1down[ind+1].focus();}
				if (obj.name=="txt2downmoney")	{document.all.txt2down[ind+1].focus();}
				if (obj.name=="txt3downmoney")	{document.all.txt3down[ind+1].focus();}

			}
		}
	}

	function calSumCutAll() {
	var i, sumVal;
		sumVal = 0;
		for (i=0;i <= document.form2.txt2upmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt2upmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt2upmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt3upmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt3upmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt3upmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt3todmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt3todmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt3todmoney[i].value);
			}
		}		
		for (i=0;i <= document.form2.txt2todmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt2todmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt2todmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt1upmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt1upmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt1upmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt1downmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt1downmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt1downmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt2downmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt2downmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt2downmoney[i].value);
			}
		}
		for (i=0;i <= document.form2.txt3downmoney.length-1; i++ ) {
			if (!isNaN(parseInt(document.form2.txt3downmoney[i].value))) {
				sumVal = sumVal + parseInt(document.form2.txt3downmoney[i].value);
			}
		}
		//document.all.sumsend.innerText=format-number(sumVal,"###,###.##");
		document.all.sumsend.innerText=sumVal;
//		alert("arr value "+sumVal);
	}	
<% end if %>
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
		document.form2.target="";
		document.form2.action="dealer_tudroum_act.asp";
		document.form2.submit();
	}
}

</script>
<script language="vbscript">
	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>
    <style type="text/css">
        .auto-style1 {
            color: #FFFFFF;
        }
        .auto-style2 {
            height: 20px;
        }
    </style>


<%
dim sumall
dim typenum1, typenum2, typenum3, typenum4, typenum5, typenum6, typenum7, typenum8
dim strOpen
dim strOrder
	strOpen="เปิดรับแทง"
	strOrder="เรียงเลข"
	if CheckGame(Session("uid"))="OPEN" then strOpen="ปิดรับแทง"

	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	if Request("act") <> "out" then
'เฉพาะเลขรับไว้	
strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
	& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
	& "WHERE (tb_ticket.game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status in (2,3)) AND (tb_ticket_number.sum_flag = 'Y') And (tb_ticket.ticket_status='A')  " _
	& "GROUP BY tb_ticket_number.play_type"

'showstr strSql
	objRec.Open strSql, conn
	if not objRec.eof then
		do while not objRec.eof
			'if objRec("play_type")=1 then
			select case cint(objRec("play_type"))
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
	'จำนวนเงินจากเจ้ามือคนอื่นที่ส่งมาให้เรา
	strSql = "SELECT tb_ticket_number.play_type, SUM(tb_ticket_number.dealer_rec) AS sum_amt " _
		& "FROM tb_ticket_number INNER JOIN tb_ticket_key ON tb_ticket_number.ticket_key_id = tb_ticket_key.ticket_key_id INNER JOIN tb_ticket ON tb_ticket_key.ticket_id = tb_ticket.ticket_id INNER JOIN sc_user ON tb_ticket.player_id = sc_user.user_id " _
		& "WHERE (tb_ticket.ref_game_id = " & Session("gameid") & ") AND (tb_ticket_number.number_status <> 4) AND (tb_ticket_number.sum_flag = 'Y') And (tb_ticket.ticket_status='A')  " _
		& "GROUP BY tb_ticket_number.play_type"

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

%>
	<TABLE width='95%' align=center class=table_red bgColor="#FFFFFF">         	
<%
	if Request("act") <> "out" Then
	
%>
		<tr align=center bgColor=#282828  class=head_white>
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
			<td bgColor=green><font color="yellow">2 บน</font></td>
			<td bgColor=red><font color="white">3 บน</font></td>
			<td bgColor=green><font color="yellow">3 โต๊ด</font></td>
			<td bgColor=red><font color="white">2 โต๊ด</font></td>
			<td bgColor=green><font color="yellow">วิ่งบน</font></td>
			<td bgColor=red><font color="white">วิ่งล่าง</font></td>
			<td bgColor=green><font color="yellow">2 ล่าง</font></td>
			<td bgColor=red><font color="white">3 ล่าง</font></td>
		</tr>
		<tr>
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					dim pAmt
					dim tmpClass
					dim arrCut
					dim cutInd
					
					redim arrCut(1,1)
					set objRec = nothing
					set recNum = nothing
					Set objRec = Server.CreateObject ("ADODB.Recordset")
					Set recNum = Server.CreateObject ("ADODB.Recordset")

					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Up & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 บน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Up & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 3 บน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Tod & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 3 โต๊ด -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Tod & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 โต๊ด -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งบน -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunUp & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
%>
				</table>
			</td><!-- จบเลขวิ่งบน -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข วิ่งล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunDown & ",'rec', 'money', 'yes' "
'showstr strSql
					set objRec = conn.Execute(strSql)

					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลขวิ่งล่าง -->				
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 2 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Down & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
				%>
				</table>
			</td><!-- จบเลข 2 ล่าง -->
			<td valign=top bgColor="<%=tmpColColor%>"><!-- เลข 3 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
				<%
					strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Down & ",'rec', 'money', 'yes' "
					set objRec = conn.Execute(strSql)
					do while not objRec.eof
						pAmt=0
						pAmt = objRec("total_money")
						tmpClass="text_black"
						response.write "<tr class="&tmpClass&"><td>"&objRec("play_number")&"="&pAmt&"</td></tr>"
						objRec.movenext
					loop
					objRec.close
	
				%>
				</table>
			</td><!-- จบเลข 3 ล่าง -->
		</tr>
		<tr>
			<td colspan=8 height=20><hr width="95%"></td>
		</tr>

		<FORM METHOD=POST ACTION="dealer_tudroum.asp" name="form1">
		<INPUT TYPE="hidden" name="act" value="tud">
		<INPUT TYPE="hidden" name="tudauto" value="">
<!-- 		<tr bgColor=#66CCFF>
			<td colspan=8 height=30 class=textbig_red align=center><INPUT TYPE="submit" name=submit value="                  ตั     ด     เ     ก็     บ                " class=inputB></td>
		</tr> -->
		<%
			'if tud1 = "0" then tud1 = ""
			'if tud2 = "0" then tud2 = ""
			'if tud3 = "0" then tud3 = ""
			'if tud4 = "0" then tud4 = ""
			'if tud5 = "0" then tud5 = ""
			'if tud6 = "0" then tud6 = ""
			'if tud7 = "0" then tud7 = ""
			'if tud8 = "0" then tud8 = ""
Dim strCmbSelect
	strCmbSelect = ""

		%>
		<tr>
			<td align="center" style="" colspan="8" class="text_black">
				เลือกประเภทการตัด %&nbsp;
				<SELECT NAME="cmbcutperctype">
					<%
					strCmbSelect = ""
					If cutperctype="T" Then strCmbSelect = "selected"
					%>
					<OPTION VALUE="T" <%=strCmbSelect%>>ตัด % ส่วนบน</option>
					<%
					strCmbSelect = ""
					If cutperctype="A" Then strCmbSelect = "selected"
					%>
					<OPTION VALUE="A" <%=strCmbSelect%>>ตัดเฉลี่ย % ของทั้งหมด</option>
					<%
					strCmbSelect = ""
					If cutperctype="B" Then strCmbSelect = "selected"
					%>
					<OPTION VALUE="B" <%=strCmbSelect%>>ตัด % ส่วนล่าง</option>
				</SELECT>&nbsp;&nbsp;จำนวน % ที่ต้องการตัด&nbsp;&nbsp;
				<input type="text" name="txtperccut" id="txtperccut" size="10" value="<%=cutperc%>">%&nbsp;&nbsp;
				<INPUT TYPE="button" class="inputE" value="ตัด %"  style="cursor:hand; width: 70px;" ONCLICK="click_tudpercent();" >&nbsp;(*** ตัดอัตโนมัตตัดจากเลขรับทั้งหมด แต่จำนวนที่เห็นปัจจุบันเป็นเลขรับไว้)
			</td>
		</tr>
		<tr>
			<td colspan=8 height=20><hr width="95%"></td>
		</tr>
		<tr>
			<td bgcolor=green>	<INPUT TYPE="text" NAME="txttud1" id="txttud1" size=15 value="<%=tud1%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=red>	<INPUT TYPE="text" NAME="txttud2" id="txttud2" size=15 value="<%=tud2%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=green>	<INPUT TYPE="text" NAME="txttud3" id="txttud3" size=15 value="<%=tud3%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=red>	<INPUT TYPE="text" NAME="txttud4" id="txttud4" size=15 value="<%=tud4%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=green>	<INPUT TYPE="text" NAME="txttud5" id="txttud5" size=15 value="<%=tud5%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=red>	<INPUT TYPE="text" NAME="txttud6" id="txttud6" size=15 value="<%=tud6%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=green>	<INPUT TYPE="text" NAME="txttud7" id="txttud7" size=15 value="<%=tud7%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
			<td bgcolor=red>	<INPUT TYPE="text" NAME="txttud8" id="txttud8" size=15 value="<%=tud8%>" onKeyPress="txttud_keypress(this);" onBlur="txttud_blur(this);"></td>
		</tr>
		</FORM>

<%
	end if  ' request act <> out
	if Request("act")="tud" or Request("act")="out" Then
	
	dim myInd
%>
		<tr>
			<td colspan=8 class="auto-style2"><hr width="95%"></td>
		</tr>
		<tr class=textbig_red>
			<td colspan=8 height=20 align=center><h4> จาก<u>&nbsp;&nbsp;&nbsp;<%=Session("uname")%>&nbsp;&nbsp;&nbsp;</u>ยอดส่ง&nbsp;&nbsp;&nbsp;<span id="sumsend"></span> </h4></td>
		</tr>
		<tr class=textbig_red>
			<td colspan=8 height=20 align=center>&nbsp;</td>
		</tr>
		<tr align=center class=head_red bgcolor=red>
			<td class="auto-style1">2 บน</td>
			<td class="auto-style1">3 บน</td>
			<td class="auto-style1">3 โต๊ด</td>
			<td class="auto-style1">2 โต๊ด</td>
			<td class="auto-style1">วิ่งบน</td>
			<td class="auto-style1">วิ่งล่าง</td>
			<td class="auto-style1">2 ล่าง</td>
			<td class="auto-style1">3 ล่าง</td>
		</tr>
		<FORM METHOD=POST name="form2" Action="dealer_tudroum_send.asp" Target=""> <!--  ACTION="dealer_tudroum_act.asp"  -->
		<INPUT TYPE="hidden" name="tud1" value="<%=tud1%>">
		<INPUT TYPE="hidden" name="tud2" value="<%=tud2%>">
		<INPUT TYPE="hidden" name="tud3" value="<%=tud3%>">
		<INPUT TYPE="hidden" name="tud4" value="<%=tud4%>">
		<INPUT TYPE="hidden" name="tud5" value="<%=tud5%>">
		<INPUT TYPE="hidden" name="tud6" value="<%=tud6%>">
		<INPUT TYPE="hidden" name="tud7" value="<%=tud7%>">
		<INPUT TYPE="hidden" name="tud8" value="<%=tud8%>">
		<%
			'if tud1 = "" then tud1 = "0"
			'if tud2 = "" then tud2 = "0"
			'if tud3 = "" then tud3 = "0"
			'if tud4 = "" then tud4 = "0"
			'if tud5 = "" then tud5 = "0"
			'if tud6 = "" then tud6 = "0"
			'if tud7 = "" then tud7 = "0"
			'if tud8 = "" then tud8 = "0"
		%>

		<tr bgcolor=#ffd8cc>
			<td valign=top><!-- เลข 2 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType2Up & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2up' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt2upmoney' value="&pAmt-tud1&" size=7 onKeyPress='CheckKeyCode(this,"&myInd&");'  onBlur='txttud_blur(this);'></td></tr>"
									response.write "<input type=hidden name='2upcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							Loop
							objRec.close						
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Up & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								if clng(pAmt) > clng(tud1) and tud1 <> ""  then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2up' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt2upmoney' value="&pAmt-tud1&" size=7 onKeyPress='CheckKeyCode(this,"&myInd&");'  onBlur='txttud_blur(this);'></td></tr>"
									response.write "<input type=hidden name='2upcuttype' value='1'>"
									myInd=myInd+1
								end if						
								objRec.movenext
							Loop
							objRec.close
						end if
					End If 
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2up' style='width: 30px;' maxlength='2' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt2upmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"
						response.write "<input type=hidden name='2upcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 2 บน -->
			<td valign=top><!-- เลข 3 บน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType3Up & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3up' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3upmoney' value="&pAmt-tud2&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3upcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Up & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								if clng(pAmt) > clng(tud2) and tud2 <> "" then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3up' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3upmoney' value="&pAmt-tud2&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3upcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 										
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3up' style='width: 40px;' maxlength='3' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3upmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"	
						response.write "<input type=hidden name='3upcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 3 บน -->
			<td valign=top><!-- เลข 3 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType3Tod & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3tod' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3todmoney' value="&pAmt-tud3&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3todcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Tod & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								if clng(pAmt) > clng(tud3) and tud3 <> "" then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3tod' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3todmoney' value="&pAmt-tud3&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3todcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 															
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3tod' style='width: 40px;' maxlength='3' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' name='txt3todmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"	
						response.write "<input type=hidden name='3todcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 3 โต๊ด -->
			<td valign=top><!-- เลข 2 โต๊ด -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" then					
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType2Tod & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2tod' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2todmoney' value="&pAmt-tud4&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='2todcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Tod & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								if clng(pAmt) > clng(tud4) and tud4 <> ""  then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2tod' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2todmoney' value="&pAmt-tud4&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='2todcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 															
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2tod' style='width: 30px;' maxlength='2' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2todmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
						response.write "<input type=hidden name='2todcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 2 โต๊ด -->
			<td valign=top><!-- เลข วิ่งบน -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        		
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayTypeRunUp & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1up' style='width: 20px;' maxlength='1' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1upmoney' value="&pAmt-tud5&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='1upcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunUp & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								if clng(pAmt) > clng(tud5) and tud5 <> ""  then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1up' style='width: 20px;' maxlength='1' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1upmoney' value="&pAmt-tud5&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='1upcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 																				
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1up' style='width: 20px;' maxlength='1' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1upmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
						response.write "<input type=hidden name='1upcuttype' value='2'>"
						myInd=myInd+1
					next 
%>
				</table>
			</td><!-- จบเลขวิ่งบน -->
			<td valign=top><!-- เลข วิ่งล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayTypeRunDown & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
'								for cutInd = 1 to Ubound(arrCut,2)  
'									if objRec("play_number")=arrCut(1,cutInd) then
'										pAmt = pAmt - clng(arrCut(2,cutInd))
'										exit for
'									end if
'								next
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1down' style='width: 20px;' maxlength='1' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1downmoney' value="&pAmt-tud6&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='1downcuttype' value='1'>"
									myInd=myInd+1
								End If 
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayTypeRunDown & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								for cutInd = 1 to Ubound(arrCut,2)  
									if objRec("play_number")=arrCut(1,cutInd) then
										pAmt = pAmt - clng(arrCut(2,cutInd))
										exit for
									end if
								next
								tmpClass="text_black"
								if clng(pAmt) > clng(tud6) and tud6 <> ""  then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1down' style='width: 20px;' maxlength='1' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1downmoney' value="&pAmt-tud6&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='1downcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 																				
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt1down' style='width: 20px;' maxlength='1' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt1downmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
						response.write "<input type=hidden name='1downcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลขวิ่งล่าง -->				
			<td valign=top><!-- เลข 2 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType2Down & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2down' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2downmoney' value="&pAmt-tud7&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='2downcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType2Down & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								for cutInd = 1 to Ubound(arrCut,2)  
									if objRec("play_number")=arrCut(1,cutInd) then
										pAmt = pAmt - clng(arrCut(2,cutInd))
										exit for
									end if
								next
								tmpClass="text_black"
								if clng(pAmt) > clng(tud7) and tud7 <> ""  then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2down' style='width: 30px;' maxlength='2' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2downmoney' value="&pAmt-tud7&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='2downcuttype' value='1'>"
									myInd=myInd+1
								end if
								objRec.movenext
							loop
							objRec.close
						End If 																				
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt2down' style='width: 30px;' maxlength='2' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt2downmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"
						response.write "<input type=hidden name='2downcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 2 ล่าง -->
			<td valign=top><!-- เลข 3 ล่าง -->
				<TABLE cellSpacing=0 cellPadding=0 width='100%' border=0 align=center>        	
				<%
					myInd=0
					if Request("act") <> "out" Then
						If cutperctype = "T" Or cutperctype = "A" Or cutperctype = "B" Then   '** ตัด auto
							strSql = "exec spA_GetCutNumberCutAuto " & Session("gameid") & "," & mlnPlayType3Down & ",'" & cutperctype & "', " &  cutperc
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								tmpClass="text_black"
								If CInt(pAmt) > 0 Then 
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3down' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt3downmoney' value="&pAmt-tud8&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3downcuttype' value='1'>"
									myInd=myInd+1
								end if	
								objRec.movenext
							loop
							objRec.close
						Else  '** ตัด ปกติ
							strSql = "exec spGetPlayNumber " & Session("gameid") & "," & mlnPlayType3Down & ",'rec', 'money', 'no' "
							set objRec = conn.Execute(strSql)
							myInd=0
							do while not objRec.eof
								pAmt=0
								pAmt = objRec("total_money")
								for cutInd = 1 to Ubound(arrCut,2)  
									if objRec("play_number")=arrCut(1,cutInd) then
										pAmt = pAmt - clng(arrCut(2,cutInd))
										exit for
									end if
								next
								tmpClass="text_black"
								if clng(pAmt) > clng(tud8) and tud8 <> "" then
									response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3down' style='width: 40px;' maxlength='3' value="&objRec("play_number")&" size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt3downmoney' value="&pAmt-tud8&" size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"							
									response.write "<input type=hidden name='3downcuttype' value='1'>"
									myInd=myInd+1
								end if	
								objRec.movenext
							loop
							objRec.close
						End If 																				
					end if
					for i = 1 to 5
						response.write "<tr class="&tmpClass&"><td><INPUT TYPE='text' NAME='txt3down' style='width: 40px;' maxlength='3' value='' size=2 onBlur='txttud_blur(this);' onKeyPress=CheckKeyCode(this,"&myInd&")>=<input type='text' NAME='txt3downmoney' value='' size=7 onKeyPress=CheckKeyCode(this,"&myInd&") onBlur='txttud_blur(this);'></td></tr>"
						response.write "<input type=hidden name='3downcuttype' value='2'>"
						myInd=myInd+1
					next 
				%>
				</table>
			</td><!-- จบเลข 3 ล่าง -->
		</tr>	
		<tr>		
			<td colspan=8 class=textbig_blue align=center>&nbsp;</td>
		</tr>
		<tr>		
			<input type=hidden name="sendfrom">
			<input type=hidden name="sendto">
			<input type=hidden name="sendtype">
			<input type=hidden name="sendweb">			
			<input type=hidden name="sendweb2">			
			<td colspan=8 class=textbig_blue align=center><INPUT TYPE="button" name="bttSend" value="ส่งเจ้ามืออื่น" class="inputE" style="cursor:hand; width: 90px;" onClick=showsendto()>&nbsp;&nbsp;<INPUT TYPE="button" name="bttPrint" value="พิมพ์ออก" class="inputR" style="cursor:hand; width: 100px;" onClick=gosendtype("2",<%=Session("uid")%>)></td>
		</tr>
		</FORM>
<%
	end if
%>
	</table>	

<%
if Request("act")="tud" then	 
%>	
<script language="JavaScript">
	calSumCutAll();
</script>
<%
end if
%>

<%
	set objRec = nothing
	set conn   = nothing	
%>	
<% End sub %>