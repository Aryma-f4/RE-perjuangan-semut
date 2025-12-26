package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Image;
   
   public class BtSelectItem extends UIExportSprite
   {
      
      private var _text:String;
      
      private var _img:Image;
      
      private var _propImage:Image;
      
      private var _state:int = 1;
      
      private var _isHaveData:Boolean = false;
      
      private var _isLock:Boolean = false;
      
      private var _showData:Object;
      
      public function BtSelectItem()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("publicComponent"));
         _layout.buildLayout("btSelectItem",_displayObj);
         _img = getImageByName("img");
         getTextFieldByName("text").nativeFilters = StarlingUITools.instance.getDropShadowFilter();
      }
      
      private function initShowData() : void
      {
         _displayObj.addChild(_propImage);
         showState(1);
      }
      
      public function lock(param1:Boolean) : void
      {
         _isLock = param1;
         if(param1)
         {
            showState(3);
         }
         else
         {
            showState(1);
         }
      }
      
      public function clearDataShow() : void
      {
         _propImage && _propImage.removeFromParent();
         _showData = null;
         text = "";
      }
      
      public function showState(param1:int) : void
      {
         _img.texture = Assets.sAsset.getTexture("pComponentSelectItem" + param1);
         _state = param1;
         if(_state != 1)
         {
            clearDataShow();
         }
      }
      
      public function updateSkill(param1:FightGoodsData) : void
      {
         clearDataShow();
         _showData = param1;
         _propImage = new Image(Assets.sAsset.getTexture("fightgoods" + param1.frame));
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos"),_propImage);
         initShowData();
      }
      
      public function updateWeapon(param1:GoodsData) : void
      {
         clearDataShow();
         _showData = param1;
         _propImage = Assets.sAsset.getGoodsImageByRect(param1.typeID,param1.frameID,getDisplayObjectByName("pos").bounds);
         initShowData();
         if(param1.strengthenNum != 0)
         {
            text = param1.strengthenNum.toString();
         }
         _displayObj.addChild(getTextFieldByName("text"));
      }
      
      public function get text() : String
      {
         return _text;
      }
      
      public function set text(param1:String) : void
      {
         _text = param1;
         if(param1 != "")
         {
            getTextFieldByName("text").text = "+" + _text;
         }
         else
         {
            getTextFieldByName("text").text = "";
         }
      }
      
      public function get state() : int
      {
         return _state;
      }
      
      public function get showData() : Object
      {
         return _showData;
      }
      
      public function get isLock() : Boolean
      {
         return _isLock;
      }
   }
}

