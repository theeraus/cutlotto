<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<STYLE TYPE="text/css">
	<!--
    A:link {text-decoration: none;}  
    A:visited {text-decoration: none;}   
	-->
</STYLE>
</HEAD>
<BODY>
<P>&nbsp;</P>
<FORM id=FORM1 name=FORM1 action="dealer_tudroum_send_act.asp" method=post>
<TABLE WIDTH="300" ALIGN=center BORDER=4 CELLSPACING=0 CELLPADDING=0 >
	<TR>
		<TD>

<TABLE WIDTH="100%" BORDER=0 CELLSPACING=0 CELLPADDING=0 bgColor=white>
	<TR class=head_white bgColor=#6495ed>
		<TD align=middle colspan=3>��س� Log in ���� User <br>�ͧ�����ͷ��س��ͧ����觵��</TD>
	</TR>
	<TR class=text_blue>
		<TD colspan=3 align=middle>   &nbsp;</TD>
		
	</TR>
	<TR class=text_blue>
		<TD> &nbsp;&nbsp;User Name</TD>
		<TD><INPUT id=text1 name=txtUserName width=200 size=20></TD>
		<TD></TD>
	</TR>
	<TR class=text_blue>
		<TD> &nbsp;&nbsp;Password</TD>
		<TD><INPUT id=password1 type=password name=password1 width=200 size=20></TD>
		<TD></TD>
	</TR>
        <TR>
          
          <TD colspan=3 align=middle><INPUT id=button1 type=submit align=left value="  Sign In  " name=button1 ></TD></TR>
</TABLE>

</TD>
	</TR>
</TABLE>
<Input type=hidden name=mygoto value='dealer_tudroum.asp'>
<Input type=hidden name=cutallid value='<%=Request("cutallid")%>'>
</FORM>
</BODY>
</HTML>
