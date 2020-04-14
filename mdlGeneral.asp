<head>

</head>
<%
	dim conn
	dim comm
	dim userPrintID
	dim userWebID
	dim webver,str_player
		str_player="เอเย่นต์"	
		webver = "1.0"   ' ถึง 3.9 แล้วให้ขึ้น 4.0
		userPrintID = 999
		userWebID = 1000

	dim strConnection 
		set conn = CreateObject("ADODB.Connection")	
		conn.open Application("constr")
		
		Set comm = CreateObject("ADODB.Command")	
		comm.ActiveConnection = Application("constr")

		'set connweb2 = CreateObject("ADODB.Connection")	
		'connweb2.open Application("conweb2")
		
		'Set commweb2 = CreateObject("ADODB.Command")	
		'commweb2.ActiveConnection = Application("conweb2")

	dim myUrl
		myUrl = Request.ServerVariables("url")
		myUrl = left(myUrl, instr(2,myUrl,"/"))

		if right(myUrl,1) <> "/" then myUrl = myUrl & "/"

		Session("web1url")="http://" & Request.ServerVariables("HTTP_HOST") & myUrl
		



	function check_session_valid()
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	end function

	function CheckGame(dealer_id)
	dim rs
		CheckGame="CLOSE"
		if clng(dealer_id)>0 then
			if not CheckExistTable("tb_open_game","dealer_id=" & dealer_id & " And game_active='A'") then
				Dim old_game_type
				old_game_type=GetValueFromTable("tb_open_game", "game_type", "dealer_id=" & dealer_id & " And game_active='D'  order by game_id desc ")
				if old_game_type="" then
					old_game_type=1
				end if 
				strSql = "Insert Into tb_open_game(dealer_id, game_type, set_date, game_status,	game_active) values " _
					& "("&dealer_id&", '" & old_game_type & "', GetDate(), 1,'A')"
				comm.CommandText = strSql
				comm.CommandType = adCmdText
				comm.Execute
			end if
			strSql = "select * from tb_open_game where dealer_id=" & dealer_id & " And game_active='A'"
			Session("gameid")=0
			set rs = Server.CreateObject("ADODB.Recordset")	
			rs.open strSql,conn
			if not rs.eof then
				Session("gameid")=rs("game_id")
				if rs("game_status")=1 then 
					CheckGame="OPEN"
				elseif rs("game_status")=2 then 
					CheckGame="KEY"
				else
					CheckGame="CLOSE"
				end if
			end if
			set rs = nothing
		end if

	end function

	function CheckOtherGame(dealer_id)
	dim rs
		CheckOtherGame=0
		if clng(Session("uid"))>0 then
			strSql = "select * from tb_open_game where dealer_id=" & dealer_id & " And game_active='A'"

			set rs = Server.CreateObject("ADODB.Recordset")	
			rs.open strSql,conn
			if not rs.eof then
				CheckOtherGame=rs("game_id")			
			end if
			set rs = nothing
		end if
	end function

	function GetPlayTypeName(PlayType)
		Select Case cstr(PlayType)
		case "1"
			GetPlayTypeName = "2 ตัวบน"
		case "2"
			GetPlayTypeName = "3 ตัวบน"
		case "3"
			GetPlayTypeName = "3 ตัวโต๊ด"
		case "4"
			GetPlayTypeName = "2 ตัวโต๊ด"
		case "5"
			GetPlayTypeName = "วิ่งบน"
		case "6"
			GetPlayTypeName = "วิ่งล่าง"
		case "7"
			GetPlayTypeName = "2 ตัวล่าง"
		case "8"
			GetPlayTypeName = "3 ตัวล่าง"
		case else
			GetPlayTypeName = ""
		end select
	end function

	function GetReceiveStatus(RecStatus)
		Select Case cstr(RecStatus)
		case "0"
			GetReceiveStatus = "กำลังคีย์"
		case "1"
			GetReceiveStatus = "รอรับ"
		case "2"
			GetReceiveStatus = "รับหมด"
		case "3"
			GetReceiveStatus = "รับบางส่วน"
		case "4"
			GetReceiveStatus = "ไม่รับ"
		case else
			GetReceiveStatus = ""
		end select
	end function


	Sub ShowMenu1(usertype)
	dim stUser
	stUser="Disabled"
	if Session("uid") <> "" then stUser=""
%>

	<TABLE width="85%">
		<TR>
		<TD class=text_blue_big bgColor=#FFFF00 width=13%>
		<table class=text_blue_big bgColor=#FFFFFF width="100%"><tr><td style="font-size:16">
		<strong>&nbsp;
		<%
		if usertype="K" Then
			Dim objRS , objDB , SQL,uname
			set objDB=Server.CreateObject("ADODB.Connection")       
			objDB.Open Application("constr")
			Set objRS =Server.CreateObject("ADODB.Recordset")
			SQL="select login_id, user_name from sc_user where [user_id]=" & Session("did")	
			set objRS=objDB.Execute(SQL)
			if not objRs.EOF Then
				uname=objRS("login_id") & " " & objRS("user_name")
			End if
			response.write uname 
		%>
		<% Else %>
		<%=Session("logid")%>&nbsp;<%=Session("uname")%>
		<% End If %>
		&nbsp;</strong></TD>
		</td>

        </tr>

		<tr>
		<TD align="center" class="text_light" nowrap>		
		<strong><i>		
		 <div id="tic">
		<p>CutLotto รุ่น <%=webver%></p>				
		<p>
		<%=Date()%>
		</p>
		<p><%=Session("limit_play") %></p>
		</div></i></strong>
		</TD>
		</tr>

        </table>
		<TD width="70%">
            
<%
		if usertype="A" then
%>
			<input id="but1" type='button' value='ผู้ใช้ระบบ(เจ้ามือ)' class='inputB' onClick="gotoPage('mt_listdealer.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but2" type='button' value='ตั้งเวลา Refresh' class='inputB' onClick="gotoPage('admin_refresh.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but17" type='button' value='Upload Help' class='inputB' onClick="gotoPage('admin_upload.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but18" type='button' value='Link เจ้ามือ' class='inputB' onClick="gotoPage('link_web.asp?is_dealer=1'),chgcolor(this)" <%=stUser%>>
			<input id="but19" type='button' value='Link <%=str_player%>' class='inputB' onClick="gotoPage('link_web.asp?is_dealer=0'),chgcolor(this)" <%=stUser%>>
			<input id="but28" type='button' value='ล้างเครดิต' class='inputB' onClick="gotoPage('admin_cls_credit.asp?is_dealer=0'),chgcolor(this)" <%=stUser%>>
            <input id="but33" type='button' value='ข่าวสาร+ค่าเช่า' class='inputB' onClick="gotoPage('message.asp'),chgcolor(this)" <%=stUser%> >
<%
		elseif usertype="D" then
