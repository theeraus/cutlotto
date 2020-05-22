<%@ Language=VBScript CodePage = 65001  %>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->

<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript">
<!--
function checkvalue()
{


//	if(document.form.txtSeq.value == "")
//	{
//		alert("��سҡ�˹��ӴѺ�������١��ͧ")
//		document.form.txtSeq.focus()
//		return false
//	}	
//	if(document.form.chkVote.checked == true)
//	{document.form.txtVoteF.value="Y"}
//	else	
//	{document.form.txtVoteF.value="N"}
	document.form.chkdisabled.value=0
	if (document.form.chkstatus.checked == true) {
		document.form.chkdisabled.value=1
	}
	return true;
}
//-->
</script>
<TITLE>User</TITLE>
</HEAD>
<%
	dim objRec
	Dim strSQL
	dim preCode
	dim bID
	dim bUser
	dim bPass
	dim bSumPass
	dim bUType
	dim bFname
	dim bLname
	dim bNick
	dim bDisable
	dim bAddr1
	dim bAddr2
	dim bTel
	dim bFax
	dim bMobile
	dim bEmail
	dim bRemain
	dim bRecTk
	
	preCode=0
	bID = 0
	bUser=""
	bPass=""
	bSumPass=""
	bUType=""
	bFname=""
	bLname=""
	bNick=""
	bDisable="0"
	bAddr1=""
	bAddr2=""
	bTel=""
	bFax=""
	bMobile=""
	bEmail=""
	bRemain=""
	bRecTk=""

	if  Ucase(Request("Act"))= "ADD" then		
			bID=GenMaxID("sc_user", "user_id", "")
			bPass=Request("txtpass")
			bSumPass=Request("txtsumpass")
			
			strSql = "Insert Into sc_user (user_id, user_name, user_password, sum_password, user_type, first_name, last_name, nick_name, user_disable, create_by, create_date, address_1,  address_2, home_tel, mobile_no, fax_no, email, old_remain, rec_ticket) Values ("
			strSql = StrSql & bID 
			strSql = StrSql & ", '" & Request("txtuser") & "'"
			strSql = StrSql & ", '" & bPass & "'"
			strSql = StrSql & ", '" & bSumPass & "'"
			strSql = StrSql & ", '" & Request("cmbtype") & "'"
			strSql = StrSql & ", '" & Request("txtfname") & "'"
			strSql = StrSql & ", '" & Request("txtlname") & "'"
			strSql = StrSql & ", '" & Request("txtnick") & "'"
			strSql = StrSql & ", " & Request("chkdisabled") & ""
			strSql = StrSql & ", " & Session("uid") & ""
			strSql = StrSql & ", GetDate()"
			strSql = StrSql & ", '" & Request("txtaddr1") & "'"
			strSql = StrSql & ", '" & Request("txtaddr2") & "'"
			strSql = StrSql & ", '" & Request("txttel") & "'"
			strSql = StrSql & ", '" & Request("txtfax") & "'"
			strSql = StrSql & ", '" & Request("txtmobile") & "'"
			strSql = StrSql & ", '" & Request("txtemail") & "'"
			strSql = StrSql & ", " & Request("txtremain") & ""
			strSql = StrSql & ", '" & Request("cmbrec") & "')"

'showstr strsql
			comm.CommandText = StrSql
			comm.CommandType = adCmdText
			comm.Execute
			Response.Redirect "mt_listdealer.asp"
	elseif Ucase(Request("Act"))= "EDIT" then 
			if Request("txtpass") <> "" then
				bPass = Request("txtpass")
			end if
			if Request("txtsumpass") <> "" then
				bSumPass = Request("txtsumpass")
			end if
			strSql = "Update sc_user "
			strSql = StrSql & " set user_name='" & Request("txtuser") & "' "
			if bPass <> "" then
				strSql = StrSql & ", user_password='" & bPass & "' "
			end if
			if bSumPass <> "" then
				strSql = StrSql & ", sum_password='" & bSumPass & "' "
			end if
			strSql = StrSql & ", user_type = '" & Request("cmbtype") & "'"
			strSql = StrSql & ", first_name = '" & Request("txtfname") & "'"
			strSql = StrSql & ", last_name = '" & Request("txtlname") & "'"
			strSql = StrSql & ", nick_name = '" & Request("txtnick") & "'"
			strSql = StrSql & ", user_disable = " & Request("chkdisabled") & ""
			strSql = StrSql & ", address_1 = '" & Request("txtaddr1") & "'"
			strSql = StrSql & ", address_2 = '" & Request("txtaddr2") & "'"
			strSql = StrSql & ", home_tel = '" & Request("txttel") & "'"
			strSql = StrSql & ", fax_no = '" & Request("txtfax") & "'"
			strSql = StrSql & ", mobile_no = '" & Request("txtmobile") & "'"
			strSql = StrSql & ", email = '" & Request("txtemail") & "'"
			strSql = StrSql & ", old_remain = " & Request("txtremain") & ""
			strSql = StrSql & ", rec_ticket = '" & Request("cmbrec") & "'"
			strSql = StrSql & " Where user_id=" & Request("oldid") & " "
