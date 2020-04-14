<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>
<%
		Dim i , j
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim mode
		Dim objRS , objDB , SQL	, tmp_Color
		Dim dealer_id
		dealer_id=Request("dealer_id")
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		


		mode=Request("mode")			

		If mode="clear" Then
			SQL="update sc_user	 set "
			SQL=SQL & " active_LimitMoney=0,"
			SQL=SQL & " up2=0, "
			SQL=SQL & " up3=0, "
			SQL=SQL & " tod3=0, "
			SQL=SQL & " down2=0 "
			SQL=SQL & " where user_id=" & dealer_id
			objDB.Execute(SQL)
			SQL="delete from tb_limit_number where dealer_id=" & dealer_id
			objDB.Execute(SQL)
		End if
		If mode="save" Then
			SQL="update sc_user set "
			SQL=SQL & " limit_number_for=" & Request("limit_number_for") & ","
			SQL=SQL & " active_LimitMoney=" & Request("used") & ","
			SQL=SQL & " up2=" & Request("up2") & ", "
			SQL=SQL & " up3=" & Request("up3") & ", "
			SQL=SQL & " tod3=" & Request("tod3") & ", "
			SQL=SQL & " down2=" & Request("down2") 
			SQL=SQL & " where user_id=" & dealer_id
			objDB.Execute(SQL)		
			i=1
            j=1
			Dim d2up, d3up, d3tod, d2dw
			Dim seq1,seq2,seq3,seq4
    		Dim t2up, t3up, t3tod, t2dw
            Dim tv2up, tv3up, tv3tod, tv2dw
			Dim tseq1,tseq2,tseq3,tseq4
			seq1=1
			seq2=1
			seq3=1
			seq4=1
            tseq1=1
			tseq2=1
			tseq3=1
			tseq4=1
			SQL="delete from tb_limit_number where dealer_id=" & dealer_id
			objDB.Execute(SQL)	
			While i<=15
				d2up=Request("d2up_" & i)
				d3up=Request("d3up_" & i)
				d3tod=Request("d3tod_" & i)
				d2dw=Request("d2dw_" & i)
				If d2up<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, seq, flag) values (" & dealer_id & ",'" & d2up & "',1," & seq1 & ",0)" 
					objDB.Execute(SQL)		
					seq1=seq1+1
				End If
				If d3up<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, seq, flag) values (" & dealer_id & ",'" & d3up & "',2," & seq2 & ",0)"  
					objDB.Execute(SQL)		
					seq2=seq2+1
				End If
				If d3tod<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, seq, flag) values (" & dealer_id & ",'" & d3tod & "',3," & seq3 &",0)"  
					objDB.Execute(SQL)		
					seq3=seq3+1
				End If
				If d2dw<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, seq, flag) values (" & dealer_id & ",'" & d2dw & "',7," & seq4 & ",0)"  
					objDB.Execute(SQL)		
					seq4=seq4+1
				End if
				i=i+1
			Wend 

            While j<=15
				t2up=Request("t2up_" & j)
				t3up=Request("t3up_" & j)
				t3tod=Request("t3tod_" & j)
				t2dw=Request("t2dw_" & j)
                tv2up=Request("tv2up_" & j)
				tv3up=Request("tv3up_" & j)
				tv3tod=Request("tv3tod_" & j)
				tv2dw=Request("tv2dw_" & j)
				If t2up<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, check_play_amt, seq, flag) values (" & dealer_id & ",'" & t2up & "',1," & tv2up & "," & tseq1 & ",1)" 
					objDB.Execute(SQL)		
					tseq1=tseq1+1
				End If
				If t3up<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, check_play_amt, seq, flag) values (" & dealer_id & ",'" & t3up & "',2," & tv3up & "," & tseq2 & ",1)"  
					objDB.Execute(SQL)		
					tseq2=tseq2+1
				End If
				If t3tod<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, check_play_amt, seq, flag) values (" & dealer_id & ",'" & t3tod & "',3," & tv3tod & "," & tseq3 &",1)"  
					objDB.Execute(SQL)		
					tseq3=tseq3+1
				End If
				If t2dw<>"" then
					SQL="insert into tb_limit_number (dealer_id, limit_number, play_type, check_play_amt, seq, flag) values (" & dealer_id & ",'" & t2dw & "',7," & tv2dw & "," & tseq4 & ",1)"  
					objDB.Execute(SQL)		
					tseq4=tseq4+1
				End if
				j=j+1
			Wend 

		End if
		SQL="select * from sc_user where user_id=" & dealer_id
		Set objRS=objDB.Execute(SQL)
		Dim up2,up3, tod3, down2,active_LimitMoney,used,noused
		up2=0
		up3=0
		tod3=0
		down2=0
		active_LimitMoney=""
		used=""
		noused=""
