
<%
dim conn
dim comm
dim strConnection 
Const pathPic_work = "E:\Works\BH-Shareholder\www\images_work\"
Const pathPicTmp_work = "E:\Works\BH-Shareholder\www\images_work\tmp\"
Const pathPreview_work = "./images_work/"
Const pathDataImport = "E:\Works\BH-Shareholder\www\DataImport\"

	set conn = CreateObject("ADODB.Connection")	
	conn.open Application("constr")
	Set comm = CreateObject("ADODB.Command")	
	comm.ActiveConnection = Application("constr")



Sub ShowMenu1(iComID)
%>
	<TABLE>
		<TR>
		<TD>

<%
	dim strData
	dim strReg
	dim strUser
		strData="": strReg="": strUser=""
			if Session("MngData")<>true then strData="Disabled" 
			if Session("MngReg")<>true then strReg="Disabled" 
			if Session("MngUser")<>true then strUser="Disabled" 
%>
			<input type='button' value='ผู้ใช้ระบบ' class='inputB' onClick="gotoPage('mt_listuser.asp')" <%=strUser%>>
			<input type='button' value='ข้อมูลบริษัท' class='inputB' onClick="gotoPage('mt_listcom.asp')" <%=strData%>>
			<input type='button' value='กำหนดวันประชุม' class='inputB' onClick="gotoPage('mt_listmet.asp?comid=<%=iComID%>')" <%=strData%>>
			<input type='button' value='นำเข้าผู้ถือหุ้น' class='inputB' onClick="gotoPage('import_datashare.asp')" <%=strData%>>
			<input type='button' value='แก้ไขผู้ถือหุ้น' class='inputB' onClick="gotoPage('mt_listshare.asp')" <%=strReg%>>
			<input type='button' value='กำหนดวาระ' class='inputB' onClick="gotoPage('mt_listdoom.asp')" <%=strData%>>
			<input type='button' value='กำหนดโต๊ะ' class='inputB' onClick="gotoPage('mt_listTable.asp')" <%=strData%>>
			<input type='button' value='ลงทะเบียน' class='inputB' onClick="gotoPage('wk_register.asp')" <%=strReg%>>
			<input type='button' value='ลงคะแนน' class='inputB' onClick="gotoPage('wk_doom_vote.asp')" <%=strReg%>>
			<input type='button' value='รายงาน' class='inputB' onClick="gotoPage('wk_menu_rep.asp')" <%=strReg%>>
			<input type='button' value='ออก' class='inputB' onClick="JavaScript:window.location='index.asp';">
		</TD>	
		</TR>
	</TABLE>	
<%
End sub

sub ShowMessage(msg)
	Response.write "<META http-equiv='Content-Type' content='text/html; charset=windows-874'>"
	Response.write "<LINK href='code.css' type=text/css rel=stylesheet>"
	Response.write "<br><br>"
	Response.write "<table align=center class=table_blue><tr height=40 class=tr_head_info>"
	Response.write "<td align=center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & msg & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"
	Response.write "</tr></table>"

end sub

function GenMaxID(byval TableName, byval FieldName, byval Condition)
dim strSql
dim objConn
dim rs
dim mID
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "SELECT Max(" & FieldName & ") as MaxID FROM " & TableName
	if trim(Condition)<>"" then
		strSql=strSql & " Where " & Condition
	end if
	rs.open strSql,objConn
	mID=1
	if not rs.eof then
		if not isnull(rs("MaxID")) then
			mID = rs("MaxID") + 1
		end if
	end if		
	set rs = nothing
	set objConn = nothing			
	GenMaxID = mID
end Function


function ShowTitle(lang,title_th,title_en)
	
	Response.Write "<TABLE WIDTH='100%' ALIGN='left' BORDER=0 CELLSPACING=0 CELLPADDING=0>"
	Response.Write "<TR><TD class=text_white align=left height=25 background=images/title_head.jpg>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size=3>" & ShowTextLang(lang,title_th,title_en) & "</font></TD></TR>"
	Response.Write "</TABLE><br><br>"
end function

function ShowBack()	
	Response.Write "<br><br>"
	Response.Write "<TABLE WIDTH='100%' ALIGN='left' BORDER=0 CELLSPACING=0 CELLPADDING=0>"
	Response.Write "<TR><TD class=text_white align=right><A href='JavaScript:history.back(1)'>ย้อนกลับ>></a></TD></TR>"
	Response.Write "</TABLE><br><br>"
end function


function FormatDateAsOf(lang, mDay, mMonth, mYear)
		if lang = 1 then
			FormatDateAsOf = "ข้อมูลล่าสุด " & mDay & " " & getMonthName(lang,mMonth) & " " & getYearLang(lang,mYear)
		else
			FormatDateAsOf = "as of " & mDay & " " & getMonthName(lang,mMonth) & " " & getYearLang(lang,mYear)
		end if
end function

