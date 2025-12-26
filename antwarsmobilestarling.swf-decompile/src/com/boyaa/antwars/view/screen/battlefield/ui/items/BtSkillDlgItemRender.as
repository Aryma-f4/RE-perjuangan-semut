package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Image;
   
   public class BtSkillDlgItemRender extends LayoutListItemRender
   {
      
      private var _title:String;
      
      private var _desc:String;
      
      private var _skillImg:Image;
      
      private var _weaponView:GoodsDetailView;
      
      private var _text:String;
      
      public function BtSkillDlgItemRender()
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
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("btSkillDlg"));
         _layoutUtil.buildLayout("weaponAndProp",_displayObject);
         getTextFieldByName("addText").nativeFilters = StarlingUITools.instance.getDropShadowFilter();
         initOriginRenderItems();
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         clearData();
         if(this._data is FightGoodsData)
         {
            _skillImg = createSkill();
            _displayObject.addChild(_skillImg);
         }
         if(this._data is GoodsData)
         {
            _weaponView = createWeapon();
            _displayObject.addChild(_weaponView);
         }
         _displayObject.addChild(getTextFieldByName("addText"));
      }
      
      private function clearData() : void
      {
         _skillImg && _skillImg.removeFromParent();
         _weaponView && _weaponView.removeFromParent();
      }
      
      private function createSkill() : Image
      {
         var _loc2_:FightGoodsData = this._data as FightGoodsData;
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("fightgoods" + _loc2_.frame));
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos"),_loc1_);
         title = _loc2_.name;
         desc = _loc2_.info;
         text = "";
         return _loc1_;
      }
      
      private function createWeapon() : GoodsDetailView
      {
         var _loc2_:GoodsData = this._data as GoodsData;
         var _loc1_:GoodsDetailView = new GoodsDetailView(getDisplayObjectByName("pos").bounds,_loc2_);
         _loc1_.touchable = false;
         title = _loc2_.name;
         desc = _loc2_.dec;
         if(_loc2_.strengthenNum != 0)
         {
            text = "+" + _loc2_.strengthenNum;
         }
         else
         {
            text = "";
         }
         return _loc1_;
      }
      
      public function set title(param1:String) : void
      {
         _title = param1;
         getTextFieldByName("title").text = _title;
      }
      
      public function set desc(param1:String) : void
      {
         _desc = param1;
         getTextFieldByName("desc").text = _desc;
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         getTextFieldByName("addText").text = _text;
      }
   }
}

