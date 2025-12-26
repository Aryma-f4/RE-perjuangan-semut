package com.boyaa.antwars.events
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const SLOTTING:String = "slotting";
      
      public static const SHOOTCOMPLETE:String = "shootComplete";
      
      public static const RECEIVECHAT:String = "receiveChat";
      
      public static const EXPRESSION:String = "expression";
      
      public static const MIDWAYLEAVE:String = "MidwayLeave";
      
      public static const LOADMAPCOMPLETE:String = "LOADMAPCOMPLETE";
      
      public static const SENDSYSTEMINFO:String = "SENDSYSTEMINFO";
      
      public static const SHOW_CHATTOFRIEND:String = "showChatToFriend";
      
      public static const CHATTOFRIEND_FAIL:String = "chatToFriendFail";
      
      public static const SHOW_LOUDSPEAKER:String = "showLoudSpeaker";
      
      public static const SHOW_UNION_TALK:String = "showUnionTalk";
      
      public static const SHOPBUY:String = "shopBuy";
      
      public static const ADDWISH:String = "ADDWISH";
      
      public static const ClOSESTRFEEDDLG:String = "ClOSESTRFEEDDLG";
      
      public static const CHATTOFRIEND:String = "chatToFriend";
      
      public static const FRIEND_OFFLINE:String = "friendOffLine";
      
      public static const CLOSE_CHATLIST:String = "closeChatList";
      
      public static const CLOSE_FASTTALK:String = "closeFastTalk";
      
      public static const FASTTALK_INFO:String = "fastTalkInfo";
      
      public static const FAST_TALK:String = "fastTalk";
      
      public static const DELETE_FASTTALK:String = "deleteFastTalk";
      
      public static const SYSTEM_INFO:String = "systemInfo";
      
      public static const NETWORKCONNECTFAIL:String = "NETWORKCONNECTFAIL";
      
      public static const NETWORKTESTCONPLETE:String = "NETWORKTESTCONPLETE";
      
      public static const AUCTIONITEMCLICK:String = "AUCTIONITEMCLICK";
      
      public static const CHANGECHATCHANNEL:String = "changechatchannel";
      
      public static const FILTER_CHAT:String = "filterChat";
      
      public static const USE_SKILL:String = "useSKill";
      
      public static const USE_SKILL_COMPLETE:String = "useSkillComplete";
      
      public static const CHANGE_WEAPON:String = "changeWeapon";
      
      public static const CHANGE_WEAPON_COMPLTE:String = "changeWeaponComplete";
      
      public static const USE_PROP_COMPLETE:String = "usePropComplete";
      
      public static const FRESH_GAME:String = "freshGame";
      
      public static const FRESH_GUIDE_COMPLETE:String = "freshGuideComplete";
      
      public static const MOVE_CONTROL:String = "moveControl";
      
      public static const JOIN_BATTLE_ROOM:String = "joinBattleRoom";
      
      public static const SEARCH_BT_ROOM:String = "searchBtRoom";
      
      public static const INPUT_PASSWORD:String = "inputPassword";
      
      public static const MENU_BUTTON_TOUCH:String = "menuButtonTouch";
      
      private var _param:Object = null;
      
      public function GameEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         _param = param2;
         super(param1,param3,param4);
      }
      
      override public function clone() : Event
      {
         return new GameEvent(type,param,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("GameEvent","param","type","bubbles","cancelable","eventPhase");
      }
      
      public function get param() : Object
      {
         return _param;
      }
   }
}

