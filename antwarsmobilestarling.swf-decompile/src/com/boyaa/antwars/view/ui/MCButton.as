package com.boyaa.antwars.view.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MCButton
   {
      
      private const UP:int = 1;
      
      private const OVER:int = 2;
      
      private const DOWN:int = 3;
      
      private const DISABLE:int = 4;
      
      private var _btn:MovieClip = null;
      
      private var _fun:Function = null;
      
      public function MCButton(param1:MovieClip)
      {
         super();
         _btn = param1;
         _btn.gotoAndStop(1);
         _btn.mouseChildren = false;
      }
      
      public function get btnView() : MovieClip
      {
         return _btn;
      }
      
      public function set click(param1:Function) : void
      {
         if(param1 != null)
         {
            _btn.mouseEnabled = true;
            _btn.buttonMode = true;
            addEvent(param1);
            _fun = param1;
         }
         else
         {
            _btn.mouseEnabled = false;
            _btn.buttonMode = false;
            removeEvent(_fun);
         }
      }
      
      private function addEvent(param1:Function) : void
      {
         _btn.addEventListener("rollOver",rollOver);
         _btn.addEventListener("rollOut",rollOut);
         _btn.addEventListener("mouseDown",onMouseDown);
         _btn.addEventListener("mouseUp",onUp);
         _btn.addEventListener("click",onSound);
         _btn.addEventListener("click",param1);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame < 4)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame < 4)
         {
            param1.currentTarget.gotoAndStop(3);
         }
      }
      
      private function onSound(param1:MouseEvent) : void
      {
      }
      
      private function rollOver(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame < 4)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function rollOut(param1:MouseEvent) : void
      {
         if(param1.currentTarget.currentFrame < 4)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function removeEvent(param1:Function) : void
      {
         _btn.removeEventListener("rollOver",rollOver);
         _btn.removeEventListener("rollOut",rollOut);
         _btn.removeEventListener("mouseDown",onMouseDown);
         _btn.removeEventListener("mouseUp",onUp);
         _btn.removeEventListener("click",onSound);
         _btn.removeEventListener("click",param1);
      }
   }
}

