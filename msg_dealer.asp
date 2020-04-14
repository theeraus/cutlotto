<html>
<head>
<title>.:: Link Web ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
<style type="text/css">
  <!--
  div#blinking {text-decoration: blink;}
  -->
</style>

</head>
<body topmargin="0"  leftmargin="0">



  <!--******************************************************************news*********************************************************************************-->
    
    
<!--group_type // DB:msg_type  =  2  = ข้อความ Dealer-->
    
    <form name="form_news" action="msg_dealer.asp" method="post">
    <input type="hidden" name="group_type" value="2">
	<input type="hidden" name="edit_msg_id">
	<center><br>
    <strong class="tdbody">	&bull;  #  แจ้งข่าวสารลูกค้า #  &bull;</strong>
    
    
	<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
	<tr>
			<td width="50%">&nbsp;&nbsp;&nbsp;
                       <img src="images/add.jpg" style="cursor:hand;" onClick="click_add();">
			</td>

	</tr>
	</table>
    
    
	<table  border="0"  cellpadding="1" cellspacing="1"  width="100%">
	<tr>
			<td align="center" colspan=2>
                    
			<table  border="0"  cellpadding="1" cellspacing="1" bgcolor="#000040" width="98%">
			
            <tr>
					
                    <td class="textbig_white" align="center" bgcolor="#000066" colspan="2"></td>
                    <td class="textbig_white" align="center" bgcolor="#000066">ข่าวสาร</td>
                    <td class="textbig_white" align="center" bgcolor="#000066">การแสดงผล</td>
			</tr>
							
			
									<tr>
										<td bgcolor="#FFFFFF"  width="3%">
											<img src="images/edit.jpg" style="cursor:hand;"   onClick="click_edit('157');" >
										</td>											
										<td bgcolor="#FFFFFF" width="3%">
											<img src="images/del.jpg" style="cursor:hand;"   onClick="click_del('157','555 ');" >
										</td>
                                        
                             										
										<td class="tdbody" bgcolor="#FFFFA4" align="left" >555 	</td>
										
                                        <td class="tdbody" width="25%" bgcolor="#FFFFA4">502017  //  Test</td>
									</tr>
									<!----------------------------------------------------------->
								

                                	
                            
                            
                            
                            
						</table>
				  </td>
				</tr>
			</table>
            
            
	</center>
	<input type="hidden" name="mode">
	<input type="hidden" name="edit_user_id">
	</form>
    


</body>
</html>


<script language="javascript">
function clickpic(p){
	var t=p

	//alert(t)
	// รัฐบาล
	if (t==1){
		document.mypic.src ="images/price_tos.jpg"
		document.form_news.game_type.value="2"
	}
	// ออมสิน
	if (t==2){
		document.mypic.src = "images/price_oth.jpg";
		document.form_news.game_type.value="3"
	}
	// อื่นๆ
	if (t==3){
		document.mypic.src = "images/price_gov.jpg"
		document.form_news.game_type.value="1"
	}
	document.form_news.mode.value="chg_game_type";
	document.form_news.submit();
}	

function click_edit(msg_id){
	document.form_news.mode.value="edit";
	document.form_news.edit_msg_id.value=msg_id;
	document.form_news.submit();
}



function click_del(msg_id,msg_detail){
	if (confirm('คุณต้องการลบรายการ ' + msg_detail+' ?' )){
		document.form_news.mode.value="delete";
		document.form_news.edit_msg_id.value=msg_id;
		document.form_news.submit();
	}
}

function click_cancel(){
	document.form_news.mode.value="cancel";
	document.form_news.edit_user_id.value=""
	document.form_news.submit();
}


// แก้ไขแล้ว  Edit
// ========================================

function click_edit_save(msg_id){
	if (document.form_news.msg_detail.value=="")
	{
		alert("กรุณากรอกข้อมูลข่าวสาร")
		document.form_news.msg_detail.focus();
		return false
	}
	
	
	document.form_news.mode.value="edit_save";
	document.form_news.edit_msg_id.value=msg_id;
	document.form_news.submit();
}


// ========================================




// แก้ไขแล้ว  ปุ่มเพิ่ม
// ========================================

function click_add(){	
	document.form_news.mode.value="add_new";
	document.form_news.submit();
}

// ========================================




// แก้ไขแล้ว  ปุ่มบันทึก ขณะเพิ่ม
// ========================================


function click_add_save(){
	if (document.form_news.msg_detail.value==""){
		alert('ผิดพลาด : กรุณากรอกข้อมูลข่าวสาร')
		document.form_news.msg_detail.focus();
		return
	}
	document.form_news.mode.value="add_save";
	document.form_news.submit();
}

function click_status(user_id){
	document.form1.mode.value="edit_status";
	document.form1.edit_user_id.value=user_id;
	document.form1.submit();
}



</script>
	


<script language="vbscript">

	function formatnum( num )
		num = FormatNumber( num, 0 )
		formatnum = num
	end function
</script>


<script language="JavaScript">

   function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode
         if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;

         return true;
      }
	  
	  
	  //เช็ค กด enter
function chkEnter(obj){
		var k=event.keyCode
		if (k == 13){	
	//alert(obj.name);

			if(obj.name=="msg_detail"){
				document.form1.msg_detail2.focus();
			}

			
		}
	}
</script>