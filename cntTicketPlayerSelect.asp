<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	Dim player_id
	player_id=Request("player_id")
%>
<script language="javascript">


    function chgcolor(obj) {



        var id, oth_button, i
        for (i = 1; i <= 31 ; i++) {
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> :: ยอดสรุปเป็นใบ : คนแทง :: </TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script src="include/js_function.js" language="javascript"></script>
    <style type="text/css">
        .style1
        {
            font-size: large;
            vertical-align: middle:
        }
        .style2
        {
            font-size: large;
            text-align: center;
        }
    </style>
</HEAD>

<BODY>
<table width="300" cellpadding="1" cellspacing="1" align="center" >
<% if len(trim(Session("logid"))) <8 then %>
<tr>
    <td height="70"></td>
</tr>
<tr>
<td class="inputB2" align="center" valign="middle" height="30px" width="400px">
    <a href="cntTicketPlayerID.asp?player_id=<%=player_id%>" target="_blank" class="style1">
    <div style="width:100%; height: 100%"
        class="style2">ของตัวเอง</div></a></div></td>
</tr>
<tr>
    <td height="20"></td>
</tr>
<tr>
<td class="inputB1" align="center" valign="middle" height="30px" width="400px">
    <a href="cntTicketPlayerIDLevel2.asp?player_id=<%=player_id%>" target="_blank" class="style1">
    <div style="width:100%; height: 100%"
        class="style1">ของลูกค้าย่อย</div></a></td>
</tr>
<tr>
    <td height="20"></td>
</tr>
<% else %>
	<tr>
        <td class="inputB3" align="center" valign="middle" height="30px" width="400px">
        <a href="cntTicketPlayerIDLevel2.asp?player_id=<%=player_id%>" target="_blank" class="style1">
        <div style="width:100%; height: 100%"
                class="style1">ของลูกค้าย่อย</div></a>
        </td>
    </tr>
<% end if %>
</table>
</BODY>
</HTML>
<script language="javascript">
    function click_player(player_id, page) {
        MyArgs = window.showModalDialog(page + '?player_id=' + player_id, '', 'dialogTop:' + 200 + 'px;dialogLeft:' + 0 + 'px;dialogHeight:500px;dialogWidth:1000px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');

    }
</script>