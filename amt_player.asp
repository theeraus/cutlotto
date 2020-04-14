<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"
	Dim show_type
	show_type=Request("show_type")
	Response.Redirect("amt_player_result.asp?show_type=" & show_type & "&uid=" & Session("uid"))
%>