dim limit_number_for1,limit_number_for2
		If Not objRS.eof Then
			up2=objRS("up2")
			up3=objRS("up3")
			tod3=objRS("tod3")
			down2=objRS("down2")
if objRS("limit_number_for")="1" then
	limit_number_for1="checked"
end if
if objRS("limit_number_for")="2" then
	limit_number_for2="checked"
end if
			If objRS("active_LimitMoney")="1" then
				used="checked"
			Else 
				noused="checked"
			End if
		End If
'response.end		
%>

	<form name="form1" action="frmLimitMoney.asp?dealer_id=<%=dealer_id%>" method="post">
	<input type="hidden" name="mode" value="save">
	<center><br><font color=red size=+1><b>แจ้งเลขเต็มอัตโนมัติ      </b></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<font class="head_black"><input type="radio" name="used" value="1" <%=used%>>&nbsp;&nbsp; ใช้
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="radio" name="used" value="0" <%=noused%>>&nbsp;&nbsp; ไม่ใช้
	&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;		
	<input type="radio" name="limit_number_for" value="1" <%=limit_number_for1%>>&nbsp;&nbsp; ใช้ทั้งหมด
	&nbsp;&nbsp;&nbsp;&nbsp;	
	<input type="radio" name="limit_number_for" value="2" <%=limit_number_for2%>>&nbsp;&nbsp; ใช้กับคนแทง
	</font>
	<br>
	<hr style="height:1;" color=red><br>
	<table width="100%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">
		<tr>
			<td colspan="8" align="right">
				<input type="button" class="inputR" name="clear_data" value="ล้างเลข" style="cursor:hand;width:100;" onClick="click_clear();">
				<input type="button" class="inputG" name="save_data" value="บันทึก" style="cursor:hand;width:100;" onClick="click_save();">
				<%
				Dim back_page
				If Session("utype")="K" then
					back_page="key_dealer_play.asp"
				Else
					back_page="firstpage_dealer.asp"
				End If 
				%>
				<input type="button" class="inputE" name="exit_menu" value="ออก" style="cursor:hand;width:100;"
				onClick="gotoPage('<%=back_page%>'); ">
			</td>
		</tr>
        <tr>
			<td colspan="4" align="center"><font color=red size=+1><b>จำกัดยอดเงินแต่ละตัวไม่ให้เกิน</b></font></td>
		</tr>
		<tr class=head_white align=center>
			<td bgColor="#4f4f4f" class="auto-style1">
			2 บน
			</td>
			<td bgColor="#6600cc" class="auto-style1">
			3 บน
			</td>
			<td bgColor="#4f4f4f" class="auto-style1">
			3 โต๊ด
			</td>			
			<td bgColor="#6600cc" class="auto-style1">
			2 ล่าง
			</td>
		</tr>
		<tr height="40">
			<td align="center">
			<input type="text" name="up2" size="8" maxlength="6" value="<%=up2%>" onKeyDown="chkEnter(document.form1.up2,document.form1.up3);">
			</td>
			<td align="center">
			<input type="text" name="up3" size="8" maxlength="6" value="<%=up3%>" onKeyDown="chkEnter(document.form1.up3,document.form1.tod3);">
			</td>
			<td align="center">
			<input type="text" name="tod3" size="8" maxlength="6" value="<%=tod3%>" onKeyDown="chkEnter(document.form1.tod3,document.form1.down2);">
			</td>		
			<td align="center">
			<input type="text" name="down2" size="8" maxlength="6" value="<%=down2%>">
			</td>
		</tr>
		
	</table><br>
	<table width="100%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">
		<tr>
			<td colspan="4" align="center"><font color=red size=+1><b>แจ้งเลขเต็มใส่เลข(บล็อคไม่ให้คีย์)</b></font></td>
		</tr>
		<tr class=head_white align=center>
			<td bgColor="#4f4f4f">
			2 บน
			</td>
			<td bgColor="#6600cc">
			3 บน
			</td>
			<td bgColor="#4f4f4f">
			3 โต๊ด
			</td>			
			<td bgColor="#6600cc">
			2 ล่าง
			</td>
		</tr>
		<%
		i=1

		Dim shw_num1,shw_num2,shw_num3,shw_num4
		While i<=15
			shw_num1=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=1 and flag=0 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				shw_num1=objRS("limit_number")
			End If 
			shw_num2=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=2 and flag=0 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				shw_num2=objRS("limit_number")
			End If 
			shw_num3=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=3 and flag=0 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				shw_num3=objRS("limit_number")
			End If 
			shw_num4=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=7 and flag=0 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				shw_num4=objRS("limit_number")
			End If 
		%>
		<tr>
			<td align="center">
				<input type="text" size="5" maxlength="2" name="d2up_<%=i%>" onKeyDown="nextFocus(this,'<%="d2up"%>',<%=i%>,2);" value="<%=shw_num1%>"> 
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="3" name="d3up_<%=i%>"  onKeyDown="nextFocus(this,'<%="d3up"%>',<%=i%>,3);" value="<%=shw_num2%>">
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="3" name="d3tod_<%=i%>"  onKeyDown="nextFocus(this,'<%="d3tod"%>',<%=i%>,3);" value="<%=shw_num3%>" onBlur="tod3order(this);">
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="2" name="d2dw_<%=i%>"  onKeyDown="nextFocus(this,'<%="d2dw"%>',<%=i%>,2);" value="<%=shw_num4%>">
			</td>
		</tr>
		<%
			i=i+1
		wend
		%>
		<tr height="45">
			<td colspan="8" align="right">
				<input type="button" class="inputR" name="clear_data" value="ล้างเลข" style="cursor:hand;width:100;" onClick="click_clear();">
				<input type="button" class="inputG" name="save_data" value="บันทึก" style="cursor:hand;width:100;"
				onClick="click_save();">
				<input type="button" class="inputE" name="exit_menu" value="ออก" style="cursor:hand;width:100;"
				onClick="gotoPage('firstpage_dealer.asp'); ">
			</td>
		</tr>
	</table>
    <br>
	<table width="100%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">
		<tr>
			<td colspan="4" align="center"><font color=red size=+1><b>แจ้งเลขเต็มใส่เลขและยอดเงิน(จำกัดยอดจากโพยทั้งหมด)</b></font></td>
		</tr>
		<tr class=head_white align=center>
			<td bgColor="#4f4f4f">
			2 บน
			</td>
			<td bgColor="#6600cc">
			3 บน
			</td>
			<td bgColor="#4f4f4f">
			3 โต๊ด
			</td>			
			<td bgColor="#6600cc">
			2 ล่าง
			</td>
		</tr>
		<%
		i=1

		Dim tshw_num1,tshw_num2,tshw_num3,tshw_num4
        Dim tshw_val1,tshw_val2,tshw_val3,tshw_val4
		While i<=15
			tshw_num1=""
            tshw_val1=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=1 and flag=1 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				tshw_num1=objRS("limit_number")
                tshw_val1=objRS("check_play_amt")
			End If 
			tshw_num2=""
            tshw_val2=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=2 and flag=1 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				tshw_num2=objRS("limit_number")
                tshw_val2=objRS("check_play_amt")
			End If 
			tshw_num3=""
            tshw_val3=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=3 and flag=1 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				tshw_num3=objRS("limit_number")
                tshw_val3=objRS("check_play_amt")
			End If 
			tshw_num4=""
            tshw_val4=""
			SQL="select * from tb_limit_number where dealer_id=" & dealer_id & " and play_type=7 and flag=1 and seq=" & i
			Set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				tshw_num4=objRS("limit_number")
                tshw_val4=objRS("check_play_amt")
			End If 
		%>
		<tr>
			<td align="center">
				<input type="text" size="5" maxlength="2" name="t2up_<%=i%>" onKeyDown="nextFocus(this,'<%="tv2up"%>',<%=i%>,2);" value="<%=tshw_num1%>">
                <input type="text" size="8" maxlength="6" name="tv2up_<%=i%>" value="<%=tshw_val1%>"> 
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="3" name="t3up_<%=i%>"  onKeyDown="nextFocus(this,'<%="tv3up"%>',<%=i%>,3);" value="<%=tshw_num2%>">
                <input type="text" size="8" maxlength="6" name="tv3up_<%=i%>" value="<%=tshw_val2%>">
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="3" name="t3tod_<%=i%>"  onKeyDown="nextFocus(this,'<%="tv3tod"%>',<%=i%>,3);" value="<%=tshw_num3%>">
                <input type="text" size="8" maxlength="6" name="tv3tod_<%=i%>" value="<%=tshw_val3%>">
			</td>
			<td align="center">
				<input type="text" size="5" maxlength="2" name="t2dw_<%=i%>"  onKeyDown="nextFocus(this,'<%="tv2dw"%>',<%=i%>,2);" value="<%=tshw_num4%>">
                <input type="text" size="8" maxlength="6" name="tv2dw_<%=i%>" value="<%=tshw_val4%>">
			</td>
		</tr>
		<%
			i=i+1
		wend
		%>
		<tr height="45">
			<td colspan="8" align="right">
				<input type="button" class="inputR" name="clear_data" value="ล้างเลข" style="cursor:hand;width:100;" onClick="click_clear();">
				<input type="button" class="inputG" name="save_data" value="บันทึก" style="cursor:hand;width:100;"
				onClick="click_save();">
				<input type="button" class="inputE" name="exit_menu" value="ออก" style="cursor:hand;width:100;"
				onClick="gotoPage('firstpage_dealer.asp'); ">
			</td>
		</tr>
	</table>
	</center>
	</form>

			
