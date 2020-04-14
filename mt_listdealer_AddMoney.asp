<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="include/config.inc"-->
<%
		' admin ตั้งเจ้ามือได้ 3 หลัก 000-999 //2009-02-19
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_user_id
		Dim user_name, user_password, sum_password, old_remain, login_id, address_1, cntlogin, cntDealer
		dim tRefresh
		Dim limit_play,objRSTMP

		mode=Request("mode")
		edit_user_id=Request("edit_user_id")
		if edit_user_id="" then edit_user_id=0
	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		
		Set objRSTMP =Server.CreateObject("ADODB.Recordset")		
		dealer_id=Session("uid")
		game_type=Request("game_type")
		if mode="chg_game_type" then
			SQL="update tb_open_game set game_type=" & game_type & " where dealer_id=" & dealer_id & _
			" and game_active='A' "
			set objRS=objDB.Execute(SQL)
		end if
		if mode="edit" then ' กรณีที่ user click แก้ไขรายการ
			'response.write "edit" & edit_user_id
		end if
		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			user_name=Request("user_name")
			user_password=Request("user_password")
			sum_password=Request("sum_password")
			limit_play=Replace(Request("limit_play"),",","")
			old_remain=Replace(Request("old_remain"),",","")
			if old_remain="" then old_remain=0
			login_id=Request("login_id")
			address_1=Request("address_1")
			cntlogin= Replace(Request("cntlogin"),",","")
			cntDealer = Replace(Request("sum_active"),",","")
			SQL="exec spEdit_sc_user '" & login_id & "','" & user_name & "','" & user_password & "','" & sum_password & _
			"'," & old_remain & ",'" & address_1 & "'," & edit_user_id & ", " & cntlogin & ", " & cntDealer & "," & limit_play
'response.write SQL
'response.end
			set objRS=objDB.Execute(SQL)
		end if
'		if mode="delete" then ' กรณีที่ user click ลบรายการ
'			SQL="delete sc_user where [user_id]=" & edit_user_id
'			set objRS=objDB.Execute(SQL)
'		end if
		if mode="edit_status" then
			'//SQL="exec spEdit_status_by_user_id "  & edit_user_id
			SQL="exec spEdit_user_disable "  & edit_user_id
			set objRS=objDB.Execute(SQL)
		end if
		if mode="add_save" then
			user_name=Request("user_name")
			user_password=Request("user_password")
			sum_password=Request("sum_password")
			limit_play=Request("limit_play")
			old_remain=Replace(Request("old_remain"),",","")
			if old_remain="" then old_remain=0
			login_id=Request("login_id")
			address_1=Request("address_1")
			cntlogin= Request("cntlogin")
			If cntlogin="" Then cntlogin=0
			cntDealer = Request("sum_active")
			If cntDealer="" Then cntDealer=0
			if not isnumeric(old_remain) then
				Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก ยอดค้างเก่าต้องเป็นตัวเลข !!!</font></span></center>"
			else	
				SQL="select * from sc_user where create_by=" & dealer_id & " and user_name='" & user_name & "'"
				set objRS=objDB.Execute(SQL)
				if not objRS.eof then
						Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มีชื่อนี้แล้ว !! " & user_name & "</font></span></center>"
				else
						SQL="select * from sc_user where create_by=" & dealer_id & " and login_id='" & login_id & "'"
						set objRS=objDB.Execute(SQL)
						if not objRS.eof then
								Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มี หมายเลข นี้แล้ว !! " & login_id & "</font></span></center>"
						else
							SQL="exec spAdd_sc_user_admin '" & login_id & "','" & user_name & "','" & user_password & "','" & sum_password & _
							"'," & old_remain & ",'" & address_1 & "'," & dealer_id & ",0,"  & limit_play
							set objRS=objDB.Execute(SQL)
						end if
				end if
			end if
		end if

%>
<html>
<head>
<title>.:: config Add Money ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
<style type="text/css">
  <!--
  div#blinking {text-decoration: blink;}
  -->
