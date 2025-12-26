package com.boyaa.antwars.view
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class BaseDlg extends GuideSprite
   {
      
      public static var DLG_ACTIVE_DONE:String = "DLG_ACTIVE_DONE";
      
      public static var DLG_DEACTIVE_DONE:String = "DLG_DEACTIVE_DONE";
      
      private var _autoDispose:Boolean;
      
      protected var _markBg:Quad;
      
      protected var _displayObj:Sprite;
      
      protected var _isLoadComplete:Boolean = false;
      
      public function BaseDlg(param1:Boolean = true)
      {
         super();
         _autoDispose = param1;
         _markBg = new Quad(1365,768,0);
         _markBg.alpha = 0.5;
         this.addChildAt(_markBg,0);
         _displayObj = new Sprite();
         this.addChild(_displayObj);
      }
      
      protected function initCommandButton() : void
      {
         getButtonByName("btnS_close") && getButtonByName("btnS_close").addEventListener("triggered",deActiveDone);
      }
      
      public function deactive() : void
      {
         Starling.juggler.tween(this,0.3,{
            "alpha":0,
            "transition":"easeIn",
            "onComplete":deActiveDone
         });
      }
      
      public function deActiveDone() : void
      {
         dispatchEvent(new Event("DLG_DEACTIVE_DONE"));
         if(this._autoDispose)
         {
            this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeFromParent();
      }
      
      public function active() : void
      {
         this.alpha = 0;
         Starling.juggler.tween(this,0.5,{
            "alpha":1,
            "transition":"easeInOut",
            "onComplete":activeDone
         });
      }
      
      protected function setDisplayObjectInMiddle() : void
      {
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
      }
      
      public function setMarkBgVisible(param1:Boolean) : void
      {
         _markBg.visible = param1;
      }
      
      public function activeDone() : void
      {
         dispatchEvent(new Event("DLG_ACTIVE_DONE"));
      }
      
      protected function getTextFieldByName(param1:String, param2:Sprite = null) : TextField
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as TextField;
         }
         return param2.getChildByName(param1) as TextField;
      }
      
      protected function getButtonByName(param1:String, param2:Sprite = null) : Button
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Button;
         }
         return param2.getChildByName(param1) as Button;
      }
      
      protected function getDisplayObjByName(param1:String, param2:Sprite = null) : DisplayObject
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1);
         }
         return param2.getChildByName(param1);
      }
      
      protected function getSpriteByName(param1:String, param2:Sprite = null) : Sprite
      {
         if(param2 == null)
         {
            return _displayObj.getChildByName(param1) as Sprite;
         }
         return param2.getChildByName(param1) as Sprite;
      }
   }
}

