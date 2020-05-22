<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<%
		Dim limit_play, sum_play, can_play
		Dim objRS , objRS1, objDB , SQL, dealer_id, game_type	, from_click_submit, chr_search
		Dim call_from
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		Set objRS1 =Server.CreateObject("ADODB.Recordset")
		dealer_id=Request("dealer_id")
		game_type=Request("game_type")
		from_click_submit=Request("from_click_submit")
		chr_search=Request("chr_search")
		call_from = Request("call_from")
%>
<script>
	function set_focus(){
		document.form1.chr_search.focus();
	}
</script>
<html>
<head>
<title>.:: ค้นหา : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script>
function select_player(player_id,call_from){	
	document.form1.action="search_player_bydealer_Action.asp?player_id="+player_id+'&call_from='+call_from
	document.form1.submit();	
	}
</script>

<link rel="stylesheet" href="jquery/jquery.treeview.css" />
    <link rel="stylesheet" href="jquery/red-treeview.css" />
	<link rel="stylesheet" href="screen.css" />
	
	<script type="text/javascript" src="jquery/jquery.min.js"></script>
	<script src="lib/jquery.cookie.js" type="text/javascript"></script>
	<script src="jquery/jquery.treeview.js" type="text/javascript"></script>

	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	
	<script type="text/javascript">
		$(function() {
			$("#tree").treeview({
				collapsed: true,
				animated: "medium",
				control:"#sidetreecontrol",
				prerendered: true,
				persist: "location"
			});
		})
		
	</script>

    <style type="text/css">
        .auto-style1 {
            FONT-FAMILY: Arial, "MS Sans Serif", Thonburi;
            COLOR: #FFFFFF;
            FONT-SIZE: 11pt;
        }
    </style>

