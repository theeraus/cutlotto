<!--#include virtual="masterpage.asp"-->

<% Sub ContentPlaceHolder() %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objRS2, objDB , SQL	
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_web_id
		Dim dealer_name, web_addr, user_login, password

		mode=Request("mode")
		edit_web_id=Request("edit_web_id")
		if edit_web_id="" then edit_web_id=0
	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Set objRS2 =Server.CreateObject("ADODB.Recordset")		
		dealer_id=Session("uid")
		game_type=Request("game_type")



		if mode="edit" then ' กรณีที่ user click แก้ไขรายการ
			'response.write "edit" & edit_web_id
		end if
		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			dealer_name = Request("dealer_name")
			web_addr = Request("web_addr")
			'grp_login = Request("grp_login")
			user_login = Request("user_login")
			password = Request("password")

'***** เปลี่ยนจาก table tb_dealer_web  > sc_user
' web_id = user_id
'dealer_id = create_by
'dealer_name = user_name
'web_addr = address_1
'grp_login = nick_name
'user_login = login_id
'password = user_password


			Sql = "Update sc_user set user_name = '" & dealer_name & "', address_1 = '" & web_addr & "', login_id = '" & user_login & "', user_password = '" & password & "' where user_id = " & edit_web_id
			set objRS=objDB.Execute(SQL)
		end if
		if mode="delete" then ' กรณีที่ user click ลบรายการ
			SQL="delete sc_user where [user_id]=" & edit_web_id
			set objRS=objDB.Execute(SQL)
		end if
		if mode="add_save" then
			dealer_name = Request("dealer_name")
			web_addr = Request("web_addr")
			'grp_login = Request("grp_login")
			user_login = Request("user_login")
			password = Request("password")
			SQL="Insert into sc_user (create_by, user_name, address_1, login_id, user_password, user_type) values (" & Session("uid") & ", '" & dealer_name & "', '" & web_addr & "', '" & user_login & "', '" & password & "', 'W') "
			set objRS=objDB.Execute(SQL)
			SQL = "select @@identity as uid"
			set objRS=objDB.Execute(SQL)
			if not objRS.Eof then
				SQL = "Insert Into tb_open_game(dealer_id, game_type, set_date, game_status,	game_active) values " _
					& "("&objRS("uid")&", 1, GetDate(), 1,'A')"
				set objRS2=objDB.Execute(SQL)
			end if
			objRS.Close
		end if
%>



<form name="form1" action="dealer_web_config.asp" method="post">
	
	<center><br>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
						<input type="button" class="btn btn-primary" value="เพิ่ม" style="width: 100px;"  onClick="click_add();">&nbsp;&nbsp;&nbsp;					
						<input type="button" class="btn btn-secondary " value="ออก" style="width: 100px;" onClick="gotoPage('firstpage_dealer.asp')">
					</td>
				</tr>
			</table>
			<div class="table-responsive">
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%" class="table table-striped">
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" class="btn-info">
							<tr>
								<td colspan="9" class="tdbody kt-shape-bg-color-3" >
									&nbsp;หน้าตั้ง Web สำหรับเจ้ามือ
								</td>
							</tr>
							<tr>
								<td class="textbig_white" align="right" colspan="2" bgcolor="#282828">หมายเลข</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ชื่อเจ้ามือ</td>
								<td class="textbig_white" align="center" bgcolor="#282828">URL (web address)</td>
<!-- 16/6/09 ตัดกลุ่มออก เหลือแต่ user name password
								<td class="textbig_white" align="center" bgcolor="#282828">กลุ่ม</td> -->
								<td class="textbig_white" align="center" bgcolor="#282828">ชื่อ</td>
								<td class="textbig_white" align="center" bgcolor="#282828">รหัสผ่าน</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ตั้งราคา</td>
								<td class="textbig_white" align="center" bgcolor="#282828">Login</td>
							</tr>
							<%
							SQL="exec spGetGame_Type_by_dealer_id " & dealer_id	
							set objRS=objDB.Execute(SQL)
							if not objRS.eof then
								game_type=objRS("game_type")
								select case  game_type
									case 1
										pic="images/price_gov.jpg"
									case 2
										pic="images/price_tos.jpg"
									case 3
										pic="images/price_oth.jpg"
								end select
							end if
							objRS.Close
							SQL="select  * from sc_user where create_by=" & dealer_id & " and user_type='W' order by user_name "
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							if mode="add_new" then
							%>
								<tr>
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;" onClick="click_add_save();" >
									</td>
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
									</td>											
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="dealer_name" 
										class="input1" size="20" maxlength="50" onKeyDown="return chkEnter(this);">
									</td>
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="web_addr" value="http://" 	
										class="input1"  size="50" maxlength="100" onKeyDown="chkEnter(this);">	
									</td>										
