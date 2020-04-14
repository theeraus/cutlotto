<!--#include virtual="masterpage.asp"-->

<% Sub ContentPlaceHolder() %>

	
<%
	Dim dealer_id, player_id, game_type,from_save, rec_ticket 
	Dim play_type , pay_amt , discount_amt, i, out_amt, out_disc
	Dim pic, use_same_this
	Dim status20
	Dim status20color
	dealer_id=Session("uid")	
	player_id=Session("uid")
	game_type=Request("game_type")
	from_save=Request("from_save")
	Dim objRS , objDB , SQL, login_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select login_id, isnull(use_20,'N') as use20 from sc_user where user_id=" & player_id 
	set objRS=objDB.Execute(SQL)
	if not objRS.eof then
		login_id=objRS("login_id")
		status20 = objRS("use20")
	end if
	if from_save="yes" then
	'// ถ้ามาจากการ click บันทึก
		Dim maxMoney
		use_same_this=Request("use_same_this")
		rec_ticket=Request("rec_ticket")	

		SQL="update sc_user set rec_ticket=" & rec_ticket & " where [user_id]=" & player_id
		set objRS=objDB.Execute(SQL)
		

		for i=1 to 8
			play_type=i
			pay_amt =Request("p" & i)
			if pay_amt="" then pay_amt=0

			discount_amt=Request("d" & i)
			if discount_amt="" then discount_amt=0

			out_amt=Request("o" & i)
			If out_amt="" Then out_amt=0

			out_disc=Request("s" & i)
			If out_disc="" Then out_disc=0
			
			SQL="exec spInsert_tb_price_playerMax " & dealer_id & "," & _
			player_id & "," & game_type & "," & play_type &  "," &	pay_amt & "," & discount_amt & "," & out_amt & "," & out_disc
			set objRS=objDB.Execute(SQL) 
		next 
		if use_same_this="yes" then
			'-- update ข้อมูลของ player ทุกคนที่เป็นของเจ้ามือนี้ให้มีราคา / % เท่ากับ player นี้ 
			SQL="exec spUpdate_tb_price_player_Lot " & dealer_id & ", " & player_id & "," & game_type
			set objRS=objDB.Execute(SQL)
		end if
		Response.Redirect("firstpage_dealer.asp")
	Elseif from_save="20" Then
		Dim tmpChangStatus
		tmpChangStatus = Request("status20")
		If tmpChangStatus="N" Then
			tmpChangStatus="Y"
		ElseIf tmpChangStatus = "Y" Then
			tmpChangStatus = "N"
		End If 
			SQL="update sc_user set use_20 = '" & tmpChangStatus & "' where user_id=" & dealer_id
			set objRS=objDB.Execute(SQL)
		status20 = tmpChangStatus
		'Response.write("ok work  " & tmpChangStatus )
	End If 
%>

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
function click_20() {
	document.form1.from_save.value="20";
	document.form1.submit();
}
</script> 

<form name="form1" action="price_player_config_dealer.asp?me=1" method="post">
				<input type="hidden" name="from_save" value="yes">
				<input type="hidden" name="dealer_id" value="<%=dealer_id%>">
				<input type="hidden" name="player_id" value="<%=player_id%>">
				<input type="hidden" name="game_type" value="<%=game_type%>">
				<input type="hidden" name="status20" value="<%=status20%>">
<div class="alert alert-primary " role="alert">
		<div class="alert-text">
			<h4 class="alert-heading">ตั้งราคากลาง! ราคากลางใช้ 2 กรณี คือ</h4>
				<p>1. ใช้ในการ สู้บน และ สู้ล่าง</p>
				<p class="mb-0">2. ใช้เป็นราคาตอนพิมพ์แทงออก</p>
		</div>
