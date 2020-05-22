<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim dealer_id, game_id
	dealer_id=Session("uid")
	game_id=Session("gameid")
	SQL="exec spJCntTicketByPlayerOfDealer " & game_id	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> :: ยอดสรุปเป็นใบ :: </TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script src="include/js_function.js" language="javascript"></script>
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script language="javascript">
    function click_player(player_id) {
        var ParmA = ""; //document.form1.proj_code.value;
        var ParmB = "";
        var ParmC = '';
        var MyArgs = new Array(ParmA, ParmB, ParmC);

        //	MyArgs=window.showModalDialog('cntTicketPlayerID.asp?player_id='+player_id, '', 'dialogTop:'+200+'px;dialogLeft:'+0+'px;dialogHeight:500px;dialogWidth:1000px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');

        //location('index.asp?page=cntTicketPlayerID.asp?player_id='+player_id);
        //location = 'cntTicketPlayerID.asp?player_id='+player_id;

        window.open("cntTicketPlayerID.asp?player_id=" + player_id, "_blank", "top=150,left=150,height=520,width=650,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");


        if (MyArgs == null) {
            //	window.alert(
            //	  "Nothing returned from child. No changes made to input boxes")
        }
        else {
            //document.form1.proj_code.value=MyArgs[0].toString();
        }

    }

function chgcolor(obj) {



    var id, oth_button, i
    for (i = 1; i <= 31; i++) {
        id = "but" + i
        oth_button = document.getElementById(id)
        if (oth_button != null) {
            oth_button.className = "inputB"
        }


    }


    but3.className = "input_01"
    but4.className = "input_pink"
    but5.className = "input_pink"
    but7.className = "input_01"
    but8.className = "input_pink"
    but20.className = "input_violet"
    but27.className = "input_blue"
    but24.className = "input_blue"
    but25.className = "input_blue"
    but26.className = "input_blue"
    but29.className = "input_green"
    but32.className = "inputB"


    obj.className = "button_red"
}

</script>
</HEAD>  

<BODY>
	<center>
	<TABLE  border="0"  cellpadding="5" cellspacing="1" width="30%">
	<TR>		
		<Th class="text_black" colspan="3">&nbsp;</Th>
	</TR>
	<TR bgcolor="red">		
		<Th class="head_white" colspan="2">รายชื่อคนแทง</Th>
		<Th width="28%" class="head_white">จำนวนใบ</Th>
	</TR>
	<%
    dim l
    dim tmpRowColor
    dim tmpColColor
    dim tmpColColor2
    tmpColColor="#ff9999"
    tmpColColor2="#ffcccc"
    l=0
	Set objRS=objDB.Execute(SQL)
	While Not objRS.eof

    IF l mod 2 = 1 then
        tmpRowColor = tmpColColor2
    else
        tmpRowColor = tmpColColor
    end if 
	%>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=<%=tmpRowColor%> onClick="click_player('<%=objRS("player_id")%>')">
		<TD width="24%" align="center"><%=objRS("login_id")%></TD>
		<TD width="48%"><%=objRS("user_name")%></TD>
		<TD align="center"><%=objRS("cntTicket")%></TD>
	</TR>
	<%
    l = l + 1
		objRS.MoveNext
	wend
	%>
		<tr style="height:29;">
			<td colspan="3" align="center">
			<input type="button" class="btn btn-primary btn-sm" value="พิมพ์" style="cursor:hand; width: 75px;"
			onClick="self.print();"
			>
			</td>
		</tr>
	</TABLE>
	</center>
</BODY>
</HTML>
