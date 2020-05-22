<%@ Language=VBScript CodePage = 65001  %>
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
Response.ContentType = "text/html"
Response.AddHeader "Content-Type", "text/html;charset=UTF-8"
Response.CodePage = 65001
Response.CharSet = "UTF-8"
Dim objRec
Dim strSql
dim cntrow, cntcol
dim madd, mout
	Set objRec = Server.CreateObject ("ADODB.Recordset")

	if Request("act") = "save" then
        if Request("txtnum1") <> "" then
            madd  = Request("txtnum1")
        else
            madd  = 0
        end if
        if Request("txttem1") <> "" then
            mout  = Request("txttem1")
        else
            mout  = 0
        end if
		strSql = "exec spA_SaveMoneyValue " & Request("uid") & ", '1'," &  madd & ", " & mout & ",'" & Request("txtremark") & "'"
		set objRec = conn.Execute(strSql)
	end if

%>
<HTML>
<HEAD>
<Title>เติมเงิน</Title>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<script language="javascript">
	function cmdsave_click() {
		
	    if (isNaN(document.form1.txtnum1.value) && isNaN(document.form1.txttem1.value)) {
			alert("กรุณาระบุตัวเลข !!!")
			document.form1.txtnum3.focus();
			return false;
		} 

		document.form1.act.value="save";
		document.form1.submit();
	}
	
</script>
</HEAD>
<BODY topmargin=0 leftmargin=0 onLoad="document.all.txtnum1.focus();">
<FORM METHOD=POST ACTION="dealer_setvalue_addmoney.asp" Name="form1" >	
<INPUT TYPE="hidden" name="uid" value="<%=Request("uid")%>">
<INPUT TYPE="hidden" name="act" value="">
	<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
		<TR>
			<Td  bgColor=#ff7777 align=center><strong>เติมเงิน</strong></Td>
		</Tr>
		<TR>
			<Td>
				<TABLE width='100%' align=center class=table_red bgColor="#FFFFFF">
					<TR bgColor=#ff7777>					
						<TD align=center><strong>เติมเข้า</strong></TD>						
						<TD align=center><strong>หักออก</strong></TD>
                        <TD align=center><strong>หมายเหตุ</strong></TD>									
					</Tr>

<%
	dim cnt
	cnt = 0
    cnt = cnt +1
	Response.write "<TR class=text_black>"
	Response.write "<Td align=center><INPUT TYPE='text' NAME='txtnum1' style='width:100' ></Td>"
	Response.write "<Td align=center><INPUT TYPE='text' NAME='txttem1' style='width:100' ></Td>"
    Response.write "<Td align=center><INPUT TYPE='text' NAME='txtremark' style='width:180' ></Td>"
	Response.write "</TR>"
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
