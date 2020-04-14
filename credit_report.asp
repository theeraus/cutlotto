<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>

<html>
<head>
<title>.:: config price ::. </title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<!-- <meta http-equiv="refresh" content="10"> -->
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/normalfunc.js"></script>
 <script language='JavaScript' src='include/popcalendar.js' type='text/javascript'></script>
 <script type="text/javascript" src="jquery/jquery-1.2.3.js"></script>
<script type="text/javascript" src="jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="jquery/jquery.form.js"></script>
<script language="javascript">
	var loading_img = '<img src="images/loading.gif" border="0">';
	$().ajaxStop($.unblockUI);
	function block() {
		$.blockUI(loading_img);
	}

	function getUrl(url) {
		block();
		window.location = url;
	}


	function searchSubmit(action_url) {
		if(document.getElementById('start_date').value==''){alert('��س��к� ������ѹ���');return}
		if(document.getElementById('end_date').value==''){alert('��س��к� �֧�ѹ���');return}
		if(!(document.getElementById('all_login_no').checked)){		
			if(document.getElementById('start_login_no').value=='' || document.getElementById('end_login_no').value==''){
				alert("��س��к� ����");return;
			}
		}
		$('#myform').ajaxSubmit({
			url: action_url,
			beforeSubmit: block,
			clearForm: false,
			success: function(msg){
					$('#divBody').html(msg);
			}
		})
	}
	
	function displayExcelPage() {
		if(document.getElementById('start_date').value==''){alert('��س��к� ������ѹ���');return}
		if(document.getElementById('end_date').value==''){alert('��س��к� �֧�ѹ���');return}
		var start_date = document.getElementById('start_date').value;
		var end_date = document.getElementById('end_date').value;
		var start_login_no = document.getElementById('start_login_no').value;
		var end_login_no = document.getElementById('end_login_no').value;
		window.open('credit_report_response.asp?start_date='+start_date+'&end_date='+end_date+'&end_login_no='+end_login_no+'&start_login_no='+start_login_no+'&printtype=excel');
	}
</script>
</head>

<!--#include file="mdlGeneral.asp"-->
<body>
	<form name="myform" id="myform" action="" method="post">
		<center>
			<table cellspacing="1" cellpadding="1" border=0>
			<tr><td><fieldset>
			<table cellspacing="1" cellpadding="1">
				<tr>
					<td class="head_blue" colspan="4" align="center"><b>��§ҹ�ôԵ</b></td>
				</tr>
				<tr>
					<td class="head_blue" colspan="4" align="center"><hr style="height:1;"></td>
				</tr>
				<tr>
					<td class="text_black">������ѹ��� &nbsp;</td>
					<td> <input type=text name='start_date'   value=""  maxlength='20' size='10'  readonly class="text_black"><a href="javascript:"> <img src='images/cal.gif' align='absbottom' border="0" onclick="popUpCalendar(this,start_date,'dd-mm-yyyy');"></a> </td>
					<td class="text_black">&nbsp;&nbsp;&nbsp;�֧�ѹ��� &nbsp;</td>
					<td> <input type=text name='end_date'   value=""  maxlength='20' size='10'  readonly class="text_black"><a href="javascript:"> <img src='images/cal.gif' align='absbottom' border="0" onclick="popUpCalendar(this,end_date,'dd-mm-yyyy');"></a> </td>
				</tr>
				<tr>
					<td class="text_black">�ҡ���� &nbsp;</td>
					<td><input type=text name='start_login_no'   value=""  maxlength='6' size='14'  class="text_black"></td>
					<td class="text_black">&nbsp;&nbsp;&nbsp;�֧���� &nbsp;</td>
					<td><input type=text name='end_login_no'   value=""  maxlength='6' size='14'  class="text_black"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="text_black" colspan="3"><input type="checkbox" name='all_login_no'  id="all_login_no"  value=""  maxlength='6' size='10'  class="text_black"> &nbsp;�ҡ���ʷ���������դ�������͹��� &nbsp;</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input type="button" value="����§ҹ" style="cursor:hand;width:120;"  onClick="searchSubmit('credit_report_response.asp');">
						&nbsp;&nbsp;<input type="button" name="export_excel" id="export_excel" value="�ʴ���§ҹ�� Excel" style="cursor:hand;width:140;" onClick="displayExcelPage();">
						&nbsp;&nbsp;<input type="button" value="��Ѻ˹����ѡ" style="cursor:hand;width:120;" onClick="window.open('price_player_config.asp','_self')">
						
					</td>
				</tr>
			</table>
			</fieldset></td></tr>
			</table>
		</center>
	</form>
	<div style="width:auto; overflow:auto;" id="divBody"></div>
</body>
</html>

