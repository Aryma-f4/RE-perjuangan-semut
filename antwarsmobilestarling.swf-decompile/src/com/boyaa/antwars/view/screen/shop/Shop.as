package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.tool.TweenQueue;
   import feathers.controls.List;
   import feathers.controls.Screen;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.TiledRowsLayout;
   import feathers.textures.Scale9Textures;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.RectangleUtil;
   
   public class Shop extends Screen
   {
      
      public static var goShopping:int = 0;
      
      public static const INDEXSHOP:int = 0;
      
      public static const WEAPONSHOP:int = 1;
      
      public static const ARMORSHOP:int = 2;
      
      public static const ACCESSORYSHOP:int = 3;
      
      public static const PROPSHOP:int = 4;
      
      public static const RECOMMENDHOP:int = 5;
      
      private var page1:Sprite;
      
      private var page2:Sprite;
      
      private var frameBtns:Sprite;
      
      private var titleSprite:Sprite;
      
      private var accountInfoSprite:Sprite;
      
      private var btn0Sprite:Sprite;
      
      private var btn1Sprite:Sprite;
      
      private var btn2Sprite:Sprite;
      
      private var btn3Sprite:Sprite;
      
      private var btn4Sprite:Sprite;
      
      private var longTip:ShopItemDetailTip;
      
      private var shortTip:SmallTip;
      
      private var bg:Image;
      
      private var bgFrame:Scale9Image;
      
      private var currentWeapon:Image;
      
      private var radioSelected:Image;
      
      private var imgClearDisable:Image;
      
      private var btnRecomend:Button;
      
      private var btnWeapon:Button;
      
      private var btnArmor:Button;
      
      private var btnAccessory:Button;
      
      private var btnProp:Button;
      
      public var exitBtn:Button;
      
      private var btnBack:Button;
      
      private var btnClear:Button;
      
      private var btnRecharge:Button;
      
      private var btnCheck:Button;
      
      private var btnBuy:Button;
      
      private var list:List;
      
      private var recommendListData:ListCollection;
      
      private var weaponListData:ListCollection;
      
      private var propListData:ListCollection;
      
      private var accessoryListData:ListCollection;
      
      private var armorListData:ListCollection;
      
      private var boyaaCoin:TextField;
      
      private var gameGold:TextField;
      
      private var accountData:AccountData;
      
      private var currentShopData:ShopData;
      
      private var shopDataWears:Vector.<ShopData>;
      
      private var character:Character;
      
      private var valueTexts:Vector.<TextField>;
      
      private var keyTexts:Vector.<TextField>;
      
      private var screenItems:Dictionary;
      
      private var buyType:int = 3;
      
      private var currentList:int = 0;
      
      public var inGuide:Boolean = false;
      
      protected var _optionsData:Object;
      
      private var buyDlg:ShopBuyDlg;
      
      private var _showListType:String = "0";
      
      public function Shop()
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
         this.addEventListener("removedFromStage",onRemoveFromStage);
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
      
      override protected function initialize() : void
      {
         ShopDataList.instance.shopType = 0;
         screenItems = Assets.getScreenPos("shop");
         bg = new Image(Assets.sAsset.getTexture("bb_bg"));
         bg.width = 1365;
         bg.height = 768;
         this.addChild(bg);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("shop_top_bar"));
         _loc1_.touchable = false;
         addChild(_loc1_);
         exitBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         exitBtn.x = Assets.rightTop.x - exitBtn.width;
         exitBtn.y = Assets.rightTop.y + exitBtn.height / 2;
         exitBtn.addEventListener("triggered",onExitBtnClick);
         this.addChild(exitBtn);
         initPage1();
         initPage2();
      }
      
      override protected function draw() : void
      {
      }
      
      private function initPage1() : void
      {
         page1 = new Sprite();
         btn0Sprite = new Sprite();
         btn1Sprite = new Sprite();
         btn2Sprite = new Sprite();
         btn3Sprite = new Sprite();
         btn4Sprite = new Sprite();
         page1.addChild(btn0Sprite);
         page1.addChild(btn1Sprite);
         page1.addChild(btn2Sprite);
         page1.addChild(btn3Sprite);
         page1.addChild(btn4Sprite);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("sc_title"));
         Assets.sAsset.positionDisplay(_loc4_,"shop","title");
         _loc4_.touchable = false;
         page1.addChild(_loc4_);
         btnRecomend = new Button(Assets.sAsset.getTexture("bg9"),"",Assets.sAsset.getTexture("bg10"));
         btnRecomend.x = screenItems["btn0"].x;
         btnRecomend.y = screenItems["btn0"].y;
         btnRecomend.addEventListener("triggered",onRecommend);
         btn0Sprite.addChild(btnRecomend);
         btnWeapon = new Button(Assets.sAsset.getTexture("bg9"),"",Assets.sAsset.getTexture("bg10"));
         btnWeapon.x = screenItems["btn1"].x;
         btnWeapon.y = screenItems["btn1"].y;
         btnWeapon.addEventListener("triggered",onWeapon);
         btn1Sprite.addChild(btnWeapon);
         btnArmor = new Button(Assets.sAsset.getTexture("bg9"),"",Assets.sAsset.getTexture("bg10"));
         btnArmor.x = screenItems["btn2"].x;
         btnArmor.y = screenItems["btn2"].y;
         btnArmor.addEventListener("triggered",onArmor);
         btn2Sprite.addChild(btnArmor);
         btnAccessory = new Button(Assets.sAsset.getTexture("bg9"),"",Assets.sAsset.getTexture("bg10"));
         btnAccessory.x = screenItems["btn3"].x;
         btnAccessory.y = screenItems["btn3"].y;
         btnAccessory.addEventListener("triggered",onAccessory);
         btn3Sprite.addChild(btnAccessory);
         btnProp = new Button(Assets.sAsset.getTexture("bg9"),"",Assets.sAsset.getTexture("bg10"));
         btnProp.x = screenItems["btn4"].x;
         btnProp.y = screenItems["btn4"].y;
         btnProp.addEventListener("triggered",onProp);
         btn4Sprite.addChild(btnProp);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("tj2"));
         Assets.sAsset.positionDisplay(_loc2_,"shop","shop0");
         page1.addChild(_loc2_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("wq2"));
         Assets.sAsset.positionDisplay(_loc1_,"shop","shop1");
         page1.addChild(_loc1_);
         var _loc8_:Image = new Image(Assets.sAsset.getTexture("fj2"));
         Assets.sAsset.positionDisplay(_loc8_,"shop","shop2");
         page1.addChild(_loc8_);
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("sp2"));
         Assets.sAsset.positionDisplay(_loc7_,"shop","shop3");
         page1.addChild(_loc7_);
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("dj2"));
         Assets.sAsset.positionDisplay(_loc6_,"shop","shop4");
         page1.addChild(_loc6_);
         _loc2_.touchable = _loc1_.touchable = _loc8_.touchable = _loc7_.touchable = _loc6_.touchable = false;
         var _loc11_:Image = new Image(Assets.sAsset.getTexture("tuijian"));
         Assets.sAsset.positionDisplay(_loc11_,"shop","name0");
         page1.addChild(_loc11_);
         var _loc9_:Image = new Image(Assets.sAsset.getTexture("wuqi"));
         Assets.sAsset.positionDisplay(_loc9_,"shop","name1");
         page1.addChild(_loc9_);
         var _loc10_:Image = new Image(Assets.sAsset.getTexture("fj"));
         Assets.sAsset.positionDisplay(_loc10_,"shop","name2");
         page1.addChild(_loc10_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("sp"));
         Assets.sAsset.positionDisplay(_loc3_,"shop","name3");
         page1.addChild(_loc3_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("dj"));
         Assets.sAsset.positionDisplay(_loc5_,"shop","name4");
         page1.addChild(_loc5_);
         _loc11_.touchable = _loc9_.touchable = _loc10_.touchable = _loc3_.touchable = _loc5_.touchable = false;
         btn0Sprite.addChild(_loc2_);
         btn0Sprite.addChild(_loc11_);
         btn1Sprite.addChild(_loc1_);
         btn1Sprite.addChild(_loc9_);
         btn2Sprite.addChild(_loc8_);
         btn2Sprite.addChild(_loc10_);
         btn3Sprite.addChild(_loc7_);
         btn3Sprite.addChild(_loc3_);
         btn4Sprite.addChild(_loc6_);
         btn4Sprite.addChild(_loc5_);
         addChild(page1);
      }
      
      private function initPage2() : void
      {
         page2 = new Sprite();
         titleSprite = new Sprite();
         accountInfoSprite = new Sprite();
         shopDataWears = new Vector.<ShopData>();
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("tuijian"));
         Assets.sAsset.positionDisplay(_loc5_,"shop","title2");
         titleSprite.addChild(_loc5_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("wuqi"));
         Assets.sAsset.positionDisplay(_loc3_,"shop","title2");
         titleSprite.addChild(_loc3_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("fj"));
         Assets.sAsset.positionDisplay(_loc4_,"shop","title2");
         titleSprite.addChild(_loc4_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("sp"));
         Assets.sAsset.positionDisplay(_loc1_,"shop","title2");
         titleSprite.addChild(_loc1_);
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("dj"));
         Assets.sAsset.positionDisplay(_loc2_,"shop","title2");
         titleSprite.addChild(_loc2_);
         titleSprite.touchable = false;
         _loc3_.visible = _loc4_.visible = _loc1_.visible = _loc2_.visible = false;
         page2.addChild(titleSprite);
         initList();
         initAccountInfo();
         btnBack = new Button(Assets.sAsset.getTexture("back0"),"",Assets.sAsset.getTexture("back1"));
         btnBack.x = Assets.leftTop.x + 10;
         btnBack.y = Assets.leftTop.y + btnBack.height / 2 + 10;
         btnBack.addEventListener("triggered",onBack);
         page2.addChild(btnBack);
         initRoleInfo();
         btnClear = new Button(Assets.sAsset.getTexture("clear0"),"",Assets.sAsset.getTexture("clear1"));
         btnClear.x = screenItems["clear"].x;
         btnClear.y = screenItems["clear"].y - 50;
         btnClear.addEventListener("triggered",onClear);
         btnClear.visible = false;
         page2.addChild(btnClear);
         imgClearDisable = new Image(Assets.sAsset.getTexture("but3-2"));
         imgClearDisable.x = screenItems["clear"].x;
         imgClearDisable.y = screenItems["clear"].y - 50;
         page2.addChild(imgClearDisable);
         page2.visible = false;
         addChild(page2);
         initButtonFrame();
         switch(goShopping - 1)
         {
            case 0:
               onWeapon(null);
               break;
            case 1:
               onArmor(null);
               break;
            case 2:
               onAccessory(null);
               break;
            case 3:
               onProp(null);
               break;
            case 4:
               onRecommend(null);
         }
         goShopping = 0;
      }
      
      private function initAccountInfo() : void
      {
         var _loc6_:int = 0;
         var _loc3_:Button = null;
         accountData = AccountData.instance;
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         _loc2_.x = screenItems["goldBg1"].x;
         _loc2_.y = screenItems["goldBg1"].y;
         accountInfoSprite.addChild(_loc2_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         _loc4_.x = screenItems["goldBg2"].x;
         _loc4_.y = screenItems["goldBg2"].y;
         accountInfoSprite.addChild(_loc4_);
         btnRecharge = new Button(Assets.sAsset.getTexture("recharge8"),"",Assets.sAsset.getTexture("recharge7"));
         btnRecharge.x = screenItems["recharge"].x;
         btnRecharge.y = screenItems["recharge"].y;
         btnRecharge.addEventListener("triggered",onRecharge);
         accountInfoSprite.addChild(btnRecharge);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("gameGoldIcon"));
         _loc1_.x = screenItems["gameGoldIcon"].x;
         _loc1_.y = screenItems["gameGoldIcon"].y;
         accountInfoSprite.addChild(_loc1_);
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         _loc5_.x = screenItems["boyaaCoinIcon"].x;
         _loc5_.y = screenItems["boyaaCoinIcon"].y;
         accountInfoSprite.addChild(_loc5_);
         var _loc7_:Rectangle = Assets.getPosition("shop","gameGold");
         gameGold = new TextField(_loc7_.width,_loc7_.height,accountData.gameGold.toString(),"Verdana",24,16777215,true);
         gameGold.hAlign = "left";
         gameGold.vAlign = "top";
         gameGold.x = _loc7_.x;
         gameGold.y = _loc7_.y;
         accountInfoSprite.addChild(gameGold);
         _loc7_ = Assets.getPosition("shop","boyaaCoin");
         boyaaCoin = new TextField(_loc7_.width,_loc7_.height,accountData.boyaaCoin.toString(),"Verdana",24,16777215,true);
         boyaaCoin.hAlign = "left";
         boyaaCoin.vAlign = "top";
         boyaaCoin.x = _loc7_.x;
         boyaaCoin.y = _loc7_.y;
         accountInfoSprite.addChild(boyaaCoin);
         _loc6_ = 0;
         while(_loc6_ < 2)
         {
            _loc3_ = new Button(Assets.sAsset.getTexture("dx0"));
            _loc3_.name = _loc6_.toString();
            Assets.positionDisplay(_loc3_,"shop","radio" + _loc6_);
            _loc3_.addEventListener("triggered",onRadio);
            accountInfoSprite.addChild(_loc3_);
            _loc6_++;
         }
         _loc7_ = Assets.getPosition("shop","radio0");
         radioSelected = new Image(Assets.sAsset.getTexture("dx1"));
         radioSelected.x = _loc7_.x;
         radioSelected.y = _loc7_.y - 10;
         accountInfoSprite.addChild(radioSelected);
         page2.addChild(accountInfoSprite);
      }
      
      private function initList() : void
      {
         var _loc6_:int = 0;
         var _loc2_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         Assets.sAsset.positionDisplay(_loc2_,"shop","frame");
         var _loc1_:Quad = new Quad(_loc2_.width - 10,_loc2_.height - 10,4269333);
         _loc1_.x = _loc2_.x + 5;
         _loc1_.y = _loc2_.y + 5;
         page2.addChild(_loc1_);
         page2.addChild(_loc2_);
         recommendListData = new ListCollection(ShopDataList.instance.getShopDataMobile(1,PlayerDataList.instance.selfData.babySex));
         weaponListData = new ListCollection(ShopDataList.instance.getShopDataMobile(2,PlayerDataList.instance.selfData.babySex));
         var _loc5_:Array = ShopDataList.instance.getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
         var _loc4_:int = int(_loc5_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            if((_loc5_[_loc6_] as ShopData).typeID == 15 && (_loc5_[_loc6_] as ShopData).frameID == 1013)
            {
               _loc5_.unshift(_loc5_[_loc6_]);
               _loc5_.splice(_loc6_ + 1,1);
               break;
            }
            _loc6_++;
         }
         propListData = new ListCollection(_loc5_);
         accessoryListData = new ListCollection(ShopDataList.instance.getShopDataMobile(4,PlayerDataList.instance.selfData.babySex));
         armorListData = new ListCollection(ShopDataList.instance.getShopDataMobile(5,PlayerDataList.instance.selfData.babySex));
         list = new List();
         list.itemRendererType = ShopItemRenderer;
         list.addEventListener("change",listChangeHandler);
         var _loc3_:TiledRowsLayout = new TiledRowsLayout();
         _loc3_.useSquareTiles = false;
         _loc3_.gap = 5;
         _loc3_.paddingTop = 5;
         list.layout = _loc3_;
         Assets.positionDisplay(list,"shop","item");
         page2.addChild(list);
      }
      
      private function initButtonFrame() : void
      {
         frameBtns = new Sprite();
         bgFrame = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         bgFrame.width = 314;
         bgFrame.height = 96;
         frameBtns.addChild(bgFrame);
         btnCheck = new Button(Assets.sAsset.getTexture("check0"),"",Assets.sAsset.getTexture("check1"));
         btnCheck.addEventListener("triggered",onCheck);
         frameBtns.addChild(btnCheck);
         var _loc1_:int = 15;
         btnBuy = new Button(Assets.sAsset.getTexture("buy0"),"",Assets.sAsset.getTexture("buy1"));
         btnBuy.x = _loc1_ + btnCheck.width;
         btnBuy.y = _loc1_;
         btnBuy.addEventListener("triggered",onBuy);
         frameBtns.addChild(btnBuy);
         btnCheck.x = _loc1_;
         btnCheck.y = btnBuy.y;
         frameBtns.visible = false;
         addChild(frameBtns);
      }
      
      private function initRoleInfo() : void
      {
         var _loc6_:Rectangle = null;
         var _loc10_:TextField = null;
         var _loc11_:* = 0;
         var _loc1_:TextField = null;
         var _loc7_:* = 0;
         var _loc9_:Image = new Image(Assets.sAsset.getTexture("bg6"));
         Assets.sAsset.positionDisplay(_loc9_,"shop","left_bg");
         page2.addChild(_loc9_);
         var _loc12_:Rectangle = Assets.getPosition("shop","character");
         character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.scaleY = 0.6;
         character.scaleX = character.scaleY;
         character.initData(PlayerDataList.instance.selfData.getPropData());
         takeOffClothes(PlayerDataList.instance.selfData.getPropData());
         character.x = _loc12_.x + (_loc12_.width >> 1);
         character.y = _loc12_.y + _loc12_.height;
         page2.addChild(character);
         var _loc3_:GlowFilter = new GlowFilter(4660230,1,6,6,10);
         var _loc8_:Array = [];
         _loc8_.push(_loc3_);
         keyTexts = new Vector.<TextField>();
         var _loc4_:Array = LangManager.ta("detailsNameArr");
         var _loc5_:Array = PlayerDataList.instance.selfData.ability();
         _loc11_ = 0;
         while(_loc11_ < 6)
         {
            _loc6_ = Assets.sAsset.getPosition("shop","property" + _loc11_);
            _loc10_ = new TextField(_loc6_.width,_loc6_.height,_loc4_[_loc11_] + "：0","Verdana",24,16777215);
            Assets.sAsset.positionDisplay(_loc10_,"shop","property" + _loc11_);
            _loc10_.hAlign = "left";
            _loc10_.touchable = false;
            _loc10_.nativeFilters = _loc8_;
            keyTexts.push(_loc10_);
            page2.addChild(_loc10_);
            _loc11_++;
         }
         valueTexts = new Vector.<TextField>();
         _loc7_ = 0;
         while(_loc7_ < 6)
         {
            _loc6_ = Assets.sAsset.getPosition("shop","txt_num_" + _loc7_);
            _loc1_ = new TextField(_loc6_.width,_loc6_.height,"","Verdana",24,65280);
            Assets.sAsset.positionDisplay(_loc1_,"shop","txt_num_" + _loc7_);
            _loc1_.hAlign = "left";
            _loc1_.touchable = false;
            valueTexts.push(_loc1_);
            page2.addChild(_loc1_);
            _loc7_++;
         }
         _loc6_ = Assets.sAsset.getPosition("shop","levelText");
         var _loc2_:TextField = new TextField(_loc6_.width,_loc6_.height,"","Verdana",24,16777215);
         _loc2_.nativeFilters = _loc8_;
         _loc2_.x = _loc6_.x;
         _loc2_.y = _loc6_.y;
         _loc2_.hAlign = "left";
         _loc2_.autoScale = true;
         _loc2_.text = "LV" + PlayerDataList.instance.selfData.level;
         page2.addChild(_loc2_);
      }
      
      private function goPage2() : void
      {
         page1.visible = false;
         page2.visible = true;
      }
      
      private function goPage1() : void
      {
         page2.visible = false;
         page1.visible = true;
         page1.alpha = 0;
         Starling.juggler.tween(page1,0.6,{
            "alpha":1,
            "transition":"easeOut",
            "onComplete":function():void
            {
            }
         });
      }
      
      private function showCurrentWeapon(param1:ShopData) : void
      {
         var _loc2_:String = null;
         var _loc3_:Texture = null;
         var _loc5_:Rectangle = null;
         var _loc4_:Rectangle = null;
         if(param1)
         {
            _loc2_ = ShopDataList.instance.getWeaponImageString(param1);
            if(currentWeapon)
            {
               currentWeapon.removeFromParent();
            }
            _loc3_ = Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture(_loc2_);
            currentWeapon = new Image(_loc3_);
            _loc5_ = Assets.getPosition("shop","weapon");
            if(this.currentWeapon)
            {
               this.currentWeapon.pivotX = 0;
               this.currentWeapon.pivotY = 0;
               if(this.currentWeapon.width < _loc5_.width && this.currentWeapon.height < _loc5_.height)
               {
                  _loc4_ = RectangleUtil.fit(new Rectangle(0,0,this.currentWeapon.width,this.currentWeapon.height),_loc5_,"none");
               }
               else
               {
                  _loc4_ = RectangleUtil.fit(new Rectangle(0,0,this.currentWeapon.width,this.currentWeapon.height),_loc5_,"showAll");
               }
               this.currentWeapon.x = _loc4_.x;
               this.currentWeapon.y = _loc4_.y;
               this.currentWeapon.width = _loc4_.width;
               this.currentWeapon.height = _loc4_.height;
            }
            page2.addChild(currentWeapon);
         }
         else if(currentWeapon)
         {
            currentWeapon.removeFromParent();
         }
      }
      
      private function showTitle(param1:int) : void
      {
         var _loc3_:int = 0;
         currentList = param1;
         updateListByCoin(_showListType);
         var _loc2_:int = titleSprite.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            titleSprite.getChildAt(_loc3_).visible = false;
            _loc3_++;
         }
         titleSprite.getChildAt(param1).visible = true;
      }
      
      private function hideWearProperty() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = LangManager.ta("detailsNameArr");
         var _loc1_:int = int(valueTexts.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            valueTexts[_loc3_].text = "";
            keyTexts[_loc3_].text = _loc2_[_loc3_] + ":0";
            _loc3_++;
         }
      }
      
      private function onSelectedItem(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:ShopData = param1 as ShopData;
         currentShopData = _loc2_;
         if(inGuide)
         {
            if(_loc2_.typeID == 15 && _loc2_.frameID == 1013)
            {
               Guide.instance.guide(btnBuy,"",true);
               btnCheck.enabled = false;
               this.stage.removeEventListener("touch",onTouch);
               return;
            }
         }
         if(_loc2_.isEquipment)
         {
            btnClear.visible = true;
            imgClearDisable.visible = false;
            if(_loc2_.isWeapon)
            {
               showCurrentWeapon(_loc2_);
            }
            else
            {
               character.wearById(_loc2_.typeID,_loc2_.frameID);
            }
            _loc3_ = int(shopDataWears.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(currentShopData.typeID == shopDataWears[_loc4_].typeID)
               {
                  shopDataWears.splice(_loc4_,1);
                  break;
               }
               _loc4_++;
            }
            shopDataWears.push(currentShopData);
            updateWearProperty();
         }
         else
         {
            hideWearProperty();
         }
      }
      
      private function updateWearProperty() : void
      {
         var _loc6_:int = 0;
         var _loc4_:ShopData = null;
         var _loc3_:Array = null;
         var _loc1_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Array = [0,0,0,0,0,0];
         var _loc5_:int = int(shopDataWears.length);
         if(_loc5_ > 1)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc5_ - 1)
            {
               _loc4_ = shopDataWears[_loc6_];
               _loc2_[0] += _loc4_.attack;
               _loc2_[1] += _loc4_.defense;
               _loc2_[2] += _loc4_.lucky;
               _loc2_[3] += _loc4_.nimble;
               _loc2_[4] += _loc4_.damage;
               _loc2_[5] += _loc4_.armor;
               _loc6_++;
            }
            _loc3_ = LangManager.ta("detailsNameArr");
            _loc1_ = int(keyTexts.length);
            _loc7_ = 0;
            while(_loc7_ < _loc1_)
            {
               keyTexts[_loc7_].text = _loc3_[_loc7_] + ":" + _loc2_[_loc7_];
               _loc7_++;
            }
         }
         if(currentShopData.isEquipment)
         {
            valueTexts[0].text = "+" + currentShopData.attack;
            valueTexts[1].text = "+" + currentShopData.defense;
            valueTexts[2].text = "+" + currentShopData.lucky;
            valueTexts[3].text = "+" + currentShopData.nimble;
            valueTexts[4].text = "+" + currentShopData.damage;
            valueTexts[5].text = "+" + currentShopData.armor;
         }
      }
      
      private function updateListByCoin(param1:String) : void
      {
         var _loc10_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = 0;
         var _loc2_:Array = [];
         var _loc7_:Array = [];
         var _loc4_:Array = [];
         switch(currentList)
         {
            case 0:
               _loc4_ = ShopDataList.instance.getShopDataMobile(1,PlayerDataList.instance.selfData.babySex);
               _loc10_ = 0;
               while(_loc10_ < _loc4_.length)
               {
                  if(_loc4_[_loc10_].canBuyType(1))
                  {
                     _loc2_.push(_loc4_[_loc10_]);
                  }
                  else
                  {
                     _loc7_.push(_loc4_[_loc10_]);
                  }
                  _loc10_++;
               }
               if(param1 == "0")
               {
                  recommendListData.data = _loc7_;
               }
               else
               {
                  recommendListData.data = _loc2_;
               }
               list.dataProvider = recommendListData;
               break;
            case 1:
               _loc4_ = ShopDataList.instance.getShopDataMobile(2,PlayerDataList.instance.selfData.babySex);
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  if(_loc4_[_loc8_].canBuyType(1))
                  {
                     _loc2_.push(_loc4_[_loc8_]);
                  }
                  else
                  {
                     _loc7_.push(_loc4_[_loc8_]);
                  }
                  _loc8_++;
               }
               if(param1 == "0")
               {
                  weaponListData.data = _loc7_;
               }
               else
               {
                  weaponListData.data = _loc2_;
               }
               list.dataProvider = weaponListData;
               break;
            case 2:
               _loc4_ = ShopDataList.instance.getShopDataMobile(5,PlayerDataList.instance.selfData.babySex);
               _loc9_ = 0;
               while(_loc9_ < _loc4_.length)
               {
                  if(_loc4_[_loc9_].canBuyType(1))
                  {
                     _loc2_.push(_loc4_[_loc9_]);
                  }
                  else
                  {
                     _loc7_.push(_loc4_[_loc9_]);
                  }
                  _loc9_++;
               }
               if(param1 == "0")
               {
                  armorListData.data = _loc7_;
               }
               else
               {
                  armorListData.data = _loc2_;
               }
               list.dataProvider = armorListData;
               break;
            case 3:
               _loc4_ = ShopDataList.instance.getShopDataMobile(4,PlayerDataList.instance.selfData.babySex);
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  if(_loc4_[_loc5_].canBuyType(1))
                  {
                     _loc2_.push(_loc4_[_loc5_]);
                  }
                  else
                  {
                     _loc7_.push(_loc4_[_loc5_]);
                  }
                  _loc5_++;
               }
               if(param1 == "0")
               {
                  accessoryListData.data = _loc7_;
               }
               else
               {
                  accessoryListData.data = _loc2_;
               }
               list.dataProvider = accessoryListData;
               break;
            case 4:
               _loc4_ = ShopDataList.instance.getShopDataMobile(3,PlayerDataList.instance.selfData.babySex);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  if(_loc4_[_loc6_].canBuyType(1))
                  {
                     _loc2_.push(_loc4_[_loc6_]);
                  }
                  else
                  {
                     _loc7_.push(_loc4_[_loc6_]);
                  }
                  _loc6_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc7_.length)
               {
                  if((_loc7_[_loc3_] as ShopData).typeID == 15 && (_loc7_[_loc3_] as ShopData).frameID == 1013)
                  {
                     _loc7_.unshift(_loc7_[_loc3_]);
                     _loc7_.splice(_loc3_ + 1,1);
                     break;
                  }
                  _loc3_++;
               }
               if(param1 == "0")
               {
                  propListData.data = _loc7_;
               }
               else
               {
                  propListData.data = _loc2_;
               }
               list.dataProvider = propListData;
         }
         list.alpha = 0;
         Starling.juggler.tween(list,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
      }
      
      private function updateRoleInfo() : void
      {
         var _loc4_:* = 0;
         var _loc2_:Array = PlayerDataList.instance.selfData.ability();
         var _loc1_:Array = LangManager.ta("detailsNameArr");
         var _loc3_:int = int(valueTexts.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            keyTexts[_loc4_].text = _loc1_[_loc4_] + "：" + _loc2_[_loc4_];
            _loc4_++;
         }
         character.initData(PlayerDataList.instance.selfData.getPropData());
      }
      
      private function updateAccountInfo() : void
      {
         boyaaCoin.text = accountData.boyaaCoin.toString();
         gameGold.text = accountData.gameGold.toString();
         if(currentShopData && currentShopData.isEquipment)
         {
            if(currentShopData.isWeapon)
            {
               showCurrentWeapon(PlayerDataList.instance.selfData.getWeapon());
            }
            else
            {
               character.wearById(currentShopData.typeID,0);
            }
         }
         updateArrayData();
         if(inGuide)
         {
            Guide.instance.guide(exitBtn);
            exitBtn.enabled = true;
            _optionsData.pos = "mission";
         }
      }
      
      private function updateArrayData() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(shopDataWears.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(shopDataWears[_loc2_] == currentShopData)
            {
               shopDataWears.splice(_loc2_,1);
            }
            _loc2_++;
         }
         if(shopDataWears.length == 0)
         {
            btnClear.visible = false;
            imgClearDisable.visible = true;
         }
         currentShopData = null;
      }
      
      private function takeOffClothes(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(param1.length);
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               character.wearById(param1[_loc3_].typeID,0);
               _loc3_++;
            }
         }
      }
      
      private function buy() : void
      {
         buyDlg = new ShopBuyDlg();
         buyDlg.setData(currentShopData);
         buyDlg.buySignal.add(updateAccountInfo);
         addChild(buyDlg);
      }
      
      private function clear() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(shopDataWears.length);
         if(_loc1_ > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               character.wearById(shopDataWears[_loc2_].typeID,0);
               _loc2_++;
            }
            shopDataWears.length = 0;
         }
         showCurrentWeapon(null);
         hideWearProperty();
         btnClear.visible = false;
         imgClearDisable.visible = true;
         currentShopData = null;
      }
      
      private function listChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         if(inGuide)
         {
            if(_loc2_.selectedIndex != 0)
            {
               return;
            }
         }
         frameBtns.visible = true;
         frameBtns.alpha = 0;
         Starling.juggler.tween(frameBtns,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
         onSelectedItem(_loc2_.selectedItem);
         _loc2_.selectedIndex = -1;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.pivotX = 524;
         this.pivotY = 383;
         this.x = 524;
         this.y = 383;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut"
         });
         showButtonEffect();
         this.removeEventListener("addedToStage",onAddedToStage);
         this.stage.addEventListener("touch",onTouch);
      }
      
      private function showButtonEffect() : void
      {
         var tween:TweenQueue;
         btn0Sprite.scaleY = btn1Sprite.scaleY = btn2Sprite.scaleY = btn3Sprite.scaleY = btn4Sprite.scaleY = 0;
         tween = new TweenQueue();
         tween.add(btn0Sprite,0.2,{"scaleY":1});
         tween.add(btn1Sprite,0.2,{"scaleY":1});
         tween.add(btn2Sprite,0.2,{"scaleY":1});
         tween.add(btn3Sprite,0.2,{"scaleY":1});
         tween.add(btn4Sprite,0.2,{
            "scaleY":1,
            "onComplete":function():void
            {
               showGuide();
            }
         });
         tween.start();
      }
      
      private function showGuide() : void
      {
         if(_optionsData.pos == "shop")
         {
            Guide.instance.guide(btnProp,LangManager.t("guide10"),true);
            inGuide = true;
            btnAccessory.touchable = false;
            btnArmor.touchable = false;
            btnRecomend.touchable = false;
            btnWeapon.touchable = false;
         }
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         this.stage.removeEventListener("touch",onTouch);
         Starling.juggler.removeTweens(this);
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc3_ = param1.getTouches(list);
            if(_loc3_.length > 0 && _loc3_[0].phase == "began")
            {
               frameBtns.x = _loc3_[0].globalX;
               frameBtns.y = _loc3_[0].globalY;
               if(frameBtns.x > 700)
               {
                  frameBtns.x = 700;
               }
            }
            if(frameBtns.visible)
            {
               _loc4_ = param1.getTouches(frameBtns);
               if(_loc4_.length == 0)
               {
                  frameBtns.visible = false;
                  list.selectedIndex = -1;
               }
            }
         }
      }
      
      private function onRadio(param1:Event) : void
      {
         if(inGuide)
         {
            return;
         }
         var _loc2_:Button = param1.target as Button;
         radioSelected.x = _loc2_.x;
         radioSelected.y = _loc2_.y - 9;
         radioSelected.visible = true;
         buyType = _loc2_.name == "0" ? 3 : 1;
         _showListType = _loc2_.name;
         updateListByCoin(_showListType);
      }
      
      private function onCheck(param1:Event) : void
      {
         if(!currentShopData.isEquipment)
         {
            if(!shortTip)
            {
               shortTip = SmallTip.getInstance();
               shortTip.buySignal.add(buy);
               stage.addChild(shortTip);
            }
            if(currentShopData)
            {
               shortTip.setData(currentShopData);
               shortTip.showButtonById(0);
            }
            shortTip.pivotX = 151;
            shortTip.pivotY = 180;
            shortTip.y = 390;
            shortTip.x = 807;
            shortTip.scaleX = shortTip.scaleY = 0;
            shortTip.visible = true;
            Starling.juggler.tween(shortTip,0.5,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOut"
            });
         }
         else
         {
            if(longTip == null)
            {
               longTip = ShopItemDetailTip.getInstance();
               longTip.buySignal.add(buy);
               stage.addChild(longTip);
            }
            if(currentShopData)
            {
               longTip.setData(currentShopData);
               longTip.showButtonById(0);
            }
            longTip.y = 440;
            longTip.x = 807;
            longTip.pivotX = 151;
            longTip.pivotY = 305;
            longTip.scaleX = longTip.scaleY = 0;
            longTip.visible = true;
            Starling.juggler.tween(longTip,0.5,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOut"
            });
         }
         frameBtns.visible = false;
      }
      
      private function onBack(param1:Event) : void
      {
         clear();
         goPage1();
      }
      
      private function onClear(param1:Event) : void
      {
         clear();
      }
      
      private function onBuy(param1:Event) : void
      {
         if(inGuide)
         {
            Guide.instance.stop();
         }
         buy();
         frameBtns.visible = false;
      }
      
      private function onRecharge(param1:Event) : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function onRecommend(param1:Event) : void
      {
         goPage2();
         showTitle(0);
         list.dataProvider = recommendListData;
      }
      
      private function onWeapon(param1:Event) : void
      {
         goPage2();
         showTitle(1);
         list.dataProvider = weaponListData;
      }
      
      private function onAccessory(param1:Event) : void
      {
         goPage2();
         showTitle(3);
         list.dataProvider = accessoryListData;
      }
      
      private function onArmor(param1:Event) : void
      {
         goPage2();
         showTitle(2);
         list.dataProvider = armorListData;
      }
      
      private function onProp(param1:Event) : void
      {
         goPage2();
         showTitle(4);
         list.dataProvider = propListData;
         if(inGuide)
         {
            Guide.instance.show(460,160,LangManager.t("guide11"),340,144);
            btnBack.enabled = false;
            btnRecharge.enabled = false;
         }
      }
      
      private function onExitBtnClick(param1:Event) : void
      {
         if(inGuide)
         {
            inGuide = false;
            Guide.instance.stop();
            _optionsData.pos = "mission";
         }
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":onExit
         });
         if(Game.fromSkycityToShop)
         {
            this.dispatchEventWith("showSkyCity");
            Game.fromSkycityToShop = false;
         }
         else
         {
            this.dispatchEvent(new Event("complete"));
         }
      }
      
      private function onExit() : void
      {
         Starling.juggler.removeTweens(this);
      }
   }
}

