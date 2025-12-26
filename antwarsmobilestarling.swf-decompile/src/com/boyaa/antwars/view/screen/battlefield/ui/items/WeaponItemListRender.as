package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.screen.shop.GoodsDetailView;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class WeaponItemListRender extends LayoutListItemRender
   {
      
      private var _weaponView:Sprite;
      
      private var _numText:TextField;
      
      private var _useData:UseWeaponData;
      
      public function WeaponItemListRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("BattlefieldUI"));
         _layoutUtil.buildLayout("btUIPropAndWeaponLayout",_displayObject);
         _numText = getTextFieldByName("text");
         getButtonByName("btn").addEventListener("triggered",onUseButtonHandle);
         _numText.touchable = false;
         _numText.nativeFilters = StarlingUITools.instance.getDropShadowFilter();
         _numText.bold = true;
         _weaponView = new Sprite();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_prop"),_weaponView);
         _displayObject.addChild(_weaponView);
         _displayObject.addChild(_numText);
         _weaponView.touchable = false;
         initOriginRenderItems();
      }
      
      private function onUseButtonHandle(param1:Event) : void
      {
         EventCenter.GameEvent.dispatchEvent(new com.boyaa.antwars.events.GameEvent("changeWeapon",{"data":_useData}));
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         _useData = this._data as UseWeaponData;
         _weaponView.removeChildren();
         _weaponView.addChild(createWeaponShow(_useData.weaponData));
         if(_useData.weaponData.strengthenNum > 0)
         {
            _numText.text = "+" + _useData.weaponData.strengthenNum.toString();
         }
         else
         {
            _numText.text = "";
         }
      }
      
      private function createWeaponShow(param1:GoodsData) : GoodsDetailView
      {
         var _loc2_:GoodsDetailView = new GoodsDetailView(getDisplayObjectByName("pos_prop").bounds,param1);
         _loc2_.x = 0;
         _loc2_.y = 0;
         _loc2_.touchable = false;
         return _loc2_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

