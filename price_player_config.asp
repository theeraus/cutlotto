<!--#include virtual="masterpage.asp"-->

<% Sub ContentPlaceHolder() %>

<script type="text/javascript">
function click_creditreport(){
	window.open("credit_report.asp","_self")
}
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
		div_id="det"+id;
		createXMLHttpRequest();
		var sName=id; //document.getElementById(id).value;
		xmlHttp.onreadystatechange=handelStateChange;
		xmlHttp.open("GET","shw_player.asp?modeshow=level2&user_id="+sName,true);
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

<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim parent_login_id, digit_len
		parent_login_id=Trim(Session("logid")) ' // login_id ของ คนแทง
		digit_len=Len(parent_login_id)
		Dim maxlength_login
		maxlength_login=3
		Select Case CInt(digit_len)
			Case 3
				maxlength_login=3  ' 6 ' เจ้ามือ ตั้งคนแทง
			Case Else
				maxlength_login=0
		End Select 
		'response.write parent_login_id  & " " & digit_len

		
		Dim objRS , objDB , SQL	
		Dim dealer_id, tmp_Color
		Dim pic , game_type
		Dim mode, edit_user_id
		Dim user_name, user_password, sum_password, old_remain, login_id, address_1
		Dim limit_play, refresh_time


		mode=Request("mode")
		edit_user_id=Request("edit_user_id")
		if edit_user_id="" then edit_user_id=0
	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		

		dealer_id=Session("uid")
		game_type=Request("game_type")

		If mode="edit_rec_dealer" Then
			SQL="update sc_user set rec_ticket_dealer=(rec_ticket_dealer+1) % 2 where user_id=" & Session("uid")
			set objRS=objDB.Execute(SQL)
			response.redirect "price_player_config.asp"
		End if


		Dim rec_ticket_dealer
		SQL="select * from sc_user where user_id=" & Session("uid")
		set objRS=objDB.Execute(SQL)
		If Not objRS.eof Then
			rec_ticket_dealer=objRS("rec_ticket_dealer")
		Else
			response.end
		End if
		'//เช็คยอด เอายอด ได้-เสีย มาแก้ไขที่ sc_user limit_play		 2009-06-07
		if mode="adjust_balance" Then
			Dim Client_IP
			Client_IP=Request.ServerVariables("REMOTE_ADDR") 
			SQL="exec spJCalcCredit " & dealer_id & ", " & Session("gameid") & ",'" & Client_IP & "'"
			objDB.Execute(SQL)	