</head>
<body topmargin="0" leftmargin="0" scroll = no  style="border : solid #606060; border-width : 1px;" onLoad="set_focus();"> 
	<form name="form1" action="search_player_bydealer.asp" method="post">
	<table align="center" cellpadding="0" cellspacing="0" width="100%" border="0" class="table">
	<tr bgcolor="#fd397a">
			<td height="25" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="auto-style1"><h5>ค้นจาก ชื่อ หรือ นามสกุล</h5></td>
						<td  align="right"><img src="images/close.gif" align="absmiddle" style="cursor:hand; " onClick="parent.closeDialog()">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="10">
			<td></td>
		</tr>
		<tr>
			<td align="center" >			

				<table width="95%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
					<input type="hidden" name="from_click_submit" value="yes">
					<input type="hidden" name="game_type" value="<%=game_type%>">
					<input type="hidden" name="dealer_id" value="<%=dealer_id%>">
					<input type="hidden" name="call_from" value="<%=call_from%>">
					
					<tr>
						<td bgcolor="#ffd8cc" style=" text-align: center;">
							<input type="text" size="10" name="chr_search" class="form-control">
							<p style="margin: 10px;">
								<input type="button" class="btn btn-primary btn-sm" value="ค้นหา" onClick="clickOK()" style="cursor:hand;width: 75px;">
							&nbsp;&nbsp;<input type="button" class="btn btn-primary btn-sm" value="ยกเลิก" onClick="clickCancel()" style="cursor:hand;width: 75px;">
							</p>
							
						</td>
					</tr>
					<tr>
						<td bgcolor="#ffd8cc" align="center">
						<div style="width:100%;height:560 ;overflow:auto;" >
						<table width="99%"  border="0" cellspacing="0" cellpadding="0" > 
							<tr bgcolor="#FFFFFF"><td>
					<%
						if from_click_submit<>"yes" then ' ถ้าเข้ามาครั้งแรกให้แสดง ทุก player 
							SQL=" select login_id, "
							SQL=SQL & "	[user_id] player_id, "
							SQL=SQL & "	[user_name] player_name  "
							SQL=SQL & "	from sc_user a "
							SQL=SQL & "	where a.create_by=" & dealer_id & " and a.user_type='P' "
							SQL=SQL & " and a.create_by_player=0 "
							SQL=SQL & "	order by a.login_id "
							set objRS=objDB.Execute(SQL)
						else
							
							'SQL="exec spJSelectPlayerByPName " & dealer_id & ", " & Session("gameid")	  & ",'" & chr_search & "'"
							SQL=" select login_id, "
							SQL=SQL & "	[user_id] player_id, "
							SQL=SQL & "	[user_name] player_name  "
							SQL=SQL & "	from sc_user a "
							SQL=SQL & "	where a.create_by=" & dealer_id & " and a.user_type='P' "
							SQL=SQL & " and login_id like '" & chr_search & "%' "
							SQL=SQL & " and a.create_by_player=0 "
							SQL=SQL & "	order by a.login_id "

							set objRS=objDB.Execute(SQL)
							If not objRS.eof	Then
								If objRS.recordcount=1 then														
									%>
									<script language="javascript">
										select_player('<%=objRS("player_id")%>','<%=call_from%>');
										</script>
									<%
								End if
							End if
						end if	

						Dim send, receive, wait, ret, total, tnumber									
						%>
						<div id="main">
						<div id="sidetree">
						  <div class="treeheader"></div>
						  <ul class="treeview" id="tree">
						<%
						while not objRS.eof								
							%>
							<li class="expandable"><div class="hitarea expandable-hitarea"></div><span class="tdbody" onClick="select_player('<%=objRS("player_id")%>','<%=call_from%>'	)" style="cursor:hand;"><%=objRS("login_id")%><%=objRS("player_name")%></span>
							<%
							SQL=" select login_id, "
							SQL=SQL & "	[user_id] player_id, "
							SQL=SQL & "	[user_name] player_name  "
							SQL=SQL & "	from sc_user a "
							SQL=SQL & "	where a.create_by=" & dealer_id & " and a.user_type='P' "
							SQL=SQL & " and login_id like '" & chr_search & "%' "
							SQL=SQL & " and a.create_by_player=" & objRS("player_id")
							SQL=SQL & "	order by a.login_id "
							Set objRS1=objDB.Execute(SQL)
							while not objRS1.eof		
							%>
								<ul style="display: none;"><li><span class="tdbody"  onClick="select_player('<%=objRS1("player_id")%>','<%=call_from%>'	)" style="cursor:hand;"><%=objRS1("login_id")%><%=objRS1("player_name")%></span></li></ul>
							<%
								objRS1.MoveNext
							Wend 
							%></li>						
							<%
							objRS.MoveNext
						wend
					%>											
						</ul>
						</div>
						</div>
								</td></tr>
							</table> 
						</td>
					</tr>
				</table>
			</td>		
		</tr>
	</table>
	</center>
	</form>
</body>
</html>
<script language="javascript">
	function clickOK(){
		document.form1.submit();
	}
	function clickCancel(){
	parent.closeDialog();
	}
	
</script>
<%
Function GetSend(p,g)
	if p="" then
		GetSend=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetSend " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetSend = objRS("send")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReceive(p,g)
	if p="" then
		GetReceive=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReceive " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReceive = objRS("receive")
	else
		GetReceive=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReturn(p,g)
	if p="" then
		GetReturn=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReturn " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReturn = objRS("returned")
	else
		GetReturn=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetTotalPlay(p,g)
	if p="" then
		GetTotalPlay=0
		exit function
	end if
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetTotalPlay " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalPlay = objRS("total_play_amt")
	else
		GetTotalPlay=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function Getticket_number( p, g )
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetticket_number " & p & "," & g & ",1"
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	else
		Getticket_number=0
	end if
	set objRS=nothing
	set objDB=nothing
End Function

%>
<script language="vbscript">
	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>
<script language="javascript">
function convert_number(obj){
	var value=obj;
		if(value!=""){							
			return formatnum(value) ;		   
		}
}	
</script>