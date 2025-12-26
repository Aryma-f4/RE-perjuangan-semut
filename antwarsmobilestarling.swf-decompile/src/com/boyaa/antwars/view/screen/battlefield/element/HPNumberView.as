package com.boyaa.antwars.view.screen.battlefield.element
{
   import starling.display.Image;
   
   public class HPNumberView extends NumberView
   {
      
      public function HPNumberView(param1:Number, param2:Number)
      {
         super("flnum",param1,param2);
         numWidth -= 5;
      }
      
      override protected function drawView() : void
      {
         var _loc3_:Image = null;
         var _loc5_:Image = null;
         var _loc4_:int = _number;
         var _loc7_:int = _loc4_ / 100;
         var _loc6_:int = _loc4_ / 10 % 10;
         var _loc8_:int = _loc4_ % 10;
         if(_loc7_ > 0)
         {
            _loc3_ = getImage(_loc7_.toString());
            _loc3_.x = 0;
            _loc3_.y = __height - _loc3_.height >> 1;
            this.pushDrawImage(_loc3_);
         }
         if(_loc7_ > 0 || _loc7_ == 0 && _loc6_ > 0)
         {
            _loc5_ = getImage(_loc6_.toString());
            _loc5_.x = numWidth;
            _loc5_.y = __height - _loc5_.height >> 1;
            this.pushDrawImage(_loc5_);
         }
         var _loc2_:Image = getImage(_loc8_.toString());
         _loc2_.x = numWidth * 2;
         _loc2_.y = __height - _loc2_.height >> 1;
         this.pushDrawImage(_loc2_);
         var _loc1_:Image = getImage("bfh");
         _loc1_.x = numWidth * 3;
         _loc1_.y = __height - _loc1_.height >> 1;
         this.pushDrawImage(_loc1_);
      }
   }
}

