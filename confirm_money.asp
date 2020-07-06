<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>

<%
    dim bank_id,money,dateTransfer,note,mode
    dim objDB, strSql
    set objDB=Server.CreateObject("ADODB.Connection")     

    set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	objDB.CursorLocation = 3 

    bank_id=Request("bank_id")
    money=Request("money")
    dateTransfer=Request("dateTransfer")
    note=Request("note")
    mode=Request("mode")

    if mode="add" then
        strSql = "Insert Into pay_requestion (user_id, bank_name, money_transfer, transfer_date, transfer_status, created_date, updated_date, note) values "	_
					& "("& Session("uid") &",'"& bank_id &"',"& money &", '"& dateTransfer &"', 0, GetDate(), GetDate(), '"& note &"')"

        objDB.Execute(strSql)
        objDB.Close
        Response.Redirect "history_money.asp"

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
	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</HEAD>
<body>

<div class="kt-portlet">
    <div class="kt-portlet__head">
        <div class="kt-portlet__head-label">
            <h3 class="kt-portlet__head-title">ยืนยันการโอนเงิน</h3>
        </div>
    </div>

    <!--begin::Form-->
    <form id="kt_form_1" name="kt_form_1" class="kt-form" action="confirm_money.asp" method="post">

        <div class="kt-portlet__body">
            <div class="form-group form-group-last">
                <div class="alert alert-secondary" role="alert">
                    <div class="alert-icon"><i class="flaticon-warning kt-font-brand"></i></div>
                    <div class="alert-text">
                        กรุณากรอกข้อมูลการโอนเงินตามความเป็นจริง และหลังจากนั้น admin จะอนุมัติเงินเข้าระบบภายใน 24 ชั่วโมง
                    </div>
                </div>
            </div>
            <input type="hidden" value="add" id="mode" name="mode" >
            <div class="form-group">
                <label for="exampleSelectl">ธนาคารของคุณที่โอนเงินเข้ามา</label>

                <select class="form-control form-control" title="กรุณาเลือกธนาคาร" id="bank_id" name="bank_id" required>
                    <option value="">-- เลือกธนาคาร --</option>
                    <option value="ธนาคารกรุงเทพ">ธนาคารกรุงเทพ</option>
                    <option value="ธนาคารกสิกรไทย">ธนาคารกสิกรไทย</option>
                    <option value="ธนาคารไทยพาณิชย์">ธนาคารไทยพาณิชย์</option>
                    <option value="ธนาคารกรุงศรีอยุธยา">ธนาคารกรุงศรีอยุธยา</option>
                    <option value="ธนาคารกรุงไทย">ธนาคารกรุงไทย</option>
                    <option value="ธนาคารทหารไทย">ธนาคารทหารไทย</option>
                    <option value="ธนาคารธนชาต">ธนาคารธนชาต</option>
                    <option value="ธนาคารยูโอบี">ธนาคารยูโอบี</option>
                    <option value="ธนาคารออมสิน">ธนาคารออมสิน</option>
                    <option value="ธนาคารสแตนดาร์ดชาร์เตอร์ด">ธนาคารสแตนดาร์ดชาร์เตอร์ด</option>
                    <option value="ธนาคารเกียรตินาคิน">ธนาคารเกียรตินาคิน</option>
                    <option value="ธนาคารซีไอเอ็มบีไทย">ธนาคารซีไอเอ็มบีไทย</option>
                    <option value="ธนาคารทหารไทย">ธนาคารทหารไทย</option>
                    <option value="ธนาคารทิสโก้">ธนาคารทิสโก้</option>
                    <option value="ธนาคารเพื่อการเกษตรและสหกรณ์การเกษตร">ธนาคารเพื่อการเกษตรและสหกรณ์การเกษตร</option>
                    <option value="ธนาคารอาคารสงเคราะห์">ธนาคารอาคารสงเคราะห์</option>
                    <option value="ธนาคารอิสลามแห่งประเทศไทย">ธนาคารอิสลามแห่งประเทศไทย</option>
                    <option value="ธนาคารไอซีบีซี (ไทย)">ธนาคารไอซีบีซี (ไทย)</option>
                </select>
            </div>
            <div class="form-group">
                <label>จำนวนเงินที่โอน</label>
                <input type="number" class="form-control" title="กรุณากรอกข้อมูล" id="money" name="money" required>
            </div>

            <div class="form-group">
                <label>วันเวลาที่โอนเงิน</label>
                <input type="text" class="form-control" title="กรุณากรอกข้อมูล" id="dateTransfer" name="dateTransfer" required>
                <span class="form-text text-muted">ตัวอย่างการกรอก 02/08/2563 12:30</span>
            </div>

            <div class="form-group">
                <label>หมายเหตุ</label>
                <textarea class="form-control" id="note" name="note" rows="4"></textarea>
            </div>
         

        </div>
        <div class="kt-portlet__foot">
            <div class="kt-form__actions">
                <button type="submit" class="btn btn-accent">แจ้งการโอนเงิน</button>
                <button type="reset" class="btn btn-secondary">ยกเลิก</button>
            </div>
        </div>
    </form>

    <!--end::Form-->
</div>
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

    <!--begin::Global Theme Bundle(used by all pages) -->
	<script src="assets/plugins/global/plugins.bundle.js" type="text/javascript"></script>
	<script src="assets/js/scripts.bundle.js" type="text/javascript"></script>

    <script>

        $("#kt_form_1").validate({
             //display error alert on form submit  
            invalidHandler: function(event, validator) {
                KTUtil.scrollTo("kt_form_1", -200);
            },
            submitHandler: function (form) {
               form.submit(); // submit the form
            }
        });

    </script>

</body>
</HTML>    

