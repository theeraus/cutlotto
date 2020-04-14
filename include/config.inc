<%
'*** This file defines all the constants used throughout the message board and there are quite a few of them.

'*** The conection object is used all the time so we'll dimension it here
Dim objConn

'*** The conection object is used all the time so we'll dimension it here
dim dbConn

'*** This constant is the name of your message board.
'*** E.g. If you want your message board to be called 'Software' change the line to read: Const MBTitle = "Software"
Const MBTitle = "Thread-IT v1.4"

'*** These are page body tags, the define the page colours and link colours.
Const MBPageBody1 = "<body bgcolor=""#FFFFFF"" link=""#FFFFFF"" vlink=""#FFFFFF"" alink=""#FF0000"">"
Const MBPageBody2 = "<body bgcolor=""#FFFFFF"" link=""#003098"" vlink=""#003098"" alink=""#FF0000"">"

'*** Colour of thread page
Const MBThreadColour = "#FFFFFF"

'*** Background colour of the topics table
Const MBTopicsTBLColour = "#000000"

'*** Field colour of the header row in the topics table.
Const MBTopicsTRFDColour = "#003399"

'*** Field colour for topics listing.
Const MBTopicsFDColour = "#E8E8E8"

'*** Field colour of header of reply messages.
Const MBReplyHeadColour = "#003399"

'*** Field colour for topics listing.
Const MBReplyBodyColour = "#E8E8E8"


'*** Define fonts
'*** Where you see "s in HTML tags put a " in front. Otherwise you get an 'Expected end of statement' error

Const FONT1 = "<font face=""MS Sans Serif, Arial"" size=""2"" color=""#000000"">"
Const FONT2 = "<font face=""MS Sans Serif, Arial"" size=""1"" color=""#000000"">"
Const FONT3 = "<font face=""MS Sans Serif, Arial"" size=""2"" color=""#FFFFFF"">"
Const FONT4 = "<font face=""MS Sans Serif, Arial"" size=""1"" color=""#FFFFFF"">"


'*** Define images for use in the board.

Const MBImgLogo = "<img src=""images/logo.gif"" width=""155"" height=""37"" alt=""Put your logo here"">"
Const MBImgGoBack = "<img src=""images/goback.gif"" width=""148"" height=""23"" border=""0"" alt=""Go Back"">"
Const MBImgAddNew = "<img src=""images/addnew.gif"" width=""148"" height=""23"" vspace=""5"" border=""0"" alt=""Add New Topic"">"
Const MBImgAddReply = "<img src=""images/reply.gif"" width=""209"" height=""26"" border=""0"" alt=""Add a Reply"">"
Const MBImgViewTopics = "<img src=""images/viewtopics.gif"" width=""148"" height=""23"" border=""0"" alt=""VIEW TOPICS"">"
Const MBImgViewReplies = "<img src=""images/viewreplies.gif"" width=""148"" height=""23"" border=""0"" alt=""VIEW REPLIES"">"
Const MBImgReply = "<img src=""images/reply.gif"" width=""60"" height=""14"" border=""0"" alt=""Reply to this message"">"
Const MBImgAllReplies = "<img src=""images/allreplies.gif"" width=""148"" height=""23"" border=""0"" alt=""VIEW ALL REPLIES"">"
Const MBImgHideReplies = "<img src=""images/hidereplies.gif"" width=""148"" height=""23"" border=""0"" alt=""HIDE ALL REPLIES"">"
	
Const MBImgTopic = "<img src=""images/topic.gif"" width=""75"" height=""15"" border=""0"" alt=""Topic"">"
Const MBImgAuthor = "<img src=""images/author.gif"" width=""75"" height=""15"" border=""0"" alt=""Author"">"
Const MBImgLastPost = "<img src=""images/lastpost.gif"" width=""75"" height=""15"" border=""0"" alt=""Last Post"">"
Const MBImgReplies = "<img src=""images/replies.gif"" width=""75"" height=""15"" border=""0"" alt=""Replies"">"

Const MBImgAddNewReply = "<img src=""images/addnewreply.gif"" width=""400"" height=""23"" border=""0"" alt=""Add New Reply"">"
Const MBImgAddNewTopic = "<img src=""images/addnewtopic.gif"" width=""400"" height=""23"" border=""0"" vspace=""5"" alt=""Add New Topic"">"

Const MBImgOldMessage = "<img src=""images/old.gif"" width=""15"" height=""16"" border=""0"">"
Const MBImgOldOpen = "<img src=""images/oldopen.gif"" width=""15"" height=""16"" border=""0"">"
Const MBImgNewMessage = "<img src=""images/new.gif"" width=""15"" height=""16"" border=0 alt=""There are new messages in this topic."">"
Const MBImgTopicIcon = "<img src=""images/topicicon.gif"" width=""16"" height=""16"" border=""0"">"

'*** This is the important one that allows me to give this code away for free. Please use it somewhere on the front page or I will have to stop giving it away for nothing.
Const PrintCredit = "<font face=""MS Sans Serif, Arial"" size=""1"" color=""#000000"">Message Board Developed by <a href=""http://www.ymonda.com"" target=""_top"">yMonda Limited</a></font>"

