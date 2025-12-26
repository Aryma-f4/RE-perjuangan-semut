package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.ChangeScreenLoading;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.fresh.Guide;
   import com.boyaa.debug.Logging.LevelLogger;
   import org.osflash.signals.Signal;
   
   public class InviteFriendFeedManager
   {
      
      private static var _instance:InviteFriendFeedManager = null;
      
      private var _inviteSignal:Signal;
      
      private var _roomID:int;
      
      private var _serverID:int;
      
      private var _isShow:Boolean = false;
      
      private var _password:String = "";
      
      public function InviteFriendFeedManager(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : InviteFriendFeedManager
      {
         if(_instance == null)
         {
            _instance = new InviteFriendFeedManager(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _inviteSignal = new Signal(Object);
         addInviteListener(beInviteForFight);
      }
      
      public function addInviteListener(param1:Function) : void
      {
         _inviteSignal.add(param1);
      }
      
      public function removeInviteListener(param1:Function) : void
      {
         _inviteSignal.remove(param1);
      }
      
      public function inviteForFight(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         GameServer.instance.inviteFriend(param1,param2,param3,param4,param5);
      }
      
      private function beInviteForFight(param1:Object) : void
      {
         if(PlayerDataList.instance.selfData.inFight)
         {
            return;
         }
         if(ChangeScreenLoading.isShow)
         {
            return;
         }
         var _loc2_:Array = ["BTROOM","TEAMROOM"];
         if(_loc2_.indexOf(Application.instance.currentGame.navigator.activeScreenID) != -1 || _isShow)
         {
            return;
         }
         LevelLogger.getLogger("beInviteForFight").info(JSON.stringify(param1));
         var _loc3_:String = "";
         if(param1.pkType == 1)
         {
            _loc3_ = LangManager.getLang.getreplaceLang("invite2v2",param1.name);
         }
         else
         {
            _loc3_ = LangManager.getLang.getreplaceLang("invite1v1",param1.name);
         }
         _roomID = param1.roomId;
         _serverID = param1.serverId;
         _password = param1.password;
         _isShow = true;
         SystemTip.instance.showSystemAlert(_loc3_,yesFunction,noFunction,true);
      }
      
      private function yesFunction() : void
      {
         _isShow = false;
         Guide.instance.stop();
         GameServer.instance.acceptInvite(PlayerDataList.instance.selfData.uid,true);
         Application.instance.currentGame.showLoading();
         if(!BattleServer.instance.isConnect)
         {
            GameServer.instance.getServerIDByType(1,function(param1:Object):void
            {
               var serData:ServerData;
               var data:Object = param1;
               LevelLogger.getLogger("yesFunction").info(JSON.stringify(data));
               if(data.ret == 0)
               {
                  serData = AllRoomData.instance.getDataByID(data.svid);
                  BattleServer.instance.init(serData.ip,serData.port);
                  BattleServer.instance.connect();
                  BattleServer.instance.login(function(param1:Object):void
                  {
                     if(param1.ret == 1)
                     {
                        TextTip.instance.show(LangManager.t("longinBattleFail") + param1.data.errCode);
                        BattleServer.instance.close();
                        Application.instance.currentGame.hiddenLoading();
                     }
                     else
                     {
                        PlayerDataList.instance.pk_type = 1;
                        BattleServer.instance.seekRoom(_roomID,_password);
                     }
                  });
               }
            });
         }
         else
         {
            Application.instance.currentGame.hiddenLoading();
            PlayerDataList.instance.pk_type = 1;
            BattleServer.instance.seekRoom(_roomID,_password);
         }
      }
      
      private function noFunction() : void
      {
         _isShow = false;
         GameServer.instance.acceptInvite(PlayerDataList.instance.selfData.uid,false);
      }
      
      public function get inviteSignal() : Signal
      {
         return _inviteSignal;
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
