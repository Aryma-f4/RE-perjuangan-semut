package com.boyaa.antwars.view.ui
{
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class LayoutListItemRender extends ListItemRenderer
   {
      
      protected var _layoutUtil:LayoutUitl;
      
      protected var _displayObject:Sprite;
      
      protected var _isGray:Boolean = false;
      
      public function LayoutListItemRender()
      {
         super();
         _displayObject = new Sprite();
         addChild(_displayObject);
      }
      
      protected function buildLayoutByName(param1:String, param2:String) : void
      {
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther(param1));
         _layoutUtil.buildLayout(param2,_displayObject);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
      }
      
      override protected function commitData() : void
      {
         super.commitData();
      }
      
      protected function initOriginRenderItems() : void
      {
         this.bg = new Image(Assets.emptyTexture());
         this.bg.width = _displayObject.width;
         this.bg.height = _displayObject.height;
         this.bgNormalTexture = Assets.emptyTexture();
         this.bgFocusTexture = Assets.emptyTexture();
      }
      
      public function getDisplayObjectByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObject.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      public function getTextFieldByName(param1:String, param2:Sprite = null) : TextField
      {
         if(param2 == null)
         {
            return _displayObject.getChildByName(param1) as TextField;
         }
         return param2.getChildByName(param1) as TextField;
      }
      
      public function getButtonByName(param1:String, param2:Sprite = null) : Button
      {
         if(param2 == null)
         {
            return _displayObject.getChildByName(param1) as Button;
         }
         return param2.getChildByName(param1) as Button;
      }
      
      public function getSpriteByName(param1:String, param2:Sprite = null) : Sprite
      {
         if(param2 == null)
         {
            return _displayObject.getChildByName(param1) as Sprite;
         }
         return param2.getChildByName(param1) as Sprite;
      }
      
      public function getImageByName(param1:String, param2:Sprite = null) : Image
      {
         if(param2 == null)
         {
            return _displayObject.getChildByName(param1) as Image;
         }
         return param2.getChildByName(param1) as Image;
      }
      
      public function get isGray() : Boolean
      {
         return _isGray;
      }
      
      public function set isGray(param1:Boolean) : void
      {
         _isGray = param1;
         if(_isGray)
         {
            this.touchable = false;
            this.filter = StarlingUITools.instance.getGrayFilter();
         }
         else
         {
            this.touchable = true;
         }
      }
   }
}

