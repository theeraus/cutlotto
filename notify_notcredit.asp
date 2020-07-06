<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<% Response.CodePage = 65001%>

<HTML>
<HEAD>
<TITLE>จำนวนเครดิตของคุณไม่พอ</TITLE>
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
<div class="alert alert-danger" role="alert">
    <div class="alert-text">
        <h4 class="alert-heading">เครดิตของคุณไม่เพียงพบ!</h4>
        <p>จำนวนเครดิตของคุณไม่พอที่จะออกรางวัล กรุณาเติมเงินเข้าระบบให้เพียงพอสำหรับออกรางวัล</p>
         <p class="mb-0">หากคุณไม่สามารถเติมเงินในระบบได้กรุณาติดต่อ admin</p>
        <hr>
        <a href="confirm_money.asp" class="btn btn-info btn-elevate">แจ้งโอนเงินเข้าระบบ</a>
        <a href="pricing.asp" class="btn btn-info btn-elevate">วิธีการคิดค่าบริการ</a>
        
       
    </div>
</div>


</div>
</body>

</HTML>    

