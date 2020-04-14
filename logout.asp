<%OPTION EXPLICIT%>
<!--#include file="include/config.inc"-->
<%
		if trim(Session("uid"))="" then 
            session.abandon
    	    response.redirect "signin.asp"
        endif

		Dim objRS , objDB , SQL	
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		If Session("utype")="K" Then
			SQL="update sc_user set  is_online=0,cnt_dealer = cnt_dealer - 1 where [user_id]=" & Session("key_id")
		else
			SQL="update sc_user set  is_online=0,cnt_dealer = cnt_dealer - 1 where [user_id]=" & Session("uid")
		End If 
		set objRS=objDB.Execute(SQL)
		set objRS=nothing
		set objDB=Nothing
		session.abandon
%>
<script language="javascript">
	self.close()
	//window.open('index.asp',"_top")
</script>