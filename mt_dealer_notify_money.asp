<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>

<%
    Dim objRS , conn , SQL,cmd
    set conn=Server.CreateObject("ADODB.Connection")      
		conn.Open Application("constr")
		conn.CursorLocation = 3 
    Set cmd = Server.CreateObject("ADODB.Command")
    Set cmd.ActiveConnection = conn

    On Error Resume Next

    dim param_userid, param_status,param_money, param_note ,param_tranid,param_note_transection,param_transection_type
    param_tranid = Request.Form("tran_id")
    param_userid = Request.Form("user_id")
    param_status = Request.Form("status")
    param_money = Request.Form("money_transfer")
    param_note = Request.Form("note")
    param_note_transection = "ดีลเลอร์โอนเงินเข้าบัญชี"
    param_transection_type = "IN"
    if param_tranid <> "" and param_status <> "" then
        cmd.CommandText = "py_RequestPayment " & param_userid & "," & param_tranid & "," _ 
                & param_status & "," & param_money & ",'" & param_note & "','" _ 
                & param_note_transection & "','"  & param_transection_type & "'"
        cmd.CommandType = adCmdStoredProc

        call cmd.Execute
        conn.close
        Response.end
        <!-- Response.end -->
    end if

    
 
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
            <h3 class="kt-portlet__head-title">ดีลเลอร์แจ้งโอนเงิน</h3>
        </div>
    </div>
<div class="kt-portlet__body">
    <table class="table table-striped- table-bordered table-hover table-checkable" id="kt_table_1">
        <thead>
            <tr>
                <th>วันที่แจ้ง</th>
                <th>หมายเลขสมาชิก</th>
                <th>ชื่อ</th>
                <th>ธนาคารที่โอน</th>
                <th>จำนวนเงินที่โอน</th>
                <th>วันเวลาที่โอนเงิน</th>
                <th>สถานะโอนเงิน</th>
                <th>หมายเหตุ</th>
                <th></th>
            </tr>
        </thead>
       <tbody>
        <%  
            SQL = "select r.id, CONVERT(VARCHAR(30), r.created_date, 120) as created_date, r.user_id,u.user_name,r.bank_name,r.money_transfer,r.transfer_date,r.transfer_status,r.note from pay_requestion r join sc_user u on r.user_id = u.user_id order by created_date"

            set objRS=conn.Execute(SQL)
            while not objRS.eof 
        %>
            <tr>
                <td><%= objRS("created_date") %></td>
                <td><%= objRS("user_id") %></td>
                <td><%= objRS("user_name") %></td>
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
                <td>
                    <% if objRS("transfer_status")  = 0 then %>
                    <button type="button" class="btn btn-sm btn-clean btn-icon btn-icon-md edit-btn" tran_id="<%=objRS("id")%>"
                        title="View" user_id="<%=objRS("user_id") %>" money_transfer="<%=objRS("money_transfer") %>" note='<%= objRS("note") %>' >
                        <i class="la la-edit"></i>
                    </button>
                    <% end if %>
                </td>
            </tr>
        <%  
            objRS.MoveNext
			wend 
        %>

        </tbody>
    </table>
</div>

</div>
<div class="modal fade" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">ยืนยันการชำระเงิน</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>จำนวนเงินที่โอนเข้าเครดิต</label>
                    <input type="number" class="form-control" id="money" name="money">
                    <input type="hidden" id="user_id" name="user_id">
                    <input type="hidden" id="tran_id" name="tran_id">
                </div>
                <div class="form-group">
                    <label>หมายเหตุ</label>
                    <textarea type="text" class="form-control" id="note" name="note" > </textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-brand" data-dismiss="modal">ยกเลิก</button>
                <button type="button" class="btn btn-danger" id="btn-reject" name="btn-approve" status="2" >ไม่อนุมัติ</button>
                <button type="button" class="btn btn-primary" id="btn-approve" name="btn-reject" status="1" >อนุมัติการชำระเงิน</button>
            </div>
        </div>
    </div>
</div>

</body>
  <script>
        var KTAppOptions = {
            "colors": {
                "state": {
                    "brand": "#5d78ff",
                    "metal": "#c4c5d6",
                    "light": "#ffffff",
                    "accent": "#00c5dc",
                    "primary": "#5867dd",
                    "success": "#34bfa3",
                    "info": "#36a3f7",
                    "warning": "#ffb822",
                    "danger": "#fd3995",
                    "focus": "#9816f4"
                },
                "base": {
                    "label": [
                        "#c5cbe3",
                        "#a1a8c3",
                        "#3d4465",
                        "#3e4466"
                    ],
                    "shape": [
                        "#f0f3ff",
                        "#d9dffa",
                        "#afb4d4",
                        "#646c9a"
                    ]
                }
            }
        };
  </script>

<script src="assets/plugins/global/plugins.bundle.js" type="text/javascript"></script>
<script src="assets/js/scripts.bundle.js" type="text/javascript"></script>
<!--begin::Page Vendors(used by this page) -->
<script src="assets/plugins/custom/datatables/datatables.bundle.js" type="text/javascript"></script>
<script>

    $(document).ready( function () {
        $('#kt_table_1').DataTable();

        $(".edit-btn").click(function(){
            var tran_id = $(this).attr("tran_id");
            var user_id = $(this).attr("user_id");
            var money_transfer = $(this).attr("money_transfer");
            var note = $(this).attr("note");
            $("#tran_id").val(tran_id);
            $("#user_id").val(user_id);
            $("#money").val(money_transfer);
            $("#note").val(note);
            $("#exampleModalLong").modal('show');
        });

        $("#btn-confirm").click(function(){
            location.reload();
        });

        $("#btn-approve").click(function(){
            var tran_id = $("#tran_id").val();
            var user_id = $("#user_id").val();
            var money_transfer = $("#money").val();
            var note = $("#note").val();
            var status = 1;
            $.ajax({
                url: "mt_dealer_notify_money.asp",
                type: 'POST',
                data: { "user_id" : '"' + user_id + '"',"tran_id" : '"' + tran_id + '"', "user_id": '"' + user_id + '"',"money_transfer": '"' + money_transfer + '"',"note": '"' + note + '"',"status": '"' + status + '"' }
            }).done(function(data) {
                console.log(data)
                window.location = "mt_dealer_notify_money.asp"
            });
        });

        $("#btn-reject").click(function(){
            var tran_id = $("#tran_id").val();
            var user_id = $("#user_id").val();
            var money_transfer = $("#money").val();
            var note = $("#note").val();
            var status = 2;
            $.ajax({
                url: "mt_dealer_notify_money.asp",
                type: 'POST',
                data: { "user_id" : '"' + user_id + '"',"tran_id" : '"' + tran_id + '"', "user_id": '"' + user_id + '"',"money_transfer": '"' + money_transfer + '"',"note": '"' + note + '"',"status": '"' + status + '"' }
            }).done(function(data) {
                console.log("test")
                window.location = "mt_dealer_notify_money.asp"
            });

        });
    });

</script>
</HTML>    

