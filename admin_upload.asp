<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>ASP Upload</TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
</HEAD> 
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
// คำสั่ง java script สำหรับการตรวจสอบการป้อนข้อมูล
function validate(){

     if (document.upload.file.value=="") {
          alert("กรุณาเลือก File ที่ต้องการ upload..!");
          document.upload.file.focus();
          return false;
     }
     if (confirm("คุณต้องการส่ง file ที่คุณเลือกหรือไม่?")) {
          return true;
     } else {
          return false;
     } 
}
// End -->
</script> 



<BODY>

<form name="upload" action="upload.asp" method="post" enctype="multipart/form-data" onsubmit="return validate();">
<table width="400" border="0" align="center">
      <tr>
          <td width="27%">&nbsp;</td>
          <td width="73%"><font size="2"><b>ไฟล์ Help</b></font></td>
     </tr>
     <tr>
          <td nowrap>File ที่ต้องการ Upload</td>
          <td><input type="file" name="file" size="50"></td>
     </tr>
     <tr>
          <td>&nbsp;</td>
          <td><input type="submit" name="Submit" value="Submit">
          <input type="reset" name="Submit2" value="Reset"></td>
     </tr>
</table>
</form>

</BODY>
</HTML>