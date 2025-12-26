package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Image;
   
   public class BtRoomPropItemListRender extends LayoutListItemRender
   {
      
      private var _img:Image;
      
      private var _propImg:Image;
      
      private var _weaponView:GoodsDetailView;
      
      private var _state:int = 0;
      
      public function BtRoomPropItemListRender()
      {
         super();
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("btRoom"));
         _layoutUtil.buildLayout("btRoomPropItem",_displayObject);
         _img = getImageByName("img");
         initOriginRenderItems();
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(_propImg)
         {
            _propImg.removeFromParent();
         }
         if(_weaponView)
         {
            _weaponView.removeFromParent();
         }
         _img.texture = Assets.sAsset.getTexture("img_btRoomItem1");
         if(this._data is UseSkillData)
         {
            _propImg = createProp(this._data as UseSkillData);
            _displayObject.addChild(_propImg);
            _state = 0;
         }
         else if(this._data is UseWeaponData)
         {
            _weaponView = createWeapon(this._data as UseWeaponData);
            _displayObject.addChild(_weaponView);
            _state = 1;
         }
         else if(this._data.string == "add")
         {
            _img.texture = Assets.sAsset.getTexture("img_btRoomItem2");
            _state = 2;
         }
         else
         {
            _img.texture = Assets.sAsset.getTexture("img_btRoomItem3");
            _state = 3;
         }
      }
      
      private function createProp(param1:UseSkillData) : Image
      {
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("fightgoods" + param1.id));
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos"),_loc2_);
         return _loc2_;
      }
      
      private function createWeapon(param1:UseWeaponData) : GoodsDetailView
      {
         var _loc2_:GoodsDetailView = new GoodsDetailView(getDisplayObjectByName("pos").bounds,param1.weaponData);
         _loc2_.touchable = false;
         return _loc2_;
      }
   }
}

