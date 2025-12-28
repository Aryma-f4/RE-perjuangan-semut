package com.boyaa.antwars.view.display
{
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class StartGameProgress extends Sprite
   {
      
      public static const ProgressBackground:Class = ProgressBackgroundPng;
      
      private var _progress:Sprite;
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      private var _bg:Bitmap;
      
      private var _bar:Shape;

      private var _text:TextField;
      
      public function StartGameProgress()
      {
         super();
         _bg = new ProgressBackground();
         _width = _bg.width;
         _height = _bg.height;
         addChild(_bg);
         _progress = new Sprite();
         _bar = new Shape();
         _bar.graphics.beginFill(6618880);
         _bar.graphics.drawRect(26,62,406,12);
         _bar.graphics.endFill();
         _progress.addChild(_bar);
         _progress.scrollRect = new Rectangle(0,0,0,_height);
         addChild(_progress);
         _text = new TextField();
         _text.defaultTextFormat = new TextFormat("Arial",12,16777215);
         _text.width = _width;
         _text.height = 20;
         _text.y = 60;
         _text.text = "0%";
         _text.autoSize = "center";
         addChild(_text);
      }
      
      public function set progress(param1:Number) : void
      {
         _progress.scrollRect = new Rectangle(0,0,_width * param1,_height);
         _text.text = int(param1 * 100) + "%";
         _text.x = (_width - _text.width) / 2;
      }
   }
}

import flash.geom.Rectangle;
