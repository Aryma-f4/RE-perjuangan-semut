package com.boyaa.antwars.data.model.mission
{
   import com.boyaa.antwars.data.model.ShopData;
   
   public class RewardData
   {
      
      private var _pcate:int;
      
      private var _pframe:int;
      
      private var _validperiod:int;
      
      private var _quantity:int;
      
      private var _goodName:String;
      
      private var _mgender:int;
      
      private var _data:ShopData;
      
      public function RewardData()
      {
         super();
      }
      
      public function get pcate() : int
      {
         return _pcate;
      }
      
      public function set pcate(param1:int) : void
      {
         _pcate = param1;
      }
      
      public function get pframe() : int
      {
         return _pframe;
      }
      
      public function set pframe(param1:int) : void
      {
         _pframe = param1;
      }
      
      public function get validperiod() : int
      {
         return _validperiod;
      }
      
      public function set validperiod(param1:int) : void
      {
         _validperiod = param1;
      }
      
      public function get quantity() : int
      {
         return _quantity;
      }
      
      public function set quantity(param1:int) : void
      {
         _quantity = param1;
      }
      
      public function get goodName() : String
      {
         return _goodName;
      }
      
      public function set goodName(param1:String) : void
      {
         _goodName = param1;
      }
      
      public function get data() : ShopData
      {
         return _data;
      }
      
      public function set data(param1:ShopData) : void
      {
         _data = param1;
      }
      
      public function get mgender() : int
      {
         return _mgender;
      }
      
      public function set mgender(param1:int) : void
      {
         _mgender = param1;
      }
   }
}

