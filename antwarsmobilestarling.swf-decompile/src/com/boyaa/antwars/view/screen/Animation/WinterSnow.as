package com.boyaa.antwars.view.screen.Animation
{
   import com.boyaa.antwars.helper.Timepiece;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class WinterSnow
   {
      
      private var _snowArr:Array = [];
      
      private const SNOW_NUM:int = 100;
      
      public function WinterSnow()
      {
         super();
      }
      
      public function show(param1:DisplayObjectContainer = null) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Sprite = null;
         var _loc5_:Image = null;
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc6_ = 0;
         while(_loc6_ < 100)
         {
            _loc3_ = new Sprite();
            _loc5_ = new Image(Assets.sAsset.getTexture("snow"));
            _loc3_.addChild(_loc5_);
            _loc3_.x = 1365 * Math.random();
            _loc3_.y = 768 * Math.random();
            _loc3_.alpha = 5 + 95 * Math.random();
            _loc3_.scaleX = _loc3_.scaleY = (5 + 125 * Math.random()) / 100;
            _loc4_ = 4 * Math.random() + 1;
            _loc2_ = 2 * (Math.random() - Math.random());
            _snowArr.push([_loc3_,_loc4_,_loc2_]);
            if(!param1)
            {
               param1 = Application.instance.currentGame.stage;
            }
            param1.addChild(_loc3_);
            _loc6_++;
         }
         Timepiece.instance.addFun(onMove);
      }
      
      public function remove() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         var _loc1_:Sprite = null;
         Timepiece.instance.removeFun(onMove);
         _loc3_ = 0;
         while(_loc3_ < _snowArr.length)
         {
            _loc2_ = _snowArr[_loc3_];
            _loc1_ = _loc2_[0];
            _loc1_.removeFromParent(true);
            _loc3_++;
         }
      }
      
      private function onMove() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         var _loc1_:Sprite = null;
         _loc3_ = 0;
         while(_loc3_ < _snowArr.length)
         {
            _loc2_ = _snowArr[_loc3_];
            _loc1_ = _loc2_[0];
            _loc1_.x += _loc2_[1];
            _loc1_.y += _loc2_[1];
            if(_loc1_.y > 768)
            {
               _loc1_.y = 0;
            }
            if(_loc1_.x > 1365)
            {
               _loc1_.x = 0;
            }
            if(_loc1_.x < 0)
            {
               _loc1_.x = 1365;
            }
            _loc3_++;
         }
      }
   }
}

