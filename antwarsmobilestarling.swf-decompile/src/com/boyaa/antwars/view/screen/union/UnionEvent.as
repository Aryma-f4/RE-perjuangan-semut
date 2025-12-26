package com.boyaa.antwars.view.screen.union
{
   import starling.events.Event;
   
   public class UnionEvent extends Event
   {
      
      public static var UNION_CREATE_DONE:String = "UnionEvent::UNION_CREATE_DONE";
      
      public static var UNION_LIST_APPLY_UNION:String = "UnionEvent::UNION_LIST_APPLY_UNION";
      
      public static var UNION_MANAGER_APPLY_ITEM_SELECT:String = "UnionEvent::UNION_MANAGER_APPLY_ITEM_SELECT";
      
      public static var UNION_MANAGER_APPLY_TOP_SELECT:String = "UnionEvent::UNION_MANAGER_APPLY_TOP_SELECT";
      
      public static var UNION_DATA_REFRESH:String = "UnionEvent::UNION_DATA_REFRESH";
      
      public static const UNION_MANAGER_INVITE_ITEM_SELECT:String = "unionManagerInviteItemSelect";
      
      public static const UNION_MANAGER_INVITE_TOP_SELECT:String = "unionManagerInviteTopSelect";
      
      public static const UNION_BUY_ITEM:String = "unionBuyDone";
      
      public static const WORSHIP_THIS_BODY:String = "worshipThisBody";
      
      public static var UNION_VIEW_CHANGE:String = "UnionEvent::UNION_VIEW_CHANGE";
      
      public static var GOTO_HALL:String = "UnionEvent::goto_hall";
      
      public static var PRIVATE_CHAT:String = "UnionEvent::PRIVATE_CHAT";
      
      public static var STEPDOWN_ITEM_RENDER_CLEAR:String = "UnionEvent::STEPDOWN_ITEM_RENDER_CLEAR";
      
      public static var STEPDOWN_ITEM_RENDER_SELECT:String = "UnionEvent::STEPDOWN_ITEM_RENDER_SELECT";
      
      private var _eventData:Object;
      
      public function UnionEvent(param1:String, param2:Object = null)
      {
         _eventData = param2;
         super(param1,false,null);
      }
      
      public function get eventData() : Object
      {
         return _eventData;
      }
   }
}

