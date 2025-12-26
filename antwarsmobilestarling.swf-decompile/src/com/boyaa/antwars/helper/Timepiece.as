package com.boyaa.antwars.helper
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class Timepiece
   {
      
      public static const FRAME:int = 0;
      
      public static const TIMER:int = 1;
      
      public static const DELAY:int = 2;
      
      private static var _instance:Timepiece = null;
      
      private var _currentTime:uint = 0;
      
      private var _callBack:Function = null;
      
      private var _speed:uint = 0;
      
      private var _frameFun:Array = null;
      
      private var _timerFun:Array = null;
      
      private var _delayFun:Array = null;
      
      private var _running:Boolean = false;
      
      private var _stage:Stage = null;
      
      private var _lasttime:int = 0;
      
      public function Timepiece(param1:Single)
      {
         super();
         _frameFun = [];
         _timerFun = [];
         _delayFun = [];
      }
      
      public static function get instance() : Timepiece
      {
         if(_instance == null)
         {
            _instance = new Timepiece(new Single());
         }
         return _instance;
      }
      
      public function initStage(param1:Stage) : void
      {
         _stage = param1;
      }
      
      public function addFun(param1:Function) : void
      {
         _frameFun.push(param1);
         if(!_running)
         {
            start();
         }
      }
      
      public function addTimerFun(param1:Function, param2:uint) : void
      {
         _timerFun.push([param1,param2,getTimer()]);
         if(!_running)
         {
            start();
         }
      }
      
      public function addDelayCall(param1:Function, param2:uint) : void
      {
         _delayFun.push([param1,param2,getTimer()]);
         if(!_running)
         {
            start();
         }
      }
      
      public function hasFunction(param1:Function, param2:uint) : Boolean
      {
         var _loc5_:int = 0;
         var _loc4_:Array = [_frameFun,_timerFun,_delayFun];
         var _loc3_:Array = _loc4_[param2];
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc5_][0])
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function removeFun(param1:Function, param2:int = 0) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2 == 0)
         {
            _loc5_ = 0;
            while(_loc5_ < _frameFun.length)
            {
               if(_frameFun[_loc5_] == param1)
               {
                  _frameFun.splice(_loc5_,1);
                  break;
               }
               _loc5_++;
            }
         }
         else if(param2 == 1)
         {
            _loc3_ = 0;
            while(_loc3_ < _timerFun.length)
            {
               if(_timerFun[_loc3_][0] == param1)
               {
                  _timerFun.splice(_loc3_,1);
                  break;
               }
               _loc3_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _delayFun.length)
            {
               if(_delayFun[_loc4_][0] == param1)
               {
                  _delayFun.splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
         }
         if(_timerFun.length == 0 && _frameFun.length == 0 && _delayFun.length == 0)
         {
            stop();
         }
      }
      
      private function start() : void
      {
         _running = true;
         _stage.addEventListener("enterFrame",timerHandler,false,0,true);
         _lasttime = getTimer();
      }
      
      private function stop() : void
      {
         _running = false;
         _stage.removeEventListener("enterFrame",timerHandler,false);
      }
      
      private function runFrameFun() : void
      {
         var _loc3_:Function = null;
         var _loc2_:Array = _frameFun.concat();
         var _loc1_:int = int(_frameFun.length);
         var _loc4_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_ != null)
            {
               _loc3_();
            }
            _loc4_++;
         }
      }
      
      private function timerHandler(param1:Event) : void
      {
         var _loc3_:Array = null;
         var _loc6_:Function = null;
         var _loc8_:Array = null;
         var _loc4_:Function = null;
         var _loc5_:int = 0;
         var _loc7_:Array = [];
         var _loc9_:int = 0;
         var _loc2_:int = getTimer();
         _loc5_ = (_loc2_ - _lasttime) / 30;
         _lasttime = _loc2_;
         _loc5_ = int(_loc5_ == 0 ? 1 : _loc5_);
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            runFrameFun();
            _loc9_++;
         }
         _loc5_ = int(_timerFun.length);
         _loc7_ = _timerFun.concat();
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc3_ = _loc7_[_loc9_];
            _loc6_ = _loc3_[0];
            if(_loc6_ != null)
            {
               if(_loc2_ - _loc3_[2] >= _loc3_[1])
               {
                  var _loc10_:int = 2;
                  var _loc11_:* = _loc3_[_loc10_] + _loc3_[1];
                  _loc3_[_loc10_] = _loc11_;
                  _loc6_();
               }
            }
            _loc9_++;
         }
         _loc5_ = int(_delayFun.length);
         _loc9_ = 0;
         while(_loc9_ < _loc5_)
         {
            _loc8_ = _delayFun[_loc9_];
            if(_loc8_ != null)
            {
               _loc4_ = _loc8_[0];
               if(_loc4_ != null)
               {
                  if(_loc2_ - _loc8_[2] >= _loc8_[1])
                  {
                     _delayFun.splice(_loc9_,1);
                     _loc9_--;
                     _loc5_--;
                     _loc4_();
                  }
               }
            }
            _loc9_++;
         }
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
