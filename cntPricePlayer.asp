<%OPTION EXPLICIT%>
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %> 
<% Response.Expires = -1 %>
<!--#include file="mdlGeneral.asp"-->
<%
	if trim(Session("uid"))="" then 	response.redirect "signin.asp"

	Dim objRS , objDB , SQL
	set objDB=Server.CreateObject("ADODB.Connection")       
	objDB.Open Application("constr")
	Set objRS =Server.CreateObject("ADODB.Recordset")
	Dim dealer_id, game_id
	dealer_id=Session("uid")
	game_id=Session("gameid")
	SQL="exec spJCntTicketByPlayerOfDealer " & game_id	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
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
    
<script language="javascript">
    function click_player(player_id) {
        var ParmA = ""; //document.form1.proj_code.value;
        var ParmB = "";
        var ParmC = '';
        var MyArgs = new Array(ParmA, ParmB, ParmC);

        //	MyArgs=window.showModalDialog('cntTicketPlayerID.asp?player_id='+player_id, '', 'dialogTop:'+200+'px;dialogLeft:'+0+'px;dialogHeight:500px;dialogWidth:1000px;edge:Sunken;center:Yes;help:No;resizable:No;status:No;');

        //location('index.asp?page=cntTicketPlayerID.asp?player_id='+player_id);
        //location = 'cntTicketPlayerID.asp?player_id='+player_id;

        window.open("cntTicketPlayerID.asp?player_id=" + player_id, "_blank", "top=150,left=150,height=520,width=650,directories=0,resizable=1,scrollbars=1,fullscreen=0,location=0,menubar=0,status=0,toolbar=0");


        if (MyArgs == null) {
            //	window.alert(
            //	  "Nothing returned from child. No changes made to input boxes")
        }
        else {
            //document.form1.proj_code.value=MyArgs[0].toString();
        }

    }
    function presscal1(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text3.value = 0;
        }
        else {
            document.form1.Text3.value = o.value * 0.001;
            sumc = parseInt(document.form1.Text3.value) + parseInt(document.form1.Text6.value) + parseInt(document.form1.Text9.value) + parseInt(document.form1.Text12.value);
            document.form1.Text13.value = sumc;
        }

    }
    function presscal2(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text6.value = 0;
        }
        else {
            document.form1.Text6.value = o.value * 0.0005;
            sumc = parseInt(document.form1.Text3.value) + parseInt(document.form1.Text6.value) + parseInt(document.form1.Text9.value) + parseInt(document.form1.Text12.value);
            document.form1.Text13.value = sumc;
        }

    }
    function presscal3(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text9.value = 0;
        }
        else {
            document.form1.Text9.value = o.value * 0.0005;
            sumc = parseInt(document.form1.Text3.value) + parseInt(document.form1.Text6.value) + parseInt(document.form1.Text9.value) + parseInt(document.form1.Text12.value);
            document.form1.Text13.value = sumc;
        }

    }
    function presscal4(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text12.value = 0;
        }
        else {
            document.form1.Text12.value = o.value * 5;
            sumc = parseInt(document.form1.Text3.value) + parseInt(document.form1.Text6.value) + parseInt(document.form1.Text9.value) + parseInt(document.form1.Text12.value);
            document.form1.Text13.value = sumc;
        }

    }
    function presscal5(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text14.value = 200000;
            document.form1.Text16.value = 700;
        }
        else {
            if (parseInt(o.value) <= 200000) {
                document.form1.Text16.value = 700;
            } else if (parseInt(o.value) <= 300000) {
                document.form1.Text16.value = 1000;
            } else if (parseInt(o.value) <= 400000) {
                document.form1.Text16.value = 1200;
            } else if (parseInt(o.value) <= 500000) {
                document.form1.Text16.value = 1400;
            } else if (parseInt(o.value) <= 600000) {
                document.form1.Text16.value = 1600;
            } else if (parseInt(o.value) <= 700000) {
                document.form1.Text16.value = 1800;
            } else if (parseInt(o.value) <= 800000) {
                document.form1.Text16.value = 2100;
            } else if (parseInt(o.value) <= 900000) {
                document.form1.Text16.value = 2400;
            } else if (parseInt(o.value) <= 1000000) {
                document.form1.Text16.value = 2800;
            } else if (parseInt(o.value) <= 1200000) {
                document.form1.Text16.value = 3200;
            } else if (parseInt(o.value) <= 1400000) {
                document.form1.Text16.value = 3600;
            } else if (parseInt(o.value) <= 1600000) {
                document.form1.Text16.value = 4000;
            } else if (parseInt(o.value) <= 1800000) {
                document.form1.Text16.value = 4400;
            } else if (parseInt(o.value) <= 2000000) {
                document.form1.Text16.value = 4800;
            } else if (parseInt(o.value) <= 2300000) {
                document.form1.Text16.value = 5400;
            } else if (parseInt(o.value) <= 2600000) {
                document.form1.Text16.value = 6000;
            } else if (parseInt(o.value) <= 3000000) {
                document.form1.Text16.value = 6600;
            } else if (parseInt(o.value) <= 3500000) {
                document.form1.Text16.value = 8200;
            } else if (parseInt(o.value) <= 4000000) {
                document.form1.Text16.value = 9200;
            } else if (parseInt(o.value) <= 4500000) {
                document.form1.Text16.value = 10000;
            } else if (parseInt(o.value) <= 5000000) {
                document.form1.Text16.value = 11000;
            } else if (parseInt(o.value) <= 5500000) {
                document.form1.Text16.value = 12000;
            } else if (parseInt(o.value) <= 6000000) {
                document.form1.Text16.value = 13000;
            } else if (parseInt(o.value) <= 6500000) {
                document.form1.Text16.value = 14000;
            } else if (parseInt(o.value) <= 7000000) {
                document.form1.Text16.value = 15000;
            } else if (parseInt(o.value) <= 7500000) {
                document.form1.Text16.value = 16000;
            } else if (parseInt(o.value) <= 8000000) {
                document.form1.Text16.value = 17000;
            } else if (parseInt(o.value) <= 8500000) {
                document.form1.Text16.value = 18000;
            } else if (parseInt(o.value) <= 9000000) {
                document.form1.Text16.value = 19000;
            } else if (parseInt(o.value) <= 10000000) {
                document.form1.Text16.value = 22000;
            } else if (parseInt(o.value) <= 50000000) {
                document.form1.Text16.value = 35000;
            } else if (parseInt(o.value) <= 100000000) {
                document.form1.Text16.value = 60000;
            }
            sumc = parseInt(document.form1.Text16.value) + parseInt(document.form1.Text19.value);
            document.form1.Text20.value = sumc;
        }

    }
    function presscal6(o) {
        var sumc = 0;
        if (o.value == "") {
            document.form1.Text19.value = 0;
        }
        else {
            if (parseInt(o.value) <= 10000) {
                document.form1.Text19.value = 0;
            } else if (parseInt(o.value) <= 50000) {
                document.form1.Text19.value = 200;
            } else if (parseInt(o.value) <= 100000) {
                document.form1.Text19.value = 400;
            } else if (parseInt(o.value) <= 150000) {
                document.form1.Text19.value = 600;
            } else if (parseInt(o.value) <= 200000) {
                document.form1.Text19.value = 800;
            } else if (parseInt(o.value) <= 250000) {
                document.form1.Text19.value = 1000;
            } else if (parseInt(o.value) <= 300000) {
                document.form1.Text19.value = 1200;
            } else if (parseInt(o.value) <= 350000) {
                document.form1.Text19.value = 1400;
            } else if (parseInt(o.value) <= 400000) {
                document.form1.Text19.value = 1600;
            } else if (parseInt(o.value) <= 450000) {
                document.form1.Text19.value = 1800;
            } else if (parseInt(o.value) <= 500000) {
                document.form1.Text19.value = 2000;
            } else if (parseInt(o.value) <= 550000) {
                document.form1.Text19.value = 2200;
            } else if (parseInt(o.value) <= 600000) {
                document.form1.Text19.value = 2400;
            } else if (parseInt(o.value) <= 650000) {
                document.form1.Text19.value = 2600;
            } else if (parseInt(o.value) <= 700000) {
                document.form1.Text19.value = 2800;
            } else if (parseInt(o.value) <= 750000) {
                document.form1.Text19.value = 3000;
            } else if (parseInt(o.value) <= 800000) {
                document.form1.Text19.value = 3200;
            } else if (parseInt(o.value) <= 850000) {
                document.form1.Text19.value = 3400;
            } else if (parseInt(o.value) <= 900000) {
                document.form1.Text19.value = 3600;
            } else if (parseInt(o.value) <= 950000) {
                document.form1.Text19.value = 3800;
            } else if (parseInt(o.value) <= 1000000) {
                document.form1.Text19.value = 4000;
            } else if (parseInt(o.value) <= 1500000) {
                document.form1.Text19.value = 6000;
            } else if (parseInt(o.value) <= 2000000) {
                document.form1.Text19.value = 8000;
            } else if (parseInt(o.value) <= 2500000) {
                document.form1.Text19.value = 10000;
            } else if (parseInt(o.value) <= 3000000) {
                document.form1.Text19.value = 12000;
            } else if (parseInt(o.value) <= 3500000) {
                document.form1.Text19.value = 14000;
            } else if (parseInt(o.value) <= 4000000) {
                document.form1.Text19.value = 16000;
            } else if (parseInt(o.value) <= 4500000) {
                document.form1.Text19.value = 18000;
            } else if (parseInt(o.value) <= 5000000) {
                document.form1.Text19.value = 20000;
            } else if (parseInt(o.value) <= 5500000) {
                document.form1.Text19.value = 22000;
            } else if (parseInt(o.value) <= 6000000) {
                document.form1.Text19.value = 24000;
            } else if (parseInt(o.value) <= 6500000) {
                document.form1.Text19.value = 26000;
            } else if (parseInt(o.value) <= 7000000) {
                document.form1.Text19.value = 28000;
            }
            sumc = parseInt(document.form1.Text16.value) + parseInt(document.form1.Text19.value);
            document.form1.Text20.value = sumc;
        }

    }

