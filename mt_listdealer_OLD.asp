<%@ Language=VBScript CodePage = 65001  %>
<% Response.CodePage = 65001%>
<%OPTION EXPLICIT%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>




<%




Dim objRec
Dim strSql
Dim cntApp
dim chkRow
dim strdel
	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	

	
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
</HEAD>
<BODY topmargin=0>

	<TABLE cellSpacing=0 cellPadding=0 width='95%' border=0 align=center>        	
		<tr>
		  <td class="head_black" align=center>��駤�ᷧ</td>
		  <td class="head_blue" align=right>&nbsp;
			<%
			response.write session("msgResult")
			session("msgResult") = ""
			%>
			</td>
		</tr>
	</table>	
	<TABLE cellSpacing=1 cellPadding=0 width="95%" border=0 align=center>        

	
<%	
	strSql="Select * From sc_user"
	strSql = strSql & " where create_by=" & Session("uid")
	objRec.Open strSql, conn


	if Not objRec.EOF then	
%>
        <TR bgcolor=RoyalBlue>
          <TD class="Head_white">
      <P align=center>&nbsp;</P></TD>
          <TD class="Head_white">
      <P align=center>����</P></TD>
          <TD class="Head_white">
      <P align=center>����</P></TD>
          <TD class="Head_white">
      <P align=center>Password</P></TD>
          <TD class="Head_white">
      <P align=center>���ʴ��ʹ�Թ</P></TD>
          <TD class="Head_white">
      <P align=center>�ʹ��ҧ���</P> </TD>
          <TD class="Head_white">
      <P align=center>&nbsp;</P> </TD>
		  <TD class="Head_white">
      <P align=center>�ѹ�֡ �� ������� �����˵� ���</P> </TD>
          <TD class="Head_white" align=center><input type=button value="����" class=inputB onClick="gotoPage('mt_adddealer.asp')"></TD> 
        </TR>  
<%	
dim reccolor
		cntApp=0
		chkRow=1
		Do While Not objRec.EOF
			cntApp = cntApp +1
			if chkRow=1 then
				Response.Write "<TR bgcolor=#e6e6fa>"
				chkRow=0
			else
				Response.Write "<TR>"
				chkRow=1
			end if
			if objRec("rec_ticket")=1 then
				reccolor="#009900"
			else
				reccolor="#FF0000"
			end if
%>
			        
          <TD class="text_blue" align=center bgcolor=<%=reccolor%>>&nbsp;</TD>          
          <TD class="text_blue" align=center><%="" & objRec("user_id")%>&nbsp;</TD>
          <TD class="text_blue"><%="" & objRec("first_name")%></TD>
          <TD class="text_blue"><%="" & objRec("user_password")%></TD>
          <TD class="text_blue"><%="" & objRec("sum_password")%></TD>          
          <TD class="text_blue" align=right><%="" & objRec("old_remain")%>&nbsp;</TD>  
          <TD class="text_blue" align=center><%="����Ҥҡ�ҧ" %></TD>  
          <TD class="text_blue"><%="" & objRec("address_1")&" "&objRec("address_2")&" ��Ͷ�� "&objRec("mobile_no")&" T. " & objRec("home_tel")&" F. "&objRec("fax_no")&"<a href='mailto:"&objRec("email")&"'>"&objRec("email") %></a></TD>  
          <TD class="text_blue" align=center><input type=button value="���" class=inputB onClick="gotoPage('mt_adddealer.asp?uid=<%=objRec("user_id")%>')"> <input type=button value="ź" class=inputB onClick="gotoPage('mt_adddealer.asp')"></TD>
        </TR>  

<%		
			objRec.MoveNext
		Loop
	else
%>
	
        <TR align=middle bgcolor=Blue>
          <TD colspan=6 class=head_white>��辺������ [<a href="mt_adddealer.asp" class=head_red>����</a>]</TD>
        </TR>  
        <TR align=middle>
          <TD colspan=6 class=head_blue><A href="JavaScript:history.back(1)">��͹��Ѻ</a></TD>
        </TR>  
	
<%	
	end if
	objRec.Close
	conn.Close	
	Set objRec = Nothing
	Set conn = Nothing	
%>
	</TABLE>

<P>&nbsp;</P>

</BODY>
</HTML>
