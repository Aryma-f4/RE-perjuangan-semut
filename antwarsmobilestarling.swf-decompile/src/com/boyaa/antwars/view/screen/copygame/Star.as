package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.tool.TweenQueue;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.utils.deg2rad;
   
   public class Star extends Sprite
   {
      
      private var imgStarBg:Image;
      
      public var starNum:int = 3;
      
      private var starArr:Array;
      
      public function Star()
      {
         var _loc3_:int = 0;
         var _loc1_:Image = null;
         var _loc2_:int = 0;
         starArr = [];
         super();
         imgStarBg = new Image(Assets.sAsset.getTexture("fb10"));
         imgStarBg.y = 6;
         addChild(imgStarBg);
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture("fb11"));
            _loc1_.pivotX = _loc1_.pivotY = _loc1_.width / 2;
            starArr.push(_loc1_);
            addChild(_loc1_);
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            starArr[_loc2_].x = _loc2_ * (starArr[_loc2_].width - 4) + starArr[_loc2_].width / 2 - 5;
            starArr[_loc2_].y = starArr[_loc2_].height / 2;
            _loc2_++;
         }
         this.touchable = false;
      }
      
      public function updateStarNum(param1:int) : void
      {
         var _loc6_:int = 0;
         var _loc3_:Image = null;
         var _loc5_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < 3)
         {
            _loc3_ = starArr[_loc6_] as Image;
            _loc3_.alpha = 0;
            _loc3_.scaleX = _loc3_.scaleY = 2;
            _loc6_++;
         }
         imgStarBg.visible = true;
         var _loc4_:int = param1;
         _loc4_ = int(_loc4_ > 3 ? 3 : _loc4_);
         var _loc2_:TweenQueue = new TweenQueue();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_.add(starArr[_loc5_],1,{
               "alpha":1,
               "scaleX":1,
               "scaleY":1,
               "rotation":deg2rad(360)
            },"easeInOutBack");
            _loc5_++;
         }
         _loc2_.start();
      }
      
      override public function dispose() : void
      {
         parent && parent.removeChild(this);
         super.dispose();
      }
   }
}

