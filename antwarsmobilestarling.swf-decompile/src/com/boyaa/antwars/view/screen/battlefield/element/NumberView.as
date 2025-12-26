package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.net.Remoting;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.RenderTexture;
   
   public class NumberView extends Sprite
   {
      
      private var textureAtlas:ResAssetManager;
      
      private var imageName:String;
      
      private var renderTexture:RenderTexture;
      
      protected var _number:Number = 0;
      
      protected var __width:Number;
      
      protected var __height:Number;
      
      protected var numWidth:Number;
      
      protected var numHeight:Number;
      
      private var dot:Boolean;
      
      private var numImages:Vector.<Image>;
      
      public function NumberView(param1:String, param2:Number, param3:Number, param4:Boolean = false)
      {
         super();
         textureAtlas = Assets.sAsset;
         this.imageName = param1;
         this.__width = param2;
         this.__height = param3;
         this.dot = param4;
         var _loc5_:Image = getImage("0");
         numWidth = _loc5_.width;
         numHeight = _loc5_.height;
         numImages = new Vector.<Image>();
         renderTexture = new RenderTexture(__width,__height);
         _drawView();
         addChild(new Image(renderTexture));
      }
      
      public function set number(param1:Number) : void
      {
         _number = param1;
         _drawView();
      }
      
      public function get number() : Number
      {
         return _number;
      }
      
      protected function drawView() : void
      {
         var _loc6_:Image = null;
         var _loc2_:int = _number;
         if(dot)
         {
            _loc2_ = _number * 10;
         }
         var _loc4_:int = _loc2_ / 10;
         var _loc5_:int = _loc2_ % 10;
         var _loc3_:Image = getImage(_loc4_.toString());
         var _loc1_:Image = getImage(_loc5_.toString());
         _loc3_.x = __width - numWidth * 2 >> 1;
         _loc3_.y = __height - numHeight >> 1;
         _loc1_.y = _loc3_.y;
         _loc1_.x = _loc3_.x + numWidth;
         this.pushDrawImage(_loc3_);
         this.pushDrawImage(_loc1_);
         if(dot)
         {
            _loc6_ = getImage("dot");
            _loc6_.x = __width - _loc6_.width >> 1;
            _loc6_.y = _loc3_.y + numHeight / 2;
            this.pushDrawImage(_loc6_);
         }
      }
      
      protected function pushDrawImage(param1:Image) : void
      {
         numImages.push(param1);
      }
      
      protected function getImage(param1:String) : Image
      {
         return new Image(textureAtlas.getTexture(this.imageName + param1));
      }
      
      protected function _drawView() : void
      {
         try
         {
            drawView();
            renderTexture.clear();
            renderTexture.drawBundled(function():void
            {
               var _loc1_:int = 0;
               while(_loc1_ < numImages.length)
               {
                  renderTexture.draw(numImages[_loc1_]);
                  _loc1_++;
               }
               numImages.length = 0;
            });
         }
         catch(e:Error)
         {
            Remoting.instance.gameLog(e.message + "|" + e.getStackTrace());
         }
      }
      
      override public function dispose() : void
      {
         renderTexture.dispose();
         super.dispose();
      }
   }
}

