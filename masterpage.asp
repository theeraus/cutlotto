<%@ Language=VBScript CodePage = 65001  %>
<% Response.CodePage = 65001%>
<%OPTION EXPLICIT%>
<!--#include file="include/adovbs.inc"-->
<!--#include file="include/config.inc"-->
<!--#include file="mdlGeneral.asp"-->

<%
        if Trim(Session("uid"))="" or Trim(Session("uid"))=0 then
            response.redirect "signin.asp"
        end if

%>
	
<% 
  Response.CharSet = "UTF-8"
  Response.CodePage = 65001
%>

<html lang="en">

	<!-- begin::Head -->
	<head>
		<base href="">
		<meta charset="utf-8" />
	    <TITLE>Welcome Cut Lotto</TITLE>
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
	
		<link rel="shortcut icon" href="assets/media/logos/favicon.ico" />

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

        <script language="JavaScript" src="include/normalfunc.js"></script>
        <script language="JavaScript" src="include/js_function.js"></script>
		 <script language="JavaScript" src="include/dialog.js"></script>
	</head>

	

	<!-- begin::Body -->
	<body class="kt-quick-panel--right kt-demo-panel--right kt-offcanvas-panel--right kt-header--fixed kt-header-mobile--fixed kt-subheader--enabled kt-subheader--transparent kt-aside--enabled kt-aside--fixed kt-page--loading">

		<!-- begin:: Header Mobile -->
		<div id="kt_header_mobile" class="kt-header-mobile  kt-header-mobile--fixed ">
			<div class="kt-header-mobile__logo">

					<img alt="Logo" src="assets/media/logos/logo-6.png" />
			
			
			</div>
			<div class="kt-header-mobile__toolbar">
				<button class="kt-header-mobile__toolbar-toggler kt-header-mobile__toolbar-toggler--left" id="kt_aside_mobile_toggler"><span></span></button>
				<button class="kt-header-mobile__toolbar-toggler" id="kt_header_mobile_toggler"><span></span></button>
				<button class="kt-header-mobile__toolbar-topbar-toggler" id="kt_header_mobile_topbar_toggler"><i class="flaticon-more"></i></button>
			</div>
		</div>

		<!-- end:: Header Mobile -->

		<!-- begin:: Root -->
		<div class="kt-grid kt-grid--hor kt-grid--root">

			<!-- begin:: Page -->
			<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--ver kt-page">

				<!-- begin:: Aside -->
				<button class="kt-aside-close " id="kt_aside_close_btn"><i class="la la-close"></i></button>
				<div class="kt-aside  kt-aside--fixed  kt-grid__item kt-grid kt-grid--desktop kt-grid--hor-desktop" id="kt_aside">

					<!-- begin::Aside Brand -->
					<div class="kt-aside__brand kt-grid__item " id="kt_aside_brand">
						<div class="kt-aside__brand-logo" onclick='xxxx("111")'>
						    <img alt="Logo" src="assets/media/logos/logo-6.png" />
						</div>
						<div class="kt-aside__brand-tools">
							<button class="kt-aside__brand-aside-toggler kt-aside__brand-aside-toggler--left" id="kt_aside_toggler"><span></span></button>
						</div>
					</div>

					<!-- end:: Aside Brand -->

					<!-- begin:: Aside Menu -->
					<div class="kt-aside-menu-wrapper kt-grid__item kt-grid__item--fluid" id="kt_aside_menu_wrapper">
            	      
						<div id="kt_aside_menu" class="kt-aside-menu " data-ktmenu-vertical="1" data-ktmenu-scroll="1" data-ktmenu-dropdown-timeout="500">
						     <%Call ShowMenu2(Session("utype"))%>
						</div>
					</div>

				</div>

				<!-- end:: Aside -->

				<!-- begin:: Wrapper -->
				<div class="kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor kt-wrapper" id="kt_wrapper">

					<!-- begin:: Header -->
					<div id="kt_header" class="kt-header kt-grid__item  kt-header--fixed ">

						<!-- begin:: Header Menu -->
						<button class="kt-header-menu-wrapper-close" id="kt_header_menu_mobile_close_btn"><i class="la la-close"></i></button>
						<div class="kt-header-menu-wrapper" id="kt_header_menu_wrapper">
                            <div id="kt_header_menu" class="kt-header-menu kt-header-menu-mobile  kt-header-menu--layout- ">
								<ul class="kt-menu__nav ">
									<li class="kt-menu__item kt-menu__item--submenu kt-menu__item--rel kt-menu__item--active "><a href="javascript:;" class="kt-menu__link kt-menu__toggle">
                                            <span class="kt-menu__link-text">เครดิตคงเหลือ <%=Session("limit_play") %> </span>
                                        </a>
									</li>
								</ul>
							</div>
                        </div>

						<!-- end:: Header Menu -->

						<!-- begin:: Header Topbar -->
						<div class="kt-header__topbar">
                    		<%Call ShowHeader(Session("utype"))%>
						</div>
                        

						<!-- end:: Header Topbar -->
					</div>
                    <div style="padding:10px;background-color: rgba(93,120,255,.1);">

                       <IFRAME marginWidth=0 src="mess_alert_dealer.asp" 
                        width="100%" height="40px" name="mess" style="width: 100%; float: right;border: none;">
                      </IFRAME>
 
                    </div>

					<!-- end:: Header -->
					<div class="kt-content  kt-grid__item kt-grid__item--fluid kt-grid kt-grid--hor">
						<div class="kt-container  kt-container--fluid  kt-grid__item kt-grid__item--fluid" style="margin:20px 0">

							<div class="row">
								<div class="col-xl-12 col-lg-12">
                                 <% Call ContentPlaceHolder() %>
								</div>
							</div>

						</div>
					</div>
					
				</div>

				<!-- end:: Wrapper -->
			</div>

			<!-- end:: Page -->
		</div>

		<!-- end:: Root -->


		<!-- begin:: Scrolltop -->
		<div id="kt_scrolltop" class="kt-scrolltop">
			<i class="la la-arrow-up"></i>
		</div>



		<!-- begin::Global Config(global config for global JS sciprts) -->
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

		<!-- end::Global Config -->

		<!--begin::Global Theme Bundle(used by all pages) -->
		<script src="assets/plugins/global/plugins.bundle.js" type="text/javascript"></script>
		<script src="assets/js/scripts.bundle.js" type="text/javascript"></script>

		<script src="assets/js/thai_date_picker/bootstrap-datepicker.js"></script>
    	<script src="assets/js/thai_date_picker/bootstrap-datepicker-thai.js"></script>
    	<script src="assets/js/thai_date_picker/locales/bootstrap-datepicker.th.js"></script>		
		<script src="assets/js/pages/components/forms/widgets/bootstrap-datepicker.js" type="text/javascript"></script>
		<!--end::Global Theme Bundle -->

	</body>


	<!-- end::Body -->
</html>





