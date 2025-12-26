package dragonBones.animation
{
   import flash.utils.getTimer;
   
   public final class WorldClock implements IAnimatable
   {
      
      public static var clock:WorldClock = new WorldClock();
      
      private var animatableList:Vector.<IAnimatable>;
      
      private var _time:Number;
      
      private var _timeScale:Number = 1;
      
      public function WorldClock()
      {
         super();
         _time = getTimer() * 0.001;
         animatableList = new Vector.<IAnimatable>();
      }
      
      public function get time() : Number
      {
         return _time;
      }
      
      public function get timeScale() : Number
      {
         return _timeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         if(param1 < 0 || isNaN(param1))
         {
            param1 = 0;
         }
         _timeScale = param1;
      }
      
      public function contains(param1:IAnimatable) : Boolean
      {
         return animatableList.indexOf(param1) >= 0;
      }
      
      public function add(param1:IAnimatable) : void
      {
         if(param1 && animatableList.indexOf(param1) == -1)
         {
            animatableList.push(param1);
         }
      }
      
      public function remove(param1:IAnimatable) : void
      {
         var _loc2_:int = int(animatableList.indexOf(param1));
         if(_loc2_ >= 0)
         {
            animatableList[_loc2_] = null;
         }
      }
      
      public function clear() : void
      {
         animatableList.length = 0;
      }
      
      public function advanceTime(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc6_:int = 0;
         var _loc4_:IAnimatable = null;
         if(param1 < 0)
         {
            _loc2_ = getTimer() * 0.001;
            param1 = _loc2_ - _time;
            _time = _loc2_;
         }
         param1 *= _timeScale;
         var _loc5_:int = int(animatableList.length);
         if(_loc5_ == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ = animatableList[_loc6_];
            if(_loc4_)
            {
               if(_loc3_ != _loc6_)
               {
                  animatableList[_loc3_] = _loc4_;
                  animatableList[_loc6_] = null;
               }
               _loc4_.advanceTime(param1);
               _loc3_++;
            }
            _loc6_++;
         }
         if(_loc3_ != _loc6_)
         {
            _loc5_ = int(animatableList.length);
            while(_loc6_ < _loc5_)
            {
               animatableList[_loc3_++] = animatableList[_loc6_++];
            }
            animatableList.length = _loc3_;
         }
      }
   }
}

