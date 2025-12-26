package com.boyaa.antwars.control
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.model.ServerData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   
   public class ServerManager
   {
      
      public static const BATTLE:int = 1;
      
      public static const DUPLICATE:int = 3;
      
      public static const ENDLESS:int = 21;
      
      public static const UNION_BOSS:int = 22;
      
      private static var _instance:ServerManager = null;
      
      private var _funArr:Array = [];
      
      public function ServerManager(param1:Single)
      {
         super();
      }
      
      public static function get instance() : ServerManager
      {
         if(_instance == null)
         {
            _instance = new ServerManager(new Single());
         }
         return _instance;
      }
      
      private function conncetBTServer() : void
      {
         if(BattleServer.instance.isConnect)
         {
            _funArr[1][0](_funArr[1][2]);
            return;
         }
         GameServer.instance.getServerIDByType(1,function(param1:Object):void
         {
            var serData:ServerData;
            var data:Object = param1;
            Application.instance.log("BATTLE-SERVERIP",JSON.stringify(data));
            if(data.ret == 0)
            {
               serData = AllRoomData.instance.getDataByID(data.svid);
               BattleServer.instance.init(serData.ip,serData.port);
               BattleServer.instance.connect();
               BattleServer.instance.login(function(param1:Object):void
               {
                  Application.instance.log("BATTLE-CONNECT",JSON.stringify(data));
                  if(param1.ret == 1)
                  {
                     TextTip.instance.show(LangManager.t("longinBattleFail") + param1.data.errCode);
                     BattleServer.instance.close();
                     _funArr[1][1](param1);
                  }
                  else
                  {
                     _funArr[1][0](param1);
                     _funArr[1][2] = param1;
                  }
               });
            }
         });
      }
      
      public function connectServer(param1:int, param2:Function, param3:Function = null) : void
      {
         _funArr[param1] = [];
         _funArr[param1][0] = param2;
         _funArr[param1][1] = param3;
         switch(param1)
         {
            case 1:
               conncetBTServer();
               break;
            case 3:
            case 21:
            case 22:
         }
      }
      
      public function closeServer(param1:int) : void
      {
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
