<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<% Response.CodePage = 65001%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<HTML>
<HEAD>
<meta http-equiv="refresh" content="" />
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="JavaScript" src="include/js_function.js"></script>
<BODY>
<center><br>
<%
Dim dealer_id
dealer_id=Request("dealer_id")
If dealer_id="" Then Response.End 
Dim objRS , objDB , SQL	
set objDB=Server.CreateObject("ADODB.Connection")       
objDB.Open Application("constr")
Set objRS =Server.CreateObject("ADODB.Recordset")		
Dim dealer_name
SQL="select * from sc_user where user_id=" & dealer_id
Set objRS=objDB.Execute(SQL)
If Not objRS.eof Then
	dealer_name=objRS("user_name")
End If 
Response.Write "<font class=head_blue>" & dealer_name & "</font><br>"
SQL="select * from tb_clear_number where dealer_id=" & dealer_id & " order by id"
Set objRS=objDB.Execute(SQL)
If Not objRS.eof Then 
	Response.Write "<table class=normal bgcolor='#C9C9C9' width='400'  cellpadding=1 cellspacing=1>"
	Response.Write "<tr bgcolor='#DFBFBF'>"
	Response.Write "<th>วันที่ตรวจเลข</th>"
	Response.Write "<th>ยอด</th>"
	Response.Write "<th>ใช้จริง</th>"
	Response.Write "</tr>"
	While Not objRS.eof
		Response.Write "<tr bgcolor='#FFFFFF'>"
		Response.Write "<td>" & objRS("c_date") & "</td>"
		Response.Write "<td align='right'>" & FormatNumber(objRS("admin_limit"),0) & "&nbsp;</td>"
		Response.Write "<td align='right'>" & FormatNumber(objRS("play_amt"),0) & "&nbsp;</td>"
		Response.Write "</tr>"
		objRS.MoveNext
	Wend 
	Response.Write "</table>"
End If 
%>
</center>
</BODY>
</HTML>