'response.write SQL
			SQL=" update sc_user Set  game_id_adjust=chkgame_id  "
			SQL=SQL & " where user_id=" & dealer_id 
			set objRS=objDB.Execute(SQL)
			response.redirect "price_player_config.asp"
		End If 
		'//เช็คยอด เอายอด ได้-เสีย มาแก้ไขที่ sc_user limit_play		
		if mode="chg_game_type" then
			SQL="update tb_open_game set game_type=" & game_type & " where dealer_id=" & dealer_id & _
			" and game_active='A' "
			set objRS=objDB.Execute(SQL)
		end if
		if mode="edit" then ' กรณีที่ user click แก้ไขรายการ
			'response.write "edit" & edit_user_id
		end if
		if mode="edit_save" then ' กรณีที่ user click แก้ไขรายการ แล้วบันทึกข้อมูล
			Dim can_edit 
			can_edit="yes"
			user_name=Request("user_name")
			user_password=Request("user_password")
			sum_password=Request("sum_password")
			old_remain=0 ' Replace(Request("old_remain"),",","")
			login_id=parent_login_id & Trim(Request("login_id"))
			address_1=Request("address_1")
			limit_play=Request("limit_play")
			refresh_time=0 'Request("refresh_time")
			'//ห้ามแก้ไขแล้วให้มี user ซ้ำกัน jum 20080627
			SQL="select * from sc_user where user_type='P' and create_by=" & dealer_id & " and user_id<>'" & edit_user_id & "' and user_name='" & user_name & "'"
			set objRS=objDB.Execute(SQL)
			if not objRS.eof then
					Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มีชื่อนี้แล้ว !! " & user_name & "</font></span></center>"
					can_edit="no"
			End if
			SQL="select * from sc_user where user_type='P' and create_by=" & dealer_id & " and user_id<>'" & edit_user_id & "' and login_id='" & login_id & "'"
			set objRS=objDB.Execute(SQL)
			if not objRS.eof then
					Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มี หมายเลข นี้แล้ว !! " & login_id & "</font></span></center>"
					can_edit="no"
			end if

				
			If can_edit="yes" then
				SQL="select isnull(cnt_login,0) cnt_login,isnull(cnt_dealer,0) cnt_dealer from sc_user where user_id=" & edit_user_id

				Dim cnt_login, cnt_dealer
				set objRS=objDB.Execute(SQL)
				If Not objRS.eof Then
					cnt_login=objRS("cnt_login")
					cnt_dealer=objRS("cnt_dealer")
				End if

				SQL=" update sc_user set  "
				SQL=SQL & " login_id='" & login_id & "', "
				SQL=SQL & " [user_name]='" & user_name & "', "
				SQL=SQL & " user_password='" & user_password & "', "
				SQL=SQL & " sum_password='" & sum_password & "', "
				SQL=SQL & " old_remain=" & old_remain & " , "
				SQL=SQL & " address_1='" & address_1 & "', "
				SQL=SQL & "	 cnt_login =" & cnt_login & " , "
				SQL=SQL & " cnt_dealer =" & cnt_dealer & " , "
				'//SQL=SQL & " limit_play =" & limit_play & ", "
				SQL=SQL & " refresh_time =" & refresh_time & " "			
				SQL=SQL & " where [user_id]=" & edit_user_id 
				set objRS=objDB.Execute(SQL)
			End if
			response.redirect "price_player_config.asp"
		end if
		if mode="delete" then ' กรณีที่ user click ลบรายการ
			SQL="delete from tb_usercredit where  user_id=" & edit_user_id
			objDB.Execute(SQL)
			SQL="delete tb_usercredit from tb_usercredit a inner join sc_user b on a.user_id=b.user_id where create_by_player=" & edit_user_id		
			set objRS=objDB.Execute(SQL)
			SQL="delete from tb_usercredit_det where  user_id=" & edit_user_id
			objDB.Execute(SQL)
			SQL="delete tb_usercredit_det from tb_usercredit_det a inner join sc_user b on a.user_id=b.user_id where create_by_player=" & edit_user_id		
			set objRS=objDB.Execute(SQL)

			SQL="delete sc_user where create_by_player=" & edit_user_id		
			set objRS=objDB.Execute(SQL)
			SQL="delete sc_user where [user_id]=" & edit_user_id
			set objRS=objDB.Execute(SQL)
			SQL="delete from tb_price_player where player_id=" & edit_user_id
			objDB.Execute(SQL)
			
			SQL="delete from tb_price_player_level2 where create_by_player=" & edit_user_id
			objDB.Execute(SQL)
			SQL="delete sc_user where create_by_player=" & edit_user_id
			objDB.Execute(SQL)
			

			'response.redirect "price_player_config.asp"
		end if
		if mode="edit_status" then
			SQL="exec spEdit_status_by_user_id "  & edit_user_id
			set objRS=objDB.Execute(SQL)
response.redirect "price_player_config.asp"
		end If
		'เลือกเอง
		if mode="all_select" then
			SQL="update sc_user set rec_ticket_type=1 where create_by=" & dealer_id
			set objRS=objDB.Execute(SQL)
			SQL="update sc_user set rec_ticket_type=1 where user_id=" & dealer_id
			set objRS=objDB.Execute(SQL)
response.redirect "price_player_config.asp"
		end If
		'แดงทั้งหมด
		if mode="all_red" then
			SQL="update sc_user set rec_ticket_type=2 where create_by=" & dealer_id
			set objRS=objDB.Execute(SQL)
			SQL="update sc_user set rec_ticket_type=2 where user_id=" & dealer_id
			set objRS=objDB.Execute(SQL)
		end If
		' กดปุ่มเขียวทั้งหมด
		if mode="all_green" then
			SQL="update sc_user set rec_ticket_type=3 where create_by=" & dealer_id
			set objRS=objDB.Execute(SQL)
			SQL="update sc_user set rec_ticket_type=3 where user_id=" & dealer_id
			set objRS=objDB.Execute(SQL)
