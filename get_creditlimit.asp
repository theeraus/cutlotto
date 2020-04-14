<%OPTION EXPLICIT%>
<%

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	objDB.CursorLocation = 3 
	Set objRS =Server.CreateObject("ADODB.Recordset")	
	Dim player_id, limit_play, sum_play,can_play
	limit_play=0
	If Request("player_id")<>"" Then
		player_id=Request("player_id")
	else
		player_id=Session("uid")
	End If 
	'// หา เครดิตสูงสุด
	SQL="exec spJSelectPlayerDet " & player_id & ", " & Session("gameid")	

	set objRS=objDB.Execute(SQL)
	if Not objRS.eof Then
		If CDbl(objRS("limit_play"))>0 then
			limit_play=FormatNumber(objRS("limit_play"),0)
		Else
			limit_play=0
		End if
		If CDbl(objRS("sum_play"))>0 then
			sum_play=FormatNumber(objRS("sum_play"),0)
		Else
			sum_play=0
		End If
		If ( CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")) ) > 0 Then
			can_play=FormatNumber(CDbl(objRS("limit_play")) - CDbl(objRS("sum_play")),0)
		Else
			can_play=0
		End if	
	End If
	

%>
<script language="javascript">
		parent.document.all.limit_play.innerText='<%=limit_play %>'
		parent.document.all.can_play.innerText='<%=can_play %>'
</script>