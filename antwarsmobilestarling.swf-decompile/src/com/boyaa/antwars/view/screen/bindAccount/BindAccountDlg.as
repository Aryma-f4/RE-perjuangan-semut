package com.boyaa.antwars.view.screen.bindAccount
{
   import com.boyaa.ane.NCApiEvent;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.Hall;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.Tiptext;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Graphics;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class BindAccountDlg extends Sprite
   {
      
      private var _asset:ResAssetManager;
      
      private var _closeBtn:Button;
      
      private var _helpBtn:Button;
      
      private var _bindSinaBtn:Button;
      
      private var _bindBoyaaBtn:Button;
      
      private var _playerName:TextField;
      
      private var _goldCoin:TextField;
      
      private var _boyaaCoin:TextField;
      
      private var _level:TextField;
      
      private var _markBg:DlgMark;
      
      private var _bottomTip:TextField;
      
      private var _updateSignal:Signal;
      
      public function BindAccountDlg()
      {
         super();
         _asset = Assets.sAsset;
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(_loc1_.getResFile(formatString("asset/BindAccount.info")));
         _asset.loadQueue(loadComplete);
         _updateSignal = new Signal();
         _markBg = new DlgMark();
         addEventListener("addedToStage",onAddToStage);
      }
      
      private function onAddToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToStage);
         parent.addChild(_markBg);
         parent.swapChildren(_markBg,this);
      }
      
      private function loadComplete(param1:Number) : void
      {
         var _loc2_:LayoutUitl = null;
         if(param1 >= 1)
         {
            _loc2_ = new LayoutUitl(_asset.getOther("BindAccount"),_asset);
            _loc2_.buildLayout("bindAccount",this);
            init();
            this.pivotX = this.width >> 1;
            this.pivotY = this.height >> 1;
            this.scaleX = this.scaleY = 0;
            Starling.juggler.tween(this,0.4,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeInOut"
            });
         }
      }
      
      private function init() : void
      {
         _closeBtn = this.getChildByName("btnS_close") as Button;
         _helpBtn = this.getChildByName("btnS_help") as Button;
         _bindSinaBtn = this.getChildByName("btnS_sina") as Button;
         _bindBoyaaBtn = this.getChildByName("btnS_Boyaa") as Button;
         _goldCoin = this.getChildByName("goldCoinText") as TextField;
         _boyaaCoin = this.getChildByName("boyaaCoinText") as TextField;
         _playerName = this.getChildByName("playerName") as TextField;
         _bottomTip = this.getChildByName("bottomTipText") as TextField;
         _level = this.getChildByName("levelText") as TextField;
         _closeBtn.addEventListener("triggered",onCloseBtn);
         _helpBtn.addEventListener("triggered",onHelpBtn);
         _bindSinaBtn.addEventListener("triggered",onBindSinaBtn);
         _bindBoyaaBtn.addEventListener("triggered",onBindBoyaaBtn);
         addPlayerInfoToDlg();
      }
      
      private function addPlayerInfoToDlg() : void
      {
         var _loc3_:PlayerData = PlayerDataList.instance.selfData;
         var _loc2_:String = _loc3_.babyName;
         var _loc1_:int = _loc3_.level;
         var _loc4_:Character = CharacterFactory.instance.checkOutCharacter(_loc3_.babySex);
         _loc4_.initData(_loc3_.getPropData());
         _loc4_.touchable = false;
         addChild(_loc4_);
         _loc4_.scaleY = 0.6;
         _loc4_.scaleX = _loc4_.scaleY;
         _loc4_.x = getChildByName("playerPos").x;
         _loc4_.y = getChildByName("playerPos").y;
         _playerName.text = _loc2_;
         _level.text = String(_loc1_);
         _goldCoin.text = AccountData.instance.gameGold.toString();
         _boyaaCoin.text = AccountData.instance.boyaaCoin.toString();
      }
      
      private function onSinaWeiboLogin(param1:NCApiEvent) : void
      {
         Application.instance.weiboApi.removeEventListener("sinaweiboDidLogIn",onSinaWeiboLogin);
         Application.instance.log("LoginManager",param1.getParam());
         var _loc2_:Object = JSON.parse(param1.getParam());
         if(_loc2_.hasOwnProperty("ret") && _loc2_.ret == 0)
         {
            Application.instance.weiboApi.requestWithURL("users/show.json","uid=" + _loc2_.UserID,"GET");
         }
         else if(_loc2_.hasOwnProperty("uid"))
         {
            bindAccountReq(_loc2_.uid,2);
         }
         else
         {
            new Tiptext(LangManager.t("loginFail"));
         }
      }
      
      private function onRequestComplete(param1:NCApiEvent) : void
      {
         var _loc2_:Object = JSON.parse(param1.getParam());
         if((_loc2_.url as String).indexOf("users/show.json") != -1)
         {
            Application.instance.weiboApi.removeEventListener("requestComplete",onRequestComplete);
            Application.instance.log("LoginManager requestComplete",param1.getParam());
            if(_loc2_.ret == 0)
            {
               bindAccountReq(_loc2_.data.id,2);
            }
            else
            {
               new Tiptext(LangManager.t("loginFail"));
            }
         }
      }
      
      private function bindAccountReq(param1:int, param2:int) : void
      {
         var uid:int = param1;
         var type:int = param2;
         Remoting.instance.bindAccount([uid,type],function(param1:Object):void
         {
            Application.instance.log("BindAccount",JSON.stringify(param1));
         });
      }
      
      private function onBindBoyaaBtn(param1:Event) : void
      {
         TextTip.instance.showByLang("bindBoyaa");
      }
      
      private function onBindSinaBtn(param1:Event) : void
      {
         Application.instance.weiboApi.login();
         Application.instance.weiboApi.addEventListener("sinaweiboDidLogIn",onSinaWeiboLogin);
         Application.instance.weiboApi.addEventListener("requestComplete",onRequestComplete);
      }
      
      private function onHelpBtn(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("bindAccountHelper"));
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":dispose
         });
      }
      
      override public function dispose() : void
      {
         parent && parent.removeChild(this);
         _markBg.removeFromParent(true);
         super.dispose();
         var _loc1_:Hall = Application.instance.currentGame.navigator.activeScreen as Hall;
         _loc1_.posGuide();
      }
      
      public function get updateSignal() : Signal
      {
         return _updateSignal;
      }
      
      private function testQuad() : void
      {
         var _loc2_:Quad = new Quad(100,200);
         var _loc3_:Sprite = new Sprite();
         var _loc1_:Graphics = new Graphics(_loc3_);
         _loc1_.lineTexture(8,Assets.sAsset.getTexture("cutLine"));
         _loc1_.drawRoundRect(0,0,220,200,15);
         addChild(_loc3_);
         _loc3_.x = 300;
         _loc3_.y = 120;
      }
   }
}