<!-- 16/6/09 ตัดกลุ่มออก เหลือแต่ user name password									
										<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="grp_login" 
										class="input1"  size="15" maxlength="50" onKeyDown="chkEnter(this);">	
									</td> -->
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_login" 
										class="input1"  size="15" maxlength="50" onKeyDown="chkEnter(this);">												
									</td>
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="password" 
										class="input1"  size="15" maxlength="20" onKeyDown="chkEnter(this);">  										
									</td>
									<td bgcolor="<%=c %>">&nbsp;</td>
									<td bgcolor="<%=c %>">&nbsp;</td>									
								</tr>
							<%	
							end if
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							while not objRS.eof
							
								if mode="edit" and Cint(objRS("user_id"))=Cint(edit_web_id) then
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;" onClick="click_edit_save('<%=objRs("user_id")%>');" >
										</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
										</td>							
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="dealer_name" value="<%=objRs("user_name")%>"
											class="input1" size="20" maxlength="50" onKeyDown="chkEnter(this);">
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="web_addr" value="<%=objRs("address_1")%>" 	
											class="input1"  size="50" maxlength="100" onKeyDown="chkEnter(this);">	
										</td>										
<!-- 										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="grp_login" value="<%=objRs("nick_name")%>" 
											class="input1"  size="15" maxlength="50" onKeyDown="chkEnter(this);">	
										</td> -->
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_login" value="<%=objRs("login_id")%>" 
											class="input1"  size="15" maxlength="50" onKeyDown="chkEnter(this);">												
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="password" value="<%=objRs("user_password")%>" 
											class="input1"  size="15" maxlength="20" onKeyDown="chkEnter(this);">  										
										</td>								
										<td bgcolor="<%=c %>">&nbsp;</td>
										<td bgcolor="<%=c %>">&nbsp;</td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputE" value="แก้ไข" style="cursor:hand; width: 75px;" onClick="click_edit('<%=objRs("user_id")%>');" >
										</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ลบ" style="cursor:hand; width: 75px;" onClick="click_del('<%=objRs("user_id")%>','<%=objRs("user_name")%>');" >
										</td>											
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="200"><%=objRS("user_name")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="300"><%=objRS("address_1")%>	</td>
<!-- 										<td class="tdbody" bgcolor="<%=c %>" align="left" width="100"><%=objRS("nick_name")%>	</td> -->
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="100"><%=objRS("login_id")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="100"><%=objRS("user_password")%></td>
										<td class="tdbody" bgcolor="<%=c %>" align="center"><input type=button 
                                                class="inputM" name=bttsetprice value="ตั้งราคา" 
                                                onClick="gotoPage('price_web_config_byuser.asp?player_id=<%=objRS("user_id")%>&game_type=<%=game_type%>');" 
                                                style="width: 90px"></td>
										<td class="tdbody" bgcolor="<%=c %>" align="center"><input type=button class="inputM" name=bttlogin value="Log in" onClick="goLogin('<%=objRS("address_1")%>', '<%=objRS("login_id")%>','<%=objRS("user_password")%>','<%=objRS("nick_name")%>');" style="width: 90px"></td>
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
				<tr>
					<td colspan=2 class=head_red>*** ช่อง URL (web address) : ต้องปิดท้ายด้วยเครื่องหมาย "/" เสมอ </td>
				</tr>
				<tr>
					<td colspan=2 class=head_red>*** กรณีตั้งเจ้ามือใน web เดียวกันในช่อง URL ให้ใส่เป็นช่องว่าง </td>
				</tr>
			</table>
			</div>
	</center>
	<input type="hidden" name="mode">
	<input type="hidden" name="edit_web_id">
	
	</form>



