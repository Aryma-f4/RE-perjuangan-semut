package com.boyaa.antwars.view.ui.layout
{
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   
   public class TipDialogBg extends Sprite
   {
      
      private static const LEFT_TOP:String = "Tip_LeftTop";
      
      private static const CENTER_TOP:String = "Tip_CenterTop";
      
      private static const TOP_SCALE:String = "Tip_TopScale";
      
      private static const LEFT_SCALE:String = "Tip_LeftScale";
      
      private static const LEFT_BOTTOM:String = "Tip_LeftBottom";
      
      private static const BOTTOM_SCALE:String = "Tip_BottomScale";
      
      private static const CENTER_SCALE:String = "Tip_CenterScale";
      
      private var _dlgWidth:Number;
      
      private var _dlgHeight:Number;
      
      private var _texturesNameArr:Array = ["Tip_CenterScale","Tip_LeftTop","Tip_CenterTop","Tip_TopScale","Tip_LeftScale","Tip_LeftBottom","Tip_BottomScale"];
      
      private var _idArr:Array = [0,1,2,3,4,5,6];
      
      private var _imageArr:Vector.<Image>;
      
      private var _onePart:Sprite;
      
      private var _twoPart:Sprite;
      
      private var _scale9Image:Scale9Image;
      
      public function TipDialogBg(param1:Number, param2:Number)
      {
         super();
         _dlgHeight = param2;
         _dlgWidth = param1;
         createScale9Image();
         var _loc6_:Sprite = createTitle();
         var _loc4_:Sprite = createTitle();
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("q135"));
         _loc3_.x = _dlgWidth - _loc3_.width >> 1;
         _loc4_.scaleX = -1;
         _loc4_.x = _dlgWidth;
         var _loc5_:Quad = new Quad(_dlgWidth - 50,_dlgHeight - 50,16635288);
         _loc5_.x = 25;
         _loc5_.y = 25;
         addChild(_loc5_);
         addChild(_loc6_);
         addChild(_loc4_);
         addChild(_loc3_);
      }
      
      private function createTitle() : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("q137"));
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("q136"));
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("q135"));
         var _loc1_:Number = _dlgWidth / 2 - _loc3_.width - _loc5_.width / 2;
         if(_loc1_ > 0)
         {
            _loc4_.addChild(_loc2_);
            _loc2_.width = _loc1_ + 4;
            _loc2_.height -= 0.52;
            _loc2_.x = _loc3_.x + _loc3_.width - 1;
         }
         _loc4_.addChild(_loc3_);
         return _loc4_;
      }
      
      private function createScale9Image() : void
      {
         _scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tip_dlg_image"),new Rectangle(25,25,123,113)));
         _scale9Image.width = _dlgWidth;
         _scale9Image.height = _dlgHeight;
         addChild(_scale9Image);
      }
      
      private function createDlg() : void
      {
         _onePart = createHalf();
         _twoPart = createHalf();
         _twoPart.scaleX = -1;
         _twoPart.x = _onePart.width * 2 - 12;
         addChild(_onePart);
         addChild(_twoPart);
      }
      
      private function createHalf() : Sprite
      {
         var _loc4_:int = 0;
         var _loc1_:Image = null;
         var _loc3_:Sprite = new Sprite();
         _imageArr = new Vector.<Image>();
         _loc4_ = 0;
         while(_loc4_ < _texturesNameArr.length)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture(_texturesNameArr[_loc4_]));
            _loc1_.name = _texturesNameArr[_loc4_];
            _imageArr.push(_loc1_);
            _loc4_++;
         }
         getImageByName("Tip_TopScale").width = _dlgWidth - getImageByName("Tip_LeftTop").width - getImageByName("Tip_CenterTop").width;
         getImageByName("Tip_LeftScale").height = _dlgHeight - getImageByName("Tip_LeftTop").height - getImageByName("Tip_LeftBottom").height;
         getImageByName("Tip_BottomScale").width = _dlgWidth - getImageByName("Tip_LeftBottom").width;
         getImageByName("Tip_CenterScale").width = getImageByName("Tip_TopScale").width + getImageByName("Tip_CenterTop").width + 10;
         getImageByName("Tip_CenterScale").height = getImageByName("Tip_LeftScale").height + 10;
         var _loc2_:Number = 1;
         getImageByName("Tip_LeftTop").x = 0;
         getImageByName("Tip_TopScale").x = getImageByName("Tip_LeftTop").width - _loc2_;
         getImageByName("Tip_CenterTop").x = getImageByName("Tip_TopScale").x + getImageByName("Tip_TopScale").width - _loc2_;
         getImageByName("Tip_LeftScale").x = -1;
         getImageByName("Tip_LeftScale").y = getImageByName("Tip_LeftTop").height - _loc2_;
         getImageByName("Tip_LeftBottom").y = getImageByName("Tip_LeftScale").y + getImageByName("Tip_LeftScale").height - _loc2_;
         getImageByName("Tip_BottomScale").x = getImageByName("Tip_LeftBottom").x + getImageByName("Tip_LeftBottom").width - _loc2_;
         getImageByName("Tip_BottomScale").y = getImageByName("Tip_LeftBottom").y;
         getImageByName("Tip_CenterScale").x = getImageByName("Tip_LeftScale").x + getImageByName("Tip_LeftScale").width - 10;
         getImageByName("Tip_CenterScale").y = getImageByName("Tip_LeftTop").height - 5;
         _loc4_ = 0;
         while(_loc4_ < _texturesNameArr.length)
         {
            _loc3_.addChild(getImageByName(_texturesNameArr[_loc4_]));
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function getImageByName(param1:String) : Image
      {
         for each(var _loc2_ in _imageArr)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

