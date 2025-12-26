package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.screen.battlefield.Battlefield;
   import com.boyaa.antwars.view.screen.battlefield.BtUILayer;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.fresh.FreshGuideVlaue;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.ui.layout.EasyFunctions;
   import starling.display.DisplayObject;
   import starling.display.Sprite;
   import starling.events.EnterFrameEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class BtControlBar extends EasyFunctions
   {
      
      public static const KEDU:int = 100;
      
      private var _shootButton:FashionStarlingButton;
      
      private var _powerBar:DisplayObject;
      
      private var _memoryBar:DisplayObject;
      
      private var _powerWidth:Number;
      
      private var _isTouchButton:Boolean = false;
      
      private const OFFIST:Number = 4;
      
      private var _uiLayer:BtUILayer;
      
      private var _isShow:Boolean = false;
      
      private var _visible:Boolean = true;
      
      private var _scaleNum:Number = 0;
      
      private var _flag:Number = 4;
      
      public function BtControlBar(param1:Sprite)
      {
         super(param1);
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         _powerBar = getDisplayObjectByName("powerItem");
         _memoryBar = getDisplayObjectByName("memoryItem");
         _powerWidth = _powerBar.width;
         _shootButton = new FashionStarlingButton(getButtonByName("shootBtn"));
         _shootButton.starlingBtn.addEventListener("touch",onShootButtonTouch);
         SmallCodeTools.instance.setDisplayObjectInWidthScreen("right",_displayObj);
         _powerBar.scaleX = 0;
         _memoryBar.scaleX = 0;
         Application.instance.currentGame.stage.addEventListener("enterFrame",onPowerBarChangeHandle);
         EventCenter.GameEvent.addEventListener("freshGame",onFreshGameHandle);
      }
      
      private function onFreshGameHandle(param1:GameEvent) : void
      {
         var _loc2_:Array = param1.param as Array;
         if(_loc2_[0] == "shoot")
         {
            _memoryBar.scaleX = _loc2_[1] / 100;
            GuideTipManager.instance.showByDisplayObject(_shootButton.starlingBtn);
         }
      }
      
      private function onPowerBarChangeHandle(param1:EnterFrameEvent) : void
      {
         if(!_isTouchButton)
         {
            return;
         }
         if(_scaleNum > _powerWidth || _scaleNum < 0)
         {
            _flag = -_flag;
         }
         _scaleNum += _flag;
         _powerBar.scaleX = Math.max(0,Math.min(1,_scaleNum / _powerWidth));
         if(_scaleNum < 0)
         {
            _isTouchButton = false;
         }
      }
      
      private function onShootButtonTouch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(_shootButton.starlingBtn);
         if(!_loc2_)
         {
            return;
         }
         if(!selfCharacerCtrl.isCtrl)
         {
            return;
         }
         if(_loc2_.phase == "began")
         {
            _isTouchButton = true;
            _scaleNum = 0;
            _flag = 4;
            _shootButton.isSelect = true;
         }
         if(_loc2_.phase == "ended")
         {
            _isTouchButton = false;
            _shootButton.isSelect = false;
            _memoryBar.scaleX = _powerBar.scaleX;
            if(FreshGuideVlaue.inFreshGame && FreshGuideVlaue.currentStepData.length != 0 && FreshGuideVlaue.currentStepData[0] == "shoot")
            {
               _powerBar.scaleX = FreshGuideVlaue.currentStepData[1] / 100;
               _memoryBar.scaleX = _powerBar.scaleX;
               GuideTipManager.instance.stopGuide();
            }
            selfCharacerCtrl.character.velocity = _powerBar.scaleX * 100;
            selfCharacerCtrl.shootInControlBar();
         }
      }
      
      public function get selfCharacerCtrl() : SelfCharacterCtrl
      {
         if(_uiLayer.getGameWorld() is Battlefield)
         {
            return Battlefield(_uiLayer.getGameWorld()).selfCharacterCtrl;
         }
         return GameWorld(_uiLayer.getGameWorld()).selfCharacterCtrl;
      }
      
      public function get uiLayer() : BtUILayer
      {
         return _uiLayer;
      }
      
      public function set uiLayer(param1:BtUILayer) : void
      {
         _uiLayer = param1;
      }
      
      public function get isShow() : Boolean
      {
         return _isShow;
      }
      
      public function set isShow(param1:Boolean) : void
      {
         _isShow = param1;
         if(_isShow)
         {
            _displayObj.visible = true;
         }
         else
         {
            _displayObj.visible = false;
         }
      }
      
      public function get shootButton() : FashionStarlingButton
      {
         return _shootButton;
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         _visible = param1;
         _displayObj.visible = param1;
         _shootButton.isSelect = !param1;
      }
   }
}

