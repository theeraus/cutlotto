<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<%Response.Buffer = True%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<Title></Title>
</HEAD>
<BODY topmargin=0 leftmargin=0>


<SCRIPT LANGUAGE=vbscript RUNAT=Server>
'	sub ExcuteCommand(Byval strSql) 
	dim rs
	dim objConn
	dim strSql
	dim strTitle
	dim strMsg 
	dim strGoto
	dim RndPw
	dim LenPw
	dim strPw
	dim chkOk
	dim buser
	dim bpass
	dim bdealer
	buser=trim(Request("txtUserName"))
	bpass=trim(Request("password1"))
	bdealer=trim(Request("txtdealer"))
    Session("userid")    = buser
    Session("password")  = bpass
    Session("logintime") = now
	Session("refreshtime")=""

	strTitle = "ตรวจสอบผู้ใช้ระบบ"
	strGoto= "index.asp?pname=signin"	
	Set objConn = Server.CreateObject ("ADODB.Connection")
	objConn.Open Application("constr")	
	
	chkOk = false
	LenPw = len(Request("password1"))
		Set rs = server.createobject("ADODB.Recordset")
		'ถ้า User name เป็นช่องว่างแสดงว่าเป็น เจ้ามือ รหัสเจ้ามือ กับ พาสเวอร์ดไม่ว่าง
		'ถ้า เจ้ามือ ว่าง user ไม่ว่าง พาสเวร์ดไม่ว่าง เป็น admin
		'ถ้าไม่ว่างทั้ง สาม เป็นคนแทง

		if buser <> "" and bdealer <> "" and bpass <> "" then 'คนแทง
			strSql = "SELECT     sc_user.*, sc_user_1.user_name AS dealer_fname FROM         sc_user INNER JOIN sc_user sc_user_1 ON sc_user.create_by = sc_user_1.user_id " _
				& "Where (sc_user.user_name='" & buser & "' or sc_user.login_id='" & buser & "') "
				strSql = strSql & " And (sc_user_1.user_name ='" & bdealer & "' or sc_user_1.login_id='" & bdealer & "') and sc_user.user_type='P'"
		elseif buser = "" and bdealer <> "" and bpass <> "" then ' เจ้ามือ
			strSql = "Select * From sc_user Where "
			strSql = strSql & " (login_id='" & bdealer & "' or user_name='" & bdealer & ") and sc_user.user_type='D'"
		elseif buser <> "" and bdealer = "" and bpass <> "" then ' admin / เจ้ามือ
			strSql = "Select * From sc_user Where "
			strSql = strSql & " (user_name='" & buser & "' or login_id='"& buser &"') and sc_user.user_type <> 'P'"
		end If
		'// jum 2006-07-05
		If bdealer<>"" And lcase( Left(buser,1))="k" Then ' คนคีย์
			strSql="select b.user_id,a.user_name, a.user_type,a.create_by , a.login_id, "
			strSql=strSql & " a.user_password , a.user_disable ,a.refresh_time "
			strSql=strSql & " from sc_user a inner join "
			strSql=strSql & " sc_user b on a.create_by=b.user_id "
			strSql=strSql & " where a.user_type='K' and a.login_id='" & buser & "' "
			strSql=strSql & " and  b.login_id='" & bdealer & "' and b.user_type='D' "
			
		End if
'showstr strSql
		rs.Open strSql,objConn
		if not rs.eof then
			RndPw = Mid(rs("user_password"),1,1)
			strPw = Request("password1")'EncryptPws(Request("password1"),RndPw)
			if rs("user_disable") = true then
				strMsg = "กรุณาติดต่อผู้ดูแลระบบ !"
			elseif strPw = rs("user_password") then
				chkOk = true
				Session("uid")=rs("user_id")
				Session("uname")=""&rs("user_name")
				Session("utype")=""&rs("user_type")
				Session("did")	=rs("create_by")
				Session("logid")=rs("login_id")
				if Not isnull(rs("refresh_time")) and  rs("refresh_time") > 0 then
					Session("refreshtime")=rs("refresh_time")
				end If
				If Session("utype")="K" Then CheckGame(Session("uid"))

				strSql="update sc_user set activate_time=GetDate(), cnt_login = cnt_login + 1, cnt_dealer= cnt_dealer + 1 where [user_id]=" & Session("uid")
				comm.CommandText = strSql
				comm.CommandType = adCmdText
				comm.Execute


			else
				strMsg = "รหัสผ่านไม่ถูกต้อง !"
			end if
		else
			strMsg = "ไม่พบรหัสผู้ใช้ !"
		end if
		set rs = nothing
		set objConn = nothing

	if chkOk =true then
		Session("chkid")= Session.SessionID
		'// jum 2006-11-29 
		Dim oSecurity, strRedi
		set oSecurity = server.createobject("DLLGetMacAddr.clsGetMacAddress")
		strRedi=oSecurity.strRedi(Session("utype"))
		response.redirect strRedi		
	else
		call showmessage(strMsg&"&nbsp;&nbsp;[<a href='index.asp?page=signin.asp'>ย้อนกลับ</a>]")
		Response.end		
	end if	

	
Function EncryptPws(ByVal inPws, byval RndPw)
Dim LenPws
Dim enPws
Dim I
dim tmp
Dim chkRnd
        If RTrim(inPws) = "" Then
                EncryptPws = ""
                Exit Function
        End If
        chkRnd = RndPw
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

'	End sub
</Script>

</body>
</html>