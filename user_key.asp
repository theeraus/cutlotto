<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_user_id
		Dim user_name, user_password, sum_password, old_remain, login_id, address_1


		mode=Request("mode")
		edit_user_id=Request("edit_user_id")
		if edit_user_id="" then edit_user_id=0
	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		dealer_id=Session("uid")
		game_type=Request("game_type")
		
		Dim dealer_login
		dealer_login=Session("logid")

		Dim rec_ticket_dealer
		SQL="select * from sc_user where user_id=" & Session("uid")
		set objRS=objDB.Execute(SQL)
		If Not objRS.eof Then
			rec_ticket_dealer=objRS("rec_ticket_dealer")
		Else
			response.end
		End if


		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			user_name=Request("user_name")
			user_password=Request("user_password")
			login_id=Request("login_id")
			
			SQL="select isnull(cnt_login,0) cnt_login,isnull(cnt_dealer,0) cnt_dealer from sc_user where user_id=" & edit_user_id

			Dim cnt_login, cnt_dealer
			set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				cnt_login=objRS("cnt_login")
				cnt_dealer=objRS("cnt_dealer")
			End If
			SQL="select * from sc_user where user_type='K' and create_by=" & dealer_id & " and login_id='" & login_id & "' and user_id<>" & edit_user_id
			set objRS=objDB.Execute(SQL)
			If Not objRS.eof Then
				Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มี หมายเลข นี้แล้ว !! " & login_id & "</font></span></center>"
			else
				SQL="update sc_user set  "
				SQL=SQL & " login_id='" & login_id & "',"
				SQL=SQL & " [user_name]='" & user_name & "'"
				SQL=SQL & ",user_password='" & user_password & "'"
				SQL=SQL & " where [user_id]=" & edit_user_id 
				set objRS=objDB.Execute(SQL)
			End if
		end if
		if mode="delete" then ' กรณีที่ user click ลบรายการ
			SQL="delete sc_user where [user_id]=" & edit_user_id
			set objRS=objDB.Execute(SQL)
		end If
		
		
		if mode="add_save" then
			user_name=Request("user_name")
			user_password=Request("user_password")
			sum_password=Request("sum_password")
			old_remain=Replace(Request("old_remain"),",","")
			if old_remain="" then old_remain=0
			login_id=Trim(dealer_login) & "K" & Trim(Request("login_id"))
			address_1=Request("address_1")
			if not isnumeric(old_remain) then
				Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก ยอดค้างเก่าต้องเป็นตัวเลข !!!</font></span></center>"
			else	
				SQL="select * from sc_user where user_type='K' and create_by=" & dealer_id & " and user_name='" & user_name & "'"
				set objRS=objDB.Execute(SQL)
				if not objRS.eof then
						Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มีชื่อนี้แล้ว !! " & user_name & "</font></span></center>"
				else
						SQL="select * from sc_user where user_type='K' and create_by=" & dealer_id & " and login_id='" & login_id & "'"
						set objRS=objDB.Execute(SQL)
						if not objRS.eof then
								Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มี หมายเลข นี้แล้ว !! " & login_id & "</font></span></center>"
						else
							
							SQL="insert into sc_user ( "
							SQL=SQL & "	login_id, "
							SQL=SQL & "	 [user_name], "
							SQL=SQL & "	 user_password, " 
							SQL=SQL & "	 user_type, "
							SQL=SQL & "	 create_by, "
							SQL=SQL & "  create_date) values ("
							SQL=SQL & "'" & login_id & "', "
							SQL=SQL & "'" & user_name & "', "
							SQL=SQL & "'" & user_password & "', "
							SQL=SQL & " 'K', "
							SQL=SQL & "'" & dealer_id & "', "
							SQL=SQL & " getdate() )"

							set objRS=objDB.Execute(SQL)
						end if
				end if
			end if
		end if
