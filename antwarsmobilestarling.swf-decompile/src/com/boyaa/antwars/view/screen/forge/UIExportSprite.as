package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UIExportSprite extends GuideSprite
   {
      
      protected var _layout:LayoutUitl;
      
      protected var _displayObj:Sprite = new Sprite();
      
      protected var _mask:DlgMark;
      
      public function UIExportSprite()
      {
         super();
         this.addChild(_displayObj);
         initialization();
      }
      
      protected function buildLayout(param1:String, param2:String) : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther(param1));
         _layout.buildLayout(param2,_displayObj);
      }
      
      protected function initialization() : void
      {
      }
      
      protected function showMark() : void
      {
         _mask = new DlgMark();
         _mask.setTouchHandle(removeSelf);
         this.addChildAt(_mask,0);
      }
      
      protected function addCloseButtonEvent(param1:String = null) : void
      {
         if(param1 == null)
         {
            param1 = "btnS_close";
         }
         getButtonByName(param1).addEventListener("triggered",onCloseHandle);
      }
      
      protected function onCloseHandle(param1:Event) : void
      {
         removeSelf();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.parent)
         {
            removeSelf();
         }
      }
      
      protected function removeSelf() : void
      {
         this.removeFromParent(true);
         if(_mask)
         {
            _mask.removeFromParent(true);
         }
      }
      
      public function getImageByName(param1:String, param2:Sprite = null) : Image
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Image;
         }
         return param2.getChildByName(param1) as Image;
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

