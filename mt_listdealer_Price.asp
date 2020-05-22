<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<!--#include file="include/config.inc"-->
<%
		' admin ตั้งเจ้ามือได้ 3 หลัก 000-999 //2009-02-19
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim objRS , objDB , SQL	,SQL2
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
        objDB.CommandTimeout = 600     
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

%>
<html>
<head>
<title>.:: Dealer price ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<style type="text/css">
  <!--
  div#blinking {text-decoration: blink;}
  -->
</style>
<script language="javascript">
	function open_setvalue(uid){
		window.open("dealer_setvalue_fight.asp?uid="+uid, "_blank","top=200,left=200,height=200,width=400,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
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
		xmlHttp.open("GET","shw_player.asp?user_id="+sName,true);
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
	<form name="form1" action="mt_listdealer_Price.asp" method="post">
	<center><br>

			<table  border="0"  cellpadding="1" cellspacing="1"  width="100%" class="table">
				<tr>
					<td align="center">
						<table  border="0" cellpadding="1" cellspacing="1" width="100%">							
							<tr>
								<td class="head_red" align="center">
									แสดงยอดค่าบริการใช้งาน แต่ละงวดรายเอเย่นต์เทียบทั้งแบบที่1 และแบบที่2
								</td>
							</tr>
						</table>
					</td>
				</tr>
                <tr>
					<td align="center">
						<table  border="0" cellpadding="1" cellspacing="1" width="100%" class="table">							
							<tr>
								<td class="head_red" align="center">
									<select name="yyyymmgame" style="width:100"  >
                                        <%
                                            SQL2="exec spGetDealerprice_lookup"
							                set objRS=objDB.Execute(SQL2)
                                            while not objRS.eof
                                        %>
							            <option value="<%=objRS("yyyymm")%>"><%=objRS("yyyymm")%></option>
                                        <%
								            objRS.MoveNext
							                wend 
							            %>
						            </select>
                                    <input type="button" class="btn btn-primary btn-sm" value="คำนวนค่าเช่า" style="cursor:hand; width: 100px;" onClick="click_search();">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="center" colspan=2>
						<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#000040">					
							<tr>
								<td class="textbig_white" align="center" bgcolor="#282828">เกมส์</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">วันที่</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ผู้ใช้</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ผู้ล๊อคอิน</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ชื่อ</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ยอดจ่าย</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">จำกัดวงเงิน</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ประเภท</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ยอดรับ</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">บน</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ล่าง</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">จำนวนผู้ใช้</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">รวมยอดเช่า</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ประเภท</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">เครดิต</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ยอดรับ</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ยอดเกิน</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">รวมยอดเช่า</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">วันที่สร้าง</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">ผู้ใช้ทั้งหมด</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">วันที่ใช้งานล่าสุด</td>
                                <td class="textbig_white" align="center" bgcolor="#282828">จำนวนผู้ใช้ปัจจุบัน</td>
							</tr>
                            <%

                            Dim c,d,e
							c="#FFFFA4"
                            d="#33CC33"
                            e="yellow"

                                if mode <> "" then
							        SQL="exec spGetDealerprice_byAdmin '" & mode & "'"
							        set objRS=objDB.Execute(SQL)
                                else
                                    SQL="exec spGetDealerprice_byAdmin ''"
							        set objRS=objDB.Execute(SQL)
                                end if

                                while not objRS.eof

							%>
									<tr>										
										<td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("game_id")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("set_date")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("user_id")%></td>
                                        <td bgcolor="<%=e %>" align="left" ><%=objRS("login_id")%></td>
                                        <td bgcolor="<%=e %>" align="left" ><%=objRS("user_name")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("paid_flag")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("limit_play")%></td>
                                        <td bgcolor="<%=d %>" align="left" ><%=objRS("typepaid1")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_money")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_up")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_down")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_account")%></td>
                                        <td bgcolor="<%=e %>" align="left" ><%=objRS("total_paid1")%></td>
                                        <td bgcolor="<%=d %>" align="left" ><%=objRS("typepaid2")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_credit")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("sum_receive")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("over_credit")%></td>
                                        <td bgcolor="<%=e %>" align="left" ><%=objRS("total_paid2")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("create_date")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("create_days")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("active_date")%></td>
                                        <td class="tdbody" bgcolor="<%=c %>" align="left" ><%=objRS("active_days")%></td>
										
									</tr>

                            <%
								
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
function click_search(){
    document.form1.mode.value = document.all.yyyymmgame.value;
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