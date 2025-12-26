package com.boyaa.antwars.view.screen.forge
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.ClickSprite;
   import com.boyaa.antwars.view.display.Gauge;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.forge.tip.ForgeQuickyBuy;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.shop.ShopBuyDlg;
   import com.boyaa.antwars.view.ui.Radio;
   import com.greensock.TweenLite;
   import feathers.controls.Screen;
   import feathers.controls.ScrollContainer;
   import feathers.layout.TiledRowsLayout;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.filters.BlurFilter;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class Forge extends Screen implements IGuideProcess
   {
      
      private const STRENTH:String = "qiangHua";
      
      private const TRANSFOR:String = "zhuanYi";
      
      private const SELECT:String = "select";
      
      private const SYNTHESIS:String = "_synthesis";
      
      private const ADDITION:String = "_addition";
      
      private var selectContent:Sprite;
      
      private var qiangHuaContent:Sprite;
      
      private var zhuanYiContent:Sprite;
      
      private var _synthesisContent:ForgeSynthesisView;
      
      private var _additionContent:ForgeAdditionView;
      
      private var currentShow:String;
      
      private var qhStoneNum:Array;
      
      private var posHelper:Rectangle;
      
      private var gExpGauge:Gauge;
      
      private var gExpTxt:TextField;
      
      private var loading:Sprite;
      
      private var gTitleTxt:TextField;
      
      private var goodsbox1:Image;
      
      private var goodsbox2:Image;
      
      private var yjqhok:Radio;
      
      private var plevelTxt:TextField;
      
      private var plevelTxt2:TextField;
      
      private var pattrTxt:TextField;
      
      private var pattrTxt2:TextField;
      
      private var qhStoneTxt:TextField;
      
      private var needNum:Number;
      
      private var gTitleTxt2:TextField;
      
      private var zptitle:TextField;
      
      private var zptitle2:TextField;
      
      private var zplevel:TextField;
      
      private var zplevel2:TextField;
      
      private var zpattr:TextField;
      
      private var zpattr2:TextField;
      
      private var zps1:TextField;
      
      private var zps2:TextField;
      
      private var zps3:TextField;
      
      private var zps4:TextField;
      
      private var zyok:Radio;
      
      private var zyok1:Radio;
      
      private var gameGold:TextField;
      
      private var boyaaCoin:TextField;
      
      private var goldSprite:Sprite;
      
      private var myFilters:Array;
      
      private var helpDlg:HelpDlg;
      
      private var qhStoneImage:Image;
      
      private var _boxContainer:Sprite;
      
      public var inGuide:Boolean = false;
      
      protected var _optionsData:Object;
      
      private var exitBtn:Button;
      
      private var btnBack:Button;
      
      private var rwBg:Image;
      
      private var abtn:Button;
      
      private var addStone:Button;
      
      private var btnRecharge:Button;
      
      private var container:ScrollContainer;
      
      private var stoneContainer:ScrollContainer;
      
      private var _currentSelectGoodsData:GoodsData;
      
      private var _isSelectEquip:Boolean = false;
      
      private var helpBtn:Button;
      
      public function Forge()
      {
         super();
      }
      
      public function get optionsData() : Object
      {
         return _optionsData;
      }
      
      public function set optionsData(param1:Object) : void
      {
         _optionsData = param1;
         invalidate("data");
      }
      
      public function get isSelectEquip() : Boolean
      {
         return _isSelectEquip;
      }
      
      public function set isSelectEquip(param1:Boolean) : void
      {
         _isSelectEquip = param1;
         if(!_isSelectEquip)
         {
            _additionContent.equipData = null;
            _synthesisContent.equipData = null;
         }
      }
      
      override protected function initialize() : void
      {
         var rmger:ResManager;
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/FORGE/forge.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/FORGE/forge.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                     showGuide();
                     guideProcess();
                  },0.15);
               }
            };
         })());
      }
      
      private function init() : void
      {
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("bb_bg"));
         _loc4_.width = 1365;
         _loc4_.height = 768;
         _loc4_.blendMode = "none";
         addChild(_loc4_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("shop_top_bar"));
         _loc5_.touchable = false;
         addChild(_loc5_);
         exitBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.sAsset.positionDisplay(exitBtn,"forge","exit");
         exitBtn.x = Assets.rightTop.x - exitBtn.width;
         exitBtn.addEventListener("triggered",onExitBtnClick);
         this.addChild(exitBtn);
         btnBack = new Button(Assets.sAsset.getTexture("back0"),"",Assets.sAsset.getTexture("back1"));
         btnBack.x = Assets.leftTop.x + 10;
         btnBack.y = Assets.leftTop.y + btnBack.height / 2 + 10;
         btnBack.addEventListener("triggered",onBack);
         addChild(btnBack);
         var _loc1_:GlowFilter = new GlowFilter(4660230,1,6,6,10);
         myFilters = [];
         myFilters.push(_loc1_);
         _boxContainer = new Sprite();
         _boxContainer.width = 1365;
         _boxContainer.height = 768;
         var _loc6_:Rectangle = Assets.sAsset.getPosition("forge","listbox");
         _boxContainer.clipRect = _loc6_;
         addAccountInfo();
         createSelect();
         createQH();
         createZY();
         createSynthesis();
         createAddition();
         gotoShow("select");
         loading = new Sprite();
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("forgebg23"));
         loading.addChild(_loc2_);
         var _loc3_:Gauge = new Gauge(Assets.sAsset.getTexture("forgebg24"));
         _loc3_.x = _loc2_.width - _loc3_.width >> 1;
         _loc3_.y = _loc2_.height - _loc3_.height >> 1;
         _loc3_.name = "Gauge";
         loading.addChild(_loc3_);
         addChild(loading);
         loading.x = 1365 - loading.width >> 1;
         loading.y = 768 - loading.height >> 1;
         loading.visible = false;
         ForgeQuickyBuy.quickyBuyDoneSignal.add(updateBoxItem);
      }
      
      private function updateBoxItem(param1:String) : void
      {
         if(currentShow == "_synthesis")
         {
            addStoneInBox(_synthesisContent,currentShow);
         }
         if(currentShow == "_addition")
         {
            addStoneInBox(_additionContent,currentShow);
         }
      }
      
      private function showGuide() : void
      {
         if(_optionsData.pos == "forge")
         {
            Guide.instance.guide(rwBg,LangManager.t("guide10"),true);
            inGuide = true;
            btnBack.enabled = false;
            btnRecharge.enabled = false;
         }
      }
      
      private function showLoading(param1:Number, param2:Function) : void
      {
         var newValue:Number = param1;
         var callBack:Function = param2;
         TweenLite.to(gExpGauge,!newValue ? 0.8 : 0.2,{
            "ratio":(!newValue ? 1 : newValue),
            "onComplete":function():void
            {
               callBack();
               if(newValue == 0)
               {
                  gExpGauge.ratio = 0;
               }
            }
         });
      }
      
      private function gotoShow(param1:String) : void
      {
         selectContent.visible = false;
         qiangHuaContent.visible = false;
         zhuanYiContent.visible = false;
         _synthesisContent.visible = false;
         _additionContent.visible = false;
         this[param1 + "Content"].visible = true;
         goodsbox1 && goodsbox1.removeFromParent(true);
         goodsbox2 && goodsbox2.removeFromParent(true);
         goodsbox1 = null;
         goodsbox2 = null;
         _synthesisContent.stoneImgInForge && _synthesisContent.stoneImgInForge.removeFromParent(true);
         _additionContent.stoneImgInForge && _additionContent.stoneImgInForge.removeFromParent(true);
         currentShow = param1;
         Assets.sAsset.positionDisplay(container,"forge","listbox");
         if(param1 == "qiangHua")
         {
            qhStoneNum = GoodsList.instance.getConsumeGoods(15,1013);
            qhStoneTxt.text = qhStoneNum[qhStoneNum.length - 1].toString();
            qhStoneImage.visible = qhStoneNum[qhStoneNum.length - 1] > 0;
            showQHInfo();
            createList(qiangHuaContent);
            if(inGuide)
            {
               Guide.instance.guide(container,LangManager.t("guide12"));
               helpBtn.enabled = false;
               abtn.enabled = false;
               addStone.enabled = false;
            }
         }
         if(param1 == "zhuanYi")
         {
            showZYInfo();
            createList(zhuanYiContent);
         }
         if(param1 != "select")
         {
            goldSprite.x = container.x - 30;
            goldSprite.y = container.y + container.height + goldSprite.height / 2;
         }
         else
         {
            goldSprite.x = Assets.bottomCenter.x - goldSprite.width / 2;
            goldSprite.y = Assets.bottomCenter.y - goldSprite.height;
         }
         if("_synthesis" == param1)
         {
            _synthesisContent.clearData();
            createList(_synthesisContent);
            isSelectEquip = false;
         }
         if("_addition" == param1)
         {
            _additionContent.clearData();
            createList(_additionContent);
            isSelectEquip = false;
         }
      }
      
      private function createSelect() : void
      {
         var _loc6_:int = 0;
         var _loc2_:ClickSprite = null;
         var _loc4_:Image = null;
         selectContent = new Sprite();
         addChild(selectContent);
         selectContent.visible = false;
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("forgebg33"));
         selectContent.addChild(_loc3_);
         Assets.positionDisplay(_loc3_,"forge","title");
         _loc3_.scaleX = _loc3_.scaleY = 1;
         _loc3_.x = 1365 - _loc3_.width >> 1;
         var _loc5_:Array = [onQianghua,onZhuangyi,onSynthesis,onAddition];
         var _loc1_:Array = ["qiangHuaBtn","transformBtn","synthesisBtn","additionBtn"];
         _loc6_ = 1;
         while(_loc6_ <= 4)
         {
            _loc2_ = new ClickSprite();
            _loc4_ = new Image(Assets.sAsset.getTexture("forgeSelect" + _loc6_));
            _loc2_.addChild(_loc4_);
            if(_loc6_ == 1)
            {
               rwBg = _loc4_;
            }
            _loc2_.name = _loc1_[_loc6_ - 1];
            Assets.sAsset.positionDisplay(_loc2_,"forgeSelectView","btn" + _loc6_);
            selectContent.addChild(_loc2_);
            _loc2_.addEventListener("triggered",_loc5_[_loc6_ - 1]);
            _loc6_++;
         }
      }
      
      private function createSynthesis() : void
      {
         _synthesisContent = new ForgeSynthesisView();
         addChild(_synthesisContent);
         _synthesisContent.visible = false;
         _synthesisContent.doneSignal.add(updateAccount);
         _synthesisContent.equipImgInForge = goodsbox1;
         _synthesisContent.stoneImgInForge = goodsbox2;
      }
      
      private function createAddition() : void
      {
         _additionContent = new ForgeAdditionView();
         addChild(_additionContent);
         _additionContent.visible = false;
         _additionContent.doneSignal.add(updateAccount);
         _additionContent.equipImgInForge = goodsbox1;
         _additionContent.stoneImgInForge = goodsbox2;
      }
      
      private function createQH() : void
      {
         qiangHuaContent = new Sprite();
         addChild(qiangHuaContent);
         qiangHuaContent.visible = false;
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("forgebg7"));
         Assets.positionDisplay(_loc2_,"forge","title");
         qiangHuaContent.addChild(_loc2_);
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("forgebg1"));
         qiangHuaContent.addChild(_loc6_);
         Assets.sAsset.positionDisplay(_loc6_,"forge","forgebg1");
         helpBtn = new Button(Assets.sAsset.getTexture("helpbtn0"),"",Assets.sAsset.getTexture("helpbtn1"));
         Assets.positionDisplay(helpBtn,"forge","helpbtn");
         helpBtn.x = exitBtn.x - exitBtn.width - 10;
         qiangHuaContent.addChild(helpBtn);
         helpBtn.addEventListener("triggered",onHelp);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("forgebg2"));
         Assets.sAsset.positionDisplay(_loc5_,"forge","box1");
         qiangHuaContent.addChild(_loc5_);
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("hightbg"));
         _loc7_.name = "lefboxH";
         Assets.sAsset.positionDisplay(_loc7_,"forge","box1");
         qiangHuaContent.addChild(_loc7_);
         _loc7_.visible = false;
         abtn = new Button(Assets.sAsset.getTexture("forgebg8"),"",Assets.sAsset.getTexture("forgebg9"));
         Assets.sAsset.positionDisplay(abtn,"forge","qhbtn");
         qiangHuaContent.addChild(abtn);
         abtn.name = "forgeBtn";
         abtn.addEventListener("triggered",onActionBtn);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("forgebg2"));
         Assets.sAsset.positionDisplay(_loc1_,"forge","box2");
         qiangHuaContent.addChild(_loc1_);
         qhStoneNum = GoodsList.instance.getConsumeGoods(15,1013);
         var _loc8_:Image = new Image(Assets.sAsset.getTexture("forgebg3"));
         Assets.sAsset.positionDisplay(_loc8_,"forge","fbarbg");
         qiangHuaContent.addChild(_loc8_);
         gExpGauge = new Gauge(Assets.sAsset.getTexture("forgebg4"));
         Assets.sAsset.positionDisplay(gExpGauge,"forge","fbar");
         qiangHuaContent.addChild(gExpGauge);
         gExpGauge.ratio = 0;
         posHelper = Assets.sAsset.getPosition("forge","fbar");
         gExpTxt = new TextField(posHelper.width + 10,posHelper.height + 10,"0/0","Verdana",24,16777215);
         gExpTxt.nativeFilters = myFilters;
         gExpTxt.hAlign = "center";
         gExpTxt.vAlign = "center";
         gExpTxt.x = posHelper.x - 5;
         gExpTxt.y = posHelper.y - 5;
         qiangHuaContent.addChild(gExpTxt);
         gExpTxt.autoScale = true;
         posHelper = Assets.sAsset.getPosition("forge","ptitle");
         gTitleTxt = new TextField(posHelper.width + 10,posHelper.height + 10,"","Verdana",24,16777215,true);
         gTitleTxt.nativeFilters = myFilters;
         gTitleTxt.hAlign = "center";
         gTitleTxt.vAlign = "center";
         gTitleTxt.x = posHelper.x - 5;
         gTitleTxt.y = posHelper.y - 5;
         qiangHuaContent.addChild(gTitleTxt);
         posHelper = Assets.sAsset.getPosition("forge","ptitle2");
         gTitleTxt2 = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("qhStone"),"Verdana",24,16777215,true);
         gTitleTxt2.nativeFilters = myFilters;
         gTitleTxt2.hAlign = "center";
         gTitleTxt2.vAlign = "center";
         gTitleTxt2.x = posHelper.x - 5;
         gTitleTxt2.y = posHelper.y - 5;
         qiangHuaContent.addChild(gTitleTxt2);
         gTitleTxt.autoScale = gTitleTxt2.autoScale = true;
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("forgebg14"));
         Assets.positionDisplay(_loc4_,"forge","levelto");
         qiangHuaContent.addChild(_loc4_);
         _loc4_ = new Image(Assets.sAsset.getTexture("forgebg14"));
         Assets.positionDisplay(_loc4_,"forge","levelto2");
         qiangHuaContent.addChild(_loc4_);
         posHelper = Assets.sAsset.getPosition("forge","plevel");
         plevelTxt = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("level") + ": 0","Verdana",24,16777215,true);
         plevelTxt.nativeFilters = myFilters;
         plevelTxt.hAlign = "left";
         plevelTxt.vAlign = "center";
         plevelTxt.x = posHelper.x - 15;
         plevelTxt.y = posHelper.y - 5;
         plevelTxt.autoScale = true;
         qiangHuaContent.addChild(plevelTxt);
         posHelper = Assets.sAsset.getPosition("forge","plevel2");
         plevelTxt2 = new TextField(posHelper.width + 10,posHelper.height + 10,"0","Verdana",24,16777215,true);
         plevelTxt2.nativeFilters = myFilters;
         plevelTxt2.hAlign = "left";
         plevelTxt2.vAlign = "center";
         plevelTxt2.x = posHelper.x + 5;
         plevelTxt2.y = posHelper.y - 5;
         plevelTxt2.autoScale = true;
         qiangHuaContent.addChild(plevelTxt2);
         posHelper = Assets.sAsset.getPosition("forge","pattr");
         pattrTxt = new TextField(posHelper.width + 20,posHelper.height + 10,LangManager.t("attr") + ": 0","Verdana",24,16777215,true);
         pattrTxt.nativeFilters = myFilters;
         pattrTxt.hAlign = "left";
         pattrTxt.vAlign = "center";
         pattrTxt.x = posHelper.x - 15;
         pattrTxt.y = posHelper.y - 5;
         qiangHuaContent.addChild(pattrTxt);
         posHelper = Assets.sAsset.getPosition("forge","pattr2");
         pattrTxt2 = new TextField(posHelper.width + 20,posHelper.height + 10,"0","Verdana",24,16777215,true);
         pattrTxt2.nativeFilters = myFilters;
         pattrTxt2.hAlign = "left";
         pattrTxt2.vAlign = "center";
         pattrTxt2.x = posHelper.x + 5;
         pattrTxt2.y = posHelper.y - 5;
         qiangHuaContent.addChild(pattrTxt2);
         pattrTxt.autoScale = pattrTxt2.autoScale = true;
         yjqhok = new Radio();
         yjqhok.data = true;
         posHelper = Assets.sAsset.getPosition("forge","yjqhok");
         Assets.positionDisplay(yjqhok,"forge","yjqhok");
         qiangHuaContent.addChild(yjqhok);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("forgebg6"));
         Assets.positionDisplay(_loc3_,"forge","yjqh");
         qiangHuaContent.addChild(_loc3_);
         var _loc9_:Image = new Image(Assets.sAsset.getTexture("forgebg3"));
         Assets.positionDisplay(_loc9_,"forge","sbg");
         qiangHuaContent.addChild(_loc9_);
         posHelper = Assets.sAsset.getPosition("forge","sbg");
         qhStoneTxt = new TextField(posHelper.width + 10,posHelper.height + 10,qhStoneNum[qhStoneNum.length - 1].toString(),"Verdana",24,16777215,true);
         qhStoneTxt.nativeFilters = myFilters;
         qhStoneTxt.hAlign = "center";
         qhStoneTxt.vAlign = "center";
         qhStoneTxt.x = posHelper.x - 5;
         qhStoneTxt.y = posHelper.y - 5;
         qiangHuaContent.addChild(qhStoneTxt);
         addStone = new Button(Assets.sAsset.getTexture("recharge8"),"",Assets.sAsset.getTexture("recharge7"));
         Assets.positionDisplay(addStone,"forge","sadd");
         qiangHuaContent.addChild(addStone);
         addStone.addEventListener("triggered",onAddStone);
         qhStoneImage = Assets.sAsset.getGoodsImageByRect(15,1013,Assets.sAsset.getPosition("forge","goodsbox2"));
         qiangHuaContent.addChild(qhStoneImage);
         qhStoneImage.visible = false;
      }
      
      private function onAddStone(param1:Event = null) : void
      {
         var _loc2_:ShopData = ShopDataList.instance.getSingleData(15,1013);
         var _loc3_:ShopBuyDlg = new ShopBuyDlg(true,_loc2_);
         _loc3_.buySignal.add(updateStoneNum);
         Application.instance.currentGame.addChild(_loc3_);
      }
      
      private function onAddZYStone() : void
      {
         var _loc1_:ShopData = ShopDataList.instance.getSingleData(40,1013);
         var _loc2_:ShopBuyDlg = new ShopBuyDlg(true,_loc1_);
         _loc2_.buySignal.add(updateStoneNum);
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function updateStoneNum() : void
      {
         if(currentShow == "qiangHua")
         {
            qhStoneNum = GoodsList.instance.getConsumeGoods(15,1013);
            qhStoneTxt.text = qhStoneNum[qhStoneNum.length - 1].toString();
            qhStoneImage.visible = qhStoneNum[qhStoneNum.length - 1] > 0;
            boyaaCoin.text = AccountData.instance.boyaaCoin.toString();
            guideProcess("forge");
         }
         else if(currentShow == "zhuanYi")
         {
         }
      }
      
      private function heightlineBox(param1:Function) : void
      {
         var callBack:Function = param1;
         var sprite:Sprite = this[currentShow + "Content"] as Sprite;
         var img:Image = sprite.getChildByName("lefboxH") as Image;
         if(img)
         {
            img.visible = true;
            img.alpha = 1;
            Starling.juggler.tween(img,1,{
               "alpha":0,
               "transition":"easeIn",
               "onComplete":function():void
               {
                  img.visible = false;
                  callBack();
               }
            });
         }
      }
      
      private function addAccountInfo() : void
      {
         goldSprite = new Sprite();
         addChild(goldSprite);
         var _loc3_:AccountData = AccountData.instance;
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         Assets.sAsset.positionDisplay(_loc2_,"accountInfo","goldBg1");
         _loc2_.touchable = false;
         goldSprite.addChild(_loc2_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         _loc4_.touchable = false;
         Assets.sAsset.positionDisplay(_loc4_,"accountInfo","goldBg2");
         goldSprite.addChild(_loc4_);
         btnRecharge = new Button(Assets.sAsset.getTexture("recharge8"),"",Assets.sAsset.getTexture("recharge7"));
         Assets.sAsset.positionDisplay(btnRecharge,"accountInfo","recharge");
         btnRecharge.addEventListener("triggered",onRecharge);
         goldSprite.addChild(btnRecharge);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("gameGoldIcon"));
         Assets.sAsset.positionDisplay(_loc1_,"accountInfo","gameGoldIcon");
         _loc1_.filter = BlurFilter.createDropShadow();
         goldSprite.addChild(_loc1_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         Assets.sAsset.positionDisplay(_loc5_,"accountInfo","boyaaCoinIcon");
         _loc5_.filter = BlurFilter.createDropShadow();
         goldSprite.addChild(_loc5_);
         var _loc6_:Rectangle = Assets.getPosition("accountInfo","gameGold");
         gameGold = new TextField(_loc6_.width,_loc6_.height,_loc3_.gameGold.toString(),"Verdana",24,16777215,true);
         gameGold.hAlign = "left";
         gameGold.vAlign = "top";
         gameGold.x = _loc6_.x;
         gameGold.y = _loc6_.y;
         goldSprite.addChild(gameGold);
         _loc6_ = Assets.getPosition("accountInfo","boyaaCoin");
         boyaaCoin = new TextField(_loc6_.width,_loc6_.height,_loc3_.boyaaCoin.toString(),"Verdana",24,16777215,true);
         boyaaCoin.hAlign = "left";
         boyaaCoin.vAlign = "top";
         boyaaCoin.x = _loc6_.x;
         boyaaCoin.y = _loc6_.y;
         goldSprite.addChild(boyaaCoin);
         goldSprite.x = Assets.bottomCenter.x - goldSprite.width / 2;
         goldSprite.y = Assets.bottomCenter.y - goldSprite.height;
         trace(Assets.bottomCenter.x,Assets.bottomCenter.y,goldSprite.x,goldSprite.y);
      }
      
      private function updateAccount() : void
      {
         gameGold.text = AccountData.instance.gameGold.toString();
         boyaaCoin.text = AccountData.instance.boyaaCoin.toString();
      }
      
      private function onRecharge(param1:Event) : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function animaitionBoxContent(param1:int = 0) : void
      {
         var flag:int = param1;
         var showContent:* = function():void
         {
         };
         var rect:Rectangle = Assets.sAsset.getPosition("forge","listbox");
         var aniTime:Number = 0.5;
         if(flag == 0)
         {
            TweenLite.to(container,aniTime,{
               "x":rect.x,
               "onComplete":showContent
            });
            TweenLite.to(stoneContainer,aniTime,{
               "x":rect.x + stoneContainer.width,
               "onComplete":showContent
            });
         }
         else
         {
            TweenLite.to(container,aniTime,{
               "x":rect.x - container.width,
               "onComplete":showContent
            });
            TweenLite.to(stoneContainer,aniTime,{
               "x":rect.x,
               "onComplete":showContent
            });
         }
      }
      
      private function createList(param1:Sprite) : void
      {
         _boxContainer.removeChildren();
         var _loc4_:DisplayObject = param1.getChildByName("container");
         if(_loc4_)
         {
            _loc4_.removeFromParent(true);
         }
         if(param1.getChildByName("containerBg"))
         {
            param1.getChildByName("containerBg").removeFromParent(true);
         }
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("forgebg10"));
         Assets.sAsset.positionDisplay(_loc2_,"forge","listbg");
         _loc2_.name = "containerBg";
         param1.addChild(_loc2_);
         param1.addChild(_boxContainer);
         var _loc3_:TiledRowsLayout = new TiledRowsLayout();
         container = new ScrollContainer();
         container.name = "container";
         container.layout = _loc3_;
         _loc3_.gap = -14;
         _loc3_.paddingLeft = 0;
         _loc3_.paddingRight = 0;
         Assets.sAsset.positionDisplay(container,"forge","listbox");
         addEquipGoodsInBox(param1);
         if(param1 == _synthesisContent || param1 == _additionContent)
         {
            if(stoneContainer)
            {
               stoneContainer.removeFromParent(true);
            }
            stoneContainer = new ScrollContainer();
            stoneContainer.layout = _loc3_;
            _boxContainer.addChild(stoneContainer);
            Assets.sAsset.positionDisplay(stoneContainer,"forge","listbox");
            stoneContainer.x += stoneContainer.width;
            addStoneInBox(param1,currentShow);
         }
      }
      
      private function addEquipGoodsInBox(param1:Sprite) : void
      {
         var _loc5_:* = 0;
         var _loc2_:GoodsData = null;
         if(stoneContainer)
         {
            stoneContainer.removeFromParent(true);
         }
         container.removeChildren();
         var _loc4_:Array = GoodsList.instance.getEquipment(1);
         var _loc6_:Array = GoodsList.instance.getEquipment(0);
         var _loc3_:Array = _loc4_.concat(_loc6_);
         _boxContainer.addChild(container);
         _loc5_ = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc5_] as GoodsData;
            if(param1 == _additionContent)
            {
               if(_loc2_.isRentFromOther(_loc2_.onlyID) == false)
               {
                  container.addChild(createGoodsBox(_loc3_[_loc5_]));
               }
            }
            else if((_loc3_[_loc5_].typeID == 11 || _loc3_[_loc5_].typeID == 1 || _loc3_[_loc5_].typeID == 6) && (param1 == qiangHuaContent && _loc3_[_loc5_].strengthen || param1 == zhuanYiContent && _loc3_[_loc5_].canTransfer || param1 == _synthesisContent && _loc3_[_loc5_].synthesis))
            {
               if(_loc2_.isRentFromOther(_loc2_.onlyID) == false)
               {
                  container.addChild(createGoodsBox(_loc3_[_loc5_]));
               }
            }
            _loc5_++;
         }
      }
      
      private function createGoodsBox(param1:GoodsData) : ClickSprite
      {
         return new ForgeGoodsBox(param1,onGoodsBox);
      }
      
      private function onGoodsBox(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc4_:GoodsData = null;
         var _loc2_:GoodsData = null;
         var _loc5_:ForgeViewBase = null;
         if(currentShow == "qiangHua")
         {
            _loc3_ = parseInt((param1.target as ClickSprite).name);
            _currentSelectGoodsData = _loc4_ = GoodsList.instance.getGoodsByOnlyID(_loc3_);
            if(_loc4_.strengthenNum > 11)
            {
               TextTip.instance.show(LangManager.t("qhmax"));
               return;
            }
            goodsbox1 && goodsbox1.removeFromParent(true);
            goodsbox1 = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,Assets.sAsset.getPosition("forge","goodsbox1"));
            goodsbox1.name = _loc3_.toString();
            qiangHuaContent.addChild(goodsbox1);
            gExpGauge.ratio = _loc4_.strengthenExp / _loc4_.nextStrengthenExp();
            showQHInfo();
            if(inGuide)
            {
               Guide.instance.guide(abtn,"",true);
               abtn.enabled = true;
            }
            guideProcess("forge");
         }
         else if(currentShow == "zhuanYi")
         {
            _loc3_ = parseInt((param1.target as ClickSprite).name);
            if(goodsbox1 && _loc3_ == parseInt(goodsbox1.name) || goodsbox2 && _loc3_ == parseInt(goodsbox2.name))
            {
               return;
            }
            if(goodsbox1)
            {
               _loc2_ = GoodsList.instance.getGoodsByOnlyID(parseInt(goodsbox1.name));
               _loc4_ = GoodsList.instance.getGoodsByOnlyID(_loc3_);
               if(_loc2_.typeID != _loc4_.typeID)
               {
                  TextTip.instance.show(LangManager.t("zyerror1"));
                  return;
               }
               goodsbox2 && goodsbox2.removeFromParent(true);
               goodsbox2 = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,Assets.sAsset.getPosition("forge","goodsbox4"));
               goodsbox2.name = _loc3_.toString();
               zhuanYiContent.addChild(goodsbox2);
            }
            else
            {
               _loc4_ = GoodsList.instance.getGoodsByOnlyID(_loc3_);
               goodsbox1 = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,Assets.sAsset.getPosition("forge","goodsbox3"));
               goodsbox1.name = _loc3_.toString();
               zhuanYiContent.addChild(goodsbox1);
            }
            showZYInfo();
         }
         else if("_synthesis" == currentShow || "_addition" == currentShow)
         {
            if("_synthesis" == currentShow)
            {
               _loc5_ = _synthesisContent;
            }
            if("_addition" == currentShow)
            {
               _loc5_ = _additionContent;
            }
            _loc3_ = parseInt((param1.target as ClickSprite).name);
            _currentSelectGoodsData = _loc4_ = GoodsList.instance.getGoodsByOnlyID(_loc3_);
            if(!isSelectEquip)
            {
               goodsbox1 && goodsbox1.removeFromParent(true);
               goodsbox1 = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,_synthesisContent.getDisplayObjectByName("goodsbox0").bounds);
               goodsbox1.name = _loc3_.toString();
               _loc5_.addChild(goodsbox1);
               isSelectEquip = true;
               animaitionBoxContent(1);
               _loc5_.equipData = _loc4_;
            }
            else
            {
               _loc5_.stoneImgInForge && _loc5_.stoneImgInForge.removeFromParent(true);
               goodsbox2 && goodsbox2.removeFromParent(true);
               goodsbox2 = Assets.sAsset.getGoodsImageByRect(_loc4_.typeID,_loc4_.frameID,_synthesisContent.getDisplayObjectByName("goodsbox1").bounds);
               goodsbox2.name = _loc3_.toString();
               _loc5_.addChild(goodsbox2);
               _loc5_.stoneData = _loc4_;
               _loc5_.stoneImgInForge = goodsbox2;
            }
         }
         goodsbox1 && goodsbox1.addEventListener("touch",onEmptyBox);
         goodsbox2 && goodsbox2.addEventListener("touch",onEmptyBox);
      }
      
      private function addStoneInBox(param1:Sprite, param2:String = "_synthesis") : void
      {
         var _loc8_:int = 0;
         var _loc5_:GoodsData = null;
         if(stoneContainer)
         {
            stoneContainer.removeChildren();
         }
         var _loc4_:Array = GoodsList.instance.getOther();
         var _loc6_:Array = [16,17,18,19];
         var _loc7_:Array = [20];
         var _loc3_:* = [];
         if("_synthesis" == param2)
         {
            _loc3_ = _loc6_;
         }
         else
         {
            _loc3_ = _loc7_;
         }
         _loc8_ = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc8_];
            if(_loc3_.indexOf(_loc5_.typeID) != -1)
            {
               stoneContainer.addChild(createGoodsBox(_loc5_));
            }
            _loc8_++;
         }
      }
      
      private function onEmptyBox(param1:TouchEvent) : void
      {
         var _loc3_:Image = null;
         var _loc2_:Touch = param1.getTouch(stage);
         if(_loc2_.phase == "ended")
         {
            _loc3_ = param1.target as Image;
            _loc3_.removeFromParent(true);
            if(_loc3_ == goodsbox1)
            {
               goodsbox1 = null;
               if("_synthesis" == currentShow)
               {
                  if(isSelectEquip)
                  {
                     animaitionBoxContent(0);
                     isSelectEquip = false;
                  }
               }
               if("_addition" == currentShow)
               {
                  if(isSelectEquip)
                  {
                     animaitionBoxContent(0);
                     isSelectEquip = false;
                  }
               }
            }
            else
            {
               goodsbox2 = null;
               _synthesisContent.stoneData = null;
               _additionContent.stoneData = null;
            }
         }
         if(currentShow == "qiangHua")
         {
            showQHInfo();
         }
         if(currentShow == "zhuanYi")
         {
            showZYInfo();
         }
      }
      
      private function showQHInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GoodsData = null;
         if(goodsbox1)
         {
            _loc1_ = parseInt(goodsbox1.name);
            _loc2_ = GoodsList.instance.getGoodsByOnlyID(_loc1_);
            gExpTxt.text = _loc2_.strengthenExp + "/" + _loc2_.nextStrengthenExp();
            gTitleTxt.text = _loc2_.name;
            plevelTxt.text = LangManager.t("level") + ": " + _loc2_.strengthenNum;
            plevelTxt2.text = Math.min(_loc2_.strengthenNum + 1,12).toString();
            pattrTxt.text = getAttrText(_loc2_);
            if(_loc2_.typeID == 11)
            {
               pattrTxt2.text = Math.floor(_loc2_.damage * Math.pow(1.1,Math.min(_loc2_.strengthenNum + 1,12))).toString();
            }
            else if(_loc2_.typeID == 1 || _loc2_.typeID == 6)
            {
               pattrTxt2.text = Math.floor(_loc2_.armor * Math.pow(1.1,Math.min(_loc2_.strengthenNum + 1,12))).toString();
            }
            qhStoneTxt.text = qhStoneNum[qhStoneNum.length - 1].toString();
            qhStoneImage.visible = qhStoneNum[qhStoneNum.length - 1] > 0;
            return;
         }
         gExpGauge.ratio = 0;
         gExpTxt.text = "0/0";
         gTitleTxt.text = "";
         plevelTxt.text = LangManager.t("level") + ": 0";
         plevelTxt2.text = "0";
         pattrTxt.text = LangManager.t("attr") + ": 0";
         pattrTxt2.text = "0";
      }
      
      private function showZYInfo() : void
      {
         var _loc2_:int = 0;
         var _loc1_:GoodsData = null;
         var _loc3_:GoodsData = null;
         if(goodsbox1)
         {
            _loc2_ = parseInt(goodsbox1.name);
            _loc1_ = GoodsList.instance.getGoodsByOnlyID(_loc2_);
         }
         else
         {
            zptitle.text = "";
            zplevel.text = LangManager.t("level") + ": 0";
            zpattr.text = LangManager.t("attr") + ": 0";
            zps3.text = "0";
            zps2.text = LangManager.t("zycgl") + "0%";
         }
         if(zyok1.data)
         {
            zps2.text = LangManager.t("zycgl") + "100%";
         }
         if(goodsbox2)
         {
            _loc2_ = parseInt(goodsbox2.name);
            _loc3_ = GoodsList.instance.getGoodsByOnlyID(_loc2_);
         }
         else
         {
            zptitle2.text = "";
            zplevel2.text = LangManager.t("level") + ": 0";
            zpattr2.text = LangManager.t("attr") + ": 0";
         }
         if(_loc1_)
         {
            zptitle.text = _loc1_.name;
            zplevel.text = LangManager.t("level") + ": " + _loc1_.strengthenNum;
            zpattr.text = getAttrText(_loc1_);
            zps3.text = _loc1_.getShiftBoyaaCoin().toString();
            if(zyok1.data)
            {
               zps2.text = LangManager.t("zycgl") + "100%";
            }
            else
            {
               zps2.text = LangManager.t("zycgl") + _loc1_.getShiftProbability().toString() + "%";
            }
         }
         if(_loc3_)
         {
            zptitle2.text = _loc3_.name;
            zplevel2.text = LangManager.t("level") + ": " + _loc3_.strengthenNum;
            zpattr2.text = getAttrText(_loc3_);
         }
      }
      
      private function getAttrText(param1:GoodsData) : String
      {
         if(param1.typeID == 11)
         {
            return LangManager.t("reduceBlood") + ": " + Math.floor(param1.damage * Math.pow(1.1,param1.strengthenNum)).toString();
         }
         if(param1.typeID == 1 || param1.typeID == 6)
         {
            return LangManager.t("defense") + Math.floor(param1.armor * Math.pow(1.1,param1.strengthenNum)).toString();
         }
         return LangManager.t("defense") + "0";
      }
      
      private function onActionBtn(param1:Event) : void
      {
         var stoneAry:Array;
         var onlyId:int;
         var goods:GoodsData;
         var stoneGoods:GoodsData;
         var lastneedNum:int;
         var goods1:GoodsData;
         var goodses:Array;
         var lastneed:int;
         var e:Event = param1;
         if(inGuide)
         {
            Guide.instance.stop();
         }
         if(currentShow == "qiangHua")
         {
            if(!goodsbox1 || !goodsbox1.parent)
            {
               TextTip.instance.show(LangManager.t("toSelectZB"));
               return;
            }
            onlyId = parseInt(goodsbox1.name);
            goods = GoodsList.instance.getGoodsByOnlyID(onlyId);
            if(goods.nextStrengthenExp() == 0)
            {
               TextTip.instance.show(LangManager.t("qhmax"));
               return;
            }
            if(qhStoneNum[qhStoneNum.length - 1] == 0)
            {
               SystemTip.instance.showSystemAlert(LangManager.t("toBuyQHStone"),function():void
               {
                  onAddStone();
               },function():void
               {
               });
            }
            stoneGoods = GoodsList.instance.getGoodsById(15,1013);
            if(yjqhok.data)
            {
               needNum = (goods.nextStrengthenExp() - goods.strengthenExp) / 10;
            }
            else
            {
               needNum = 1;
            }
            if(needNum <= 0)
            {
               needNum = 1;
            }
            if(needNum > qhStoneNum[qhStoneNum.length - 1])
            {
               stoneAry = qhStoneNum.slice(0,qhStoneNum.length - 1);
               _callStrenthen(onlyId,stoneAry);
            }
            else
            {
               lastneedNum = needNum - qhStoneNum[0][1];
               if(lastneedNum > 0)
               {
                  stoneAry = [[qhStoneNum[0][0],qhStoneNum[0][1]],[qhStoneNum[1][0],lastneedNum]];
               }
               else
               {
                  stoneAry = [[qhStoneNum[0][0],needNum]];
               }
               _callStrenthen(onlyId,stoneAry);
            }
         }
         else if(currentShow == "zhuanYi")
         {
            if(!(goodsbox1 && goodsbox2))
            {
               TextTip.instance.show(LangManager.t("toSelectZB"));
               return;
            }
            goods1 = GoodsList.instance.getGoodsByOnlyID(parseInt(goodsbox1.name));
            if(goods1.strengthenNum <= GoodsList.instance.getGoodsByOnlyID(parseInt(goodsbox2.name)).strengthenNum)
            {
               TextTip.instance.show(LangManager.t("zyerror2"));
               return;
            }
            if(zyok.data == true)
            {
               goodses = GoodsList.instance.getConsumeGoods(40,1013);
               if(goodses[goodses.length - 1] < 10)
               {
                  SystemTip.instance.showSystemAlert(LangManager.t("toBuyZYStone"),function():void
                  {
                     Application.instance.currentGame.navigator.showScreen("HALL");
                  },function():void
                  {
                  });
                  return;
               }
               lastneed = 10 - goodses[0][1];
               if(lastneed > 0)
               {
                  stoneAry = [[goodses[0][0],goodses[0][1]],[goodses[1][0],lastneed]];
               }
               else
               {
                  stoneAry = [[goodses[0][0],10]];
               }
            }
            else
            {
               if(goods1.getShiftBoyaaCoin() > AccountData.instance.boyaaCoin)
               {
                  SystemTip.instance.showSystemAlert(LangManager.t("boyyabz"),function():void
                  {
                     onRecharge(null);
                  },function():void
                  {
                  });
                  return;
               }
               stoneAry = null;
            }
            _callTransfer(parseInt(goodsbox1.name),parseInt(goodsbox2.name),stoneAry);
         }
      }
      
      private function _callStrenthen(param1:int, param2:Array) : void
      {
         var _this:Forge;
         var onlyId:int = param1;
         var stoneAry:Array = param2;
         if(stoneAry.length == 0)
         {
            return;
         }
         _this = this;
         touchable = false;
         GameServer.instance.strenthen(onlyId,stoneAry,function(param1:Object):void
         {
            var goods:GoodsData;
            var oldSNum:int;
            var addSExp:int;
            var retData:Object = param1;
            trace(JSON.stringify(retData));
            if(retData.ret == 0)
            {
               goods = GoodsList.instance.getGoodsByOnlyID(retData.onlyId);
               oldSNum = goods.strengthenNum;
               addSExp = retData.exp - goods.strengthenExp;
               goods.strengthenExp = retData.exp;
               goods.resolveSynthesis(retData.synthesis);
               GoodsList.instance.reduceConsumeGoods(15,1013,needNum);
               qhStoneNum = GoodsList.instance.getConsumeGoods(15,1013);
               showQHInfo();
               showLoading(goods.strengthenExp / goods.nextStrengthenExp(),function():void
               {
                  if(goods.strengthenNum > oldSNum)
                  {
                     SoundManager.playSound("qhzyok");
                     heightlineBox(function():void
                     {
                        touchable = true;
                        createList(_this[currentShow + "Content"]);
                        TextTip.instance.show(LangManager.t("qhLevel",[goods.strengthenNum]));
                        MissionManager.instance.updateMissionData(179,0,0,goods.strengthenNum);
                        _optionsData.pos = "mission";
                     });
                  }
                  else
                  {
                     SoundManager.playSound("qhadd");
                     TextTip.instance.show(LangManager.t("qhOK",[addSExp]));
                     touchable = true;
                  }
                  if(inGuide)
                  {
                     Guide.instance.guide(exitBtn);
                     exitBtn.enabled = true;
                  }
               });
            }
            else
            {
               SoundManager.playSound("zyfail");
               TextTip.instance.show(LangManager.t("optFail"));
               touchable = true;
            }
         });
      }
      
      private function _callTransfer(param1:int, param2:int, param3:Array) : void
      {
         var fromOnlyId:int = param1;
         var toOnlyId:int = param2;
         var stoneAry:Array = param3;
         touchable = false;
         var _this:Forge = this;
         GameServer.instance.transfer(fromOnlyId,toOnlyId,stoneAry,function(param1:Object):void
         {
            var goodsNum:Array;
            var goods:GoodsData;
            var retData:Object = param1;
            trace(JSON.stringify(retData));
            if(retData.ret == 0)
            {
               goods = GoodsList.instance.getGoodsByOnlyID(retData.fromOnlyId);
               goods.resolveSynthesis(retData.fromSynthesis);
               goods = GoodsList.instance.getGoodsByOnlyID(retData.toOnlyId);
               goods.resolveSynthesis(retData.toSynthesis);
               if(zyok.data)
               {
                  GoodsList.instance.reduceConsumeGoods(40,1013,10);
                  goodsNum = GoodsList.instance.getConsumeGoods(40,1013);
                  zps1.text = LangManager.t("needZyStone",[goodsNum[goodsNum.length - 1]]);
               }
               else
               {
                  AccountData.instance.boyaaCoin -= goods.getShiftBoyaaCoin();
                  boyaaCoin.text = AccountData.instance.boyaaCoin.toString();
               }
               showZYInfo();
               SoundManager.playSound("qhzyok");
               heightlineBox(function():void
               {
                  touchable = true;
                  createList(_this[currentShow + "Content"]);
                  TextTip.instance.show(LangManager.t("zyOK"));
               });
            }
            else if(retData.ret == 2)
            {
               GoodsList.instance.reduceConsumeGoods(40,1013,10);
               goodsNum = GoodsList.instance.getConsumeGoods(40,1013);
               zps1.text = LangManager.t("needZyStone",[goodsNum[goodsNum.length - 1]]);
               touchable = true;
               SoundManager.playSound("zyfail");
               TextTip.instance.show(LangManager.t("zyFail"));
            }
            else
            {
               touchable = true;
               SoundManager.playSound("zyfail");
               TextTip.instance.show(LangManager.t("optFail"));
            }
         });
      }
      
      private function createZY() : void
      {
         var _loc6_:int = 0;
         zhuanYiContent = new Sprite();
         addChild(zhuanYiContent);
         zhuanYiContent.visible = false;
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("forgebg1"));
         zhuanYiContent.addChild(_loc2_);
         Assets.sAsset.positionDisplay(_loc2_,"forge","forgebg1");
         var _loc8_:Image = new Image(Assets.sAsset.getTexture("forgebg20"));
         Assets.positionDisplay(_loc8_,"forge","title");
         zhuanYiContent.addChild(_loc8_);
         var _loc7_:Button = new Button(Assets.sAsset.getTexture("helpbtn0"),"",Assets.sAsset.getTexture("helpbtn1"));
         Assets.positionDisplay(_loc7_,"forge","helpbtn");
         _loc7_.x = exitBtn.x - exitBtn.width - 10;
         zhuanYiContent.addChild(_loc7_);
         _loc7_.addEventListener("triggered",onHelp);
         createList(zhuanYiContent);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("forgebg2"));
         Assets.positionDisplay(_loc4_,"forge","zbox1");
         zhuanYiContent.addChild(_loc4_);
         var _loc11_:TextField = new TextField(190,30,LangManager.t("sxsc"),"Verdana",24,16777215);
         _loc11_.nativeFilters = myFilters;
         zhuanYiContent.addChild(_loc11_);
         _loc11_.x = _loc4_.x + (_loc4_.width - 190 >> 1);
         _loc11_.y = _loc4_.y + (_loc4_.height - 30 >> 1);
         _loc11_.autoScale = true;
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("forgebg2"));
         Assets.positionDisplay(_loc3_,"forge","zbox2");
         zhuanYiContent.addChild(_loc3_);
         var _loc10_:Image = new Image(Assets.sAsset.getTexture("hightbg"));
         _loc10_.name = "lefboxH";
         Assets.sAsset.positionDisplay(_loc10_,"forge","zbox2");
         _loc10_.visible = false;
         zhuanYiContent.addChild(_loc10_);
         _loc11_ = new TextField(190,30,LangManager.t("sxjs"),"Verdana",24,16777215);
         _loc11_.nativeFilters = myFilters;
         zhuanYiContent.addChild(_loc11_);
         _loc11_.x = _loc3_.x + (_loc3_.width - 190 >> 1);
         _loc11_.y = _loc3_.y + (_loc3_.height - 30 >> 1);
         _loc11_.autoScale = true;
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("forgebg14"));
         _loc1_.scaleX = _loc1_.scaleY = 2;
         _loc1_.x = 450;
         _loc1_.y = 460;
         zhuanYiContent.addChild(_loc1_);
         posHelper = Assets.sAsset.getPosition("forge","zptitle");
         zptitle = new TextField(posHelper.width + 10,posHelper.height + 10,"","Verdana",24,16777215);
         zptitle.nativeFilters = myFilters;
         zptitle.hAlign = "center";
         zptitle.vAlign = "center";
         zptitle.x = posHelper.x - 5;
         zptitle.y = posHelper.y - 5;
         zhuanYiContent.addChild(zptitle);
         posHelper = Assets.sAsset.getPosition("forge","zptitle2");
         zptitle2 = new TextField(posHelper.width + 10,posHelper.height + 10,"","Verdana",24,16777215);
         zptitle2.nativeFilters = myFilters;
         zptitle2.hAlign = "center";
         zptitle2.vAlign = "center";
         zptitle2.x = posHelper.x - 5;
         zptitle2.y = posHelper.y - 5;
         zhuanYiContent.addChild(zptitle2);
         posHelper = Assets.sAsset.getPosition("forge","zplevel");
         zplevel = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("level") + ": 0","Verdana",24,16777215);
         zplevel.nativeFilters = myFilters;
         zplevel.hAlign = "left";
         zplevel.vAlign = "center";
         zplevel.x = posHelper.x + 20;
         zplevel.y = posHelper.y - 5;
         zplevel.autoScale = true;
         zhuanYiContent.addChild(zplevel);
         posHelper = Assets.sAsset.getPosition("forge","zplevel2");
         zplevel2 = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("level") + ": 0","Verdana",24,16777215);
         zplevel2.nativeFilters = myFilters;
         zplevel2.hAlign = "left";
         zplevel2.vAlign = "center";
         zplevel2.x = posHelper.x + 20;
         zplevel2.y = posHelper.y - 5;
         zplevel2.autoScale = true;
         zhuanYiContent.addChild(zplevel2);
         posHelper = Assets.sAsset.getPosition("forge","zpattr");
         zpattr = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("attr") + ": 0","Verdana",24,16777215);
         zpattr.nativeFilters = myFilters;
         zpattr.hAlign = "left";
         zpattr.vAlign = "center";
         zpattr.x = posHelper.x + 20;
         zpattr.y = posHelper.y - 5;
         zpattr.autoScale = true;
         zhuanYiContent.addChild(zpattr);
         posHelper = Assets.sAsset.getPosition("forge","zpattr2");
         zpattr2 = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("attr") + ": 0","Verdana",24,16777215);
         zpattr2.nativeFilters = myFilters;
         zpattr2.hAlign = "left";
         zpattr2.vAlign = "center";
         zpattr2.x = posHelper.x + 20;
         zpattr2.y = posHelper.y - 5;
         zpattr2.autoScale = true;
         zhuanYiContent.addChild(zpattr2);
         posHelper = Assets.sAsset.getPosition("forge","zps1");
         var _loc5_:Array = GoodsList.instance.getConsumeGoods(40,1013);
         zps1 = new TextField(posHelper.width + 10,posHelper.height + 10,LangManager.t("needZyStone",[_loc5_[_loc5_.length - 1]]),"Verdana",24,16777215);
         zps1.nativeFilters = myFilters;
         zps1.hAlign = "left";
         zps1.vAlign = "center";
         zps1.x = posHelper.x + 50;
         zps1.y = posHelper.y - 5;
         zhuanYiContent.addChild(zps1);
         var _loc12_:Image = Assets.sAsset.getGoodsImage(40,1013);
         _loc12_.x = posHelper.x - 5;
         _loc12_.y = posHelper.y - 5;
         _loc12_.width = _loc12_.height = 50;
         zhuanYiContent.addChild(_loc12_);
         posHelper = Assets.sAsset.getPosition("forge","zps2");
         zps2 = new TextField(posHelper.width + 50,posHelper.height + 10,LangManager.t("zycgl") + "100%","Verdana",24,16777215);
         zps2.nativeFilters = myFilters;
         zps2.hAlign = "left";
         zps2.vAlign = "center";
         zps2.x = posHelper.x - 5;
         zps2.y = posHelper.y - 5;
         zhuanYiContent.addChild(zps2);
         posHelper = Assets.sAsset.getPosition("forge","zps3");
         var _loc9_:Image = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         _loc9_.x = posHelper.x;
         _loc9_.y = posHelper.y;
         zhuanYiContent.addChild(_loc9_);
         zps3 = new TextField(posHelper.width + 40,posHelper.height + 10,"0","Verdana",24,16777215);
         zps3.nativeFilters = myFilters;
         zps3.hAlign = "left";
         zps3.vAlign = "center";
         zps3.x = posHelper.x + _loc9_.width + 10;
         zps3.y = posHelper.y - 5;
         zhuanYiContent.addChild(zps3);
         zyok = new Radio();
         Assets.positionDisplay(zyok,"forge","zyok");
         zhuanYiContent.addChild(zyok);
         zyok1 = new Radio();
         zyok1.data = true;
         Assets.positionDisplay(zyok1,"forge","zyok1");
         zhuanYiContent.addChild(zyok1);
         zyok.addEventListener("triggered",onZyOk);
         zyok1.addEventListener("triggered",onZyOk);
         var _loc13_:Button = new Button(Assets.sAsset.getTexture("forgebg15"),"",Assets.sAsset.getTexture("forgebg16"));
         Assets.positionDisplay(_loc13_,"forge","zybtn");
         zhuanYiContent.addChild(_loc13_);
         _loc13_.addEventListener("triggered",onActionBtn);
         _loc6_ = 1;
         while(_loc6_ <= 3)
         {
            this["zps" + _loc6_].autoScale = true;
            _loc6_++;
         }
      }
      
      private function onHelp(param1:Event) : void
      {
         if(currentShow == "qiangHua")
         {
            helpDlg = new HelpDlg();
            addChild(helpDlg);
            helpDlg.x = 1365 - helpDlg.width >> 1;
            helpDlg.y = 768 - helpDlg.height >> 1;
            helpDlg.txt = LangManager.t("qhhelp");
         }
         else if(currentShow == "zhuanYi")
         {
            helpDlg = new HelpDlg();
            addChild(helpDlg);
            helpDlg.x = 1365 - helpDlg.width >> 1;
            helpDlg.y = 768 - helpDlg.height >> 1;
            helpDlg.txt = LangManager.t("zyhelp");
         }
      }
      
      private function onZyOk(param1:Event) : void
      {
         var _loc2_:GoodsData = null;
         if(param1.target == zyok)
         {
            zyok1.data = !zyok1.data;
         }
         else
         {
            zyok.data = !zyok.data;
         }
         if(zyok1.data)
         {
            zps2.text = LangManager.t("zycgl") + "100%";
         }
         else if(goodsbox1)
         {
            _loc2_ = GoodsList.instance.getGoodsByOnlyID(parseInt(goodsbox1.name));
            zps2.text = LangManager.t("zycgl") + _loc2_.getShiftProbability().toString() + "%";
         }
         else
         {
            zps2.text = LangManager.t("zycgl") + "0%";
         }
      }
      
      private function onQianghua(param1:Event) : void
      {
         gotoShow("qiangHua");
      }
      
      private function onZhuangyi(param1:Event) : void
      {
         if(inGuide)
         {
            return;
         }
         gotoShow("zhuanYi");
      }
      
      private function onSynthesis(param1:Event) : void
      {
         gotoShow("_synthesis");
      }
      
      private function onAddition(param1:Event) : void
      {
         gotoShow("_addition");
      }
      
      private function onBack(param1:Event) : void
      {
         if(currentShow == "select")
         {
            onExitBtnClick();
         }
         else
         {
            gotoShow("select");
         }
      }
      
      private function onExitBtnClick(param1:Event = null) : void
      {
         if(inGuide)
         {
            inGuide = false;
            Guide.instance.stop();
            _optionsData.pos = "mission";
         }
         Starling.juggler.tween(this,0.4,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn"
         });
         this.dispatchEventWith("complete");
      }
      
      override public function dispose() : void
      {
         Starling.juggler.removeTweens(this);
         Assets.sAsset.removeTextureAtlas("forge");
         super.dispose();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc4_:* = _loc2_;
         if("forgeMission" === _loc4_)
         {
            if(param1 && param1 == "forge")
            {
               _loc3_ = int(_currentSelectGoodsData.nextStrengthenExp()) - int(_currentSelectGoodsData.strengthenExp) / 10;
               if(int(qhStoneNum[qhStoneNum.length - 1]) < _loc3_)
               {
                  GuideEventManager.instance.dispactherEvent("newUI",[[addStone,40]]);
               }
               else
               {
                  GuideEventManager.instance.dispactherEvent("newUI",[[qiangHuaContent.getChildByName("forgeBtn"),50]]);
               }
            }
            else
            {
               GuideEventManager.instance.dispactherEvent("newUI",[[selectContent.getChildByName("qiangHuaBtn"),20],[container,30]]);
            }
         }
      }
   }
}

