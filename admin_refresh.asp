<%OPTION EXPLICIT%>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%
		Dim objRS , objDB , SQL	, objPY
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_user_id
		Dim user_name, user_password, sum_password, old_remain, login_id, address_1, view_dealer_id
		dim refresh_time
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Set objPY =Server.CreateObject("ADODB.Recordset")		

		mode=Request("mode")
		edit_user_id=Request("edit_user_id")
		view_dealer_id=Request("view_dealer_id")

		if edit_user_id="" then edit_user_id=0
		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			refresh_time = Request("refresh_time")
			if trim(refresh_time)="" then refresh_time=0
			SQL="Update sc_user set refresh_time = " & refresh_time & " where user_id= '" & edit_user_id & "'"
			set objRS=objDB.Execute(SQL)
		end if

		if mode="edit_all" then
			refresh_time = Request("refresh_time")
			if trim(refresh_time)="" then refresh_time=0
			SQL="Update sc_user set refresh_time = " & refresh_time 
			set objRS=objDB.Execute(SQL)
		end if
		
		if mode="edit_player"  then
			refresh_time = Request("refresh_time")
			if trim(refresh_time)="" then refresh_time=0
			SQL="Update sc_user set refresh_time = " & refresh_time & " where create_by= '" & edit_user_id & "' or user_id='" & edit_user_id & "'"
			set objRS=objDB.Execute(SQL)
		end if

		if mode="clear_usage" then
			SQL="Update sc_user set cnt_login = 0"
			set objRS=objDB.Execute(SQL)			
		end if
%>

