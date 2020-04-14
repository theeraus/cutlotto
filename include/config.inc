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
Const mlnUserTypeAdmin	= "A" '	A	����������	user_type	Admin
Const mlnUserTypeDealer	= "D" '	D	����������	user_type	������
Const mlnUserTypeKey	= "K" '	K	����������	user_type	������
Const mlnUserTypePlayer	= "P" '	P	����������	user_type	��ᷧ

Const mlnRecAuto	= "1" '	1	����������Ѻ��	rec_ticket	�Ѻ�ѵ��ѵ�
Const mlnRecApplove	= "2" '	2	����������Ѻ��	rec_ticket	�ͤ�ǡ�͹�Ѻ

Const mlnStatusKey	= "0" ' 0	ʶҹС���Ѻ��	rec_status	���ѧ����
Const mlnStatusSend	= "1" '	1	ʶҹС���Ѻ��	rec_status	�� / �ͤ���
Const mlnStatusRecAll	= "2" '	2	ʶҹС���Ѻ��	rec_status	�Ѻ���
Const mlnStatusRecPart	= "3" '	3	ʶҹС���Ѻ��	rec_status	�Ѻ�ҧ��ǹ
Const mlnStatusRecNoRec	= "4" '	4	ʶҹС���Ѻ��	rec_status	����Ѻ

Const mlnKeyCom		= "1" '	1	ᷧ�ҡ	key_from	����������
Const mlnKeyPDA		= "2" '	2	ᷧ�ҡ	key_from	PDA

Const mlnDown		= "1" '	1	�Ţ�� ��ҧ	�updown_type	��ҧ
Const mlnUp		= "2" '	2	�Ţ�� ��ҧ	�updown_type	��
Const mlnUpDonw		= "3" '	3	�Ţ�� ��ҧ	�updown_type	��+��ҧ

Const mlnNumStatusKey	= "0" ' 0	ʶҹС���Ѻ�Ţ	number_status	���ѧ����
Const mlnNumStatusSend	= "1" '	1	ʶҹС���Ѻ�Ţ	number_status	�� / �ͤ���
Const mlnNumStatusRecAll= "2" '	2	ʶҹС���Ѻ�Ţ	number_status	�Ѻ���
Const mlnNumStatusRecPart= "3" '3	ʶҹС���Ѻ�Ţ	number_status	�Ѻ�ҧ��ǹ
Const mlnNumStatusNoRec	= "4" '	4	ʶҹС���Ѻ�Ţ	number_status	����Ѻ

Const mlnPlayType2Up	= "1" '	1	�������Ţᷧ	play_type	�ͧ��Ǻ�
Const mlnPlayType3Up	= "2" '	2	�������Ţᷧ	play_type	�����Ǻ�
Const mlnPlayType3Tod	= "3" '	3	�������Ţᷧ	play_type	��������
Const mlnPlayType2Tod	= "4" '	4	�������Ţᷧ	play_type	�ͧ�����
Const mlnPlayTypeRunUp	= "5" '	5	�������Ţᷧ	play_type	��觺�
Const mlnPlayTypeRunDown= "6" '	6	�������Ţᷧ	play_type	�����ҧ
Const mlnPlayType2Down	= "7" '	7	�������Ţᷧ	play_type	�ͧ�����ҧ
Const mlnPlayType3Down	= "8" '	8	�������Ţᷧ	play_type	��������ҧ

Const mlnNumWrong	= "0" ' 0	ʶҹС�õ�Ǩ�Ţ	check_status	���١
Const mlnNumRight	= "1" '	1	ʶҹС�õ�Ǩ�Ţ	check_status	�١

Const mlnGovernment	= "1" '	1	����������	game_type	����Ѱ���
Const mlnSaving		= "2" ' 2	����������	game_type	�������Թ
Const mlnOther		= "3" '	3	����������	game_type	������ �

Const mlnGameClose	= "0" '	0	����������Դ�Ѻ	game_status	�Դ�Ѻ
Const mlnGameOpen	= "1" ' 1	����������Դ�Ѻ	game_status	�Դ�Ѻ

Const mlnDealerCut	= "1" '	1	��������õѴ	cut_type	�ҡ�Ţ�Ѵ�͡
Const mlnSelfCut	= "2" '	2	��������õѴ	cut_type	�ҡ�Ѵ�͡�ͧ

Const mlnSendDealer	= "1" '	1	ʶҹС����	send_status	���������Ңͧ
Const mlnSendOtherDealer= "2" '	2	ʶҹС����	send_status	�觵�����������
Const mlnSendOut	= "3" '	3	ʶҹС����	send_status	������ᷧ�͡

Const mlnAdminID	= "1000"


%>
<!-- Thread-IT v1.4 developed by yMonda Limited 1999 -->