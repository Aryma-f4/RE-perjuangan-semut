package com.boyaa.antwars.data.model
{
   public class ExchangeNeedItem
   {
      
      public var id:int = 0;
      
      public var propid:int = 0;
      
      public var pcate:int = 0;
      
      public var pframe:int = 0;
      
      public var quantity:int = 0;
      
      public function ExchangeNeedItem()
      {
         super();
      }
      
      public function setNeedItem(param1:XML) : void
      {
         id = int(param1["id"]);
         propid = int(param1["propid"]);
         pcate = int(param1["pcate"]);
         pframe = int(param1["pframe"]);
         quantity = int(param1["quantity"]);
      }
   }
}