</style>
<script language="javascript">
	function open_setvalue(uid){
		window.open("dealer_setvalue_addmoney.asp?uid="+uid, "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}
</script>

<script type="text/javascript">
	var xmlHttp;
	var div_id
	function createXMLHttpRequest(){
		if(window.ActiveXObject){
			xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
		}
		else if(window.XMLHttpRequest){
			xmlHttp= new XMLHttpRequest();
		}
	}
	function startRequest(id){
		if(id==div_id){
			document.getElementById(div_id).innerHTML="";		
			div_id="";
			return;
		}
		createXMLHttpRequest();
		var sName=id; //document.getElementById(id).value;
		div_id=id;
		xmlHttp.onreadystatechange=handelStateChange;
		xmlHttp.open("GET","shw_player_Money.asp?user_id="+sName,true);
		xmlHttp.send(null);
	}
	function handelStateChange(){
		if(xmlHttp.readyState==4){
			if(xmlHttp.status==200){
				document.getElementById(div_id).innerHTML=xmlHttp.responseText;				
			}
		}
	}
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
</script>
</head>
<body topmargin="0"  leftmargin="0" onload="setInterval('blinkIt()',500)">
	<form name="form1" action="mt_listdealer_AddMoney.asp" method="post">
	<center><br>

			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
					<td align="center">
						<table  border="0"  cellpadding="1" cellspacing="1" width="80%">							
							<tr>
                                <td class="head_red">
									กดที่หมายเลขหรือชื่อเจ้ามือเพื่อรายระเอียดการเติมเงิน
								</td>
								<td align="right">
									<table  border="0"  cellpadding="2" cellspacing="2" bgcolor="#000000">
										<tr bgcolor="#FFFFFF">
											<td colspan="13" align="right" class="head_black">
											<%
											Dim d_cnt,p_cnt
											d_cnt=0
											p_cnt=0
											SQL="select count(user_id) as cnt from sc_user where is_online=1 and user_type='D' "
											Set objRSTMP=objDB.Execute(SQL)
											If Not objRSTMP.eof Then
												d_cnt=objRSTMP("cnt")
											End If 
											SQL="select count(user_id) as cnt from sc_user where is_online=1 and user_type='P' "
											Set objRSTMP=objDB.Execute(SQL)
											If Not objRSTMP.eof Then
												p_cnt=objRSTMP("cnt")
											End If 
											%>
												ขณะนี้ออนไลน์ ...<%=d_cnt%> + <%=p_cnt%> .... คน
											</td>
										</tr>
									</table>
								</td>	
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#000040">					
							<tr>
                                <td class="textbig_white" align="center" bgcolor="#282828">เปิด/ปิด</td>	
								<td class="textbig_white" align="center" bgcolor="#282828">หมายเลข</td>
								<td class="textbig_white" align="center" bgcolor="#282828">ชื่อ</td>
								<td class="textbig_white" align="center" bgcolor="#282828">Password</td>
								<td class="textbig_white" align="center" bgcolor="#282828">login</td>
								<td class="textbig_white" align="center" bgcolor="#282828">IP Address</td>
								<td class="textbig_white" align="center" bgcolor="#282828">รวมเติมเข้า</td>
								<td class="textbig_white" align="center" bgcolor="#282828">รวมตัดออก</td>	
								<td class="textbig_white" align="center" bgcolor="#282828">คงเหลือ</td>
                                <td class="textbig_white" align="center" bgcolor="#282828"> </td>
							</tr>
							
							<%
							'SQL="select  * from sc_user where user_type='D' order by user_id "
							SQL="exec spGetDealer_byMoney"
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							if mode="add_new" then
								tmp_Color="red"
							%>
								<tr>
									<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;">&nbsp;</td>									
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="login_id" 
										class="input1" size="3" maxlength="3" onKeyDown="chkEnter(this);">
									</td>
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_name" 	
										class="input1"  size="15" maxlength="80" onKeyDown="chkEnter(this);">	
									</td>										
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_password" 
										class="input1"  size="10" maxlength="20" onKeyDown="chkEnter(this);">	
									</td>
									<td class="tdbody" bgcolor="<%=c %>" align="right">

										<input type="text" name="limit_play" 
										class="input1"  size="15" maxlength="20">										

									</td>	
									<td class="tdbody" bgcolor="<%=c %>" align="right">

									&nbsp;									

									</td>	
									<td class="tdbody" bgcolor="<%=c %>" align="left"></td>
															
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<textarea rows="3" cols="20" name="address_1" class="input1" ></textarea>
									</td>
									<td class="tdbody">&nbsp;</td>
								</tr>
							<%	
							end if
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							while not objRS.eof
							
								if mode="edit" and Cint(objRS("user_id"))=Cint(edit_user_id) then
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									if not objRS("user_disable") then
										tmp_Color="#33CC33"
									else
										tmp_Color="red"
									end if
									%>
									<tr>
										<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;" 
										onClick="click_status('<%=objRs("user_id")%>');">&nbsp;</td>
										<td bgcolor="#FFFFFF">
											<input type="button" class="inputG" value="บันทึก" style="cursor:hand; width: 75px;" onClick="click_edit_save('<%=objRs("user_id")%>');" >
										</td>											
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="login_id" value="<%=Trim(objRS("login_id")) %>" 
											class="input1" size="10" maxlength="5"  onKeyDown="chkEnter(this);">
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_name" 	value="<%=objRS("user_name")%>" 
											class="input1"  size="15" maxlength="80"  onKeyDown="chkEnter(this);">	   
										</td>										
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_password" value="<%=objRS("user_password")%>"	
											class="input1"  size="15" maxlength="20" onKeyDown="chkEnter(this);">	
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="limit_play" value="<%=(objRS("sum_add"))%>"	
											class="input1"  size="15" maxlength="20">										
										</td>

										<td class="tdbody" bgcolor="<%=c %>" align="left">
											&nbsp;									
										</td>

										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="cntlogin" value="<%=FormatN(objRS("cnt_login"),0)%>"	
											class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">										
										</td>									
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="sum_active" value="<%=FormatN(objRS("cnt_dealer"),0)%>"	
											class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">										
										</td>																			
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<textarea rows="3" cols="20" name="address_1" class="input1" ><%=objRS("address_1")%></textarea>
										</td>
										<td>&nbsp;</td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									if not objRS("user_disable") then
										tmp_Color="#33CC33"
									else
										tmp_Color="red"
									end if
                                    Dim st_blink,ed_blink
                                    If objRS("sum_add")="0" Then ' blink 
				                        st_blink="<font color='red'>" '"<blink>"
				                        ed_blink="</font>" '"</blink>"
			                        Else
				                        st_blink="<font color='green'>"
				                        ed_blink="</font>"
			                        End If 
									%>
									<tr>
										<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;" 
										onClick="click_status('<%=objRs("user_id")%>');">&nbsp;</td>										
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="60" style="cursor:hand;" onClick="startRequest('<%=objRS("user_id")%>')"><%=objRS("login_id")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="145" style="cursor:hand;" onClick="startRequest('<%=objRS("user_id")%>')"><%=objRS("user_name")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80" style="cursor:hand;" onClick="startRequest('<%=objRS("user_id")%>')"><%=objRS("user_password")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="center" width="80"><%=objRS("cnt_login")%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="right" width="80">
											<%=objRS("ip_address")%>
										</td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="right"><%=objRS("sum_add")%></td>
										<td class="tdbody" bgcolor="<%=c %>" align="right"><%=objRS("sum_out")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="right"><%=st_blink %><%=objRS("sum_bal")%><%=ed_blink %></td>											
										<td class="tdbody" bgcolor="<%=c %>" align="center"><INPUT TYPE="button" class=inputM value="เติมเงิน" onClick="open_setvalue('<%=objRs("user_id")%>');" style="width:100"></td>
									</tr>
									<tr>										
										<td bgcolor="#FFFFFF" colspan="12" align="center">
											<div id="<%=objRs("user_id")%>"></div>
										</td>
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
</body>
</html>

<%
function FormatN(n,dot)
	if n="0" or n="" then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
end function
%>
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
	if (document.form1.limit_play.value=="")
	{
		alert("กรุณากรอก วงเงิน เป็นตัวเลขเท่านั้น")
		return false
	}
	if (isNaN(document.form1.limit_play.value))
	{
		alert("กรุณากรอก วงเงิน เป็นตัวเลขเท่านั้น")
		return false
	}
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
function click_add_save(){
	if (document.form1.login_id.value==""){
		alert('ผิดพลาด : กรุณากรอก หมายเลข เจ้ามือ')
		document.form1.login_id.focus();
		return
	}
	if (isNaN(document.form1.login_id.value)){
		alert('ผิดพลาด : กรุณากรอก หมายเลข เจ้ามือ เป็นตัวเลขเท่านั้น')
		document.form1.login_id.focus();
		return
	}
	if (document.form1.login_id.value.length!=3){
		alert('ผิดพลาด : กรุณากรอก หมายเลข เจ้ามือ เป็นตัวเลข 3 หลัก เท่านั้น')
		document.form1.login_id.focus();
		return
	}

	if (document.form1.user_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อ เจ้ามือ')
		document.form1.user_name.focus();
		return
	}
	if (document.form1.user_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.user_password.focus();
		return
	}
	/*
	if (document.form1.sum_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสดูยอดเงิน')
		document.form1.sum_password.focus();
		return
	} */
	if (document.form1.limit_play.value=="")
	{
		alert("กรุณากรอก วงเงิน เป็นตัวเลขเท่านั้น")
		return false
	}

	if (isNaN(document.form1.limit_play.value))
	{
		alert("กรุณากรอก วงเงิน เป็นตัวเลขเท่านั้น")
		return false
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
				document.form1.limit_play.focus();
			}
			/*
			if(obj.name=="sum_password"){
				document.form1.limit_play.focus();
			}*/
			if(obj.name=="limit_play"){
				document.all.btt_save.focus();
			}

		}
	}
	function click_play_amt(dealer_id){
		var ParmA = ""; //document.form1.proj_code.value;
		var ParmB = "";
		var ParmC = '';
		var MyArgs = new Array(ParmA, ParmB, ParmC);
		MyArgs=window.showModalDialog('shw_over_limit.asp?dealer_id='+dealer_id, '', 'dialogTop:'+0+'px;dialogLeft:'+640+'px;dialogHeight:720px;dialogWidth:430px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');
		
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