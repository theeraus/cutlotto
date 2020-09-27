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
            <h3 class="kt-portlet__head-title">ประวัติการโอนเงิน</h3>
        </div>
    </div>
<div class="kt-portlet__body">
    <table class="table table-striped- table-bordered table-hover table-checkable" id="kt_table_1">
        <thead>
            <tr>
                <th>วันที่แจ้ง</th>
                <th>ธนาคารที่โอน</th>
                <th>จำนวนเงินที่โอน</th>
                <th>วันเวลาที่โอนเงิน</th>
                <th>สถานะ</th>
                <th>หมายเหตุ</th>
            </tr>
        </thead>
        <tbody>
        <%  
            sql = "select CONVERT(VARCHAR(30), created_date, 120) as createdate2,* from pay_requestion where user_id = '" & Session("uid") & "' order by created_date"
            set objRS=objDB.Execute(SQL)
            while not objRS.eof 
        %>
            <tr>
                <td><%= objRS("createdate2") %></td>
                <td><%= objRS("bank_name") %></td>
                <td><%= objRS("money_transfer") %></td>
                <td><%= objRS("transfer_date") %></td>
                <td>
                    <%
                        dim status , statustext
                        status = objRS("transfer_status") 
                        if status = 0  then
                            statustext = "<span class='kt-badge kt-badge--metal kt-badge--inline'>รออนุมัติ</span>"
                        elseif status = 1 then
                            statustext = "<span class='kt-badge kt-badge--success  kt-badge--inline'>อนุมัติแล้ว</span>"
                        else
                            statustext = "<span class='kt-badge kt-badge--danger kt-badge--inline'>ไม่อนุมัติ</span>"
                        end if
                    %>
                    <%=statustext%>
                 </td>
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

