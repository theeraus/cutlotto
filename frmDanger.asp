<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="include/config.inc"-->
<%
		if trim(Session("uid"))="" then 	response.redirect "signin.asp"
		Dim mode
		Dim objRS , objDB , SQL	, tmp_Color
		Dim dealer_id
		dealer_id=Request("dealer_id")
		set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
		Set objRS =Server.CreateObject("ADODB.Recordset")		

'			Dim danger_numbers, danger_number
'			danger_numbers = split(Request("danger_number"),",")
'			for i = 0 to Ubound(danger_numbers)
'				 danger_numbers(i)
'			Next
		mode=Request("mode")			
		Dim si,sj, danger_number
		si=1
		If mode="clear" Then
			SQL="delete tb_danger_number where dealer_id=" & dealer_id
			objDB.Execute(SQL)
		End if
		If mode="save" Then
			SQL="delete tb_danger_number where dealer_id=" & dealer_id
			objDB.Execute(SQL)
			While si<=40
				sj=1
				While sj<=8
					danger_number=Request("danger_number" & si & "_" & sj)
					If danger_number<>"" Then
						SQL="insert into tb_danger_number ( "
						SQL=SQL & " dealer_id , play_type, danger_number ) values ("
						SQL=SQL & dealer_id & ", "
						SQL=SQL & sj  & ", "
						SQL=SQL & "'" & danger_number & "' ) "
						objDB.Execute(SQL)
					End if
					sj=sj+1
				wend		
				si=si+1
			wend
		End if
		SQL="select * from tb_danger_number where dealer_id=" & dealer_id
		Set objRS=objDB.Execute(SQL)
		Dim arr
		reDim arr(40,8)			
		Dim i1,i2,i3,i4,i5,i6,i7,i8
		i1=1
		i2=1
		i3=1
		i4=1
		i5=1
		i6=1
		i7=1
		i8=1
		While Not objRS.eof
			Select case CInt(objRS("play_type"))
				Case 1
					arr(i1,1)=Trim(objRS("danger_number"))
					i1=i1+1
				Case 2
					arr(i2,2)=Trim(objRS("danger_number"))
					i2=i2+1
				Case 3 '3 โต๊ด
					arr(i3,3)=Trim(objRS("danger_number"))
					i3=i3+1
				Case 4 ' 2 โต๊ด
					arr(i4,4)=Trim(objRS("danger_number"))
					i4=i4+1
				Case 5 ' วิ่งบน
					arr(i5,5)=Trim(objRS("danger_number"))
					i5=i5+1
				Case 6 ' วิ่งล่าง
					arr(i6,6)=Trim(objRS("danger_number"))
					i6=i6+1
				Case 7 ' 2 ล่าง
					arr(i7,7)=Trim(objRS("danger_number"))
					i7=i7+1
				Case 8 ' 3 ล่าง
					arr(i8,8)=Trim(objRS("danger_number"))
					i8=i8+1
			End select
			objRS.moveNext
		wend
		
%>
<html>
<head>
<title>.:: เลขอันตราย ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script language="JavaScript" src="include/normalfunc.js"></script>
<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

</head>
<body topmargin="0"  leftmargin="0">
	<form name="form1" action="frmDanger.asp?dealer_id=<%=dealer_id%>" method="post">
	<input type="hidden" name="mode" value="save">
	<center><br><font color=red size=+1><b>เลขอันตราย</b></font><br>
	<hr style="height:1;" color=red><br>
	<table width="100%"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF" class="table">
		<tr>
			<td colspan="8" align="right">
				<input type="button" class="btn btn-danger btn-sm" name="clear_data" value="ล้างเลขอันตราย" style="cursor:hand;width:100;" onClick="click_clear();">
				<input type="button" class="btn btn-primary btn-sm" name="save_data" value="บันทึก" style="cursor:hand;width:100;" onClick="click_save();">

			</td>
		</tr>
		<tr class=head_white align=center>
			<td bgColor="#4f4f4f">
			2 บน
			</td>
			<td bgColor="#6600cc">
			3 บน
			</td>
			<td bgColor="#4f4f4f">
			3 โต๊ด
			</td>
			<td bgColor="#6600cc">
			2 โต๊ด
			</td>
			<td bgColor="#4f4f4f">
			วิ่งบน
			</td>
			<td bgColor="#6600cc">
			วิ่งล่าง
			</td>
			<td bgColor="#4f4f4f">
			2 ล่าง
			</td>
			<td bgColor="#6600cc">
			3 ล่าง
			</td>
		</tr>
		<%
		Dim i , j , myColor
		i=1
		While i<=40
			%>
		<tr align=center>
			<%
			j=1	
			While j<=8
			If (j Mod 2 )= 1  Then
				myColor="white"
			Else
				myColor="#D7FFFF"			
			End if

			%><td bgColor=<%=myColor%>>
			<input type="text" size="10" name="danger_number<%=i%>_<%=j%>" 
			id="number<%=i%>_<%=j%>" 
			value="<%=arr(i,j)%>" onKeyDown="chkEnter(this,<%=i%>,<%=j%>);">
			</td><%	
				j=j+1
			wend
			%>
		</tr>
			<%
			i=i+1
		wend
		%>
		<tr height="45">
			<td colspan="8" align="right">
				<input type="button" class="btn btn-danger btn-sm" name="clear_data" value="ล้างเลขอันตราย" style="cursor:hand;width:100;" onClick="click_clear();">
				<input type="button" class="btn btn-primary btn-sm" name="save_data" value="บันทึก" style="cursor:hand;width:100;"
				onClick="click_save();">

			</td>
		</tr>
	</table><br>
	</center>
	</form>
