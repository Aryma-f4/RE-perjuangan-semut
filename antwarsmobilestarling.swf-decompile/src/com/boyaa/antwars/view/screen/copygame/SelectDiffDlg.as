package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class SelectDiffDlg extends Sprite implements IGuideProcess
   {
      
      public var btnNormal:Button;
      
      private var imgUnOpen:Image;
      
      private var imgOpen:Image;
      
      private var smallStar:Image;
      
      private var tip:TextField;
      
      private var tip1:TextField;
      
      private var txtStarNum:TextField;
      
      private var txt0:TextField;
      
      private var txt1:TextField;
      
      private var txtStarNum1:TextField;
      
      private var txt2:TextField;
      
      private var txt3:TextField;
      
      private var myFilters:Array = [];
      
      private var btnHero:Button;
      
      private var normalGoodsImgs:Array = [[34,1011],[1,1051],[1,1061],[1,1071],[1,1081]];
      
      private var heroGoodsImgs:Array = [[34,1021],[1,1111],[1,1121],[1,1131],[1,1141],[1,1151]];
      
      private var goodsDataVector:Vector.<ShopData>;
      
      private var heroGoodsDataVector:Vector.<ShopData>;
      
      private var goodsBox:GoodsDetailView;
      
      private var normalGoodsArr:Vector.<GoodsDetailView> = new Vector.<GoodsDetailView>();
      
      private var heroGoodsArr:Vector.<GoodsDetailView> = new Vector.<GoodsDetailView>();
      
      private var herobgArr:Vector.<DisplayObject>;
      
      private var currentCopyWorld:Image;
      
      private const OPEN_HORE_STAR_NUM:int = 20;
      
      private var normalStarCount:int = 0;
      
      public function SelectDiffDlg()
      {
         super();
         initData();
         initView();
      }
      
      private function onAddToState(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToState);
         initData();
         initView();
      }
      
      private function initData() : void
      {
         var _loc4_:int = 0;
         var _loc1_:ShopData = null;
         var _loc2_:int = 0;
         var _loc3_:ShopData = null;
         goodsDataVector = new Vector.<ShopData>();
         heroGoodsDataVector = new Vector.<ShopData>();
         _loc4_ = 0;
         while(_loc4_ < normalGoodsImgs.length)
         {
            _loc1_ = ShopDataList.instance.getSingleData(normalGoodsImgs[_loc4_][0],normalGoodsImgs[_loc4_][1]);
            goodsDataVector.push(_loc1_);
            _loc4_++;
         }
         _loc2_ = 0;
         while(_loc2_ < heroGoodsImgs.length)
         {
            _loc3_ = ShopDataList.instance.getSingleData(heroGoodsImgs[_loc2_][0],heroGoodsImgs[_loc2_][1]);
            heroGoodsDataVector.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function initGoodsImages() : void
      {
         var _loc1_:String = CopyGame(this.parent).whichBtnClick;
         switch(_loc1_)
         {
            case "tkzc":
               currentCopyWorld.texture = Assets.sAsset.getTexture("ms9");
               normalGoodsImgs = [[1,1201],[2,1201],[6,1201],[7,1201],[8,1201]];
               heroGoodsImgs = [[1,1202],[2,1202],[6,1202],[7,1202],[8,1202]];
               break;
            case "lszc":
               currentCopyWorld.texture = Assets.sAsset.getTexture("ms11");
               normalGoodsImgs = [[1,1211],[2,1211],[6,1211],[7,1211],[8,1211]];
               heroGoodsImgs = [[1,1212],[2,1212],[6,1212],[7,1212],[8,1212]];
               break;
            case "jlxg":
               currentCopyWorld.texture = Assets.sAsset.getTexture("ms12");
               normalGoodsImgs = [[1,1221],[2,1221],[6,1221],[7,1221]];
               heroGoodsImgs = [[1,1222],[2,1222],[6,1222],[7,1222]];
         }
      }
      
      private function initView() : void
      {
         var _loc3_:DropShadowFilter = new DropShadowFilter(1,45,3342336,1,5,5,1);
         myFilters = [];
         myFilters.push(_loc3_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("ms1"));
         Assets.positionDisplay(_loc1_,"copyMode","bg");
         addChild(_loc1_);
         currentCopyWorld = new Image(Assets.sAsset.getTexture("ms9"));
         Assets.positionDisplay(currentCopyWorld,"copyMode","txtName");
         addChild(currentCopyWorld);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("ms2"));
         Assets.positionDisplay(_loc2_,"copyMode","bg1");
         addChild(_loc2_);
         imgUnOpen = new Image(Assets.sAsset.getTexture("ms4"));
         Assets.positionDisplay(imgUnOpen,"copyMode","bg2");
         addChild(imgUnOpen);
         imgOpen = new Image(Assets.sAsset.getTexture("ms10"));
         Assets.positionDisplay(imgOpen,"copyMode","bg2");
         imgOpen.visible = false;
         addChild(imgOpen);
         tip = new TextField(250,40,LangManager.t("selectDiffDlgTip1") + 20,"Verdana",24,4594438);
         tip1 = new TextField(250,30,LangManager.getLang.getreplaceLang("selectDiffDlgTip2",20),"Verdana",22,4594438);
         Assets.positionDisplay(tip,"copyMode","tip");
         addChild(tip);
         Assets.positionDisplay(tip1,"copyMode","tip1");
         addChild(tip1);
         smallStar = new Image(Assets.sAsset.getTexture("ms5"));
         Assets.positionDisplay(smallStar,"copyMode","tipStar");
         addChild(smallStar);
         addNroamlMode();
      }
      
      private function addNroamlMode() : void
      {
         var _loc1_:Image = null;
         var _loc6_:int = 0;
         var _loc2_:TextField = new TextField(60,30,LangManager.t("gain"),"Verdana",24,4594438,true);
         Assets.positionDisplay(_loc2_,"copyMode","txtHave0");
         addChild(_loc2_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("ms8"));
         _loc3_.touchable = false;
         Assets.positionDisplay(_loc3_,"copyMode","star");
         addChild(_loc3_);
         var _loc5_:DropShadowFilter = new DropShadowFilter(1,45,3342336,1,5,5,1);
         var _loc4_:Array = [];
         _loc4_.push(_loc5_);
         txtStarNum = new TextField(100,30,"X0","Verdana",30,16777215);
         Assets.positionDisplay(txtStarNum,"copyMode","starNum");
         txtStarNum.nativeFilters = _loc4_;
         addChild(txtStarNum);
         txt0 = new TextField(120,30,LangManager.t("dropoutGoods"),"Verdana",24,4594438);
         Assets.positionDisplay(txt0,"copyMode","txt0");
         addChild(txt0);
         _loc6_ = 0;
         while(_loc6_ < 6)
         {
            _loc1_ = new Image(Assets.sAsset.getTexture("ms3"));
            _loc1_.touchable = false;
            Assets.positionDisplay(_loc1_,"copyMode","goods" + _loc6_);
            addChild(_loc1_);
            _loc6_++;
         }
         btnNormal = new Button(Assets.sAsset.getTexture("ms6"),"",Assets.sAsset.getTexture("ms7"));
         Assets.positionDisplay(btnNormal,"copyMode","btnStart");
         btnNormal.addEventListener("triggered",enterLevelMap);
         addChild(btnNormal);
      }
      
      public function addNoramlGoodsImg() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Rectangle = null;
         for each(var _loc1_ in normalGoodsArr)
         {
            _loc1_.removeFromParent();
         }
         normalGoodsArr = new Vector.<GoodsDetailView>();
         _loc3_ = 0;
         while(_loc3_ < goodsDataVector.length)
         {
            _loc2_ = Assets.getPosition("copyMode","goods" + _loc3_);
            goodsBox = new GoodsDetailView(_loc2_,goodsDataVector[_loc3_]);
            goodsBox.addEvent();
            addChild(goodsBox);
            normalGoodsArr.push(goodsBox);
            _loc3_++;
         }
      }
      
      public function addHeroGoodsImg() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Rectangle = null;
         for each(var _loc1_ in heroGoodsArr)
         {
            _loc1_.removeFromParent();
         }
         heroGoodsArr = new Vector.<GoodsDetailView>();
         _loc3_ = 0;
         while(_loc3_ < heroGoodsDataVector.length)
         {
            _loc2_ = Assets.getPosition("copyMode","goods1" + _loc3_);
            goodsBox = new GoodsDetailView(_loc2_,heroGoodsDataVector[_loc3_]);
            goodsBox.addEvent();
            addChild(goodsBox);
            heroGoodsArr.push(goodsBox);
            _loc3_++;
         }
      }
      
      private function addHeroMode() : void
      {
         var _loc3_:Image = null;
         var _loc4_:int = 0;
         if(herobgArr)
         {
            for each(var _loc2_ in herobgArr)
            {
               _loc2_.removeFromParent();
            }
         }
         herobgArr = new Vector.<DisplayObject>();
         var _loc1_:TextField = new TextField(60,30,LangManager.t("gain"),"Verdana",24,4594438,true);
         Assets.positionDisplay(_loc1_,"copyMode","txtHave1");
         addChild(_loc1_);
         herobgArr.push(_loc1_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("ms8"));
         _loc5_.touchable = false;
         Assets.positionDisplay(_loc5_,"copyMode","star1");
         addChild(_loc5_);
         herobgArr.push(_loc5_);
         txtStarNum1 = new TextField(100,30,"X 0","Verdana",30,16777215);
         Assets.positionDisplay(txtStarNum1,"copyMode","starNum1");
         txtStarNum1.nativeFilters = myFilters;
         addChild(txtStarNum1);
         herobgArr.push(txtStarNum1);
         txt2 = new TextField(120,30,LangManager.t("dropoutGoods"),"Verdana",24,4594438);
         Assets.positionDisplay(txt2,"copyMode","txt2");
         addChild(txt2);
         herobgArr.push(txt2);
         _loc1_.autoScale = txtStarNum1.autoScale = txt2.autoScale = true;
         _loc4_ = 0;
         while(_loc4_ < 6)
         {
            _loc3_ = new Image(Assets.sAsset.getTexture("ms3"));
            _loc3_.touchable = false;
            Assets.positionDisplay(_loc3_,"copyMode","goods1" + _loc4_);
            addChild(_loc3_);
            herobgArr.push(_loc3_);
            _loc4_++;
         }
         btnHero = new Button(Assets.sAsset.getTexture("ms6"),"",Assets.sAsset.getTexture("ms7"));
         Assets.positionDisplay(btnHero,"copyMode","btnStart1");
         btnHero.addEventListener("triggered",enterLevelMapHero);
         addChild(btnHero);
         herobgArr.push(btnHero);
      }
      
      private function enterLevelMapHero(param1:Event) : void
      {
         Application.instance.currentGame._copyModeOptionsData.mode = "hero";
         enterGameWorld();
      }
      
      public function update(param1:int) : void
      {
         initGoodsImages();
         initData();
         addNoramlGoodsImg();
         normalStarCount = param1;
         txtStarNum.text = "X " + param1;
         if(param1 >= 20 || Constants.debug)
         {
            imgUnOpen.visible = false;
            tip.visible = tip1.visible = smallStar.visible = false;
            imgOpen.visible = true;
            addHeroMode();
            addHeroGoodsImg();
         }
         else
         {
            if(herobgArr)
            {
               for each(var _loc3_ in herobgArr)
               {
                  _loc3_.removeFromParent();
               }
            }
            if(heroGoodsArr)
            {
               for each(var _loc2_ in heroGoodsArr)
               {
                  _loc2_.removeFromParent();
               }
            }
            imgUnOpen.visible = true;
            tip.visible = tip1.visible = smallStar.visible = true;
            imgOpen.visible = false;
         }
      }
      
      public function updateHero(param1:int) : void
      {
         if(normalStarCount >= 20)
         {
            txtStarNum1.text = "X " + param1;
         }
      }
      
      private function enterLevelMap(param1:Event) : void
      {
         Guide.instance.stop();
         Application.instance.currentGame._copyModeOptionsData.mode = "normal";
         enterGameWorld();
      }
      
      private function enterGameWorld() : void
      {
         switch(CopyGame(this.parent).whichBtnClick)
         {
            case "jlxg":
               if(PlayerDataList.instance.selfData.level < 20)
               {
                  TextTip.instance.show(LangManager.t("levelerror") + "20");
                  return;
               }
               this.parent.dispatchEventWith("showSpriteCity");
               break;
            case "lszc":
               if(PlayerDataList.instance.selfData.level < 10)
               {
                  TextTip.instance.show(LangManager.t("levelerror") + "10");
                  return;
               }
               this.parent.dispatchEventWith("showSpiderCity");
               break;
            case "tkzc":
               this.parent.dispatchEventWith("showSkyCity");
         }
      }
      
      override public function dispose() : void
      {
         parent.removeChild(this);
         super.dispose();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc4_:SubMissionData = null;
         var _loc2_:int = 0;
         GuideTipManager.instance.currentProcess = this;
         var _loc3_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc5_:Array = [btnNormal,btnHero];
         var _loc6_:* = _loc3_;
         if("copyMission" === _loc6_)
         {
            _loc4_ = MissionGuideValue.instance.getUnCompleteSubMissions();
            _loc2_ = _loc4_.pframe / 10 % 2;
            GuideEventManager.instance.dispactherEvent("newUI",[[_loc5_[_loc2_],30]]);
         }
      }
   }
}

