<%
' Author Philippe Collignon
' Email PhCollignon@email.com
' Credit ให้เขาด้วยนะครับกรุณาอย่าเอาออก 

Response.Expires=0
Response.Buffer = TRUE
Response.Clear
byteCount = Request.TotalBytes
RequestBin = Request.BinaryRead(byteCount) 
Dim UploadRequest
Set UploadRequest = CreateObject("Scripting.Dictionary")

BuildUploadRequest RequestBin
contentType = UploadRequest.Item("file").Item("ContentType")
filepathname = UploadRequest.Item("file").Item("FileName")
filename = Right(filepathname,Len(filepathname)-InstrRev(filepathname,"\"))

value = UploadRequest.Item("file").Item("Value")
'detail = UploadRequest.Item("detail").Item("Value") 

Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")
'FilePath = Server.MapPath(".") & "\" & "help.xls" ' filename 
FilePath = Server.MapPath(".") & "\" & "วิธีกดแทงโพย.rtf" ' filename 

Set MyFile = ScriptObject.CreateTextFile(FilePath)

For i = 1 to LenB(value)
     MyFile.Write chr(AscB(MidB(value,i,1)))
Next

MyFile.Close
%>

<font color='red'><strong>
Upload ไปยัง path :<%=filePath%><br>
ชื่อ file : </b><%="วิธีกดแทงโพย.rtf"%><br>
เรียบร้อยแล้ว <strong></font>

<!--#include file="inc_upload.asp"-->
