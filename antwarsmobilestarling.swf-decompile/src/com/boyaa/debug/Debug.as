package com.boyaa.debug
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.gestouch.events.GestureEvent;
   import org.gestouch.gestures.TapGesture;
   
   public class Debug
   {
      
      private static var _text:TextField = null;
      
      private static var _sprite:Sprite = null;
      
      private static var _tfm:TextFormat = null;
      
      private static var _content:String = "";
      
      public function Debug()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:Rectangle) : void
      {
         if(!Constants.debug)
         {
            return;
         }
         _tfm = new TextFormat("Arial",20,16776960,true);
         _text = new TextField();
         _text.defaultTextFormat = _tfm;
         _text.width = param2.width;
         _text.height = param2.height;
         _text.mouseEnabled = false;
         _text.wordWrap = true;
         _sprite = new Sprite();
         _sprite.graphics.beginFill(6531376,0.3);
         _sprite.graphics.drawRect(0,0,param2.width,param2.height);
         _sprite.graphics.endFill();
         _sprite.addChild(_text);
         _sprite.mouseEnabled = false;
         _sprite.visible = false;
         param1.addChild(_sprite);
         var _loc3_:TapGesture = new TapGesture(param1);
         _loc3_.numTapsRequired = 2;
         _loc3_.numTouchesRequired = 2;
         _loc3_.addEventListener("gestureRecognized",showDebug);
      }
      
      public static function debug(... rest) : void
      {
         trace(rest);
         if(true)
         {
            return;
         }
         _content += "[ANT]" + rest.toString() + "[Boyaa]" + "\n";
         _text.text = _content;
         _text.scrollV = _text.maxScrollV;
      }
      
      public static function showDebug(param1:GestureEvent) : void
      {
         _sprite.visible = !_sprite.visible;
      }
   }
}

