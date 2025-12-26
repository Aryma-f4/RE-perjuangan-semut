package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.backpack.Backpack;
   import com.boyaa.antwars.view.screen.battlefield.element.EnergyBar;
   import com.boyaa.antwars.view.screen.shop.ShopBuyDlg;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class LessPowerDlg extends Sprite
   {
      
      private var _altas:ResAssetManager;
      
      private var _bg:Image;
      
      private var _buyButton:Button;
      
      private var _cancelButton:Button;
      
      private var _txt:TextField;
      
      private var _isHaveEnergyMedicine:Boolean = false;
      
      private var markBg:DlgMark;
      
      public function LessPowerDlg()
      {
         super();
         _altas = Assets.sAsset;
         init();
         addEventListener("addedToStage",onAddToState);
      }
      
      public static function show(param1:Sprite) : void
      {
         if(param1.getChildByName("lessPowerDlg"))
         {
            return;
         }
         var _loc2_:LessPowerDlg = new LessPowerDlg();
         _loc2_.name = "lessPowerDlg";
         param1.addChild(_loc2_);
         _loc2_.x = 1365 - _loc2_.width >> 1;
         _loc2_.y = 768 - _loc2_.height >> 1;
      }
      
      private function onAddToState(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToState);
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = 387;
         this.pivotY = 241;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.7,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeOutBack"
         });
      }
      
      private function init() : void
      {
         markBg = new DlgMark();
         enterBackpack();
         if(_isHaveEnergyMedicine)
         {
            _buyButton = new Button(_altas.getTexture("bb-13"),"",_altas.getTexture("bb-14"));
            _txt = new TextField(600,100,LangManager.t("lessPowerUse"));
         }
         else
         {
            _buyButton = new Button(_altas.getTexture("buy0"),"",_altas.getTexture("buy1"));
            _txt = new TextField(600,100,LangManager.t("lessPowerBuy"));
         }
         _bg = new Image(_altas.getTexture("bg3"));
         _cancelButton = new Button(_altas.getTexture("leave1"),"",_altas.getTexture("leave2"));
         _txt.fontSize = 30;
         _txt.bold = true;
         _txt.autoScale = true;
         Assets.positionDisplay(_buyButton,"lessPowerDlg","buy");
         Assets.positionDisplay(_cancelButton,"lessPowerDlg","cancel");
         Assets.positionDisplay(_txt,"lessPowerDlg","txt");
         _buyButton.addEventListener("triggered",onBuyButton);
         _cancelButton.addEventListener("triggered",onCancelButton);
         addChild(_bg);
         addChild(_buyButton);
         addChild(_cancelButton);
         addChild(_txt);
         EnergyBar.updatePlayerEnergy();
      }
      
      private function onCancelButton(param1:Event) : void
      {
         Starling.juggler.tween(this,0.5,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeInBack",
            "onComplete":cleanUp
         });
      }
      
      private function onBuyButton(param1:Event) : void
      {
         var _loc4_:ShopData = null;
         var _loc3_:ShopBuyDlg = null;
         var _loc2_:Backpack = null;
         if(!_isHaveEnergyMedicine)
         {
            _loc4_ = ShopDataList.instance.getSingleData(42,1021);
            _loc3_ = new ShopBuyDlg(true,_loc4_);
            Application.instance.currentGame.addChild(_loc3_);
            Starling.juggler.tween(this,0.5,{
               "scaleX":0,
               "scaleY":0,
               "transition":"easeInBack",
               "onComplete":cleanUp
            });
         }
         else
         {
            _loc2_ = Application.instance.currentGame.mainMenu.backpack;
            if(_loc2_.setUseGoodsData(42))
            {
               _loc2_.useProp();
            }
            else
            {
               TextTip.instance.show(LangManager.t("bbTip"));
               _isHaveEnergyMedicine = false;
               _buyButton.upState = _altas.getTexture("buy0");
               _buyButton.downState = _altas.getTexture("buy1");
               _txt.text = LangManager.t("lessPowerBuy");
            }
            Starling.juggler.delayCall(removeThis,0.5);
         }
      }
      
      private function removeThis() : void
      {
         if(PlayerDataList.instance.selfData.energy >= 3 && this != null)
         {
            Starling.juggler.tween(this,0.5,{
               "scaleX":0,
               "scaleY":0,
               "transition":"easeInBack",
               "onComplete":cleanUp
            });
            if(Application.instance.currentGame.navigator.activeScreenID == "COPYGAMEWORLD")
            {
               CopyGameTips.nextMission();
            }
         }
      }
      
      private function enterBackpack() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = GoodsList.instance.getPropsData();
         var _loc2_:int = int(_loc1_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_[_loc3_].typeID == 42)
            {
               _isHaveEnergyMedicine = true;
               break;
            }
            _isHaveEnergyMedicine = false;
            _loc3_++;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function cleanUp() : void
      {
         Starling.juggler.removeTweens(this);
         markBg.removeFromParent(true);
         removeFromParent(true);
         var _loc1_:Array = ["ZHUNHUANGWORLD","LEIENTWORLD"];
         if(_loc1_.indexOf(Application.instance.currentGame.navigator.activeScreenID) != -1)
         {
            Application.instance.currentGame.navigator.showScreen("TEAMLIST");
         }
      }
   }
}

