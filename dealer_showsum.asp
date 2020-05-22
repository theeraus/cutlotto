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
Dim objRec
dim recPlayer
dim recNum
Dim strSql
Dim cntApp
dim chkRow
dim strdel
dim strTmp
dim ticketnumber
dim pretid							
	'*** Open the database.	

	Set objRec = Server.CreateObject ("ADODB.Recordset")
	Set recNum = Server.CreateObject ("ADODB.Recordset")
	Set recPlayer = Server.CreateObject ("ADODB.Recordset")


	if trim(Request("tid"))="" then 
		ticketnumber=1
	else
		ticketnumber=cint(Request("tid"))
	end if
%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
</HEAD>
<BODY topmargin=0 leftmargin=0>
<%

'************** ����� 
dim sumall
dim typenum1, typenum2, typenum3, typenum4, typenum5, typenum6, typenum7, typenum8
dim strOpen
dim strOrder

	sumall=0
	typenum1=0: typenum2=0: typenum3=0: typenum4=0: typenum5=0: typenum6=0: typenum7=0: typenum8=0
	

	' start 
	if len(trim(Session("logid"))) <8 then
	If Request("showtype")="player"  then
		strSql="exec spJGetSwohSum " &  Session("uid") & ", " & Session("gameid") & "," & Request("tid")
	Else
		strSql="exec spJGetSwohSum " &  Session("p2pid") & ", " & Session("gameid")  & "," & Request("tid")
	End If
	else
	If Request("showtype")="player"  then
		strSql="exec spJGetSwohSum_level2 " &  Session("uid") & ", " & Session("gameid") & "," & Request("tid")
	Else
		strSql="exec spJGetSwohSum_level2 " &  Session("p2pid") & ", " & Session("gameid")  & "," & Request("tid")
	End If
	end if
'response.write strSQL & " " & Session("logid") & " len " & len(trim(Session("logid")))
	Dim dis1,dis2,dis3,dis4,dis5,dis6,dis7,dis8
	Dim sum_pay1,sum_pay2,sum_pay3,sum_pay4,sum_pay5,sum_pay6,sum_pay7,sum_pay8
	Dim s_total,s_dis,s_pay
	s_total=0
	s_dis=0
	s_pay=0
	dis1=0
	dis2=0
	dis3=0
	dis4=0
	dis5=0
	dis6=0
	dis7=0
	dis8=0
	sum_pay1=0
	sum_pay2=0
	sum_pay3=0
	sum_pay4=0
	sum_pay5=0
	sum_pay6=0
	sum_pay7=0
	sum_pay8=0
	typenum1=0
	typenum2=0
	typenum3=0
	typenum4=0
	typenum5=0
	typenum6=0
	typenum7=0
	typenum8=0
	Set objRec=conn.Execute(strSql)
	If Not objRec.eof Then
		do while not objRec.eof
			s_total=s_total+objRec("sum_amt")
			s_dis=s_dis+objRec("sum_dist")
			s_pay=s_pay+objRec("sum_pay")
			select case objRec("play_type")				
				case 1
					typenum1 = objRec("sum_amt")
					dis1= objRec("sum_dist")
					sum_pay1= objRec("sum_pay")
				case 2
					typenum2 = objRec("sum_amt")
					dis2= objRec("sum_dist")
					sum_pay2= objRec("sum_pay")
				case 3
					typenum3 = objRec("sum_amt")
					dis3= objRec("sum_dist")
					sum_pay3= objRec("sum_pay")
				case 4
					typenum4 = objRec("sum_amt")
					dis4= objRec("sum_dist")
					sum_pay4= objRec("sum_pay")
				case 5
					typenum5 = objRec("sum_amt")
					dis5= objRec("sum_dist")
					sum_pay5= objRec("sum_pay")
				case 6
					typenum6 = objRec("sum_amt")
					dis6= objRec("sum_dist")
					sum_pay6= objRec("sum_pay")
				case 7
					typenum7 = objRec("sum_amt")
					dis7= objRec("sum_dist")
					sum_pay7= objRec("sum_pay")
				case 8
					typenum8 = objRec("sum_amt")
					dis8= objRec("sum_dist")
					sum_pay8= objRec("sum_pay")
			end select
			sumall=sumall + objRec("sum_amt")
			objRec.movenext
		loop
	End if

%>
	<TABLE width='95%' align=center class=table_blue bgcolor=white>        	
		<tr align=center class=head_black>
			<td bgColor=#CCFFCC>������</td>
			<td bgColor=#CCFFCC>�ʹ�Թ</td>
			<td bgColor=#CCFFCC>�ʹ�ѡ%  </td>
			<td bgColor=#CCFFCC>�ʹ�Թ�١</td>
			
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>2 ��</td>
			<td bgcolor=#CCFFFF><%=typenum1%></td>
			<td bgcolor=#CCFFFF><%=dis1%></td>
			<td bgcolor=#CCFFFF><%=sum_pay1%></td>			
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>3 ��</td>
			<td bgcolor=#CCFFFF><%=typenum2%></td>
			<td bgcolor=#CCFFFF><%=dis2%></td>
			<td bgcolor=#CCFFFF><%=sum_pay2%></td>
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>3 ��</td>
			<td bgcolor=#CCFFFF><%=typenum3%></td>
			<td bgcolor=#CCFFFF><%=dis3%></td>
			<td bgcolor=#CCFFFF><%=sum_pay3%></td>
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>2 ��</td>
			<td bgcolor=#CCFFFF><%=typenum4%></td>
			<td bgcolor=#CCFFFF><%=dis4%></td>
			<td bgcolor=#CCFFFF><%=sum_pay4%></td>
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>��觺�</td>
			<td bgcolor=#CCFFFF><%=typenum5%></td>
			<td bgcolor=#CCFFFF><%=dis5%></td>
			<td bgcolor=#CCFFFF><%=sum_pay5%></td>
		</tr>
		<tr><td colspan=4 height=15 bgcolor=#FFFFCC>&nbsp;</td></tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>�����ҧ</td>
			<td bgcolor=#CCFFFF><%=typenum6%></td>
			<td bgcolor=#CCFFFF><%=dis6%></td>
			<td bgcolor=#CCFFFF><%=sum_pay6%></td>
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>2 ��ҧ</td>
			<td bgcolor=#CCFFFF><%=typenum7%></td>
			<td bgcolor=#CCFFFF><%=dis7%></td>
			<td bgcolor=#CCFFFF><%=sum_pay7%></td>
		</tr>
		<tr class=text_black>
			<td bgcolor=#FFFFCC>3 ��ҧ</td>
			<td bgcolor=#CCFFFF><%=typenum8%></td>
			<td bgcolor=#CCFFFF><%=dis8%></td>
			<td bgcolor=#CCFFFF><%=sum_pay8%></td>
		</tr>
		<tr class=head_black>
			<td bgcolor=#CCFFCC>���</td>
			<td bgcolor=#CCFFCC><%=s_total%></td>
			<td bgcolor=#CCFFCC><%=s_dis%></td>
			<td bgcolor=#CCFFCC><%=s_pay%></td>
		</tr>
		<tr align=center class=head_black>
			<td bgColor=#CCFFCC colspan=4><input type=button name=cmdclose value="  �Դ  " onClick="window.close();" class=button_blue></td>
		</tr>
	</TABLE>
</BODY>
</HTML>
<%
	set objRec = nothing
	set recNum = nothing
	set conn   = nothing	
%>