<script language="javascript">
	function tod3order(obj){
	// เรียงเลขใหม่ 
		var n1,n2,n3, x1,x2,x3,x4,x5,x6, xMin
		n1=obj.value.substring(0,1)
		n2=obj.value.substring(1,2)
		n3=obj.value.substring(2,3)
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
		obj.value=xMin;	
	}
	function click_clear(){
		if(confirm('คุณต้องการล้างเลข ? ')){
			document.form1.mode.value="clear";
			document.form1.submit();
		}
	}
	function chkEnter(meobj,nextobj){
		var k=event.keyCode
		if (k == 13){			
			if( isNaN(meobj.value)){
				alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
				return false
			}		
			nextobj.focus();
		}
	}
	function click_save(){
		if(document.form1.up2.value==""){document.form1.up2.value=0;}
		if( isNaN(document.form1.up2.value)){
			alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
			document.form1.up2.focus();
			return false
		}
		if(document.form1.up3.value==""){document.form1.up3.value=0;}
		if( isNaN(document.form1.up3.value)){
			alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
			document.form1.up3.focus();
			return false
		}
		if(document.form1.tod3.value==""){document.form1.tod3.value=0;}
		if( isNaN(document.form1.tod3.value)){
			alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
			document.form1.tod3.focus();
			return false
		}
		if(document.form1.down2.value==''){document.form1.down2.value=0;}
		if( isNaN(document.form1.down2.value)){
			alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
			document.form1.down2.focus();
			return false
		}
		document.form1.submit();
	}
	function nextFocus(obj,d_type,i,lens){
		var k=event.keyCode
		if (k == 13){	
			if(obj.value!=''){
				if( isNaN(obj.value)){
					alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลขเท่านั้น !!!')
					obj.focus();
					return false
				}
				if(obj.value.length!=lens){
					alert('ผิดพลาด : กรุณากรอกจำนวนเป็นตัวเลข '+lens+' หลัก เท่านั้น !!!')
					obj.focus();
					return false
				}
			}
			if(i<30){
				i=parseFloat(i)+1;			
				nd_type=d_type;
			}else{
				i=1
				if(d_type==="d2up"){nd_type="d3up";}
				if(d_type==="d3up"){nd_type="d3tod";}
				if(d_type==="d3tod"){nd_type="d2dw";}
			}
			id=nd_type + '_'+i;  
			next_obj = document.getElementById(  id )
			next_obj.focus();
		}
	}
</script>

<% End Sub  %>