%>
			<input id="but3" type='button' value='หน้าแรก' class='inputB' onClick="gotoPage('firstpage_dealer.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but4" type='button' value='ดูโพย' class='inputB'	onClick="gotoPage('dealer_ticket.asp'),chgcolor(this)" <%=stUser%> >
			<input id="but5" type='button' value='แทงโพย' class='inputB' onClick="gotoPage('key_dealer_play.asp'),chgcolor(this)" <%=stUser%> >
<!-- 			<input id="but6" type='button' value='ตัดเลข' class='inputB' onClick="gotoPage('dealer_tudroum.asp'),chgcolor(this)" <%=stUser%>
	 -->
			<input id="but7" type='button' value='เลขคืน' class='inputB' 	onClick="gotoPage('dealer_send_back.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but8" type='button' value='ยอดแทงออก' class='inputB' 	onClick="gotoPage('dealer_play_out.asp'),chgcolor(this)" <%=stUser%>>

			<input id="but20" type='button' value='Link Web' class='inputB' onClick="gotoPage('shw_link_web.asp?is_dealer=1'),chgcolor(this)" <%=stUser%>	>

			<input id="but27" type='button' value='ตัดเลข' class='inputB' onClick="gotoPage('dealer_tudroum.asp'),chgcolor(this)" <%=stUser%> >
			<input id="but24" type='button' value='สู้บน' class='inputB' onClick="showsendto('U'),chgcolor(this)" <%=stUser%> >
			<input id="but25" type='button' value='สู้ล่าง' class='inputB'  onClick="showsendto('D'),chgcolor(this)" <%=stUser%> >
			<input id="but26" type='button' value='แทงเลขออก' class='inputB' onClick="gotoPage('dealer_tudroum.asp?act=out'),chgcolor(this)" <%=stUser%> >
			<input id="but29" type='button' value='ตั้งเอเย่นต์' class='inputB' onClick="gotoPage('price_player_config.asp'),chgcolor(this)" <%=stUser%> >
<!--		<input id="but30" type='button' value='เพิ่มเครดิต ' class='button_green' onMouseOver="changeStyle(this,'inputBOver');" 
			onMouseOut="changeStyle(this,'button_green');" onClick="gotoPage('credit_increase_by_loginno.asp'),chgcolor(this)" <%=stUser%>/>
			<input id="but31" type='button' value='รายงานเครดิต ' class='button_green' onMouseOver="changeStyle(this,'inputBOver');" 
			onMouseOut="changeStyle(this,'button_green');" onClick="gotoPage('credit_report.asp'),chgcolor(this)" <%=stUser%>/>-->
            <input id="but32" type='button' value='แจ้งชำระเงิน' class='inputB' onClick="gotoPage('transfer_sent.asp'),chgcolor(this)" <%=stUser%> >
            <input id="but35" type='button' value='ข่าวสาร / ลูกค้า' class='inputB' onClick="gotoPage('firstpage_player.asp'), chgcolor(this)" <%=stUser%> >
<!--		<input type='button' value='คิวโพยเข้า' class='inputB' onClick="gotoPage('dealer_receive_ticket.asp')" <%=stUser%>>
 			<input type='button' value='ตั้งคนแทง' class='inputB' onClick="gotoPage('mt_listdealer.asp')" <%=stUser%>>
			<input type='button' value='ป้ายประกาศ' class='inputB' onClick="gotoPage('mt_alert.asp')" <%=stUser%>>
			<input type='button' value='เลขออกตรวจ' class='inputB' onClick="gotoPage('dealer_check_number.asp')" <%=stUser%>>
			<input type='button' value='บันทึก' class='inputB' onClick="gotoPage('underconstruction.asp')" <%=stUser%>>
			<input type='button' value='ตั้งค่า' class='inputB' onClick="gotoPage('underconstruction.asp')" <%=stUser%>>
 --><%
		elseif usertype="P" then
%>
<!-- 			<input type='button' value='หน้าแรก' class='inputB' onClick="gotoPage('underconstruction.asp')" <%=stUser%>> -->
			<input id="but9" type='button' value='หน้าแรก' class='inputB' onClick="gotoPage('firstpage_player.asp'),chgcolor(this)" <%=stUser%> >
			<input id="but10" type='button' value='ดูโพย' class='inputB' onClick="gotoPage('view_player.asp'),chgcolor(this)" <%=stUser%> >
			<input id="but11" type='button' value='แทงโพย' class='inputB' onClick="gotoPage('key_player.asp'),chgcolor(this)" <%=stUser%> >
			<input id="but12" type='button' value='เลขคืน' class='inputB' onClick="gotoPage('ret_number.asp'),chgcolor(this)" <%=stUser%>	>

			<input id="but13" type='button' value='ดูยอดเงิน' class='inputB' onClick="gotoPage('amt_player.asp?show_type=1'),chgcolor(this)" <%=stUser%>	>

			<!--<input id="but23" type='button' value='สรุปยอดใบ' class='inputB' onClick="chgcolor(this),click_player('<%=Session("uid")%>'); " <%=stUser%> > -->
			<input id="but23" type='button' value='สรุปยอดใบ' class='inputB' onClick="gotoPage('cntTicketPlayerSelect.asp?player_id=<%=Session("uid")%>'),chgcolor(this)" <%=stUser%> >

			<%
			If Len(Trim(Session("logid")))<8 then
			%>
			<input id="but24" type='button' value='สมาชิก member' class='inputB' 	onClick="gotoPage('price_player_config_Level2.asp'),chgcolor(this); " <%=stUser%> 				>
			<input id="but25" type='button' value='ดูยอดเงินลูกค้า' class='inputB' onClick="gotoPage('amt_player.asp?show_type=2'),chgcolor(this); " <%=stUser%>				>
			<!-- onMouseOver="changeStyle(this,'inputB_over')"
			onMouseOut="changeStyle(this,'inputB')"  -->
			<%
			End If 
			%>
			<script language="javascript">
				function click_player(player_id){					
					var ParmA = ""; //document.form1.proj_code.value;
					var ParmB = "";
					var ParmC = '';
					var MyArgs = new Array(ParmA, ParmB, ParmC);

					MyArgs=window.showModalDialog('cntTicketPlayerID.asp?player_id='+player_id, '', 'dialogTop:'+200+'px;dialogLeft:'+0+'px;dialogHeight:500px;dialogWidth:1000px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');
					if (MyArgs == null)
					{
					//	window.alert(
					//	  "Nothing returned from child. No changes made to input boxes")
					}
					else
					{
						//document.form1.proj_code.value=MyArgs[0].toString();
					}
				
				}
			</script>

			<input id="but14" type='button' value='เปลี่ยน Password' class='inputB'
			style="width:104px;" onClick="gotoPage('key_chgpass.asp'),chgcolor(this)" <%=stUser%>>
			<!--<input id="but15" type='button' value='เปลี่ยนรหัสดูยอดเงิน' class='inputB' style="width:110;" onClick="gotoPage('key_chgsumpass.asp'),chgcolor(this)" <%=stUser%>> -->
			<input id="but21" type='button' value='Link Web' class='inputB' onClick="gotoPage('shw_link_web.asp?is_dealer=0'),chgcolor(this)" <%=stUser%>>
