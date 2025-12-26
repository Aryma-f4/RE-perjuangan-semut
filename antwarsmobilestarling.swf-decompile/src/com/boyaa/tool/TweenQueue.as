package com.boyaa.tool
{
   import starling.animation.Tween;
   import starling.core.Starling;
   
   public class TweenQueue
   {
      
      private var _tweenList:Array = null;
      
      private var _index:int = 0;
      
      public var repeatCount:int = 1;
      
      private var _curr_tween:Tween = null;
      
      public function TweenQueue()
      {
         super();
         _tweenList = [];
      }
      
      private function creatTween(param1:Array) : Tween
      {
         var _loc3_:Object = null;
         var _loc2_:Tween = new Tween(param1[0],param1[1],param1[3]);
         _loc2_.onComplete = tweenOnComplete;
         var _loc5_:Object = param1[2];
         for(var _loc4_ in _loc5_)
         {
            _loc3_ = _loc5_[_loc4_];
            if(_loc2_.hasOwnProperty(_loc4_))
            {
               _loc2_[_loc4_] = _loc3_;
            }
            else
            {
               if(!param1[0].hasOwnProperty(_loc4_))
               {
                  throw new ArgumentError("Invalid property: " + _loc4_);
               }
               _loc2_.animate(_loc4_,_loc3_ as Number);
            }
         }
         return _loc2_;
      }
      
      public function add(param1:Object, param2:Number, param3:Object, param4:Object = "linear") : void
      {
         _tweenList.push([param1,param2,param3,param4]);
      }
      
      private function tweenOnComplete() : void
      {
         _index = _index + 1;
         if(_index >= _tweenList.length)
         {
            if(repeatCount == 0)
            {
               _index = 0;
            }
            else
            {
               if(repeatCount == 1)
               {
                  stop();
                  return;
               }
               repeatCount = repeatCount - 1;
               _index = 0;
            }
         }
         _curr_tween = creatTween(_tweenList[_index]);
         Starling.juggler.add(_curr_tween);
      }
      
      public function start() : void
      {
         _curr_tween = creatTween(_tweenList[_index]);
         Starling.juggler.add(_curr_tween);
      }
      
      public function stop() : void
      {
         if(_curr_tween)
         {
            Starling.juggler.remove(_curr_tween);
         }
         _curr_tween = null;
      }
      
      public function dispose() : void
      {
         stop();
         _tweenList = [];
      }
   }
}

