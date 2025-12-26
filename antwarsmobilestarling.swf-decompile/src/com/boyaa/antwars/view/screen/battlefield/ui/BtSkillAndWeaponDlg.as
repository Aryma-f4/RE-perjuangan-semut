package com.boyaa.antwars.view.screen.battlefield.ui
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.LocalData;
   import com.boyaa.antwars.data.model.FightGoodsData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.SkillItemListRender;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillData;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseSkillManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.UseWeaponData;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponChangeManager;
   import com.boyaa.antwars.view.screen.battlefield.ui.items.WeaponItemListRender;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import com.boyaa.antwars.view.screen.fresh.FreshGuideVlaue;
   import com.boyaa.antwars.view.screen.fresh.GuideTipManager;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.List;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.events.Event;
   
   public class BtSkillAndWeaponDlg extends UIExportSprite
   {
      
      private var _skillBtn:FashionStarlingButton;
      
      private var _weaponBtn:FashionStarlingButton;
      
      private var _list:List;
      
      private var _skillData:Vector.<UseSkillData>;
      
      private var _weaponData:Array;
      
      private var _maskBg:DlgMark;
      
      private var _skillItemVector:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      private var _weaponItemVector:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
      
      public function BtSkillAndWeaponDlg(param1:int)
      {
         super();
         isSkillUseful(param1);
         init();
         addEventListener("addedToStage",onAddToStage);
      }
      
      private function isSkillUseful(param1:int) : void
      {
         for each(var _loc2_ in UseSkillManager.instance.skillDataVector)
         {
            if(_loc2_.fightGoods.expendForce > param1)
            {
               _loc2_.isEnable = false;
            }
         }
      }
      
      private function onAddToStage(param1:Event) : void
      {
         removeEventListener("addedToStage",onAddToStage);
         _maskBg = new DlgMark();
         _maskBg.setTouchHandle(remove);
         parent.addChild(_maskBg);
         parent.swapChildren(this,_maskBg);
      }
      
      private function init() : void
      {
         _layout = new LayoutUitl(Assets.sAsset.getOther("BattlefieldUI"));
         _layout.buildLayout("btUIPopDlg",_displayObj);
         _list = new List();
         _list.layout = SmallCodeTools.instance.getListRowsLayout(15,10);
         _list.itemRendererType = SkillItemListRender;
         _list.dataProvider = new ListCollection(createSKillData());
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_list"),_list);
         addChildToDisplayObject(_list);
         getButtonByName("closeBtn").addEventListener("triggered",onCloseHandle);
         _skillBtn = new FashionStarlingButton(getButtonByName("skillBtn"));
         _weaponBtn = new FashionStarlingButton(getButtonByName("weaponBtn"));
         _skillBtn.groupTag = "BtSkillAndWeaponDlg";
         _weaponBtn.groupTag = "BtSkillAndWeaponDlg";
         _skillBtn.isSelect = true;
         _skillBtn.triggerFunction = onButtonTriggerHandle;
         _weaponBtn.triggerFunction = onButtonTriggerHandle;
         EventCenter.GameEvent.addEventListener("changeWeaponComplete",onChangeWeaponComlete);
         EventCenter.GameEvent.addEventListener("useSkillComplete",onUseSkillComplete);
         EventCenter.GameEvent.addEventListener("useSKill",onUseSkillHandle);
         if(Constants.isFresh)
         {
            EventCenter.GameEvent.addEventListener("freshGame",onFreshGameHandle);
            _list.addEventListener("rendererAdd",onListItemAdd);
            _list.addEventListener("rendererRemove",onListItemRemove);
            EventCenter.GameEvent.dispatchEvent(new GameEvent("freshGuideComplete"));
         }
      }
      
      private function onUseSkillHandle(param1:GameEvent) : void
      {
         var _loc2_:int = int(Object(param1.param).skillId);
      }
      
      private function onListItemRemove(param1:Event, param2:IListItemRenderer) : void
      {
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = [_skillItemVector,_weaponItemVector];
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
      
      private function onListItemAdd(param1:Event, param2:IListItemRenderer) : void
      {
         if(_weaponBtn.isSelect)
         {
            _weaponItemVector.push(param2);
         }
         else
         {
            _skillItemVector.push(param2);
         }
      }
      
      private function showChangeWeapon(param1:int, param2:int) : void
      {
         var type:int = param1;
         var frame:int = param2;
         var weaponData:UseWeaponData = null;
         var i:int = 0;
         while(i < WeaponChangeManager.instance.getWeaponData().length)
         {
            weaponData = WeaponChangeManager.instance.getWeaponData()[i];
            if(weaponData.weaponData.typeID == type && weaponData.weaponData.frameID == frame)
            {
               break;
            }
            weaponData = null;
            i = i + 1;
         }
         if(weaponData)
         {
            _list.scrollToDisplayIndex(i);
            Timepiece.instance.addDelayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  var _loc1_:int = 0;
                  var _loc2_:ListItemRenderer = null;
                  _loc1_ = 0;
                  while(_loc1_ < _weaponItemVector.length)
                  {
                     _loc2_ = _weaponItemVector[_loc1_] as ListItemRenderer;
                     if(_loc2_.data == weaponData)
                     {
                        GuideTipManager.instance.showByDisplayObject(_loc2_);
                        break;
                     }
                     _loc1_++;
                  }
               };
            })(),300);
         }
      }
      
      private function showSkillGuide(param1:int) : void
      {
         var skillId:int = param1;
         var skillData:UseSkillData = null;
         var i:int = 0;
         while(i < UseSkillManager.instance.skillDataVector.length)
         {
            skillData = UseSkillManager.instance.skillDataVector[i];
            if(skillData.id == skillId)
            {
               break;
            }
            skillData = null;
            i = i + 1;
         }
         if(skillData)
         {
            _list.scrollToDisplayIndex(i);
            Timepiece.instance.addDelayCall((function():*
            {
               var delay:Function;
               return delay = function():void
               {
                  var _loc1_:int = 0;
                  var _loc2_:ListItemRenderer = null;
                  _loc1_ = 0;
                  while(_loc1_ < _skillItemVector.length)
                  {
                     _loc2_ = _skillItemVector[_loc1_] as ListItemRenderer;
                     if(_loc2_.data == skillData)
                     {
                        GuideTipManager.instance.showByDisplayObject(_loc2_);
                        break;
                     }
                     _loc1_++;
                  }
               };
            })(),300);
         }
      }
      
      private function onFreshGameHandle(param1:GameEvent) : void
      {
         var e:GameEvent = param1;
         var arr:Array = e.param as Array;
         switch(arr[0])
         {
            case "usePlane":
               showSkillGuide(arr[1]);
               LocalData.instance.setData("skill","1|3");
               break;
            case "useSkill":
               showSkillGuide(arr[1]);
               break;
            case "changeTab":
               Timepiece.instance.addDelayCall((function():*
               {
                  var delay:Function;
                  return delay = function():void
                  {
                     GuideTipManager.instance.showByDisplayObject(_weaponBtn.starlingBtn);
                  };
               })(),300);
               break;
            case "changeWeapon":
               showChangeWeapon(arr[1][0],arr[1][1]);
         }
      }
      
      private function freshGuideDone() : void
      {
         if(!Constants.isFresh)
         {
            return;
         }
         if(FreshGuideVlaue.currentStepData)
         {
            switch(FreshGuideVlaue.currentStepData[0])
            {
               case "usePlane":
               case "useSkill":
               case "changeWeapon":
               case "changeTab":
                  if(FreshGuideVlaue.currentStepData[2])
                  {
                     remove();
                  }
                  GuideTipManager.instance.stopGuide();
                  EventCenter.GameEvent.dispatchEvent(new GameEvent("freshGuideComplete"));
            }
         }
      }
      
      private function onUseSkillComplete(param1:GameEvent) : void
      {
         var _loc8_:Object = param1.param as Object;
         var _loc7_:int = int(_loc8_.ep);
         var _loc2_:int = int(_loc8_.id);
         var _loc6_:FightGoodsData = GoodsList.instance.getFightDataByID(_loc2_);
         var _loc4_:int = 0;
         if(_loc6_.type == 2)
         {
            _loc4_ = 1;
         }
         var _loc3_:int = 0;
         for each(var _loc5_ in UseSkillManager.instance.skillDataVector)
         {
            if(_loc5_.fightGoods.expendForce > _loc7_)
            {
               _loc3_++;
               _loc5_.isEnable = false;
            }
            if(_loc5_.id == _loc2_ && _loc4_ == 1)
            {
               _loc4_--;
               UseSkillManager.instance.removeSkillByData(_loc5_);
            }
         }
         freshGuideDone();
         _list.dataProvider = new ListCollection(createSKillData());
         if(_loc3_ >= UseSkillManager.instance.skillDataVector.length)
         {
            remove();
         }
      }
      
      private function createSKillData() : Vector.<UseSkillData>
      {
         return UseSkillManager.instance.skillDataVector.concat();
      }
      
      private function onChangeWeaponComlete(param1:GameEvent) : void
      {
         _list.dataProvider = new ListCollection(WeaponChangeManager.instance.getWeaponData());
         _list.invalidate();
         freshGuideDone();
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         super.onCloseHandle(param1);
         remove();
      }
      
      private function remove() : void
      {
         EventCenter.GameEvent.removeEventListener("changeWeaponComplete",onChangeWeaponComlete);
         EventCenter.GameEvent.removeEventListener("useSkillComplete",onUseSkillComplete);
         EventCenter.GameEvent.removeEventListener("freshGame",onFreshGameHandle);
         _list.removeEventListener("rendererAdd",onListItemAdd);
         _list.removeEventListener("rendererRemove",onListItemRemove);
         this.removeFromParent(true);
         _maskBg.removeFromParent(true);
      }
      
      private function onButtonTriggerHandle(param1:Event) : void
      {
         var _loc2_:Button = param1.target as Button;
         if(_loc2_.name == "skillBtn")
         {
            _list.itemRendererType = SkillItemListRender;
            _list.dataProvider = new ListCollection(UseSkillManager.instance.skillDataVector);
         }
         else
         {
            _list.itemRendererType = WeaponItemListRender;
            _list.dataProvider = new ListCollection(WeaponChangeManager.instance.getWeaponData());
            freshGuideDone();
         }
      }
   }
}

