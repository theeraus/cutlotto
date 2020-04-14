<%@ Language=VBScript %>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->

<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<script language="JavaScript" src="include/normalfunc.js"></script>
<LINK href="include/code.css" type=text/css rel=stylesheet>

<TITLE>System</TITLE>
    <style type="text/css">
        .style1
        {
            FONT-WEIGHT: bold;
            FONT-SIZE: large;
            COLOR: #ffffff;
            FONT-FAMILY: Verdana, 'MS Sans Serif';
            TEXT-DECORATION: none;
            height: 70px;
        }
        .style2
        {
            font-size: medium;
        }
        .style3
        {
            FONT-WEIGHT: bold;
            FONT-SIZE: 14px;
            COLOR: #3a84b4;
            FONT-FAMILY: Verdana, 'MS Sans Serif';
            TEXT-DECORATION: none;
            height: 52px;
        }
    </style>
</HEAD>
<%
	dim objRec
	Dim strSQL
	dim bMsg
	dim bLastUp
	dim chkExist
	
	bMsg=""	
	bLastUp=""
	if  Ucase(Request("Act"))= "UP" then	
		bMsg=Replace(Request("txtmsg"),chr(32)," ")
		bMsg=Replace(bMsg,chr(13)," ")
		'showstr bMsg
		'bMsg=Request("txtmsg")
		chkExist = CheckExistTable("tb_system_alert","dealer_id= "&Session("uid"))
		if chkExist then
			strSql = "Update tb_system_alert "
			strSql = StrSql & " set message='" & bMsg & "' "
			strSql = StrSql & ", last_update = GetDate() "
            strSql = StrSql & " Where dealer_id= " & Session("uid") & " "
		else
			strSql = "Insert Into tb_system_alert (dealer_id, message, last_update) Values ("
			strSql = StrSql & Session("uid") & ""
			strSql = StrSql & ", '" & bMsg & "'"
			strSql = StrSql & ", GetDate())"
		end if


'showstr strsql
		comm.CommandText = StrSql
		comm.CommandType = adCmdText
		comm.Execute
		%><script language=JavaScript>
		      window.open("index.asp?page=mt_system_alert.asp")
		      //window.location.href="mt_system_alert.asp"; 
			//alert('บันทึกข้อมูลเรียบร้อยแล้ว');
		</script><%		
	end if
	iAct="UP"
	strSql = "Select * From tb_system_alert where dealer_id= " & Session("uid") & " "
	set objRec = Server.CreateObject("ADODB.Recordset")
	objRec.Open strSql, conn, adOpenForwardOnly, adLockReadOnly
	if Not objRec.EOF then	
		bMsg=""&objRec("message")
		bLastUp=""&objRec("last_update")
	end if
'showstr "msg : "&bMsg


	
%>
<BODY TOPMARGIN=20 aLink=white vLink=white bottomMargin=0 link=darkviolet>
<P>
<FORM id=FORM1 name=form action="mt_system_alert.asp" method=post>
      <TABLE id=TABLE2  cellSpacing=0 cellPadding=1 TOPMARGIN=50px
      width="708" background="" border=0 align=center>
		<tr>
		  <td  align=center>&nbsp;</td>
		</tr>
        <tr>
		  <td  align=center>&nbsp;</td>
		</tr>
		<tr bgcolor=teal >
		  <td class="style1" align=center>&nbsp;&nbsp;&nbsp; ข้อความระบบ</td>
		  <td class="style3" align=right>
			</td>
		</tr>

        <TR vAlign=center bgColor=#e6e6fa>
          <TD  class=text_red colspan=2><span class="style2">ข้อความประกาศ</span><br>
		  <textarea rows=5 id="txtmsg" name="txtmsg" cols="100" ><%=bMsg%></TEXTAREA></TD></TR>
        <TR bgColor=#e6e6fa>
          <TD class=text_blue colspan=2><span class="style2">วันที่ปรับปรุงล่าสุด</span><br>
		  <INPUT id="txtup" name="txtup" size=20 value="<%=bLastUp%>" disabled></TD></TR>

		<TR align=middle  bgcolor=teal >
		  <td colspan="2" height="50">
			  <INPUT type="hidden" name="act" value="<%=iAct%>">
			  <INPUT type="submit" class="inputG" value="บันทึก" style="cursor:hand;width:100;" name="button1">

			</td></TR>	            
       </TABLE>

<P></FORM>&nbsp;</P>
</BODY>
</HTML>
<%
	set objRec = nothing
	set conn = nothing
%>