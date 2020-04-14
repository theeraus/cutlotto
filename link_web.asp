<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	, tmp_Color
		Dim mode, edit_user_id
		Dim lk_id,url_name,url_desc,is_dealer,c_user_id,c_date,u_user_id,u_date, edit_lk_id
		is_dealer=Request("is_dealer")

		mode=Request("mode")
		edit_lk_id=Request("edit_lk_id")
		if edit_lk_id="" then edit_lk_id=0
		lk_id=Request("lk_id")
		url_name=Request("url_name")
		url_desc=Request("url_desc")
		is_dealer=Request("is_dealer")
		c_user_id=Session("uid")

		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			
			SQL="update tb_link_web set "
			SQL=SQL & " url_name='" & replace( url_name,"'","''") & "',  "
			SQL=SQL & " url_desc='" & replace( url_desc,"'","''") & "',  "
			SQL=SQL & " is_dealer=" & is_dealer & ","
			SQL=SQL & " u_user_id=" & c_user_id & ", "
			SQL=SQL & " u_date=getdate() "
			SQL=SQL & " where lk_id=" & edit_lk_id
			set objRS=objDB.Execute(SQL)
		end if
		if mode="delete" then ' กรณีที่ user click ลบรายการ
			SQL="delete tb_link_web where lk_id=" & edit_lk_id
			set objRS=objDB.Execute(SQL)
		end if
		if mode="add_save" Then
			SQL="insert into tb_link_web ("
			SQL=SQL & " url_name , "
			SQL=SQL & " url_desc , "
			SQL=SQL & " is_dealer , "
			SQL=SQL & " c_user_id , "
			SQL=SQL & " c_date ) values ( "
			SQL=SQL & "'" &  Replace(url_name,"'","''") & "', "
			SQL=SQL & "'" & Replace(url_desc,"'","''") & "', "
			SQL=SQL & is_dealer & ", "
			SQL=SQL & c_user_id & ", "
			SQL=SQL & " getdate() )"
			set objRS=objDB.Execute(SQL)
		end if

%>

	<form name="form1" action="link_web.asp?is_dealer=<%=is_dealer %>" method="post">
	<input type="hidden" name="edit_lk_id">
	<center><br>
<strong class="tdbody">	&bull; Link 
<%
If is_dealer=1 Then
	response.write "เจ้ามือ"
Else
	response.write "คนแทง"
End if
%>
&bull;</strong>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
					<td width="50%">
						<input type="button" class="inputG" value="เพิ่ม" style="cursor:hand; width: 75px;" onClick="click_add();">&nbsp;&nbsp;				
						<input type="button" class="inputE" value="ออก" style="cursor:hand; width: 75px;" onClick="window.open('index.asp','_top')">
					</td>

				</tr>
			</table>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#282828" width="98%">
							<tr>
								<td class="textbig_white" align="right"  bgcolor="#282828" colspan="2"></td>
								<td class="textbig_white" align="center" bgcolor="#282828">URL</td>
								<td class="textbig_white" align="center" bgcolor="#282828">รายละเอียด</td>
							</tr>
							
							<%
							SQL="select * from tb_link_web where is_dealer=" & is_dealer & " order by lk_id"
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							if mode="add_new" then
								tmp_Color="red"
							%>
								<tr>							
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;"onClick="click_add_save();" >
									</td>
									<td bgcolor="#FFFFFF">
										<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
									</td>											
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="url_name" 	
										class="input"  size="50" maxlength="100" onKeyDown="chkEnter(this);">	
									</td>										
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="url_desc" 
										class="input"  size="60" maxlength="200" onKeyDown="chkEnter(this);">	
									</td>
								</tr>
							<%	
							end if
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							while not objRS.eof
							
								if mode="edit" and Cint(objRS("lk_id"))=Cint(edit_lk_id) then
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;"onClick="click_edit_save('<%=objRs("lk_id")%>');" >
										</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ยกเลิก" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
										</td>		
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="url_name" value="<%=Trim(objRS("url_name")) %>" 
											class="input" size="60" maxlength="100"  onKeyDown="chkEnter(this);">
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="url_desc" 	value="<%=objRS("url_desc")%>" 
											class="input"  size="60" maxlength="80"  onKeyDown="chkEnter(this);">	   
										</td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputE" value="แก้ไข" style="cursor:hand; width: 75px;" onClick="click_edit('<%=objRs("lk_id")%>');" >
										</td>											
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputR" value="ลบ" style="cursor:hand; width: 75px;" onClick="click_del('<%=objRs("lk_id")%>','<%=objRs("url_name")%>');" >
										</td>											
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="40%"><%=objRS("url_name")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="40%"><%=objRS("url_desc")%>	</td>
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
function click_edit(lk_id){
	document.form1.mode.value="edit";
	document.form1.edit_lk_id.value=lk_id;
	document.form1.submit();
}
function click_del(lk_id,url_name){
	if (confirm('คุณต้องการลบรายการ ' + url_name+' ?' )){
		document.form1.mode.value="delete";
		document.form1.edit_lk_id.value=lk_id;
		document.form1.submit();
	}
}
function click_cancel(){
	document.form1.mode.value="cancel";
	document.form1.edit_user_id.value=""
	document.form1.submit();
}
function click_edit_save(lk_id){
	if (document.form1.url_name.value=="")
	{
		alert("กรุณากรอก URL")
		document.form1.url_name.focus();
		return false
	}
	if (document.form1.url_desc.value=="")
	{
		alert("กรุณากรอก รายละเอียด")
		document.form1.url_desc.focus();
		return false
	}
	document.form1.mode.value="edit_save";
	document.form1.edit_lk_id.value=lk_id;
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
function click_add_save(){
	if (document.form1.url_name.value==""){
		alert('ผิดพลาด : กรุณากรอก URL')
		document.form1.url_name.focus();
		return
	}
	if (document.form1.url_desc.value==""){
		alert('ผิดพลาด : กรุณากรอก รายละเอียด')
		document.form1.url_desc.focus();
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
				document.form1.limit_play.focus();
			}
			if(obj.name=="limit_play"){
				document.all.btt_save.focus();
			}

		}
	}
</script>
<%
	if mode="add_new" Then
	%>
		<script language="javascript">
			document.form1.login_id.focus();
		</script>
	<%
	End If
	if mode="edit" Then
	%>
		<script language="javascript">
			document.form1.login_id.focus();
		</script>
	<%
	End if
%>
<script language="vbscript">
	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>


<% End Sub  %>