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

Dim objRec
Dim strSql
dim cntrow, cntcol
	Set objRec = Server.CreateObject ("ADODB.Recordset")

	if Request("act") = "save" then
		strSql = "exec spA_SaveFightValue " & Request("uid") & ", '" & Request("txtnumtype1") & "', " & Request("txtseq1") & ", " &  Request("txtnum1") & ", " & Request("txttem1") & ", 'Y'"
		set objRec = conn.Execute(strSql)
		strSql = "exec spA_SaveFightValue " & Request("uid") & ", '" & Request("txtnumtype2") & "', " & Request("txtseq2") & ", " &  Request("txtnum2") & ", " & Request("txttem2") & ", 'N'"
		set objRec = conn.Execute(strSql)
		strSql = "exec spA_SaveFightValue " & Request("uid") & ", '" & Request("txtnumtype3") & "', " & Request("txtseq3") & ", " &  Request("txtnum3") & ", " & Request("txttem3") & ", 'N'"
		set objRec = conn.Execute(strSql)
		strSql = "exec spA_SaveFightValue " & Request("uid") & ", '" & Request("txtnumtype4") & "', " & Request("txtseq4") & ", " &  Request("txtnum4") & ", " & Request("txttem4") & ", 'N'"
		set objRec = conn.Execute(strSql)

	end if
	
	strSql = "exec spA_GetFightValue " &  Request("uid")
	set objRec = conn.Execute(strSql)

%>
<HTML>
<HEAD>
<Title>ตั้งค่าสู้บน</Title>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="javascript">
	function cmdsave_click() {
		if (isNaN(document.form1.txtseq1.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtseq1.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq2.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtseq2.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq3.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtseq3.focus();
			return false;
		} 
		if (isNaN(document.form1.txtseq4.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtseq4.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum1.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtnum1.focus();
			return false;
		} 

		if (isNaN(document.form1.txtnum2.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtnum2.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum3.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtnum3.focus();
			return false;
		} 
		if (isNaN(document.form1.txtnum4.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtnum4.focus();
			return false;
		} 
		document.form1.act.value="save";
		document.form1.submit();
	}
	
</script>
</HEAD>
<BODY topmargin=0 leftmargin=0 onLoad="document.all.txtnum1.focus();">
<FORM METHOD=POST ACTION="dealer_setvalue_fight.asp" Name="form1" >	
<INPUT TYPE="hidden" name="uid" value="<%=Request("uid")%>">
<INPUT TYPE="hidden" name="act" value="">
	<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
		<TR>
			<Td  bgColor=#ff7777 align=center><strong>ตั้งค่าสู้บน</strong></Td>
		</Tr>
		<TR>
			<Td>
				<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
					<TR bgColor=#ff7777>
						<TD align=center><strong>ชนิด</strong></TD>						
						<TD align=center><strong>ลำดับ</strong></TD>						
						<TD align=center><strong>ตัวที่</strong></TD>						
						<TD align=center><strong>เต็ม</strong></TD>						
					</Tr>

<%
	dim cnt
	cnt = 0
	do while not objRec.Eof
		cnt = cnt +1
		Response.write "<TR class=text_black>"
		Response.write "<INPUT TYPE='hidden' name='txtnumtype" &cnt&"' value=" &  objRec("ref_code") & ">"
		Response.write "<Td>" & objRec("ref_det_desc")& "</Td>"
		Response.write "<Td align=center><INPUT TYPE='text' NAME='txtseq" &cnt&"' style='width:50' value=" & objRec("seq") & "></Td>"
		Response.write "<Td align=center><INPUT TYPE='text' NAME='txtnum" &cnt&"' style='width:50' value=" & objRec("number_seq") & "></Td>"
		Response.write "<Td align=center><INPUT TYPE='text' NAME='txttem" &cnt&"' style='width:50' value=" & objRec("tem") & " readonly></Td>"
		Response.write "</TR>"
		objRec.Movenext
	loop
	objRec.Close
	if Request("fromup") = "" then
%>

					<TR>
						<TD colspan=4 align=center><INPUT TYPE="button" class="inputG" value="บันทึก" name="cmdsave" style="cursor:hand; width: 100px;" onClick="cmdsave_click();">&nbsp;<INPUT TYPE="button" class="inputR" value="ปิด" name="cmdcancel" style="cursor:hand; width: 75px;" onClick="window.close();"></Td>
					</Tr>
<%
	end if
%>					
				</Table>
			</Td>
		</Tr>
	</Table>
</FORM>	

</BODY>
</HTML>
