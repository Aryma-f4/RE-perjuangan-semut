package com.boyaa.antwars.view.screen.union.warehouse
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.TiledRowsLayout;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Event;
   
   public class MyWarehouseDlg extends BaseDlg
   {
      
      private var bagListData:ListCollection;
      
      private var wareGoodsListData:ListCollection;
      
      private var list:List;
      
      private var wareGoodsList:List;
      
      private var gridNumArr:Array = [4,6,8,10,12,14,16,18,20,30];
      
      public var longTip:ShopItemDetailTip;
      
      private var currentGoodsData:GoodsData;
      
      private var btnIntoMywarehouse:Button;
      
      private var btnIntoBag:Button;
      
      private var restGridNum:int;
      
      private var onlyId:int;
      
      public function MyWarehouseDlg()
      {
         super();
         var _loc1_:LayoutUitl = new LayoutUitl(Assets.sAsset.getOther("warehouse"),Assets.sAsset);
         _loc1_.buildLayout("MyWarehouseLayout",_displayObj);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
         this.addEventListener("addedToStage",onAddedToStage);
         init();
      }
      
      private function init() : void
      {
         initScale9Image();
         initList();
         initGrids();
         getButtonByName("btnS_helpbtn1").addEventListener("triggered",onHelpHandle);
         GoodsList.instance.rentalSiganl.add(updateList);
      }
      
      private function initScale9Image() : void
      {
         var _loc3_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc6_:DisplayObject = getDisplayObjByName("frame0");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc6_,_loc3_);
         var _loc2_:Quad = new Quad(_loc3_.width - 10,_loc3_.height - 10,4269333);
         _loc2_.x = _loc3_.x + 5;
         _loc2_.y = _loc3_.y + 5;
         _displayObj.addChild(_loc2_);
         _displayObj.addChild(_loc3_);
         var _loc4_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc1_:DisplayObject = getDisplayObjByName("frame1");
         SmallCodeTools.instance.setDisplayObjectInSame(_loc1_,_loc4_);
         var _loc5_:Quad = new Quad(_loc4_.width - 10,_loc4_.height - 10,4269333);
         _loc5_.x = _loc4_.x + 5;
         _loc5_.y = _loc4_.y + 5;
         _displayObj.addChild(_loc5_);
         _displayObj.addChild(_loc4_);
      }
      
      private function initList() : void
      {
         list = new List();
         bagListData = new ListCollection(GoodsList.instance.getBagData());
         list.dataProvider = bagListData;
         list.itemRendererType = BagEquipListItemRender;
         list.addEventListener("change",onListChangeHandler);
         _displayObj.addChild(list);
         wareGoodsList = new List();
         wareGoodsListData = new ListCollection();
         wareGoodsList.itemRendererType = MyWarehouseListItemRender;
         wareGoodsList.dataProvider = wareGoodsListData;
         _displayObj.addChild(wareGoodsList);
         wareGoodsList.addEventListener("change",onWareGoodsListChangeHandler);
         var _loc1_:TiledRowsLayout = new TiledRowsLayout();
         _loc1_.useSquareTiles = false;
         _loc1_.gap = 5;
         _loc1_.paddingTop = 5;
         var _loc2_:TiledRowsLayout = new TiledRowsLayout();
         _loc2_.useSquareTiles = false;
         _loc2_.gap = 5;
         _loc2_.paddingTop = 5;
         list.layout = _loc1_;
         wareGoodsList.layout = _loc2_;
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("frame1"),list);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("frame0"),wareGoodsList);
         list.y += 15;
         wareGoodsList.y += 15;
         list.height -= 30;
         wareGoodsList.height -= 30;
      }
      
      private function initGrids() : void
      {
         var _loc6_:int = 0;
         var _loc5_:GoodsData = null;
         var _loc1_:Array = GoodsList.instance.storageList.concat();
         restGridNum = _loc1_.length;
         var _loc2_:int = UnionManager.getInstance().myUnionModel.storelevel;
         var _loc4_:int = int(gridNumArr[_loc2_ - 1]);
         var _loc3_:int = int(_loc4_ < 12 ? 12 : _loc4_);
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            if(_loc1_[_loc6_] == null)
            {
               _loc5_ = new GoodsData();
               if(_loc6_ < _loc4_)
               {
                  _loc5_.typeID = -1;
                  _loc5_.frameID = -1;
               }
               _loc1_[_loc6_] = _loc5_;
            }
            _loc6_++;
         }
         wareGoodsListData.data = _loc1_;
         wareGoodsList.dataProvider = wareGoodsListData;
      }
      
      private function checkDetail() : void
      {
         longTip.setData(currentGoodsData);
         longTip.showButtonById(5);
         longTip.y = 460;
         longTip.x = 1365 >> 1;
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
      
      private function addEvent() : void
      {
         getButtonByName("btnS_back").addEventListener("triggered",deactive);
         btnIntoMywarehouse = getButtonByName("btnS_intoMyware");
         btnIntoMywarehouse.addEventListener("triggered",onIntoMywareHouse);
         btnIntoBag = getButtonByName("btnS_toBag");
         btnIntoBag.addEventListener("triggered",onIntoBag);
         btnIntoMywarehouse.visible = btnIntoBag.visible = false;
      }
      
      public function updateList(param1:int) : void
      {
         if(param1 == 2)
         {
            initGrids();
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         if(longTip == null)
         {
            longTip = ShopItemDetailTip.getInstance();
            longTip.visible = false;
         }
         stage.addChild(longTip);
         addEvent();
      }
      
      private function onHelpHandle(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("mywarehouse_help"));
      }
      
      private function onIntoBag(param1:Event) : void
      {
         var e:Event = param1;
         longTip.remove();
         GameServer.instance.getUnionTostorage([onlyId,0],function(param1:Object):void
         {
            trace("存入公会仓库：" + JSON.stringify(param1));
            GoodsList.instance.deleteItemFromeMyStorageList(onlyId);
            GoodsList.instance.addGoodsByStr(param1[1] as Array);
            initGrids();
            bagListData.data = GoodsList.instance.getBagData();
            list.dataProvider = bagListData;
         });
      }
      
      private function onIntoMywareHouse(param1:Event) : void
      {
         var index:int;
         var e:Event = param1;
         longTip.remove();
         if(UnionManager.getInstance().myUnionModel.storelevel <= 0)
         {
            TextTip.instance.showByLang("union_locktip");
            return;
         }
         index = UnionManager.getInstance().myUnionModel.storelevel - 1;
         if(restGridNum >= gridNumArr[index])
         {
            TextTip.instance.showByLang("union_locktip");
            return;
         }
         GameServer.instance.getUnionTostorage([onlyId,3],function(param1:Object):void
         {
            trace("存入公会仓库：" + JSON.stringify(param1));
            GoodsList.instance.addGoodsByStr(param1[1] as Array);
            initGrids();
            bagListData.data = GoodsList.instance.getBagData();
            list.dataProvider = bagListData;
         });
      }
      
      private function onWareGoodsListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         currentGoodsData = _loc2_.selectedItem as GoodsData;
         if(currentGoodsData)
         {
            if(currentGoodsData.typeID == 0)
            {
               TextTip.instance.showByLang("union_locktip");
            }
            else
            {
               if(currentGoodsData.typeID == -1)
               {
                  return;
               }
               onlyId = currentGoodsData.onlyID;
               if(currentGoodsData.rentStatus != 1)
               {
                  this.addChild(btnIntoMywarehouse);
                  btnIntoMywarehouse.visible = false;
                  btnIntoBag.visible = true;
                  longTip.containerBtns.addChild(btnIntoBag);
                  Assets.positionDisplay(btnIntoBag,"checkDetail","bntBuy");
               }
               else
               {
                  btnIntoBag.visible = false;
               }
               checkDetail();
            }
         }
         _loc2_.selectedIndex = -1;
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         currentGoodsData = _loc2_.selectedItem as GoodsData;
         if(currentGoodsData)
         {
            onlyId = currentGoodsData.onlyID;
            this.addChild(btnIntoBag);
            btnIntoBag.visible = false;
            btnIntoMywarehouse.visible = true;
            longTip.containerBtns.addChild(btnIntoMywarehouse);
            Assets.positionDisplay(btnIntoMywarehouse,"checkDetail","bntBuy");
         }
         checkDetail();
         _loc2_.selectedIndex = -1;
      }
      
      override public function dispose() : void
      {
         btnIntoBag.removeFromParent();
         btnIntoMywarehouse.removeFromParent();
         GoodsList.instance.rentalSiganl.remove(updateList);
         super.dispose();
      }
   }
}

