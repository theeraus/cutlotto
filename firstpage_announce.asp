<!--#include virtual="masterpage.asp"-->
<!--#include file="activate_time.asp"-->
<% Sub ContentPlaceHolder() %>

<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
%>

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

<div class="alert alert-danger" role="alert">
	<div class="alert-text">
		<h4 class="alert-heading">ประกาศ!</h4>
		<p><%=Getmessalert(player_id)%></p>
		<hr>
		<p class="mb-0"><%=Getmessalert_dealer(player_id)%></p>
	</div>
</div>





<% End Sub  %>