response.redirect "price_player_config.asp"
		end If
		
		if mode="add_save" then
			user_name=Request("user_name")
			user_password=Request("user_password")
			sum_password=Request("sum_password")
			limit_play=Request("limit_play")
			old_remain=Replace(Request("old_remain"),",","")
			if old_remain="" then old_remain=0
			parent_login_id=Request("parent_login_id")
			login_id=parent_login_id & Request("login_id")
			address_1=Request("address_1")
			refresh_time = 0 ' Request("refresh_time")
			if not isnumeric(old_remain) then
				Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก ยอดค้างเก่าต้องเป็นตัวเลข !!!</font></span></center>"
			else	
				SQL="select * from sc_user where user_type='P' and create_by=" & dealer_id & " and user_name='" & user_name & "'"
				set objRS=objDB.Execute(SQL)
				if not objRS.eof then
						Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มีชื่อนี้แล้ว !! " & user_name & "</font></span></center>"
				else
						SQL="select * from sc_user where user_type='P' and create_by=" & dealer_id & " and login_id='" & login_id & "'"
						set objRS=objDB.Execute(SQL)
						if not objRS.eof then
								Response.write "<center><span class='tdbody1'><font color='red'>ผิดพลาด : ไม่สามารถทำการบันทึกข้อมูลได้ เนื่องจาก มี หมายเลข นี้แล้ว !! " & login_id & "</font></span></center>"
						else
							SQL="exec spAdd_sc_userNew '" & login_id & "','" & user_name & "','" & user_password & "','" & sum_password & _
							"'," & old_remain & ",'" & address_1 & "'," & dealer_id & ", " & limit_play & "," & refresh_time
							set objRS=objDB.Execute(SQL)
						end if
				end if
			end if
response.redirect "price_player_config.asp"
		end If
		If mode="show" Then 'แสดงราคา % ส่วนลดที่หน้าแทง คนแทง
			SQL="update sc_user set show_price_player=1 where user_id=" & dealer_id
			objDB.Execute(SQL)
response.redirect "price_player_config.asp"
		End If
		If mode="notshow" Then  'ไม่แสดงราคา % ส่วนลดที่หน้าแทง คนแทง
			SQL="update sc_user set show_price_player=0 where user_id=" & dealer_id
			objDB.Execute(SQL)
response.redirect "price_player_config.asp"
		End if		
%>


