package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   
   public class WeddingManager
   {
      
      private static var _instance:WeddingManager = null;
      
      private var _isCoupleFight:Boolean = false;
      
      private var _delayMarryData:Array;
      
      public function WeddingManager(param1:Single)
      {
         super();
      }
      
      public static function get instance() : WeddingManager
      {
         if(_instance == null)
         {
            _instance = new WeddingManager(new Single());
         }
         return _instance;
      }
      
      public function init() : void
      {
         bindNet();
      }
      
      private function bindNet() : void
      {
         unBindNet();
         GameServer.instance.onWeddingMarry(6002,onWeddingPopMarryMsg);
         GameServer.instance.onWeddingMarry(6001,onWeddingIsSendPopMarryMsg);
         GameServer.instance.onWeddingMarry(6004,onWeddingPopMarryAnswer);
         GameServer.instance.onWeddingMarry(6041,onWeddingDivorceMsg);
         GameServer.instance.onWeddingMarry(6042,onWeddingDivorceAnswer);
         GameServer.instance.onWeddingMarry(6040,onWeddingIsSendDivorceMsg);
         GameServer.instance.onWeddingMarry(6007,onWeddingPushMarryMsg);
         GameServer.instance.onWeddingMarry(6006,onMarryStateHandle);
         GameServer.instance.onWeddingMarry(6038,onWeddingMarryBack);
      }
      
      private function onWeddingIsSendDivorceMsg(param1:Object) : void
      {
         var _loc2_:GoodsData = null;
         Application.instance.log("onWeddingIsSendDivorceMsg",JSON.stringify(param1));
         switch(int(param1.data.replycode))
         {
            case 0:
               TextTip.instance.showByLang("boyyabz");
               break;
            case 1:
               TextTip.instance.showByLang("weddingTip10");
               PlayerDataList.instance.selfData.clearMarryState();
               break;
            case 2:
               TextTip.instance.showByLang("weddingTip0");
               break;
            case 4:
               _loc2_ = GoodsList.instance.getGoodsById(36,1081);
               GoodsList.instance.removeGoodsByOnlyID(_loc2_.onlyID);
         }
         Application.instance.currentGame.mainMenu.backpack.updateData();
      }
      
      private function onWeddingDivorceAnswer(param1:Object) : void
      {
         Application.instance.log("onWeddingDivorceAnswer",JSON.stringify(param1));
         switch(int(param1.data.replyCode) - 1)
         {
            case 0:
               TextTip.instance.showByLang("weddingTip8");
               PlayerDataList.instance.selfData.clearMarryState();
               break;
            case 1:
               TextTip.instance.showByLang("weddingTip9");
         }
      }
      
      private function onWeddingDivorceMsg(param1:Object) : void
      {
         Application.instance.log("onWeddingDivorceMsg",JSON.stringify(param1));
         Application.instance.currentGame.addChild(new DivorceAgreeDlg(param1.data));
      }
      
      private function onWeddingPopMarryAnswer(param1:Object) : void
      {
         Application.instance.log("onWeddingPopMarryAnswer",JSON.stringify(param1));
         var _loc2_:Array = ["weddingTip3","weddingTip5","weddingTip2","weddingTip1","weddingTip4","weddingTip6","weddingTip7"];
         var _loc3_:Array = [2,7];
         TextTip.instance.showByLang(_loc2_[param1.data.replyCode - 1]);
         if(_loc3_.indexOf(param1.data.replyCode) != -1)
         {
            MissionManager.instance.updateMissionData(149);
            PlayerDataList.instance.selfData.partnerID == param1.data.uid;
            PlayerDataList.instance.selfData.marryState = 2;
         }
      }
      
      private function onWeddingIsSendPopMarryMsg(param1:Object) : void
      {
         var _loc2_:GoodsData = null;
         Application.instance.log("onWeddingIsSendPopMarryMsg",JSON.stringify(param1));
         switch(int(param1.data.replyCode))
         {
            case 0:
               _loc2_ = GoodsList.instance.getGoodsById(36,1071);
               GoodsList.instance.removeGoodsByOnlyID(_loc2_.onlyID);
               break;
            case 1:
               TextTip.instance.showByLang("weddingTip0");
               break;
            case 2:
               TextTip.instance.showByLang("jsonerror");
               break;
            case 4:
               TextTip.instance.showByLang("weddingTip1");
               break;
            case 5:
               TextTip.instance.showByLang("weddingTip2");
         }
         Application.instance.currentGame.mainMenu.backpack.updateData();
      }
      
      private function onWeddingPopMarryMsg(param1:Object) : void
      {
         Application.instance.log("onWeddingPopMarryMsg",JSON.stringify(param1));
         Application.instance.currentGame.addChild(new PopAgreeDlg(param1.data));
      }
      
      private function onWeddingPushMarryMsg(param1:Object) : void
      {
         _delayMarryData = param1.data.marryArr;
      }
      
      public function showDeleyMarryAsk() : void
      {
         if(!_delayMarryData || _delayMarryData.length <= 0)
         {
            return;
         }
         if(PlayerDataList.instance.selfData.inFight)
         {
            return;
         }
         var _loc1_:Object = _delayMarryData.pop();
         Application.instance.currentGame.addChild(new PopAgreeDlg(_loc1_));
      }
      
      private function onMarryStateHandle(param1:Object) : void
      {
         Application.instance.log("onMarryStateHandle",JSON.stringify(param1));
         var _loc3_:int = int(param1.data.omid);
         var _loc2_:int = int(param1.data.state);
         PlayerDataList.instance.selfData.partnerID = _loc3_;
         PlayerDataList.instance.selfData.marryState = _loc2_;
      }
      
      private function onWeddingMarryBack(param1:Object) : void
      {
         Application.instance.log("onWeddingMarryBack",JSON.stringify(param1));
         var _loc2_:int = int(param1.data.mid);
         var _loc3_:int = int(param1.data.replyCode);
         if(_loc3_ == 2)
         {
            PlayerDataList.instance.selfData.marryState = 1;
         }
      }
      
      private function unBindNet() : void
      {
         GameServer.instance.disposeRecvFun(onWeddingPopMarryMsg);
         GameServer.instance.disposeRecvFun(onWeddingIsSendPopMarryMsg);
         GameServer.instance.disposeRecvFun(onWeddingPopMarryAnswer);
         GameServer.instance.disposeRecvFun(onWeddingDivorceMsg);
         GameServer.instance.disposeRecvFun(onWeddingDivorceAnswer);
         GameServer.instance.disposeRecvFun(onWeddingIsSendDivorceMsg);
         GameServer.instance.disposeRecvFun(onWeddingPushMarryMsg);
         GameServer.instance.disposeRecvFun(onMarryStateHandle);
         GameServer.instance.disposeRecvFun(onWeddingMarryBack);
      }
      
      public function checkCoupleFight() : void
      {
         var _loc2_:PlayerData = PlayerDataList.instance.selfData;
         var _loc1_:PlayerData = PlayerDataList.instance.getTeamPlayerData(_loc2_.team);
         if(_loc1_ && _loc1_.uid == _loc2_.partnerID)
         {
            isCoupleFight = true;
         }
         else
         {
            isCoupleFight = false;
         }
         Application.instance.log("checkCoupleFight",isCoupleFight.toString());
      }
      
      public function get isCoupleFight() : Boolean
      {
         return _isCoupleFight;
      }
      
      public function set isCoupleFight(param1:Boolean) : void
      {
         _isCoupleFight = param1;
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
