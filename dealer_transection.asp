<%@ Language=VBScript CodePage = 65001  %>
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
<TITLE>รายการธุระกรรม</TITLE>
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
            <h3 class="kt-portlet__head-title">รายการธุระกรรมดีลเลอร์</h3>
        </div>
    </div>
<div class="kt-portlet__body">
    <table class="table table-striped- table-bordered table-hover table-checkable" id="kt_table_1">
        <thead>
            <tr>
                <th>วันที่ทำธุระกรรม</th>
                <th>User Id</th>
                <th>User</th>
                <th>ประเภท</th>
                <th>เครดิตก่อนเข้าบัญชี</th>
                <th>เครดิตที่ทำการโอน</th>
                <th>เครดิตรวมหลังโอน</th>
                <th>หมายเหตุ</th>
            </tr>
        </thead>
        <tbody>
        <%  
            sql = "select u.user_name,u.user_id, py.tran_type, py.before_money, py.transfer_money,py.current_money,py.note, CONVERT(VARCHAR(30), py.created_date, 120) as created_date " _
                & "from [dbo].[pay_transection] py join  sc_user u on u.user_id = py.user_id "  _ 
                & "where py.user_id = '" & Session("uid") & "'" _
                & "order by create_date desc"
            set objRS=objDB.Execute(SQL)
            while not objRS.eof 
        %>
            <tr>
                <td><%= objRS("created_date") %></td>
                <td><%= objRS("user_id") %></td>
                <td><%= objRS("user_name") %></td>
                <td><%= objRS("tran_type") %></td>
                <td><%= objRS("before_money") %></td>
                <td><%= objRS("transfer_money") %></td>
                <td><%= objRS("current_money") %></td>
                <td><%= objRS("note") %></td>
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
<!--begin::Page Vendors(used by this page) -->
<script src="assets/plugins/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
<script>

    $(document).ready( function () {
        $('#kt_table_1').DataTable();
    });

</script>
</HTML>    

