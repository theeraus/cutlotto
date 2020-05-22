<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<%

		Dim objRS , objDB , SQL, dealer_id, game_type	, from_click_submit, chr_search
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")	
		dealer_id=Request("dealer_id")
		game_type=Request("game_type")
		from_click_submit=Request("from_click_submit")
		chr_search=Request("chr_search")
%>
<html>
<head>
<title>.:: ค้นหา : คนแทง ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0" leftmargin="0" scroll = no  style="border : solid #606060; border-width : 1px;">
	<form name="form1" action="search_player.asp" method="post">
	<table align="center" cellpadding="0" cellspacing="0" width="100%" border="0">
	<tr bgcolor="#CD9BFF">
			<td height="25" >
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="tdbody1"> ค้นจาก ชื่อ หรือ หมายเลข <span id=search_text></span></td>
						<td  align="right"><img src="images/close.gif" align="absmiddle" style="cursor:hand; " onClick="parent.closeDialog()">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height="10">
			<td></td>
		</tr>
		<tr>
			<td align="center" >			

				<table width="95%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
					<input type="hidden" name="from_click_submit" value="yes">
					<input type="hidden" name="game_type" value="<%=game_type%>">
					<input type="hidden" name="dealer_id" value="<%=dealer_id%>">
					<tr>
						<td bgcolor="#B3FFD9">
							<input type="text" size="10" name="chr_search" class="input1">&nbsp;
							<input type="button" value=" ค้นหา " onClick="clickOK()" style="cursor:hand;">
							&nbsp;&nbsp;<input type="button" value=" ยกเลิก " onClick="clickCancel()" style="cursor:hand;">
						</td>
					</tr>
					<tr>
						<td bgcolor="#B3FFD9" align="center">
						<div style="width:100%;height:320 ;overflow:auto;" > 
						<table width="99%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#606060">
					<%
						if from_click_submit<>"yes" then ' ถ้าเข้ามาครั้งแรกให้แสดง ทุก player 
							SQL="exec spGetPlayerPrice_by_Dealer_ID_GameType  " & dealer_id & "," & game_type
						else
							SQL="exec spGetPlayerPrice_by_Dealer_ID_GameType_pname " & dealer_id & "," & game_type & ",'" & chr_search & "'"
						end if						
						set objRS=objDB.Execute(SQL)
						while not objRS.eof								
							%>
							<tr onClick="select_player(
										<%=objRS("p1")%>,
										<%=objRS("p2")%>,
										<%=objRS("p3")%>,
										<%=objRS("p4")%>,
										<%=objRS("p5")%>,
										<%=objRS("p6")%>,
										<%=objRS("p7")%>,
										<%=objRS("p8")%>,
										<%=objRS("d1")%>,
										<%=objRS("d2")%>,
										<%=objRS("d3")%>,
										<%=objRS("d4")%>,
										<%=objRS("d5")%>,
										<%=objRS("d6")%>,
										<%=objRS("d7")%>,
										<%=objRS("d8")%>
										)" style="cursor:hand;">
								<td class="tdbody1" bgcolor="#FFFFA4"><%=objRS("login_id")%></td>
								<td class="tdbody1" bgcolor="#FFFFA4"><%=objRS("player_name")%></td>
							</tr>
							<%
							objRS.MoveNext
						wend
					%>											
						</table>
						</td>
					</tr>
				</table>
			</td>		
		</tr>
	</table>
	</center>
	</form>
</body>
</html>
<script language="javascript">
	function clickOK(){
		document.form1.submit();
	}
	function clickCancel(){
	parent.closeDialog();
	}
	function select_player(p1,p2,p3,p4,p5,p6,p7,p8,d1,d2,d3,d4,d5,d6,d7,d8){
		parent.document.form1.p1.value=p1
		parent.document.form1.p2.value=p2
		parent.document.form1.p3.value=p3
		parent.document.form1.p4.value=p4
		parent.document.form1.p5.value=p5
		parent.document.form1.p6.value=p6
		parent.document.form1.p7.value=p7
		parent.document.form1.p8.value=p8

		parent.document.form1.d1.value=d1
		parent.document.form1.d2.value=d2
		parent.document.form1.d3.value=d3
		parent.document.form1.d4.value=d4
		parent.document.form1.d5.value=d5
		parent.document.form1.d6.value=d6
		parent.document.form1.d7.value=d7
		parent.document.form1.d8.value=d8
		parent.closeDialog();
	}
</script>
