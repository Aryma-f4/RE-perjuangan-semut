package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.shop.BuyDlg;
   import com.boyaa.antwars.view.screen.shop.ShopManager;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.smallTools.boyaaCode.scrollText.BoyaaScrollText;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class WeddingDlg extends GuideSprite implements IGuideProcess
   {
      
      private const EXCHANGE_SPRITE:String = "exchangeSprite";
      
      private const POP_INFO:String = "popInfo";
      
      private const DIVORCEINFO:String = "divorceInfo";
      
      private const DIVORCEBTNS_GROUP:String = "divorceBtnsGroup";
      
      private const WEDDING_SPRITE:String = "weddingSprite";
      
      private var _layout:LayoutUitl;
      
      private var _exchangeSprite:Sprite;
      
      private var _popInfo:Sprite;
      
      private var _divorceInfo:Sprite;
      
      private var _divorceBtnsGroup:Sprite;
      
      private var _weddingSprite:Sprite;
      
      private var _backBgSprite:Sprite;
      
      private var _spArr:Array = ["exchangeSprite","popInfo","divorceInfo","divorceBtnsGroup","weddingSprite"];
      
      private var _popBtn:Button;
      
      private var _weddingBtn:Button;
      
      private var _divorceBtn:Button;
      
      private var _exchangeBtn:Button;
      
      private var _closeBtn:Button;
      
      private var _helpBtn:Button;
      
      private var _btnTextureArr:Array = [];
      
      private var _btnNameArr:Array = ["popBtn","weddingBtn","divorceBtn","exchangeBtn","closeBtn","helpBtn"];
      
      private var _dlgMark:DlgMark;
      
      private const MARRYPRICE:Array = [99,1999,4999];
      
      private var _popInfoScrollTxt:BoyaaScrollText;
      
      private var _currentWeddingSceneIndex:int = 1;
      
      public function WeddingDlg()
      {
         super();
         loadAssets();
      }
      
      private function loadAssets() : void
      {
         var rmger:ResManager = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/OTHER/wedding.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/OTHER/wedding.xml",Assets.sAsset.scaleFactor)));
         Application.instance.currentGame.showLoading();
         Assets.sAsset.loadQueue((function():*
         {
            var load:Function;
            return load = function(param1:Number):void
            {
               if(param1 == 1)
               {
                  Application.instance.currentGame.hiddenLoading();
                  init();
               }
            };
         })());
      }
      
      private function init() : void
      {
         var _loc1_:int = 0;
         _dlgMark = new DlgMark();
         parent.addChild(_dlgMark);
         parent.swapChildren(_dlgMark,this);
         _layout = new LayoutUitl(Assets.sAsset.getOther("wedding"),Assets.sAsset);
         _layout.buildLayout("weddingLayout",this);
         this.x = (1365 - this.width) / 2;
         _backBgSprite = this.getChildByName("bgSprite") as Sprite;
         _loc1_ = 0;
         while(_loc1_ < _spArr.length)
         {
            this["_" + _spArr[_loc1_]] = getChildByName(_spArr[_loc1_]) as Sprite;
            this["_" + _spArr[_loc1_]].visible = false;
            _loc1_++;
         }
         initText();
         initButtons();
         onListButtonHandle(null);
         bindNet();
         changeWeddingText();
         GameServer.instance.weddingGetWeddingMsg();
         guideProcess();
      }
      
      private function bindNet() : void
      {
         GameServer.instance.onWeddingMarry(6039,onEnterWeddingMsgHandle);
         GameServer.instance.onWeddingMarry(6038,onWeddingMarryBack);
      }
      
      private function unBindNet() : void
      {
         GameServer.instance.disposeRecvFun(onEnterWeddingMsgHandle);
         GameServer.instance.disposeRecvFun(onWeddingMarryBack);
      }
      
      private function initText() : void
      {
         var _loc1_:TextField = _popInfo.getChildByName("popInfoTxt") as TextField;
         _popInfoScrollTxt = new BoyaaScrollText(_loc1_.width,_loc1_.height,"","Verdana",30,0);
         _popInfoScrollTxt.text = LangManager.t("popInfo");
         SmallCodeTools.instance.setDisplayObjectInSamePos(_loc1_,_popInfoScrollTxt);
         _popInfo.addChild(_popInfoScrollTxt);
      }
      
      private function initButtons() : void
      {
         var btn:Button;
         var i:int = 0;
         i = 0;
         while(i < _btnNameArr.length)
         {
            this["_" + _btnNameArr[i]] = _backBgSprite.getChildByName(_btnNameArr[i]) as Button;
            i = i + 1;
         }
         i = 0;
         while(i < 4)
         {
            btn = this["_" + _btnNameArr[i]] as Button;
            _btnTextureArr.push([btn,btn.upState,btn.downState]);
            btn.addEventListener("triggered",onListButtonHandle);
            i = i + 1;
         }
         _closeBtn.addEventListener("triggered",onCloseHandle);
         _helpBtn.addEventListener("triggered",onHelpHandle);
         Button(_popInfo.getChildByName("popBtn")).addEventListener("triggered",onPopMarryHandle);
         Button(_divorceBtnsGroup.getChildByName("divorceBtn")).addEventListener("triggered",onDivorceBtnsHandle);
         Button(_divorceBtnsGroup.getChildByName("forceDivorceBtn")).addEventListener("triggered",onDivorceBtnsHandle);
         Button(_divorceInfo.getChildByName("popBtn")).addEventListener("triggered",onNormalDivorceHandle);
         Button(_weddingSprite.getChildByName("leftBtn")).addEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("rightBtn")).addEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("okBtn")).addEventListener("triggered",onWeddingSceneChangeHandle);
         new WeddingExchangeRing(_exchangeSprite);
         WeddingAniManager.instance.aniSignal.add((function():*
         {
            var hide:Function;
            return hide = function(param1:String):void
            {
               if(param1 == "weddingAniComplete")
               {
                  hideWeddingButtons();
               }
            };
         })());
      }
      
      private function onHelpHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("weddingHelp"));
      }
      
      private function onCloseHandle(param1:Event) : void
      {
         _dlgMark.removeFromParent(true);
         this.removeFromParent(true);
      }
      
      private function removeEvent() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Button = null;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc1_ = this["_" + _btnNameArr[_loc2_]] as Button;
            _loc1_.removeEventListener("triggered",onListButtonHandle);
            _loc2_++;
         }
         unBindNet();
         Button(_divorceBtnsGroup.getChildByName("divorceBtn")).removeEventListener("triggered",onDivorceBtnsHandle);
         Button(_divorceBtnsGroup.getChildByName("forceDivorceBtn")).removeEventListener("triggered",onDivorceBtnsHandle);
         Button(_weddingSprite.getChildByName("leftBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("rightBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("okBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
      }
      
      private function onWeddingSceneChangeHandle(param1:Event) : void
      {
         var image:Image;
         var e:Event = param1;
         if(Button(e.currentTarget).name == "okBtn")
         {
            if(PlayerDataList.instance.selfData.marryState == 1)
            {
               GameServer.instance.weddingMarryMe(0);
            }
            else
            {
               if(PlayerDataList.instance.selfData.marryState == 3)
               {
                  TextTip.instance.showByLang("weddingTip11");
                  return;
               }
               SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("weddingPrice",MARRYPRICE[currentWeddingSceneIndex - 1]),(function():*
               {
                  var yes:Function;
                  return yes = function():void
                  {
                     if(AccountData.instance.boyaaCoin < MARRYPRICE[currentWeddingSceneIndex - 1])
                     {
                        TextTip.instance.showByLang("boyyabz");
                        return;
                     }
                     GameServer.instance.weddingMarryMe(_currentWeddingSceneIndex);
                  };
               })(),(function():*
               {
                  var no:Function;
                  return no = function():void
                  {
                  };
               })());
            }
            return;
         }
         if(Button(e.currentTarget).name == "leftBtn")
         {
            currentWeddingSceneIndex = currentWeddingSceneIndex - 1;
         }
         if(Button(e.currentTarget).name == "rightBtn")
         {
            currentWeddingSceneIndex = currentWeddingSceneIndex + 1;
         }
         image = _weddingSprite.getChildByName("changeWeddingBG") as Image;
         image.texture = Assets.sAsset.getTexture("mov_weddingChange" + currentWeddingSceneIndex);
         changeWeddingText();
      }
      
      private function onDivorceBtnsHandle(param1:Event) : void
      {
         var boyaaCoin:int;
         var e:Event = param1;
         if(Button(e.currentTarget).name == "divorceBtn")
         {
            showSpriteByName("divorceInfo");
         }
         else
         {
            if(PlayerDataList.instance.selfData.marryState == 3)
            {
               TextTip.instance.showByLang("weddingTip11");
               return;
            }
            boyaaCoin = 555;
            SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("weddingForceDivorce",boyaaCoin),(function():*
            {
               var yes:Function;
               return yes = function():void
               {
                  if(AccountData.instance.boyaaCoin < boyaaCoin)
                  {
                     TextTip.instance.showByLang("boyyabz");
                     return;
                  }
                  GameServer.instance.weddingSendDivorceMsg(2,0,"");
               };
            })(),(function():*
            {
               var no:Function;
               return no = function():void
               {
               };
            })());
         }
      }
      
      private function onNormalDivorceHandle(param1:Event) : void
      {
         if(PlayerDataList.instance.selfData.marryState == 3)
         {
            TextTip.instance.showByLang("weddingTip11");
            return;
         }
         showInfo(36,1081);
      }
      
      private function onPopMarryHandle(param1:Event) : void
      {
         if(PlayerDataList.instance.selfData.marryState != 3)
         {
            TextTip.instance.showByLang("weddingTip1");
            return;
         }
         showInfo(36,1071);
      }
      
      private function showInfo(param1:int, param2:int) : void
      {
         var _loc3_:GoodsData = GoodsList.instance.getGoodsById(param1,param2);
         if(!_loc3_)
         {
            ShopManager.instance.showBuyDlgByTypeID(param1,param2);
            BuyDlg.closeSignal.addOnce(onBuyDlgClose);
         }
         else
         {
            WeddingPropUseManager.instance.showWeddingPopDlg(param1,param2);
         }
      }
      
      private function onBuyDlgClose() : void
      {
         BuyDlg.closeSignal.remove(onBuyDlgClose);
      }
      
      private function resetButtonState() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _btnTextureArr.length)
         {
            Button(_btnTextureArr[_loc1_][0]).upState = _btnTextureArr[_loc1_][1];
            Button(_btnTextureArr[_loc1_][0]).downState = _btnTextureArr[_loc1_][2];
            _loc1_++;
         }
      }
      
      private function onListButtonHandle(param1:Event) : void
      {
         if(param1 == null)
         {
            _popBtn.upState = _popBtn.downState;
            showSpriteByName("popInfo");
            return;
         }
         if(Button(param1.currentTarget).upState == Button(param1.currentTarget).downState)
         {
            return;
         }
         resetButtonState();
         Button(param1.currentTarget).upState = Button(param1.currentTarget).downState;
         switch(Button(param1.currentTarget).name)
         {
            case "popBtn":
               showSpriteByName("popInfo");
               break;
            case "weddingBtn":
               showSpriteByName("weddingSprite");
               break;
            case "divorceBtn":
               showSpriteByName("divorceBtnsGroup");
               break;
            case "exchangeBtn":
               showSpriteByName("exchangeSprite");
         }
      }
      
      private function showSpriteByName(param1:String) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < _spArr.length)
         {
            this["_" + _spArr[_loc3_]].visible = false;
            _loc3_++;
         }
         var _loc2_:Sprite = this["_" + param1];
         if(_loc2_)
         {
            _loc2_.visible = true;
         }
      }
      
      private function onEnterWeddingMsgHandle(param1:Object) : void
      {
         Application.instance.log("onEnterWeddingMsgHandle",JSON.stringify(param1));
         var _loc3_:int = int(param1.data.mid);
         var _loc2_:int = int(param1.data.omid);
         var _loc4_:int = int(param1.data.weddingType);
         if(_loc4_ == -1)
         {
            hideWeddingButtons();
            return;
         }
         if(_loc4_ != 0)
         {
            currentWeddingSceneIndex = _loc4_;
            Button(_weddingSprite.getChildByName("leftBtn")).visible = false;
            Button(_weddingSprite.getChildByName("rightBtn")).visible = false;
            changeWeddingText(_loc4_);
         }
      }
      
      private function changeWeddingText(param1:int = 0) : void
      {
         var _loc3_:Image = null;
         var _loc2_:Array = LangManager.getLang.getLangArray("weddingNames");
         var _loc4_:Array = LangManager.getLang.getLangArray("weddingDescs");
         TextField(_weddingSprite.getChildByName("title")).text = _loc2_[_currentWeddingSceneIndex - 1] + ":" + LangManager.getLang.getreplaceLang("weddingPrice",MARRYPRICE[_currentWeddingSceneIndex - 1]);
         TextField(_weddingSprite.getChildByName("desc")).text = _loc4_[_currentWeddingSceneIndex - 1];
         if(param1 != 0)
         {
            TextField(_weddingSprite.getChildByName("title")).text = LangManager.t("weddingTitleTip") + ":" + _loc2_[param1 - 1];
            _loc3_ = _weddingSprite.getChildByName("changeWeddingBG") as Image;
            _loc3_.texture = Assets.sAsset.getTexture("mov_weddingChange" + param1);
         }
      }
      
      private function hideWeddingButtons() : void
      {
         Button(_weddingSprite.getChildByName("okBtn")).visible = false;
         Button(_weddingSprite.getChildByName("leftBtn")).visible = false;
         Button(_weddingSprite.getChildByName("rightBtn")).visible = false;
         Button(_weddingSprite.getChildByName("leftBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("rightBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
         Button(_weddingSprite.getChildByName("okBtn")).removeEventListener("triggered",onWeddingSceneChangeHandle);
      }
      
      private function onWeddingMarryBack(param1:Object) : void
      {
         Application.instance.log("onWeddingMarryBack",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.mid);
         var _loc3_:int = int(param1.data.replyCode);
         if(_loc3_ == 1)
         {
            WeddingAniManager.instance.showWeddingByType(_currentWeddingSceneIndex);
         }
         else
         {
            TextTip.instance.showByLang("weddingError");
         }
      }
      
      public function set currentWeddingSceneIndex(param1:int) : void
      {
         _currentWeddingSceneIndex = param1;
         if(param1 <= 1)
         {
            _currentWeddingSceneIndex = 1;
         }
         if(param1 >= 3)
         {
            _currentWeddingSceneIndex = 3;
         }
      }
      
      public function get currentWeddingSceneIndex() : int
      {
         return _currentWeddingSceneIndex;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEvent();
         Assets.sAsset.removeTextureAtlas("wedding");
         WeddingAniManager.instance.disposeAsset();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc2_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!_loc2_)
         {
            return;
         }
         switch(_loc2_.actioncode - 148)
         {
            case 0:
               GuideEventManager.instance.dispactherEvent("newUI",[[_weddingBtn,20],[_weddingSprite.getChildByName("rightBtn"),30],[_weddingSprite.getChildByName("okBtn"),40]]);
               break;
            case 1:
               GuideEventManager.instance.dispactherEvent("newUI",[[_popInfo.getChildByName("popBtn"),30]]);
         }
      }
   }
}

