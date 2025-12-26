package com.boyaa.antwars.view.screen.copygame.game
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.view.character.Character;
   import com.boyaa.antwars.view.character.CharacterFactory;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.game.ICharacter;
   import com.boyaa.antwars.view.game.IGameWorld;
   import com.boyaa.antwars.view.screen.battlefield.element.SelfCharacterCtrl;
   import flash.geom.Point;
   
   public class CopyGameSelfRobot
   {
      
      private var _attackTarget:ICharacter;
      
      private var _robot:CopyGameRobotCtrl;
      
      private var _gameWorld:IGameWorld;
      
      private var _selfCharacterCtrl:SelfCharacterCtrl;
      
      private var _siteID:int;
      
      public function CopyGameSelfRobot(param1:IGameWorld, param2:ICharacter)
      {
         super();
         _attackTarget = param2;
         _gameWorld = param1;
         _selfCharacterCtrl = GameWorld(_gameWorld).selfCharacterCtrl;
      }
      
      public function addRobotToWorld(param1:Point) : void
      {
         var _loc3_:PlayerData = new PlayerData();
         var _loc2_:PlayerData = PlayerDataList.instance.getDataBySiteID(PlayerDataList.instance.selfData.siteID);
         _loc3_.exp = _loc2_.exp;
         _loc3_.level = _loc2_.level;
         var _loc4_:Character = CharacterFactory.instance.checkOutCharacter(_loc3_.babySex);
         _loc4_.initData(_loc2_.getPropData());
         _siteID = _loc2_.siteID + 1;
         _robot = new CopyGameRobotCtrl(_gameWorld,_loc4_,_siteID,_loc2_.HP,"~" + _loc2_.babyName);
         initRobot();
         _gameWorld.charatersLayer.addChild(_loc4_);
         _loc4_.x = param1.x;
         _loc4_.y = param1.y;
         _gameWorld.UILayer.addChar(_robot.siteID,_loc2_.team + 1,_loc4_,_robot.hp);
      }
      
      private function initRobot() : void
      {
         _robot.downStart();
         _robot.attackTarget = _attackTarget;
         _robot.setAttr();
         _robot.setColorMatrixFilter();
      }
      
      public function addSignalFunc(param1:Array) : void
      {
         _robot.slottingCompleteSignal.add(param1[0]);
         _robot.actionCompeleteSignal.add(param1[1]);
         _robot.dieSignal.addOnce(param1[2]);
      }
      
      public function get robot() : CopyGameRobotCtrl
      {
         return _robot;
      }
      
      public function get siteID() : int
      {
         return _robot.siteID;
      }
   }
}

