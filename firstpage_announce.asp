<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
	<!--#include file="mdlGeneral.asp"-->
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>
	<!--#include file="activate_time.asp"-->
<%
	Dim player_id
	player_id=Session("uid")

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="select game_id from tb_open_game where dealer_id=" & Session("did") & " and game_active='A' "

	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Session("gameid")=objRS("game_id")
	end if	

%>

<html>
<head>
<title>ประกาศ</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>

	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	
<script type="text/javascript">

function Close()
{
return 'Are you sure you want to close my lovely window?'
}
function closer() {
	if(document.form1.mode.value==''){
		if(document.form1.page_from.value!='index'){
			//alert(' First Page Player This window is about to close.' ); 
			window.open('logout.asp');
		}
	}
}
//close window
</script>

    <style type="text/css">
        .style1
        {
            FONT-FAMILY: Arial, "MS Sans Serif", Thonburi;
            COLOR: Red;
            FONT-SIZE: large;
        }
        .style2
        {
            font-size: medium;
            color: Blue;
        }
        .style3
        {
            font-size: medium;
            color: Red;
        }
    </style>

</head>
<body topmargin="0"  leftmargin="0" onbeforeunload="closer();">
		<table border="0" width="70%"  align="center" bgcolor="#cccccc"
        style="height: auto; margin-top: 15%;">							
			<tr>
				<td align="center" class="style1"><strong>ประกาศ</strong></td>
			</tr>
			<form name="form1" action="firstpage_announce.asp" method="post">
			<tr>
				<td align="center" class="style1">&nbsp;</td>
			</tr>
			<tr>
				<td align="center" class="style3"><strong><%=Getmessalert(player_id)%></strong></td>
			</tr>
			<tr>
				<td align="center" class="style3">&nbsp;</td>
			</tr>
			<tr>
				<td align="center" class="style2"><strong><%=Getmessalert_dealer(player_id)%></strong></td>
			</tr>
			</form>
		</body>
</html>
<%
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
%>
