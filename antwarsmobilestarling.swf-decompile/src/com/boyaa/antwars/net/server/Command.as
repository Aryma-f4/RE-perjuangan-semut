package com.boyaa.antwars.net.server
{
   public class Command
   {
      
      public static const CLIENT_SEND_PROXYSERVER:uint = 10000;
      
      public static const CLIENT_CMD_KEEP_ALIVE:uint = 30001;
      
      public static const CLIENT_COMMAND_LOGON:int = 1001;
      
      public static const CLIENT_COMMAND_CHAT_TO_FRIEND:int = 1002;
      
      public static const CLIENT_COMMAND_CHAT_TO_FRIENDS:int = 1003;
      
      public static const CLIENT_COMMAND_CHAT_HIDE:int = 1004;
      
      public static const CLIENT_COMMAND_CHAT_ENTERROOM:int = 1005;
      
      public static const CLIENT_COMMAND_CHAT_LEAVEROOM:int = 1006;
      
      public static const CLIENT_COMMAND_ENTER_ROOM:int = 1005;
      
      public static const CLIENT_COMMAND_LEAVE_ROOM:int = 1006;
      
      public static const CLIENT_COMMAND_LOUDSPEAKER:int = 1007;
      
      public static const CLIENT_COMMAND_UNIONTALK:int = 1008;
      
      public static const CLIENT_COMMAND_INVITE_UNION:int = 1016;
      
      public static const CLIENT_COMMAND_INVITE_LIST_REQUEST:int = 1009;
      
      public static const CLIENT_COMMAND_INVITE_PLAYER:int = 1010;
      
      public static const CLIENT_COMMAND_INVITE_RESPONE_REJECT:int = 1011;
      
      public static const CLIENT_COMMAND_INVITE_RESPONE_AGREE:int = 1012;
      
      public static const CLIENT_COMMAND_PLAYERDATA:int = 8196;
      
      public static const CLIENT_COMMAND_PLAYER_PLACE:int = 1013;
      
      public static const CLIENT_COMMAND_INVITE_PLAYER_COPY:int = 1014;
      
      public static const CLIENT_COMMAND_SYSTEM_MSG:int = 1015;
      
      public static const CLIENT_COMMADN_UPDATE_SITUATION:int = 1101;
      
      public static const SERVER_CONNETPROXYSUCCESS:uint = 10000;
      
      public static const SERVER_COMMAND_CHAT_TO_FRIEND:int = 1002;
      
      public static const SERVER_COMMAND_CHAT_TO_FRIENDS:int = 1003;
      
      public static const SERVER_COMMAND_FRIEND_LOGON:int = 1004;
      
      public static const SERVER_COMMAND_FRIEND_LOGOUT:int = 1005;
      
      public static const SERVER_COMMAND_SYSTEM_NOTIFY:int = 1006;
      
      public static const SERVER_COMMAND_SYSTEM_REPEAT:int = 1007;
      
      public static const SERVER_COMMAND_LOGIN_SUCCESSFUL:int = 1008;
      
      public static const SERVER_COMMAND_UNIONTALK:uint = 1009;
      
      public static const SERVER_COMMADN_FORCE_REFRESH:int = 1100;
      
      public static const SERVER_REQUEST_INVITE_UNION_LIST:int = 1023;
      
      public static const SERVER_REQUEST_INVITE_UNION_LIST_END:int = 1024;
      
      public static const SERVER_RESPONE_REQUEST_INVITE_LIST:int = 1013;
      
      public static const SERVER_RESPONE_REQUEST_AGREE:int = 1014;
      
      public static const SERVER_RESPONE_REQUEST_REJECT:int = 1015;
      
      public static const SERVER_RESPONE_OFFLINE_NOW:int = 1016;
      
      public static const SERVER_COMMAND_INVITE_PALYER:int = 1017;
      
      public static const SERVER_COMMAND_PLAYER_PLACE:int = 1018;
      
      public static const SERVER_COMMAND_DOUBLE_EXP_FIVE_MINUTE_LEFT:int = 1019;
      
      public static const SERVER_COMMAND_DOUBLE_EXP_BEGIN:int = 1020;
      
      public static const SERVER_COMMAND_DOUBLE_EXP_END:int = 1021;
      
      public static const SERVER_COMMAND_READ_FRIENDLIST_OVER:int = 1022;
      
      public static const SERVER_COMMAND_LOUDSPEAKER:int = 1026;
      
      public static const SERVER_COMMAND_SENDMSG_FAIL:int = 1027;
      
      public static const SERVER_COMMAND_COPY_INVITE:int = 1028;
      
      public static const SERVER_COMMAND_SYSTEM_MESSAGE:uint = 9475;
      
      public static const SERVER_COMMAND_START_UPDATE_MESSAGE:uint = 9476;
      
      public static const SERVER_COMMAND_SYSTEM_MSG:uint = 1001;
      
      public static const SERVER_COMMAND_PROMOTIORACE_PR_beginning:uint = 1029;
      
      public static const SERVER_COMMAND_SEND_REFLUSH_ASSURE:int = 1030;
      
      public static const SERVER_COMMAND_SEND_UNIONOUT:int = 1031;
      
      public static const SERVER_COMMAND_SEND_IN_UNION:int = 1032;
      
      public static const SERVER_OVER_UNFRIEND:uint = 8238;
      
      public static const SERVER_LOGINFAILED:uint = 1025;
      
      public static const SERVER_RESPONES_UNFRIEND:uint = 8237;
      
      public static const CLIENT_REQUEST_UNFRIEND:uint = 8202;
      
      public static const SERVER_COMMAND_UNION_LOGON:int = 1010;
      
      public static const SERVER_COMMAND_UNION_LOGOUT:int = 1011;
      
      public static const SERVER_COMMAND_UNION_ONLINES:int = 1012;
      
      public static const COMMAND_SEND_EMAIL:uint = 2002;
      
      public static const COMMAND_GET_EMAILS:uint = 2003;
      
      public static const COMMAND_READ_EMAIL:uint = 2004;
      
      public static const COMMAND_READ_EMAIL_ATT:uint = 2009;
      
      public static const COMMAND_DELETE_EMAIL:uint = 2005;
      
      public static const COMMAND_GET_ATTACHMENT:uint = 2006;
      
      public static const COMMAND_GET_NOT_READ_EMAIL:uint = 2007;
      
      public static const SERVER_IS_BUSY:uint = 2900;
      
      public static const CMD_CLIENT_ADD_PAIMAIPIN:uint = 3422;
      
      public static const CMD_CLIENT_ADD_PRICE:uint = 3423;
      
      public static const CMD_CLIENT_GET_PAIMAIPIN:uint = 3424;
      
      public static const CMD_CLIENT_GET_REFLASH_PAIMAIPIN:uint = 3425;
      
      public static const CMD_CLIENT_DUIHUAN_PAIMAIBI:uint = 3426;
      
      public static const CMD_CLIENT_GET_SELF_PAIMAIPIN:uint = 3427;
      
      public static const CMD_CLIENT_GET_SELF_TPARTIN:uint = 3428;
      
      public static const CMD_CLIENT_GET_SELF_CANCLE:uint = 3429;
      
      public static const CMD_CLIENT_FRIEND_BAG:uint = 3227;
      
      public static const CLIENT_CMD_FRIEND_BAG:uint = 3227;
      
      public static const CLIENT_COMMAND_MARRYPROPOSE:int = 6001;
      
      public static const SERVER_COMMAND_MARRYPROPOSE:int = 6002;
      
      public static const COMMAND_SENDMARRYPROPOSESUCCESS:int = 6003;
      
      public static const COMMAND_HANDLEMARRYPROPOSE:int = 6004;
      
      public static const SERVER_COMMAND_MARRYVALUE:int = 6005;
      
      public static const SERVER_COMMAND_SELFMARRYVALUE:int = 6006;
      
      public static const SERVER_COMMAND_GETLOGINPROPOSES:int = 6007;
      
      public static const COMMAND_MARRYBESPOKETIME:int = 6008;
      
      public static const COMMAND_SEEMARRYBESPOKE:int = 6009;
      
      public static const COMMAND_GUESTJOINMARRY:int = 6011;
      
      public static const COMMAND_ROUTE_MSG:int = 6012;
      
      public static const COMMAND_REMINDGETINMARRY:int = 6013;
      
      public static const COMMAND_SEEMARRYLIST:int = 6014;
      
      public static const COMMAND_UNMARRYMSG:int = 6015;
      
      public static const COMMAND_SUREUNMARRY:int = 6016;
      
      public static const COMMAND_ANTAPPEARENCE:int = 6017;
      
      public static const COMMAND_ANTMOVE:int = 6018;
      
      public static const COMMAND_LOADCOMPLETE:int = 6019;
      
      public static const COMMAND_LEAVEMARRYROOM:int = 6021;
      
      public static const COMMAND_TELLANTPLACE:int = 6022;
      
      public static const COMMAND_MARRYCHAT:int = 6023;
      
      public static const COMMAND_USEFIRWORKS:int = 6025;
      
      public static const COMMAND_SHOW_STARTBTN:int = 6026;
      
      public static const COMMAND_MARRYSTATUS:int = 6027;
      
      public static const COMMAND_GETHOSTID:int = 6028;
      
      public static const COMMAND_CLICKGIFTBOX:int = 6029;
      
      public static const COMMAND_REQUEST_STARTRITE:int = 6030;
      
      public static const COMMAND_REPLY_RITEREQUEST:int = 6031;
      
      public static const COMMAND_UNMARRY_RESULT:int = 6032;
      
      public static const COMMAND_PAY_UNMARRY:int = 6033;
      
      public static const COMMAND_PARTNER_FAMILIARITY:int = 6036;
      
      public static const CLIENT_COMMAND_SELLGOODS:int = 3004;
      
      public static const SERVER_COMMAND_SELLGOODS:int = 3004;
      
      public static const CLIENT_COMMAND_GETALLGOODS:int = 3014;
      
      public static const SERVER_COMMAND_GETALLGOODS:int = 3014;
      
      public static const CLIENT_COMMAND_GETBODYGOODS:int = 3016;
      
      public static const SERVER_COMMAND_GETBODYGOODS:int = 3016;
      
      public static const CLIENT_COMMAND_SETMEMBODY:int = 3005;
      
      public static const SERVER_COMMAND_SETMEMBODY:int = 3005;
      
      public static const CLIENT_COMMAND_SETPACKAGE:int = 3017;
      
      public static const SERVER_COMMAND_SETPACKAGE:int = 3017;
      
      public static const CLIENT_COMMAND_TOSTORAGE:int = 3018;
      
      public static const SERVER_COMMAND_TOSTORAGE:int = 3018;
      
      public static const SERVER_RENT_GOODS:int = 3109;
      
      public static const CLIENT_RENT_GOODS:int = 3109;
      
      public static const CLIENT_UNION_ALL_RENT_GOODS:int = 3117;
      
      public static const SERVER_UNION_ALL_RENT_GOODS:int = 3117;
      
      public static const SERVER_UNION_TO_RENTAL_STORAGE:int = 3107;
      
      public static const CLIENT_UNION_TO_RENTAL_STORAGE:int = 3107;
      
      public static const CLIENT_FROME_RENTAL_TO_MY_WAREHOUSE:int = 3108;
      
      public static const SERVER_FROME_RENTAL_TO_MY_WAREHOUSE:int = 3108;
      
      public static const SERVER_DEL_OVER_TIME_RENTAL_GOODS:int = 3118;
      
      public static const SERVER_BAG_RENT_STATUS:int = 3119;
      
      public static const SERVER_NOBODY_RENT:int = 3120;
      
      public static const CLIENT_COMMAND_TOBUY:int = 3013;
      
      public static const SERVER_COMMAND_TOBUY:int = 3013;
      
      public static const CLIENT_COMMAND_TOSTRENTHEN:int = 3008;
      
      public static const SERVER_COMMAND_TOSTRENTHEN:int = 3008;
      
      public static const CLIENT_COMMAND_TOSYNTHESIS:int = 3010;
      
      public static const SERVER_COMMAND_TOSYNTHESIS:int = 3010;
      
      public static const CLIENT_COMMAND_TOADDITION:int = 3116;
      
      public static const SERVER_COMMAND_TOADDITION:int = 3116;
      
      public static const CLIENT_COMMAND_TOTRANSFER:int = 3009;
      
      public static const SERVER_COMMAND_TOTRANSFER:int = 3009;
      
      public static const CLIENT_COMMAND_TORONGLIAN:int = 3011;
      
      public static const SERVER_COMMAND_TORONGLIAN:int = 3011;
      
      public static const CLIENT_COMMAND_TOCHONGZHU:int = 3012;
      
      public static const SERVER_COMMAND_TOCHONGZHU:int = 3012;
      
      public static const CLIENT_COMMAND_TOCHONGZHUCOVER:int = 3015;
      
      public static const SERVER_COMMAND_TOCHONGZHUCOVER:int = 3015;
      
      public static const CLIENT_COMMAND_USEGOODS:int = 3006;
      
      public static const SERVER_COMMAND_USEGOODS:int = 3006;
      
      public static const CLIENT_COMMAND_RENEW:int = 3007;
      
      public static const SERVER_COMMAND_RENEW:int = 3007;
      
      public static const SERVER_COMMAND_FRIEND_BODY_BAG:int = 3023;
      
      public static const CLIENT_COMMAND_FRIEND_BODY_BAG:int = 3023;
      
      public static const CLIENT_COMMAND_BUYCOOLDOWN:int = 3031;
      
      public static const SERVER_COMMAND_BUYCOOLDOWN:int = 3031;
      
      public static const ADD_LUCKYDRAW_GOOD:uint = 3024;
      
      public static const ADD_GOOD:uint = 3024;
      
      public static const SERVER_COMMAND_GET_RANK:int = 2200;
      
      public static const CLIENT_COMMAND_GET_RANK:int = 2200;
      
      public static const SERVER_COMMAND_GET_SELFRANK:int = 2202;
      
      public static const CLIENT_COMMAND_GET_SELFRANK:int = 2202;
      
      public static const SERVER_COMMAND_GET_RANKLIST:int = 2201;
      
      public static const CLIENT_COMMAND_GET_RANKLIST:int = 2201;
      
      public static const CLIENT_REQUEST_SERVER_LIST:int = 1;
      
      public static const SERVER_RESPONSE_SERVER_LIST:int = 1;
      
      public static const CLIENT_REQUEST_ALLOCATE_SERVER:int = 4;
      
      public static const SERVER_RESPONSE_ALLOCATE_SERVER:int = 4;
      
      public static const CLIENT_REQUEST_FREEWAR_LIST:int = 2;
      
      public static const SERVER_RESPONSE_FREEWAR_LIST:int = 2;
      
      public static const CLIENT_REQUEST_COPY_LIST:int = 3;
      
      public static const SERVER_REQUEST_COPY_LIST:int = 3;
      
      public static const CMD_REQ_LOGIN:uint = 0;
      
      public static const CMD_CONNECTSUCCESS:uint = 1;
      
      public static const CMD_LOGIN_FAIN:uint = 2;
      
      public static const CMD_CONNECTFAIN:uint = 16385;
      
      public static const CLIENT_COMMAND_QUICK_JOIN_GAME:uint = 6;
      
      public static const SERVER_COMMAND_RESPONSE_ENTER_ROOM:uint = 5;
      
      public static const CMD_SEND_CHAT:uint = 3;
      
      public static const CMD_SEND_EXPRESSION:uint = 4;
      
      public static const CMD_RECV_CHAT:uint = 3;
      
      public static const CMD_RECV_EXPRESSION:uint = 4;
      
      public static const CLIENT_COMMAND_CREATE_ROOM:uint = 5;
      
      public static const CLIENT_COMMAND_SEARCH_ROOM:uint = 13;
      
      public static const SERVER_COMMAND_FIND_ROOM_ERROR:uint = 12;
      
      public static const SERVER_COMMAND_EMPTY_ROOM:uint = 3000;
      
      public static const CLIENT_COMMAND_NET_DELAY:uint = 37;
      
      public static const CLIENT_COMMAND_UPDATE_NET_DELAY:uint = 38;
      
      public static const SERVER_COMMAND_NET_DELAY:uint = 32;
      
      public static const SERVER_COMMAND_NOTIFY_NET_DELAY:uint = 33;
      
      public static const CLIENT_COMMAND_CHANGE_ROOM:uint = 31;
      
      public static const SERVER_COMMAND_CHANGE_ROOM_ERROR:uint = 27;
      
      public static const CLIENT_COMMAND_USER_READY:uint = 7;
      
      public static const SERVER_COMMAND_BROADCAST_USER_READY:uint = 8;
      
      public static const CMD_PUBLIC_COMEON:uint = 6;
      
      public static const SERVER_COMMAND_PUBLIC_HOUSEOWNER:uint = 9;
      
      public static const CLIENT_COMMAND_FIGHT_DATA:uint = 1204;
      
      public static const SERVER_COMMAND_FIGHT_DATA:uint = 1204;
      
      public static const SERVER_COMMAND_PLAYER_LEAVE:uint = 1205;
      
      public static const CLIENT_COMMAND_ROBOT_2V2_GAMEOVER:uint = 1203;
      
      public static const SERVER_COMMAND_2V2_CHANGEROOM_FAST:uint = 1201;
      
      public static const CLIENT_COMMAND_CHANGE_EQUIP:uint = 1206;
      
      public static const SERVER_COMMAND_2V2_ROBOT_START:uint = 1207;
      
      public static const SERVER_COMMAND_2V2_ROBOT_TIMEOUT:uint = 1208;
      
      public static const SERVER_COMMAND_OPEN_POS:uint = 21;
      
      public static const SERVER_COMMAND_BROADCAST_GAME_READY_GO:uint = 24;
      
      public static const SERVER_COMMAND_BROADCAST_SYNC_BODY:uint = 1001;
      
      public static const CLIENT_MAP_PROGRESS:uint = 34;
      
      public static const SERVER_MAP_PROGRESS:uint = 30;
      
      public static const CMD_LAOD_COMPELELT:uint = 1001;
      
      public static const CMD_LOADMAP_OVERTIME:uint = 1017;
      
      public static const CMD_PLAY_GAME:uint = 1005;
      
      public static const CMD_PUBLIC_MOVE:uint = 1007;
      
      public static const CMD_SEND_PLAYERMOVE:uint = 1002;
      
      public static const CMD_BOMBPOINT:uint = 1005;
      
      public static const CMD_CURRENTCOMPLETE:uint = 1006;
      
      public static const CMD_OVERTIME:uint = 1007;
      
      public static const CMD_TOUCHDOWN_DEDUCTIONHP:uint = 1009;
      
      public static const CMD_SERVER_ANT_DROP_DEAD:uint = 3006;
      
      public static const CMD_USE_PROP:uint = 1010;
      
      public static const CMD_PUBLI_USE_PROP:uint = 1014;
      
      public static const CMD_SETSENDER:uint = 1008;
      
      public static const SERVER_COMMAND_SYNC_ANGER:int = 1103;
      
      public static const CLIENT_COMMAND_TOLAND:uint = 39;
      
      public static const CMD_GIVEUP:uint = 1014;
      
      public static const CMD_PUBLIC_BOMBPOINT:uint = 1010;
      
      public static const CMD_ANGRY:uint = 1012;
      
      public static const CMD_PUBLIC_ANGRY:uint = 1016;
      
      public static const CMD_GAMEOVER:uint = 1006;
      
      public static const SERVER_COMMAND_BROADCAST_USER_LEAVE_ROOM:uint = 7;
      
      public static const CMD_OVER_LUCKYDRAW:uint = 1011;
      
      public static const CMD_PUBLIC_LUCKYDRAW:uint = 1015;
      
      public static const CLIENT_COMMAND_WARD_OVER:uint = 1024;
      
      public static const CLIENT_SEND_BUY_PROP:uint = 29;
      
      public static const CLIENT_CANCEL_BUY_PROP:uint = 30;
      
      public static const CMD_RECV_BUY_PROP:uint = 1019;
      
      public static const CLIENT_COMMAND_robotOver:uint = 41;
      
      public static const SERVER_COMMAND_ENTER_ROBOT_MODE:uint = 38;
      
      public static const SERVER_COMMAND_ROBOT_MODE_PLAYING:uint = 39;
      
      public static const CLIENT_COMMAND_GETFIHGTLIST:uint = 3007;
      
      public static const SERVER_COMMAND_GETFIGHTLIST:uint = 3007;
      
      public static const CLIENT_CREATE_BTROOM:uint = 3008;
      
      public static const CLIENT_PLAYER_WEAPON_STATE:uint = 3009;
      
      public static const SERVER_PLAYER_WEAPON_STATE:uint = 3009;
      
      public static const CLIENT_PLAYER_CHANGE_WEAPON_IN_BOX:uint = 3010;
      
      public static const SERVER_PLAYER_CHANGE_WEAPON_IN_BOX:uint = 3010;
      
      public static const CLIENT_PLAYER_SEND_CHANGEWEAPON_DONE:uint = 3011;
      
      public static const SERVER_PLAYER_CHANGEWEAPON_DONE:uint = 3011;
      
      public static const SERVER_COMMAND_GETENERGY:int = 3051;
      
      public static const CLIENT_COMMAND_GETENERGY:int = 3051;
      
      public static const SERVER_COMMAND_CONSUMEENERGY:int = 3052;
      
      public static const CLIENT_COMMAND_CONSUMEENERGY:int = 3052;
      
      public static const COPY_SERVER_LOGIN:uint = 4001;
      
      public static const COPY_CLIENT_LOGIN:uint = 4001;
      
      public static const COPY_SERVER_OTHER_LOGIN:uint = 4002;
      
      public static const COPY_CLIENT_OTHER_LOGIN:uint = 4002;
      
      public static const COPY_SERVER_CREATEROOM:uint = 4003;
      
      public static const COPY_CLIENT_CREATEROOM:uint = 4003;
      
      public static const COPY_SERVER_MATCH:uint = 4004;
      
      public static const COPY_CLIENT_MATCH:uint = 4004;
      
      public static const COPY_SERVER_JOIN:uint = 4005;
      
      public static const COPY_CLIENT_JOIN:uint = 4005;
      
      public static const COPY_SERVER_GAME_START:uint = 4006;
      
      public static const COPY_CLIENT_GAME_START:uint = 4006;
      
      public static const COPY_SERVER_TURN:uint = 4007;
      
      public static const COPY_CLIENT_TURN:uint = 4007;
      
      public static const COPY_SERVER_ROOMLIST:uint = 4008;
      
      public static const COPY_CLIENT_ROOMLIST:uint = 4008;
      
      public static const COPY_SERVER_LEAVE:uint = 4009;
      
      public static const COPY_CLIENT_LEAVE:uint = 4009;
      
      public static const COPY_SERVER_CLOSESITE:uint = 4010;
      
      public static const COPY_CLIENT_CLOSESITE:uint = 4010;
      
      public static const COPY_SERVER_KICKPLAYER:uint = 4011;
      
      public static const COPY_CLIENT_KICKPLAYER:uint = 4011;
      
      public static const COPY_SERVER_PLAYERREADY:uint = 4012;
      
      public static const COPY_CLIENT_PLAYERREADY:uint = 4012;
      
      public static const COPY_SERVER_FINDROOM:uint = 4013;
      
      public static const COPY_CLIENT_FINDROOM:uint = 4013;
      
      public static const COPY_SERVER_OTHER_JOIN:uint = 4014;
      
      public static const COPY_CLIENT_CREATE_DONE:uint = 4016;
      
      public static const COPY_CLIENT_BACK_ROOM:uint = 4017;
      
      public static const COPY_CLIENT_CHANGE_CLOTHES:uint = 4018;
      
      public static const COPY_SERVER_CHANGE_CLOTHES:uint = 4018;
      
      public static const COPY_CLIENT_LOAD_MAP_COMPLETE:uint = 4050;
      
      public static const COPY_SERVER_LOAD_MPA_FAILE:uint = 4051;
      
      public static const COPY_SERVER_PLAYGAME:uint = 4052;
      
      public static const COPY_CLIENT_PLAYGAME:uint = 4052;
      
      public static const COPY_SERVER_GAMEOVER:uint = 4053;
      
      public static const COPY_CLIENT_MAPPROGRESS:uint = 4054;
      
      public static const COPY_SERVER_MAPPROGRESS:uint = 4054;
      
      public static const COPY_SERVER_BORNPOINT:uint = 4055;
      
      public static const COPY_SERVER_BOSS_BORNPOINT:uint = 4056;
      
      public static const COPY_CLIENT_PLAYER_USEPROP:uint = 4100;
      
      public static const COPY_SERVER_PLAYER_USEPROP:uint = 4100;
      
      public static const COPY_CLIENT_PLAYER_USESKILL:uint = 4101;
      
      public static const COPY_SERVER_PLAYER_USESKILL:uint = 4101;
      
      public static const COPY_CLIENT_PLAYER_MOVE:uint = 4102;
      
      public static const COPY_SERVER_PLAYER_MOVE:uint = 4102;
      
      public static const COPY_CLIENT_PLAYER_SHOOT:uint = 4103;
      
      public static const COPY_SERVER_PLAYER_SHOOT:uint = 4103;
      
      public static const COPY_CLIENT_PLAYER_DROPHP:uint = 4104;
      
      public static const COPY_SERVER_PLAYER_DROPHP:uint = 4104;
      
      public static const COPY_CLIENT_PLAYER_STATUS:uint = 4105;
      
      public static const COPY_SERVER_PLAYER_STATUS:uint = 4105;
      
      public static const COPY_CLIENT_PLAYER_DEAD:uint = 4106;
      
      public static const COPY_SERVER_PLAYER_DEAD:uint = 4106;
      
      public static const COPY_CLIENT_PLAYER_ANGER:uint = 4107;
      
      public static const COPY_SERVER_PLAYER_ANGER:uint = 4107;
      
      public static const COPY_CLIENT_PLAYER_TIMEOUT:uint = 4108;
      
      public static const COPY_SERVER_PLAYER_TIMEOUT:uint = 4108;
      
      public static const COPY_CLIENT_PLAYER_TURNCARD:uint = 4109;
      
      public static const COPY_SERVER_PLAYER_TURNCARD:uint = 4109;
      
      public static const COPY_CLIENT_PLAYER_SHOWCOMPLETE:uint = 4110;
      
      public static const COPY_SERVER_PLAYER_SHOWCOMPLETE:uint = 4110;
      
      public static const COPY_CLIENT_PLAYER_GIVEUP:uint = 4111;
      
      public static const COPY_SERVER_PLAYER_GIVEUP:uint = 4111;
      
      public static const COPY_CLIENT_PLAYER_EXIT:uint = 4112;
      
      public static const COPY_SERVER_PLAYER_EXIT:uint = 4112;
      
      public static const COPY_SERVER_SETSHOOTER:uint = 4113;
      
      public static const COPY_CLIENT_BOMBPOINT:uint = 4114;
      
      public static const COPY_SERVER_BOMBPOINT:uint = 4114;
      
      public static const COPY_SERVER_PLAYER_SHOWEACHOTHER:uint = 4115;
      
      public static const COPY_SERVER_MONSTER_SHOWTOPLAYER:uint = 4116;
      
      public static const COPY_CLIENT_PLAYER_DONE:uint = 4117;
      
      public static const COPY_CLIENT_USE_ENERGY:uint = 4118;
      
      public static const COPY_CLIENT_RELIVE_IN_BOSSROOM:uint = 4119;
      
      public static const COPY_SERVER_RELIVE_IN_BOSSROOM:uint = 4119;
      
      public static const COPY_CLIENT_RELIVE_IN_NORMAL:uint = 4120;
      
      public static const COPY_SERVER_RELIVE_IN_NORMAL:uint = 4120;
      
      public static const COPY_SERVER_PUBLIC_RELIVE:uint = 4121;
      
      public static const COPY_CLIENT_BOSS_ATTACK:uint = 4150;
      
      public static const COPY_SERVER_BOSS_ATTACK:uint = 4150;
      
      public static const COPY_CLIENT_BOSS_DROPHP:uint = 4151;
      
      public static const COPY_SERVER_BOSS_DROPHP:uint = 4151;
      
      public static const COPY_CLIENT_BOSS_MOVE:uint = 4152;
      
      public static const COPY_SERVER_BOSS_MOVE:uint = 4152;
      
      public static const COPY_CLIENT_BOSS_DEAD:uint = 4153;
      
      public static const COPY_SERVER_BOSS_DEAD:uint = 4153;
      
      public static const COPY_CLIENT_MONSTER_ATTACK:uint = 4180;
      
      public static const COPY_SERVER_MONSTER_ATTACK:uint = 4180;
      
      public static const COPY_CLIENT_MONSTER_DROPHP:uint = 4181;
      
      public static const COPY_SERVER_MONSTER_DROPHP:uint = 4181;
      
      public static const COPY_CLIENT_MONSTER_MOVE:uint = 4182;
      
      public static const COPY_SERVER_MONSTER_MOVE:uint = 4182;
      
      public static const COPY_CLIENT_MONSTER_DEAD:uint = 4183;
      
      public static const COPY_SERVER_MONSTER_DEAD:uint = 4183;
      
      public static const COPY_CLIENT_MONSTERSHOOTER_ATTACK:uint = 4184;
      
      public static const COPY_SERVER_MONSTER_COUNT:uint = 4202;
      
      public static const ENDLESS_CLIENT_GETDATA:uint = 4300;
      
      public static const ENDLESS_SERVER_GETDATA:uint = 4300;
      
      public static const ENDLESS_CLIENT_GETMONSTER:uint = 4301;
      
      public static const ENDLESS_SERVER_GETMONSTER:uint = 4301;
      
      public static const ENDLESS_CLIENT_NEXTLEVEL:uint = 4302;
      
      public static const ENDLESS_SERVER_NEXTLEVEL:uint = 4302;
      
      public static const ENDLESS_CLIENT_WINANDBACK:uint = 4303;
      
      public static const ENDLESS_CLIENT_LOSSANDBACK:uint = 4305;
      
      public static const ENDLESS_CLIENT_RELIVE:uint = 4304;
      
      public static const ENDLESS_SERVER_RELIVE:uint = 4304;
      
      public static const ENDLESS_CLIENT_FLYTOTOP:uint = 4306;
      
      public static const ENDLESS_SERVER_FLYTOTOP:uint = 4306;
      
      public static const ENDLESS_CLIENT_RANKLIST:uint = 4307;
      
      public static const ENDLESS_SERVER_RANKLIST:uint = 4307;
      
      public static const ENDLESS_CLIENT_BUYTIME:uint = 4308;
      
      public static const ENDLESS_SERVER_BUYTIME:uint = 4308;
      
      public static const ENDLESS_SERVER_REWARDBOX:uint = 4309;
      
      public static const CMD_CLIENT_TOP50_LIST:uint = 3053;
      
      public static const CMD_SERVER_TOP50_LIST:uint = 3053;
      
      public static const CMD_CLIENT_UP20_DOWN30_LIST:uint = 3054;
      
      public static const CMD_SERVER_UP20_DOWN30_LIST:uint = 3054;
      
      public static const CMD_CLIENT_BATTLE_REQUEST:uint = 3055;
      
      public static const CMD_SERVER_BATTLE_REQUEST:uint = 3055;
      
      public static const CMD_CLIENT_BATTLE_RESULT:uint = 3056;
      
      public static const CMD_SERVER_BATTLE_RESULT:uint = 3056;
      
      public static const CMD_CLIENT_BATTLE_HISTORY:uint = 3057;
      
      public static const CMD_SERVER_BATTLE_HISTORY:uint = 3057;
      
      public static const CMD_CLIENT_GET_RANK_REWARDS:uint = 3058;
      
      public static const CMD_SERVER_GET_RANK_REWARDS:uint = 3058;
      
      public static const CMD_CLIENT_GET_RANK_EQUIP:uint = 3059;
      
      public static const CMD_SERVER_GET_RANK_EQUIP:uint = 3059;
      
      public static const CMD_SERVER_GET_RANKACT_FIGHT:uint = 3062;
      
      public static const CMD_SERVER_GET_RANKACT_LEVEL:uint = 3063;
      
      public static const CMD_SERVER_SEND_MAIL:uint = 8001;
      
      public static const CMD_CLIENT_SEND_MAIL:uint = 8001;
      
      public static const CMD_SERVER_READ_MAIL:uint = 8002;
      
      public static const CMD_CLIENT_READ_MAIL:uint = 8002;
      
      public static const CMD_SERVER_GET_MAIL_LIST:uint = 8003;
      
      public static const CMD_CLIENT_GET_MAIL_LIST:uint = 8003;
      
      public static const CMD_SERVER_GET_FILE_MAIL:uint = 8004;
      
      public static const CMD_CLIENT_GET_FILE_MAIL:uint = 8004;
      
      public static const CMD_SERVER_DEL_MAIL:uint = 8005;
      
      public static const CMD_CLIENT_DEL_MAIL:uint = 8005;
      
      public static const CMD_SERVER_NEW_MAIL:uint = 8006;
      
      public static const CMD_CLIENT_UPDATA_BAG:uint = 8008;
      
      public static const CMD_CLIENT_SEND_POPMARRY:uint = 6001;
      
      public static const CMD_SERVER_RECEIVE_IS_SEND_POPMARRY:uint = 6001;
      
      public static const CMD_SERVER_RECEIVE_POPMARRY:uint = 6002;
      
      public static const CMD_CLIENT_SEND_POPMARRY_ANSWER:uint = 6004;
      
      public static const CMD_SERVER_RECEIVE_POPMARRY_ANSWER:uint = 6004;
      
      public static const CMD_SERVER_MARRY_STATE:uint = 6006;
      
      public static const CMD_SERVER_PUSH_POPMARRY:uint = 6007;
      
      public static const CMD_CLIENT_SEND_MARRAY_ME:uint = 6038;
      
      public static const CMD_SERVER_RECEIVE_MARRAY_ME:uint = 6038;
      
      public static const CMD_CLIENT_GET_ENTER_WEDDING:uint = 6039;
      
      public static const CMD_SERVER_RECEIVE_ENTER_WEDDING:uint = 6039;
      
      public static const CMD_CLIENT_SEND_DIVORCE_MSG:uint = 6040;
      
      public static const CMD_SERVER_RECEIVE_IS_SEND_DIVORCEMSG:uint = 6040;
      
      public static const CMD_SERVER_RECEIVE_DIVORCE_MSG:uint = 6041;
      
      public static const CMD_CLIENT_SEND_DIVORCE_AGREE:uint = 6042;
      
      public static const CMD_SERVER_RECEIVE_DIVORCE_AGREE:uint = 6042;
      
      public static const CMD_CLIENT_SEND_EXCHANGE_RING:uint = 6043;
      
      public static const MERRY_RING_ZQ:int = 3226;
      
      public static const CMD_SERVER_UINON_FIGHT_STATE:uint = 5300;
      
      public static const CMD_CLIENT_UINON_FIGHT_GAMESTART:uint = 5301;
      
      public static const CMD_SERVER_UINON_FIGHT_GAMESTART:uint = 5301;
      
      public static const CMD_SERVER_UINON_FIGHT_SWITCH:uint = 5303;
      
      public static const CMD_CLIENT_UINON_FIGHT_USEPROP:uint = 5302;
      
      public static const CMD_SERVER_UINON_FIGHT_USEPROP:uint = 5302;
      
      public static const CMD_SERVER_UINON_FIGHT_BOSSATTACK:uint = 5304;
      
      public static const CMD_CLIENT_UINON_FIGHT_ACTION_COMPLETE:uint = 5305;
      
      public static const CMD_CLIENT_UINON_FIGHT_BOMBPOINT:uint = 5306;
      
      public static const CMD_SERVER_UINON_FIGHT_BOMBPOINT:uint = 5306;
      
      public static const CMD_SERVER_UINON_FIGHT_TIMEOVER:uint = 5307;
      
      public static const CMD_SERVER_UINON_FIGHT_BOSSDEAD:uint = 5308;
      
      public static const CMD_CLIENT_UINON_FIGHT_GETRANK:uint = 5309;
      
      public static const CMD_SERVER_UINON_FIGHT_GETRANK:uint = 5309;
      
      public static const CMD_CLIENT_UINON_FIGHT_GETINFO:uint = 5310;
      
      public static const CMD_SERVER_UINON_FIGHT_GETINFO:uint = 5310;
      
      public static const CMD_SERVER_UINON_FIGHT_SEND_DEVOTE:uint = 5311;
      
      public static const CMD_CLIENT_UINON_FIGHT_REWARD:uint = 5312;
      
      public static const CMD_SERVER_UINON_FIGHT_REWARD:uint = 5312;
      
      public static const CMD_EXCHANGE_PROP:int = 3053;
      
      public static const ENDLESS_CLIENT_FREE_RELIVE:uint = 4310;
      
      public static const ENDLESS_SERVER_FREE_RELIVE:uint = 4310;
      
      public static const CMD_VIP_LUCKYDRAW:uint = 3005;
      
      public static const CMD_CLIENT_VIPVIEW_INFO:uint = 3111;
      
      public static const CMD_SERVER_VIPVIEW_INFO:uint = 3111;
      
      public static const CMD_CLIENT_KNOW_SOMEONE_VIP:uint = 3110;
      
      public static const CMD_SERVER_KNOW_SOMEONE_VIP:uint = 3110;
      
      public static const CMD_CLIENT_REWARD_VIP_GIFTS:uint = 3112;
      
      public static const CMD_SERVER_REWARD_VIP_GIFTS:uint = 3112;
      
      public static const CMD_CLIENT_AUTOFIGHT_TIMES:uint = 3114;
      
      public static const CMD_SERVER_AUTOFIGHT_TIMES:uint = 3114;
      
      public static const CMD_CLIENT_USE_AUTOFIGHT:uint = 3115;
      
      public static const CMD_SERVER_USE_AUTOFIGHT:uint = 3115;
      
      public static const CMD_FREE_RELIVE_IN_COPY_TIMES:uint = 4122;
      
      public static const CMD_USE_FREE_RELIVE_IN_COPY:uint = 4123;
      
      public static const CLIENT_COPY_PLAYER_SMSG_CHANGEWEAPON:uint = 4124;
      
      public static const SERVER_COPY_PLAYER_SMSG_CHANGEWEAPON:uint = 4124;
      
      public static const CLIENT_BATTLE_PLAYER_SMSG_CHANGEWEAPON:uint = 3012;
      
      public static const SERVER_BATTLE_PLAYER_SMSG_CHANGEWEAPON:uint = 3012;
      
      public static const CLIENT_UNIONCOPY_PLAYER_SMSG_CHANGEWEAPON:uint = 5315;
      
      public function Command()
      {
         super();
      }
   }
}

