<%
sub activate_time
	Dim objRS , objDB , SQL		
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")		
	SQL="update sc_user set activate_time=getdate() where [user_id]=" & Session("uid")
	set objRS=objDB.Execute(SQL)
	set objRS=nothing
	set objDB=nothing
end sub
call activate_time
%>