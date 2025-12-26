package com.boyaa.antwars.data
{
   import com.boyaa.antwars.data.model.ExchangeNeedItem;
   import com.boyaa.antwars.data.model.ExchangePropItem;
   
   public class ExchangeList
   {
      
      private static var _instance:ExchangeList = null;
      
      private var _propItems:Array = null;
      
      private var _needItems:Array = null;
      
      public function ExchangeList(param1:Single)
      {
         super();
         _propItems = [];
         _needItems = [];
      }
      
      public static function get instance() : ExchangeList
      {
         if(_instance == null)
         {
            _instance = new ExchangeList(new Single());
         }
         return _instance;
      }
      
      public function setPropItems(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc3_:ExchangePropItem = null;
         _propItems = [];
         var _loc2_:int = int(param1.prop.length());
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new ExchangePropItem();
            _loc3_.setPropItem(param1.prop[_loc4_]);
            _propItems.push(_loc3_);
            _loc4_++;
         }
      }
      
      public function setNeedItems(param1:XML) : void
      {
         var _loc4_:int = 0;
         var _loc2_:ExchangeNeedItem = null;
         _needItems = [];
         var _loc3_:int = int(param1.need.length());
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ExchangeNeedItem();
            _loc2_.setNeedItem(param1.need[_loc4_]);
            _needItems.push(_loc2_);
            _loc4_++;
         }
      }
      
      public function getPropItems() : Array
      {
         return _propItems;
      }
      
      public function getNeedItemsByPropid(param1:int) : Array
      {
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < _needItems.length)
         {
            if((_needItems[_loc3_] as ExchangeNeedItem).propid == param1)
            {
               _loc2_.push(_needItems[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