</div>
<table  class=" table table-striped table-bordered table-sm">
			<%
			Dim bgcolor
			select case game_type
					case 1
						bgcolor="btn-info "
					case 2
						bgcolor="btn-accen"
					case 3
						bgcolor="btn-dark"					
			end select
			%>
			<tr>
				<td  align="center" class="<%=bgcolor%>" colspan="5">
					<%=GetGameDesc(game_type)%>		
				</td>
			</tr>
			<tr class="btn-metal">
				<td class="tdbody1" align="center">หมายเลข : <%=login_id%></td>
				<td class="tdbody1" align="center" colspan="2">ชื่อ : <%=GetPlayerName(player_id)%></td>
			</tr>
			<tr class="btn-metal">
				<td class="tdbody1" align="center" >ชนิด</td>
				<td class="tdbody1" align="center">จ่าย</td>
				<td class="tdbody1" align="center">ลด (%)</td>
			</tr>
			<%
				SQL="exec spGet_tb_price_player_by_dealer_id_player_id_game_type " & 	dealer_id & "," & player_id & "," & game_type
				set objRS=objDB.Execute(SQL)
				i=1
				while not objRS.eof
					if objRS("ref_det_desc")=" " then
			%>
				<tr>
					<td class="tdbody1"  align="center">&nbsp;</td>
					<td align="center" >&nbsp;</td>
					<td align="center">&nbsp;</td>
				</tr>
			<%
					else
			%>
				<tr>
					<td class="tdbody1"  align="center">&nbsp;<%=objRS("ref_det_desc")%></td>
					<td align="center" >
						<input type="text" name="p<%=objRS("play_type")%>"  value="<%=objRS("pay_amt")%>" class="input1" size="5" maxLength="3" id="idL<%=i%>" onKeyDown="chkEnter(this);" >
					</td>
					<td  align="center">
						<input type="text" name="d<%=objRS("play_type")%>" value="<%=objRS("discount_amt")%>" class="input1" size="5" maxLength="2"  id="idR<%=i%>" onKeyDown="chkEnter(this);">
					</td>
				</tr>
			<%
					i=i+1
				end if
				objRS.MoveNext
				wend
			%>
		</table>
		<div class="row">
			<%
			rec_ticket=GetPlayerRecTicket(player_id)
			if rec_ticket=1 then '1=รับเลย
				pic="images/rec_play.bmp"
			else
				pic="images/rec_play_q.GIF"				
			end if
			%>

			<div class="form-group m-form__group" style="text-align: center;width: 100%;"> 
				<input type="button" class="btn btn-metal" value="ใช้ราคาเดียวกับหมายเลข...." style="cursor:hand;width: 200px;" onClick="SearchPlayer()">
				<input type="hidden" name="use_same_this" value="">
				<input type="button" class="btn btn-metal" value="ใช้ราคานี้ทั้งหมด" style="cursor:hand;width: 200px;" onClick="clickuse_same_this('<%=GetGameDesc(game_type)%>')">
				<input type="hidden" name="rec_ticket" id="rec_ticket" value="<%=rec_ticket%>">
				<input type="button" class="btn btn-metal" value="เข้าคิวรอรับโพย" style="cursor:hand; width: 120px;" id="p_rec_ticket" name="p_rec_ticket" onClick="clickrec_ticket(document.form1.rec_ticket.value)">
				<input type="button" class="btn btn-metal" value="บันทึกข้อมูล" name="OK" style="cursor:hand; width: 100px;" onClick="clickok();">
			</div>
		
		</div>

</form>

<div class="modal fade" id="playerModal" tabindex="-1" role="dialog" aria-labelledby="numberModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">

      <div id="modalbody" class="modal-body">
          	<IFRAME marginWidth=0 src="search_player.asp?dealer_id=<%=dealer_id%>&game_type=<%=game_type%>" 
                        width="100%" height="400px" name="mess" style="width: 100%; float: right;border: none;">
            </IFRAME>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">ปิด</button>
      </div>
    </div>
  </div>
</div>

<script language="javascript">
function SearchPlayer(){		


	$("#playerModal").modal("show");

	//openDialog('search_player.asp?dealer_id=<%=dealer_id%>&game_type=<%=game_type%>', 8, 5, 250, 400);
}
function clickrec_ticket(p){
	var t=p

	if (t=="2"){

		document.form1.rec_ticket.value="1" // รอคิวก่อนรับ
	}else{

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
			}
			else if (obj.id.substring(0,3)=='idR'){
				next=1
				idX='idS'		
			}
			else if (obj.id.substring(0,3)=='idS'){
				next=1
				idX='idT'		
			} else{
				return;
			}
		}
		id=idX+next
		next_obj = document.getElementById(  id )	
		next_obj.focus();
	}
}
	
</script>


<% end Sub  %>