<html>
<head>
<title>.:: config price ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
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
</head>
<body topmargin="0"  leftmargin="0" onload="setInterval('blinkIt()',500)">
	<form name="form1" action="admin_refresh.asp" method="post">
	<center><br>
			<table  border="0"  cellpadding="1" cellspacing="1"  width="90%">
				<tr>
					<td align="left" colspan=1>
					<font color=red size="3">กดที่หมายเลขเจ้ามือเพื่อดูเอเย่นต์</font>
					</td>
					<td align="right" class="text_green">
					<%
					Dim cnt_dealer, cnt_player
					SQL="select count(*) as cnt_dealer from sc_user where is_online=1 and user_type='D'"
					set objRS=objDB.Execute(SQL)	
					If Not objRS.eof Then
						cnt_dealer=objRS("cnt_dealer")
					End If 
					SQL="select count(*) as cnt_player from sc_user where is_online=1 and user_type='P'"
					set objRS=objDB.Execute(SQL)	
					If Not objRS.eof Then
						cnt_player=objRS("cnt_player")
					End If 

					%>
						ขณะนี้มีคนออนไลน์อยู่ .. <%=cnt_dealer%> + <%=cnt_player%> .. คน 
					</td>
				</tr>
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#000040" width="100%">
							<tr>
								<td class="textbig_white" align="right" colspan="2" bgcolor="#282828">หมายเลข</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ชื่อ</td>
								<td class="textbig_white" align="center" bgcolor="#282828">Password</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ค่า Refresh</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ใช้เวลาเดียวกัน</td>
								<td class="textbig_white" align="center" bgcolor="#282828">วันที่เข้าระบบครั้งแรก</td>
								<td class="textbig_white" align="center" bgcolor="#282828">เข้าระบบครั้งสุดท้าย</td>
								<td class="textbig_white" align="center" bgcolor="#282828">IP ที่เข้ามาล่าสุด</td>
								<td class="textbig_white" align="center" bgcolor="#282828"><input type=button onClick="return ClearUsage();" value="ล้างจำนวนครั้งสะสม" class="inputR"></td>
							</tr>
							
							<%
							SQL="select  * from sc_user where user_type='D' and user_id <> '999' order by login_id "
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							Dim stblink, enblink
							while not objRS.eof
								If objRS("is_online")=1 Then
									stblink="<blink>"
									enblink="</blink>"
								Else
									stblink=""
									enblink=""
								End If 
								if mode="edit" and Cint(objRS("user_id"))=Cint(edit_user_id) then
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type=button value="บันทึก" class="inputG" style="cursor:hand; width: 75px;" onClick="click_edit_save('<%=objRs("user_id")%>');" >
											<input type=button value="ยกเลิก" class="inputR" style="cursor:hand; width: 75px;" onClick="click_cancel();" >
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="login_id" value="<%=objRS("login_id")%>" 
											class="input_disable" size="3" maxlength="5" readonly>
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_name" 	value="<%=objRS("user_name")%>" 
											class="input_disable"  size="15" maxlength="80" readonly>	   
										</td>										
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_password" value="<%=objRS("user_password")%>"	
											class="input1"  size="5" readonly>	
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="txtrefresh" value="<%=objRS("refresh_time")%>"	
											class="input1"  size="5" maxlength="3">												
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											&nbsp;<input type=button value="กับทั้งหมด" class="inputE" onClick="click_edit_all('<%=objRS("user_id")%>','<%=objRS("refresh_time")%>');">&nbsp;
											&nbsp;<input type=button value="กับเอเย่นต์" class="inputE" onClick="click_edit_player('<%=objRS("user_id")%>','<%=objRS("refresh_time")%>');" >&nbsp;
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
										<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
										<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
										<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									%>
									<tr>
										<td bgcolor="#FFFFFF">
											<input type=button value="แก้ไข" class="inputE" style="cursor:hand; width: 75px;" onClick="click_edit('<%=objRs("user_id")%>');" >
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="60" style="cursor=hand;"  onClick="click_viewplayer('<%=objRs("user_id")%>');"><%=objRS("login_id")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="145"><%=stblink%><%=objRS("user_name")%><%=enblink%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=objRS("user_password")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=objRS("refresh_time")%>	</td>
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" >&nbsp;</td>
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("create_date")%>	</td>
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("activate_time")%>	</td>
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("ip_address")%>	</td>
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("cnt_login")%>	</td>
									</tr>
									<!----------------------------------------------------------->
									<%
								end if
								'****************  หา คนแทง ใน เจ้ามือ
								If   CStr(objRS("user_id")) = CStr(view_dealer_id) Then
									SQL="select  * from sc_user where user_type='P'  and create_by= "&objRS("user_id")&"  order by login_id "
									set objPY=objDB.Execute(SQL)
									c="#FFFFA4"
									'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
									'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
									while not objPY.eof
										If objPY("is_online")=1 Then
											stblink="<blink>"
											enblink="</blink>"
										Else
											stblink=""
											enblink=""
										End If 
										if mode="edit" and Cint(objPY("user_id"))=Cint(edit_user_id) then
											'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
											%>
											<tr>
												<td bgcolor="#FFFFFF">
													<input type=button value="บันทึก" class="inputG" style="cursor:hand; width: 75px;" onClick="click_edit_save('<%=objPY("user_id")%>');" >
													<input type=button value="ยกเลิก" class="inputR" style="cursor:hand; width: 75px;" onClick="click_cancel();" >

												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left">
													<input type="text" name="login_id" value="<%=objPY("login_id")%>" 
													class="input_disable" size="3" maxlength="5" readonly>
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left" class=head_red>
													&nbsp;<font color=red>>>></font>&nbsp;<input type="text" name="user_name" 	value="<%=objPY("user_name")%>" 
													class="input_disable"  size="15" maxlength="80" readonly> 
												</td>										
												<td class="tdbody" bgcolor="<%=c %>" align="left">
													<input type="text" name="user_password" value="<%=objPY("user_password")%>"	
													class="input1"  size="5" maxlength="20">	
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left">
													<input type="text" name="txtrefresh" value="<%=objPY("refresh_time")%>"	
													class="input1"  size="5" maxlength="20">												
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left">
													&nbsp;<input type=button value="กับทั้งหมด" class="inputE" onClick="click_edit_all('<%=objPY("user_id")%>','<%=objPY("refresh_time")%>');">&nbsp;
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
												<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
												<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
												<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
											</tr>
											<!-----------------------------------------------------------><%
										else
											'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
											%>
											<tr>
												<td bgcolor="#FFFFFF">
													<input type=button value="แก้ไข" class="inputE" style="cursor:hand; width: 75px;" onClick="click_edit('<%=objPY("user_id")%>');" >
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left" width="60"><%=objPY("login_id")%>	</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left" width="145">&nbsp;<%=stblink%><font color=red>>>></font>&nbsp;
												<font color=green><%=objPY("user_name")%>	</font><%=enblink%></td>
												<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=objPY("user_password")%>	</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=objPY("refresh_time")%>	</td>
												<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" >&nbsp;
												</td>
												<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objPY("create_date")%>	</td>
												<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objPY("activate_time")%>	</td>
												<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objPY("ip_address")%>	</td>
												<td nowrap class="tdbody" bgcolor="<%=c %>" align="left" ><%=objPY("cnt_login")%>	</td>
											</tr>
											<!----------------------------------------------------------->
											<%
										end if
									objPY.MoveNext
									Wend
								End If ' กรณี เลือกดูที่เจ้ามือ

								objRS.MoveNext
							wend 
							%>
							<tr>
								<td colspan=10 class=tdbody>
								<font color=red size="3">กดที่หมายเลขเจ้ามือเพื่อดูเอเย่นต์</font><br>
								<font color=red>>>></font>= เอเย่นต์ที่อยู่ภายใต้เจ้ามือ</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
	</center>
	<input type="hidden" name="mode" value=""> 
	<input type="hidden" name="edit_user_id">
	<input type="hidden" name="refresh_time">
	<input type="hidden" name="view_dealer_id" value="<%=view_dealer_id%>">
	
	</form>
