package com.joeonmars.camerafocus
{
   import com.joeonmars.camerafocus.events.*;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.display.Stage;
   
   public final class StarlingCameraFocus
   {
      
      private var _stage:Stage;
      
      private var _stageContainer:DisplayObject;
      
      private var _map:DisplayObject;
      
      private var _focusPosition:Point;
      
      private var _focusTracker:Point;
      
      private var _focusOrientation:Point;
      
      private var _focusCurrentLoc:Point;
      
      private var _focusLastLoc:Point;
      
      private var _focusDistX:Number;
      
      private var _focusDistY:Number;
      
      private var _focusTarget:*;
      
      private var _layersInfo:Dictionary;
      
      private var _boundaryLayer:DisplayObject;
      
      private var _switch:Boolean;
      
      private var _targetLastX:Number;
      
      private var _targetLastY:Number;
      
      private var _targetCurrentX:Number;
      
      private var _targetCurrentY:Number;
      
      private var _zoomFactor:Number;
      
      private var _intensity:Number;
      
      private var _shakeTimer:int;
      
      private var _shakeDecay:Number;
      
      public var trackStep:uint;
      
      public var swapStep:uint;
      
      public var zoomStep:uint;
      
      private var _tempStep:uint;
      
      private var _step:uint;
      
      public var ignoreLeftBound:Boolean;
      
      public var ignoreRightBound:Boolean;
      
      public var ignoreTopBound:Boolean;
      
      public var ignoreBottomBound:Boolean;
      
      public var isFocused:Boolean;
      
      public var isSwaping:Boolean;
      
      public var isZooming:Boolean;
      
      public var isShaking:Boolean;
      
      public var enableCallBack:Boolean;
      
      private var _boundaryEvent:CameraFocusEvent;
      
      private var _swapStartedEvent:CameraFocusEvent;
      
      private var _swapFinishedEvent:CameraFocusEvent;
      
      private var _zoomStartedEvent:CameraFocusEvent;
      
      private var _zoomFinishedEvent:CameraFocusEvent;
      
      private var _shakeStartedEvent:CameraFocusEvent;
      
      private var _shakeFinishedEvent:CameraFocusEvent;
      
      public function StarlingCameraFocus(param1:Stage, param2:DisplayObject, param3:*, param4:DisplayObject, param5:Array, param6:Boolean = false)
      {
         super();
         _stage = param1;
         _stageContainer = param2;
         _layersInfo = new Dictionary();
         _map = param4;
         _focusPosition = new Point();
         focusTarget = param3;
         _focusTracker = new Point();
         _focusTracker.x = _focusTarget.x;
         _focusTracker.y = _focusTarget.y;
         _focusOrientation = new Point();
         _focusOrientation.x = _focusTarget.x;
         _focusOrientation.y = _focusTarget.y;
         _focusCurrentLoc = _focusTracker.clone();
         _focusLastLoc = _focusTracker.clone();
         for each(var _loc7_ in param5)
         {
            _loc7_.ox = _loc7_.instance.x;
            _loc7_.oy = _loc7_.instance.y;
            _layersInfo[_loc7_.name] = _loc7_;
         }
         _targetLastX = _targetCurrentX = focusTarget.x;
         _targetLastY = _targetCurrentY = focusTarget.y;
         trackStep = 10;
         swapStep = 5;
         zoomStep = 10;
         _step = trackStep;
         _tempStep = trackStep;
         _zoomFactor = _stageContainer.scaleX;
         setDefaultFocusPosition();
         setBoundary();
         _boundaryEvent = new CameraFocusEvent("hitBoundary");
         _swapStartedEvent = new CameraFocusEvent("swapStarted");
         _swapFinishedEvent = new CameraFocusEvent("swapFinished");
         _zoomStartedEvent = new CameraFocusEvent("zoomStarted");
         _zoomFinishedEvent = new CameraFocusEvent("zoomFinished");
         _shakeStartedEvent = new CameraFocusEvent("shakeStarted");
         _shakeFinishedEvent = new CameraFocusEvent("shakeFinished");
         if(param6)
         {
            start();
         }
         else
         {
            pause();
         }
      }
      
      public function set focusTarget(param1:*) : void
      {
         this.setDefaultFocusPosition();
         _focusTarget = param1;
      }
      
      public function get focusTarget() : *
      {
         return _focusTarget;
      }
      
      public function get zoomFactor() : Number
      {
         return _zoomFactor;
      }
      
      private function get focusDist() : Object
      {
         return {
            "distX":_focusCurrentLoc.x - _focusLastLoc.x,
            "distY":_focusCurrentLoc.y - _focusLastLoc.y
         };
      }
      
      private function get globalTrackerLoc() : Point
      {
         var _loc1_:Point = null;
         if(_focusTarget is Point)
         {
            _loc1_ = _stageContainer.localToGlobal(_focusTracker);
         }
         else if(_focusTarget is DisplayObject)
         {
            _loc1_ = _focusTarget.parent.localToGlobal(_focusTracker);
         }
         return _loc1_;
      }
      
      public function getLayerByName(param1:String) : DisplayObject
      {
         return _layersInfo[param1].instance;
      }
      
      public function start() : void
      {
         _switch = true;
      }
      
      public function pause() : void
      {
         _switch = false;
      }
      
      public function destroy() : void
      {
         _stage = null;
         _stageContainer = null;
         _boundaryLayer = null;
         _layersInfo = null;
         focusTarget = null;
         _boundaryEvent = null;
         _swapStartedEvent = null;
         _swapFinishedEvent = null;
         _zoomStartedEvent = null;
         _zoomFinishedEvent = null;
         _shakeStartedEvent = null;
         _shakeFinishedEvent = null;
      }
      
      public function setFocusPosition(param1:Number, param2:Number) : void
      {
         _focusPosition.x = param1;
         _focusPosition.y = param2;
      }
      
      public function setDefaultFocusPosition() : void
      {
         setFocusPosition(Assets.width * 0.5,Assets.height * 0.5);
      }
      
      public function get focusPosition() : Point
      {
         return _focusPosition;
      }
      
      public function setBoundary(param1:DisplayObject = null) : void
      {
         _boundaryLayer = param1;
      }
      
      public function jumpToFocus(param1:* = null) : void
      {
         if(param1 == null)
         {
            param1 = _focusTarget;
         }
         _focusCurrentLoc.x = _focusLastLoc.x = _focusTracker.x = _focusTarget.x;
         _focusCurrentLoc.y = _focusLastLoc.y = _focusTracker.y = _focusTarget.y;
         swapFocus(param1,1);
      }
      
      public function swapFocus(param1:*, param2:uint = 10, param3:Boolean = false, param4:Number = 1, param5:int = 10) : void
      {
         _focusTarget = param1;
         swapStep = Math.max(1,param2);
         _tempStep = trackStep;
         _step = swapStep;
         isSwaping = true;
         if(enableCallBack)
         {
            _stage.dispatchEvent(_swapStartedEvent);
         }
         if(param3)
         {
            zoomFocus(param4,param5);
         }
      }
      
      public function zoomFocus(param1:Number, param2:uint = 10) : void
      {
         _zoomFactor = Math.max(0,param1);
         zoomStep = Math.max(1,param2);
         isZooming = true;
         if(enableCallBack)
         {
            _stage.dispatchEvent(_zoomStartedEvent);
         }
      }
      
      public function shake(param1:Number, param2:int) : void
      {
         _intensity = param1;
         _shakeTimer = param2;
         _shakeDecay = param1 / param2;
         isShaking = true;
         if(enableCallBack)
         {
            _stage.dispatchEvent(_shakeStartedEvent);
         }
      }
      
      public function update() : void
      {
         if(!_switch)
         {
            return;
         }
         if(_focusTarget == null)
         {
            return;
         }
         if(_focusTarget is DisplayObject && _focusTarget.parent == null)
         {
            return;
         }
         if(Math.round((_focusTarget.x - _focusTracker.x) * (_focusTarget.y - _focusTracker.y)) == 0)
         {
            _tempStep = trackStep;
            _step = _tempStep;
            _focusTracker.x = _focusTarget.x;
            _focusTracker.y = _focusTarget.y;
            if(isSwaping)
            {
               isSwaping = false;
               if(enableCallBack)
               {
                  _stage.dispatchEvent(_swapFinishedEvent);
               }
            }
            isFocused = true;
         }
         else
         {
            isFocused = false;
         }
         _focusTracker.x += (_focusTarget.x - _focusTracker.x) / _step;
         _focusTracker.y += (_focusTarget.y - _focusTracker.y) / _step;
         _focusLastLoc.x = _focusCurrentLoc.x;
         _focusLastLoc.y = _focusCurrentLoc.y;
         _focusCurrentLoc.x = _focusTracker.x;
         _focusCurrentLoc.y = _focusTracker.y;
         _targetLastX = _targetCurrentX;
         _targetLastY = _targetCurrentY;
         _targetCurrentX = focusTarget.x;
         _targetCurrentY = focusTarget.y;
         if(isZooming)
         {
            _stageContainer.scaleX += (_zoomFactor - _stageContainer.scaleX) / zoomStep;
            _stageContainer.scaleY += (_zoomFactor - _stageContainer.scaleY) / zoomStep;
            if(Math.abs(_stageContainer.scaleX - _zoomFactor) < 0.01)
            {
               isZooming = false;
               _stageContainer.scaleX = _stageContainer.scaleY = _zoomFactor;
               if(enableCallBack)
               {
                  _stage.dispatchEvent(_zoomFinishedEvent);
               }
            }
         }
         positionStageContainer();
         var _loc1_:Object = testBounds();
         positionParallax(_loc1_);
         if(isShaking)
         {
            if(_shakeTimer > 0)
            {
               _shakeTimer = _shakeTimer - 1;
               if(_shakeTimer <= 0)
               {
                  _shakeTimer = 0;
                  isShaking = false;
                  if(enableCallBack)
                  {
                     _stage.dispatchEvent(_shakeFinishedEvent);
                  }
               }
               else
               {
                  _intensity -= _shakeDecay;
                  _stageContainer.x = Math.random() * _intensity * Assets.width * 2 - _intensity * Assets.width + _stageContainer.x;
                  _stageContainer.y = Math.random() * _intensity * Assets.height * 2 - _intensity * Assets.height + _stageContainer.y;
               }
            }
         }
      }
      
      private function testBounds() : Object
      {
         var _loc3_:Object = {
            "top":false,
            "bottom":false,
            "left":false,
            "right":false
         };
         if(_boundaryLayer == null)
         {
            return _loc3_;
         }
         var _loc5_:Point = _boundaryLayer.parent.localToGlobal(new Point(_boundaryLayer.x,_boundaryLayer.y));
         var _loc7_:Point = _boundaryLayer.parent.localToGlobal(new Point(_boundaryLayer.x + _boundaryLayer.width,_boundaryLayer.y + _boundaryLayer.height));
         var _loc6_:Number = _loc5_.x;
         var _loc4_:Number = _loc5_.y;
         var _loc1_:Number = _loc7_.x;
         var _loc2_:Number = _loc7_.y;
         if(_loc6_ > Assets.leftTop.x)
         {
            if(!ignoreLeftBound)
            {
               _stageContainer.x += Assets.leftTop.x - _loc6_;
            }
            if(enableCallBack)
            {
               _boundaryEvent.boundary = "left";
               _stage.dispatchEvent(_boundaryEvent);
            }
            _loc3_.left = true;
         }
         if(_loc1_ < Assets.rightBottom.x)
         {
            if(!ignoreRightBound)
            {
               _stageContainer.x += Assets.rightBottom.x - _loc1_;
            }
            if(enableCallBack)
            {
               _boundaryEvent.boundary = "right";
               _stage.dispatchEvent(_boundaryEvent);
            }
            _loc3_.right = true;
         }
         if(_loc4_ > Assets.leftTop.y)
         {
            if(!ignoreTopBound)
            {
               _stageContainer.y += Assets.leftTop.y - _loc4_;
            }
            if(enableCallBack)
            {
               _boundaryEvent.boundary = "top";
               _stage.dispatchEvent(_boundaryEvent);
            }
            _loc3_.top = true;
         }
         if(_loc2_ < Assets.rightBottom.y)
         {
            if(!ignoreBottomBound)
            {
               _stageContainer.y += Assets.rightBottom.y - _loc2_;
            }
            if(enableCallBack)
            {
               _boundaryEvent.boundary = "bottom";
               _stage.dispatchEvent(_boundaryEvent);
            }
            _loc3_.bottom = true;
         }
         return _loc3_;
      }
      
      private function positionStageContainer() : void
      {
         _stageContainer.x += _focusPosition.x - globalTrackerLoc.x;
         _stageContainer.y += _focusPosition.y - globalTrackerLoc.y;
      }
      
      private function positionParallax(param1:Object) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc4_:* = param1;
         for each(var _loc5_ in _layersInfo)
         {
            _loc7_ = _loc5_.instance;
            _loc3_ = Number(_loc5_.ox);
            _loc2_ = Number(_loc5_.oy);
            if(_loc5_.ratio != 0)
            {
               _loc6_ = 1 - (_loc7_.width * _stageContainer.scaleX - Assets.width) / (_map.width * _stageContainer.scaleX - Assets.width);
               _loc8_ = 1 - (_loc7_.height * _stageContainer.scaleY - Assets.height) / (_map.height * _stageContainer.scaleY - Assets.height);
               _loc7_.x = -_stageContainer.x * _loc6_ / _stageContainer.scaleX;
               _loc7_.y = -_stageContainer.y * _loc8_ / _stageContainer.scaleY;
            }
         }
      }
   }
}

