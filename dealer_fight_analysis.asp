 <%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<%

Dim objRs
Dim strSql
dim cntrow, cntcol
	Set objRs = Server.CreateObject ("ADODB.Recordset")

	strSql = "exec spA_GetFightAnalysis  " & Session("gameid") & ",'" & Request("uptype") & "'," &  Session("uid") & "," & Request("suu") & ", " &   Request("ses")
'showstr strSql
	set objRs = conn.Execute(strSql)
%>

<HTML>
<HEAD>
<Title>��������</Title>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="javascript">
	function cmdsave_click() {
		if (isNaN(document.form1.txtseq1.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtseq1.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq2.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtseq2.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq3.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtseq3.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq4.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtseq4.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum1.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtnum1.focus();
			return false;
		} 

		if (isNaN(document.form1.txtnum2.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtnum2.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum3.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtnum3.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum4.value)) {
			alert("��س��кص���Ţ !!!")
			document.form1.txtnum4.focus();
			return false;
		} 
		document.form1.act.value="save";
		document.form1.submit();
	}
	
</script>
</HEAD>
<BODY topmargin=0 leftmargin=0>
<FORM METHOD=POST ACTION="" Name="form1" >	
<INPUT TYPE="hidden" name="act" value="">
	<TABLE width='100%' align=center class=table_blue bgColor="#FFFFFF">
		<TR>
			<Td class=head_blue align=center>��������<%=iif(Request("uptype")="U","��","��ҧ")%></Td>
		</TR>
		<TR>
			<Td>
				<TABLE width='100%' align=center  bgColor="#FFFFFF">
					<TR class=head_black>
						<Td>�ʹᷧ  = </Td>
						<Td><%=formatnumber(objRs("sum_befordisc"),0)%></Td>
						<Td>�ҷ</Td>
					</TR>
					<TR class=head_black>
						<Td>�ʹᷧ�ѡ %</Td>
						<Td><%=formatnumber(objRs("sum_receive"),0)%></Td>
						<Td>�ҷ</Td>
					</TR>
				</Table>
			</Td>
		</Tr>
		<TR>
			<Td>
				<TABLE width='100%' align=center class=text_blue  bgColor="#FFFFFF">
					<TR>
						<Td class=table_blue>&nbsp;</Td>
						<Td class=table_blue align=center>�� &nbsp;&nbsp;<%=formatnumber(objRs("per_plus"),1)%>&nbsp;&nbsp;%</Td>
						<Td class=table_blue align=center>���� &nbsp;&nbsp;<%=formatnumber(objRs("per_minus"),1)%>&nbsp;&nbsp;%</Td>
					</TR>
					<TR>
						<Td class=table_blue>�٧�ش</Td>
						<Td class=table_blue align=right><%=formatnumber(objRs("max_plus"),1)%></Td>
						<Td class=table_blue align=right><font color=red><%=formatnumber((objRs("min_minus")),1)%></font></Td>
					</TR>
					<TR>
						<Td class=table_blue>�����</Td>
						<Td class=table_blue align=right><%=formatnumber(objRs("avg_plus"),1)%></Td>
						<Td class=table_blue align=right><font color=red><%=formatnumber((objRs("avg_minus")),1)%></font></Td>
					</TR>
					<TR>
						<Td class=table_blue>����ش</Td>
						<Td class=table_blue align=right><%=formatnumber(objRs("min_plus"),1)%></Td>
						<Td class=table_blue align=right><font color=red><%=formatnumber((objRs("max_minus")),1)%></font></Td>
					</TR>
				</Table>
			</Td>
		</Tr>
		<TR>
			<Td>
				<TABLE width='100%' align=center  bgColor="#FFFFFF">
					<TR class=head_black>
<%'showstr objRs("over_amt")%>
						<Td>�繵�� =&nbsp;&nbsp;<%=formatnumber(((cdbl(objRs("over_amt"))*100) / cdbl(objRs("sum_receive"))),2)%>  %&nbsp;&nbsp;&nbsp;</Td>
						<Td></Td>
						<Td>&nbsp;&nbsp;<%=formatnumber(objRs("over_amt"),2)%>&nbsp;&nbsp;�ҷ</Td>
					</TR>
				</Table>
			</Td>
		</Tr>
	</Table>
</FORM>	

</BODY>
</HTML>
<%
	objRs.Close
%>