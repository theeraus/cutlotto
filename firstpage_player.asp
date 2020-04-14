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
'showstr "xxx " & Session("gameid")
	SQL="select game_id from tb_open_game where dealer_id=" & Session("did") & " and game_active='A' "

	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Session("gameid")=objRS("game_id")
	end if	

	Dim mode, page_from
	page_from=Request("page_from")
	mode="computer"
	'mode=Request("mode")
	if mode<>"" then
		if mode="tel" then
			Session("istelephone")=1		
		else	
			Session("istelephone")=0
		end If
		If page_from="index" Then
		%>
		<script language="javascript">
			window.open("key_player.asp","bodyFrame");
		</script>
		<%
		else
		%>
		<script language="javascript">
			top.location.href="index.asp?page=key_player.asp";
		</script>
		<%
		End if
	end if
%>

    <script language="javascript">


        function chgcolor(obj) {

            var id, oth_button, i
            for (i = 1; i <= 31; i++) {
                id = "but" + i
                oth_button = document.getElementById(id)
                if (oth_button != null) {
                    oth_button.className = "inputB"
                }

            }

            but3.className = "button_red"
            but4.className = "input_pink"
            but5.className = "input_pink"
            but7.className = "input_01"
            but8.className = "input_pink"
            but9.className = "button_red"
            but10.className = "input_pink"
            but11.className = "input_pink"
            but12.className = "input_blue"
            but13.className = "inputB"
            but20.className = "input_violet"
            but27.className = "input_blue"
            but23.className = "inputB"
            but24.className = "input_blue"
            but25.className = "input_blue"
            but26.className = "input_blue"
            but29.className = "input_green"
            but32.className = "inputB"

            obj.className = "button_red"
        }
	
</script>

<html>
<head>
<title>.:: คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script type="text/javascript">
//close window
//function window.onload()
//{
//    window.attachEvent("onbeforeunload", Close);
//}
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

</head>
<body topmargin="0"  leftmargin="0" onbeforeunload="closer();">
	<center><br><br><br>
		<table border="0" width="270"  align="absmiddle">							
			<tr>
				<td align="left"><img src="images/welcome.JPG"></td>
			</tr>
			<tr>
				<td align="left" class="tdbody">&nbsp;&nbsp;ชื่อ : 
				<%=GetPlayer_Name(player_id)%>
				</td>
			</tr>
			<form name="form1" action="firstpage_player.asp" method="post">
			<input type="hidden" name="mode">
			<input type="hidden" name="page_from" value="<%=page_from%>">
			
			<tr>
				<td align="left"><img src="images/use_com.JPG" style="cursor:hand;" onClick="click_use_com('computer');"></td>
			</tr>
			<tr>
				<td align="left"><img src="images/use_tel.JPG" style="cursor:hand;" onClick="click_use_com('tel');"></td>
			</tr>
			</form>
		<table>
	</center>
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
%>
<script language="javascript">
function click_use_com(mode){
	document.form1.mode.value=mode
	document.form1.submit();
	//window.open('index.asp?page=view_player.asp?use_com='+i,'_top')
}
</script>
<script language="JavaScript">
function chkKey(){
	 if (document.all){
	  kc = event.keyCode; // IE
	 }else{
	  kc = e.which; // NS or Others
	 } 
	 // ค่า kc คือค่า Unicode Charactor ที่เป็นตัวเลข

	 //alert("คุณกำลังกด key ที่มีค่า "+kc+" ซึ่งแปลงเป็นตัวอักษรคือ"+String.fromCharCode(kc));
	 if (kc=='49' || kc=='97')	{
		click_use_com('computer');
	 }	
	if (kc=='50' || kc=='98')	{
		click_use_com('tel');
	 }	
}
	document.onkeydown=chkKey
	window.focus();
</script>