<IFRAME name="f_hidden" WIDTH=0  height=0 frameborder=0></IFRAME>

	<form name="form1" action="price_player_config.asp" method="post">

	<center><br>
	<div class="table-responsive">
			<table class="table table-striped m-table" border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
					<td>
						<input type="button" class="btn btn-primary btn-sm" value="เพิ่ม" style="cursor:hand; width: 75px;" onClick="click_add();">					
						<input type="button" class="btn btn-focus btn-sm" value="พิมพ์" style="cursor:hand; width: 75px;" onClick="print_user();">
						<input type="button" class="btn btn-metal btn-sm" value="ออก" style="cursor:hand; width: 75px;" onClick="gotoPage('firstpage_dealer.asp')">
					</td>
					<%
					SQL="select  rec_ticket_type,show_price_player, game_id_adjust from sc_user where  user_id=" & dealer_id 
					set objRS=objDB.Execute(SQL)
					Dim rec_ticket_type, select_prefix, select_postfix, game_id_adjust
					Dim red_prefix, red_postfix, green_prefix, green_postfix
					Dim img_blue,img_red,img_green
					Dim show_price_player
					Dim select_show, select_notshow
					img_blue="images/blue.bmp"
					img_red="images/red.bmp"
					img_green="images/green.bmp"
					select_show=""
					select_notshow=""
					If Not objRS.eof Then
						game_id_adjust=objRS("game_id_adjust")
						show_price_player=objRS("show_price_player")
						If CInt(show_price_player)=1 Then
							select_show="checked"
						Else
							select_notshow="checked"
						end If 
						rec_ticket_type=objRS("rec_ticket_type")
						If rec_ticket_type="1" then
							select_prefix="<i><b>"
							select_postfix="</b></i>"
							img_blue="images/sel_blue.bmp"
						End If
						If rec_ticket_type="2" then
							red_prefix="<i><b>"
							red_postfix="</b></i>"
							img_red="images/sel_red.bmp"
						End If
						If rec_ticket_type="3" then
							green_prefix="<i><b>"
							green_postfix="</b></i>"
							img_green="images/sel_green.bmp"
						End if						
					End if
					%>
					<td class="tdbody" style="cursor:hand;" onclick="click_select();">
						<img src="<%=img_blue%>">
						<%=select_prefix%>เลือกเอง<%=select_postfix%>
					</td>
						<td class="tdbody" style="cursor:hand;" onclick="click_red();">
						<img src="<%=img_red%>">
						<%=red_prefix%>แดงทั้งหมด<%=red_postfix%>
					</td>
					<td class="tdbody" style="cursor:hand;" onclick="click_green();">
						<img src="<%=img_green%>">
						<%=green_prefix%>เขียวทั้งหมด<%=green_postfix%>
					</td>
					<td>
						<input type="button" class="btn btn-primary btn-sm" value="ตั้งราคาและตั้งแทงสูงสุด" style="cursor:hand;" onClick="window.open('setMaxPrice.asp','_self')">
					</td>
					<td class="head_black">
					ขณะนี้มีคนออนไลน์อยู่ 
					<%
					SQL="select count(*) as online_cnt from sc_user where create_by=" & dealer_id & " and is_online=1"
					set objRS=objDB.Execute(SQL)
					If Not objRS.eof Then
						response.write objRS("online_cnt")
					End If 
					%>
					คน
					</td>
				</tr>
			</table>
			
			<table class="table table-striped m-table"  border="0"  cellpadding="1" cellspacing="1"  width="100%">
				<tr>
					<td align="center" colspan="2">
						<table class="table table-sm " border="0"  cellpadding="1" cellspacing="1"  width="100%">
							<%
							if rec_ticket_dealer=1 then
								tmp_Color="#33CC33"
							else
								tmp_Color="red"
							end If									
							%>
							<tr >
								<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;" 
								onClick="click_rec_dealer()">&nbsp;
								</td>
								<td colspan="11" class="tdbody">
									&nbsp;หน้าแทงโพยเจ้ามือ 
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<span class="head_black"> แสดงราคาส่วนลดที่หน้าแทงโพย
									<input type="radio" name="show_price_player" value="1" <%=select_show%> onClick="click_show();"> แสดง
									&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="show_price_player" value="0" <%=select_notshow%>  onClick="click_notshow();">  ไม่แสดง
									</span>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<%
									Dim can_adjust
									If Session("gameid")=game_id_adjust Then
										can_adjust="disabled"
									Else
										can_adjust=""
									End If 
									'response. write " test gid =" & Session("gameid")
									%>
									<input type="button" class="btn btn-primary btn-sm" value="ปรับเครดิตอัตโนมัติ" style="cursor:hand;width:150;" onClick="click_balance();" <%=can_adjust %>>
									&nbsp;&nbsp;&nbsp;
										<!--
									<input type="button" value="รายงานเครดิต" style="cursor:hand;width:120;" onClick="click_creditreport();" > 
									-->
								</td>
							</tr>
							<tr class="btn-dark" >
								<td ></td>
								<td ></td>
								<td ></td>
								<td ></td>
								<td  align="right" colspan="1" >
								หมายเลข</td>
								<td  align="center" >ชื่อ</td>
								<td  align="center" >Password</td>
		
								<td  align="center" >เครดิตสูงสุด</td>
								<td  align="center" ></td>
								<td  align="center" >บันทึก โทร ที่อยู่ หมายเหตุ ฯลฯ</td>
							</tr>
						
							<%
'							SQL="select  * from sc_user where user_type='P' and create_by=" & dealer_id & " order by case when isnumeric(login_id)=1 then convert(int,login_id) else 0 end "
							SQL="select  "
							SQL=SQL & " user_id, "
							SQL=SQL & " user_name, "
							SQL=SQL & " user_password, "
							SQL=SQL & " sum_password, "
							SQL=SQL & " user_type, "
							SQL=SQL & " first_name, "
							SQL=SQL & " last_name, "
							SQL=SQL & " nick_name, "
							SQL=SQL & " user_disable, "
							SQL=SQL & " create_by, "
							SQL=SQL & " create_date, "
							SQL=SQL & " address_1, login_id, "
							'SQL=SQL & " address_2 , rec_ticket,is_online, a.limit_play - isnull((select sum(limit_play_sub_player ) from sc_user x where x.create_by_player=a.user_id ),0) as limit_play "
							SQL=SQL & " address_2 , rec_ticket,is_online, a.limit_play as limit_play "
							SQL=SQL & " from sc_user a with(index(idx1)) where  create_by=" & dealer_id & " and create_by_player=0 and user_type='P'   order by login_id "
	'						response.write SQL '2009-09-26
