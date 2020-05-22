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

	If Request("modeshow")="level2" Then
		SQL="select * from tb_money_value where dealer_id=" & create_by & " order by money_date desc"
	else
		SQL="select * from tb_money_value where dealer_id=" & create_by & " order by money_date desc"
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
			<td class="head_black" align="center"  bgcolor="#F5F5F5">ดีลเลอร์</td>
            <td class="head_black" align="center" bgcolor="#F5F5F5" >วันที่</td>	
			<td class="head_black" align="center" bgcolor="#F5F5F5">เติมเงินเข้า</td>
			<td class="head_black" align="center" bgcolor="#F5F5F5" >ตัดเงินออก</td>
            <td class="head_black" align="center" bgcolor="#F5F5F5" >หมายเหตุ</td>		
		</tr>
	<%
		Dim st_blink,ed_blink
		While Not objRS.eof 
			If objRS("money_add")="0" Then ' blink 
				st_blink="<font color='red'>" '"<blink>"
				ed_blink="</font>" '"</blink>"
			Else
				st_blink="<font color='green'>"
				ed_blink="</font>"
			End If 
	%>
		<tr>
			<td class="tdbody" style="width:90px;"><%=objRS("dealer_id") %></td>
            <td class="tdbody" style="width:150px;"><%=objRS("money_date") %></td>
            <td class="tdbody" style="width:90px;"><%=st_blink %><%=objRS("money_add")%><%=ed_blink %></td>
            <td class="tdbody" style="width:90px;"><%=st_blink %><%=objRS("money_out")%><%=ed_blink %></td>
			<td class="tdbody" style="width:200px;"><%=st_blink %><%=objRS("remark")%><%=ed_blink %></td>
		</tr>
	<%
			objRS.MoveNext
		Wend 
	%>
	</table>
<% End If %>

</body>
</html>
