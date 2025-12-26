package com.boyaa.antwars.view.screen.backpack
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.shop.ShopItemDetailTip;
   import com.boyaa.antwars.view.screen.shop.SmallTip;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.layout.HorizontalLayout;
   import feathers.textures.Scale9Textures;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.textures.Texture;
   import starling.utils.RectangleUtil;
   
   public class EquipedListFrame extends Sprite
   {
      
      public var listContainer:Sprite;
      
      public var frameBtns:Sprite;
      
      public var posBtnContainer:Sprite;
      
      public var selectedImg:Image;
      
      private var goodsBox:Image;
      
      private var goodsBoxArr:Vector.<Image>;
      
      private var btnClose:Button;
      
      private var tipText:TextField;
      
      private var equipList:List;
      
      private var listData:ListCollection;
      
      private var sameTypeGoodsArr:Array = [];
      
      private var currentGoodsData:GoodsData;
      
      private var goodsDataVector:Vector.<GoodsData>;
      
      private var selectedId:int = 0;
      
      private var posName:String;
      
      private var posNameArr:Array = ["hat","coat","glove","weapon","shoes","wing","necklace","glass","weddingRing","normalRing"];
      
      private var posNameText:Array = LangManager.t("bbPos").split("|");
      
      private var strengthLevelTxtArr:Vector.<TextField>;
      
      private var shortTip:SmallTip;
      
      public var signal:Signal = new Signal();
      
      public var takeOffSignal:Signal = new Signal();
      
      public function EquipedListFrame()
      {
         super();
         init();
         this.addEventListener("addedToStage",onAddedToStage);
         this.addEventListener("removedFromStage",onRemovedFromStage);
      }
      
      private function init() : void
      {
         var _loc1_:Button = null;
         var _loc3_:TextField = null;
         var _loc8_:int = 0;
         posBtnContainer = new Sprite();
         listContainer = new Sprite();
         frameBtns = new Sprite();
         goodsDataVector = new Vector.<GoodsData>();
         goodsBoxArr = new Vector.<Image>();
         strengthLevelTxtArr = new Vector.<TextField>();
         var _loc7_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         Assets.sAsset.positionDisplay(_loc7_,"backpack","check_equp_bg");
         var _loc2_:Quad = new Quad(_loc7_.width - 10,_loc7_.height - 10,4269333);
         _loc2_.x = _loc7_.x + 5;
         _loc2_.y = _loc7_.y + 5;
         addChild(_loc2_);
         addChild(_loc7_);
         var _loc5_:Array = LangManager.t("bbPos").split("|");
         var _loc6_:Texture = Assets.sAsset.getTexture("bb17");
         var _loc4_:Texture = Assets.sAsset.getTexture("bb50");
         var _loc9_:Rectangle = Assets.getPosition("backpack","level0");
         _loc8_ = 0;
         while(_loc8_ < 10)
         {
            _loc1_ = new Button(_loc6_,_loc5_[_loc8_],_loc4_);
            _loc1_.fontColor = 16777215;
            _loc1_.fontSize = 30;
            _loc1_.name = _loc8_ + posNameArr[_loc8_];
            Assets.positionDisplay(_loc1_,"backpack","item" + _loc8_);
            _loc1_.addEventListener("triggered",onShowEquipList);
            posBtnContainer.addChild(_loc1_);
            _loc3_ = new TextField(_loc9_.width,_loc9_.height,"","Simei",24,16776960,true);
            _loc3_.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
            _loc3_.hAlign = "right";
            Assets.positionDisplay(_loc3_,"backpack","level" + _loc8_);
            strengthLevelTxtArr.push(_loc3_);
            addChild(_loc3_);
            _loc8_++;
         }
         selectedImg = new Image(Assets.sAsset.getTexture("bb50"));
         Assets.positionDisplay(selectedImg,"backpack","item0");
         addChild(selectedImg);
         addChild(posBtnContainer);
         initList();
         initButtons();
      }
      
      private function initList() : void
      {
         var _loc2_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         var _loc5_:Rectangle = Assets.getPosition("backpack","equip_list");
         _loc2_.x = _loc5_.x;
         _loc2_.y = _loc5_.y;
         _loc2_.width = 530;
         _loc2_.height = 200;
         var _loc1_:Quad = new Quad(_loc5_.width,_loc5_.height - 10,4269333);
         _loc1_.x = _loc5_.x + 5;
         _loc1_.y = _loc5_.y + 5;
         listContainer.addChild(_loc1_);
         listContainer.addChild(_loc2_);
         equipList = new List();
         equipList.itemRendererType = BagItemRender;
         var _loc4_:Rectangle = Assets.getPosition("backpack","equip_list");
         equipList.x = _loc4_.x + 20;
         equipList.y = _loc4_.y + 20;
         equipList.width = _loc4_.width - 20;
         equipList.addEventListener("change",onListChangeHandler);
         listContainer.addChild(equipList);
         listData = new ListCollection();
         var _loc3_:HorizontalLayout = new HorizontalLayout();
         _loc3_.gap = 5;
         _loc3_.paddingTop = 5;
         equipList.layout = _loc3_;
         equipList.verticalScrollPolicy = "off";
         listContainer.visible = false;
         addChild(listContainer);
         btnClose = new Button(Assets.sAsset.getTexture("bb14"),"",Assets.sAsset.getTexture("bb15"));
         Assets.sAsset.positionDisplay(btnClose,"backpack","btn_check_equip1");
         btnClose.addEventListener("triggered",onClose);
         addChild(btnClose);
      }
      
      private function initButtons() : void
      {
         var _loc3_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _loc3_.width = 314;
         _loc3_.height = 96;
         var _loc1_:Button = new Button(Assets.sAsset.getTexture("bb_check_0"),"",Assets.sAsset.getTexture("bb_check_1"));
         var _loc2_:Button = new Button(Assets.sAsset.getTexture("bb_takeoff_0"),"",Assets.sAsset.getTexture("bb_takeoff_1"));
         _loc1_.addEventListener("triggered",onCheck);
         _loc2_.addEventListener("triggered",onTakeOff);
         _loc1_.x = 20;
         _loc1_.y = _loc2_.y = 22;
         _loc2_.x = _loc1_.x + _loc1_.width + 10;
         frameBtns.addChild(_loc3_);
         frameBtns.addChild(_loc1_);
         frameBtns.addChild(_loc2_);
         frameBtns.visible = false;
         addChild(frameBtns);
      }
      
      private function initWearedGoods() : void
      {
         var _loc2_:int = 0;
         var _loc1_:GoodsData = null;
         _loc2_ = 0;
         while(_loc2_ < posNameArr.length)
         {
            _loc1_ = GoodsList.instance.getGoodsByPosName(posNameArr[_loc2_]);
            initEquipImg(_loc1_,_loc2_);
            goodsDataVector.push(_loc1_);
            _loc2_++;
         }
      }
      
      private function initEquipImg(param1:GoodsData, param2:int) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle = Assets.getPosition("backpack","item" + param2);
         if(!param1)
         {
            this.goodsBox = new Image(Assets.emptyTexture());
            (posBtnContainer.getChildAt(param2) as Button).text = posNameText[param2];
            strengthLevelTxtArr[param2].visible = false;
         }
         else
         {
            this.goodsBox = Assets.sAsset.getGoodsImage(param1.typeID,param1.frameID);
            (posBtnContainer.getChildAt(param2) as Button).text = "";
         }
         goodsBoxArr.push(goodsBox);
         this.goodsBox.touchable = false;
         if(this.goodsBox)
         {
            this.goodsBox.pivotX = 0;
            this.goodsBox.pivotY = 0;
            if(this.goodsBox.width < _loc4_.width && this.goodsBox.height < _loc4_.height)
            {
               _loc3_ = RectangleUtil.fit(new Rectangle(0,0,this.goodsBox.width,this.goodsBox.height),_loc4_,"none");
            }
            else
            {
               _loc3_ = RectangleUtil.fit(new Rectangle(0,0,this.goodsBox.width,this.goodsBox.height),_loc4_,"showAll");
            }
            addChild(this.goodsBox);
            this.goodsBox.x = _loc3_.x;
            this.goodsBox.y = _loc3_.y;
            this.goodsBox.width = _loc3_.width;
            this.goodsBox.height = _loc3_.height;
            if(param1)
            {
               strengthLevelTxtArr[param2].text = "+" + param1.strengthenNum;
               this.setChildIndex(strengthLevelTxtArr[param2],this.numChildren - 1);
               if(param1.strengthenNum != 0)
               {
                  strengthLevelTxtArr[param2].visible = true;
               }
               else
               {
                  strengthLevelTxtArr[param2].visible = false;
               }
            }
         }
      }
      
      public function updateEquipImg(param1:String, param2:GoodsData) : void
      {
         var _loc3_:int = 0;
         switch(param1)
         {
            case "hat":
               _loc3_ = 0;
               break;
            case "coat":
               _loc3_ = 1;
               break;
            case "glove":
               _loc3_ = 2;
               break;
            case "weapon":
               _loc3_ = 3;
               break;
            case "shoes":
               _loc3_ = 4;
               break;
            case "wing":
               _loc3_ = 5;
               break;
            case "necklace":
               _loc3_ = 6;
               break;
            case "glass":
               _loc3_ = 7;
               break;
            case "weddingRing":
               _loc3_ = 8;
               break;
            case "normalRing":
               _loc3_ = 9;
         }
         var _loc4_:Rectangle = Assets.getPosition("backpack","item" + _loc3_);
         if(param2)
         {
            (posBtnContainer.getChildAt(_loc3_) as Button).text = "";
            goodsBoxArr[_loc3_].removeFromParent();
            goodsBoxArr[_loc3_] = Assets.sAsset.getGoodsImageByRect(param2.typeID,param2.frameID,_loc4_);
            addChild(goodsBoxArr[_loc3_]);
            goodsBoxArr[_loc3_].parent.setChildIndex(goodsBoxArr[_loc3_],this.numChildren - 2);
            goodsBoxArr[_loc3_].touchable = false;
            goodsDataVector[_loc3_] = param2;
            strengthLevelTxtArr[_loc3_].text = "+" + param2.strengthenNum;
            this.setChildIndex(strengthLevelTxtArr[_loc3_],this.numChildren - 2);
            if(param2.strengthenNum != 0)
            {
               strengthLevelTxtArr[_loc3_].visible = true;
            }
            else
            {
               strengthLevelTxtArr[_loc3_].visible = false;
            }
         }
         else
         {
            (posBtnContainer.getChildAt(_loc3_) as Button).text = posNameText[_loc3_];
            (goodsBoxArr[_loc3_] as Image).texture = Assets.emptyTexture();
            strengthLevelTxtArr[_loc3_].visible = false;
         }
         listContainer.visible = false;
      }
      
      private function takeOffToBag() : void
      {
         takeOffSignal.dispatch(currentGoodsData);
         frameBtns.visible = false;
         updateEquipImg(posName,null);
         currentGoodsData = null;
         goodsDataVector[selectedId] = null;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         initWearedGoods();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < goodsBoxArr.length)
         {
            goodsBoxArr[_loc2_].removeFromParent();
            _loc2_++;
         }
         goodsDataVector.length = 0;
         goodsBoxArr.length = 0;
         goodsBox = null;
      }
      
      private function onClose(param1:Event) : void
      {
         signal.dispatch();
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc3_:List = List(param1.currentTarget);
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:GoodsData = _loc3_.selectedItem as GoodsData;
         if(_loc2_.stutas == 0)
         {
            TextTip.instance.show(LangManager.t("timeOver"));
         }
         else
         {
            (this.parent as Backpack).takeOn(_loc2_);
         }
         _loc3_.selectedIndex = -1;
      }
      
      private function onShowEquipList(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = null;
         var _loc5_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:Button = param1.target as Button;
         selectedImg.x = _loc4_.x;
         selectedImg.y = _loc4_.y;
         var _loc3_:int = int(_loc4_.name.substr(0,1));
         selectedId = _loc3_;
         posName = _loc4_.name.substr(1,_loc4_.name.length - 1);
         currentGoodsData = goodsDataVector[_loc3_];
         if(currentGoodsData)
         {
            frameBtns.visible = true;
            frameBtns.alpha = 0;
            Starling.juggler.tween(frameBtns,0.6,{
               "alpha":1,
               "transition":"easeOutBack"
            });
            this.setChildIndex(frameBtns,this.numChildren - 1);
            frameBtns.x = _loc4_.x - (frameBtns.width - _loc4_.width >> 1);
            if(frameBtns.x <= 190)
            {
               frameBtns.x = 260;
            }
            frameBtns.y = _loc4_.y + frameBtns.height;
         }
         else
         {
            _loc6_ = GoodsList.instance.getTypeID(posName);
            _loc2_ = GoodsList.instance.getEquipment(0);
            _loc5_ = int(_loc2_.length);
            sameTypeGoodsArr = [];
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               if((_loc2_[_loc7_] as GoodsData).typeID == _loc6_)
               {
                  sameTypeGoodsArr.push(_loc2_[_loc7_]);
               }
               _loc7_++;
            }
            if(sameTypeGoodsArr.length > 0)
            {
               listData.data = sameTypeGoodsArr;
               equipList.dataProvider = listData;
               listContainer.visible = true;
               this.setChildIndex(listContainer,this.numChildren - 1);
            }
            else
            {
               listContainer.visible = false;
               TextTip.instance.show(LangManager.t("bbTip"));
            }
         }
      }
      
      private function onTakeOff(param1:Event) : void
      {
         (this.parent as Backpack).takeOff(currentGoodsData);
         frameBtns.visible = false;
         updateEquipImg(posName,null);
         currentGoodsData = null;
         goodsDataVector[selectedId] = null;
      }
      
      private function onCheck(param1:Event) : void
      {
         var _loc2_:ShopItemDetailTip = null;
         if(currentGoodsData.isEquipment)
         {
            _loc2_ = (this.parent as Backpack).longTip;
            _loc2_.showButtonById(1);
            _loc2_.takeoffSignal.add(takeOffToBag);
            _loc2_.setData(currentGoodsData);
            _loc2_.y = 440;
            _loc2_.x = 637;
            _loc2_.pivotX = 151;
            _loc2_.pivotY = 305;
            _loc2_.scaleX = _loc2_.scaleY = 0;
            _loc2_.visible = true;
            Starling.juggler.tween(_loc2_,0.5,{
               "scaleX":1,
               "scaleY":1,
               "transition":"easeOut"
            });
         }
         frameBtns.visible = false;
      }
      
      public function cleanUp() : void
      {
      }
   }
}