</body>
</html>
<script language="javascript">
function click_viewplayer(user_id) {
	document.form1.mode.value="";
	if (document.form1.view_dealer_id.value==user_id) {
		document.form1.view_dealer_id.value="";		
	} else {
		document.form1.view_dealer_id.value=user_id;
	}
	document.form1.submit();	
}

function click_edit(user_id){
	document.form1.mode.value="edit";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}
function click_cancel(){
	document.form1.mode.value="cancel";
	document.form1.edit_user_id.value=""
	document.form1.submit();
}
function click_edit_save(user_id){
	document.form1.mode.value="edit_save";
	document.form1.edit_user_id.value=user_id;
	if (!isNaN(document.form1.txtrefresh.value)) {
		document.form1.refresh_time.value=	document.form1.txtrefresh.value;
		document.form1.submit();
	} else {
		alert("กรุณาระบุ ค่า Refresh เป็นตัวเลข !")
	}
}
function click_status(user_id){
	document.form1.mode.value="edit_status";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}

function click_edit_all(user_id, refreshtime) {
	document.form1.mode.value="edit_all";
	document.form1.edit_user_id.value=user_id;
	if (document.form1.txtrefresh != "undefined") {
		document.form1.refresh_time.value=	document.form1.txtrefresh.value;

	} else {
		document.form1.refresh_time.value=refreshtime;
	}
	document.form1.submit();
}
function click_edit_player(user_id,refreshtime) {
	document.form1.mode.value="edit_player";
	document.form1.edit_user_id.value=user_id;
	if (document.form1.txtrefresh != "undefined") {
		document.form1.refresh_time.value=	document.form1.txtrefresh.value;
	} else {
		document.form1.refresh_time.value=refreshtime;
	}
	document.form1.submit();
}

function ClearUsage() {
	if (confirm("ยืนยันการล้างจำนวนครั้งสะสม")) {
			document.form1.mode.value="clear_usage";
			document.form1.submit();
			return true;
	} else {
		return false;
	}
}
</script>