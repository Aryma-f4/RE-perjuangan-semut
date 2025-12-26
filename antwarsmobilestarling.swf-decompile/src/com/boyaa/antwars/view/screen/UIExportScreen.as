package com.boyaa.antwars.view.screen
{
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.Screen;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class UIExportScreen extends Screen
   {
      
      protected var _displayObj:Sprite;
      
      protected var _assets:ResAssetManager;
      
      protected var _layoutUtil:LayoutUitl;
      
      public function UIExportScreen()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _displayObj = new Sprite();
         addChild(_displayObj);
         _assets = Assets.sAsset;
      }
      
      public function getDisplayObjectByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      public function getTextFieldByName(param1:String, param2:Sprite = null) : TextField
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as TextField;
         }
         return param2.getChildByName(param1) as TextField;
      }
      
      public function getButtonByName(param1:String, param2:Sprite = null) : Button
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Button;
         }
         return param2.getChildByName(param1) as Button;
      }
      
      public function getSpriteByName(param1:String, param2:Sprite = null) : Sprite
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Sprite;
         }
         return param2.getChildByName(param1) as Sprite;
      }
      
      public function get displayObj() : Sprite
      {
         return _displayObj;
      }
      
      public function addChildToDisplayObject(param1:DisplayObject) : void
      {
         _displayObj.addChild(param1);
      }
   }
}

