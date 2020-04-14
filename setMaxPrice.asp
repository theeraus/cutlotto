<!--#include virtual="masterpage.asp"-->

<% Sub ContentPlaceHolder() %>
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	Dim objRS , objDB , SQL	
	Dim dealer_id, game_id, game_type

	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	objDB.CursorLocation = 3 
	Set objRS =Server.CreateObject("ADODB.Recordset")		
	dealer_id=Session("uid")
	game_id=Session("gameid")	
	SQL="select game_type from tb_open_game where game_id=" & Session("gameid")	
	set objRS=objDB.Execute(SQL)
	If Not objRS.eof Then
		game_type=objRS("game_type")
	End If
	Dim save
	save=Request("save")

	If save="all" Then
		SQL="exec spJCopyPrice2All " & dealer_id & ", " & game_type & ", '" & Request("original_login_id") & "'"
		objDB.Execute(SQL)
	End If
	If save="one" Then
		SQL="exec spJCopyPrice1  " & dealer_id & ", " & game_type & ", '" & Request("from_login_id") & "', '" &  Request("to_login_id")  & "'"
		objDB.Execute(SQL)
	End if	
	If save="yes" Then
		SQL="select user_id from sc_user where create_by=" & dealer_id & " and user_type='P'  " '//and create_by_player=0 " 
		'response.write SQL 
		Set objRS=objDB.execute(SQL)
		Dim player_id,play_type,pay_amt,discount_amt,last_update,maxMoney
		While Not objRS.eof
			'-- 1=2 บน
			play_type=1
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_2up_" & objRS("user_id"))
			discount_amt=Request("dis_amt_2up_" & objRS("user_id"))
			maxMoney=Request("max_2up_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'response.write SQL & "<br>"
			'-- รายย่อย no update 2010-09-11			
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL) 
		'response.write SQL & "<br>"

			'-- 2=3 บน 
			play_type=2
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_3up_" & objRS("user_id"))
			discount_amt=Request("dis_amt_3up_" & objRS("user_id"))
			maxMoney=Request("max_3up_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'-- 3=3 โต๊ด
			play_type=3
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_3tod_" & objRS("user_id"))
			discount_amt=Request("dis_amt_3tod_" & objRS("user_id"))
			maxMoney=Request("max_3tod_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'-- 4=2 โต๊ด
			play_type=4
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_2tod_" & objRS("user_id"))
			discount_amt=Request("dis_amt_2tod_" & objRS("user_id"))
			maxMoney=Request("max_2tod_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'-- 5=วิ่งบน
			play_type=5
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_1up_" & objRS("user_id"))
			discount_amt=Request("dis_amt_1up_" & objRS("user_id"))
			maxMoney=Request("max_1up_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'-- 6= วิ่งล่าง
			play_type=6
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_1down_" & objRS("user_id"))
			discount_amt=Request("dis_amt_1down_" & objRS("user_id"))
			maxMoney=Request("max_1down_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'--7= 2 ล่าง
			play_type=7
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_2down_" & objRS("user_id"))
			discount_amt=Request("dis_amt_2down_" & objRS("user_id"))
			maxMoney=Request("max_2down_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			'--8=3 ล่าง
			play_type=8
			player_id=objRS("user_id")
			pay_amt=Request("pay_amt_3down_" & objRS("user_id"))
			discount_amt=Request("dis_amt_3down_" & objRS("user_id"))
			maxMoney=Request("max_3down_" & objRS("user_id"))
			SQL="update tb_price_player set "
			SQL=SQL & " pay_amt=" & pay_amt & " , "
			SQL=SQL & " discount_amt=" & discount_amt & " , "
			SQL=SQL & " maxMoney=" & maxMoney & ",  "
			SQL=SQL & " last_update=getdate() "
			SQL=SQL & " where player_id=" & player_id 
			SQL=SQL & " and game_type=" & game_type 
			SQL=SQL & " and dealer_id=" & dealer_id 
			SQL=SQL & " and play_type=" & play_type
			objDB.Execute(SQL)
			'-- รายย่อย no update 2010-09-11
			'SQL="update tb_price_player_Level2 set "
			'SQL=SQL & " pay_amt=" & pay_amt & " , "
			'SQL=SQL & " discount_amt=" & discount_amt & " , "
			'SQL=SQL & " maxMoney=" & maxMoney & ",  "
			'SQL=SQL & " last_update=getdate() "
			'SQL=SQL & " where create_by_player=" & player_id 
			'SQL=SQL & " and game_type=" & game_type 
			'SQL=SQL & " and dealer_id=" & dealer_id 
			'SQL=SQL & " and play_type=" & play_type
			'objDB.Execute(SQL)

			objRS.MoveNext
		Wend
'		response.redirect("firstpage_dealer.asp")
	End if
%>

	<form name="form1" action="setMaxPrice.asp" method="post">
		<input type="hidden" name="save">
		<div class="table-responsive">
	<TABLE  border="0"  cellpadding="1" cellspacing="1"  width="100%" class="table table-sm">
	<TR>
		<TD>
			<TABLE>
			<TR>
				<TD><input type="button" class="btn btn btn-label btn-label-brand btn-bold" value="ตั้งราคาและตั้งแทงสูงสุด" class="button_blue"></TD>
				<TD><input type="button" class="btn btn btn-label btn-label-brand btn-bold" id="b1" value="COPY ราคาจาก หมายเลข..ไปทั้งหมด" 

				onClick="document.all.tb1.style.display='' ;document.all.tb2.style.display='none' "></TD>
				<TD><input type="button" class="btn btn btn-label btn-label-brand btn-bold" value="COPY ราคาจาก หมายเลข..ไปยังหมายเลข..." 

				onClick="document.all.tb2.style.display='' ;document.all.tb1.style.display='none' "
				></TD>
				<TD><input type="button" class="btn btn btn-label btn-label-brand btn-bold" value="บันทึก/ออก" 
				onClick="click_submit();"
				></TD>
			</TR>

			</TABLE>		
		</TD>
	</TR>
	<tr>
		<td>
			<TABLE id="tb1" style="display:none;">
			<TR class="head_blue" height="30">
				<TD>COPY ราคาจาก หมายเลข</TD>
				<TD><input type="text" name="original_login_id" style="border-width:1;width:50;"  > ไปทั้งหมด</TD>
				<TD><input type="button" value="ตกลง" style="cursor:hand;width:90;" onClick="click_all();"></TD>
			</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td>
			<TABLE id="tb2" style="display:none;">
			<TR class="head_blue" height="30">
				<TD>COPY ราคาจาก หมายเลข</TD>
				<TD><input type="text" name="from_login_id" style="border-width:1;width:50;"  ></TD>
				<TD> ไปยัง หมายเลข</TD>
				<TD><input type="text" name="to_login_id" style="border-width:1;width:50;"  ></TD>
				<TD><input type="button" value="ตกลง" style="cursor:hand;width:90;" onClick="click_one();"></TD>
			</TR>
			</TABLE>
		</td>
	</tr>
	<TR>
		<TD>
			<TABLE class="text_black">
			<TR>
				<TD>จ่าย=อัตราจ่าย</TD>
			
				<TD>&nbsp;&nbsp;&nbsp;ลด%=ส่วนลดเปอร์เซ็นต์</TD>
			
				<TD>&nbsp;&nbsp;&nbsp;แทงสูงสุด=เงินแทงสูงสุด ต่อเลข ต่อคน</TD>
			</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>
			<TABLE  border="0"  cellpadding="2" cellspacing="2"  width="100%" bgcolor="#000000"  class="table table-sm">
			<TR class="head_white">
				<TD rowspan="2" align="center" class="btn-primary">หมายเลข</TD>
				<TD rowspan="2" align="center"  class="btn-primary">ชื่อ</TD>
				<TD colspan="3" align="center" class="btn-warning">2 บน</TD>
				<TD colspan="3" align="center"  class="btn-primary">3 บน</TD>
				<TD colspan="3" align="center" class="btn-warning">3 โต๊ด</TD>
				<TD colspan="3" align="center"  class="btn-primary">2 โต๊ด</TD>
				<TD colspan="3" align="center" class="btn-warning">วิ่งบน</TD>
				<TD colspan="3" align="center"  class="btn-primary">วิ่งล่าง</TD>
				<TD colspan="3" align="center" class="btn-warning">2 ล่าง</TD>
				<TD colspan="3" align="center"  class="btn-primary">3 ล่าง</TD>
			</TR>
			<TR class="text_white">		
				<TD class="btn-warning"><b>จ่าย</b></TD>
				<TD class="btn-warning"><b>ลด%</b></TD>
				<TD class="btn-warning"><b>แทงสูงสุด</b></TD>				

				<TD  class="btn-primary"><b>จ่าย</b></TD>
				<TD class="btn-primary"><b>ลด%</b></TD>
				<TD  class="btn-primary"><b>แทงสูงสุด</b></TD>

				<TD class="btn-warning"><b>จ่าย</b></TD>
				<TD class="btn-warning"><b>ลด%</b></TD>
				<TD class="btn-warning"><b>แทงสูงสุด</b></TD>

				<TD  class="btn-primary"><b>จ่าย</b></TD>
				<TD  class="btn-primary"><b>ลด%</b></TD>
				<TD  class="btn-primary"><b>แทงสูงสุด</b></TD>

				<TD class="btn-warning"><b>จ่าย</b></TD>
				<TD class="btn-warning"><b>ลด%</b></TD>
				<TD class="btn-warning"><b>แทงสูงสุด</b></TD>
				

				<TD  class="btn-primary"><b>จ่าย</b></TD>
				<TD  class="btn-primary"><b>ลด%</b></TD>
				<TD  class="btn-primary"><b>แทงสูงสุด</b></TD>

				<TD class="btn-warning"><b>จ่าย</b></TD>
				<TD class="btn-warning"><b>ลด%</b></TD>
				<TD class="btn-warning"><b>แทงสูงสุด</b></TD>

				<TD  class="btn-primary"><b>จ่าย</b></TD>
				<TD  class="btn-primary"><b>ลด%</b></TD>
				<TD  class="btn-primary"><b>แทงสูงสุด</b></TD>

			</TR>
			<%
			SQL="exec spJGetMaxMoney " & dealer_id & ", " & game_type

			Set objRS=objDB.Execute(SQL)
			dim row,row_
			row=1
			While Not objRS.eof
				row_=Right("0000" & row,4)
				%>
				<tr bgcolor="#FFFFFF" class="text_black">
					<td>
						<%=objRS("login_id")%>
					</td>
					<td><%=objRS("user_name")%></td>

					<td align="right">
						<input type="text" name="pay_amt_2up_<%=objRS("user_id")%>"
						id="<%=row_%>_01"
						value='<%=objRS("pay_amt_2up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_2up_<%=objRS("user_id")%>"
						id="<%=row_%>_02"
						value='<%=objRS("dis_amt_2up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_2up_<%=objRS("user_id")%>"
						id="<%=row_%>_03"
						value='<%=objRS("max_2up")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>

					<td align="right">
						<input type="text" name="pay_amt_3up_<%=objRS("user_id")%>"
						id="<%=row_%>_04"
						value='<%=objRS("pay_amt_3up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_3up_<%=objRS("user_id")%>"
						id="<%=row_%>_05"
						value='<%=objRS("dis_amt_3up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_3up_<%=objRS("user_id")%>"
						id="<%=row_%>_06"
						value='<%=objRS("max_3up")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>

					<td align="right">
						<input type="text" name="pay_amt_3tod_<%=objRS("user_id")%>"
						id="<%=row_%>_07"
						value='<%=objRS("pay_amt_3tod")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue" >
					</td>
					<td align="right">
						<input type="text" name="dis_amt_3tod_<%=objRS("user_id")%>"
						id="<%=row_%>_08"
						value='<%=objRS("dis_amt_3tod")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_3tod_<%=objRS("user_id")%>"
						id="<%=row_%>_09"
						value='<%=objRS("max_3tod")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>

					<td align="right">
						<input type="text" name="pay_amt_2tod_<%=objRS("user_id")%>"
						id="<%=row_%>_10"
						value='<%=objRS("pay_amt_2tod")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_2tod_<%=objRS("user_id")%>"
						id="<%=row_%>_11"
						value='<%=objRS("dis_amt_2tod")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_2tod_<%=objRS("user_id")%>"
						id="<%=row_%>_12"
						value='<%=objRS("max_2tod")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>

					<td align="right">
						<input type="text" name="pay_amt_1up_<%=objRS("user_id")%>"
						id="<%=row_%>_13"
						value='<%=objRS("pay_amt_1up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_1up_<%=objRS("user_id")%>"
						id="<%=row_%>_14"
						value='<%=objRS("dis_amt_1up")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_1up_<%=objRS("user_id")%>"
						id="<%=row_%>_15"
						value='<%=objRS("max_1up")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>

					<td align="right">
						<input type="text" name="pay_amt_1down_<%=objRS("user_id")%>"
						id="<%=row_%>_16"
						value='<%=objRS("pay_amt_1down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_1down_<%=objRS("user_id")%>"
						id="<%=row_%>_17"
						value='<%=objRS("dis_amt_1down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_1down_<%=objRS("user_id")%>"
						id="<%=row_%>_18"
						value='<%=objRS("max_1down")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>			

					<td align="right">
						<input type="text" name="pay_amt_2down_<%=objRS("user_id")%>"
						id="<%=row_%>_19"
						value='<%=objRS("pay_amt_2down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_2down_<%=objRS("user_id")%>"
						id="<%=row_%>_20"
						value='<%=objRS("dis_amt_2down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_2down_<%=objRS("user_id")%>"
						id="<%=row_%>_21"
						value='<%=objRS("max_2down")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>		

					<td align="right">
						<input type="text" name="pay_amt_3down_<%=objRS("user_id")%>"
						id="<%=row_%>_22"
						value='<%=objRS("pay_amt_3down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>
					<td align="right">
						<input type="text" name="dis_amt_3down_<%=objRS("user_id")%>"
						id="<%=row_%>_23"
						value='<%=objRS("dis_amt_3down")%>' 
						style="border-width:1;width:30;" 
						maxlength="3" 
						onKeyDown="chkEnter(this);" class="text_blue">					
					</td>
					<td align="right">
						<input type="text" name="max_3down_<%=objRS("user_id")%>"
						id="<%=row_%>_24"
						value='<%=objRS("max_3down")%>' 
						style="border-width:1;width:50;" 
						maxlength="6" 
						onKeyDown="chkEnter(this);" class="text_blue">
					</td>		

				</tr>
				<%
				row=row+1
				objRS.MoveNext
			wend
			%>
			</TABLE>
		</TD>
	</TR>
	</TABLE>
	</div>
	</form>

<script language="javascript">
	function click_submit(){
		// validate data
		for( i = 1; i < <%=row %>; i++ ) { 
			tmp="0000"+i;
			ltmp=tmp.length
			row=tmp.substring(ltmp-4,ltmp)
			for( j = 1; j<=24; j++ ) { 
				tmp="00"+j;
				ltmp=tmp.length
				col=tmp.substring(ltmp-2,ltmp)
				next_obj = document.getElementById(  row+'_'+col )	

				if(typeof(next_obj) == "object"){
					if(isNaN(next_obj.value)){
						alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
						next_obj.focus();
						return false;
					}
				}
			}	
		}
		document.form1.save.value="yes";
		//alert('บันทึกข้อมูล')
		document.form1.submit();
	}
	//เช็ค กด enter
	function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
			if(isNaN(obj.value)){
				alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
				obj.focus();
				return false;
			}
			row=lefty(obj.id,4)
			col_next= obj.id
			col_next=parseFloat(col_next.substring(5,7))+1;
			tmp=('00'+col_next)
			ltmp=tmp.length
			col_next=tmp.substring(ltmp-2,ltmp)

			if(col_next>24){	row=parseFloat(row)+1; 
				tmp=('0000'+row)
				ltmp=tmp.length
				row=tmp.substring(ltmp-4,ltmp)
				col_next='01';
			}
			next_obj = document.getElementById(  row+'_'+col_next )	
			if(typeof(next_obj) == "object"){
				next_obj.focus();
			}
		}
	}
	function lefty (instring, num){
		var outstr=instring.substring(instring, num);
		return (outstr);
	}
	function click_all(){
		if(document.form1.original_login_id.value==''){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.original_login_id.focus();
			return false;
		}
		if(isNaN(document.form1.original_login_id.value)){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.original_login_id.focus();
			return false;
		}
		document.form1.save.value="all";
		document.form1.submit();
	}
	function click_one(){	
		if(document.form1.from_login_id.value==''){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.from_login_id.focus();
			return false;
		}
		if(isNaN(document.form1.from_login_id.value)){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.from_login_id.focus();
			return false;
		}
		if(document.form1.to_login_id.value==''){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.to_login_id.focus();
			return false;
		}
		if(isNaN(document.form1.to_login_id.value)){
			alert('ผิดพลาด : กรุณากรอก เป็นตัวเลขเท่านั้น !!!')
			document.form1.to_login_id.focus();
			return false;
		}

		document.form1.save.value="one";
		document.form1.submit();
	}
</script>

<% end sub %>