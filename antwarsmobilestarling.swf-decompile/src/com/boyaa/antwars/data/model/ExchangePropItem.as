package com.boyaa.antwars.data.model
{
   public class ExchangePropItem
   {
      
      public var propid:int = 0;
      
      public var pcate:int = 0;
      
      public var pframe:int = 0;
      
      public var isbind:int = 0;
      
      public var quantity:int = 0;
      
      public var validperiod:int = 0;
      
      public var mpaddvalue:String = "";
      
      public function ExchangePropItem()
      {
         super();
      }
      
      public function setPropItem(param1:XML) : void
      {
         propid = int(param1["propid"]);
         pcate = int(param1["pcate"]);
         pframe = int(param1["pframe"]);
         isbind = int(param1["isbind"]);
         quantity = int(param1["quantity"]);
         validperiod = int(param1["validperiod"]);
         mpaddvalue = param1["mpaddvalue"];
      }
   }
}

