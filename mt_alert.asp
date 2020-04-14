<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>


<%
	dim objRec
	Dim strSQL
	dim bMsg
	dim bLastUp
	dim chkExist
	dim iAct
	bMsg=""	
	bLastUp=""
	if  Ucase(Request("Act"))= "UP" then	
		bMsg=Replace(Request("txtmsg"),chr(32)," ")
		bMsg=Replace(bMsg,chr(13)," ")
		'showstr bMsg
		'bMsg=Request("txtmsg")
		chkExist = CheckExistTable("tb_dealer_alert","dealer_id= "&Session("uid"))
		if chkExist then
			strSql = "Update tb_dealer_alert "
			strSql = StrSql & " set message='" & bMsg & "' "
			strSql = StrSql & ", last_update = GetDate() " 
			strSql = StrSql & " Where dealer_id= " & Session("uid") & " "
		else
			strSql = "Insert Into tb_dealer_alert (dealer_id, message, last_update) Values ("
			strSql = StrSql & Session("uid") & ""
			strSql = StrSql & ", '" & bMsg & "'"
			strSql = StrSql & ", GetDate())"
		end if


'showstr strsql
		comm.CommandText = StrSql
		comm.CommandType = adCmdText
		comm.Execute
		%><script language=JavaScript>// window.open("index.asp?page=firstpage_dealer.asp","_top")
		//window.location.href="firstpage_dealer.asp"; 
			alert('บันทึกข้อมูลเรียบร้อยแล้ว');
		</script><%		
	end if
	iAct="UP"
	strSql = "Select * From tb_dealer_alert Where dealer_id= " & Session("uid") & " "
	set objRec = Server.CreateObject("ADODB.Recordset")
	objRec.Open strSql, conn, adOpenForwardOnly, adLockReadOnly
	if Not objRec.EOF then	
		bMsg=""&objRec("message")
		bLastUp=""&objRec("last_update")
	end if
'showstr "msg : "&bMsg


	
%>


<P>
<FORM id=FORM1 name=form action="mt_alert.asp" method=post>
      <TABLE id=TABLE2  cellSpacing=0 cellPadding=1 TOPMARGIN=50px
      width="708" background="" border=0 align=center class="table">

		<tr bgcolor=gray >
		  <td  align=left style="color:#fff"><h4>ข้อความประกาศ</h4></td>
		  <td  align=right>
			<%
			response.write session("msgResult")
			session("msgResult") = ""
			%>
			</td>
		</tr>

        <TR vAlign=center bgColor=#e6e6fa>
          <TD  class=text_red colspan=2><span class="style2" style="color:#444">ข้อความประกาศ</span><br>
		  <textarea rows=5 id="txtmsg" name="txtmsg" cols="100" ><%=bMsg%></TEXTAREA></TD></TR>
        <TR bgColor=#e6e6fa>
          <TD class=text_blue colspan=2><span class="style2">วันที่ปรับปรุงล่าสุด</span><br>
		  <INPUT id="txtup" name="txtup" size=20 value="<%=bLastUp%>" disabled></TD></TR>

		<TR align=middle  bgcolor=gray >
		  <td align=left  colspan="2" height="50">
			  <INPUT type="hidden" name="act" value="<%=iAct%>">
			  <INPUT type="submit" class="btn btn-primary" value="บันทึก" style="cursor:hand;width:100;" name="button1">
			  <!--
			  <INPUT type="reset" value="ยกเลิก" id=reset1 name=reset1>
			  -->
			</td></TR>	            
       </TABLE>

<P></FORM>&nbsp;</P>

<%
	set objRec = nothing
	set conn = nothing
%>

<% End Sub %>