'response.flush
							set objRS=objDB.Execute(SQL)
							Dim c
							c="#FFFFA4"
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							if mode="add_new" then
								tmp_Color="red"
							%>
								<tr>
									<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;">&nbsp;</td>
									<td bgcolor="#FFFFFF" colspan="3">
										<span style="cursor:hand;" onClick="click_add_save();" class="head_blue">บันทึก</span>
										/
										<span style="cursor:hand;" onClick="click_cancel();" class="head_blue">ยกเลิก</span>
									</td>											
									<td bgcolor="#FFFFFF">
										<table cellspacing="0" cellpadding="0" class="table table-striped m-table">
											<tr>												
												<td class="tdbody" bgcolor="<%=c %>" align="right">
													<%=parent_login_id %>
													<input type="hidden" name="parent_login_id" value="<%=parent_login_id%>">
												</td>
												<td class="tdbody" bgcolor="<%=c %>" align="left">
													<input type="text" name="login_id" class="input1" size="8" maxlength="<%=maxlength_login%>" onKeyDown="chkEnter(this);">
												</td>
											</tr>
										</table>
									</td>

									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_name" 	
										class="input1"  size="15" maxlength="80" onKeyDown="chkEnter(this);">	
									</td>										
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="user_password" 
										class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">	
									</td>
									<!--
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="sum_password" 
										class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">
									</td> -->
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<input type="text" name="limit_play" 
										class="input1"  size="10" maxlength="20" onKeyDown="chkEnter(this);">
									</td>
									<td class="tdbody" bgcolor="<%=c %>" ></td>
									<td class="tdbody" bgcolor="<%=c %>" align="left">
										<textarea rows="3" cols="20" name="address_1" class="input1" ></textarea>
									</td>
								</tr>
							<%	
							end if
							'--------- กรณีที่ user click เพิ่มข้อมูล ---------------------------------------------
							Dim st_blink, ed_blink
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
										<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;" 
										onClick="click_status('<%=objRs("user_id")%>');">&nbsp;</td>
										<td bgcolor="#FFFFFF" colspan="3">
											<span style="cursor:hand;" id="btt_save" onClick="click_edit_save('<%=objRs("user_id")%>');" class="head_blue">บันทึก</span>
											/
											<span style="cursor:hand;" onClick="click_cancel();" class="head_blue">ยกเลิก</span>
											/
											<span style="cursor:hand;" class="head_blue" onClick="gotoPage('price_player_config_byuser.asp?player_id=<%=objRS("user_id")%>&game_type=<%=game_type%>');">ตั้งราคา</span>
										</td>				
																			
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<%
											login_id= right(Trim(objRS("login_id")),maxlength_login) 
											%>
											<table cellspacing="0" cellpadding="0" class="table table-striped m-table">
												<tr>												
													<td class="tdbody" bgcolor="<%=c %>" align="right">
														<%=parent_login_id %>
														<input type="hidden" name="parent_login_id" value="<%=parent_login_id%>">
													</td>
													<td class="tdbody" bgcolor="<%=c %>" align="left">
														<input type="text" name="login_id" value="<%=login_id%>" 
														class="input1" size="8" maxlength="<%=maxlength_login%>" onKeyDown="chkEnter(this);">
													</td>
												</tr>
											</table>

											
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_name" 	value="<%=objRS("user_name")%>" 
											class="input1"  size="15" maxlength="80" onKeyDown="chkEnter(this);">	   
										</td>										
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="user_password" value="<%=objRS("user_password")%>"	
											class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);">	
										</td>
										<!--
										<td class="tdbody" bgcolor="<%=c %>" align="left">										
											<input type="text" name="sum_password" value="<%=objRS("sum_password")%>"	
											class="input1"  size="5" maxlength="20" onKeyDown="chkEnter(this);"> 
										</td>-->
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<input type="text" name="limit_play" value="<%=objRS("limit_play")%>"	
											readonly size="10" maxlength="20" onKeyDown="chkEnter(this);">

										</td>
