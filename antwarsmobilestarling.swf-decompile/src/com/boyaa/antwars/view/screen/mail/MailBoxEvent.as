package com.boyaa.antwars.view.screen.mail
{
   import flash.events.Event;
   
   public class MailBoxEvent extends Event
   {
      
      public static var MAIL_SELECT_EVENT:String = "MailBoxEvent:MAIL_SELECT_EVENT";
      
      public static var MAIL_GOBACK_LIST_EVENT:String = "MailBoxEvent:MAIL_GOBACK_LIST_EVENT";
      
      public static var MAIL_LIST_ALL_SELECT:String = "MailBoxEvent:MAIL_LIST_ALL_SELECT";
      
      public static var MAIL_LIST_ITEM_SELECT:String = "MailBoxEvent:MAIL_LIST_ITEM_SELECT";
      
      public static var MAIL_LIST_ITEM_SELECT_ICON_CLICK:String = "MailBoxEvent:MAIL_LIST_ITEM_SELECT_ICON_CLICK";
      
      public static var MAIL_LIST_FILE_ONE_KEY:String = "MailBoxEvent:MAIL_LIST_FILE_ONE_KEY";
      
      public static var MAIL_BAG_LIST_SELECT:String = "MailBoxEvent:MAIL_BAG_LIST_SELECT";
      
      public static var MAIL_FILE_LIST_ITEM_CLICK:String = "MailBoxEvent:MAIL_FILE_LIST_ITEM_CLICK";
      
      public static var MAIL_FRIEND_CLICK:String = "MailBoxEvent:MAIL_FRIEND_CLICK";
      
      public static var MAIL_FILE_ITEM_SELECT_DONE:String = "MailBoxEvent:MAIL_FILE_ITEM_SELECT_DONE";
      
      private var _data:Object;
      
      public function MailBoxEvent(param1:String, param2:Object = null)
      {
         _data = param2;
         super(param1,false,false);
      }
      
      public function get data() : Object
      {
         return _data;
      }
   }
}

