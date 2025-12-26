package com.boyaa.antwars.view.screen.menu
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.ModelOpenContrl;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.activity.ActivityWebDlg;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.sign.NewSignInDlg;
   import com.boyaa.antwars.view.vipSystem.VipViewDlg;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.events.Event;
   
   public class VerticalMenu extends UIExportSprite
   {
      
      public static const ACTIVITY_BUTTON:String = "activityBtn";
      
      public static const SIGNIN_BUTTON:String = "signInBtn";
      
      public static const PAYMENT_BUTTON:String = "paymentBtn";
      
      public static const VIP_BUTTON:String = "vipBtn";
      
      private var _buttonsNameArr:Array = ["activityBtn","signInBtn","paymentBtn","vipBtn"];
      
      private var _buttons:Dictionary = new Dictionary();
      
      private var _activityBtn:MenuButton;
      
      private var _signInBtn:MenuButton;
      
      private var _paymentBtn:MenuButton;
      
      private var _vipBtn:MenuButton;
      
      public function VerticalMenu()
      {
         super();
      }
      
      override protected function initialization() : void
      {
         super.initialization();
         buildLayout("publicComponent","scrollMenu");
         initButtons();
         initOtherData();
      }
      
      private function initOtherData() : void
      {
         PlayerDataList.instance.selfData.isSigned ? updateSignState(true) : updateSignState(false);
         PlayerDataList.instance.selfData.signedSiganal.addOnce(onSignedSignal);
      }
      
      private function onSignedSignal() : void
      {
         updateSignState(true);
      }
      
      private function updateSignState(param1:Boolean) : void
      {
         if(param1)
         {
            _signInBtn.tipNum = 0;
         }
         else
         {
            _signInBtn.tipNum = 1;
         }
      }
      
      private function initButtons() : void
      {
         var _loc1_:MenuButton = null;
         for each(var _loc2_ in _buttonsNameArr)
         {
            this["_" + _loc2_] = new MenuButton(getButtonByName(_loc2_));
            _loc1_ = this["_" + _loc2_];
            _loc1_.triggerFunction = onButtonTouchHandle;
            _buttons[_loc2_] = _loc1_;
         }
      }
      
      private function onButtonTouchHandle(param1:Event) : void
      {
         var _loc2_:Button = param1.target as Button;
         var _loc3_:MenuButton = _buttons[_loc2_.name];
         switch(_loc2_.name)
         {
            case "activityBtn":
               showActivity();
               break;
            case "signInBtn":
               signIn();
               break;
            case "paymentBtn":
               payment();
               break;
            case "vipBtn":
               vip();
         }
      }
      
      private function showActivity() : void
      {
         if(!ModelOpenContrl.instance.checkIsOpen("open_activity"))
         {
            TextTip.instance.show(LangManager.replace("openActityLevel",ModelOpenContrl.instance.getModelValue("open_activity")));
            return;
         }
         Starling.current.stage.addChild(new ActivityWebDlg());
      }
      
      private function signIn() : void
      {
         Guide.instance.stop();
         var _loc1_:NewSignInDlg = new NewSignInDlg();
         _loc1_.signedSignal.add(onSignedSignal);
         Starling.current.stage.addChild(_loc1_);
         _loc1_.x = (1365 - _loc1_.width >> 1) + 35;
         _loc1_.y = 768 - _loc1_.height >> 1;
      }
      
      private function payment() : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function vip() : void
      {
         new VipViewDlg();
      }
      
      public function get activityBtn() : MenuButton
      {
         return _activityBtn;
      }
      
      public function get signInBtn() : MenuButton
      {
         return _signInBtn;
      }
      
      public function get paymentBtn() : MenuButton
      {
         return _paymentBtn;
      }
      
      public function get vipBtn() : MenuButton
      {
         return _vipBtn;
      }
   }
}

