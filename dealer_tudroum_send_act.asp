<%@ Language=VBScript %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="content-type" content="text/html; charset=tis-620">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<%Response.Buffer = True%>
<%
dim objRec
dim strSql
dim i
dim chkTud
dim cutSeq
dim cutallid
dim sumall 

dim arrNum
dim arrMoney
dim arrCuttype

Dim updown_type_col1 , key_number , key_money ,updown_type, key_seq, number_status
Dim player_id, ticket_number, game_id , rec_status, ticket_id, send_status, key_from, key_id
	'*** Open the database.	
	Set objRec = Server.CreateObject ("ADODB.Recordset")

	if Request("act")="save" then
		player_id=Session("otheruid")
		game_id=CheckOtherGame(Session("otherdid"))
		ticket_number=Getticket_number(player_id , game_id )
		rec_status=mlnStatusSend ' ส่ง
		send_status=mlnSendOtherDealer  ' 
		key_from=mlnKeyCom       ' แทงจาก com 
		key_id=Session("otheruid")
		strSql=""
		strSql="spInsert_tb_ticket (" & game_id & ", "  & _
											ticket_number & ", " & _
											player_id & ", " & _
											rec_status  & ", " & _
											send_status	 & ", " & _
											key_from & ", " & _
											key_id & ")"
		set objRec=conn.Execute(strSql)																
		if not objRec.EOF then
			ticket_id=objRec("ticket_id")
		end if
		objRec.close

		strSql = "SELECT tb_cut_all.cutall_id, tb_cut_all_det.cutall_det_id, tb_cut_all_det.play_type, tb_cut_all_det.play_number, tb_cut_all_det.play_amt " _
			& "FROM tb_cut_all INNER JOIN tb_cut_all_det ON tb_cut_all.cutall_id = tb_cut_all_det.cutall_id"
		objRec.Open strSql,conn
		i=0
		do while not objRec.eof
			i=i+1
			select case objRec("play_type")
			case 1,2,3,4,5
				updown_type=mlnUp
			case 6,7,8
				updown_type=mlnDown
			end select			
			key_number=objRec("play_number")
			key_money=objRec("play_amt")
			key_seq=i
			number_status=mlnNumStatusSend    '  ส่ง
			if updown_type <>""  and  key_number<>"" and  key_money <>"" then
				'--- insert into tb_ticket_key
				strSql="spInsert_tb_ticket_key (" & _
							ticket_id & ", " & _
							key_seq & "," & _
							updown_type & ", " & _
							"'" & key_number & "', " & _
							"'" & key_money &  "'," & _
							number_status & ")" 					
				comm.CommandText = strSql
				comm.CommandType = adCmdStoredProc
				comm.Execute
			end if
			objRec.MoveNext
		loop
		objRec.close
		response.redirect "dealer_play_out.asp"	
'		comm.CommandText = StrSql
'		comm.CommandType = adCmdText
'		comm.Execute




	end if
Function GetSend(p,g)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetSend " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetSend = objRS("send")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReceive(p,g)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReceive " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReceive = objRS("receive")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetReturn(p,g)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetReturn " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetReturn = objRS("returned")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function GetTotalPlay(p,g)
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetTotalPlay " & p & "," & g
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		GetTotalPlay = objRS("total_play_amt")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
Function convUpDownType(t)
	if t="ล" then
		convUpDownType=1
	end if
	if t="บ" then
		convUpDownType=2
	end if
	if t="บ+ล" then
		convUpDownType=3
	end if
End Function
Function Getticket_number( p, g )
	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	SQL="exec spGetticket_number " & p & "," & g & ",1"
	set objRS=objDB.Execute(SQL)
	if not objRs.EOF then
		Getticket_number = objRS("ticket_number")
	end if
	set objRS=nothing
	set objDB=nothing
End Function
%>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
<Title></Title>
</HEAD>
<BODY topmargin=0 leftmargin=0>

<SCRIPT LANGUAGE=vbscript RUNAT=Server>
'	sub ExcuteCommand(Byval strSql) 
	dim rs


	dim strTitle
	dim strMsg 
	dim strGoto
	dim RndPw
	dim LenPw
	dim strPw
	dim chkOk
    Session("userid")    = Request("txtUserName")
    Session("password")  = Request("password1")
    Session("logintime") = now




	Set objConn = Server.CreateObject ("ADODB.Connection")
	objConn.Open Application("constr")	
	
	chkOk = false
	LenPw = len(Request("password1"))
		Set rs = server.createobject("ADODB.Recordset")
		strSql = "Select * From sc_user Where user_name='" & Request.Form("txtUserName") & "' And user_disable=0"
'showstr strsql
		rs.Open strSql,objConn
		if not rs.eof then
			RndPw = Mid(rs("user_password"),1,1)
			strPw = EncryptPws(Request("password1"),RndPw)
			if strPw = rs("user_password") then
				chkOk = true
				Session("otheruid")=rs("user_id")
				Session("otherdid")	=rs("create_by")
			else
				strMsg = "รหัสผ่านไม่ถูกต้อง !"
			end if
		else
			strMsg = "ไม่พบรหัสผู้ใช้ !"
		end if
		set rs = nothing
		set objConn = nothing

	if chkOk =true then
		response.redirect "dealer_tudroum_send_act.asp?act=save"	
	else
		call showmessage(strMsg&"&nbsp;&nbsp;[<a href='index.asp?page=dealer_tudroum_send.asp'>ย้อนกลับ</a>]")
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