function getYearLang(lang, mYear)
	if lang = 1 then
		if mYear < 2300 then mYear = mYear + 543
	else
		if mYear > 2300 then mYear = mYear - 543
	end if
	getYearLang = mYear
end function

function getMonthName(lang, mMonth)
	if lang=1 then
		select case mMonth
		case 1
			getMonthName = "ม.ค."
		case 2
			getMonthName = "ก.พ."
		case 3
			getMonthName = "มี.ค."
		case 4
			getMonthName = "เม.ย."
		case 5
			getMonthName = "พ.ค."
		case 6
			getMonthName = "มิ.ย."
		case 7
			getMonthName = "ก.ค."
		case 8
			getMonthName = "ส.ค."
		case 9
			getMonthName = "ก.ย."
		case 10
			getMonthName = "ต.ค."
		case 11
			getMonthName = "พ.ย."
		case 12
			getMonthName = "ธ.ค."
		end select
	else
		select case mMonth
		case 1
			getMonthName = "Jan"
		case 2
			getMonthName = "Feb"
		case 3
			getMonthName = "Mar"
		case 4
			getMonthName = "Apr"
		case 5
			getMonthName = "May"
		case 6
			getMonthName = "Jun"
		case 7
			getMonthName = "July"
		case 8
			getMonthName = "Aug"
		case 9
			getMonthName = "Sep"
		case 10
			getMonthName = "Oct"
		case 11
			getMonthName = "Nov"
		case 12
			getMonthName = "Dec"
		end select
	end if
end function

function findFile(pathPicTmp,pathPic,tmpfile)
	dim r, arrinfofile
	dim ofs
	findFile = ""
	set ofs = createobject("scripting.filesystemobject")
	if ofs.FileExists(pathPicTmp&tmpfile) then
		set r = ofs.opentextfile(pathPicTmp&tmpfile,1,False)
		if err.number = 0 then
			if not r.atendofstream then
				arrinfofile = split(r.readline,"#")
			end if
			r.close
			arrinfofile(0)=trim(arrinfofile(0))
			if ofs.FileExists(pathPic&arrinfofile(0)) then
				'delete olf file if exist
				ofs.DeleteFile pathPic&arrinfofile(0)
			end if
			'arrinfofile(0) is a pic's name
			if len(trim(arrinfofile(0))) = 0 then
				arrinfofile(0) = ""
			end if
			

			'move file
			ofs.MoveFile pathPicTmp&arrinfofile(0),pathPic&arrinfofile(0) 

			'delete file
			ofs.DeleteFile pathPicTmp&tmpfile

			findFile = arrinfofile(0)
		end if
	end if
end function

sub deleteFile(pathPic,picName)
	dim ofs
	set ofs = createobject("scripting.filesystemobject")
	if ofs.FileExists(pathPic&picName) then
		ofs.DeleteFile pathPic&picName
	end if
end sub

sub ShowCmbYear(objName, chkY)
	dim cY, i, strS
	cY = 2548
	Response.Write "<Select Name="&objName&">"
	for i = cY to cY+10		
		strS=""
		if i=cY then strS = "Select"
		if i=cint(chkY) then strS= "Select"	
		Response.Write "<option value = '"&i&"'" & strS & ">" & i & "</option>"  
	next
	Response.write "</Select>"
end sub

function CheckExistTable(tablename, condition)
dim strSql
dim objConn
dim rs
	CheckExistTable = false
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select * From " & tablename & " Where "  & condition
'	showstr strsql
	rs.open strSql,objConn
	if not rs.eof then
		CheckExistTable = true
	end if

end function

function CheckActiveCompany()
dim strSql
dim objConn
dim rs
	CheckActiveCompany=0
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select Com_ID From TB_Company Where Active_Com='Y'"
	rs.open strSql,objConn
	if not rs.eof then
		CheckActiveCompany = rs("Com_ID")
	end if
end function

function CheckActiveMeeting(comid)
dim strSql
dim objConn
dim rs
	CheckActiveMeeting=0
	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select MT_ID From TB_Meeting Where Com_ID="&comid&" And MT_Status='Y'"
	rs.open strSql,objConn
	if not rs.eof then
		CheckActiveMeeting = rs("MT_ID")
	end if
end function

function CheckLockMeeting(comid)
dim strSql
dim objConn
dim rs

	Set objConn = Server.CreateObject ("ADODB.Connection")	
	objConn.Open Application("constr")		
	set rs = Server.CreateObject("ADODB.Recordset")	
	strSql = "Select MT_ID,MT_Lock From TB_Meeting Where Com_ID="&comid&" And MT_Status='Y' And MT_Lock='1'"
	rs.open strSql,objConn
	CheckLockMeeting=false
	if not rs.eof then
		CheckLockMeeting = true
	end if
end function

sub ShowStr(strSql)
	Response.write strSql
	Response.End
end sub
  %>