<td class="tdbody" bgcolor="<%=c %>" align="center" ></td>
										<td class="tdbody" bgcolor="<%=c %>" align="left">
											<textarea rows="3" cols="20" name="address_1" class="input1" ><%=objRS("address_1")%></textarea>
										</td>
									</tr>
									<!-----------------------------------------------------------><%
								else
									'<!----------------------แสดงข้อมูล 1 รายการ user ------------------------------------->
									if objRS("rec_ticket")="1" then
										tmp_Color="#33CC33"
									else
										tmp_Color="red"
									end If 
									If objRS("is_online")=1 Then ' blink 
										st_blink= "<font color='red'>" '"<blink>"
										ed_blink= "</font>" '"</blink>"
									Else
										st_blink=""
										ed_blink=""
									End If 
									%>
									<tr>
										<td width="8" class="tdbody1" bgcolor="<%=tmp_Color%>" style="cursor:hand;" 
										onClick="click_status('<%=objRs("user_id")%>');">&nbsp;</td>
										<td class="tdbody"  colspan="3" bgcolor="<%=c %>" >
											<span style="cursor:hand;" onClick="click_edit('<%=objRs("user_id")%>');" class="head_blue">แก้ไข</span>
											/
											<span style="cursor:hand;"   onClick="click_del('<%=objRs("user_id")%>', '<%=objRs("user_name")%>');" class="head_blue">ลบ</span>
											/
											<span style="cursor:hand;" onClick="gotoPage('price_player_config_byuser.asp?player_id=<%=objRS("user_id")%>&game_type=<%=game_type%>');"class="head_blue">ตั้งราคา</span>
										</td>																				
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="60" style="cursor:hand;"
										onClick="click_display('det<%=objRS("user_id")%>','<%=objRS("user_id")%>');" 
										><%=st_blink%><%=objRS("login_id")%><%=ed_blink%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="145"><%=st_blink%><%=objRS("user_name")%><%=ed_blink%>	</td>
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=st_blink%><%=objRS("user_password")%><%=ed_blink%>	</td>
										<!--
										<td class="tdbody" bgcolor="<%=c %>" align="left" width="80"><%=st_blink%><%=objRS("sum_password")%><%=ed_blink%>	</td>
										-->
										<td nowrap class="tdbody" bgcolor="<%=c %>" align="right" width="80"><%=st_blink%><%=FormatN(objRS("limit_play"),0)%><%=ed_blink%>	
										</td>
										<td class="tdbody" bgcolor="<%=c %>" align="center" >
										<input type="button" class="inputM" value="เพิ่มเครดิต" style="cursor:hand;width:90;" onClick="click_credit('<%=objRs("user_id")%>','<%=objRs("user_name")%>');">
										</td>

										<td class="tdbody" bgcolor="<%=c %>" align="left"><%=st_blink%><%=objRS("address_1")%><%=ed_blink%></td>
									</tr>
									<!-- ถ้า click ที่ login_id จะแสดงลูกค้าย่อย  -->
									<tr bgcolor="#FFFFFF">
										<td colspan="11" align="center"><div id="det<%=objRs("user_id")%>" style="display:none;">
										<!-- 
										<IFRAME SRC="shw_player.asp?modeshow=level2&user_id=<%=objRs("user_id")%>" WIDTH=700  SCROLLING=yes height=270 frameborder=0></IFRAME>
										-->
										</div></td>
									</tr>									<!----------------------------------------------------------->
									<%
								end if
								objRS.MoveNext
								
							wend 

							%>
						</table>
					</td>
				</tr>
			</table>
			</div>
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
//
if (document.form1.login_id.value==""){
		alert('ผิดพลาด : กรุณากรอก หมายเลข คนแทง')
		document.form1.login_id.focus();
		return false;
	}
	if (document.form1.user_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อ คนแทง')
		document.form1.user_name.focus();
		return false;
	}
	if (document.form1.user_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.user_password.focus();
		return false;
	}
	/*
	if (document.form1.sum_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสดูยอดเงิน')
		document.form1.sum_password.focus();
		return false;
	}*/
	if (document.form1.limit_play.value==""){
		alert('ผิดพลาด : กรุณากรอก เครดิตสูงสุด')
		document.form1.limit_play.focus();
		return false;
	}

	if (isNaN(document.form1.limit_play.value)){
		alert('ผิดพลาด : กรุณากรอก เครดิตสูงสุด เป็นตัวเลขเท่านั้น')
		document.form1.limit_play.focus();
		return false;
	}

