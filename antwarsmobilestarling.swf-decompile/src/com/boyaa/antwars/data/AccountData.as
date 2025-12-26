package com.boyaa.antwars.data
{
   import org.osflash.signals.Signal;
   
   public class AccountData
   {
      
      private static var _instance:AccountData = null;
      
      private var _gameGold:uint = 0;
      
      private var _boyaaCoin:uint = 0;
      
      public var freeCoin:uint = 0;
      
      public var aucteCoin:uint = 0;
      
      public var updateSignal:Signal;
      
      public function AccountData(param1:Single)
      {
         super();
         updateSignal = new Signal();
      }
      
      public static function get instance() : AccountData
      {
         if(_instance == null)
         {
            _instance = new AccountData(new Single());
         }
         return _instance;
      }
      
      public function updateAccount(param1:Object) : void
      {
         _gameGold = param1.currency;
         _boyaaCoin = param1.boyaacurrency;
         freeCoin = param1.excertificate;
         aucteCoin = param1.auctecoin;
         updateSignal.dispatch();
      }
      
      public function updateAccountAry(param1:Array) : void
      {
         _gameGold = param1[0];
         _boyaaCoin = param1[3];
         freeCoin = param1[2];
         aucteCoin = param1[5];
         updateSignal.dispatch();
      }
      
      public function updateBoyaaCoin(param1:uint) : void
      {
         _boyaaCoin = param1;
         updateSignal.dispatch();
      }
      
      public function set gameGold(param1:uint) : void
      {
         _gameGold = param1;
         updateSignal.dispatch();
      }
      
      public function get gameGold() : uint
      {
         return _gameGold;
      }
      
      public function set boyaaCoin(param1:uint) : void
      {
         _boyaaCoin = param1;
         updateSignal.dispatch();
      }
      
      public function get boyaaCoin() : uint
      {
         return _boyaaCoin;
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
