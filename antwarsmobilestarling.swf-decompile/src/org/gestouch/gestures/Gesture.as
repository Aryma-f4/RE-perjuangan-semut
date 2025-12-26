package org.gestouch.gestures
{
   import flash.errors.IllegalOperationError;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import org.gestouch.core.Gestouch;
   import org.gestouch.core.GestureState;
   import org.gestouch.core.GesturesManager;
   import org.gestouch.core.IGestureDelegate;
   import org.gestouch.core.IGestureTargetAdapter;
   import org.gestouch.core.Touch;
   import org.gestouch.core.gestouch_internal;
   import org.gestouch.events.GestureEvent;
   
   use namespace gestouch_internal;
   
   public class Gesture extends EventDispatcher
   {
      
      public static var DEFAULT_SLOP:uint = Math.round(0.07936507936507936 * Capabilities.screenDPI);
      
      protected const _gesturesManager:GesturesManager = Gestouch.gesturesManager;
      
      protected var _touchesMap:Object = {};
      
      protected var _centralPoint:Point = new Point();
      
      protected var _gesturesToFail:Dictionary = new Dictionary(true);
      
      protected var _pendingRecognizedState:GestureState;
      
      private var eventListeners:Dictionary = new Dictionary();
      
      protected var _targetAdapter:IGestureTargetAdapter;
      
      protected var _enabled:Boolean = true;
      
      private var _delegateWeekStorage:Dictionary;
      
      protected var _state:GestureState = GestureState.IDLE;
      
      protected var _touchesCount:uint = 0;
      
      protected var _location:Point = new Point();
      
      public function Gesture(param1:Object = null)
      {
         super();
         preinit();
         this.target = param1;
      }
      
      gestouch_internal function get targetAdapter() : IGestureTargetAdapter
      {
         return _targetAdapter;
      }
      
      protected function get targetAdapter() : IGestureTargetAdapter
      {
         return _targetAdapter;
      }
      
      public function get target() : Object
      {
         return _targetAdapter ? _targetAdapter.target : null;
      }
      
      public function set target(param1:Object) : void
      {
         var _loc2_:Object = this.target;
         if(_loc2_ == param1)
         {
            return;
         }
         uninstallTarget(_loc2_);
         _targetAdapter = param1 ? Gestouch.gestouch_internal::createGestureTargetAdapter(param1) : null;
         installTarget(param1);
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(_enabled == param1)
         {
            return;
         }
         _enabled = param1;
         if(!_enabled)
         {
            if(state == GestureState.POSSIBLE)
            {
               setState(GestureState.FAILED);
            }
            else if(state == GestureState.BEGAN || state == GestureState.CHANGED)
            {
               setState(GestureState.CANCELLED);
            }
         }
      }
      
      public function get delegate() : IGestureDelegate
      {
         var _loc3_:int = 0;
         var _loc2_:Dictionary = _delegateWeekStorage;
         for(var _loc1_ in _loc2_)
         {
            return _loc1_ as IGestureDelegate;
         }
         return null;
      }
      
      public function set delegate(param1:IGestureDelegate) : void
      {
         for(var _loc2_ in _delegateWeekStorage)
         {
            delete _delegateWeekStorage[_loc2_];
         }
         if(param1)
         {
            (_delegateWeekStorage || (_delegateWeekStorage = new Dictionary(true)))[param1] = true;
         }
      }
      
      public function get state() : GestureState
      {
         return _state;
      }
      
      public function get touchesCount() : uint
      {
         return _touchesCount;
      }
      
      public function get location() : Point
      {
         return _location.clone();
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         var _loc6_:Array = eventListeners[param2] as Array;
         if(_loc6_)
         {
            _loc6_.push(param1,param3);
         }
         else
         {
            eventListeners[param2] = [param1,param3];
         }
      }
      
      public function removeAllEventListeners() : void
      {
         var _loc4_:Array = null;
         var _loc1_:* = 0;
         var _loc3_:* = 0;
         for(var _loc2_ in eventListeners)
         {
            _loc4_ = eventListeners[_loc2_] as Array;
            _loc1_ = _loc4_.length;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               super.removeEventListener(_loc4_[_loc3_++] as String,_loc2_ as Function,_loc4_[_loc3_++] as Boolean);
            }
            delete eventListeners[_loc2_];
         }
      }
      
      public function reflect() : Class
      {
         throw Error("reflect() is abstract method and must be overridden.");
      }
      
      public function isTrackingTouch(param1:uint) : Boolean
      {
         return _touchesMap[param1] != undefined;
      }
      
      public function reset() : void
      {
         var _loc2_:Gesture = null;
         var _loc1_:GestureState = this.state;
         if(_loc1_ == GestureState.IDLE)
         {
            return;
         }
         _location.x = 0;
         _location.y = 0;
         _touchesMap = {};
         _touchesCount = 0;
         for(var _loc3_ in _gesturesToFail)
         {
            _loc2_ = _loc3_ as Gesture;
            _loc2_.removeEventListener("gestureStateChange",gestureToFail_stateChangeHandler);
         }
         _pendingRecognizedState = null;
         if(_loc1_ == GestureState.POSSIBLE)
         {
            setState(GestureState.FAILED);
         }
         else if(_loc1_ == GestureState.BEGAN || _loc1_ == GestureState.CHANGED)
         {
            setState(GestureState.CANCELLED);
         }
         else
         {
            setState(GestureState.IDLE);
         }
      }
      
      public function dispose() : void
      {
         reset();
         removeAllEventListeners();
         target = null;
         delegate = null;
         _gesturesToFail = null;
         eventListeners = null;
      }
      
      public function canBePreventedByGesture(param1:Gesture) : Boolean
      {
         return true;
      }
      
      public function canPreventGesture(param1:Gesture) : Boolean
      {
         return true;
      }
      
      public function requireGestureToFail(param1:Gesture) : void
      {
         if(!param1)
         {
            throw new ArgumentError();
         }
         _gesturesToFail[param1] = true;
      }
      
      protected function preinit() : void
      {
      }
      
      protected function installTarget(param1:Object) : void
      {
         if(param1)
         {
            _gesturesManager.gestouch_internal::addGesture(this);
         }
      }
      
      protected function uninstallTarget(param1:Object) : void
      {
         if(param1)
         {
            _gesturesManager.gestouch_internal::removeGesture(this);
         }
      }
      
      protected function ignoreTouch(param1:Touch) : void
      {
         if(_touchesMap.hasOwnProperty(param1.id))
         {
            delete _touchesMap[param1.id];
            _touchesCount = _touchesCount - 1;
         }
      }
      
      protected function failOrIgnoreTouch(param1:Touch) : void
      {
         if(state == GestureState.POSSIBLE)
         {
            setState(GestureState.FAILED);
         }
         else if(state != GestureState.IDLE)
         {
            ignoreTouch(param1);
         }
      }
      
      protected function onTouchBegin(param1:Touch) : void
      {
      }
      
      protected function onTouchMove(param1:Touch) : void
      {
      }
      
      protected function onTouchEnd(param1:Touch) : void
      {
      }
      
      protected function onTouchCancel(param1:Touch) : void
      {
      }
      
      protected function setState(param1:GestureState) : Boolean
      {
         var _loc3_:Gesture = null;
         var _loc4_:* = undefined;
         if(_state == param1 && _state == GestureState.CHANGED)
         {
            if(hasEventListener("gestureStateChange"))
            {
               dispatchEvent(new GestureEvent("gestureStateChange",_state,_state));
            }
            if(hasEventListener("gestureChanged"))
            {
               dispatchEvent(new GestureEvent("gestureChanged",_state,_state));
            }
            resetNotificationProperties();
            return true;
         }
         if(!_state.gestouch_internal::canTransitionTo(param1))
         {
            throw new IllegalOperationError("You cannot change from state " + _state + " to state " + param1 + ".");
         }
         if(param1 == GestureState.BEGAN || param1 == GestureState.RECOGNIZED)
         {
            for(_loc4_ in _gesturesToFail)
            {
               _loc3_ = _loc4_ as Gesture;
               if(_loc3_.state != GestureState.IDLE && _loc3_.state != GestureState.POSSIBLE && _loc3_.state != GestureState.FAILED)
               {
                  setState(GestureState.FAILED);
                  return false;
               }
            }
            for(_loc4_ in _gesturesToFail)
            {
               _loc3_ = _loc4_ as Gesture;
               if(_loc3_.state == GestureState.POSSIBLE)
               {
                  _pendingRecognizedState = param1;
                  for(_loc4_ in _gesturesToFail)
                  {
                     _loc3_ = _loc4_ as Gesture;
                     _loc3_.addEventListener("gestureStateChange",gestureToFail_stateChangeHandler,false,0,true);
                  }
                  return false;
               }
            }
            if(delegate && !delegate.gestureShouldBegin(this))
            {
               setState(GestureState.FAILED);
               return false;
            }
         }
         var _loc2_:GestureState = _state;
         _state = param1;
         if(_state.gestouch_internal::isEndState)
         {
            _gesturesManager.gestouch_internal::scheduleGestureStateReset(this);
         }
         if(hasEventListener("gestureStateChange"))
         {
            dispatchEvent(new GestureEvent("gestureStateChange",_state,_loc2_));
         }
         if(hasEventListener(_state.gestouch_internal::toEventType()))
         {
            dispatchEvent(new GestureEvent(_state.gestouch_internal::toEventType(),_state,_loc2_));
         }
         resetNotificationProperties();
         if(_state == GestureState.BEGAN || _state == GestureState.RECOGNIZED)
         {
            _gesturesManager.gestouch_internal::onGestureRecognized(this);
         }
         return true;
      }
      
      gestouch_internal function setState_internal(param1:GestureState) : void
      {
         setState(param1);
      }
      
      protected function updateCentralPoint() : void
      {
         var _loc2_:Point = null;
         var _loc4_:Number = 0;
         var _loc3_:Number = 0;
         for(var _loc1_ in _touchesMap)
         {
            _loc2_ = (_touchesMap[int(_loc1_)] as Touch).location;
            _loc4_ += _loc2_.x;
            _loc3_ += _loc2_.y;
         }
         _centralPoint.x = _loc4_ / _touchesCount;
         _centralPoint.y = _loc3_ / _touchesCount;
      }
      
      protected function updateLocation() : void
      {
         updateCentralPoint();
         _location.x = _centralPoint.x;
         _location.y = _centralPoint.y;
      }
      
      protected function resetNotificationProperties() : void
      {
      }
      
      gestouch_internal function touchBeginHandler(param1:Touch) : void
      {
         _touchesMap[param1.id] = param1;
         _touchesCount = _touchesCount + 1;
         onTouchBegin(param1);
         if(_touchesCount == 1 && state == GestureState.IDLE)
         {
            setState(GestureState.POSSIBLE);
         }
      }
      
      gestouch_internal function touchMoveHandler(param1:Touch) : void
      {
         _touchesMap[param1.id] = param1;
         onTouchMove(param1);
      }
      
      gestouch_internal function touchEndHandler(param1:Touch) : void
      {
         delete _touchesMap[param1.id];
         _touchesCount = _touchesCount - 1;
         onTouchEnd(param1);
      }
      
      gestouch_internal function touchCancelHandler(param1:Touch) : void
      {
         delete _touchesMap[param1.id];
         _touchesCount = _touchesCount - 1;
         onTouchCancel(param1);
         if(!state.gestouch_internal::isEndState)
         {
            if(state == GestureState.BEGAN || state == GestureState.CHANGED)
            {
               setState(GestureState.CANCELLED);
            }
            else
            {
               setState(GestureState.FAILED);
            }
         }
      }
      
      protected function gestureToFail_stateChangeHandler(param1:GestureEvent) : void
      {
         var _loc2_:Gesture = null;
         if(!_pendingRecognizedState || state != GestureState.POSSIBLE)
         {
            return;
         }
         if(param1.newState == GestureState.FAILED)
         {
            for(var _loc3_ in _gesturesToFail)
            {
               _loc2_ = _loc3_ as Gesture;
               if(_loc2_.state == GestureState.POSSIBLE)
               {
                  return;
               }
            }
            setState(_pendingRecognizedState);
         }
         else if(param1.newState != GestureState.IDLE && param1.newState != GestureState.POSSIBLE)
         {
            setState(GestureState.FAILED);
         }
      }
   }
}

