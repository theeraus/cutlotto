<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>
<%
    Dim objRS , objDB , SQL	, tmp_Color
    set objDB=Server.CreateObject("ADODB.Connection")       
		objDB.Open Application("constr")
		objDB.CursorLocation = 3 
	Set objRS =Server.CreateObject("ADODB.Recordset")	
%>
<HTML>
<HEAD>
<TITLE>ค่าใช้จ่ายการใช้ระบบ</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache-control" content="no-cache"> 
<meta http-equiv="pragma" content="no-cache"> 
<meta http-equiv="expires" content="-1">
<link href="include/code.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="include/dialog.js"></script>
<script src="include/js_function.js" language="javascript"></script>
    <link href="assets/plugins/custom/datatables/datatables.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.js"></script>
</HEAD>
<body>

<div class="kt-portlet">
    <div class="kt-portlet__head">
        <div class="kt-portlet__head-label">
            <h3 class="kt-portlet__head-title">อัตราค่าบริการ</h3>
        </div>
    </div>
<div class="kt-portlet__body">
    <table class="table">
        <thead class="thead-dark">
            <tr>
                <th>#</th>
                <th>ยอดแทง / รอบหวย</th>
                <th>ค่าบริการ (บาท)</th>
            </tr>
        </thead>
        <tbody>
        <%  
            sql = "select* from pay_pricing order by id"
            set objRS=objDB.Execute(SQL)
            while not objRS.eof 
        %>
            <tr>
                <th scope="row"><%= objRS("id") %></th>
                <td><%= objRS("pricing_name") %></td>
                <td><%= objRS("price") %></td>
            </tr>
        <%  
            objRS.MoveNext
			wend 
        %>

        </tbody>
    </table>
</div>

</div>
</body>

</HTML>    