</body>
</html>
			
<script language="javascript">
	function click_clear(){
		if(confirm('คุณต้องการล้างเลขอันตราย ? ')){
			document.form1.mode.value="clear";
			document.form1.submit();
		}
	}
	function chkEnter(obj,i,j){
		var k=event.keyCode
		if (k == 13){			
			validate
			if(i==40){
				i=0;
				j=j+1;
			}
			id='number'+(parseFloat(i)+1)+'_'+j;
			if(validate(obj,i,j)){
				next_obj = document.getElementById(  id )
				next_obj.focus();
			}
		}
	}
	function validate(obj,i,j){
		//--
		if (obj.value.indexOf('.') >=0){
			alert('ผิดพลาด : กรุณากรอกเลขแทงเป็นตัวเลขเท่านั้น !!!')
			return false
		}
		if( isNaN(obj.value)){
			alert('ผิดพลาด : กรุณากรอกเลขอันตราย เป็นตัวเลขเท่านั้น !!!')
			return false
		}
		if(j==1){ // 2บน
			if(obj.value.length!=2){
				alert("กรุณากรอกให้ครบ 2 หลัก");
				return false;
			}
		}
		if(j==2){ // 3บน
			if(obj.value.length!=3){
				alert("กรุณากรอกให้ครบ 3 หลัก");
				return false;
			}
		}
		if(j==3){ // 3โต๊ด
			if(obj.value.length!=3){
				alert("กรุณากรอกให้ครบ 3 หลัก");
				return false;
			}
			// เรียงเลขใหม่ 
			var n1,n2,n3, x1,x2,x3,x4,x5,x6, xMin
			n1=obj.value.substring(0,1)
			n2=obj.value.substring(1,2)
			n3=obj.value.substring(2,3)
			x1=n1+n2+n3;
			x2=n1+n3+n2;
			x3=n3+n2+n1;
			x4=n2+n1+n3;
			x5=n2+n3+n1;
			x6=n3+n1+n2;
			xMin=x1;
			if(xMin>x2){xMin=x2;}
			if(xMin>x3){xMin=x3;}
			if(xMin>x4){xMin=x4;}
			if(xMin>x5){xMin=x5;}
			if(xMin>x6){xMin=x6;}
			obj.value=xMin;			
		}
		if(j==4){ // 2 โต๊ด
			if(obj.value.length!=2){
				alert("กรุณากรอกให้ครบ 2 หลัก");
				return false;
			}
		}
		if(j==5){ // วิ่งบน
			if(obj.value.length!=1){
				alert("กรุณากรอกให้ครบ 1 หลัก");
				return false;
			}
		}
		if(j==6){ // วิ่งล่าง
			if(obj.value.length!=1){
				alert("กรุณากรอกให้ครบ 1 หลัก");
				return false;
			}
		}
		if(j==7){ // 2 ล่าง
			if(obj.value.length!=2){
				alert("กรุณากรอกให้ครบ 2 หลัก");
				return false;
			}
		}
		if(j==8){ // 3ล่าง
			if(obj.value.length!=3){
				alert("กรุณากรอกให้ครบ 3 หลัก");
				return false;
			}
		}
		//--
		return true;
	}
	function click_save(){
		var i,j, id
		for (i=1; i<=40 ; i++){
			for (j=1; j<=8 ; j++){
				id="number"+i+"_"+j;
				obj = document.getElementById(  id )
				if(obj.value.length!=0){	
					if (!(validate(obj,i,j) )  ) {
						alert("กรุณาตรวจสอบเลขอันตราย ")
						obj.focus();
						return false;
					}
				}
			}		
		}
		document.form1.submit();
	}
</script>