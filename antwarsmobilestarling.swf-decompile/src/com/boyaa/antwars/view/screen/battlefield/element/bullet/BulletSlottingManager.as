package com.boyaa.antwars.view.screen.battlefield.element.bullet
{
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   
   public class BulletSlottingManager
   {
      
      private static var _instance:BulletSlottingManager = null;
      
      private var _shootStart:Signal;
      
      private var _bulletDataArr:Array = [];
      
      public function BulletSlottingManager()
      {
         super();
         init();
      }
      
      public static function get instance() : BulletSlottingManager
      {
         if(_instance == null)
         {
            _instance = new BulletSlottingManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         _shootStart = new Signal(Object);
      }
      
      public function addBulletData(param1:Array, param2:int) : void
      {
         Application.instance.log("TAG-addBulletData",JSON.stringify(param1) + " site:" + param2);
         if(_bulletDataArr[param2] == null)
         {
            _bulletDataArr[param2] = new Dictionary();
         }
         _bulletDataArr[param2][param1[2]] = param1;
         beginShoot(null);
      }
      
      public function getBulletData(param1:int, param2:int) : Array
      {
         if(_bulletDataArr[param2] != null)
         {
            return _bulletDataArr[param2][param1];
         }
         return null;
      }
      
      public function clearBulletData(param1:int) : void
      {
         _bulletDataArr[param1] = [];
      }
      
      public function clear() : void
      {
         _bulletDataArr = [];
      }
      
      public function beginShoot(param1:Object) : void
      {
         _shootStart.dispatch(param1);
      }
      
      public function get shootStartSignal() : Signal
      {
         return _shootStart;
      }
   }
}

