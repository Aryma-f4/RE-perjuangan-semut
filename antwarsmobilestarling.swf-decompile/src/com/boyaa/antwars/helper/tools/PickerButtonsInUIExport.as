package com.boyaa.antwars.helper.tools
{
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.events.Event;
   
   public class PickerButtonsInUIExport extends UIExportSprite
   {
      
      protected var _buttonsArr:Vector.<FashionStarlingButton>;
      
      private var _layoutName:String;
      
      private var _layoutBuildName:String;
      
      private var _buttonNum:int;
      
      private var _scale9Image:Scale9Image;
      
      private var _scale9PicName:String = "tips_scale9";
      
      private var _posArr:Array = [];
      
      public function PickerButtonsInUIExport(param1:String, param2:String, param3:int)
      {
         _layoutName = param1;
         _layoutBuildName = param2;
         _buttonNum = param3;
         super();
      }
      
      override protected function initialization() : void
      {
         var _loc2_:int = 0;
         var _loc1_:FashionStarlingButton = null;
         super.initialization();
         _buttonsArr = new Vector.<FashionStarlingButton>();
         buildLayout(_layoutName,_layoutBuildName);
         _loc2_ = 0;
         while(_loc2_ < _buttonNum)
         {
            _loc1_ = new FashionStarlingButton(getButtonByName("btn" + _loc2_));
            _loc1_.triggerFunction = onButtonClickHandle;
            _buttonsArr.push(_loc1_);
            _posArr.push(_loc1_.starlingBtn.bounds);
            _loc2_++;
         }
         _scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture(_scale9PicName),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _scale9Image.touchable = false;
         _displayObj.addChildAt(_scale9Image,0);
         update();
      }
      
      public function showButtonById(param1:Array, param2:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc3_:* = null;
         var _loc4_:Rectangle = null;
         if(param1 == null)
         {
            for each(_loc3_ in _buttonsArr)
            {
               _loc3_.starlingBtn.visible = param2;
            }
         }
         else
         {
            for each(_loc3_ in _buttonsArr)
            {
               _loc3_.starlingBtn.visible = !param2;
            }
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _buttonsArr[param1[_loc5_]].starlingBtn.visible = param2;
               _loc5_++;
            }
         }
         _loc5_ = 0;
         for each(_loc3_ in _buttonsArr)
         {
            if(_loc3_.starlingBtn.visible)
            {
               _loc4_ = _posArr[_loc5_];
               _loc3_.starlingBtn.x = _loc4_.x;
               _loc3_.starlingBtn.y = _loc4_.y;
               _loc5_++;
            }
         }
         update();
      }
      
      public function getButtonById(param1:int) : FashionStarlingButton
      {
         return _buttonsArr[param1];
      }
      
      private function onButtonClickHandle(param1:Event) : void
      {
         trace("btn click");
      }
      
      public function update() : void
      {
         _scale9Image.width = _displayObj.width;
         _scale9Image.height = getHeight();
      }
      
      private function getHeight() : Number
      {
         var _loc1_:Number = _displayObj.height;
         return _displayObj.height * getVisibleNum() / _buttonNum;
      }
      
      private function getVisibleNum() : int
      {
         var _loc2_:int = 0;
         for each(var _loc1_ in _buttonsArr)
         {
            if(_loc1_.starlingBtn.visible)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
   }
}

