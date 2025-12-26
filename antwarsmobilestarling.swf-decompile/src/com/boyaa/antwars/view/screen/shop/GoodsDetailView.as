package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.ShopData;
   import com.boyaa.antwars.view.display.ClickSprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class GoodsDetailView extends ClickSprite
   {
      
      private var _comparison:Boolean;
      
      private var _propInfo:SmallTip;
      
      private var _equipInfo:ShopItemDetailTip;
      
      private var _currentData:ShopData;
      
      private var _goodImage:Image;
      
      private var _box:Rectangle;
      
      private var _numTxt:TextField;
      
      public function GoodsDetailView(param1:Rectangle = null, param2:ShopData = null, param3:Boolean = false)
      {
         super();
         _propInfo = SmallTip.getInstance();
         _equipInfo = ShopItemDetailTip.getInstance();
         _box = param1;
         _comparison = param3;
         updateShopData(param2);
      }
      
      public function updateShopData(param1:ShopData) : void
      {
         _currentData = param1;
         if(_currentData)
         {
            if(_box)
            {
               _goodImage = Assets.sAsset.getGoodsImageByRect(param1.typeID,param1.frameID,_box);
            }
            else
            {
               _goodImage = Assets.sAsset.getGoodsImage(param1.typeID,param1.frameID);
            }
            addChild(_goodImage);
         }
      }
      
      public function addEvent() : void
      {
         addEventListener("triggered",onShowDetails);
      }
      
      public function remove() : void
      {
      }
      
      private function show() : void
      {
         if(!_currentData)
         {
            return;
         }
         var _loc1_:Point = localToGlobal(new Point(_goodImage.x,_goodImage.y));
         if(_currentData.isEquipment)
         {
            if(_comparison && hasSameTypeGoods())
            {
               showTwoDlg();
            }
            else
            {
               _equipInfo.setData(_currentData);
               _equipInfo.showButtonById(5);
               _equipInfo.y = 440;
               _equipInfo.x = 807;
               _equipInfo.pivotX = 151;
               _equipInfo.pivotY = 305;
               _equipInfo.scaleX = _equipInfo.scaleY = 1;
               _equipInfo.visible = true;
               Application.instance.currentGame.stage.addChild(_equipInfo);
            }
         }
         else
         {
            _propInfo.setData(_currentData);
            _propInfo.showButtonById(2);
            _propInfo.pivotX = 151;
            _propInfo.pivotY = 180;
            _propInfo.y = _loc1_.y;
            _propInfo.x = _loc1_.x;
            if(_propInfo.x >= 1024 - _propInfo.width)
            {
               _propInfo.x = 1024 - _propInfo.width;
            }
            else if(_propInfo.x < _propInfo.width)
            {
               _propInfo.x = _propInfo.width;
            }
            _propInfo.scaleX = _propInfo.scaleY = 1;
            _propInfo.visible = true;
            Application.instance.currentGame.stage.addChild(_propInfo);
         }
      }
      
      private function showTwoDlg() : void
      {
         var _loc1_:CopyShopDetail = null;
         _equipInfo.setData(_currentData);
         _equipInfo.showButtonById(5);
         _equipInfo.y = 440;
         _equipInfo.x = 440;
         _equipInfo.pivotX = 151;
         _equipInfo.pivotY = 305;
         _equipInfo.scaleX = _equipInfo.scaleY = 1;
         _equipInfo.visible = true;
         Application.instance.currentGame.stage.addChild(_equipInfo);
         _currentData.typeID;
         var _loc2_:ShopData = hasSameTypeGoods();
         if(_loc2_)
         {
            _loc1_ = new CopyShopDetail();
            _loc1_.setData(_loc2_);
            Application.instance.currentGame.stage.addChild(_loc1_);
            _loc1_.x = _equipInfo.x + _equipInfo.width + 20;
            _loc1_.y = 440;
            _loc1_.pivotX = 151;
            _loc1_.pivotY = 305;
         }
      }
      
      private function onShowDetails(param1:Event) : void
      {
         show();
      }
      
      private function hasSameTypeGoods() : ShopData
      {
         var _loc4_:int = 0;
         var _loc2_:ShopData = null;
         var _loc1_:Array = PlayerDataList.instance.selfData.getPropData();
         var _loc3_:int = int(_loc1_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc1_[_loc4_] as ShopData;
            if(_loc2_.typeID == _currentData.typeID)
            {
               return _loc2_;
            }
            _loc4_++;
         }
         return null;
      }
   }
}

