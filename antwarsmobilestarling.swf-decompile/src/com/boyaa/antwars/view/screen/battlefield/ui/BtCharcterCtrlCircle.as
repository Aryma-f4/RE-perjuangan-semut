package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.view.character.CharacterCtrl;
   import com.boyaa.antwars.view.screen.battlefield.element.weapon.WeaponAngleRange;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.FreshGuideVlaue;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.Texture;
   import starling.utils.deg2rad;
   import starling.utils.rad2deg;
   
   public class BtCharcterCtrlCircle extends UIExportSprite
   {
      
      private var _charCtrl:CharacterCtrl;
      
      private var _point:DisplayObject;
      
      private var _memoryPoint:DisplayObject;
      
      private var _sector:Sprite;
      
      private var _angleRange:Array = [];
      
      private var _angle:Number = 0;
      
      private var sectorRadius:Number = 100;
      
      private var _isUsePlane:Boolean = false;
      
      private var _maxAngle:Number;
      
      private var _minAngle:Number;
      
      public function BtCharcterCtrlCircle(param1:CharacterCtrl)
      {
         super();
         _charCtrl = param1;
         init();
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("BattlefieldUI"));
         _layout.buildLayout("btUIControlCircle",_displayObj);
         _charCtrl.character.addChildAt(this,0);
         this.x = _charCtrl.character.x;
         this.y = _charCtrl.character.y - 150;
         this.scaleX = this.scaleY = 3;
         _point = getDisplayObjectByName("point");
         _memoryPoint = getDisplayObjectByName("memoryPoint");
         sectorRadius = _point.width;
         _sector = new Sprite();
         this.addChildAt(_sector,0);
         _angleRange = WeaponAngleRange.getWeaponRange(_charCtrl.character.wqGoods).concat();
         createSector(_angleRange[0],_angleRange[1] - _angleRange[0]);
         initAngle();
         Timepiece.instance.addFun(onPointMoveHandle);
      }
      
      private function initAngle() : void
      {
         if(FreshGuideVlaue.inFreshGame)
         {
            angle = minAngle;
         }
         else
         {
            angle = minAngle + (maxAngle - minAngle) / 2;
         }
      }
      
      public function changeToPlaneAngle() : void
      {
         _angleRange[0] = 1;
         _angleRange[1] = 89;
         createSector(_angleRange[0],_angleRange[1] - _angleRange[0]);
      }
      
      public function changeWeapon() : void
      {
         _angleRange = WeaponAngleRange.getWeaponRange(_charCtrl.character.wqGoods).concat();
         createSector(_angleRange[0],_angleRange[1] - _angleRange[0]);
         initAngle();
         if(angle >= _angleRange[1])
         {
            angle = _angleRange[1];
         }
         if(angle <= _angleRange[0])
         {
            angle = _angleRange[0];
         }
      }
      
      private function createSector(param1:Number, param2:Number) : void
      {
         _sector.removeChildren();
         var _loc6_:Shape = new Shape();
         _loc6_.graphics.beginFill(16772096,0.2);
         StarlingUITools.instance.drawSector(_loc6_.graphics,_point.x,_point.y,sectorRadius,deg2rad(param1),deg2rad(param2));
         _loc6_.graphics.endFill();
         var _loc3_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         _loc3_.draw(_loc6_);
         var _loc4_:Texture = Texture.fromData(_loc3_);
         _loc3_.dispose();
         var _loc5_:Image = new Image(_loc4_);
         _sector.addChild(_loc5_);
         _sector.scaleY = -1;
      }
      
      private function onPointMoveHandle() : void
      {
         _charCtrl.character.angle = getSHootAngle();
      }
      
      private function getSHootAngle() : Number
      {
         var _loc3_:Number = rad2deg(_point.rotation);
         var _loc2_:Number = rad2deg(_charCtrl.character.rotation);
         if(_charCtrl.character.scaleX < 0)
         {
            _loc3_ *= -1;
         }
         var _loc1_:Number = _loc2_ + _loc3_;
         if(_charCtrl.character.scaleX < 0)
         {
            return 180 - _loc1_;
         }
         return -_loc1_;
      }
      
      private function remove() : void
      {
         Timepiece.instance.removeFun(onPointMoveHandle,0);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         remove();
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      public function set angle(param1:Number) : void
      {
         _angle = param1;
         var _loc2_:Number = _angle;
         if(_loc2_ > _angleRange[1])
         {
            _loc2_ = Number(_angleRange[1]);
         }
         if(_loc2_ < _angleRange[0])
         {
            _loc2_ = Number(_angleRange[0]);
         }
         _point.rotation = -deg2rad(_loc2_);
         freshGuideChange();
      }
      
      public function get maxAngle() : Number
      {
         _maxAngle = _angleRange[1];
         return _maxAngle;
      }
      
      public function get minAngle() : Number
      {
         _minAngle = _angleRange[0];
         return _minAngle;
      }
      
      private function freshGuideChange() : void
      {
         if(!Constants.isFresh)
         {
            return;
         }
         var _loc1_:Number = getSHootAngle();
         if(FreshGuideVlaue.currentStepData)
         {
            if(FreshGuideVlaue.currentStepData[0] == "changeAngle")
            {
               if(FreshGuideVlaue.currentStepData[1] == _loc1_)
               {
                  EventCenter.GameEvent.dispatchEvent(new GameEvent("freshGuideComplete"));
               }
            }
         }
      }
   }
}

