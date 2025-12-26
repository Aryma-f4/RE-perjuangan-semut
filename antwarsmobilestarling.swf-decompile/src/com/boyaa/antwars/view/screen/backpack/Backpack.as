package com.boyaa.antwars.view.screen.backpack
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.ShopDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.Hall;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.battlefield.element.EnergyBar;
   import com.boyaa.antwars.view.screen.copygame.CityWorld;
   import com.boyaa.antwars.view.screen.copygame.SkyCity;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideEventManager;
   import com.boyaa.antwars.view.screen.fresh.guideControl.GuideSprite;
   import com.boyaa.antwars.view.screen.fresh.guideControl.IGuideProcess;
   import com.boyaa.antwars.view.screen.fresh.guideControl.MissionGuideValue;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.screen.shop.SmallTip;
   import com.boyaa.antwars.view.screen.wedding.WeddingPropUseManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import feathers.controls.List;
   import feathers.controls.ScreenNavigator;
   import feathers.controls.ToggleButton;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.TiledRowsLayout;
   import feathers.textures.Scale9Textures;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.filters.ColorMatrixFilter;
   import starling.text.TextField;
   import starling.utils.RectangleUtil;
   
   public class Backpack extends GuideSprite implements IGuideProcess
   {
      
      public static var selectBag:int = 0;
      
      public static const WEAPON:int = 1;
      
      public static const ARMOR:int = 2;
      
      public static const PROP:int = 3;
      
      private var frameBtns:Sprite;
      
      private var groupBtns:Sprite;
      
      private var goldSprite:Sprite;
      
      private var closeBtn:Button;
      
      private var btnWeapon:ToggleButton;
      
      private var btnEquip:ToggleButton;
      
      private var btnProp:ToggleButton;
      
      public var btnCheckEquip:Button;
      
      private var btnShop:Button;
      
      private var btnRecharge:Button;
      
      private var btnRenew:Button;
      
      private var btnTakeOn:Button;
      
      private var btnUse:Button;
      
      private var imgClearDisable:Image;
      
      private var list:List;
      
      private var weaponListData:ListCollection;
      
      private var equipListData:ListCollection;
      
      private var propListData:ListCollection;
      
      private var boyaaCoin:TextField;
      
      private var gameGold:TextField;
      
      private var valueTexts:Vector.<TextField>;
      
      private var levelText:TextField;
      
      public var character:Character;
      
      private var accountData:AccountData;
      
      private var currentGoodsData:GoodsData;
      
      private var currentWeapon:Image;
      
      public var updateSignal:Signal;
      
      private var equipFrame:EquipedListFrame;
      
      public var longTip:ShopItemDetailTip;
      
      public var shortTip:SmallTip;
      
      public var backpackWidth:Number = 1024;
      
      public var backpackHeight:Number = 768;
      
      private var screenItems:Dictionary;
      
      private var posHelper:Rectangle;
      
      public var inGuide:Boolean = false;
      
      private var markbg:DlgMark;
      
      private var btnCheck:Button;
      
      private var btnSale:Button;
      
      private var _propItemRenderArr:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      private var _weaponItemRenderArr:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      private var _equipItemRenderArr:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      public function Backpack()
      {
         super();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function init() : void
      {
         screenItems = Assets.getScreenPos("backpack");
         var _loc5_:Image = new Image(Assets.sAsset.getTexture("bb_bg"));
         Assets.positionDisplay(_loc5_,"backpack","bgbg");
         addChild(_loc5_);
         var _loc7_:Image = new Image(Assets.sAsset.getTexture("bb45"));
         Assets.positionDisplay(_loc7_,"backpack","top");
         addChild(_loc7_);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("bag"));
         Assets.positionDisplay(_loc1_,"backpack","bag");
         addChild(_loc1_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("bb46"));
         Assets.positionDisplay(_loc4_,"backpack","bottom");
         addChild(_loc4_);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.sAsset.positionDisplay(closeBtn,"backpack","closeBtn");
         closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(closeBtn);
         var _loc6_:Image = new Image(Assets.sAsset.getTexture("bg6"));
         Assets.sAsset.positionDisplay(_loc6_,"backpack","left_bg");
         _loc6_.touchable = false;
         var _loc3_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)),Assets.sAsset.scaleFactor);
         Assets.sAsset.positionDisplay(_loc3_,"backpack","frame");
         var _loc2_:Quad = new Quad(_loc3_.width - 10,_loc3_.height - 10,4269333);
         _loc2_.x = _loc3_.x + 5;
         _loc2_.y = _loc3_.y + 5;
         addChild(_loc2_);
         addChild(_loc3_);
         btnCheckEquip = new Button(Assets.sAsset.getTexture("bb14"),"",Assets.sAsset.getTexture("bb15"));
         Assets.sAsset.positionDisplay(btnCheckEquip,"backpack","btn_check_equip");
         btnCheckEquip.addEventListener("triggered",onCheckEquip);
         groupBtns = new Sprite();
         addChild(groupBtns);
         btnWeapon = initButton(btnWeapon,["backpack","wqBtn","bb-5","bb-6",onWeaponBtn]);
         btnWeapon.isSelected = true;
         btnWeapon.isEnabled = false;
         groupBtns.addChild(btnWeapon);
         btnEquip = initButton(btnEquip,["backpack","fzBtn","bb5","bb6",onEquipBtn]);
         groupBtns.addChild(btnEquip);
         btnProp = initButton(btnProp,["backpack","qtBtn","bb7","bb8",onPropBtn]);
         groupBtns.addChild(btnProp);
         btnShop = new Button(Assets.sAsset.getTexture("bb_shop_0"),"",Assets.sAsset.getTexture("bb_shop_1"));
         Assets.sAsset.positionDisplay(btnShop,"backpack","btn_shop");
         btnShop.addEventListener("triggered",onShop);
         addChild(btnShop);
         initList();
         initAccountInfo();
         addChild(btnCheckEquip);
         equipFrame = new EquipedListFrame();
         equipFrame.signal.add(hideEquipList);
         equipFrame.takeOffSignal.add(takeOff);
         equipFrame.visible = false;
         addChild(equipFrame);
         addChild(_loc6_);
         initFrameButtons();
         initRoleInfo();
         updateSignal = new Signal();
         EnergyBar.updatePlayerEnergy();
      }
      
      private function initFrameButtons() : void
      {
         frameBtns = new Sprite();
         var _loc1_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         Assets.positionDisplay(_loc1_,"backpack","bg_frame_btn");
         frameBtns.addChild(_loc1_);
         btnCheck = new Button(Assets.sAsset.getTexture("bb_check_0"),"",Assets.sAsset.getTexture("bb_check_1"));
         Assets.positionDisplay(btnCheck,"backpack","btn0");
         btnCheck.addEventListener("triggered",onCheck);
         frameBtns.addChild(btnCheck);
         btnSale = new Button(Assets.sAsset.getTexture("bb-10"),"",Assets.sAsset.getTexture("bb-11"));
         Assets.positionDisplay(btnSale,"backpack","btn1");
         btnSale.addEventListener("triggered",onSale);
         frameBtns.addChild(btnSale);
         btnUse = new Button(Assets.sAsset.getTexture("bb-13"),"",Assets.sAsset.getTexture("bb-14"));
         Assets.positionDisplay(btnUse,"backpack","btn2");
         btnUse.addEventListener("triggered",onUse);
         frameBtns.addChild(btnUse);
         imgClearDisable = new Image(Assets.sAsset.getTexture("bb24-2"));
         Assets.positionDisplay(imgClearDisable,"backpack","btn2");
         frameBtns.addChild(imgClearDisable);
         btnTakeOn = new Button(Assets.sAsset.getTexture("bb-15"),"",Assets.sAsset.getTexture("bb-16"));
         Assets.positionDisplay(btnTakeOn,"backpack","btn2");
         btnTakeOn.addEventListener("triggered",onTakeOn);
         frameBtns.addChild(btnTakeOn);
         btnRenew = new Button(Assets.sAsset.getTexture("bb26"),"",Assets.sAsset.getTexture("bb27"));
         Assets.positionDisplay(btnRenew,"backpack","btn2");
         btnRenew.addEventListener("triggered",onRenew);
         frameBtns.addChild(btnRenew);
         frameBtns.visible = false;
         addChild(frameBtns);
      }
      
      private function initButton(param1:ToggleButton, param2:Array) : ToggleButton
      {
         param1 = new ToggleButton();
         param1.isToggle = true;
         param1.name = "0";
         Assets.positionDisplay(param1,param2[0],param2[1]);
         param1.defaultSkin = new Image(Assets.sAsset.getTexture(param2[2]));
         param1.downSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.selectedDownSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.defaultSelectedSkin = new Image(Assets.sAsset.getTexture(param2[3]));
         param1.addEventListener("triggered",param2[4]);
         return param1;
      }
      
      private function initList() : void
      {
         weaponListData = new ListCollection();
         equipListData = new ListCollection();
         propListData = new ListCollection();
         list = new List();
         list.dataProvider = weaponListData;
         list.itemRendererType = BackpackItemRenderer;
         Assets.positionDisplay(list,"backpack","item");
         this.addChild(list);
         list.addEventListener("change",onListChangeHandler);
         list.addEventListener("rendererAdd",onItemAddToListHandle);
         list.addEventListener("rendererRemove",onItemRmoveHandle);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 5;
         _loc1_.paddingTop = 5;
         list.layout = _loc1_;
      }
      
      private function onItemRmoveHandle(param1:Event, param2:IListItemRenderer) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [_propItemRenderArr,_weaponItemRenderArr,_equipItemRenderArr];
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = int(_loc4_[_loc5_].indexOf(param2));
            if(_loc3_ != -1)
            {
               _loc4_[_loc5_].splice(_loc3_,1);
               break;
            }
            _loc5_++;
         }
      }
      
      private function onItemAddToListHandle(param1:Event, param2:IListItemRenderer) : void
      {
         if(btnProp.isSelected)
         {
            _propItemRenderArr.push(param2);
         }
         if(btnWeapon.isSelected)
         {
            _weaponItemRenderArr.push(param2);
         }
         if(btnEquip.isSelected)
         {
            _equipItemRenderArr.push(param2);
         }
      }
      
      private function initAccountInfo() : void
      {
         goldSprite = new Sprite();
         goldSprite.touchable = false;
         addChild(goldSprite);
         accountData = AccountData.instance;
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         _loc2_.x = screenItems["goldBg1"].x;
         _loc2_.y = screenItems["goldBg1"].y;
         goldSprite.addChild(_loc2_);
         var _loc3_:Image = new Image(Assets.sAsset.getTexture("bg18"));
         _loc3_.x = screenItems["goldBg2"].x;
         _loc3_.y = screenItems["goldBg2"].y;
         goldSprite.addChild(_loc3_);
         btnRecharge = new Button(Assets.sAsset.getTexture("recharge8"),"",Assets.sAsset.getTexture("recharge7"));
         btnRecharge.x = screenItems["recharge"].x;
         btnRecharge.y = screenItems["recharge"].y;
         btnRecharge.addEventListener("triggered",onRecharge);
         addChild(btnRecharge);
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("gameGoldIcon"));
         _loc1_.x = screenItems["gameGoldIcon"].x;
         _loc1_.y = screenItems["gameGoldIcon"].y;
         goldSprite.addChild(_loc1_);
         var _loc4_:Image = new Image(Assets.sAsset.getTexture("boyaaCoinIcon"));
         _loc4_.x = screenItems["boyaaCoinIcon"].x;
         _loc4_.y = screenItems["boyaaCoinIcon"].y;
         goldSprite.addChild(_loc4_);
         var _loc5_:Rectangle = Assets.getPosition("backpack","gameGold");
         gameGold = new TextField(_loc5_.width,_loc5_.height,accountData.gameGold.toString(),"Verdana",24,16777215,true);
         gameGold.hAlign = "left";
         gameGold.vAlign = "top";
         gameGold.x = _loc5_.x;
         gameGold.y = _loc5_.y;
         gameGold.autoScale = true;
         goldSprite.addChild(gameGold);
         _loc5_ = Assets.getPosition("backpack","boyaaCoin");
         boyaaCoin = new TextField(_loc5_.width,_loc5_.height,accountData.boyaaCoin.toString(),"Verdana",24,16777215,true);
         boyaaCoin.hAlign = "left";
         boyaaCoin.vAlign = "top";
         boyaaCoin.x = _loc5_.x;
         boyaaCoin.y = _loc5_.y;
         boyaaCoin.autoScale = true;
         goldSprite.addChild(boyaaCoin);
      }
      
      private function initRoleInfo() : void
      {
         var _loc5_:Rectangle = null;
         var _loc9_:* = 0;
         var _loc8_:TextField = null;
         var _loc6_:* = 0;
         var _loc1_:TextField = null;
         var _loc10_:Rectangle = Assets.getPosition("backpack","character");
         character = CharacterFactory.instance.checkOutCharacter(PlayerDataList.instance.selfData.babySex);
         character.addEventListener("touch",onTouchCharacter);
         character.scaleY = 0.6;
         character.scaleX = character.scaleY;
         character.initData(PlayerDataList.instance.selfData.getPropData());
         character.x = _loc10_.x + (_loc10_.width >> 1);
         character.y = _loc10_.y + _loc10_.height;
         addChild(character);
         var _loc2_:GlowFilter = new GlowFilter(4660230,1,6,6,10);
         var _loc7_:Array = [];
         _loc7_.push(_loc2_);
         var _loc3_:Array = LangManager.ta("detailsNameArr1");
         var _loc4_:Array = PlayerDataList.instance.selfData.ability();
         _loc9_ = 0;
         while(_loc9_ < 7)
         {
            _loc5_ = Assets.sAsset.getPosition("backpack","property" + _loc9_);
            _loc8_ = new TextField(_loc5_.width,_loc5_.height,_loc3_[_loc9_] + ":","Verdana",24,16777215);
            Assets.sAsset.positionDisplay(_loc8_,"backpack","property" + _loc9_);
            _loc8_.hAlign = "left";
            _loc8_.touchable = false;
            _loc8_.nativeFilters = _loc7_;
            _loc8_.autoScale = true;
            addChild(_loc8_);
            _loc9_++;
         }
         valueTexts = new Vector.<TextField>();
         _loc6_ = 0;
         while(_loc6_ < 7)
         {
            _loc5_ = Assets.sAsset.getPosition("backpack","txt_num_" + _loc6_);
            _loc1_ = new TextField(_loc5_.width,_loc5_.height,String(_loc4_[_loc6_]),"Verdana",24,65280);
            _loc1_.autoScale = true;
            Assets.sAsset.positionDisplay(_loc1_,"backpack","txt_num_" + _loc6_);
            _loc1_.hAlign = "left";
            _loc1_.touchable = false;
            valueTexts.push(_loc1_);
            addChild(_loc1_);
            _loc6_++;
         }
         _loc5_ = Assets.getPosition("backpack","levelText");
         levelText = new TextField(_loc5_.width,_loc5_.height,"","Verdana",24,16777215);
         levelText.nativeFilters = _loc7_;
         levelText.x = _loc5_.x;
         levelText.y = _loc5_.y;
         levelText.hAlign = "left";
         levelText.autoScale = true;
         levelText.text = "LV" + PlayerDataList.instance.selfData.level;
         addChild(levelText);
         updateCurrentWeapon(character.wqGoods);
      }
      
      public function selectYourBag(param1:int) : void
      {
         selectBag = param1;
         switch(selectBag - 1)
         {
            case 0:
               onWeaponBtn(null);
               break;
            case 1:
               onEquipBtn(null);
               break;
            case 2:
               onPropBtn(null);
         }
         selectBag = 0;
      }
      
      public function setUseGoodsData(param1:int) : GoodsData
      {
         switch(param1 - 42)
         {
            case 0:
               currentGoodsData = GoodsList.instance.getGoodsById(42,1021) || GoodsList.instance.getGoodsById(42,1011) || GoodsList.instance.getGoodsById(42,1031);
         }
         return currentGoodsData;
      }
      
      public function useMissionGoods(param1:int, param2:int, param3:Function) : void
      {
         var type:int = param1;
         var frame:int = param2;
         var callBackFun:Function = param3;
         currentGoodsData = GoodsList.instance.getGoodsById(type,frame);
         if(currentGoodsData)
         {
            GameServer.instance.useGoods(currentGoodsData.onlyID,(function():*
            {
               var callBack:Function;
               return callBack = function(param1:Object):void
               {
                  if(param1.ret == 0)
                  {
                     callBackFun();
                  }
               };
            })());
         }
         else
         {
            trace("玩家身上没有此道具");
         }
      }
      
      public function sale() : void
      {
         GameServer.instance.sellGoods(currentGoodsData.onlyID,1,function(param1:Object):void
         {
            Application.instance.log("Backpack",JSON.stringify(param1));
            onSaleSignal(param1);
         });
      }
      
      public function takeOff(param1:GoodsData = null) : void
      {
         var data:GoodsData = param1;
         var goodsData:GoodsData = currentGoodsData;
         if(data)
         {
            goodsData = data;
         }
         GameServer.instance.setMemBody([goodsData.getPosName(),0,goodsData.onlyID],function(param1:Object):void
         {
            var _loc2_:Array = null;
            Application.instance.log("Backpack",JSON.stringify(param1));
            if(param1)
            {
               _loc2_ = param1 as Array;
               if(_loc2_[0])
               {
                  if(_loc2_[1][1] == 0)
                  {
                     character.wearById(goodsData.typeID,0);
                     GoodsList.instance.takeOffGoodsById(_loc2_[1][0]);
                     equipFrame.updateEquipImg(goodsData.getPosName(),null);
                     if(goodsData.isWeapon)
                     {
                        updateCurrentWeapon(data);
                     }
                     updateRoleInfo();
                     updateList();
                  }
               }
            }
         });
      }
      
      public function takeOn(param1:GoodsData = null) : void
      {
         var data:GoodsData = param1;
         var goodsData:GoodsData = currentGoodsData;
         if(data)
         {
            goodsData = data;
         }
         trace("穿装备：-----",goodsData.isEquipment,goodsData.stutas);
         if(goodsData.isEquipment && goodsData.stutas != 0)
         {
            if(goodsData.gender != 0 && goodsData.gender != PlayerDataList.instance.selfData.babySex + 1)
            {
               TextTip.instance.show(LangManager.t("sexerror"));
               return;
            }
            if(goodsData.lowerlevel > PlayerDataList.instance.selfData.level)
            {
               TextTip.instance.show(LangManager.t("levelerror") + goodsData.lowerlevel);
               return;
            }
            GameServer.instance.setMemBody([goodsData.getPosName(),1,goodsData.onlyID],function(param1:Object):void
            {
               var _loc2_:Array = null;
               Application.instance.log("Backpack",JSON.stringify(param1));
               if(param1)
               {
                  _loc2_ = param1 as Array;
                  if(_loc2_[0])
                  {
                     if(_loc2_[1][1] != 0)
                     {
                        GoodsList.instance.wearGoods(_loc2_[1][0],_loc2_[2]);
                        TextTip.instance.show(LangManager.t("equipOK"));
                        MissionManager.instance.updateMissionData(180,1,0);
                        equipFrame.updateEquipImg(goodsData.getPosName(),goodsData);
                        if(!goodsData.isWeapon)
                        {
                           character.wearById(goodsData.typeID,goodsData.frameID);
                           updateData();
                        }
                        else
                        {
                           character.wearById(goodsData.typeID,goodsData.frameID);
                           updateCurrentWeapon(goodsData);
                           updateData();
                        }
                        MissionManager.instance.updateMissionData(163,goodsData.typeID,goodsData.frameID,1);
                        return;
                     }
                  }
               }
               TextTip.instance.show(LangManager.t("equipFail"));
            });
         }
      }
      
      public function useProp() : void
      {
         var arr:Array;
         var goodsData:GoodsData = currentGoodsData;
         var canUseAry:Array = [25,26,36,42];
         if(canUseAry.indexOf(goodsData.typeID) != -1)
         {
            if(goodsData.lowerlevel > PlayerDataList.instance.selfData.level)
            {
               TextTip.instance.show(LangManager.t("levelerror") + goodsData.lowerlevel);
               return;
            }
            if(goodsData.typeID == 42 && PlayerDataList.instance.selfData.energy >= 60)
            {
               TextTip.instance.show(LangManager.t("energyIsFull"));
               return;
            }
            if(goodsData.typeID == 36)
            {
               arr = [1071,1081];
               if(arr.indexOf(goodsData.frameID) != -1)
               {
                  WeddingPropUseManager.instance.showWeddingPopDlg(goodsData.typeID,goodsData.frameID);
                  return;
               }
            }
            GameServer.instance.useGoods(goodsData.onlyID,function(param1:Object):void
            {
               var box:Sprite;
               var pos:Rectangle;
               var i:int;
               var gdata:GoodsData;
               var gimg:Image;
               var navigator:ScreenNavigator;
               var retData:Object = param1;
               Application.instance.log("Backpack:使用道具",JSON.stringify(retData));
               if(retData.ret == 0)
               {
                  if(retData.hasOwnProperty("prop") && retData.prop.length > 0)
                  {
                     box = new Sprite();
                     pos = new Rectangle(0,0,200,200);
                     i = 0;
                     while(i < retData.prop.length)
                     {
                        gdata = retData.prop[i] as GoodsData;
                        gimg = Assets.sAsset.getGoodsImageByRect(gdata.typeID,gdata.frameID,pos);
                        if(gimg)
                        {
                           gimg.x = i * 150;
                           box.addChild(gimg);
                        }
                        i = i + 1;
                     }
                     box.pivotX = box.width >> 1;
                     box.pivotY = box.height >> 1;
                     box.x = 1365 >> 1;
                     box.y = 768 >> 1;
                     box.scaleX = box.scaleY = 0;
                     Starling.juggler.tween(box,1,{
                        "scaleX":1,
                        "scaleY":1,
                        "transition":"easeOut",
                        "onComplete":function():void
                        {
                           box.removeFromParent(true);
                        }
                     });
                     Application.instance.currentGame.addChild(box);
                  }
                  else if(retData.hasOwnProperty("gameGold") && retData.gameGold > 0)
                  {
                     TextTip.instance.show(LangManager.t("gain") + LangManager.t("gold") + ":" + retData.gameGold);
                     trace(goodsData.amount,"<<<<<<<");
                  }
                  else if(retData.hasOwnProperty("energy") && retData.energy > 0)
                  {
                     TextTip.instance.show(LangManager.getLang.getreplaceLang("updateEnergy",retData.energy));
                     navigator = Application.instance.currentGame.navigator;
                     if(navigator.activeScreenID == "SKYCITY")
                     {
                        SkyCity(navigator.activeScreen).updateEnergyBar(retData.energy);
                     }
                     else if(navigator.activeScreen as CityWorld)
                     {
                        CityWorld(navigator.activeScreen).updateEnergyBar(retData.energy);
                     }
                     if(CopyServer.instance.isConnect)
                     {
                        CopyServer.instance.sendPlayerUseEnergy();
                     }
                  }
                  else
                  {
                     TextTip.instance.show(LangManager.t("useOk"));
                  }
                  MissionManager.instance.updateMissionData(121,goodsData.typeID,goodsData.frameID);
                  updateData();
               }
               else
               {
                  TextTip.instance.show(LangManager.t("useFail"));
               }
            });
         }
      }
      
      public function renew() : void
      {
         var money:int;
         var priceAry:Array;
         var type:int;
         var tipStr:String;
         var goodsName:String = currentGoodsData.name;
         var moneyType:String = LangManager.t("gold");
         if(currentGoodsData.getPrice(1))
         {
            type = 1;
            moneyType = LangManager.t("gold");
            priceAry = currentGoodsData.getPrice(1);
            money = int(priceAry[0][1]);
         }
         else if(currentGoodsData.getPrice(3))
         {
            type = 3;
            moneyType = LangManager.t("shop_paycoin");
            priceAry = currentGoodsData.getPrice(3);
            money = int(priceAry[0][1]);
         }
         tipStr = LangManager.t("renewTip") + "[" + goodsName + "]," + LangManager.t("renewPay") + money + moneyType + "?";
         SystemTip.instance.showSystemAlert(tipStr,function():void
         {
            if(moneyType == LangManager.t("gold"))
            {
               if(AccountData.instance.gameGold < money)
               {
                  TextTip.instance.show(LangManager.t("goRecharge"));
                  return;
               }
            }
            else if(AccountData.instance.boyaaCoin < money)
            {
               Starling.juggler.delayCall(noEnoughCoin,0.3);
               return;
            }
            GameServer.instance.renew([[currentGoodsData.onlyID,type,priceAry[0][0]]],function(param1:Object):void
            {
               Application.instance.log("Backpack:renew",JSON.stringify(param1));
               if(param1.ret == 0)
               {
                  updateRenewGoods(param1.data.prop);
                  AccountData.instance.gameGold -= param1.data.gameGold;
                  AccountData.instance.boyaaCoin -= param1.data.boyaaCoin;
                  updateData();
                  TextTip.instance.show(LangManager.t("renewOK"));
               }
               else
               {
                  TextTip.instance.show(LangManager.t("renewFail"));
               }
            });
         },function():void
         {
         });
      }
      
      private function noEnoughCoin() : void
      {
         SystemTip.instance.showSystemAlert(LangManager.t("rechargeBoyaaGold"),function():void
         {
            Application.instance.currentGame.mainMenu.onRechargeBtn();
         },function():void
         {
         });
      }
      
      public function hideEquipList() : void
      {
         Starling.juggler.tween(equipFrame,0.5,{
            "x":-equipFrame.width / 4,
            "transition":"easeIn",
            "onComplete":function():void
            {
               equipFrame.visible = false;
               btnCheckEquip.visible = true;
            }
         });
      }
      
      public function updateRenewGoods(param1:Array) : void
      {
         var good:GoodsData;
         var prop:Array = param1;
         var i:int = 0;
         while(i < prop.length)
         {
            good = GoodsList.instance.addGoodsByStr(prop[i]);
            if(GoodsList.instance.isBodyExpiration(good.onlyID))
            {
               good.place = 1;
               GameServer.instance.setMemBody([good.getPosName(),1,good.onlyID],function(param1:Object):void
               {
               });
            }
            i = i + 1;
         }
         updateData();
      }
      
      public function updateData() : void
      {
         updateList();
         updateAccountInfo();
         updateRoleInfo();
         updateSignal.dispatch();
      }
      
      public function guideProcess(param1:Object = null) : void
      {
         var _loc3_:* = null;
         var _loc4_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         if(!_loc4_)
         {
            return;
         }
         var _loc2_:Array = [11];
         switch(_loc4_.actioncode)
         {
            case 121:
               if(param1 != null)
               {
                  guideSpecialProcess(param1,_loc4_);
                  break;
               }
               GuideEventManager.instance.dispactherEvent("newUI",[[btnProp,20]]);
               break;
            case 163:
               if(param1 != null)
               {
                  guideSpecialProcess(param1,_loc4_);
                  break;
               }
               if(_loc2_.indexOf(_loc4_.pcate) != -1)
               {
                  GuideEventManager.instance.dispactherEvent("newUI",[[btnWeapon,20]]);
                  break;
               }
               GuideEventManager.instance.dispactherEvent("newUI",[[btnEquip,20]]);
               break;
            case 180:
               if(param1 == null)
               {
                  GuideEventManager.instance.dispactherEvent("newUI",[[btnEquip,20],[list,30]]);
               }
         }
      }
      
      private function guideSpecialProcess(param1:Object, param2:SubMissionData) : void
      {
         var str:Object = param1;
         var subMissionData:SubMissionData = param2;
         var jumpToItem:* = function(param1:Array, param2:Vector.<IListItemRenderer>, param3:List):void
         {
            var goodsData:GoodsData;
            var propArr:Array = param1;
            var itemRenderArr:Vector.<IListItemRenderer> = param2;
            var list:List = param3;
            var i:int = 0;
            while(i < propArr.length)
            {
               goodsData = propArr[i];
               if(goodsData.typeID == subMissionData.pcate && goodsData.frameID == subMissionData.pframe)
               {
                  break;
               }
               goodsData = null;
               i = i + 1;
            }
            if(goodsData)
            {
               list.scrollToDisplayIndex(i);
               Timepiece.instance.addDelayCall((function():*
               {
                  var delay:Function;
                  return delay = function():void
                  {
                     var _loc1_:int = 0;
                     var _loc2_:ListItemRenderer = null;
                     _loc1_ = 0;
                     while(_loc1_ < itemRenderArr.length)
                     {
                        _loc2_ = itemRenderArr[_loc1_] as ListItemRenderer;
                        if(_loc2_.data == goodsData)
                        {
                           GuideEventManager.instance.dispactherEvent("newUI",[[_loc2_,30]]);
                           break;
                        }
                        _loc1_++;
                     }
                  };
               })(),300);
            }
         };
         var arr:Array = [];
         switch(str)
         {
            case "propInfo":
               arr = GoodsList.instance.getOther();
               jumpToItem(arr,_propItemRenderArr,list);
               break;
            case "weaponInfo":
               arr = GoodsList.instance.getWQ(2);
               jumpToItem(arr,_weaponItemRenderArr,list);
               break;
            case "equipInfo":
               arr = GoodsList.instance.getFZ(2);
               jumpToItem(arr,_equipItemRenderArr,list);
               break;
            case "useProp":
               GuideEventManager.instance.dispactherEvent("newUI",[[btnUse,40]]);
               break;
            case "useWeapon":
               GuideEventManager.instance.dispactherEvent("newUI",[[btnTakeOn,40]]);
         }
      }
      
      private function updateList() : void
      {
         var wqData:Array;
         var tempArr0:Array;
         var i:int;
         var temp:GoodsData;
         var tempArr1:Array;
         var fzData:Array;
         var j:int;
         var temp1:GoodsData;
         var listData:ListCollection;
         Application.instance.log("Backpack","updateList");
         wqData = GoodsList.instance.getWQ();
         tempArr0 = [];
         i = 0;
         while(i < wqData.length)
         {
            temp = wqData[i] as GoodsData;
            if(temp.place != 1)
            {
               tempArr0.push(temp);
            }
            i = i + 1;
         }
         weaponListData.data = tempArr0;
         tempArr1 = [];
         fzData = GoodsList.instance.getFZ();
         j = 0;
         while(j < fzData.length)
         {
            temp1 = fzData[j] as GoodsData;
            if(temp1.place != 1)
            {
               tempArr1.push(temp1);
            }
            j = j + 1;
         }
         equipListData.data = tempArr1;
         propListData.data = GoodsList.instance.getOther();
         if(btnProp.isSelected)
         {
            listData = new ListCollection();
            list.dataProvider = listData;
            Starling.juggler.delayCall(function():void
            {
               propListData.data = GoodsList.instance.getOther();
               list.dataProvider = propListData;
            },0.1);
         }
      }
      
      private function updateRoleInfo() : void
      {
         var _loc3_:* = 0;
         Application.instance.log("Backpack","updateRoleInfo");
         var _loc1_:Array = PlayerDataList.instance.selfData.ability();
         var _loc2_:int = int(valueTexts.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            valueTexts[_loc3_].text = _loc1_[_loc3_];
            _loc3_++;
         }
         levelText.text = "LV" + PlayerDataList.instance.selfData.level;
      }
      
      private function updateAccountInfo() : void
      {
         boyaaCoin.text = accountData.boyaaCoin.toString();
         gameGold.text = accountData.gameGold.toString();
      }
      
      private function updateCurrentWeapon(param1:GoodsData) : void
      {
         var _loc2_:String = null;
         var _loc4_:GoodsData = null;
         var _loc5_:Rectangle = null;
         var _loc3_:Rectangle = null;
         if(param1)
         {
            _loc2_ = ShopDataList.instance.getWeaponImageString(param1);
            if(currentWeapon)
            {
               _loc4_ = PlayerDataList.instance.selfData.getWeapon();
               if(_loc4_)
               {
                  currentWeapon.removeFromParent();
                  currentWeapon = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture(_loc2_));
                  addChild(currentWeapon);
               }
               else
               {
                  currentWeapon.removeFromParent();
               }
            }
            else
            {
               currentWeapon = new Image(Assets.sAsset.getTextureAtlas("wqSpritesheet").getTexture(_loc2_));
               addChild(currentWeapon);
            }
            _loc5_ = Assets.getPosition("backpack","weapon");
            if(this.currentWeapon)
            {
               this.currentWeapon.pivotX = 0;
               this.currentWeapon.pivotY = 0;
               if(this.currentWeapon.width < _loc5_.width && this.currentWeapon.height < _loc5_.height)
               {
                  _loc3_ = RectangleUtil.fit(new Rectangle(0,0,this.currentWeapon.width,this.currentWeapon.height),_loc5_,"none");
               }
               else
               {
                  _loc3_ = RectangleUtil.fit(new Rectangle(0,0,this.currentWeapon.width,this.currentWeapon.height),_loc5_,"showAll");
               }
               this.currentWeapon.x = _loc3_.x;
               this.currentWeapon.y = _loc3_.y;
               this.currentWeapon.width = _loc3_.width;
               this.currentWeapon.height = _loc3_.height;
            }
         }
      }
      
      private function cancelSelect() : void
      {
         var _loc3_:int = 0;
         var _loc2_:ToggleButton = null;
         var _loc1_:int = groupBtns.numChildren;
         Application.instance.log("Backpack","cancelSelect\'s num " + _loc1_.toString());
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = groupBtns.getChildAt(_loc3_) as ToggleButton;
            if(_loc2_.isSelected == true)
            {
               _loc2_.isSelected = false;
               _loc2_.isEnabled = true;
            }
            _loc3_++;
         }
      }
      
      private function showButtonMode(param1:GoodsData) : void
      {
         if(!param1.isEquipment)
         {
            btnUse.visible = true;
            imgClearDisable.visible = false;
            btnTakeOn.visible = false;
            btnRenew.visible = false;
            if(param1.typeID == 25 || param1.typeID == 26 || param1.typeID == 36 || param1.typeID == 42)
            {
               btnUse.visible = true;
               imgClearDisable.visible = false;
            }
            else
            {
               btnUse.visible = false;
               imgClearDisable.visible = true;
            }
            guideProcess("useProp");
         }
         else
         {
            btnUse.visible = false;
            imgClearDisable.visible = false;
            if(param1.position == 0)
            {
               if(param1.stutas == 0)
               {
                  btnTakeOn.visible = false;
                  btnRenew.visible = true;
               }
               else
               {
                  btnTakeOn.visible = true;
                  btnRenew.visible = false;
                  guideProcess("useWeapon");
               }
               if(param1.isRentFromOther(param1.onlyID))
               {
                  btnSale.touchable = false;
                  setGrayFitlers(btnSale);
               }
               else
               {
                  btnSale.touchable = true;
                  btnSale.filter = null;
               }
            }
         }
      }
      
      private function setGrayFitlers(param1:DisplayObject) : void
      {
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc2_.adjustSaturation(-1);
         param1.filter = _loc2_;
      }
      
      private function onSaleSignal(param1:Object) : void
      {
         TextTip.instance.show(LangManager.t("sellOK") + param1.data.money + LangManager.t("gold"));
         var _loc2_:GoodsData = GoodsList.instance.getGoodsByOnlyID(param1.data.only);
         if(_loc2_.place == 1)
         {
            character.wear(Constants.getGoodsNameById(_loc2_.typeID));
         }
         GoodsList.instance.removeGoodsByOnlyID(param1.data.only);
         accountData.gameGold += param1.data.money;
         updateData();
         updateAccountInfo();
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         Application.instance.log("log1","...");
         markbg = new DlgMark();
         parent.addChild(markbg);
         parent.swapChildren(markbg,this);
         cancelSelect();
         btnWeapon.isEnabled = false;
         btnWeapon.isSelected = true;
         Application.instance.log("log2","...");
         updateList();
         list.dataProvider = weaponListData;
         updateAccountInfo();
         updateRoleInfo();
         character.initData(PlayerDataList.instance.selfData.getPropData());
         updateCurrentWeapon(character.wqGoods);
         Application.instance.log("log3","...");
         if(longTip == null)
         {
            longTip = ShopItemDetailTip.getInstance();
            longTip.takeOnSignal.add(takeOn);
            longTip.useSignal.add(useProp);
            longTip.renewSignal.add(renew);
            longTip.saleSignal.add(sale);
            longTip.visible = false;
         }
         stage.addChild(longTip);
         Application.instance.log("log4","...");
         if(!shortTip)
         {
            shortTip = SmallTip.getInstance();
            shortTip.useSignal.add(useProp);
            shortTip.saleSignal.add(sale);
            shortTip.visible = false;
         }
         this.stage.addChild(shortTip);
         Application.instance.log("log5","...");
         this.stage.addEventListener("touch",onTouch);
         list.visible = false;
         this.pivotX = 540;
         this.pivotY = 384;
         this.scaleX = this.scaleY = 0;
         Application.instance.log("log6","...");
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut",
            "onComplete":onCompleteHandler
         });
      }
      
      private function onCompleteHandler() : void
      {
         var _loc1_:Array = null;
         list.visible = true;
         Application.instance.log("position:",Application.instance.currentGame._guideOptionsData.pos);
         if(Application.instance.currentGame._guideOptionsData.pos == "backpack")
         {
            cancelSelect();
            _loc1_ = GoodsList.instance.getFZ();
            equipListData.data = _loc1_;
            btnEquip.isSelected = true;
            list.dataProvider = equipListData;
            Guide.instance.guide(list,LangManager.t("guide13"),true);
            inGuide = true;
            btnWeapon.isEnabled = false;
            btnProp.isEnabled = false;
            btnShop.enabled = false;
            btnRecharge.enabled = false;
         }
         else
         {
            btnWeapon.isEnabled = true;
            btnProp.isEnabled = true;
            btnShop.enabled = true;
            btnRecharge.enabled = true;
            Application.instance.log("onCompleteHandler:","else-------");
         }
         guideProcess();
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         currentGoodsData = _loc2_.selectedItem as GoodsData;
         trace(currentGoodsData.typeID,currentGoodsData.frameID);
         showButtonMode(currentGoodsData);
         frameBtns.visible = true;
         frameBtns.alpha = 0;
         Starling.juggler.tween(frameBtns,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
         showGuide();
         _loc2_.selectedIndex = -1;
      }
      
      private function showGuide() : void
      {
         if(inGuide)
         {
            if(currentGoodsData.isEquipment && !currentGoodsData.isWeapon && btnTakeOn.visible)
            {
               Guide.instance.guide(btnTakeOn,"",true);
               btnCheck.enabled = false;
               btnSale.enabled = false;
            }
            else
            {
               inGuide = false;
               Guide.instance.stop();
            }
         }
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc6_:* = undefined;
         var _loc5_:Point = null;
         var _loc7_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:* = undefined;
         var _loc2_:* = undefined;
         var _loc4_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc4_.length > 0 && _loc4_[0].phase == "began")
         {
            _loc6_ = param1.getTouches(list);
            if(_loc6_.length > 0 && _loc6_[0].phase == "began")
            {
               _loc5_ = list.globalToLocal(new Point(_loc6_[0].globalX,_loc6_[0].globalY));
               if(_loc5_.x > 320)
               {
                  _loc5_.x = 320;
               }
               frameBtns.x = _loc5_.x;
               frameBtns.y = _loc5_.y - 50;
               if(inGuide)
               {
                  this.stage.removeEventListener("touch",onTouch);
               }
            }
            if(frameBtns.visible)
            {
               _loc7_ = param1.getTouches(frameBtns);
               if(_loc7_.length == 0)
               {
                  frameBtns.visible = false;
                  list.selectedIndex = -1;
               }
            }
         }
         var _loc8_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc8_.length > 0 && _loc8_[0].phase == "began")
         {
            if(equipFrame.listContainer.visible)
            {
               _loc9_ = param1.getTouches(equipFrame.listContainer);
               if(_loc9_.length == 0)
               {
                  equipFrame.listContainer.visible = false;
                  _loc3_ = param1.getTouches(equipFrame.posBtnContainer);
                  trace(_loc3_.length);
                  if(_loc3_.length == 0)
                  {
                     equipFrame.selectedImg.visible = false;
                  }
               }
            }
            if(equipFrame.frameBtns.visible)
            {
               _loc2_ = param1.getTouches(equipFrame.frameBtns);
               if(_loc2_.length == 0)
               {
                  equipFrame.frameBtns.visible = false;
               }
            }
         }
      }
      
      private function onTouchCharacter(param1:TouchEvent) : void
      {
         if(inGuide)
         {
            return;
         }
         var _loc2_:Touch = param1.getTouch(character,"began");
         if(_loc2_)
         {
            if(equipFrame.visible)
            {
               hideEquipList();
            }
            else
            {
               onCheckEquip();
            }
         }
      }
      
      private function onShop(param1:Event) : void
      {
         removeFromParent();
         Application.instance.currentGame.navigator.showScreen("SHOP");
      }
      
      private function onCheck(param1:Event) : void
      {
         if(!currentGoodsData.isEquipment)
         {
            if(currentGoodsData)
            {
               shortTip.setData(currentGoodsData);
            }
            shortTip.showButtonById(1,currentGoodsData);
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
            if(currentGoodsData.place == 1)
            {
               if(currentGoodsData.getType(currentGoodsData.typeID) == "防具" || currentGoodsData.getType(currentGoodsData.typeID) == "饰品")
               {
                  longTip.showButtonById(1);
               }
            }
            else if(currentGoodsData.position == 0)
            {
               if(currentGoodsData.stutas == 0)
               {
                  longTip.showButtonById(4);
               }
               else
               {
                  longTip.showButtonById(3);
               }
            }
            if(currentGoodsData)
            {
               longTip.setData(currentGoodsData);
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
      
      private function onCheckEquip(param1:Event = null) : void
      {
         btnCheckEquip.visible = false;
         equipFrame.x = -equipFrame.width / 5;
         equipFrame.visible = true;
         Starling.juggler.tween(equipFrame,0.5,{
            "x":0,
            "transition":"easeOut"
         });
      }
      
      private function onRenew(param1:Event) : void
      {
         renew();
      }
      
      private function onSale(param1:Event) : void
      {
         sale();
         frameBtns.visible = false;
      }
      
      private function onTakeOn(param1:Event) : void
      {
         frameBtns.visible = false;
         takeOn();
         if(inGuide)
         {
            Guide.instance.guide(closeBtn,"",true);
         }
      }
      
      private function onUse(param1:Event) : void
      {
         frameBtns.visible = false;
         if(currentGoodsData.isEquipment && currentGoodsData.stutas != 0)
         {
            takeOn();
            return;
         }
         useProp();
      }
      
      private function onRecharge(param1:Event) : void
      {
         Application.instance.currentGame.mainMenu.onRechargeBtn();
      }
      
      private function onWeaponBtn(param1:Event) : void
      {
         var wqData:Array;
         var tempArr:Array;
         var i:int;
         var temp:GoodsData;
         var event:Event = param1;
         Application.instance.log("Backpack","onWeaponBtn");
         cancelSelect();
         wqData = GoodsList.instance.getWQ();
         tempArr = [];
         i = 0;
         while(i < wqData.length)
         {
            temp = wqData[i] as GoodsData;
            if(temp.place != 1)
            {
               tempArr.push(temp);
            }
            i = i + 1;
         }
         weaponListData.data = tempArr;
         list.dataProvider = weaponListData;
         list.alpha = 0;
         Starling.juggler.tween(list,0.6,{
            "alpha":1,
            "transition":"easeOutBack",
            "onComplete":(function():*
            {
               var complete:Function;
               return complete = function():void
               {
                  guideProcess("weaponInfo");
               };
            })()
         });
      }
      
      private function onEquipBtn(param1:Event) : void
      {
         var fzData:Array;
         var tempArr:Array;
         var len:int;
         var i:int;
         var temp:GoodsData;
         var event:Event = param1;
         cancelSelect();
         fzData = GoodsList.instance.getFZ();
         tempArr = [];
         len = int(fzData.length);
         i = 0;
         while(i < len)
         {
            temp = fzData[i] as GoodsData;
            if(temp.place != 1)
            {
               tempArr.push(temp);
            }
            i = i + 1;
         }
         equipListData.data = tempArr;
         list.dataProvider = equipListData;
         list.alpha = 0;
         Starling.juggler.tween(list,0.6,{
            "alpha":1,
            "transition":"easeOutBack",
            "onComplete":(function():*
            {
               var complete:Function;
               return complete = function():void
               {
                  guideProcess("equipInfo");
               };
            })()
         });
      }
      
      private function onPropBtn(param1:Event) : void
      {
         var event:Event = param1;
         cancelSelect();
         list.dataProvider = propListData;
         list.alpha = 0;
         Starling.juggler.tween(list,0.6,{
            "alpha":1,
            "transition":"easeOutBack",
            "onComplete":(function():*
            {
               var complete:Function;
               return complete = function():void
               {
                  guideProcess("propInfo");
               };
            })()
         });
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         if(inGuide)
         {
            Guide.instance.stop();
            inGuide = false;
            frameBtns.visible = false;
            btnCheck.enabled = true;
            btnSale.enabled = true;
            Application.instance.currentGame._guideOptionsData.pos = "mission";
         }
         list.visible = false;
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
         if(CopyServer.instance.isConnect && Application.instance.currentGame.navigator.activeScreenID == "TEAMROOM")
         {
            CopyServer.instance.changeClothes();
         }
         if(BattleServer.instance.isConnect)
         {
            BattleServer.instance.changeCloths(PlayerDataList.instance.selfData.uid);
         }
      }
      
      private function cleanUp() : void
      {
         var _loc1_:Hall = null;
         if(equipFrame && equipFrame.visible)
         {
            hideEquipList();
         }
         if(Application.instance.currentGame.navigator.activeScreenID == "HALL")
         {
            _loc1_ = Application.instance.currentGame.navigator.activeScreen as Hall;
            _loc1_.posGuide();
         }
         markbg.removeFromParent();
         Starling.juggler.removeTweens(this);
         removeFromParent();
      }
   }
}