<script language="javascript">
function click_edit(web_id){
	document.form1.mode.value="edit";
	document.form1.edit_web_id.value=web_id;
	document.form1.submit();
}
function click_del(web_id, dealer_name){
	if (confirm('คุณต้องการลบรายการ ' + dealer_name+' ?' )){
		document.form1.mode.value="delete";
		document.form1.edit_web_id.value=web_id;
		document.form1.submit();
	}
}
function click_cancel(){
	document.form1.mode.value="cancel";
	document.form1.edit_web_id.value=""
	document.form1.submit();
}
function click_edit_save(web_id){
	if (document.form1.dealer_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อเจ้ามือ')
		document.form1.dealer_name.focus();
		return false
	}
	if (document.form1.web_addr.value=="http://"){
		document.form1.web_addr.value="";
	}

	if (document.form1.user_login.value==""){
		alert('ผิดพลาด : กรุณากรอก user ของกลุ่ม')
		document.form1.user_login.focus();
		return false
	}
	if (document.form1.password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.password.focus();
		return false
	}
	document.form1.mode.value="edit_save";
	document.form1.edit_web_id.value=web_id;
	document.form1.submit();
}
function click_status(web_id){
	document.form1.mode.value="edit_status";
	document.form1.edit_web_id.value=web_id;
	document.form1.submit();
}
function click_add(){
	document.form1.mode.value="add_new";
	document.form1.submit();
}
function click_add_save(){
	if (document.form1.dealer_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อเจ้ามือ')
		document.form1.dealer_name.focus();
		return false
	}
	if (document.form1.web_addr.value=="http://"){
		document.form1.web_addr.value="";
		//alert('ผิดพลาด : กรุณากรอก URL (web address)')
		//document.form1.web_addr.focus();
		//return false
	}

	if (document.form1.user_login.value==""){
		alert('ผิดพลาด : กรุณากรอก user ของกลุ่ม')
		document.form1.user_login.focus();
		return false
	}
	if (document.form1.password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.password.focus();
		return false
	}
	document.form1.mode.value="add_save";
	document.form1.submit();
}
//เช็ค กด enter
function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			if(obj.name=="dealer_name"){
				document.form1.web_addr.focus();
			}
			if(obj.name=="web_addr"){
				document.form1.user_login.focus();
				//document.form1.grp_login.focus();
			}

			if(obj.name=="user_login"){
				document.form1.password.focus();
			}
			if(obj.name=="password"){
				document.form1.btt_save.focus();
			}

		} else {
			if(obj.name=="dealer_name"){
				if ( k > 96 && k < 105)
				{
					alert("กรุณาระบุเป็นตัวอักษรเท่านั้น !!!");
					return false;
				}
			}			
		}
	}

	function print_user() {	window.open("dealer_print_player.asp","_blank","top=150,left=150,height=600,width=800,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function click_rec_dealer(){
		document.form1.mode.value="edit_rec_dealer";
		document.form1.submit();
	}
	
		function goLogin(locate, uname, passw, dealer){
		
		
		if (uname==''){
			alert('กรุณาป้อน ชื่อ ผู้ใช้งาน')
			return false
		}
		if (passw==''){
			alert('กรุณาป้อน รหัสผ่าน')
			return false
		}
		
		window.open(locate+"mdlCheckUser.asp?txtUserName="+uname+"&password1="+passw ,"_blank", "scrollbars=no, status=0, fullscreen=1, location=0, toolbar=0, titlebar=0, width=1020, height=740, top=0, left=0");	
		//return false;
	
		//top.window.opener = window;
		//top.close();
		
		//window.open('close.html', '_parent');
		
				
	}
</script>
<%
	if mode="add_new" Then
	%>
		<script language="javascript">
			document.form1.dealer_name.focus();
		</script>
	<%
	End if
%>

<% End Sub %>