'showstr strsql
			comm.CommandText = StrSql
			comm.CommandType = adCmdText
			comm.Execute
			Response.Redirect "mt_listdealer.asp"
	end if
	if Request("uid") = "" then
		iAct="ADD"
	Else
		iAct="EDIT"
		preCode=Request("uid")
		strSql = "Select * From sc_user Where user_id=" & preCode & ""
		set objRec = Server.CreateObject("ADODB.Recordset")
		objRec.Open strSql, conn, adOpenForwardOnly, adLockReadOnly
		if Not objRec.EOF then	
			bID=objRec("user_id")
			bUser=""&objRec("user_name")
			bUType=""&objRec("user_type")
			bFname=""&objRec("first_name")
			bLname=""&objRec("last_name")
			bNick=""&objRec("nick_name")
			bDisable=objRec("user_disable")
			bAddr1=""&objRec("address_1")
			bAddr2=""&objRec("address_2")
			bTel=""&objRec("home_tel")
			bFax=""&objRec("fax_no")
			bMobile=""&objRec("mobile_no")
			bEmail=""&objRec("email")
			bRemain=""&objRec("old_remain")
			bRecTk=""&objRec("rec_ticket")
		end if
	end if


Function EncryptPws(ByVal inPws)
Dim LenPws
Dim enPws
Dim I
dim tmp
Dim chkRnd
        If RTrim(inPws) = "" Then
                EncryptPws = ""
                Exit Function
        End If
        chkRnd = Int((2 * Rnd) + 0)
        LenPws = Len(inPws)
        enPws = chkRnd	
        If chkRnd=1 Then
			tmp=LenPws
			if len(tmp)=1 then tmp = "0" & tmp
			enPws = enPws & tmp          
        End If
        
        For I = LenPws To 1 Step -1
		'	tmp=I
			tmp =(Asc(Mid(inPws, I, 1)) * (chkRnd + 1) + LenPws)
			if len(tmp)=1 then tmp = "00" & tmp
			if len(tmp)=2 then tmp = "0" & tmp
            enPws = enPws & tmp
        Next         
        If chkRnd=0 Then
			tmp=LenPws
			if len(tmp)=1 then tmp = "0" & tmp
            enPws = enPws & tmp
        End If
        EncryptPws = enPws
        
End Function

	
%>
<BODY TOPMARGIN=0 aLink=white vLink=white bottomMargin=0 link=darkviolet>
<P>
<FORM id=FORM1 name=form action="mt_adddealer.asp" method=post>
      <TABLE id=TABLE2  cellSpacing=0 cellPadding=1  class="table_red"
      width="708" background="" border=0 align=center>
		<tr bgcolor=red>
		  <td class="head_white">�����ż�����к�</td>
		  <td class="head_blue" align=right>
			<%
			response.write session("msgResult")
			session("msgResult") = ""
			%>
			</td>
		</tr>
        <TR vAlign=center bgColor=#e6e6fa>
          <TD  class=text_blue>
            <P align=right>���ʼ����&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id="txtuserid" name="txtuserid" size=10 value="<%=bID%>" Disabled></P></TD></TR>
        <TR bgColor=#e6e6fa>
          <TD vAlign=center class=text_blue>
            <P align=right>���ͼ����&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id="txtfname" name="txtfname" size=20 value="<%=bFname%>"></P></TD></TR>
        <TR bgColor=#e6e6fa>
          <TD vAlign=center class=text_blue>
            <P align=right>���ʡ��&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id="txtlname" name="txtlname" size=20  value="<%=bLname%>"></P></TD></TR>
        <TR bgColor=#e6e6fa>
          <TD vAlign=center class=text_blue>
            <P align=right>�������&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id="txtnick" size=10 name="txtnick" value="<%=bNick%>"></P></TD></TR>
<%
	dim strDisable
	strDisable=""
	if bDisable= true  then
		strDisable="checked"
	end if
