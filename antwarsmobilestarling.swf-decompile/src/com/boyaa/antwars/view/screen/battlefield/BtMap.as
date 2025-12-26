package com.boyaa.antwars.view.screen.battlefield
{
   import com.boyaa.antwars.sound.SoundManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.textures.RenderTexture;
   
   public class BtMap extends Sprite
   {
      
      private static const ADDEX:String = "ADDEX";
      
      private var mRenderTexture:RenderTexture;
      
      private var mCanvas:Image;
      
      private var mMapId:int;
      
      private var _bitmapData:BitmapData;
      
      public var mapHeight:int = 0;
      
      public var mapWidth:int = 0;
      
      private var mark:Quad;
      
      public var mapSolid:Boolean = false;
      
      public function BtMap(param1:int)
      {
         switch(param1)
         {
            case 1001:
            case 1203:
               SoundManager.playBgSound("Music 6");
               break;
            case 1002:
            case 1201:
            case 1204:
               SoundManager.playBgSound("Music 7");
               break;
            case 1003:
            case 1102:
            case 1202:
               SoundManager.playBgSound("Music 8");
               break;
            case 1004:
            case 1104:
               SoundManager.playBgSound("Music 9");
               break;
            case 1005:
            case 1103:
               SoundManager.playBgSound("Music 10");
         }
         BlendMode.register("ADDEX","destinationAlpha","oneMinusSourceAlpha");
         super();
         mMapId = param1;
         createMap();
         mark = new Quad(mapWidth,mapHeight,0);
         mark.alpha = 0;
      }
      
      public function getMapId() : int
      {
         return mMapId;
      }
      
      private function createMap() : void
      {
         _bitmapData = Assets.btAsset.getBitmapData("map_" + mMapId);
         var _loc1_:Image = new Image(Assets.btAsset.getMapTexture(mMapId));
         mapHeight = _loc1_.height;
         mapWidth = _loc1_.width;
         mRenderTexture = new RenderTexture(_loc1_.width,_loc1_.height,true,1);
         mCanvas = new Image(mRenderTexture);
         mRenderTexture.draw(_loc1_);
         addChild(mCanvas);
         _loc1_.dispose();
         Assets.btAsset.removeMapTexture(mMapId);
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function hitPoint(param1:Point) : Boolean
      {
         var _loc3_:uint = _bitmapData.getPixel32(param1.x,param1.y);
         var _loc2_:uint = uint(_loc3_ >> 24 & 0xFF);
         if(_loc2_ > alpha)
         {
            return true;
         }
         return false;
      }
      
      public function slotting(param1:Image, param2:BitmapData, param3:Image, param4:int, param5:Point) : void
      {
         if(mapSolid)
         {
            return;
         }
         param1.blendMode = "erase";
         param1.scaleX = param1.scaleY = param4 / (param1.width - 80);
         param1.x = param5.x;
         param1.y = param5.y;
         mRenderTexture.draw(param1);
         param3.blendMode = "ADDEX";
         param3.scaleX = param3.scaleY = param1.scaleX;
         param3.x = param5.x;
         param3.y = param5.y;
         mRenderTexture.draw(param3);
         var _loc6_:Bitmap = new Bitmap(param2);
         _loc6_.scaleX = _loc6_.scaleY = param1.scaleX;
         _bitmapData.draw(_loc6_,new Matrix(param1.scaleX,0,0,param1.scaleX,param5.x - (_loc6_.width >> 1),param5.y - (_loc6_.height >> 1)),null,"erase");
      }
      
      public function dark() : void
      {
         addChild(mark);
         Starling.juggler.tween(mark,0.5,{"alpha":0.5});
      }
      
      public function unDark() : void
      {
         Starling.juggler.tween(mark,0.5,{
            "alpha":0,
            "onComplete":function():void
            {
               removeChild(mark);
            }
         });
      }
      
      override public function dispose() : void
      {
         mRenderTexture.dispose();
         mCanvas.dispose();
         _bitmapData.dispose();
         _bitmapData = null;
         Assets.btAsset.removeMapTexture(mMapId,"bg");
         trace("BtMap dispose");
         super.dispose();
      }
   }
}

