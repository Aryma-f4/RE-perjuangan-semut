package org.gestouch.core
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import org.gestouch.gestures.Gesture;
   import org.gestouch.input.NativeInputAdapter;
   
   use namespace gestouch_internal;
   
   public class GesturesManager
   {
      
      protected const _frameTickerShape:Shape = new Shape();
      
      protected var _inputAdapters:Vector.<IInputAdapter> = new Vector.<IInputAdapter>();
      
      protected var _gesturesMap:Dictionary = new Dictionary(true);
      
      protected var _gesturesForTouchMap:Dictionary = new Dictionary();
      
      protected var _gesturesForTargetMap:Dictionary = new Dictionary(true);
      
      protected var _dirtyGesturesCount:uint = 0;
      
      protected var _dirtyGesturesMap:Dictionary = new Dictionary(true);
      
      protected var _stage:Stage;
      
      public function GesturesManager()
      {
         super();
      }
      
      protected function onStageAvailable(param1:Stage) : void
      {
         _stage = param1;
         if(!Gestouch.inputAdapter)
         {
            Gestouch.inputAdapter = new NativeInputAdapter(param1);
         }
      }
      
      protected function resetDirtyGestures() : void
      {
         for(var _loc1_ in _dirtyGesturesMap)
         {
            (_loc1_ as Gesture).reset();
         }
         _dirtyGesturesCount = 0;
         _dirtyGesturesMap = new Dictionary(true);
         _frameTickerShape.removeEventListener("enterFrame",enterFrameHandler);
      }
      
      gestouch_internal function addGesture(param1:Gesture) : void
      {
         var _loc4_:DisplayObject = null;
         if(!param1)
         {
            throw new ArgumentError("Argument \'gesture\' must be not null.");
         }
         var _loc2_:Object = param1.target;
         if(!_loc2_)
         {
            throw new IllegalOperationError("Gesture must have target.");
         }
         var _loc3_:Vector.<Gesture> = _gesturesForTargetMap[_loc2_] as Vector.<Gesture>;
         if(_loc3_)
         {
            if(_loc3_.indexOf(param1) == -1)
            {
               _loc3_.push(param1);
            }
         }
         else
         {
            _loc3_ = _gesturesForTargetMap[_loc2_] = new Vector.<Gesture>();
            _loc3_[0] = param1;
         }
         _gesturesMap[param1] = true;
         if(!_stage)
         {
            _loc4_ = _loc2_ as DisplayObject;
            if(_loc4_)
            {
               if(_loc4_.stage)
               {
                  onStageAvailable(_loc4_.stage);
               }
               else
               {
                  _loc4_.addEventListener("addedToStage",gestureTarget_addedToStageHandler);
               }
            }
         }
      }
      
      gestouch_internal function removeGesture(param1:Gesture) : void
      {
         var _loc3_:* = undefined;
         if(!param1)
         {
            throw new ArgumentError("Argument \'gesture\' must be not null.");
         }
         var _loc2_:Object = param1.target;
         if(_loc2_)
         {
            _loc3_ = _gesturesForTargetMap[_loc2_] as Vector.<Gesture>;
            if(_loc3_.length > 1)
            {
               _loc3_.splice(_loc3_.indexOf(param1),1);
            }
            else
            {
               delete _gesturesForTargetMap[_loc2_];
               if(_loc2_ is IEventDispatcher)
               {
                  (_loc2_ as IEventDispatcher).removeEventListener("addedToStage",gestureTarget_addedToStageHandler);
               }
            }
         }
         delete _gesturesMap[param1];
         param1.reset();
      }
      
      gestouch_internal function scheduleGestureStateReset(param1:Gesture) : void
      {
         if(!_dirtyGesturesMap[param1])
         {
            _dirtyGesturesMap[param1] = true;
            _dirtyGesturesCount = _dirtyGesturesCount + 1;
            _frameTickerShape.addEventListener("enterFrame",enterFrameHandler);
         }
      }
      
      gestouch_internal function onGestureRecognized(param1:Gesture) : void
      {
         var _loc3_:Gesture = null;
         var _loc4_:Object = null;
         var _loc2_:IGestureDelegate = null;
         var _loc5_:IGestureDelegate = null;
         var _loc6_:Object = param1.target;
         for(var _loc7_ in _gesturesMap)
         {
            _loc3_ = _loc7_ as Gesture;
            _loc4_ = _loc3_.target;
            if(_loc3_ != param1 && _loc6_ && _loc4_ && _loc3_.enabled && _loc3_.state == GestureState.POSSIBLE)
            {
               if(_loc4_ == _loc6_ || param1.gestouch_internal::targetAdapter.contains(_loc4_) || _loc3_.gestouch_internal::targetAdapter.contains(_loc6_))
               {
                  _loc2_ = param1.delegate;
                  _loc5_ = _loc3_.delegate;
                  if(param1.canPreventGesture(_loc3_) && _loc3_.canBePreventedByGesture(param1) && (!_loc2_ || !_loc2_.gesturesShouldRecognizeSimultaneously(param1,_loc3_)) && (!_loc5_ || !_loc5_.gesturesShouldRecognizeSimultaneously(_loc3_,param1)))
                  {
                     _loc3_.gestouch_internal::setState_internal(GestureState.FAILED);
                  }
               }
            }
         }
      }
      
      gestouch_internal function onTouchBegin(param1:Touch) : void
      {
         var _loc5_:Gesture = null;
         var _loc9_:* = 0;
         var _loc8_:* = undefined;
         var _loc4_:Vector.<Gesture> = _gesturesForTouchMap[param1] as Vector.<Gesture>;
         if(!_loc4_)
         {
            _loc4_ = new Vector.<Gesture>();
            _gesturesForTouchMap[param1] = _loc4_;
         }
         else
         {
            _loc4_.length = 0;
         }
         var _loc3_:Object = param1.target;
         var _loc2_:IDisplayListAdapter = Gestouch.gestouch_internal::getDisplayListAdapter(_loc3_);
         if(!_loc2_)
         {
            throw new Error("Display list adapter not found for target of type \'" + getQualifiedClassName(_loc3_) + "\'.");
         }
         var _loc6_:Vector.<Object> = _loc2_.getHierarchy(_loc3_);
         var _loc7_:uint = _loc6_.length;
         if(_loc7_ == 0)
         {
            throw new Error("No hierarchy build for target \'" + _loc3_ + "\'. Something is wrong with that IDisplayListAdapter.");
         }
         if(_stage && !(_loc6_[_loc7_ - 1] is Stage))
         {
            _loc6_[_loc7_] = _stage;
         }
         for each(_loc3_ in _loc6_)
         {
            _loc8_ = _gesturesForTargetMap[_loc3_] as Vector.<Gesture>;
            if(_loc8_)
            {
               _loc9_ = _loc8_.length;
               while(_loc9_-- > 0)
               {
                  _loc5_ = _loc8_[_loc9_];
                  if(_loc5_.enabled && (!_loc5_.delegate || _loc5_.delegate.gestureShouldReceiveTouch(_loc5_,param1)))
                  {
                     _loc4_.unshift(_loc5_);
                  }
               }
            }
         }
         _loc9_ = _loc4_.length;
         while(_loc9_-- > 0)
         {
            _loc5_ = _loc4_[_loc9_];
            if(!_dirtyGesturesMap[_loc5_])
            {
               _loc5_.gestouch_internal::touchBeginHandler(param1);
            }
            else
            {
               _loc4_.splice(_loc9_,1);
            }
         }
      }
      
      gestouch_internal function onTouchMove(param1:Touch) : void
      {
         var _loc2_:Gesture = null;
         var _loc3_:Vector.<Gesture> = _gesturesForTouchMap[param1] as Vector.<Gesture>;
         var _loc4_:uint = _loc3_.length;
         while(_loc4_-- > 0)
         {
            _loc2_ = _loc3_[_loc4_];
            if(!_dirtyGesturesMap[_loc2_] && _loc2_.isTrackingTouch(param1.id))
            {
               _loc2_.gestouch_internal::touchMoveHandler(param1);
            }
            else
            {
               _loc3_.splice(_loc4_,1);
            }
         }
      }
      
      gestouch_internal function onTouchEnd(param1:Touch) : void
      {
         var _loc2_:Gesture = null;
         var _loc3_:Vector.<Gesture> = _gesturesForTouchMap[param1] as Vector.<Gesture>;
         var _loc4_:uint = _loc3_.length;
         while(_loc4_-- > 0)
         {
            _loc2_ = _loc3_[_loc4_];
            if(!_dirtyGesturesMap[_loc2_] && _loc2_.isTrackingTouch(param1.id))
            {
               _loc2_.gestouch_internal::touchEndHandler(param1);
            }
         }
         _loc3_.length = 0;
         delete _gesturesForTouchMap[param1];
      }
      
      gestouch_internal function onTouchCancel(param1:Touch) : void
      {
         var _loc2_:Gesture = null;
         var _loc3_:Vector.<Gesture> = _gesturesForTouchMap[param1] as Vector.<Gesture>;
         var _loc4_:uint = _loc3_.length;
         while(_loc4_-- > 0)
         {
            _loc2_ = _loc3_[_loc4_];
            if(!_dirtyGesturesMap[_loc2_] && _loc2_.isTrackingTouch(param1.id))
            {
               _loc2_.gestouch_internal::touchCancelHandler(param1);
            }
         }
         _loc3_.length = 0;
         delete _gesturesForTouchMap[param1];
      }
      
      protected function gestureTarget_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         _loc2_.removeEventListener("addedToStage",gestureTarget_addedToStageHandler);
         if(!_stage)
         {
            onStageAvailable(_loc2_.stage);
         }
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         resetDirtyGestures();
      }
   }
}

