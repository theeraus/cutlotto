<!--#include virtual="masterpage.asp"-->
<% Sub ContentPlaceHolder() %>

<%
Dim objRS , objDB , SQL
set objDB=Server.CreateObject("ADODB.Connection")       
objDB.Open Application("constr")
Set objRS =Server.CreateObject("ADODB.Recordset")
	
Dim save, end_date
save=Request("save")
end_date=Request("end_date")
If save="yes" Then
	SQL="exec spJClsCredit '" & end_date & "'"
	objDB.Execute(SQL)
	Response.Write "<div class='alert alert-danger'><div class='alert-text'>ระบบทำการลบข้อมูลเครดิต เรียบร้อยแล้ว</div></div>"
End If 
%>

	<form name="form1" action="" method="post">
		<input type="hidden" name="save" value="yes">
	<center>

	<table width="550" cellpadding="3" cellspacing="3">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<fieldset>
					<table>
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>			
							<td class="text_black">ตั้งแต่เริ่ม จนถึงวันที่</td>
							<td><input  name="end_date"  type="text" 
							class="form-control datepicker"  
							data-date-language="th-th"
							readonly placeholder="กรุณาเลือกวันที่" /></td>
							<td>
								<input type="button" class="btn btn-primary" style="width:80;cursor:hand;" value="ตกลง" onclick="click_ok();">
							</td>
						</tr>
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
				</fieldset>
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
	</table>
	</center>
	</form>


<script language="javascript">
	$(function(){
		$('.datepicker').datepicker({
			format: 'dd-mm-yyyy'
		});
	});
	

	function click_ok(){
		if($(".datepicker").val()==""){
			alert("ผิดพลาด : กรุณาระบุวันที่ ที่ต้องการลบข้อมูลเครดิต");
			return false;
		}
		document.form1.submit();
	}
</script>


<% End Sub %>