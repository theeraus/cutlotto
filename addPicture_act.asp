<%@ Language=VBScript %>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<%check_session_valid()%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%Response.Buffer = True%>

<%
dim pathPicTmp, pathPic, tmpfile

		pathPicTmp = "D:\hshome\step88\step88.com\images\"
		pathPic= "D:\hshome\step88\step88.com\"
		set oUp = server.createobject("Dundas.Upload.2")
		oUp.UseUniqueNames = false
		oUp.Save pathPicTmp
		tmpfile=oUp.form("tmpfile").value
		For Each objUploadedFile in oUp.Files
			fullpath = trim(objUploadedFile.Path)
			filename =  right(fullpath,len(objUploadedFile.Path) - instrrev(fullpath,"\"))
			filesize = objUploadedFile.Size
			filetype = objUploadedFile.contenttype
		Next
		'response.write "<br> ==== saved ====="
		set ofs = createobject("scripting.filesystemobject")
		set afs = ofs.createtextfile(pathPicTmp&oUp.form("tmpfile").value,true)
		afs.writeline(filename&"#"&filesize&"#"&filetype&"#"&now)
		afs.close



		
		on error resume next
		set ofs = createobject("scripting.filesystemobject")
		set r = ofs.opentextfile(pathPicTmp&tmpfile,1,False)
		if err.number = 0 then
			if not r.atendofstream then
				arrinfofile = split(r.readline,"#")
			end if
			r.close
			'delete old file
			ofs.DeleteFile pathPic&"help.xls"				

			'move file
			ofs.MoveFile pathPicTmp&arrinfofile(0),pathPic&"help.xls"

			'delete file
			ofs.DeleteFile pathPicTmp&tmpfile				

		end if
		on error goto 0


%>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
<meta http-equiv="Content-Type" content="text/html;  charset=windows-874">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<LINK href="include/code.css" type=text/css rel=stylesheet>
<script language="JavaScript" src="include/normalfunc.js"></script>
</HEAD>
<BODY topmargin=0 leftmargin=0>

<center><br><br>
<table width="300" border="0." cellspacing="0" cellpadding="0" align="center">
<tr valign="top"> 
<td align="center" class="normal"> 
		<%showmessage "ทำการ Upload file เรียบร้อยแล้ว"%>
</td>
</tr>
</td>
<td align="center" class="normal"> 
		ทดสอบเปิดไฟล์ <a href="help.xls" target="_blank">วิธีการแทง</a>
		<br><br><br><br>
</td>
</tr>
<tr>
	<td class="normal" align=center>[ <a href="javascript:history.back(1)">ย้อนกลับ</a> ]</td>
</tr>
</table>


<br><br></center>