//

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
	// จำนวนหลักต้องเท่ากับ  maxlength_login 
	if ((document.form1.login_id.value).length!=<%=maxlength_login%>){
		alert('ผิดพลาด : กรุณากรอก หมายเลข คนแทง ให้มีจำนวนหลัก '+ <%=maxlength_login%>)
		document.form1.login_id.focus();
		return false;
	}
	// ตัวเลขด้านหน้าต้องเท่ากับ  parent_login_id 
	/*
	if((document.form1.login_id.value).substring(0,<%=len(parent_login_id)%>)!='<%=parent_login_id%>' ){
		alert("กรอก รหัสผู้ใช้งาน ไม่ถูกต้อง ต้องนำหน้าด้วย ::: "+<%=parent_login_id%>+" ::: เท่านั้น");
		document.form1.login_id.focus();
		return false;
	}
	*/

	if (document.form1.login_id.value==""){
		alert('ผิดพลาด : กรุณากรอก หมายเลข คนแทง')
		document.form1.login_id.focus();
		return false;
	}
	if (document.form1.user_name.value==""){
		alert('ผิดพลาด : กรุณากรอก ชื่อ คนแทง')
		document.form1.user_name.focus();
		return false;
	}
	if (document.form1.user_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสผ่าน')
		document.form1.user_password.focus();
		return false;
	}
	/*
	if (document.form1.sum_password.value==""){
		alert('ผิดพลาด : กรุณากรอก รหัสดูยอดเงิน')
		document.form1.sum_password.focus();
		return false;
	}*/
	if (document.form1.limit_play.value==""){
		alert('ผิดพลาด : กรุณากรอก เครดิตสูงสุด')
		document.form1.limit_play.focus();
		return false;
	}

	if (isNaN(document.form1.limit_play.value)){
		alert('ผิดพลาด : กรุณากรอก เครดิตสูงสุด เป็นตัวเลขเท่านั้น')
		document.form1.limit_play.focus();
		return false;
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
			if(obj.name=="user_password"){
				document.form1.sum_password.focus();
			}
			if(obj.name=="sum_password"){
				document.form1.limit_play.focus();
			}*/

		}
	}

	function print_user() {	window.open("dealer_print_player.asp","_blank","top=150,left=150,height=600,width=800,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");
	}

	function click_rec_dealer(){
		document.form1.mode.value="edit_rec_dealer";
		document.form1.submit();
	}
	function click_select(){
		document.form1.mode.value="all_select";
		document.form1.submit();
	}
	function click_red(){
		document.form1.mode.value="all_red";
		document.form1.submit();
	}
	function click_green(){
		document.form1.mode.value="all_green";
		document.form1.submit();
	}
	function click_show(){
		document.form1.mode.value="show";
		document.form1.submit();
	}
	function click_notshow(){
		document.form1.mode.value="notshow";
		document.form1.submit();
	}
	function click_balance(){
		if(confirm("คุณต้องการปรับเครดิตอัตโนมัติ ?")){
			document.form1.mode.value="adjust_balance";
			document.form1.submit();
		}
	}	

	function placeCursorAtEnd(el) {
		  var len = el.value.length;
		  if (el.setSelectionRange) {
			el.setSelectionRange(len, len);
		  } else if (el.createTextRange) {
			var range = el.createTextRange();
			range.collapse(true);
			range.moveEnd('character', len);
			range.moveStart('character', len);
			range.select();
		  }
		}
	function click_credit(UID,user_name){
		window.open ("credit_increase.asp?UID="+UID+"&user_name="+user_name,"mywindow","location=0,status=0,scrollbars=0,width=350,height=200,top=100,left=200"); 

	}
</script>
<%
	if mode="add_new" Then
	%>
	
		<script language="javascript">
			placeCursorAtEnd(document.form1.login_id)
		</script>
	<%
	End if
%>

<%
if mode="edit" then
	%>
	<script>
		placeCursorAtEnd(document.form1.login_id)
	</script>
	<%
end if
%>
<script language="javascript">
	function click_display(div_id,uid){
		obj=document.getElementById(  div_id )	
		if(obj.style.display== 'none' ){
			obj.style.display="";
			startRequest(uid);
		}else{
			obj.style.display= 'none';
		}
	}
</script>
<script language="javascript">
function click_del_det(user_id,modeshow,deluser_id,user_name){
	if (confirm('คุณต้องการลบรายการ ' + user_name+' ?' )){
		var1="shw_player.asp?user_id="+user_id+"&modeshow="+modeshow+"&deluser_id="+deluser_id;
		window.open(var1,"f_hidden");
		window.location.reload();
	}
}
</script>

<% End Sub  %>