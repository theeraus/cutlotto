<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%Response.Buffer = True%>
<!--#include file="adovbs.inc"-->

<SCRIPT LANGUAGE=vbscript RUNAT=Server>
'	sub ExcuteCommand(Byval strSql) 
	dim rs
	dim comm	
	dim strSql
	
		'Set rs = server.createobject("ADODB.Recordset")
		Response.Write Request.Form("mSql")
		Set comm = CreateObject("ADODB.Command")	
		comm.ActiveConnection = Application("constr")
		comm.CommandText = Request("mSql")
		comm.CommandType = adCmdText
		comm.Execute
		If Err.number = 0 Then	
			Response.Write "�ѹ�֡���º��������"
		end if		
		set comm = nothing
		'Response.Write " goto " & Request("myGoto")
		'Response.End
		Response.Redirect Request("myGoto")
'	End sub
</Script>