</script>
    <style type="text/css">
        .style1
        {
            color: red;
        }
    </style>
</HEAD>  

<BODY>
	<center>
    <form name="form1" action="key_player.asp" method="post">
	<TABLE  border="0"  cellpadding="5" cellspacing="1" style="width: 50%">
	<TR>		
		<Th class="text_black" colspan="4">
            เพื่อให้ทราบถึงยอดค่าใช้จ่ายในการใช้ระบบต่องวดมีการคิดค่าบริการแต่ละงวดเป็นอย่างไร 
            สามารถคำนวณได้จากโปรแกรมนี้โดยการใส่ข้อมูลของท่านเพื่อประมาณการใช้จ่ายเพื่อชำระเงินได้ดังนี้</Th>
	</TR>
	<TR>		
		<Th class="text_black" colspan="4">ยอดรับต่องวด <span class="style1">คือ 
            ยอดรับหวยสูงสุด(โดยประมาณ)</span><br />
            จำนวนผู้ใช้งาน <span class="style1">คือ คิดจากชื่อผู้ใช้งาน 
            เจ้ามือ+พนักงาน+ลูกค้าที่แทงเน็ตเข้ามาเอง หรือ 
            คิดจากจำนวนเครื่องที่ใช้งานที่อย่างใดอย่างหนึ่งมากกว่า (โดยประมาณ)</span></Th>
	</TR>
	<TR>		
		<Th class="text_black" colspan="4">&nbsp;</Th>
	</TR>
	<TR bgcolor="red">		
		<Th class="head_white" colspan="4">แบบที่1 คำนวณราคา ตามปริมาณที่ใช้งาน</Th>
	</TR>

	<TR style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD align=center>&nbsp;</TD>
		<TD align=center>ความต้องการ</TD>
		<TD align=center>อัตรา</TD>
		<TD align=center>ค่าใช้</TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>ยอดรับส่งต่องวด<span class="style1">*</span></TD>
		<TD><INPUT TYPE="text" id="Text1" NAME="txt3up" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 onKeyUp="presscal1(this)" /></TD>
		<TD><INPUT TYPE="text" id="Text2" NAME="txt3up" style="width:120;" 
                readonly="readonly" value="0.10 % ของยอด" /></TD>
		<TD><INPUT TYPE="text" id="Text3" NAME="txt3up" 
                style="width:100; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>ยอดรับบน(ไม่ใช้ไม่ต้องใส่)</TD>
		<TD><INPUT TYPE="text" id="Text4" NAME="txt3up" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 onKeyUp="presscal2(this)" /></TD>
		<TD><INPUT TYPE="text" id="Text5" NAME="txt3up" style="width:120;" 
                readonly="readonly" value="0.05 % ของยอด" /></TD>
		<TD><INPUT TYPE="text" id="Text6" NAME="txt3up" 
                style="width:100; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>ยอดรับล่าง(ไม่ใช้ไม่ต้องใส่)</TD>
		<TD><INPUT TYPE="text" id="Text7" NAME="txt3up" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 onKeyUp="presscal3(this)" /></TD>
		<TD><INPUT TYPE="text" id="Text8" NAME="txt3up" style="width:120;" 
                readonly="readonly" value="0.05 % ของยอด" /></TD>
		<TD><INPUT TYPE="text" id="Text9" NAME="txt3up" 
                style="width:100; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>จำนวนผู้ใช้งาน<span class="style1">*</span></TD>
		<TD><INPUT TYPE="text" id="Text10" NAME="txt3up" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 onKeyUp="presscal4(this)" /></TD>
		<TD><INPUT TYPE="text" id="Text11" NAME="txt3up" style="width:120;" 
                readonly="readonly" value="5.00 ต่อคน" /></TD>
		<TD><INPUT TYPE="text" id="Text12" NAME="txt3up" 
                style="width:100; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>&nbsp;</TD>
		<TD>&nbsp;</TD>
		<TD>ยอดรวม</TD>
		<TD><INPUT TYPE="text" id="Text13" NAME="txt3up" 
                style="width:100; font-weight: bold; font-size: medium; color: #FF0000; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR bgcolor="red">		
		<Th class="head_white" colspan="4">แบบที่2 คำนวณราคา แบบรายเดือน</Th>
	</TR>
	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>ยอดรับโพยไม่เกิน<span class="style1">*</span></TD>
		<TD><INPUT TYPE="text" id="Text14" NAME="txt3up0" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 
                onKeyUp="presscal5(this)" value="200000" /></TD>
		<TD><INPUT TYPE="text" id="Text15" NAME="txt3up1" style="width:120;" 
                readonly="readonly" value="เริ่มต้น 700" /></TD>
		<TD><INPUT TYPE="text" id="Text16" NAME="txt3up2" 
                style="width:100; text-align: right;" maxlength=7 
                value="700" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD>ยอดใช้เครดิตเกิน</TD>
		<TD><INPUT TYPE="text" id="Text17" NAME="txt3up3" pattern= "[0-9]" 
                style="width:100; text-align: right;" maxlength=7 
                onKeyUp="presscal6(this)" /></TD>
		<TD><INPUT TYPE="text" id="Text18" NAME="txt3up4" style="width:120;" 
                readonly="readonly" value="0" /></TD>
		<TD><INPUT TYPE="text" id="Text19" NAME="txt3up5" 
                style="width:100; text-align: right;" maxlength=7 
                value="0" readonly="readonly" /></TD>
	</TR>

	<TR class="text_blue" style="cursor:hand;"
	bgcolor=#ffcc99>
		<TD class="style1">ขั้นต่ำ 200,000ขึ้นไป</TD>
		<TD>&nbsp;</TD>
		<TD>ยอดรวม</TD>
		<TD><INPUT TYPE="text" id="Text20" NAME="txt3up6" 
                
                style="width:100; font-weight: bold; font-size: medium; color: #FF0000; text-align: right;" maxlength=7 
                value="700" readonly="readonly" /></TD>
	</TR>

		<tr style="height:29;">
<!--			<td colspan="4" align="center">
			<input type="button" class="inputE" value="คำนวณ" style="cursor:hand; width: 100px;"
			onClick="self.print();"	>
			</td>-->
		</tr>
	</TABLE>
    </form>
	</center>
</BODY>
</HTML>
