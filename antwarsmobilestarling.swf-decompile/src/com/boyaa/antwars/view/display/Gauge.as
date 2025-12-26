package com.boyaa.antwars.view.display
{
   import flash.geom.Point;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.Texture;
   
   public class Gauge extends Sprite
   {
      
      private var mImage:Image;
      
      private var mRatio:Number;
      
      public function Gauge(param1:Texture)
      {
         super();
         mRatio = 1;
         mImage = new Image(param1);
         addChild(mImage);
      }
      
      private function update() : void
      {
         mImage.scaleX = mRatio;
         mImage.setTexCoords(1,new Point(mRatio,0));
         mImage.setTexCoords(3,new Point(mRatio,1));
      }
      
      public function get ratio() : Number
      {
         return mRatio;
      }
      
      public function set ratio(param1:Number) : void
      {
         mRatio = Math.max(0,Math.min(1,param1));
         update();
      }
   }
}

