package com.boyaa.antwars.view.screen.battlefield.element
{
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class StaticNumerView extends Sprite
   {
      
      public function StaticNumerView(param1:String, param2:int, param3:String = "")
      {
         var _loc8_:int = 0;
         var _loc10_:Image = null;
         var _loc7_:Image = null;
         super();
         var _loc11_:int = 0;
         var _loc5_:ResAssetManager = Assets.sAsset;
         var _loc9_:Image = new Image(_loc5_.getTexture(param1 + "0"));
         var _loc4_:int = _loc9_.width;
         var _loc6_:int = _loc9_.height;
         if(param2 == 0)
         {
            addChild(_loc9_);
            _loc11_++;
         }
         while(param2 > 0)
         {
            _loc8_ = param2 % 10;
            param2 /= 10;
            _loc10_ = new Image(_loc5_.getTexture(param1 + _loc8_));
            _loc10_.x = -_loc4_ * _loc11_;
            addChild(_loc10_);
            _loc11_++;
         }
         if(param3 == "+")
         {
            _loc7_ = new Image(_loc5_.getTexture(param1 + "add"));
            _loc7_.x = -_loc4_ * _loc11_;
            _loc7_.y = _loc6_ - _loc7_.height >> 1;
            addChild(_loc7_);
         }
         else if(param3 == "-")
         {
            _loc7_ = new Image(_loc5_.getTexture(param1 + "dec"));
            _loc7_.x = -_loc4_ * _loc11_;
            _loc7_.y = _loc6_ - _loc7_.height >> 1;
            addChild(_loc7_);
         }
         this.pivotX = -_loc4_ * _loc11_;
      }
   }
}

