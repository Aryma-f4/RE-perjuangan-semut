package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.greensock.TweenLite;
   import flash.geom.Point;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class SkillItemListRender extends LayoutListItemRender
   {
      
      private var _skillView:Sprite;
      
      private var _numText:TextField;
      
      private var _useSkillData:UseSkillData;
      
      public function SkillItemListRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _layoutUtil = new LayoutUitl(Assets.sAsset.getOther("BattlefieldUI"));
         _layoutUtil.buildLayout("btUIPropAndWeaponLayout",_displayObject);
         _numText = getTextFieldByName("text");
         getButtonByName("btn").addEventListener("triggered",onSKillButtonHandle);
         _numText.touchable = false;
         _skillView = new Sprite();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_prop"),_skillView);
         _displayObject.addChild(_skillView);
         _skillView.touchable = false;
         initOriginRenderItems();
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         if(!this._data)
         {
            return;
         }
         _useSkillData = this._data as UseSkillData;
         _skillView.removeChildren();
         _skillView.addChild(createSkill(_useSkillData.id));
         if(!_useSkillData.isEnable)
         {
            isGray = true;
         }
      }
      
      private function onSKillButtonHandle(param1:Event) : void
      {
         var _loc2_:Object = {
            "listItem":this,
            "skillId":_useSkillData.id
         };
         if(UseSkillManager.instance.bulletType && _useSkillData.id == 10)
         {
            return;
         }
         if(UseSkillManager.instance.limitSkillCount && _useSkillData.id == 2)
         {
            return;
         }
         useSkillAnimation();
         EventCenter.GameEvent.dispatchEvent(new com.boyaa.antwars.events.GameEvent("useSKill",_loc2_));
         if(_useSkillData.id == 10)
         {
            UseSkillManager.instance.bulletType = 1;
         }
         if(_useSkillData.id == 2)
         {
            UseSkillManager.instance.limitSkillCount = 1;
         }
      }
      
      private function useSkillAnimation() : void
      {
         var complete:* = function():void
         {
            image.removeFromParent(true);
         };
         var image:Image = createSkill(_useSkillData.id);
         var pt:Point = this.parent.localToGlobal(new Point(this.x,this.y));
         image.x = pt.x;
         image.y = pt.y;
         Application.instance.currentGame.addChild(image);
         TweenLite.to(image,1.5,{
            "alpha":0,
            "y":pt.y - 100,
            "onComplete":complete
         });
      }
      
      private function createSkill(param1:int) : Image
      {
         var _loc2_:Image = new Image(Assets.sAsset.getTexture("fightgoods" + param1));
         _loc2_.touchable = false;
         return _loc2_;
      }
   }
}

