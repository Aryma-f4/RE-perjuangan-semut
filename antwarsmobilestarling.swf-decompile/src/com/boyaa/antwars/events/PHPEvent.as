package com.boyaa.antwars.events
{
   import flash.events.Event;
   
   public class PHPEvent extends Event
   {
      
      public static const GAME_MEMBER_LOAD:String = "GameMemberLoad";
      
      public static const GAME_BIND_ACCOUNT:String = "GameBindAccount";
      
      public static const GAME_MEMBER_CREATE:String = "GameMemberCreate";
      
      public static const GAME_MEMBER_CHECKREPEATROLE:String = "GAME_MEMBER_CHECKREPEATROLE";
      
      public static const GAME_PROPS_BUY:String = "GAME_PROPS_BUY";
      
      public static const GAME_PROPS_GETMEMPROPS:String = "GAME_PROPS_GETMEMPROPS";
      
      public static const GET_NEWBIE_PRESENTPROPS:String = "GET_NEWBIE_PRESENTPROPS";
      
      public static const GAME_PROPS_STRENGTHEN:String = "GAME_PROPS_STRENGTHEN";
      
      public static const GAME_PROPS_SYNTHESIS:String = "GAME_PROPS_SYNTHESIS";
      
      public static const GAME_PROPS_RONGLIAN:String = "GAME_PROPS_RONGLIAN";
      
      public static const GAME_PROPS_TRANSFER:String = "GAME_PROPS_TRANSFER";
      
      public static const GAME_PROPS_CHONGZHU:String = "GAME_PROPS_CHONGZHU";
      
      public static const GAME_PROPS_CHONGZHUCOVER:String = "GAME_PROPS_CHONGZHUCOVER";
      
      public static const GAME_PROPS_CHANGEPLACE:String = "GAME_PROPS_CHANGEPLACE";
      
      public static const GAME_PROPS_CHANGEPLACES:String = "GAME_PROPS_CHANGEPLACES";
      
      public static const GAME_ADDFIREND:String = "GAME_ADDFIREND";
      
      public static const GAME_DELETE_FRIEND:String = "GAME_DELETE_FRIEND";
      
      public static const GAME_VisitedFriend:String = "GAME_VisitedFriend";
      
      public static const GAME_WarrantComplete:String = "GAME_WarrantComplete";
      
      public static const GAME_COMPANY:String = "GAME_COMPANY";
      
      public static const INVITE_GETGIFT:String = "INVITE_GETGIFT";
      
      public static const GETINVITEPRIZE:String = "GETINVITEPRIZE";
      
      public static const GAME_READTERRACE:String = "GAME_READTERRACE";
      
      public static const REQUEST_OF_ADDINGFRIEND:String = "request_of_addingfriend";
      
      public static const RESPOND_TO_ADDINGFRIEND:String = "respond_to_addingfriend";
      
      public static const GAME_MEMBER_ATTACHMENT:String = "GAME_MEMBER_ATTACHMENT";
      
      public static const GAME_MEMBER_READMAIL:String = "GAME_MEMBER_READMAIL";
      
      public static const GAME_MEMBER_READALLMAIL:String = "GAME_MEMBER_READALLMAIL";
      
      public static const GAME_MEMBER_SENDMAIL:String = "GAME_MEMBER_SENDMAIL";
      
      public static const GAME_MEMBER_DELMAIL:String = "GAME_MEMBER_DELMAIL";
      
      public static const GAME_TABLE_GETSERVER:String = "GAME_TABLE_GETSERVER";
      
      public static const GAME_TABLE_FASTSTART:String = "GAME_TABLE_FASTSTART";
      
      public static const GAME_TABLE_SEEKROOM:String = "GAME_TABLE_SEEKROOM";
      
      public static const GAME_GOODS_OPEN_GIFT:String = "GAME_GOODS_OPEN_GIFT";
      
      public static const GOODS_RENEW:String = "GOODS_RENEW";
      
      public static const GOODS_SELL:String = "GOODS_SELL";
      
      public static const SYSSendMoney:String = "SYSSendMoney";
      
      public static const CONSUMEPROP:String = "CONSUMEPROP";
      
      public static const SEND_FEED_BACK:String = "SEND_FEED_BACK";
      
      public static const GET_MISSION_STATE:String = "getMissionState";
      
      public static const GAIN_REWARD:String = "gain_reward";
      
      public static const LUCK_DRAW:String = "luckDraw";
      
      public static const LEVEL_RANK:String = "levelRank";
      
      public static const FIGHT_RANK:String = "fightRank";
      
      public static const CREATE_HOME:String = "create_home";
      
      public static const GET_HOME_DATA:String = "get_home_data";
      
      public static const GET_MESSAGES:String = "get_messages";
      
      public static const GET_SINGLE_MESSAGE:String = "get_single_message";
      
      public static const GET_LUCK_ROUND:String = "getLuckRound";
      
      public static const ADD_MEXXAGE:String = "add_message";
      
      public static const VISIT_FRIEND:String = "visit_friend";
      
      public static const LOG_NEWS:String = "logNews";
      
      public static const GAIN_PREMIUM:String = "gain_premium";
      
      public static const GET_SIGN_INFO:String = "getSignInfo";
      
      public static const GET_RESIGN_INFO:String = "getReSignInfo";
      
      public static const GET_SIGN_GIFT:String = "getSignGift";
      
      public static const GET_SIGN_REWARDS:String = "getSignRewards";
      
      public static const ATTENDANCEREGISTER:String = "AttendanceRegister";
      
      public static const SAVESUITID:String = "saveSuitId";
      
      public static const SAVEATTENDANCEREGISTER:String = "saveAttendanceRegister";
      
      public static const GETCHESTINFO:String = "getchestinfo";
      
      public static const CDKEYCALLBACK:String = "CDKEYCALLBACK";
      
      public static const DAYLEVEL_RANK:String = "DAYLEVEL_RANK";
      
      public static const WEEKLEVEL_RANK:String = "WEEKLEVEL_RANK";
      
      public static const DAYFIGHT_RANK:String = "DAYFIGHT_RANK";
      
      public static const WEEKFIGHT_RANK:String = "WEEKFIGHT_RANK";
      
      public static const GET_DUPLICATE_SERVER:String = "getDuplicateServer";
      
      public static const GET_CHAT_SERVERID:String = "getChatServerID";
      
      public static const GET_DUPLICATE_ROOMLIST:String = "getDuplicateRoomList";
      
      public static const GET_FIGHT_ROOMLIST:String = "GET_FIGHT_ROOMLIST";
      
      public static const GAME_FRIENDS_GETFRIENDUPGRADEPIRZE:String = "GAME_FRIENDS_GETFRIENDUPGRADEPIRZE";
      
      public static const GET_TENCENT_BALANCE:String = "GET_TENCENT_BALANCE";
      
      public static const GET_TENCENT_BUY:String = "GET_TENCENT_BUY";
      
      public static const BUY_GROUP:String = "buyGroups";
      
      public static const GETMATCH:String = "getMatch";
      
      public static const APPLICATIONFEE:String = "APPLICATIONFEE";
      
      public static const JUMPJIN:String = "JUMPJIN";
      
      public static const GET_FRIEND_COUNT:String = "getFriendCount";
      
      public static const GET_VIP_DAILY_GIFT:String = "GET_VIP_DAILY_GIFT";
      
      public static const GET_VIP_UPLEVEL_PRIZE:String = "GET_VIP_UPLEVEL_PRIZE";
      
      public static const GET_COPYS_ENERGY:String = "GET_COPYS_ENERGY";
      
      public static const WARRANTPRICE:String = "WarrantPrice";
      
      public static const IS_ALLOW_TO_ENTER_COPY:String = "IS_ALLOW_TO_ENTER_COPY";
      
      public static const GETMAILNUM:String = "getMailNum";
      
      public static const MEMHELPER:String = "getMemHelper";
      
      public static const GET_UNION_MESSAGE_LIST:String = "getUnionMessageList";
      
      public static const LEAVE_UNION_MESSAGE_DONE:String = "leaveUnionMessageDone";
      
      public static const GET_WORSHIP_INFO_DONE:String = "getWorshipInfoDone";
      
      public static const UNION_NAME_ISOK:String = "unionNameIsOK";
      
      public static const CREATE_UNION:String = "createUnion";
      
      public static const ISHAVE_UNION:String = "isHaveUnion";
      
      public static const GET_UNION_LIST:String = "getUnionList";
      
      public static const APPLY_TO_UNION:String = "applyToUnion";
      
      public static const GET_APPLYUNION_INFO:String = "getApplyUnionInfo";
      
      public static const CANCEL_APPLY_UNION:String = "cancelApplyUnion";
      
      public static const INVITE_PLAYER_TO_UNION:String = "invitePlayerToUnion";
      
      public static const DEALINVITE:String = "dealInvite";
      
      public static const EDIT_UNION_NOTICE:String = "editUnionNotice";
      
      public static const GET_UNION_NOTICE:String = "getUnionNotice";
      
      public static const ENDOW_UNION:String = "endowUnion";
      
      public static const GET_UUNION_MEMBER:String = "getUnionMember";
      
      public static const EDIT_UNION_POSITION_NAME:String = "editUnionPositionName";
      
      public static const GET_NOUNION_PLAYERS:String = "getNoUnionPlayers";
      
      public static const DEAL_UNION_APPLY:String = "dealUnionApply";
      
      public static const MANAGE_UNIONMEMBER:String = "manageUnionMember";
      
      public static const COMBINE_UNIONPROP:String = "combineUnionProp";
      
      public static const UPUNION_LEVEL:String = "upUnionLevel";
      
      public static const UNION_THINGS_NOTE:String = "unionThingsNote";
      
      public static const EDIT_UNION_CDESC:String = "editUnionCdes";
      
      public static const EDIT_UNION_LIMIT:String = "editUnionLimit";
      
      public static const UNION_BUILD_RANK:String = "unionBuildRank";
      
      public static const UNION_HONOR_RANK:String = "unionHonorRank";
      
      public static const CHANGE_UNION_NAME:String = "changeUnionName";
      
      public static const GET_MOON_BOX:String = "getMoonBox";
      
      public static const ADDAUGOOD:String = "addAuGood";
      
      public static const GETAUINFOS:String = "getMemAucteInfos";
      
      public static const GETAUTYPEINFOS:String = "getaucteProps";
      
      public static const GETAUBidINFOS:String = "getMemBidInfos";
      
      public static const ADDAUPRICE:String = "addAuctePrice";
      
      public static const BUTTHROUGH:String = "buyThrough";
      
      public static const BOYAA2AU:String = "boyaa2auctecoin";
      
      public static const CANCELAU:String = "canceAucte";
      
      public static const REFRESHAUCTION:String = "REFRESHAUCTION";
      
      public static const SET_PASSWORD:String = "SET_PASSWORD";
      
      public static const CHECK_PASSWORD:String = "CHECK_PASSWORD";
      
      public static const RESET_PASSWORD:String = "RESET_PASSWORD";
      
      public static const CHECK_ANSWER:String = "CHECK_ANSWER";
      
      public static const REPICK_PASSWORD:String = "REPICK_PASSWORD";
      
      public static const GET_PWD_QUESTION:String = "GET_PWD_QUESTION";
      
      public static const ACTIVITIESREWARD:String = "activitiesReward";
      
      public static const BUY_GROUPBUYING_GOOD:String = "BUY_GROUPBUYING_GOOD";
      
      public static const BUY_GROUPBUYING_IPAD:String = "BUY_GROUPBUYING_IPAD";
      
      public static const GETFLOWER:String = "GETFLOWER";
      
      public static const GETMINVITENUM:String = "GETMINVITENUM";
      
      public static const GETMOTERDAILY:String = "GETMOTERDAILY";
      
      public static const GET_WEEKLY_MATCH:String = "GET_WEEKLY_MATCH";
      
      public static const ENTER_WEEKLY_MATCH_ROOM:String = "ENTER_WEEKLY_MATCH_ROOM";
      
      public static const CHONGBANG:String = "CHONGBANG";
      
      public static const GROUPBUY:String = "GROUPBUY";
      
      public static const GETGROUPBUY:String = "GETGROUPBUY";
      
      public static const GETMEMBODY:String = "getMemBody";
      
      public static const GET_HALLOWMAS_BOX:String = "getHallowmasBox";
      
      public static const USE_NOVICECARD:String = "useNoviceCard";
      
      public static const USE_CONSORTIONCARD:String = "useConsortionCard";
      
      public static const SELF_DEVOTEDETAIL:String = "selfDevoteDetail";
      
      public static const USEGAOPENGCARDCOMLETE:String = "USEGAOPENGCARDCOMLETE";
      
      public static const CONNETIMCOMPLETE:String = "CONNETIMCOMPLETE";
      
      public static const NEWYEAR:String = "NEWYEAR";
      
      public static const NEWYEARFIRST:String = "NEWYEARFIRST";
      
      public static const GETNEWYEARFIRST:String = "getNewYearGift";
      
      public static const VALENTINE:String = "VALENTINE";
      
      public static const GET_VALENTINE_BOX:String = "GET_VALENTINE_BOX";
      
      public static const GET_FREE_SEND:String = "GET_FREE_SEND";
      
      public static const GET_ROSE:String = "GET_ROSE";
      
      public static const openFreshPack:String = "openFreshPack";
      
      public static const getFirends:String = "getFirends";
      
      public static const addFriend:String = "addFriend";
      
      public static const deleteFriend:String = "deleteFriend";
      
      public static const getMemStatus:String = "getMemStatus";
      
      public static const getCopyGrade:String = "getCopyGrade";
      
      public static const buyBTProp:String = "buyBTProp";
      
      public static const getMobileCopyPrize:String = "getMobileCopyPrize";
      
      public static const backBTProp:String = "backBTProp";
      
      public static const useBTProp:String = "useBTProp";
      
      public static const getNewWeapon:String = "getNewWeapon";
      
      public static const mobileUpdate:String = "mobileUpdate";
      
      public static const getAccount:String = "getAccount";
      
      public static const suggestion:String = "suggestion";
      
      public static const apkPromo:String = "apkPromo";
      
      public static const indulgeCheck:String = "indulgeCheck";
      
      public static const getIndulgeInfo:String = "getIndulgeInfo";
      
      public static const getNotice:String = "getNotice";
      
      public static const getMissionStatus:String = "getMissionStatus";
      
      public static const WORSHIP_DONE:String = "worshipDone";
      
      public static const GET_WORSHIP_DONE:String = "getWorshipDone";
      
      public static const FEED_BACK_TO_PHP:String = "feedbacktophp";
      
      public static const PLAYER_WEAPON_STATE:String = "playerWeaponState";
      
      public static const CHANGE_WEAPON_IN_BOX:String = "changeWeaponInBox";
      
      public static const CHANGE_WEAPON_IN_BATTLE:String = "changeWeaponInBattle";
      
      public static const FACEBOOK_IMG_URL:String = "facebookImgUrl";
      
      private var _param:Object = null;
      
      public function PHPEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         _param = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new PHPEvent(type,param,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("PHPEvent","param","type","bubbles","cancelable","eventPhase");
      }
      
      public function get param() : Object
      {
         return _param;
      }
   }
}