'**** Constant of Millionare ****
Const mlnUserTypeAdmin	= "A" '	A	ปรเภทผู้ใช้	user_type	Admin
Const mlnUserTypeDealer	= "D" '	D	ปรเภทผู้ใช้	user_type	เจ้ามือ
Const mlnUserTypeKey	= "K" '	K	ปรเภทผู้ใช้	user_type	คนคีย์
Const mlnUserTypePlayer	= "P" '	P	ปรเภทผู้ใช้	user_type	คนแทง

Const mlnRecAuto	= "1" '	1	ประเภทการรับโพย	rec_ticket	รับอัตโนมัติ
Const mlnRecApplove	= "2" '	2	ประเภทการรับโพย	rec_ticket	รอคิวก่อนรับ

Const mlnStatusKey	= "0" ' 0	สถานะการรับโพย	rec_status	กำลังคีย์
Const mlnStatusSend	= "1" '	1	สถานะการรับโพย	rec_status	ส่ง / รอคีย์
Const mlnStatusRecAll	= "2" '	2	สถานะการรับโพย	rec_status	รับหมด
Const mlnStatusRecPart	= "3" '	3	สถานะการรับโพย	rec_status	รับบางส่วน
Const mlnStatusRecNoRec	= "4" '	4	สถานะการรับโพย	rec_status	ไม่รับ

Const mlnKeyCom		= "1" '	1	แทงจาก	key_from	คอมพิวเตอร์
Const mlnKeyPDA		= "2" '	2	แทงจาก	key_from	PDA

Const mlnDown		= "1" '	1	เลขบน ล่าง	ีupdown_type	ล่าง
Const mlnUp		= "2" '	2	เลขบน ล่าง	ีupdown_type	บน
Const mlnUpDonw		= "3" '	3	เลขบน ล่าง	ีupdown_type	บน+ล่าง

Const mlnNumStatusKey	= "0" ' 0	สถานะการรับเลข	number_status	กำลังคีย์
Const mlnNumStatusSend	= "1" '	1	สถานะการรับเลข	number_status	ส่ง / รอคีย์
Const mlnNumStatusRecAll= "2" '	2	สถานะการรับเลข	number_status	รับหมด
Const mlnNumStatusRecPart= "3" '3	สถานะการรับเลข	number_status	รับบางส่วน
Const mlnNumStatusNoRec	= "4" '	4	สถานะการรับเลข	number_status	ไม่รับ

Const mlnPlayType2Up	= "1" '	1	ประเภทเลขแทง	play_type	สองตัวบน
Const mlnPlayType3Up	= "2" '	2	ประเภทเลขแทง	play_type	สามตัวบน
Const mlnPlayType3Tod	= "3" '	3	ประเภทเลขแทง	play_type	สามตัวโต๊ด
Const mlnPlayType2Tod	= "4" '	4	ประเภทเลขแทง	play_type	สองตัวโต๊ด
Const mlnPlayTypeRunUp	= "5" '	5	ประเภทเลขแทง	play_type	วิ่งบน
Const mlnPlayTypeRunDown= "6" '	6	ประเภทเลขแทง	play_type	วิ่งล่าง
Const mlnPlayType2Down	= "7" '	7	ประเภทเลขแทง	play_type	สองตัวล่าง
Const mlnPlayType3Down	= "8" '	8	ประเภทเลขแทง	play_type	สามตัวล่าง

Const mlnNumWrong	= "0" ' 0	สถานะการตรวจเลข	check_status	ไม่ถูก
Const mlnNumRight	= "1" '	1	สถานะการตรวจเลข	check_status	ถูก

Const mlnGovernment	= "1" '	1	ประเภทหัวย	game_type	หวยรัฐบาล
Const mlnSaving		= "2" ' 2	ประเภทหัวย	game_type	หวยออมสิน
Const mlnOther		= "3" '	3	ประเภทหัวย	game_type	หวยอื่น ๆ

Const mlnGameClose	= "0" '	0	ประเภทการเปิดรับ	game_status	ปิดรับ
Const mlnGameOpen	= "1" ' 1	ประเภทการเปิดรับ	game_status	เปิดรับ

Const mlnDealerCut	= "1" '	1	ประเภทการตัด	cut_type	จากเลขตัดออก
Const mlnSelfCut	= "2" '	2	ประเภทการตัด	cut_type	จากตัดออกเอง

Const mlnSendDealer	= "1" '	1	สถานะการส่ง	send_status	ส่งเจ้ามอเจ้าของ
Const mlnSendOtherDealer= "2" '	2	สถานะการส่ง	send_status	ส่งต่อเจ้ามืออื่น
Const mlnSendOut	= "3" '	3	สถานะการส่ง	send_status	เจ้ามือแทงออก

Const mlnAdminID	= "1000"


%>
<!-- Thread-IT v1.4 developed by yMonda Limited 1999 -->