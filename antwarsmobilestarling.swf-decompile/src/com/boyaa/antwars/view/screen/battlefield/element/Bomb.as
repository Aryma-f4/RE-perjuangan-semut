package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.QuadBatch;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.extensions.pixelmask.PixelMaskDisplayObject;
   import starling.textures.Texture;
   
   public class Bomb extends Sprite
   {
      
      private static const DU_PART:Number = 24;
      
      private static const MAX_DATA:Number = 100;
      
      private var textureAtlas:ResAssetManager;
      
      private var bgRound:Image;
      
      private var coreRound:Image;
      
      private var mask:Image;
      
      private var maskQuadBatch:QuadBatch;
      
      private var round:PixelMaskDisplayObject;
      
      private var r:Number;
      
      private var centerPoint:Point;
      
      private var data:uint = 0;
      
      private var _du:uint = 1;
      
      private var isHardwareRendering:Boolean;
      
      private var fireMC:MovieClip;
      
      public function Bomb()
      {
         super();
         textureAtlas = Assets.sAsset;
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         isHardwareRendering = Starling.context.driverInfo.toLowerCase().indexOf("software") == -1;
         LevelLogger.getLogger("Bomb").info("isHardwareRendering:",isHardwareRendering);
         bgRound = new Image(textureAtlas.getTexture("dz63"));
         addChild(bgRound);
         r = bgRound.width >> 1;
         centerPoint = new Point(bgRound.width >> 1,bgRound.height >> 1);
         coreRound = new Image(textureAtlas.getTexture("dz62"));
         coreRound.x = bgRound.width - coreRound.width >> 1;
         coreRound.y = bgRound.height - coreRound.height >> 1;
         addChild(coreRound);
         var _loc2_:Image = new Image(textureAtlas.getTexture("dz66"));
         round = new PixelMaskDisplayObject();
         round.addChild(_loc2_);
         addChild(round);
         drawMask();
         fireMC = new MovieClip(textureAtlas.getTextures("fire"),20);
         fireMC.touchable = false;
         fireMC.pivotX = fireMC.width >> 1;
         fireMC.pivotY = fireMC.height;
         fireMC.x = centerPoint.x;
         fireMC.y = centerPoint.y + r - 20;
         fireMC.scaleX = fireMC.scaleY = 1.2;
         bombValue = 0;
      }
      
      private function drawMask() : void
      {
         var _loc2_:Shape = new Shape();
         drawSector(_loc2_.graphics,16,r);
         var _loc1_:BitmapData = new BitmapData(2 * r,2 * r,true,0);
         _loc1_.draw(_loc2_);
         _loc2_ = null;
         mask = new Image(Texture.fromBitmapData(_loc1_));
         _loc1_.dispose();
         mask.touchable = false;
         mask.pivotX = r;
         mask.pivotY = r;
         maskQuadBatch = new QuadBatch();
         maskQuadBatch.touchable = false;
         maskQuadBatch.x = r;
         maskQuadBatch.y = r;
         round.mask = maskQuadBatch;
      }
      
      public function get bombValue() : uint
      {
         return this.data;
      }
      
      public function set bombValue(param1:uint) : void
      {
         var _loc4_:* = 0;
         var _loc3_:Point = null;
         this.data = param1;
         var _loc2_:uint = Math.floor((param1 + 1) * 24 / 100);
         if(_loc2_ == this._du)
         {
            return;
         }
         this._du = _loc2_;
         maskQuadBatch.reset();
         _loc4_ = 0;
         while(_loc4_ < this._du)
         {
            mask.rotation = _loc4_ * 15 * 3.141592653589793 / 180;
            maskQuadBatch.addImage(mask);
            _loc4_++;
         }
         round.mask = maskQuadBatch;
         this.data = Math.min(this.data,100);
         this.data = Math.max(this.data,0);
         if(this.data == 100)
         {
            Starling.juggler.add(fireMC);
            fireMC.play();
            if(Constants.isFresh)
            {
               _loc3_ = parent.localToGlobal(new Point(this.x,this.y));
               fireMC.x = _loc3_.x + centerPoint.x;
               fireMC.y = _loc3_.y + centerPoint.y + r - 20;
               Starling.current.stage.addChild(fireMC);
            }
            else
            {
               addChild(fireMC);
            }
         }
         else if(Starling.juggler.contains(fireMC))
         {
            Starling.juggler.remove(fireMC);
            fireMC.stop();
            fireMC.removeFromParent();
         }
      }
      
      private function drawSector(param1:Graphics, param2:Number, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         param1.clear();
         param1.beginFill(16777215);
         param1.moveTo(param3,param3);
         param1.lineTo(param3 + param3 * Math.cos(-1.5707963267948966),param3 + param3 * Math.sin(-1.5707963267948966));
         var _loc6_:uint = Math.floor(param2 / 45);
         var _loc5_:Number = -1.5707963267948966;
         while(_loc6_-- > 0)
         {
            _loc5_ += 3.141592653589793 / 4;
            param1.curveTo(param3 + param3 / Math.cos(3.141592653589793 / 8) * Math.cos(_loc5_ - 3.141592653589793 / 8),param3 + param3 / Math.cos(3.141592653589793 / 8) * Math.sin(_loc5_ - 3.141592653589793 / 8),param3 + param3 * Math.cos(_loc5_),param3 + param3 * Math.sin(_loc5_));
         }
         if(param2 % 45)
         {
            _loc4_ = param2 % 45 * 3.141592653589793 / 180;
            param1.curveTo(param3 + param3 / Math.cos(_loc4_ / 2) * Math.cos(_loc5_ + _loc4_ / 2),param3 + param3 / Math.cos(_loc4_ / 2) * Math.sin(_loc5_ + _loc4_ / 2),param3 + param3 * Math.cos(_loc5_ + _loc4_),param3 + param3 * Math.sin(_loc5_ + _loc4_));
         }
         param1.endFill();
      }
      
      override public function dispose() : void
      {
         Starling.juggler.remove(fireMC);
         mask.texture.dispose();
         mask.dispose();
         maskQuadBatch.texture && maskQuadBatch.texture.dispose();
         maskQuadBatch.dispose();
         fireMC.dispose();
         super.dispose();
      }
      
      public function getImageBg() : Image
      {
         return bgRound;
      }
      
      override public function get visible() : Boolean
      {
         return super.visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         fireMC.visible = param1;
      }
   }
}

