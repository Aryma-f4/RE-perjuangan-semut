package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.debug.Logging.LevelLogger;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class EnergyBar extends Sprite
   {
      
      private var bg:Scale9Image;
      
      private var bg1:Scale9Image;
      
      private var barBg:Scale9Image;
      
      private var txtName:TextField;
      
      private var txtTotal:TextField;
      
      private var txtCurrent:TextField;
      
      private var star:Image;
      
      private var starNum:TextField;
      
      private var quad:Scale9Image;
      
      private const ENERGY:int = 60;
      
      private var _currentEnergy:int = 60;
      
      public function EnergyBar()
      {
         super();
         bg = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(17,17,38,38)),Assets.sAsset.scaleFactor);
         Assets.positionDisplay(bg,"energy","energy0Other");
         addChild(bg);
         bg1 = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(17,17,38,38)),Assets.sAsset.scaleFactor);
         Assets.positionDisplay(bg1,"energy","energy6Other");
         addChild(bg1);
         barBg = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("nlz2"),new Rectangle(5,5,165,13)));
         Assets.positionDisplay(barBg,"energy","energy2Other");
         addChild(barBg);
         quad = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("nlz1"),new Rectangle(5,5,165,13)));
         Assets.positionDisplay(quad,"energy","energy3Other");
         addChild(quad);
         txtName = new TextField(200,30,LangManager.t("powerName"),"Verdana",24,16777215);
         txtName.autoScale = true;
         Assets.positionDisplay(txtName,"energy","energy1Other");
         addChild(txtName);
         txtCurrent = new TextField(100,30,"60","Verdana",24,16777215);
         txtCurrent.autoScale = true;
         Assets.positionDisplay(txtCurrent,"energy","energy4Other");
         addChild(txtCurrent);
         txtTotal = new TextField(100,30,"/60","Verdana",24,16777215);
         txtTotal.autoScale = true;
         Assets.positionDisplay(txtTotal,"energy","energy5Other");
         addChild(txtTotal);
         star = new Image(Assets.sAsset.getTexture("fb11"));
         Assets.positionDisplay(star,"energy","starOther");
         addChild(star);
         starNum = new TextField(100,30,"50","Verdana",24,16777215);
         starNum.autoScale = true;
         Assets.positionDisplay(starNum,"energy","txtNumOther");
         addChild(starNum);
         autoUpdate();
         Timepiece.instance.addTimerFun(autoUpdate,30000);
      }
      
      public static function updatePlayerEnergy() : void
      {
         GameServer.instance.sentMsgToGetEnergy();
         GameServer.instance.getPlayerEnergy(function(param1:Object):void
         {
            var _loc2_:int = int(param1.data.energy);
            PlayerDataList.instance.selfData.energy = _loc2_;
         });
      }
      
      public function set currentEnergy(param1:int) : void
      {
         _currentEnergy = param1;
         txtCurrent.text = _currentEnergy.toString();
         update(_currentEnergy);
      }
      
      public function get currentEnergy() : int
      {
         return _currentEnergy;
      }
      
      private function autoUpdate() : void
      {
         GameServer.instance.sentMsgToGetEnergy();
         GameServer.instance.getPlayerEnergy(playerEnergy);
      }
      
      private function playerEnergy(param1:Object) : void
      {
         LevelLogger.getLogger("PlayerEnergy").info(JSON.stringify(param1));
         var _loc2_:int = int(param1.data.userId);
         var _loc4_:int = int(param1.data.type);
         var _loc3_:int = int(param1.data.energy);
         PlayerDataList.instance.selfData.energy = _loc3_;
         _currentEnergy = _loc3_;
         txtCurrent.text = String(_loc3_);
         update(_currentEnergy);
      }
      
      public function increaseEnergy(param1:int) : void
      {
         _currentEnergy += param1;
         txtCurrent.text = _currentEnergy.toString();
         update(_currentEnergy);
      }
      
      public function updateEnergy(param1:int) : void
      {
         _currentEnergy = param1;
         txtCurrent.text = _currentEnergy.toString();
         update(_currentEnergy);
      }
      
      public function decreaseEnergy(param1:int) : void
      {
         _currentEnergy -= param1;
         txtCurrent.text = _currentEnergy.toString();
         update(_currentEnergy);
      }
      
      private function update(param1:int) : void
      {
         this.quad.scaleX = Math.max(0,Math.min(1,param1 / 60));
      }
      
      public function set allStarNum(param1:int) : void
      {
         starNum.text = " X" + param1.toString();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Timepiece.instance.removeFun(autoUpdate,1);
      }
   }
}

