package com.boyaa.tool.smallTools.boyaaCode.scrollText
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class BoyaaScrollText extends Sprite
   {
      
      private var _textField:TextField;
      
      private var _text:String = "";
      
      private const MOVE_TIME:Number = 0.1;
      
      public function BoyaaScrollText(param1:int, param2:int, param3:String, param4:String = "Verdana", param5:int = 20, param6:uint = 16777215, param7:Boolean = false)
      {
         super();
         _textField = new TextField(param1,param2,param3,param4,param5,param6,param7);
         _textField.hAlign = "left";
         _textField.vAlign = "top";
         addChild(_textField);
         setTextSize(param1,param2);
         this.addEventListener("touch",onTouchHandle);
      }
      
      private function setTextFieldHeight() : void
      {
         _textField.height = _textField.textBounds.height + 10;
      }
      
      private function onTouchHandle(param1:TouchEvent) : void
      {
         var _loc4_:Touch = null;
         var _loc7_:Point = null;
         var _loc2_:Point = null;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Vector.<Touch> = param1.getTouches(this,"moved");
         if(_loc5_.length == 1)
         {
            _loc4_ = _loc5_[0];
            _loc7_ = _loc4_.getLocation(this);
            _loc2_ = _loc4_.getPreviousLocation(this);
            _loc6_ = _loc2_.y - _loc7_.y;
            _textField.y -= _loc6_;
         }
         _loc5_ = param1.getTouches(this,"ended");
         if(_loc5_.length == 1)
         {
            if(_textField.y > 0)
            {
               Starling.juggler.tween(_textField,0.1,{
                  "y":0,
                  "transition":"easeInElastic"
               });
            }
            if(_textField.y < 0)
            {
               _loc3_ = clipRect.height - _textField.textBounds.height;
               if(_textField.textBounds.height >= clipRect.height)
               {
                  if(_textField.y <= _loc3_)
                  {
                     Starling.juggler.tween(_textField,0.1,{
                        "y":_loc3_,
                        "transition":"easeInElastic"
                     });
                  }
               }
               else
               {
                  Starling.juggler.tween(_textField,0.1,{
                     "y":0,
                     "transition":"easeInElastic"
                  });
               }
            }
         }
      }
      
      private function init() : void
      {
      }
      
      public function setTextSize(param1:int, param2:int) : void
      {
         this.clipRect = new Rectangle(0,0,param1,param2);
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         _textField.text = param1;
         setTextFieldHeight();
      }
      
      override public function dispose() : void
      {
         this.removeEventListener("touch",onTouchHandle);
         Starling.juggler.removeTweens(_textField);
         super.dispose();
      }
   }
}

