<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->

<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>
<html>
<head>
<title>.:: ตั้งราคากลาง : เว็บแทงออก ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="JavaScript" src="include/dialog.js"></script>
<script language="Javascript">
function change (picurl,n) {
	if (n==1){	
		document.pictureGov.src = picurl;
	}
	if (n==2){	
		document.pictureTos.src = picurl;
	}
	if (n==3){	
		document.pictureOth.src = picurl;
	}
}
</script> 

</head>
<body topmargin="0"  leftmargin="0">	
<%
	Dim dealer_id, player_id, game_type,from_save, rec_ticket 
	Dim play_type , pay_amt , discount_amt, i
	Dim pic, use_same_this
	dealer_id=Session("uid")	
	player_id=Request("player_id")
	game_type=Request("game_type")
	from_save=Request("from_save")
	Dim objRS , objDB , SQL, login_id,objRSTMP ,maxMoney
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Set objRSTMP =Server.CreateObject("ADODB.Recordset")
	SQL="select login_id from sc_user where user_id=" & player_id 
	set objRS=objDB.Execute(SQL)
	if not objRS.eof then
		login_id=objRS("login_id")
	end if
	if from_save="yes" then
	'// ถ้ามาจากการ click บันทึก
		use_same_this=Request("use_same_this")
		rec_ticket=Request("rec_ticket")		
'		SQL="update sc_user set rec_ticket=" & rec_ticket & " where [user_id]=" & player_id
'		set objRS=objDB.Execute(SQL)

		for i=1 to 8
			play_type=i
			pay_amt =Request("p" & i)
			if pay_amt="" then pay_amt=0

			discount_amt=Request("d" & i)
			if discount_amt="" then discount_amt=0

			SQL="select maxMoney from tb_price_player where dealer_id="	 & dealer_id & " and player_id=" & player_id & " and game_type=" & game_type & " and play_type=" & play_type
			response.write SQL
			Set objRSTMP=objDB.Execute(SQL)	
			maxMoney=0
			If Not 	objRSTMP.eof Then
					maxMoney=objRSTMP("maxMoney")
			End if

			SQL="delete tb_price_player where dealer_id="	 & dealer_id & " and player_id=" & player_id & " and game_type=" & game_type & " and play_type=" & play_type
			objDB.Execute(SQL)

			SQL="exec spInsert_tb_price_player " & dealer_id & "," & _
			player_id & "," & game_type & "," & play_type &  "," &	pay_amt & "," & discount_amt & "," & maxMoney
			set objRS=objDB.Execute(SQL)
		next 
		if use_same_this="yes" then
			'-- update ข้อมูลของ player ทุกคนที่เป็นของเจ้ามือนี้ให้มีราคา / % เท่ากับ player นี้ 
			SQL="exec spA_Update_tb_price_web_Lot " & dealer_id & ", " & player_id & "," & game_type
			set objRS=objDB.Execute(SQL)
		end if
		Response.Redirect("dealer_web_config.asp")
	end if
%>
	<form name="form1" action="price_web_config_byuser.asp?me=1" method="post">
	<center><br>
	<table width="500"  border="0" cellspacing="1" cellpadding="1">
		<tr height="35">
			<td><img src="images/price_gov.jpg" border="0" style="cursor:hand;"  name="pictureGov" 
			onMouseOver="change('images/price_gov_over.jpg',1);" 
			onMouseOut="change('images/price_gov.jpg',1)"
			onClick="gotoPage('price_web_config_byuser.asp?play_id=<%=player_id%>&game_type=1');">		

			<img src="images/price_tos.jpg" border="0" style="cursor:hand;" name="pictureTos" 
			onMouseOver="change('images/price_tos_over.jpg',2);" 
			onMouseOut="change('images/price_tos.jpg',2)"	onClick="gotoPage('price_web_config_byuser.asp?play_id=<%=player_id%>&game_type=2');">	

			<img src="images/price_oth.jpg" border="0"style="cursor:hand;"  name="pictureOth" 
			onMouseOver="change('images/price_oth_over.jpg',3);" 
			onMouseOut="change('images/price_oth.jpg',3)"
			onClick="gotoPage('price_web_config_byuser.asp?play_id=<%=player_id%>&game_type=3');">	
			<td>
		</tr>
	</table>
	<table width="500"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
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
			SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
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
	</table><br>
	<table width="500"  border="0" cellspacing="1" cellpadding="1">
		<tr  height="30">
			<td class="tdbody" align="left" colspan="4">&nbsp;&nbsp;&nbsp;
				<img src="images/price_same.GIF" style="cursor:hand;" onClick="SearchPlayer()">
			</td>
		</tr>
		<tr height="35">
			<!---- ใช้ราคานี้ ---->
			<td class="tdbody" align="left" colspan="4">&nbsp;&nbsp;&nbsp; 
				<input type="hidden" name="use_same_this" value="">
				<img src="images/user_this.GIF" style="cursor:hand;" onClick="clickuse_same_this('<%=GetGameDesc(game_type)%>')">
			</td>
		</tr>
		<tr>
			<input type="hidden" name="from_save" value="yes">
			<input type="hidden" name="dealer_id" value="<%=dealer_id%>">
			<input type="hidden" name="player_id" value="<%=player_id%>">
			<input type="hidden" name="game_type" value="<%=game_type%>">
			<td class="tdbody" align="left" colspan="4">&nbsp;&nbsp;&nbsp;
				<input type="button" value=" บันทึก/ออก" name="OK" style="cursor:hand;" onClick="clickok();">
			</td>
		</tr>
	</table>
	</center>
	</form>
</body>
</html>
<%
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
%>
<script language="javascript">
function SearchPlayer(){		
		openDialog('search_player.asp?dealer_id=<%=dealer_id%>&game_type=<%=game_type%>', 8, 5, 250, 400);
}
function clickrec_ticket(p){
	var t=p

	if (t=="2"){
		document.p_rec_ticket.src = "images/rec_play.bmp";
		document.form1.rec_ticket.value="1" // รอคิวก่อนรับ
	}else{
		document.p_rec_ticket.src = "images/rec_play_q.GIF"	;
		document.form1.rec_ticket.value="2" // รับเลย
	}	
}

function clickok(){
	document.form1.submit();
}
function clickuse_same_this(t){
	if (confirm('คุณต้องการ ใช้ราคานี้ทั้งหมด \n ราคาของทุกคน (เฉพาะ'+t+')ให้แก้เป็นราคาเดียวกัน ทั้ง จ่าย และ %')) {
   document.form1.use_same_this.value="yes"
   document.form1.submit();
	}	
}

function chkEnter(obj){
	var k=event.keyCode
	if (k == 13){	
		var n=obj.id.substring(3,4)
		var idX=obj.id.substring(0,3)
		var next,id, next_obj 
		next=parseInt(n)+1		
		if (next>8) {
			if (obj.id.substring(0,3)=='idL'){
				next=1
				idX='idR'		
			}else{
				return;
			}
		}
		id=idX+next
		next_obj = document.getElementById(  id )	
		next_obj.focus();
	}
}
	
</script>