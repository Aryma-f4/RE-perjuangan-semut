package com.boyaa.antwars.sound
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.AntiAddictionDlg;
   import com.boyaa.antwars.view.screen.GameNotice;
   import com.boyaa.antwars.view.screen.rankList.RankListScreen;
   import feathers.controls.ScreenNavigator;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class GameConfigDlg extends Sprite
   {
      
      public static const HELPDLG:String = "helpDlg";
      
      private static var _exitSignal:Signal = new Signal(String);
      
      private var _bgImage:Image;
      
      private var _helpButton:Button;
      
      private var _suggestionButton:Button;
      
      private var _closeBtn:Button;
      
      private var _bgSoundRadio:Image;
      
      private var _bgActSoundRadio:Image;
      
      private var _atlas:ResAssetManager;
      
      private var _helpDlg:Sprite;
      
      private var _suggestionDlg:Sprite;
      
      private var _antiAddiction:AntiAddictionDlg;
      
      private var _noticeDlg:GameNotice;
      
      private var btnNotice:Button;
      
      private var _exitGameBtn:Button;
      
      private var btnCertificate:Button;
      
      private var _fansBtn:Button;
      
      private var version:TextField;
      
      private var privacyPolicy:Button;
      
      private var termsofservice:Button;
      
      private var markBg:DlgMark;
      
      public function GameConfigDlg(param1:Boolean = false)
      {
         super();
         init(param1);
         addEventListener("addedToStage",onAddedToStage);
      }
      
      public static function get exitSignal() : Signal
      {
         return _exitSignal;
      }
      
      private function init(param1:Boolean = false) : void
      {
         markBg = new DlgMark();
         _atlas = Assets.sAsset;
         _bgImage = new Image(_atlas.getTexture("bg3"));
         addChild(_bgImage);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("set_title"));
         Assets.positionDisplay(_loc2_,"configDlg","title");
         addChild(_loc2_);
         _closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.positionDisplay(_closeBtn,"configDlg","closeBtn");
         _closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(_closeBtn);
         _helpButton = new Button(_atlas.getTexture("sz6"),"",_atlas.getTexture("sz7"));
         Assets.positionDisplay(_helpButton,"configDlg","helpBtn");
         _helpButton.addEventListener("triggered",onHelpBtn);
         addChild(_helpButton);
         _fansBtn = new Button(_atlas.getTexture("fansBtn01"),"",_atlas.getTexture("fansBtn02"));
         Assets.positionDisplay(_fansBtn,"configDlg","fansBtn");
         _fansBtn.addEventListener("triggered",onFansBtn);
         addChild(_fansBtn);
         if(Constants.lanVersion == 1)
         {
            btnCertificate = new Button(_atlas.getTexture("but1"),"",_atlas.getTexture("but2"));
            Assets.positionDisplay(btnCertificate,"configDlg","btnCertificate");
            btnCertificate.addEventListener("triggered",onCertificateBtn);
            addChild(btnCertificate);
            if(PlayerDataList.instance.selfData.isAdult)
            {
               btnCertificate.enabled = false;
            }
         }
         if(!param1)
         {
            _suggestionButton = new Button(_atlas.getTexture("sz8"),"",_atlas.getTexture("sz9"));
            Assets.positionDisplay(_suggestionButton,"configDlg","suggestionBtn");
            _suggestionButton.addEventListener("triggered",onSuggestionBtn);
            addChild(_suggestionButton);
         }
         else
         {
            _exitGameBtn = new Button(_atlas.getTexture("sz14"),"",_atlas.getTexture("sz15"));
            Assets.positionDisplay(_exitGameBtn,"configDlg","suggestionBtn");
            _exitGameBtn.addEventListener("triggered",onExitGameBtn);
            addChild(_exitGameBtn);
         }
         if(SoundManager.bgSoundSwitch)
         {
            _bgSoundRadio = new Image(_atlas.getTexture("sz3"));
         }
         else
         {
            _bgSoundRadio = new Image(_atlas.getTexture("sz2"));
         }
         Assets.positionDisplay(_bgSoundRadio,"configDlg","bgSound");
         _bgSoundRadio.addEventListener("touch",onSoundSwitch);
         addChild(_bgSoundRadio);
         if(SoundManager.soundSwitch)
         {
            _bgActSoundRadio = new Image(_atlas.getTexture("sz5"));
         }
         else
         {
            _bgActSoundRadio = new Image(_atlas.getTexture("sz4"));
         }
         Assets.positionDisplay(_bgActSoundRadio,"configDlg","bgActSound");
         _bgActSoundRadio.addEventListener("touch",onActSoundSwich);
         addChild(_bgActSoundRadio);
         version = new TextField(250,50,Application.instance.version,"Verdana",12,4991758,true);
         version.x = _bgImage.width - version.width - 280;
         version.y = _bgImage.height - version.height - 20;
         version.autoScale = true;
         addChild(version);
         if(Constants.lanVersion == 1)
         {
            privacyPolicy = new Button(_atlas.getTexture("sz20"),"",_atlas.getTexture("sz21"));
            Assets.positionDisplay(privacyPolicy,"configDlg","btn_private");
            privacyPolicy.addEventListener("triggered",onPrivacyPolicy);
            addChild(privacyPolicy);
            termsofservice = new Button(_atlas.getTexture("sz22"),"",_atlas.getTexture("sz23"));
            Assets.positionDisplay(termsofservice,"configDlg","btm_service");
            termsofservice.addEventListener("triggered",onTermsofservice);
            addChild(termsofservice);
         }
      }
      
      private function onFansBtn(param1:Event) : void
      {
         var _loc2_:String = "https://www.facebook.com/PerjuangansemutAndroid";
         navigateToURL(new URLRequest(_loc2_));
      }
      
      private function onTermsofservice(param1:Event) : void
      {
         var _loc2_:String = LangManager.t("termsofserviceUrl");
         navigateToURL(new URLRequest(_loc2_));
      }
      
      private function onPrivacyPolicy(param1:Event) : void
      {
         var _loc2_:String = LangManager.t("privacyPolicyUrl");
         navigateToURL(new URLRequest(_loc2_));
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
         this.pivotX = 387;
         this.pivotY = 241;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
      }
      
      private function onExitGameBtn(param1:Event) : void
      {
         var detail:CopyDetailData;
         var e:Event = param1;
         var navigator:ScreenNavigator = Application.instance.currentGame.navigator;
         if(navigator.activeScreenID == "BATTLEFIELD" || navigator.activeScreenID == "ROBOTBATTLEFIELD" || navigator.activeScreenID == "ROBOT_2VS2_BATTLEFIELD")
         {
            if(BattleServer.instance.isConnect)
            {
               BattleServer.instance.close();
            }
            if(RankListScreen.isRankFight)
            {
               navigator.activeScreen.dispatchEventWith("showRank");
            }
            else
            {
               navigator.activeScreen.dispatchEventWith("exit");
            }
         }
         else if(navigator.activeScreenID == "COPYGAMEWORLD")
         {
            detail = CopyList.instance.currentCopyData;
            if(CopyServer.instance.isConnect)
            {
               CopyServer.instance.close();
            }
            switch(detail.cpid - 1)
            {
               case 0:
                  navigator.activeScreen.dispatchEventWith("complete");
                  break;
               case 1:
                  navigator.activeScreen.dispatchEventWith("showSpiderCity");
                  break;
               case 2:
                  navigator.activeScreen.dispatchEventWith("showSpriteCity");
                  break;
               default:
                  navigator.activeScreen.dispatchEventWith("exit");
            }
         }
         else if(navigator.activeScreenID == "ZHUNHUANGWORLD" || navigator.activeScreenID == "LEIENTWORLD")
         {
            CopyServer.instance.leaveRoom();
            Starling.juggler.delayCall(function():void
            {
               navigator.showScreen("TEAMLIST");
            },0.15);
         }
         else if(navigator.activeScreenID == "ENDLESSTOWERWORLD")
         {
            exitSignal.dispatch("ENDLESSTOWERWORLD");
         }
         else
         {
            navigator.activeScreen.dispatchEventWith("complete");
         }
         PlayerDataList.instance.removePlayers();
         onExit();
      }
      
      private function onActSoundSwich(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(stage);
         if(_loc2_.phase == "ended")
         {
            if(SoundManager.soundSwitch)
            {
               _bgActSoundRadio.texture = _atlas.getTexture("sz4");
            }
            else
            {
               _bgActSoundRadio.texture = _atlas.getTexture("sz5");
            }
            SoundManager.soundSwitch = !SoundManager.soundSwitch;
            trace(SoundManager.soundSwitch);
         }
      }
      
      private function onSoundSwitch(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(stage);
         if(_loc2_.phase == "ended")
         {
            if(SoundManager.bgSoundSwitch)
            {
               _bgSoundRadio.texture = _atlas.getTexture("sz2");
            }
            else
            {
               _bgSoundRadio.texture = _atlas.getTexture("sz3");
            }
            SoundManager.bgSoundSwitch = !SoundManager.bgSoundSwitch;
         }
      }
      
      private function onHelpBtn(param1:Event) : void
      {
         _helpDlg = new HelpDlg();
         Application.instance.currentGame.stage.addChild(_helpDlg);
         _helpDlg.x = 1365 - _helpDlg.width >> 1;
         _helpDlg.y = 768 - _helpDlg.height >> 1;
      }
      
      private function onSuggestionBtn(param1:Event) : void
      {
         _suggestionDlg = new SuggestionDlg();
         this.parent.addChild(_suggestionDlg);
         _suggestionDlg.x = 1365 - _suggestionDlg.width >> 1;
         _suggestionDlg.y = 768 - _suggestionDlg.height >> 1;
      }
      
      private function onCertificateBtn(param1:Event) : void
      {
         if(Constants.lanVersion != 1)
         {
            return;
         }
         _antiAddiction = new AntiAddictionDlg();
         Application.instance.currentGame.stage.addChild(_antiAddiction);
         _antiAddiction.x = (1365 - _antiAddiction.width >> 1) + 15;
         _antiAddiction.y = 768 - _antiAddiction.height >> 1;
      }
      
      private function onNoticeBtn(param1:Event) : void
      {
         _noticeDlg = new GameNotice();
         _noticeDlg.show(false);
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         _closeBtn.removeEventListener("triggered",onCloseBtn);
         Starling.juggler.tween(this,0.2,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":onExit
         });
      }
      
      private function onExit() : void
      {
         Starling.juggler.removeTweens(this);
         markBg.removeFromParent(true);
         this.parent.removeChild(this);
      }
   }
}

