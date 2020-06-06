<%@ Language=VBScript CodePage = 65001  %>
<%OPTION EXPLICIT%>
<% Response.CodePage = 65001%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!--#include file="include/adovbs.inc"-->
<!--#include file="mdlGeneral.asp"-->
<%

dim srcPage
if Trim(Request("page"))="" then
	Session("uid")=0
	Session("uname")=""
	Session("utype")=""
	Session("cutallid")=0
end if
    if Trim(Session("uid"))="" then
       response.redirect "signin.asp"
    end if
%>
<html>

<head>
	<meta name="description" content="Latest updates and statistic charts">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700">
	<link href="assets/plugins/custom/fullcalendar/fullcalendar.bundle.css" rel="stylesheet" type="text/css" />

	<link href="assets/plugins/global/plugins.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/style.bundle.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/base/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/header/menu/light.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/brand/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/skins/aside/navy.css" rel="stylesheet" type="text/css" />
	<link href="assets/css/global.css" rel="stylesheet" type="text/css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

	<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />


	<script type="text/javascript" src="include/switch.js"></script>
	<script language=javascript>
		function ClickRefresh(url, rf_rate) {
			if (document.all.cmdrefresh.value == "Refresh ?????????") {
				document.all.cmdrefresh.value = "???? Refresh ?????????";
				rf_rate = "0";
			} else {
				document.all.cmdrefresh.value = "Refresh ?????????";
				rf_rate = "1";
			}
			url = url + '?stoprefresh=' + rf_rate;
			parent.document.all.bodyFrame.src = url;
		}

		function showsendto(gosuu) {
			window.open("dealer_check_suu.asp?gosuu=" + gosuu, "_blank",
				"top=200,left=200,height=150,width=300,directories=0,resizable=0,scrollbars=0,fullscreen=0,location=0,menubar=0,status=0,toolbar=0"
			);
		}

		function Close() {
			return 'Are you sure you want to close my lovely window?'
		}
	</script>


	<LINK href="include/code.css" type=text/css rel=stylesheet>
	<LINK href="include/stylesmenu.css" type=text/css rel="stylesheet">
	<script language="JavaScript" src="include/normalfunc.js"></script>
	<script language="JavaScript" src="include/js_function.js"></script>
	<TITLE>Welcome DSS Tool </TITLE>

</head>

<body class="kt-quick-panel--right kt-demo-panel--right kt-offcanvas-panel--right kt-header--fixed 
	kt-header-mobile--fixed kt-subheader--enabled kt-subheader--transparent kt-aside--enabled 
	kt-aside--fixed kt-page--loading">

	<!-- begin:: Header Mobile -->
	<div id="kt_header_mobile" class="kt-header-mobile  kt-header-mobile--fixed ">
		<div class="kt-header-mobile__logo">
			<a href="index.html">
				<img alt="Logo" src="assets/media/logos/logo-dtool.png" style="width:120px" />
			</a>

		</div>
		<div class="kt-header-mobile__toolbar">
			<button class="kt-header-mobile__toolbar-toggler kt-header-mobile__toolbar-toggler--left"
				id="kt_aside_mobile_toggler"><span></span></button>

			<button class="kt-header-mobile__toolbar-topbar-toggler" id="kt_header_mobile_topbar_toggler"><i
					class="flaticon-more"></i></button>
		</div>
	</div>
	<!-- end:: Header Mobile -->

	<!-- begin:: Root -->
	<div class="kt-grid kt-grid--hor kt-grid--root">
		<!-- begin:: Page -->
		<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">
			<!-- begin:: Aside -->
			<button class="kt-aside-close " id="kt_aside_close_btn"><i class="la la-close"></i></button>
			<div class="kt-aside  kt-aside--fixed  kt-grid__item kt-grid kt-grid--desktop kt-grid--hor-desktop"
				id="kt_aside">

				<!-- begin::Aside Brand -->
				<div class="kt-aside__brand kt-grid__item " id="kt_aside_brand">
					<div class="kt-aside__brand-logo">
						<img alt="Logo" src="assets/media/logos/logo-dtool.png" style="width:120px" />
					</div>
					<div class="kt-aside__brand-tools">
						<button class="kt-aside__brand-aside-toggler kt-aside__brand-aside-toggler--left"
							id="kt_aside_toggler"><span></span></button>
					</div>
				</div>

				<!-- end:: Aside Brand -->

				<!-- begin:: Aside Menu -->
				<div class="kt-aside-menu-wrapper kt-grid__item kt-grid__item--fluid" id="kt_aside_menu_wrapper">

					<div id="kt_aside_menu" class="kt-aside-menu " data-ktmenu-vertical="1" data-ktmenu-scroll="1"
						data-ktmenu-dropdown-timeout="500">
						<%Call ShowMenu2(Session("utype"))%>
					</div>
				</div>

			</div>
			<!-- end:: Aside -->
			<!-- begin:: Wrapper -->
			<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">

				<!-- begin:: Header -->
				<div id="kt_header" class="kt-header kt-grid__item  kt-header--fixed ">
					<div style="width: 100%;padding: 25px;">
						<IFRAME marginWidth=0 src="mess_alert_dealer.asp" width="100%" height="40px" name="mess"
							style="width: 100%; float: right;border: none;">
						</IFRAME>
					</div>

				</div>


				<!-- end:: Header -->

				<div class="kt-content  kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
					<div class="kt-container  kt-container--fluid  kt-grid__item kt-grid__item--fluid"
						style="margin:20px 0">


						<%
							if Trim(Request("page"))="" then
								srcPage="signin.asp"
							else
								srcPage=Request("page")
							end if
						%>
						<IFRAME marginWidth=0 marginHeight=0 src="<%=srcPage%>" frameBorder=no width="100%"
							height="100%" name="bodyFrame" align="left">
						</IFRAME>



					</div>
				</div>


			</div>

			<!-- end:: Wrapper -->

		</div>

	</div>


	<!-- begin:: Scrolltop -->
	<div id="kt_scrolltop" class="kt-scrolltop">
		<i class="la la-arrow-up"></i>
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
	<!--end::Global Theme Bundle -->

</body>

</html>