%>

	<form name="form1" action="user_key.asp" method="post">
	<center><br>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%" >
				<tr>
					<td style="text-align: center;">
						<input type="button" class="inputG" value="เพิ่ม" style="cursor:hand; width: 75px;" onClick="click_add();">					
						<input type="button" class="inputP" value="พิมพ์" style="cursor:hand; width: 75px;" onClick="print_user();">
						<input type="button" class="inputE" value="ออก" style="cursor:hand; width: 75px;" onClick="gotoPage('firstpage_dealer.asp')">
					</td>
				</tr>
				<tr>
					<td align="center"> 
					<strong>
					ตั้งคนคีย์
					</strong>
					</td>
				</td>
			</table>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%"  >
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#282828"   >
							<%
							if rec_ticket_dealer=1 then
								tmp_Color="#33CC33"
							else
								tmp_Color="red"
							end If									
							%>
							
							<tr>
								<td class="textbig_white" align="right" colspan="2" bgcolor="#282828" >
								&nbsp;</td>
								<td class="textbig_white" align="center" colspan="1" bgcolor="#282828">
								หมายเลข</td>
								<td class="textbig_white" align="left" bgcolor="#282828">ชื่อ</td>
								<td class="textbig_white" align="center" bgcolor="#282828">Password</td>
							</tr>
							<%
							SQL="select  * from sc_user where user_type='K' and create_by=" & dealer_id & " order by login_id "
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							if mode="add_new" then
								tmp_Color="red"
							%>
								<tr>				
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;" onClick="click_add_save();" >
									</td>
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
									</td>			
									<td class="tdbody" bgcolor="<%=c %>" align="left" width="150">
									<span class="input1"><%=dealer_login%>K</span><input type="text" name="login_id"  
										class="input1" size="5" maxlength="5" onKeyDown="chkEnter(this);">
									</td>
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_name" 	
										class="input1"  size="15" maxlength="80" onKeyDown="chkEnter(this);">	
									</td>										
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_password" 
										class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">	
									</td>
								</tr>
							<%	
							end if
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							while not objRS.eof
							
								if mode="edit" and Cint(objRS("user_id"))=Cint(edit_user_id) then
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									if objRS("rec_ticket")=1 then
										tmp_Color="#33CC33"
									else
										tmp_Color="red"
									end if
									%>
									<tr>				
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;" onClick="click_edit_save('<%=objRs("user_id")%>');" >
										</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
										</td>	
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="login_id" value="<%=objRS("login_id")%>" 
											class="input1" size="8" maxlength="5" onKeyDown="chkEnter(this);">
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_name" 	value="<%=objRS("user_name")%>" 
											class="input1"  size="15" maxlength="80" onKeyDown="chkEnter(this);">	   
										</td>										
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_password" value="<%=objRS("user_password")%>"	
											class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">	
										</td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									if objRS("rec_ticket")="1" then
										tmp_Color="#33CC33"
									else
										tmp_Color="red"
									end if
									%>
									<tr>							
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputE" value="แก้ไข" style="cursor:hand; width: 75px;" onClick="click_edit('<%=objRs("user_id")%>');" >
										</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ลบ" style="cursor:hand; width: 75px;" onClick="click_del('<%=objRs("user_id")%>', '<%=objRs("user_name")%>');" >
										</td>	
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="60"><%=objRS("login_id")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="145"><%=objRS("user_name")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=objRS("user_password")%>	</td>										
									</tr>
									<!----------------------------------------------------------->
									<%
								end if
								objRS.MoveNext
							wend 
							%>
						</table>
					</td>
				</tr>
			</table>
	</center>
	<input type="hidden" name="mode">
	<input type="hidden" name="edit_user_id">
	</form>



<script language="javascript">
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
function click_edit(user_id){
	document.form1.mode.value="edit";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}
function click_del(user_id,user_name){
	if (confirm('คุณต้องการลบรายการ ' + user_name+' ?' )){
		document.form1.mode.value="delete";
		document.form1.edit_user_id.value=user_id;
		document.form1.submit();
	}
}
function click_cancel(){
	document.form1.mode.value="cancel";
	document.form1.edit_user_id.value=""
	document.form1.submit();
}
function click_edit_save(user_id){
	document.form1.mode.value="edit_save";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}
function click_status(user_id){
	document.form1.mode.value="edit_status";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}
function click_add(){
	document.form1.mode.value="add_new";
	document.form1.submit();
}
function lefty (instring, num){
	var outstr=instring.substring(instring, num);
	return (outstr);
}
function click_add_save(){
	if (document.form1.login_id.value==""){
		alert('ผิดพลาด : กรุณากรอก หมายเลข คนแทง')
		document.form1.login_id.focus();
		return
	}
	//if (lefty(document.form1.login_id.value,1)!="k" & //lefty(document.form1.login_id.value,1)!="K"){
	//	alert('ผิดพลาด : กรุณากรอก หมายเลข คนแทง นำหน้าด้วย k')
	//	document.form1.login_id.focus();
	//	return
	//}
	if (document.form1.user_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อ คนแทง')
		document.form1.user_name.focus();
		return
	}
	if (document.form1.user_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.user_password.focus();
		return
	}
	
	document.form1.mode.value="add_save";
	document.form1.submit();
}
//เช็ค กด enter
function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			if(obj.name=="login_id"){
				document.form1.user_name.focus();
			}
			if(obj.name=="user_name"){
				document.form1.user_password.focus();
			}
			if(obj.name=="user_password"){
				document.form1.sum_password.focus();
			}
			if(obj.name=="sum_password"){
				document.form1.old_remain.focus();
			}
			if(obj.name=="old_remain"){
				document.form1.btt_save.focus();
			}

		}
	}

	function print_user() {	window.open("dealer_print_oper.asp","_blank","top=150,left=150,height=600,width=800,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function click_rec_dealer(){
		document.form1.mode.value="edit_rec_dealer";
		document.form1.submit();
	}
</script>
<%
	if mode="add_new" Then
	%>
		<script language="javascript">
			document.form1.login_id.focus();
		</script>
	<%
	End if
%>

<% End Sub %>