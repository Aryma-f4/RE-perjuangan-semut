package com.boyaa.antwars
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Loadding extends Sprite
   {
      
      public static const BgLoading:Class = §loading_png$67faeff2b9ad9f2f94034ff8874f1bf2-661908667§;
      
      private var _stage:DisplayObjectContainer = null;
      
      private var _loadingBitmap:Bitmap = null;
      
      private var display:TextField = null;
      
      private var mViewPort:Rectangle;
      
      private var _inStage:Boolean = false;
      
      public function Loadding(param1:DisplayObjectContainer, param2:Rectangle)
      {
         super();
         _stage = param1;
         mViewPort = param2;
         this.mouseEnabled = false;
         _loadingBitmap = new BgLoading();
         _loadingBitmap.smoothing = true;
         _loadingBitmap.width = mViewPort.width;
         _loadingBitmap.height = mViewPort.height;
         _loadingBitmap.x = mViewPort.x;
         _loadingBitmap.y = mViewPort.y;
         addChild(_loadingBitmap);
         var _loc4_:Sprite = new Sprite();
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         _loc4_.graphics.beginFill(0,0.5);
         _loc4_.graphics.drawRect(0,0,mViewPort.width,mViewPort.height * 0.15);
         _loc4_.graphics.endFill();
         _loc4_.x = mViewPort.x;
         _loc4_.y = mViewPort.y + (mViewPort.height - mViewPort.height * 0.15) / 2;
         display = new TextField();
         display.textColor = 16777215;
         display.autoSize = "center";
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = 25;
         display.defaultTextFormat = _loc3_;
         _loc4_.addChild(display);
         addChild(_loc4_);
      }
      
      public function getBitMap() : Bitmap
      {
         return _loadingBitmap;
      }
      
      public function addToStage() : void
      {
         if(!_inStage)
         {
            _stage.addChild(this);
            _inStage = true;
         }
      }
      
      public function setStateText(param1:String) : void
      {
         display.text = param1;
         display.x = mViewPort.width - display.textWidth >> 1;
         display.y = mViewPort.y + (display.textHeight >> 1) + 5;
         addToStage();
      }
      
      public function removeToStage() : void
      {
         if(_inStage)
         {
            _loadingBitmap.bitmapData.dispose();
            _stage.removeChild(this);
            _inStage = false;
         }
      }
   }
}

