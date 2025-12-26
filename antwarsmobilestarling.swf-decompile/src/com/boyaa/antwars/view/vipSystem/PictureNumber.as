package com.boyaa.antwars.view.vipSystem
{
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class PictureNumber extends Sprite
   {
      
      private var _number:int = 0;
      
      private var _numberArr:Vector.<Image> = new Vector.<Image>();
      
      public function PictureNumber()
      {
         super();
      }
      
      public function get number() : int
      {
         return _number;
      }
      
      public function set number(param1:int) : void
      {
         _number = param1;
         showNumbers();
      }
      
      private function showNumbers() : void
      {
         var _loc6_:int = 0;
         var _loc5_:String = null;
         var _loc3_:Image = null;
         this.removeChildren();
         var _loc2_:int = 0;
         var _loc4_:int = _number;
         while(_loc4_ != 0)
         {
            _loc4_ /= 10;
            _loc2_++;
         }
         var _loc1_:String = _number.toString();
         _loc6_ = 0;
         while(_loc6_ < _loc2_)
         {
            _loc5_ = _loc1_.charAt(_loc6_);
            if(_loc5_ == "0")
            {
               _loc5_ = "10";
            }
            _loc3_ = new Image(Assets.sAsset.getTexture("img_publicNum" + _loc5_));
            _numberArr.push(_loc3_);
            _loc3_.x = _loc6_ * _loc3_.width;
            this.addChild(_loc3_);
            _loc6_++;
         }
      }
   }
}

