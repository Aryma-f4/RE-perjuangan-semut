package com.boyaa.antwars.view.vipSystem
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.net.server.GameServer;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class VipButton extends Sprite
   {
      
      private var _button:Button;
      
      private var _txtImg:Image;
      
      private var _numImg:Image;
      
      private var _triggerFunction:Function = null;
      
      private var _level:int = 0;
      
      public function VipButton()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _button = new Button(Assets.sAsset.getTexture("VipButtonInHall0001"),"",Assets.sAsset.getTexture("VipButtonInHall0002"));
         _button.addEventListener("triggered",onButtonTriggerHandle);
         addChild(_button);
         _txtImg = new Image(Assets.sAsset.getTexture("VIPText"));
         _txtImg.x = 20;
         _txtImg.y = 26;
         _txtImg.touchable = false;
         _numImg = new Image(Assets.sAsset.getTexture("vipLevelNum0001"));
         _numImg.x = 140;
         _numImg.y = 20;
         _numImg.touchable = false;
         addChild(_txtImg);
         addChild(_numImg);
      }
      
      private function onButtonTriggerHandle(param1:Event) : void
      {
         if(_triggerFunction != null)
         {
            _triggerFunction(param1);
         }
      }
      
      public function showLevelByPlayerData(param1:PlayerData) : void
      {
         var data:PlayerData = param1;
         GameServer.instance.onSomeOneVipLevel((function():*
         {
            var callBack:Function;
            return callBack = function(param1:Object):void
            {
               var _loc2_:PlayerData = PlayerDataList.instance.getDataByUID(param1.who);
               _loc2_.vipLevel = param1.level;
               setLevel(_loc2_.vipLevel);
            };
         })(),true);
         GameServer.instance.getSomeOneVipLevel(data.uid);
      }
      
      public function setLevel(param1:int) : void
      {
         _level = param1;
         if(_level == 0)
         {
            _txtImg.x = 65;
            _numImg.visible = false;
         }
         else
         {
            _txtImg.x = 20;
            _numImg.texture = Assets.sAsset.getTexture("vipLevelNum000" + param1);
            _numImg.visible = true;
         }
      }
      
      public function get triggerFunction() : Function
      {
         return _triggerFunction;
      }
      
      public function set triggerFunction(param1:Function) : void
      {
         _triggerFunction = param1;
      }
      
      public function get level() : int
      {
         return _level;
      }
   }
}

