package org.gestouch.core
{
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   use namespace gestouch_internal;
   
   public class TouchesManager
   {
      
      protected var _gesturesManager:GesturesManager;
      
      protected var _touchesMap:Object = {};
      
      protected var _hitTesters:Vector.<ITouchHitTester> = new Vector.<ITouchHitTester>();
      
      protected var _hitTesterPrioritiesMap:Dictionary = new Dictionary(true);
      
      protected var _activeTouchesCount:uint;
      
      public function TouchesManager(param1:GesturesManager)
      {
         super();
         _gesturesManager = param1;
      }
      
      public function get activeTouchesCount() : uint
      {
         return _activeTouchesCount;
      }
      
      public function getTouches(param1:Object = null) : Array
      {
         var _loc4_:* = 0;
         var _loc3_:Array = [];
         if(!param1 || param1 is Stage)
         {
            _loc4_ = 0;
            for each(var _loc2_ in _touchesMap)
            {
               _loc3_[_loc4_++] = _loc2_;
            }
         }
         return _loc3_;
      }
      
      gestouch_internal function addTouchHitTester(param1:ITouchHitTester, param2:int = 0) : void
      {
         if(!param1)
         {
            throw new ArgumentError("Argument must be non null.");
         }
         if(_hitTesters.indexOf(param1) == -1)
         {
            _hitTesters.push(param1);
         }
         _hitTesterPrioritiesMap[param1] = param2;
         _hitTesters.sort(hitTestersSorter);
      }
      
      gestouch_internal function removeInputAdapter(param1:ITouchHitTester) : void
      {
         if(!param1)
         {
            throw new ArgumentError("Argument must be non null.");
         }
         var _loc2_:int = int(_hitTesters.indexOf(param1));
         if(_loc2_ == -1)
         {
            throw new Error("This touchHitTester is not registered.");
         }
         _hitTesters.splice(_loc2_,1);
         delete _hitTesterPrioritiesMap[param1];
      }
      
      gestouch_internal function onTouchBegin(param1:uint, param2:Number, param3:Number, param4:InteractiveObject = null) : Boolean
      {
         var _loc9_:Object = null;
         var _loc5_:* = null;
         if(param1 in _touchesMap)
         {
            return false;
         }
         var _loc7_:Point = new Point(param2,param3);
         for each(var _loc8_ in _touchesMap)
         {
            if(Point.distance(_loc8_.location,_loc7_) < 2)
            {
               return false;
            }
         }
         var _loc6_:Touch = createTouch();
         _loc6_.id = param1;
         for each(var _loc10_ in _hitTesters)
         {
            _loc9_ = _loc10_.hitTest(_loc7_,param4);
            if(_loc9_)
            {
               if(!(_loc9_ is Stage))
               {
                  break;
               }
               _loc5_ = _loc9_;
            }
         }
         if(!_loc9_ && !_loc5_)
         {
            throw new Error("Not touch target found (hit test).Something is wrong, at least flash.display::Stage should be found.See Gestouch#addTouchHitTester() and Gestouch#inputAdapter.");
         }
         _loc6_.target = _loc9_ || _loc5_;
         _loc6_.gestouch_internal::setLocation(param2,param3,getTimer());
         _touchesMap[param1] = _loc6_;
         _activeTouchesCount = _activeTouchesCount + 1;
         _gesturesManager.gestouch_internal::onTouchBegin(_loc6_);
         return true;
      }
      
      gestouch_internal function onTouchMove(param1:uint, param2:Number, param3:Number) : void
      {
         var _loc4_:Touch = _touchesMap[param1] as Touch;
         if(!_loc4_)
         {
            return;
         }
         _loc4_.gestouch_internal::updateLocation(param2,param3,getTimer());
         _gesturesManager.gestouch_internal::onTouchMove(_loc4_);
      }
      
      gestouch_internal function onTouchEnd(param1:uint, param2:Number, param3:Number) : void
      {
         var _loc4_:Touch = _touchesMap[param1] as Touch;
         if(!_loc4_)
         {
            return;
         }
         _loc4_.gestouch_internal::updateLocation(param2,param3,getTimer());
         delete _touchesMap[param1];
         _activeTouchesCount = _activeTouchesCount - 1;
         _gesturesManager.gestouch_internal::onTouchEnd(_loc4_);
         _loc4_.target = null;
      }
      
      gestouch_internal function onTouchCancel(param1:uint, param2:Number, param3:Number) : void
      {
         var _loc4_:Touch = _touchesMap[param1] as Touch;
         if(!_loc4_)
         {
            return;
         }
         _loc4_.gestouch_internal::updateLocation(param2,param3,getTimer());
         delete _touchesMap[param1];
         _activeTouchesCount = _activeTouchesCount - 1;
         _gesturesManager.gestouch_internal::onTouchCancel(_loc4_);
         _loc4_.target = null;
      }
      
      protected function createTouch() : Touch
      {
         return new Touch();
      }
      
      protected function hitTestersSorter(param1:ITouchHitTester, param2:ITouchHitTester) : Number
      {
         var _loc3_:int = int(_hitTesterPrioritiesMap[param1]) - int(_hitTesterPrioritiesMap[param2]);
         if(_loc3_ > 0)
         {
            return -1;
         }
         if(_loc3_ < 0)
         {
            return 1;
         }
         return _hitTesters.indexOf(param1) > _hitTesters.indexOf(param2) ? 1 : -1;
      }
   }
}