%>
        <TR>
          <TD vAlign=top class=text_blue>
            <P align=right>ʶҹ�&nbsp;:</P></TD>
          <TD class=text_blue><INPUT id=chkstatus type=checkbox name=chkBStatus <%=strDisable%>>Disable</TD></TR>
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>�������&nbsp;:</P></TD>
          <TD><INPUT id="txtaddr1" name="txtaddr1" size=50 value="<%=bAddr1%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>&nbsp;:</P></TD>
          <TD><INPUT id="txtaddr2" name="txtaddr2" size=50 value="<%=bAddr2%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>������Ͷ��&nbsp;:</P></TD>
          <TD><INPUT id="txtmobile" name="txtmobile" size=30 value="<%=bMobile%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>�������Ѿ��&nbsp;:</P></TD>
          <TD><INPUT id="txttel" name="txttel" size=30 value="<%=bTel%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>���������&nbsp;:</P></TD>
          <TD><INPUT id="txtfax" name="txtfax" size=30 value="<%=bFax%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>E-mail&nbsp;:</P></TD>
          <TD><INPUT id="txtemail" name="txtemail" size=30 value="<%=bEmail%>"></TD></TR>			
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>�ʹ��ҧ���&nbsp;:</P></TD>
          <TD><INPUT id="txtremain" name="txtremain" size=30 value="<%=bRemain%>"></TD></TR>			
<%
		dim strselect
%>
        <TR bgColor=#e6e6fa>
          <TD vAlign=top class=text_blue>
            <P align=right>����Ѻ��&nbsp;:</P></TD>
          <TD><select id="cmbrec" name="cmbrec">
<%				strselect=""
				if bRecTk="2" then strselect="selected" %>
			  <option value="2" <%=strselect%>>�͡���׹�ѹ</option>	
<%				strselect=""
				if bRecTk="1" then strselect="selected" %>
			  <option value="1" <%=strselect%>>�Ѻ�ѵ��ѵ�</option>	
			  </select>
		  </TD></TR>			

		<TR vAlign=center class=text_blue>
          <TD  class=text_blue>
            <P align=right>User Name&nbsp;:</P></TD>
          <TD>
            <P align=left><INPUT id="txtuser" width="173" name="txtuser" value="<%=bUser%>" ></P></TD></TR>
        <TR>
          <TD vAlign=center class=text_blue>
            <P align=right>���ʼ�ҹ&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id=txtpass type=password name=txtpass>&nbsp;�׹�ѹ���ʼ�ҹ :&nbsp;<INPUT id=txtconpass type=password name=txtconpass></P></TD></TR>
        <TR>
          <TD vAlign=center class=text_blue>
            <P align=right>���ʴ��ʹ�Թ&nbsp;:</P></TD>
          <TD class=text_blue>
            <P align=left><INPUT id=txtsumpass type=password name=txtsumpass>&nbsp;�׹�ѹ���ʼ�ҹ :&nbsp;<INPUT id=txtconsumpass type=password name=txtconsumpass></P></TD></TR>
        <TR>
          <TD vAlign=top class=text_blue>
            <P align=right>&nbsp;�����������&nbsp;:</P></TD>
          <TD class=text_blue>
			  <select id="cmbtype" name="cmbtype">
<% 
				strselect=""
				if bUType="A" then strselect="selected" %>
			  <option value="A" <%=strselect%>>Admin</option>	
<%				strselect=""
				if bUType="D" then strselect="selected" %>
			  <option value="D"<%=strselect%>>������</option>	
<%				strselect=""
				if bUType="P" then strselect="selected" %>
			  <option value="P"<%=strselect%>>��ᷧ</option>	
<%				strselect=""
				if bUType="K" then strselect="selected" %>
			  <option value="K"<%=strselect%>>������</option>	
			  </select>
		  </TD></TR>
		<TR align=middle  bgcolor=red>
		  <td colspan="2">&nbsp;
			  <INPUT type="hidden" name="oldid" value=<%=preCode%>>
			  <INPUT type="hidden" name="act" value="<%=iAct%>">
			  <INPUT type="hidden" name="chkdisabled">
			  <INPUT type="submit" value="�ѹ�֡" name="button1" class="inputG" style="cursor:hand; width: 75px;" onclick="return checkvalue();">
			  <INPUT type="reset" value="¡��ԡ" class="inputE" style="cursor:hand; width: 75px;" id=reset1 name=reset1>
			</td></TR>	            
       </TABLE>

<P></FORM>&nbsp;</P>
</BODY>
</HTML>
<%
	'objRec.Close
	'conn.Close	
	Set objRec = Nothing
	Set conn = Nothing		
%>