package org.gestouch.input
{
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.events.TouchEvent;
   import flash.ui.Multitouch;
   import org.gestouch.core.IInputAdapter;
   import org.gestouch.core.TouchesManager;
   import org.gestouch.core.gestouch_internal;
   
   use namespace gestouch_internal;
   
   public class NativeInputAdapter implements IInputAdapter
   {
      
      protected static const MOUSE_TOUCH_POINT_ID:uint = 0;
      
      Multitouch.inputMode = "touchPoint";
      
      protected var _stage:Stage;
      
      protected var _explicitlyHandleTouchEvents:Boolean;
      
      protected var _explicitlyHandleMouseEvents:Boolean;
      
      protected var _touchesManager:TouchesManager;
      
      public function NativeInputAdapter(param1:Stage, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         if(!param1)
         {
            throw new ArgumentError("Stage must be not null.");
         }
         _stage = param1;
         _explicitlyHandleTouchEvents = param2;
         _explicitlyHandleMouseEvents = param3;
      }
      
      public function set touchesManager(param1:TouchesManager) : void
      {
         _touchesManager = param1;
      }
      
      public function init() : void
      {
         if(Multitouch.supportsTouchEvents || _explicitlyHandleTouchEvents)
         {
            _stage.addEventListener("touchBegin",touchBeginHandler,true);
            _stage.addEventListener("touchBegin",touchBeginHandler,false);
            _stage.addEventListener("touchMove",touchMoveHandler,true);
            _stage.addEventListener("touchMove",touchMoveHandler,false);
            _stage.addEventListener("touchEnd",touchEndHandler,true,2147483647);
            _stage.addEventListener("touchEnd",touchEndHandler,false,2147483647);
         }
         if(!Multitouch.supportsTouchEvents || _explicitlyHandleMouseEvents)
         {
            _stage.addEventListener("mouseDown",mouseDownHandler,true);
            _stage.addEventListener("mouseDown",mouseDownHandler,false);
         }
      }
      
      public function onDispose() : void
      {
         _touchesManager = null;
         _stage.removeEventListener("touchBegin",touchBeginHandler,true);
         _stage.removeEventListener("touchBegin",touchBeginHandler,false);
         _stage.removeEventListener("touchMove",touchMoveHandler,true);
         _stage.removeEventListener("touchMove",touchMoveHandler,false);
         _stage.removeEventListener("touchEnd",touchEndHandler,true);
         _stage.removeEventListener("touchEnd",touchEndHandler,false);
         _stage.removeEventListener("mouseDown",mouseDownHandler,true);
         _stage.removeEventListener("mouseDown",mouseDownHandler,false);
         unstallMouseListeners();
      }
      
      protected function installMouseListeners() : void
      {
         _stage.addEventListener("mouseMove",mouseMoveHandler,true);
         _stage.addEventListener("mouseMove",mouseMoveHandler,false);
         _stage.addEventListener("mouseUp",mouseUpHandler,true,2147483647);
         _stage.addEventListener("mouseUp",mouseUpHandler,false,2147483647);
      }
      
      protected function unstallMouseListeners() : void
      {
         _stage.removeEventListener("mouseMove",mouseMoveHandler,true);
         _stage.removeEventListener("mouseMove",mouseMoveHandler,false);
         _stage.removeEventListener("mouseUp",mouseUpHandler,true);
         _stage.removeEventListener("mouseUp",mouseUpHandler,false);
      }
      
      protected function touchBeginHandler(param1:TouchEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         _touchesManager.gestouch_internal::onTouchBegin(param1.touchPointID,param1.stageX,param1.stageY,param1.target as InteractiveObject);
      }
      
      protected function touchMoveHandler(param1:TouchEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         _touchesManager.gestouch_internal::onTouchMove(param1.touchPointID,param1.stageX,param1.stageY);
      }
      
      protected function touchEndHandler(param1:TouchEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         if(param1.hasOwnProperty("isTouchPointCanceled") && param1["isTouchPointCanceled"])
         {
            _touchesManager.gestouch_internal::onTouchCancel(param1.touchPointID,param1.stageX,param1.stageY);
         }
         else
         {
            _touchesManager.gestouch_internal::onTouchEnd(param1.touchPointID,param1.stageX,param1.stageY);
         }
      }
      
      protected function mouseDownHandler(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         var _loc2_:Boolean = _touchesManager.gestouch_internal::onTouchBegin(0,param1.stageX,param1.stageY,param1.target as InteractiveObject);
         if(_loc2_)
         {
            installMouseListeners();
         }
      }
      
      protected function mouseMoveHandler(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         _touchesManager.gestouch_internal::onTouchMove(0,param1.stageX,param1.stageY);
      }
      
      protected function mouseUpHandler(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 3)
         {
            return;
         }
         _touchesManager.gestouch_internal::onTouchEnd(0,param1.stageX,param1.stageY);
         if(_touchesManager.activeTouchesCount == 0)
         {
            unstallMouseListeners();
         }
      }
   }
}

