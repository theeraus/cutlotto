<%OPTION EXPLICIT%>
<%
   response.ContentType="text/html; charset=windows-874" 
%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<%'check_session_valid()%>
<!--#include file="mdlGeneral.asp"-->
<%
	Dim objRS , objDB , SQL,create_by, modeshow,deluser_id
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	create_by=Request("user_id")
	modeshow=Request("modeshow")
	
	deluser_id=Request("deluser_id")
	If deluser_id<>"" Then
		SQL="delete from sc_user where user_id=" & deluser_id
		objDB.Execute(SQL)
	End If 
	If Request("modeshow")="level2" Then
		SQL="select * from sc_user where create_by_player=" & create_by & " and user_type='P' order by login_id"
	else
		SQL="select * from sc_user where create_by=" & create_by & " and user_type='P' order by login_id"
	End if
	Set objRS=objDB.Execute(SQL)
%>
<html>
<head>
<title>.:: คนแทง : เปลี่ยน password ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function blinkIt() {
 if (!document.all) return;
 else {
   for(i=0;i<document.all.tags('blink').length;i++){
      s=document.all.tags('blink')[i];
      s.style.visibility=(s.style.visibility=='visible')?'hidden':'visible';
   }
 }
}
</script>
</head>
<body topmargin="0"  leftmargin="0" onload="setInterval('blinkIt()',500)">

	
<% If  Not objRS.eof  then%>
	<table  border="0"  cellpadding="1" cellspacing="1"    bgcolor="#004080">		
		<tr>
			<td class="head_black" align="center"  bgcolor="#F5F5F5">ลบรายการ</td>
			<td class="head_black" align="center"  bgcolor="#F5F5F5">หมายเลข</td>
			<td class="head_black" align="center" bgcolor="#F5F5F5">ชื่อ</td>
			<td class="head_black" align="center" bgcolor="#F5F5F5">Password</td>
			<td class="head_black" align="center" bgcolor="#F5F5F5">รหัสลับ</td>
			<td class="head_black" align="center" bgcolor="#F5F5F5" >ยอดรับแทง </td>	

		</tr>
	<%
		Dim st_blink,ed_blink
		While Not objRS.eof 
			If objRS("is_online")="1" Then ' blink 
				st_blink="<font color='red'>" '"<blink>"
				ed_blink="</font>" '"</blink>"
			Else
				st_blink=""
				ed_blink=""
			End If 
	%>
		<tr>
			<td class="tdbody" align='center'><span style="cursor:hand;"   onClick="click_del_det('<%=create_by%>','<%=modeshow%>','<%=objRs("user_id")%>', '<%=objRs("user_name")%>');" class="head_blue">ลบ</span></td>
			<td class="tdbody" style="width:90px;"><%=objRS("login_id") %></td>
			<td class="tdbody" style="width:130px;"><%=st_blink %><%=objRS("user_name")%><%=ed_blink %></td>
			<td class="tdbody" style="width:130px;"><%=objRS("user_password")%></td>
			<td class="tdbody" style="width:130px;"><%=objRS("sum_password")%></td>
			<td class="tdbody" style="width:130px;" align="right"><%=FormatNumber(objRS("limit_play"),0)%>&nbsp;</td>
		</tr>
	<%
			objRS.MoveNext
		Wend 
	%>
	</table>
<% End If %>

</body>
</html>
