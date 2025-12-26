package com.boyaa.antwars.view.screen.battlefield.ui.items
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.events.GameEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.battlefield.Battlefield;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import com.boyaa.antwars.view.screen.copygame.boss.BossWorld;
   import com.boyaa.antwars.view.screen.unionBossFight.UnionBossFightWorld;
   import com.boyaa.tool.LoadData;
   
   public class WeaponChangeManager
   {
      
      private static var _instance:WeaponChangeManager = null;
      
      private var _weaponVec:Vector.<UseWeaponData>;
      
      private var _self:SelfCharacterCtrl;
      
      private var _oldWeaponData:UseWeaponData;
      
      public function WeaponChangeManager(param1:Single)
      {
         super();
         _weaponVec = new Vector.<UseWeaponData>();
         addEvent();
      }
      
      public static function get instance() : WeaponChangeManager
      {
         if(_instance == null)
         {
            _instance = new WeaponChangeManager(new Single());
         }
         return _instance;
      }
      
      public function initWeapon(param1:Function = null) : void
      {
         var fun:Function = param1;
         Remoting.instance.getWeaponState((function():*
         {
            var callBack:Function;
            return callBack = function(param1:Object):void
            {
               var _loc3_:int = 0;
               var _loc2_:GoodsData = null;
               Application.instance.log("playerWeaponState",JSON.stringify(param1));
               WeaponChangeManager.instance.resetWeaponData([]);
               if(param1.ret == 0)
               {
                  _loc3_ = 0;
                  while(_loc3_ < param1.weapon.length)
                  {
                     _loc2_ = new GoodsData();
                     _loc2_.updateGoodsInfo(param1.weapon[_loc3_]);
                     WeaponChangeManager.instance.addWeaponData(_loc2_);
                     _loc3_++;
                  }
                  if(fun != null)
                  {
                     fun();
                  }
               }
            };
         })());
      }
      
      private function addEvent() : void
      {
         EventCenter.GameEvent.addEventListener("changeWeapon",onChangeWeapon);
      }
      
      private function onUseWeaponComplete(param1:GoodsData) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _weaponVec.length)
         {
            if(param1 == _weaponVec[_loc2_].weaponData)
            {
               _weaponVec[_loc2_] = _oldWeaponData;
               break;
            }
            _loc2_++;
         }
         _self.changeWeapon(param1);
         sendToServer();
         EventCenter.GameEvent.dispatchEvent(new GameEvent("changeWeaponComplete",{}));
      }
      
      private function sendToServer() : void
      {
         if(Application.instance.currentGame.currentWorld is Battlefield)
         {
            BattleServer.instance.sendChangeWeaponDone();
         }
         else if(Application.instance.currentGame.currentWorld is BossWorld)
         {
            CopyServer.instance.sendChangeWeaponDone(1);
         }
         else if(Application.instance.currentGame.currentWorld is UnionBossFightWorld)
         {
            CopyServer.instance.sendChangeWeaponDone(2);
         }
      }
      
      private function onChangeWeapon(param1:GameEvent) : void
      {
         var e:GameEvent = param1;
         var obj:UseWeaponData = e.param.data as UseWeaponData;
         _oldWeaponData = new UseWeaponData(_self.character.wqGoods);
         if(obj.weaponData.lowerlevel > PlayerDataList.instance.selfData.level)
         {
            TextTip.instance.show(LangManager.t("levelerror") + obj.weaponData.lowerlevel);
            return;
         }
         LoadData.show();
         GameServer.instance.setMemBody([obj.weaponData.getPosName(),1,obj.weaponData.onlyID],function(param1:Object):void
         {
            var arr:Array;
            var retData:Object = param1;
            Application.instance.log("WeaponChange",JSON.stringify(retData));
            LoadData.hide();
            if(retData)
            {
               arr = retData as Array;
               if(arr[0])
               {
                  if(arr[1][1] != 0)
                  {
                     GoodsList.instance.wearGoods(arr[1][0],arr[2]);
                     TextTip.instance.show(LangManager.t("equipOK"));
                     MissionManager.instance.updateMissionData(180,1,0);
                     _self.character.wearById(obj.weaponData.typeID,obj.weaponData.frameID);
                     MissionManager.instance.updateMissionData(163,obj.weaponData.typeID,obj.weaponData.frameID,1);
                     Remoting.instance.changeWeaponInBattle(_oldWeaponData.weaponData.onlyID,obj.weaponData.onlyID,(function():*
                     {
                        var done:Function;
                        return done = function(param1:Object):void
                        {
                           Application.instance.log("PHP-ChangeWeaponInFight",JSON.stringify(param1));
                           if(param1.ret == 0)
                           {
                              onUseWeaponComplete(obj.weaponData);
                           }
                           else
                           {
                              switch(param1.ret)
                              {
                                 case 100:
                                 case 200:
                                 case 300:
                              }
                           }
                        };
                     })());
                     return;
                  }
               }
            }
            TextTip.instance.show(LangManager.t("equipFail"));
         });
      }
      
      public function setUsePlayer(param1:SelfCharacterCtrl) : void
      {
         _self = param1;
      }
      
      public function resetWeaponData(param1:Array) : void
      {
         var _loc2_:int = 0;
         _weaponVec = new Vector.<UseWeaponData>();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            addWeaponData(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function addWeaponData(param1:GoodsData) : void
      {
         var _loc2_:UseWeaponData = new UseWeaponData(param1);
         _weaponVec.push(_loc2_);
      }
      
      public function removeWeaponData(param1:GoodsData) : void
      {
         for each(var _loc2_ in _weaponVec)
         {
            if(_loc2_.weaponData == param1)
            {
               _weaponVec.splice(_weaponVec.indexOf(_loc2_),1);
               break;
            }
         }
      }
      
      public function getWeaponData() : Vector.<UseWeaponData>
      {
         return _weaponVec;
      }
      
      public function get weaponVec() : Vector.<UseWeaponData>
      {
         return _weaponVec;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
