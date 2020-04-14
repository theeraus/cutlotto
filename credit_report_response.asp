<%OPTION EXPLICIT%>
<%
	Dim border,printtype, start_date , end_date,start_login_no, end_login_no, dealer_id,grand_total
	grand_total=0
	dealer_id=Session("uid")
	border="1"
	printtype=Request("printtype")
	start_date=Request("start_date")
	end_date=Request("end_date")
	start_login_no=Request("start_login_no")
	end_login_no=Request("end_login_no")
	If printtype="excel" then
		Response.ContentType = "application/vnd.ms-excel"
		Response.AddHeader "Content-Disposition", "attachment; filename=credit_report.xls" 
		border="1"
	Else 
		 Response.AddHeader "Pragma", "no-cache" 
		 Response.Expires = -1 
		 Response.CacheControl = "no-cache" 
	End If 
   response.Charset="tis-620"
	
%>
<html>
<style>
body,table{font-family:tahoma, Arial, Helvetica, sans-serif; font-size:13px;}
.tablecontent{ font-family:tahoma, Arial, Helvetica, sans-serif; font-size:13px; border-style:solid ; border-width:1px;}
.boderbottom { border-bottom-style:solid ; border-bottom-width:1px; }
.document_table{ border: 1px solid #CCCCCC; font-family:tahoma, Arial, Helvetica, sans-serif  }
.document_table td {border-bottom: 1px solid #CCCCCC}
</style>
<meta http-equiv="Content-type" content="text/html;charset=tis-620" />
<style type="text/css">
<!--
.style1 {

	color: #FFFFFF;
	font-weight: bold;
}
.style2 {color: #FFFFFF}
-->
</style>
<body>
<center>
<%	
	Dim objRS , objDB , SQL, objRS1
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Set objRS1 =Server.CreateObject("ADODB.Recordset")
	Dim game_id
	game_id=Session("gameid")
	SQL=""
	If start_login_no<>"" then
		SQL="select login_id,user_id,user_name,address_1,limit_play_original,limit_play from sc_user a where create_by=" & dealer_id & " and login_id>='" & start_login_no & "' and login_id<='" & end_login_no & "'"
	Else ' กรณีทั้งหมด

		'SQL="  select distinct a.login_id,a.user_id,a.user_name,a.address_1,a.limit_play_original,a.limit_play  "
		'SQL=SQL & " from sc_user a  " '//inner join tb_ticket b on a.user_id=b.player_id and b.game_id=" & game_id
		'SQL=SQL & "  where  a.user_type='P'  "
		'SQL=SQL & " and a.create_by=" & dealer_id
		'SQL=SQL & " and convert(varchar(10),activate_time,21)>=dbo.fxChr2Date('" & start_date & "') "
		'SQL=SQL & " and convert(varchar(10),activate_time,21)<=dbo.fxChr2Date('" & end_date & "') "

SQL=" select distinct a.login_id,a.user_id,a.user_name,a.address_1,a.limit_play_original,a.limit_play  "
SQL=SQL & " from sc_user a where a.user_type='P' and a.create_by=" & dealer_id & " and  "
SQL=SQL & " ( "
SQL=SQL & "( "
SQL=SQL & " convert(varchar(10),activate_time,21)>=dbo.fxChr2Date('" & start_date & "')  "
SQL=SQL & " and convert(varchar(10),activate_time,21)<=dbo.fxChr2Date('" & end_date  & "')  "
SQL=SQL & " ) "

SQL=SQL & " or "
SQL=SQL & "( "
SQL=SQL & " convert(varchar(10),create_date ,21)>=dbo.fxChr2Date('" & start_date & "')  "
SQL=SQL & " and convert(varchar(10),create_date ,21)<=dbo.fxChr2Date('" & end_date  & "')  "
SQL=SQL & " ) "


SQL=SQL & " or "
SQL=SQL & " exists ( "
SQL=SQL & " select 1 from tb_usercredit_det b where a.user_id=b.user_id and  "
SQL=SQL & " convert(varchar(10),adj_date,21)>=dbo.fxChr2Date('" & start_date  & "')  "
SQL=SQL & " and convert(varchar(10),adj_date,21)<=dbo.fxChr2Date('" & end_date & "') "
SQL=SQL & " ) "
SQL=SQL & " ) "


	End If
	SQL=SQL & " order by a.login_id"
'response.write SQL
	Set objRS=objDB.Execute(SQL)
'response.end
	Dim numrow, cols
	cols=6 '10
	numrow=1
	Dim color_1,color_white, color_yellow, color_orange
	color_1="#D7FFBB"
	color_white="#FFFFFF"
	color_yellow="#FFFFC4"
	color_orange="#FF8000"
	If Not objRS.eof then
		
%>

<table border="<%=border%>" align="center" cellpadding="1" cellspacing="1" width="100%">
	<%
	If printtype="excel" then		
		response.write "<tr><td colspan=" & (CInt(cols) + 5) & " align='center'>รายงานเครดิต</td></tr> "
		response.write "<tr><td colspan=" & (CInt(cols) + 5) & " align='center'>เริ่มวันที่ " & start_date & " ถึงวันที่ " & end_date 
		If  start_login_no<>"" Then
			response.write " จากรหัส " & start_login_no & " ถึงรหัส " & end_login_no
		Else 
			response.write " จากรหัสทั้งหมดที่มีความเคลื่อนไหว"
		End If 
		response.write "</td></tr> "
	End If 
		
	%>
	<tr>
		<td align="center"  bgcolor="<%=color_white%>" nowrap><font color="#000000">รหัส</font></td>
		<td align="center"  bgcolor="<%=color_white%>" nowrap ><font color="#000000">ชื่อ</font></td> 
		<td align="center"  bgcolor="<%=color_white%>" nowrap ><font color="#000000">เบอร์โทร</font></td> 
		<td align="center"  bgcolor="<%=color_1%>" nowrap ><font color="#000000">เครดิตยกมา</font></td> 
		<td align="center"  bgcolor="#0033FF" nowrap colspan="<%=cols%>"><font color="#FFFFFF">รายการเคลื่อนไหว</font></td> 		
		<td align="center"  bgcolor="<%=color_orange%>" nowrap ><font color="#000000">เครดิตคงเหลือ</font></td> 
	</tr>		
  <%
	Dim i, bg, count_col, myUID, move_credit, finish_credit , balance_credit
	Dim login_id,user_name,address_1,bf_credit,first_line_of_player
	i=1
 	While Not objRS.eof 
		myUID=objRS("user_id")
		 login_id=objRS("login_id")
		 user_name=objRS("user_name")
		 address_1=objRS("address_1")
		 'หาเครดิตยกมา  limit_play_original (เครดิต เดิมที่เจ้ามือให้มา) - เครดิตตั้งแต่เริ่มถึงก่อนวันที่เรียกดูข้อมูล
		move_credit=SumCreditToDate(myUID,start_date)	
		'//finish_credit=SumCreditFinishDate(myUID,start_date) ' ตัดเครดิต ส่วนท้ายออก
		bf_credit=CDbl(move_credit)+CDbl(objRS("limit_play_original"))
		balance_credit=bf_credit
		first_line_of_player=1
		i = i + 1
		If i Mod 2 =0 Then 
			bg="#F0F5FA"
		Else 
			bg="#D1DCEB"
		End If 
	 %><tr >
		<td  bgcolor="<%=color_white%>" align="left" ><%=login_id%></td>		
		<td  bgcolor="<%=color_white%>" align="center" ><%=user_name%></td>
		<td  bgcolor="<%=color_white%>" align="center" nowrap>&nbsp;<%=address_1%></td>		
		<td  bgcolor="<%=color_1%>" align="right" ><%=FormatNumber(bf_credit,2)%></td><!-- ต้องหาค่าใหม่-->		
	  <%


		SQL="exec spJCreditReportSum '" & start_date & "','" & end_date & "','" & objRS("login_id") & "'"
		Set objRS1=objDB.Execute(SQL)
		If Not objRS1.eof Then		
			balance_credit=CDbl(balance_credit)+CDbl(objRS1("sum_adj_credit"))
		End If 
		grand_total=grand_total+balance_credit
		SQL="exec spJCreditReport '" & start_date & "','" & end_date & "','" & objRS("login_id") & "'"
		Set objRS1=objDB.Execute(SQL)
		count_col=1 
		While Not objRS1.Eof 
 %>

    <td  style="width:110px;" bgcolor="<%=color_yellow%>" align="center" ><%=objRS1("adj_type") & show_sign(CDbl(objRS1("adj_credit"))) & objRS1("adj_credit")%><br><%=objRS1("show_adj_date")%></td>		
	
  
  <%
			objRS1.MoveNext			
			count_col=count_col+1
			If cint(count_col)>cint(cols) Then
				count_col=1
				If CInt(first_line_of_player)=1 Then
					response.write "<td align='right' bgcolor='" & color_orange & "'>" & FormatNumber(balance_credit ,2) & "</td>"
					first_line_of_player=first_line_of_player+1
				Else 
					response.write "<td align='right' bgcolor='" & color_orange & "'>&nbsp;</td>"
				End If 
				Response.write "</tr><tr><td colspan='4' bgcolor='" & bg & "'>&nbsp;</td>"				
			End If 			
		Wend  
		If CInt(count_col)<=cint(cols) Then
			While CInt(count_col)<=cint(cols)
				response.write "<td style='width:90px;' bgcolor='" & bg & "'>&nbsp;</td>"
				count_col=count_col+1
			Wend 
			If CInt(first_line_of_player)=1 Then
				response.write "<td align='right' bgcolor='" & color_orange & "'>" & FormatNumber(balance_credit,2) & "</td>"
				first_line_of_player=first_line_of_player+1
			Else
				response.write "<td align='right' bgcolor='" & color_orange & "'>&nbsp;</td>"
			End If 
		End If 
		
		%>

		</tr>
		<%
		
		objRS1.Close
		objRS.MoveNext
	wend
    '// while

  %> 
  <tr>
		<td align="right"  bgcolor="<%=color_white%>" nowrap colspan="10" ><font color="#000000"><b>รวมทั้งสิ้น</b></font>&nbsp;&nbsp;&nbsp;&nbsp;</td>			
		<td align="right"  bgcolor="<%=color_orange%>" nowrap ><font color="#000000"><b><%=FormatNumber(grand_total,2)%></b></font></td> 
	</tr>	
</table>
<%
 Else 
		 If printtype<>"excel" then	
			response.write "<tr><td align='left'><font color='#FF0000' siz='2'><b>ไม่พบข้อมูลที่ต้องการค้นหา!!!</b></font></td></tr>"
		 End if
  End If 
 
%>
</center>
</body>
</html>
<%
Function show_sign(number)
	If number>0 Then
		show_sign="+"
	Else
		show_sign= ""
	End if
End Function
Function SumCreditToDate(user_id,atDate)
	Dim myCredit
	myCredit=0
	SQL="exec spJCalcCreditBF " & user_id & ",'" & atDate & "'"
	Set objRS1=objDB.execute(SQL)
	If Not objRS1.eof Then
		myCredit=objRS1("credit")
	End If 
	SumCreditToDate=myCredit
	'response.write SQL
	response.flush
	'response.End 
End Function
Function SumCreditFinishDate(user_id,atDate)
	Dim myCredit
	myCredit=0
	SQL="exec spJCalcCreditFinish " & user_id & ",'" & atDate & "'"
	Set objRS1=objDB.execute(SQL)
	If Not objRS1.eof Then
		myCredit=objRS1("credit")
	End If 
	SumCreditFinishDate=myCredit
	'response.write SQL
End function
%>