<%
		elseif usertype="K" then
%>
<!-- 			<input type='button' value='หน้าแรก' class='inputB' onClick="gotoPage('underconstruction.asp')" <%=stUser%>> -->
			<input id="but16" type='button' value='แทงโพย' class='inputB' onClick="gotoPage('key_dealer_play.asp'),chgcolor(this)" <%=stUser%>>
			<input id="but4" type='button' value='ดูโพย' class='inputB' onClick="gotoPage('dealer_ticket.asp'),chgcolor(this)" <%=stUser%>>
			<!--
			<input id="but23" type='button' value='แจ้งเลขเต็มอัตโนมัติ' class='inputB' onClick="gotoPage('frmLimitMoney.asp?dealer_id=<%=Session("uid") %>'),chgcolor(this)" <%=stUser%>> -->
			<input id="but22" type='button' value='Link Web' class='inputB' onClick="gotoPage('shw_link_web.asp?is_dealer=0'),chgcolor(this)" <%=stUser%>>
<%
		end if
%>
			<input type='button' value='ออก' class='inputB' onClick="gotoPage('logout.asp');self.close()">

	<%	
if usertype="D" And False then
	if Session("stoprefresh")="1" then	%>

				<input type=button name=cmdrefresh value="Refresh อัตโนมัติ" class=inputB onClick="ClickRefresh('firstpage_dealer.asp','0')">

	<%	else	%>
				<input type=button name=cmdrefresh value="หยุด Refresh อัตโนมัติ" class=inputB onClick="ClickRefresh('firstpage_dealer.asp','1')">

	<%	end if	
end if
%>
<!--        <tr>
		
		<TD align="right" class="text_light" nowrap>
        <strong><span id="theTime"></span></strong></td>	

        </tr>-->
<!--        		<TD align="right" class="text_light" nowrap>
        <strong><span id="theTime"></span></strong></td>	
		</TD>	-->

		</TR>
	</TABLE>	
<script type="text/javascript">
<!--
  initialiseList("tic");
//-->
</script>
<script language="JavaScript" type="text/javascript">

function sivamtime() {
  now=new Date();
  hour=now.getHours();
  min=now.getMinutes();
  sec=now.getSeconds();

if (min<=9) { min="0"+min; }
if (sec<=9) { sec="0"+sec; }
if (hour>12) { hour=hour-12; add="pm"; }
else { hour=hour; add="am"; }
if (hour==12) { add="pm"; }

time = ((hour<=9) ? "0"+hour : hour) + ":" + min + ":" + sec + " " + add;

if (document.getElementById) { document.all.theTime.innerHTML = time; }
else if (document.layers) {
 document.layers.theTime.document.write(time);
 document.layers.theTime.document.close(); }

setTimeout("sivamtime()", 1000);
}
window.onload = sivamtime;

// -->

</script>
<%
End sub

Sub ShowHeader(usertype)
	dim stUser
	stUser="Disabled"
	if Session("uid") <> "" then stUser=""
%>
	<div class="kt-header__topbar-item kt-header__topbar-item--user">
		<div class="kt-header__topbar-wrapper" data-toggle="dropdown" data-offset="0px,0px">

			<!--use "kt-rounded" class for rounded avatar style-->
			<div class="kt-header__topbar-user kt-rounded-">
				<span class="kt-header__topbar-welcome kt-hidden-mobile">สวัสดี,</span>
				<span class="kt-header__topbar-username kt-hidden-mobile">
					<%
					if usertype="K" Then
						Dim objRS , objDB , SQL,uname
						set objDB=Server.CreateObject("ADODB.Connection")       
						objDB.Open Application("constr")
						Set objRS =Server.CreateObject("ADODB.Recordset")
						SQL="select login_id, user_name from sc_user where [user_id]=" & Session("did")	
						set objRS=objDB.Execute(SQL)
						if not objRs.EOF Then
							uname=objRS("login_id") & " " & objRS("user_name")
						End if
						response.write uname 
					%>
					<% Else %>
					<%=Session("logid")%>&nbsp;<%=Session("uname")%>
					<% End If %>
				</span>
				<img alt="Pic" src="assets/media/users/300_25.jpg" class="kt-rounded-" />

				<!--use below badge element instead the user avatar to display username's first letter(remove kt-hidden class to display it) -->
				<span class="kt-badge kt-badge--username kt-badge--lg kt-badge--brand kt-hidden kt-badge--bold">S</span>
			</div>
		</div>
		<div class="dropdown-menu dropdown-menu-fit dropdown-menu-right dropdown-menu-anim dropdown-menu-top-unround dropdown-menu-sm">
			<div class="kt-user-card kt-margin-b-40 kt-margin-b-30-tablet-and-mobile" style="background-image: url(assets/media/misc/head_bg_sm.jpg)">
				<div class="kt-user-card__wrapper">
					<div class="kt-user-card__pic">

						<!--use "kt-rounded" class for rounded avatar style-->
						<img alt="Pic" src="assets/media/users/300_21.jpg" class="kt-rounded-" />
					</div>
					<div class="kt-user-card__details">
						<div class="kt-user-card__name">
							<%=Session("logid")%>&nbsp;<%=Session("uname")%>
						</div>
						<div class="kt-user-card__position">
							<p>Credit <%=Session("limit_play") %></p>
						</div>
					</div>
				</div>
			</div>
			<ul class="kt-nav kt-margin-b-10">
				<li class="kt-nav__item">
					<a href="custom/profile/personal-information.html" class="kt-nav__link">
						<span class="kt-nav__link-icon"><i class="flaticon2-calendar-3"></i></span>
						<span class="kt-nav__link-text">เปลียนรหัสผ่าน</span>
					</a>
				</li>
				<li class="kt-nav__separator kt-nav__separator--fit"></li>
				<li class="kt-nav__custom kt-space-between">
					<a href="custom/login/login-v1.html" target="_blank" class="btn btn-label-brand btn-upper btn-sm btn-bold">ออกจากระบบ</a>
				</li>
			</ul>
		</div>
		
	</div>

<%
End Sub

Sub ShowMenu2(usertype)
	dim stUser
	stUser="Disabled"
	if Session("uid") <> "" then stUser=""
%>
	<div id="kt_aside_menu" class="kt-aside-menu " data-ktmenu-vertical="1" data-ktmenu-scroll="1" data-ktmenu-dropdown-timeout="500">
		<ul class="kt-menu__nav ">
			<% if usertype="A" then %>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="mt_listdealer.asp" onclick= "gotoPage('mt_listdealer.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-layers"></i>
						<span class="kt-menu__link-text">หน้าแรก</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-settings"></i>
						<span class="kt-menu__link-text">ตั้งค่า</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>
					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">

							<li class="kt-menu__item " aria-haspopup="true">
								<a href="mt_listdealer.asp" onclick= "gotoPage('mt_listdealer.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ผู้ใช้ระบบ(เจ้ามือ)</span><span class="kt-menu__link-badge"></a>
							</li>
							
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="admin_refresh.asp" onclick= "gotoPage('admin_refresh.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งเวลา Refresh</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="admin_upload.asp" onclick= "gotoPage('admin_upload.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">Upload Help</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="link_web.asp?is_dealer=1" onclick= "gotoPage('link_web.asp?is_dealer=1')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">Link เจ้ามือ</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="link_web.asp?is_dealer=0" onclick= "gotoPage('link_web.asp?is_dealer=0')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">Link เอเย่นต์</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="admin_cls_credit.asp?is_dealer=0" onclick= "gotoPage('admin_cls_credit.asp?is_dealer=0')" class="kt-menu__link ">
								<span class="kt-menu__link-text">ล้างเครดิต</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="mt_system_alert" onclick= "gotoPage('mt_system_alert')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ประกาศระบบ</span><span class="kt-menu__link-badge"></a>
							</li>

						</ul>
					</div>
				</li>
		
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="mt_listdealer_AddMoney.asp" onclick= "gotoPage('mt_listdealer_AddMoney.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-talk"></i>
						<span class="kt-menu__link-text">เติมเงินดีลเลอร์</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="mt_listdealer_Price.asp" onclick= "gotoPage('mt_listdealer_Price.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-bell"></i>
						<span class="kt-menu__link-text">รายงานค่าเช่าเจ้ามือ</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="logout.asp" onclick= "gotoPage('logout.asp');self.close()" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-logout"></i>
						<span class="kt-menu__link-text">ออกจากระบบ</span></a>
				</li>
			<% elseif usertype = "F" or usertype="D" then %>

				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true">
					<a href="firstpage_dealer.asp" onclick="gotoPage('firstpage_dealer.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-layers"></i>
						<span class="kt-menu__link-text">หน้าแรก</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-settings"></i>
						<span class="kt-menu__link-text">ตั้งค่า</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href='price_player_config_dealer.asp?dealer_id=<%=Session("uid")%>&game_type=1' onclick= 'gotoPage('price_player_config_dealer.asp?dealer_id=<%=Session("uid")%>&game_type=1')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งค่าราคากลาง</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_web_config.asp" onclick= "gotoPage('dealer_web_config.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งเว็บแทงออก</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="price_player_config.asp" onclick= "gotoPage('price_player_config.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งเอเจ้น</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="user_key.asp" onclick= "gotoPage('user_key.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งคนคีย์</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href='frmDanger.asp?dealer_id=<%=Session("uid") %>'' onclick= "gotoPage('frmDanger.asp?dealer_id=<%=Session("uid") %>')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งเลขอันตราย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href='frmLimitMoney.asp?dealer_id=<%=Session("uid") %>' onclick= "gotoPage('frmLimitMoney.asp?dealer_id=<%=Session("uid") %>')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งเลขเต็มอัตโนมัติ</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href='link_web.asp?is_dealer=1' onclick= "gotoPage('link_web.asp?is_dealer=1')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ลิ้งค์เจ้ามือ</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="admin_cls_credit.asp?is_dealer=0" onclick= "gotoPage('admin_cls_credit.asp?is_dealer=0')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ล้างเครดิต</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="mt_alert.asp" onclick= "gotoPage('mt_alert.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตั้งประกาศ</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-notepad"></i>
						<span class="kt-menu__link-text">โพย</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_ticket.asp" onclick= "gotoPage('dealer_ticket.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ดูโพย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="key_dealer_play.asp" onclick= "gotoPage('key_dealer_play.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">แทงโพย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_send_back.asp" onclick= "gotoPage('dealer_send_back.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">เลขคืน</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_play_out.asp" onclick= "gotoPage('dealer_play_out.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ยอดแทงออก</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-percentage"></i>
						<span class="kt-menu__link-text">ระบบสู้</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>
					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_fight_up.asp?act=cal"  class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">สู้บน</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_fight_down.asp?act=cal"  class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">สู้ล่าง</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_tudroum.asp?act=out" onclick= "gotoPage('dealer_tudroum.asp?act=out')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">แทงเลขออก</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_tudroum.asp" onclick= "gotoPage('dealer_tudroum.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ตัดเลข</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-line-chart"></i>
						<span class="kt-menu__link-text">สรุปยอด/รายงาน</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_check_number.asp" onclick= "gotoPage('dealer_check_number.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">เลขออก/ตรวจผล</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="cntTicketPlayer.asp" onclick= "gotoPage('cntTicketPlayer.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ยอดสรุปเป็นใบ</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-poll-symbol"></i>
						<span class="kt-menu__link-text">ข้อมูล</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_save_data.asp"  class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">เก็บข้อมูล</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_open_old.asp" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ดูข้อมูลที่เก็บ</span><span class="kt-menu__link-badge"></a>
							</li>
								<li class="kt-menu__item " aria-haspopup="true">
								<a href="admin_cls_key.asp" onclick= "gotoPage('admin_cls_key.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ล้างเลข</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="firstpage_announce.asp" onclick= "gotoPage('firstpage_announce.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-talk"></i>
						<span class="kt-menu__link-text">ป้ายประกาศ</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="cntPricePlayer.asp" onclick= "gotoPage('cntPricePlayer.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-bell"></i>
						<span class="kt-menu__link-text">แจ้งชำระเงิน</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:void(0)" onclick= "download_manual();" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-sms"></i>
						<span class="kt-menu__link-text">วิธีกดแทงโพย</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="key_chgpass.asp" onclick= "gotoPage('key_chgpass.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-user"></i>
						<span class="kt-menu__link-text">เปลียนรหัสผ่าน</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="shw_link_web.asp?is_dealer=1" onclick= "gotoPage('shw_link_web.asp?is_dealer=1')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-paperplane"></i>
						<span class="kt-menu__link-text">ลิงค์เว็บ</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="logout.asp" onclick= "gotoPage('logout.asp');self.close()" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-logout"></i>
						<span class="kt-menu__link-text">ออกจากระบบ</span></a>
				</li>

			<% elseif usertype="P" then %>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="firstpage_announce.asp" onclick= "gotoPage('firstpage_announce.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-layers"></i>
						<span class="kt-menu__link-text">หน้าแรก</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-settings"></i>
						<span class="kt-menu__link-text">ตั้งค่า</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="javascript:void(0)" onclick= "gotoPage('price_player_config_Level2.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">สมาชิก Member</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-notepad"></i>
						<span class="kt-menu__link-text">โพย</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="view_player.asp" onclick= "gotoPage('view_player.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ดูโพย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="key_player.asp" onclick= "gotoPage('key_player.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">แทงโพย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="ret_number.asp" onclick= "gotoPage('ret_number.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">เลขคืน</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>


				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-line-chart"></i>
						<span class="kt-menu__link-text">สรุปยอด/รายงาน</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>
					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="amt_player.asp?show_type=1" onclick= "gotoPage('amt_player.asp?show_type=1')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ดูยอดเงิน</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="cntTicketPlayerSelect.asp?player_id=<%=Session("uid")%>" onclick= "gotoPage('cntTicketPlayerSelect.asp?player_id=<%=Session("uid")%>')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">สรุปยอดใบ</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>

				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="amt_player.asp?show_type=2" onclick= "gotoPage('amt_player.asp?show_type=2')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-talk"></i>
						<span class="kt-menu__link-text">ดูยอดเงินลูกค้า</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="key_chgpass.asp" onclick= "gotoPage('key_chgpass.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-user"></i>
						<span class="kt-menu__link-text">เปลียนรหัสผ่าน</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="shw_link_web.asp?is_dealer=1" onclick= "gotoPage('shw_link_web.asp?is_dealer=1')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-paperplane"></i>
						<span class="kt-menu__link-text">ลิงค์เว็บ</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="logout.asp" onclick= "gotoPage('logout.asp');self.close()" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-logout"></i>
						<span class="kt-menu__link-text">ออกจากระบบ</span></a>
				</li>

			<% elseif usertype="K" then %>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="firstpage_announce.asp" onclick= "gotoPage('firstpage_announce.asp')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-layers"></i>
						<span class="kt-menu__link-text">หน้าแรก</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="javascript:;" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-notepad"></i>
						<span class="kt-menu__link-text">โพย</span><i class="kt-menu__ver-arrow la la-angle-right"></i>
					</a>

					<div class="kt-menu__submenu "><span class="kt-menu__arrow"></span>
						<ul class="kt-menu__subnav">
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="dealer_ticket.asp" onclick= "gotoPage('dealer_ticket.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">ดูโพย</span><span class="kt-menu__link-badge"></a>
							</li>
							<li class="kt-menu__item " aria-haspopup="true">
								<a href="key_dealer_play.asp" onclick= "gotoPage('key_dealer_play.asp')" class="kt-menu__link ">
								<i class="kt-menu__link-bullet kt-menu__link-bullet--line"><span></span></i>
								<span class="kt-menu__link-text">แทงโพย</span><span class="kt-menu__link-badge"></a>
							</li>
						</ul>
					</div>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="shw_link_web.asp?is_dealer=1" onclick= "gotoPage('shw_link_web.asp?is_dealer=1')" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon2-paperplane"></i>
						<span class="kt-menu__link-text">ลิงค์เว็บ</span></a>
				</li>
				<li class="kt-menu__item  kt-menu__item--submenu kt-menu__item--open kt-menu__item--here" aria-haspopup="true" data-ktmenu-submenu-toggle="hover">
					<a href="logout.asp" onclick= "gotoPage('logout.asp');self.close()" class="kt-menu__link kt-menu__toggle"><i class="kt-menu__link-icon flaticon-logout"></i>
						<span class="kt-menu__link-text">ออกจากระบบ</span></a>
				</li>

			<% end if %>
		</ul>
	</div>



<script >


function download_manual() {
    window.open("key.html", null, 'left=400, top=0, height=600, width= 700, status=yes, resizable= yes, scrollbars= no, toolbar= yes,location= no, menubar= yes')
}
function opensave() {
    window.open("dealer_save_data.asp", "_blank", "top=150,left=150,height=350,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
}
function openold() {
    window.open("dealer_open_old.asp", "_blank", "top=150,left=150,height=350,width=450,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
}
function cleargame(chkover) {

    if (confirm("คุณต้องการพิมพ์ หรือ เก็บโพยไว้หรือไม่ ?")) {
        opensave();
    } else {

    }
   
}

</script>

<%
End sub

sub ShowMessage(msg)
	Response.write "<META http-equiv='Content-Type' content='text/html; charset=windows-874'>"
	Response.write "<LINK href='code.css' type=text/css rel=stylesheet>"
	Response.write "<br><br>"
	Response.write "<table align=center class=table_blue><tr height=40 class=tr_head_info>"
	Response.write "<td align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & msg & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"
	Response.write "</tr></table>"

end sub

function GenMaxID(byval TableName, byval FieldName, byval Condition)
dim strSql
dim objConn
dim rs
dim mID
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "SELECT Max(" & FieldName & ") as MaxID FROM " & TableName
	if trim(Condition)<>"" then
		strSql=strSql & " Where " & Condition
	end if
	rs.open strSql,objConn
	mID=1
	if not rs.eof then
		if not isnull(rs("MaxID")) then
			mID = rs("MaxID") + 1
		end if
	end if		
	set rs = nothing
	set objConn = nothing			
	GenMaxID = mID
end Function

function GetSumValue(byval TableName, byval FieldName, byval Condition)
dim strSql
dim objConn
dim rs
dim sumval
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "SELECT sum(" & FieldName & ") as sumval FROM " & TableName
	if trim(Condition)<>"" then
		strSql=strSql & " Where " & Condition
	end if
	rs.open strSql,objConn
	sumval=0
	if not rs.eof then
		if not isnull(rs("sumval")) then
			sumval = rs("sumval") 
		end if
	end if		
	set rs = nothing
	set objConn = nothing			
	GetSumValue = sumval
end Function

function ShowTitle(lang,title_th,title_en)
	
	Response.Write "<TABLE WIDTH='100%' ALIGN='left' BORDER=0 CELLSPACING=0 CELLPADDING=0>"
	Response.Write "<TR><TD class=text_white align=left height=25 background=images/title_head.jpg>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size=3>" & ShowTextLang(lang,title_th,title_en) & "</font></TD></TR>"
	Response.Write "</TABLE><br><br>"
end function

function ShowBack()	
	Response.Write "<br><br>"
	Response.Write "<TABLE WIDTH='100%' ALIGN='left' BORDER=0 CELLSPACING=0 CELLPADDING=0>"
	Response.Write "<TR><TD class=text_white align=right><A href='JavaScript:history.back(1)'>ย้อนกลับ>></a></TD></TR>"
	Response.Write "</TABLE><br><br>"
end function


function FormatDateAsOf(lang, mDay, mMonth, mYear)
		if lang = 1 then
			FormatDateAsOf = "ข้อมูลล่าสุด " & mDay & " " & getMonthName(lang,mMonth) & " " & getYearLang(lang,mYear)
		else
			FormatDateAsOf = "as of " & mDay & " " & getMonthName(lang,mMonth) & " " & getYearLang(lang,mYear)
		end if
end function

function getYearLang(lang, mYear)
	if lang = 1 then
		if mYear < 2300 then mYear = mYear + 543
	else
		if mYear > 2300 then mYear = mYear - 543
	end if
	getYearLang = mYear
end function

function getMonthName(lang, mMonth)
	if lang=1 then
		select case mMonth
		case 1
			getMonthName = "ม.ค."
		case 2
			getMonthName = "ก.พ."
		case 3
			getMonthName = "มี.ค."
		case 4
			getMonthName = "เม.ย."
		case 5
			getMonthName = "พ.ค."
		case 6
			getMonthName = "มิ.ย."
		case 7
			getMonthName = "ก.ค."
		case 8
			getMonthName = "ส.ค."
		case 9
			getMonthName = "ก.ย."
		case 10
			getMonthName = "ต.ค."
		case 11
			getMonthName = "พ.ย."
		case 12
			getMonthName = "ธ.ค."
		end select
	else
		select case mMonth
		case 1
			getMonthName = "Jan"
		case 2
			getMonthName = "Feb"
		case 3
			getMonthName = "Mar"
		case 4
			getMonthName = "Apr"
		case 5
			getMonthName = "May"
		case 6
			getMonthName = "Jun"
		case 7
			getMonthName = "July"
		case 8
			getMonthName = "Aug"
		case 9
			getMonthName = "Sep"
		case 10
			getMonthName = "Oct"
		case 11
			getMonthName = "Nov"
		case 12
			getMonthName = "Dec"
		end select
	end if
end function

function findFile(pathPicTmp,pathPic,tmpfile)
	dim r, arrinfofile
	dim ofs
	findFile = ""
	set ofs = createobject("scripting.filesystemobject")
	if ofs.FileExists(pathPicTmp&tmpfile) then
		set r = ofs.opentextfile(pathPicTmp&tmpfile,1,False)
		if err.number = 0 then
			if not r.atendofstream then
				arrinfofile = split(r.readline,"#")
			end if
			r.close
			arrinfofile(0)=trim(arrinfofile(0))
			if ofs.FileExists(pathPic&arrinfofile(0)) then
				'delete olf file if exist
				ofs.DeleteFile pathPic&arrinfofile(0)
			end if
			'arrinfofile(0) is a pic's name
			if len(trim(arrinfofile(0))) = 0 then
				arrinfofile(0) = ""
			end if
			

			'move file
			ofs.MoveFile pathPicTmp&arrinfofile(0),pathPic&arrinfofile(0) 

			'delete file
			ofs.DeleteFile pathPicTmp&tmpfile

			findFile = arrinfofile(0)
		end if
	end if
end function

sub deleteFile(pathPic,picName)
	dim ofs
	set ofs = createobject("scripting.filesystemobject")
	if ofs.FileExists(pathPic&picName) then
		ofs.DeleteFile pathPic&picName
	end if
end sub

sub ShowCmbYear(objName, chkY)
	dim cY, i, strS
	cY = 2548
	Response.Write "<Select Name="&objName&">"
	for i = cY to cY+10		
		strS=""
		if i=cY then strS = "Select"
		if i=cint(chkY) then strS= "Select"	
		Response.Write "<option value = '"&i&"'" & strS & ">" & i & "</option>"  
	next
	Response.write "</Select>"
end sub

function CheckExistTable(tablename, condition)
dim strSql
dim objConn
dim rs
	CheckExistTable = false
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select * From " & tablename & " Where "  & condition
'	showstr strsql
	rs.open strSql,objConn
	if not rs.eof then
		CheckExistTable = true
	end if
	rs.close
	set objConn = nothing

end function

function GetValueFromTable(tablename, fieldvalue, condition)
dim strSql
dim objConn
dim rs
	GetValueFromTable = ""
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select "&fieldvalue&" From " & tablename 
	if condition <> "" then
		strSql = strSql & " Where "  & condition
	end if

	rs.open strSql,objConn
	if not rs.eof then
		GetValueFromTable = rs(fieldvalue)
	end if
	rs.close
	set objConn = nothing
end function



function NumberWithZero(num, numformat)
dim i 
dim strnum
	strnum=""
	for i = 1 to numformat - len(num)
		strnum = strnum & "0"
	next 
	strnum = strnum & num
	NumberWithZero = strnum
end function

Function selected(var1,var2)
' ใช้กับคอนโทรล Select
	If cstr(var1) = cstr(var2) Then
		selected = " SELECTED"
	Else
		selected = ""
	End If
End Function

Function checked(var1,var2)
' ใช้กับคอนโทรล Checkbox, Radio
	If cstr(var1) = cstr(var2) Then
		checked = " CHECKED"
	Else
		checked = ""
	End If
End Function

function showupdown(ud)
	if cint(ud)=1 then
		showupdown="ล"
	elseif cint(ud) = 2 then
		showupdown="บ"
	elseif cint(ud) = 3 then
		showupdown="บ+ล"
	else
		showupdown=""
	end if
end function

sub ShowStr(strSql)
	Response.write strSql
	Response.End
end sub

function iif(chk , strTrue, strFalse)
	if chk then
		iif = strTrue
	else
		iif = strFalse
	end if
end function

Sub ShowTableCmb(tableName, fieldshow, fieldid, objName, oldValue, condition,BlankLine, width, myevent)
Dim objConn
Dim objRec
dim strSql, str
	'*** Open the database.	
	Set objConn = Server.CreateObject ("ADODB.Connection")
	Set objRec = Server.CreateObject ("ADODB.Recordset")
	objConn.Open Application("constr")	
	strSql = "Select "&fieldid&", Isnull("&fieldshow&", '') as "&fieldshow&" From "&tableName&""
	if condition <> "" then
		strSql = strSql & " Where " & condition
	end if
	strSql = strSql & " Order by " & fieldshow
'showstr strSql
'on error resume next
	objRec.Open strSql, objConn, 3,1
'if err <> 0 then showstr strSql
'on error goto 0
	Response.write "<Select Name='"&objName&"' style='width:"&width&"'  " & myevent & ">"
	if BlankLine then
		Response.write "<Option value=''>&nbsp;</Option>"
	end if
	do while not objRec.Eof
		str=""
		if cstr(oldValue)=cstr(objRec(fieldid)) then str="Selected"
		Response.write "<Option value='"&objRec(fieldid)&"' " & str &">"&objRec(fieldshow)&"</Option>"
		objRec.MoveNext
	loop
	Response.write "</Select>"
	objRec.close
	set objRec = Nothing
	set objConn = Nothing
End sub

Sub ShowListView(tableName, fieldshow, fieldid, objName, oldValue, condition,BlankLine, width, myevent)
Dim objConn
Dim objRec
dim strSql, str
	'*** Open the database.	
	Set objConn = Server.CreateObject ("ADODB.Connection")
	Set objRec = Server.CreateObject ("ADODB.Recordset")
	objConn.Open Application("constr")	
	strSql = "Select "&fieldid&", Isnull("&fieldshow&", '') as "&fieldshow&" From "&tableName&""
	if condition <> "" then
		strSql = strSql & " Where " & condition
	end if
	strSql = strSql & " Order by " & fieldshow
'showstr strSql
'on error resume next
	objRec.Open strSql, objConn, 3,1
'if err <> 0 then showstr strSql
'on error goto 0
	Response.write "<Select Name='"&objName&"' style='width:"&width&"'  " & myevent & " size=5>"
	if BlankLine then
		Response.write "<Option value=''>&nbsp;</Option>"
	end if
	do while not objRec.Eof
		str=""
		if cstr(oldValue)=cstr(objRec(fieldid)) then str="Selected"
		Response.write "<Option value='"&objRec(fieldid)&"' " & str &">"&objRec(fieldshow)&"</Option>"
		objRec.MoveNext
	loop
	Response.write "</Select>"
	objRec.close
	set objRec = Nothing
	set objConn = Nothing
End sub

  %>
<script language="javascript">
	function chgcolor(obj){
		var id, oth_button,i
		for (i=1; i<=31 ; i++){
			id="but"+i
			oth_button= document.getElementById(  id )	
			if (oth_button != null ){
				oth_button.className="inputB"
			}
}

		but3.className = "inputB"
		but4.className = "inputB"
		but5.className = "inputB"
		but7.className = "inputB"
		but8.className = "inputB"
		but20.className = "inputB"
		but21.className = "inputB"
		but22.className = "inputB"
		but27.className = "inputB"
		but24.className = "inputB"
		but25.className = "inputB"
		but26.className = "inputB"
		but29.className = "inputB"
		but32.className = "inputB"
		but35.className = "inputB"

		obj.className="input_yellow"
	}

</script>

<%
Sub PrintPrice(dealer_id, player_id, game_id, show_credit, dealer_view)

	If player_id="" Then Exit Sub 
	Dim objRS , objDB , SQL, login_id, i
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim game_type
	'-- แสดงก็ต่อเมื่อ เจ้า กำหนดให้แสดง ราคา ส่วนลด
	SQL="select * from sc_user where user_id=" & dealer_id  & " and show_price_player=1 "
	Set objRS=objDB.Execute(SQL)
	If objRS.eof Then
		Exit sub
	End If 
	SQL="select game_type from tb_open_game where game_id=" & game_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		game_type=objRS("game_type")
	End If 
	SQL="select login_id from sc_user where user_id=" & player_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		login_id=objRS("login_id")
	End If 
	%>		
		<table width="250"  border="0" cellspacing="1" cellpadding="1" bgcolor="#E8E8E8">
				<%
				Dim bgcolor
				select case game_type
						case 1
							bgcolor="#CD9BFF"
						case 2
							bgcolor="#F3A44B"
						case 3
							bgcolor="#339900"					
				end select
				%>
				<tr>
					<td class="tdbody1" align="left" bgcolor="<%=bgcolor%>" colspan="3">
						<%=GetGameDesc(game_type)%>		
					</td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#B3FFD9" align="left">หมายเลข : <%=login_id%></td>
					<td class="tdbody1" bgcolor="#B3FFD9" align="left" colspan="2">ชื่อ : <%=GetPlayerName(player_id)%></td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#FFFFA4" align="center">ชนิด</td>
					<td class="tdbody1" bgcolor="#FFFFA4" align="center">จ่าย</td>
					<td class="tdbody1" bgcolor="#FFFFA4" align="center">ลด (%)</td>
				</tr>
				<%
					if	dealer_view="1" Then
						SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
					else
						If Len(Trim(login_id))>6 Then ' รายย่อย
							SQL="exec spGetPlayPrice_Level2 " & 	dealer_id & "," & player_id & "," & game_type
						Else 
							SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
						End If 
					End If 
'response.write SQL & " dealer_view=" & dealer_view & " Len(login_id) " & Len(Trim(login_id)) & " " & login_id & SQL
					set objRS=objDB.Execute(SQL)
					i=1
					while not objRS.eof
						if objRS("ref_det_desc")=" " then
				%>
					<tr>
						<td class="tdbody1" bgcolor="#FFFFA4" align="center">&nbsp;</td>
						<td bgcolor="#B3FFD9" align="center" >&nbsp;</td>
						<td bgcolor="#B3FFD9" align="center">&nbsp;</td>
					</tr>
				<%
						else
				%>
					<tr>
						<td class="tdbody1" bgcolor="#FFFFA4" align="center">&nbsp;<%=objRS("ref_det_desc")%></td>
						<td bgcolor="#B3FFD9" align="center" >
							<input type="text" name="p<%=objRS("play_type")%>"  value="<%=objRS("pay_amt")%>" class="input1" size="5" maxLength="3" id="idL<%=i%>" onKeyDown="chkEnter(this);" >
						</td>
						<td bgcolor="#B3FFD9" align="center">
							<input type="text" name="d<%=objRS("play_type")%>" value="<%=objRS("discount_amt")%>" class="input1" size="5" maxLength="2" 
							id="idR<%=i%>" onKeyDown="chkEnter(this);">
						</td>
					</tr>
				<%
						i=i+1
					end if
					objRS.MoveNext
					wend
				%>
			</table>		
			<table>
				
					<%
					if	dealer_view="1" Then
						SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	
					else
						If Len(login_id)>6 Then ' รายย่อย
							SQL="exec spJSelectPlayerDetLevel2 " & player_id & ", " & Session("gameid")	
						else
							SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	
						End If
'response.write SQL
					End if
					Set objRS=objDB.Execute(SQL)
					Dim limit_play
					Dim can_play,sum_play
					If Not objRS.eof Then						
						If CDbl(objRS("limit_play"))>0 then
							limit_play=objRS("limit_play") 
						Else
							limit_play=0
						End if
						If CDbl(objRS("sum_play"))>0 then
							sum_play=FormatNumber(objRS("sum_play"),0)
						Else
							sum_play=0
						End If								
						If ( CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")) ) > 0 Then
							can_play=(CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")))
						Else
							can_play=0
						End If
					End If 
					If show_credit="yes" then
					%>

				<tr class="head_black">
					<td>
						เครดิต :</td><td align="right"><%=FormatNumber(limit_play,0)%>
					</td>
				</tr>
				<tr class="head_black">
					<td>
						<% if can_play>1 then %>
						คงเหลือ : </td><td align="right"><%=FormatNumber(can_play,0)%>
						<% else %>
						คงเหลือ : </td><td align="right">0
						<% end if %>
					</td>
				</tr>
				<% End If %>
			</table>		
		<%
	set objRS=nothing
	set objDB=nothing
End Sub 
Function GetGameDesc(g)
	select case g
		case 1 
			GetGameDesc="รัฐบาล"
		case 2
			GetGameDesc="ออมสิน/ธกส"
		case 3
			GetGameDesc="ตั้งราคาอื่น"
		case else
			GetGameDesc=""
	end select
End Function
Function GetPlayerName(p)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_PlayerName " & p
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetPlayerName = objRS("player_name")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>



<%
function GetGameDesc(g)
	select case g
		case 1 
			GetGameDesc="รัฐบาล"
		case 2
			GetGameDesc="ออมสิน/ธกส"
		case 3
			GetGameDesc="ตั้งราคาอื่น"
		case else
			GetGameDesc=""
	end select
End Function
Function GetPlayerName(p)

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_PlayerName " & p
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetPlayerName = objRS("player_name")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetPlayerRecTicket(p)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGet_Rec_Ticket " & p
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetPlayerRecTicket = objRS("rec_ticket")
	end if
	set objRS=nothing
	set objDB=nothing
End Function

function FormatN(n,dot)
	if n=0 or n="" Or n=" " Or IsNull(n) then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
end function

function FormatN(n,dot)
	if n=0 or n="" Or n=" " Or IsNull(n) then
		FormatN=0
	else
		FormatN=formatnumber(n,dot)
	end if
end function


Function GetPlayer_Name( p )
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select login_id +' '+ [user_name] login_id_user_name from sc_user where [user_id]= " & p
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetPlayer_Name = objRS("login_id_user_name")
	else
		GetPlayer_Name=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function Getmessalert( p )

    Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")

	if p<>"0"  And p<>"" Then 
		if Session("utype")="A" then
		else
            if Session("utype")="P" then
				SQL = "Select top(1) * From tb_system_alert "
			elseif Session("utype")="D" Or Session("utype")="K" Or Session("utype")="F"  then
				SQL = "Select top(1) * From tb_system_alert "
			end if	
			set objRS=objDB.Execute(SQL)
	        if not objRs.EOF then
		        Getmessalert = objRS("message")
	        end if
		end if
	end if

End Function
Function Getmessalert_dealer( p )

    Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")

	if p<>"0"  And p<>"" Then 
		if Session("utype")="A" then
		else
            if Session("utype")="P" then
				SQL = "Select * From tb_dealer_alert Where dealer_id= " & Session("did") & " "
			elseif Session("utype")="D" Or Session("utype")="K" Or Session("utype")="F" then
				SQL = "Select * From tb_dealer_alert Where dealer_id= " & Session("uid") & " "
			end if	
			set objRS=objDB.Execute(SQL)
	        if not objRs.EOF then
		        Getmessalert_dealer = objRS("message")
	        end if
		end if
	end if

End Function

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

sub GenEmptyCol(cntCol, cntRow)
dim i
	for i = 1 to (5 - cntCol)
		response.write "<td width=100 class=box2>&nbsp;</td>"
	next 
end sub

Sub PrintPrices(dealer_id, player_id, game_id)

	Dim objRS , objDB , SQL, login_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim game_type
	SQL="select game_type from tb_open_game where game_id=" & game_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		game_type=objRS("game_type")
	End If 
	SQL="select login_id from sc_user where user_id=" & player_id
	Set objRS=objDB.Execute(SQL)
	If Not  objRS.eof Then
		login_id=objRS("login_id")
	End If 
	%>		
		<table width="300"  border="0" cellspacing="1" cellpadding="1" bgcolor="#E8E8E8">
				<%
				Dim bgcolor
				select case game_type
						case 1
							bgcolor="red"
						case 2
							bgcolor="red"
						case 3
							bgcolor="red"					
				end select
				%>
				<tr>
					<td class="tdbody1" align="left" bgcolor="<%=bgcolor%>" colspan="3">
						<%=GetGameDesc(game_type)%>		
					</td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#ff9999" align="left">หมายเลข : <%=login_id%></td>
					<td class="tdbody1" bgcolor="#ff9999" align="left" colspan="2">ชื่อ : <%=GetPlayerName(player_id)%></td>
				</tr>
				<tr>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">ชนิด</td>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">จ่าย</td>
					<td class="tdbody1" bgcolor="#ffd8cc" align="center">ลด (%)</td>
				</tr>
				<%
					SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
					set objRS=objDB.Execute(SQL)
					i=1
					while not objRS.eof
						if objRS("ref_det_desc")=" " then
				%>
					<tr>
						<td class="tdbody1" bgcolor="#ffd8cc" align="center">&nbsp;</td>
						<td bgcolor="#ff9999" align="center" >&nbsp;</td>
						<td bgcolor="#ff9999" align="center">&nbsp;</td>
					</tr>
				<%
						else
				%>
					<tr>
						<td class="tdbody1" bgcolor="#ffd8cc" align="center">&nbsp;<%=objRS("ref_det_desc")%></td>
						<td bgcolor="#ff9999" align="center" >
							<input type="text" name="p<%=objRS("play_type")%>"  value="<%=objRS("pay_amt")%>" class="input1" size="5" maxLength="3" id="idL<%=i%>" onKeyDown="chkEnter(this);" >
						</td>
						<td bgcolor="#ff9999" align="center">
							<input type="text" name="d<%=objRS("play_type")%>" value="<%=objRS("discount_amt")%>" class="input1" size="5" maxLength="2" 
							id="idR<%=i%>" onKeyDown="chkEnter(this);">
						</td>
					</tr>
				<%
						i=i+1
					end if
					objRS.MoveNext
					wend
				%>
			</table>		
			<table>
				
					<%
					SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	
					Set objRS=objDB.Execute(SQL)
					Dim limit_play
					Dim can_play,sum_play
					If Not objRS.eof Then						
						If CDbl(objRS("limit_play"))>0 then
							limit_play=FormatNumber(objRS("limit_play"),0)
						Else
							limit_play=0
						End if
						If CDbl(objRS("sum_play"))>0 then
							sum_play=FormatNumber(objRS("sum_play"),0)
						Else
							sum_play=0
						End If								
						If ( CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")) ) > 0 Then
							can_play=FormatNumber(CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")),0)
						Else
							can_play=0
						End If
					End If 
					%>
				<tr class="head_black">
					<td>
						เครดิต :</td><td align="right"><%=FormatNumber(limit_play,0)%>
					</td>
				</tr>
				<tr class="head_black">
					<td>
						คงเหลือ : </td><td align="right"><%=FormatNumber(can_play,0)%>
					</td>
				</tr>
			</table>		
		<%
	set objRS=nothing
	set objDB=nothing
End Sub 

%>


