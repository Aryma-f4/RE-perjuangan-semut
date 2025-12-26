package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.net.server.GameServer;
   
   public class MailTipsControl
   {
      
      private static var _instance:MailTipsControl = null;
      
      public function MailTipsControl()
      {
         super();
      }
      
      public static function get instance() : MailTipsControl
      {
         if(_instance == null)
         {
            _instance = new MailTipsControl();
         }
         return _instance;
      }
      
      public function setMailHighLight(param1:Boolean) : void
      {
         Application.instance.currentGame.mainMenu.mailBtnHighLight(param1);
      }
      
      public function showTip() : void
      {
         GameServer.instance.getMailList(onGetMainList);
      }
      
      private function onGetMainList(param1:Object) : void
      {
         var _loc2_:Array = null;
         try
         {
            _loc2_ = param1 as Array;
            if(_loc2_.length != 0)
            {
               Application.instance.currentGame.mainMenu.mailBtnHighLight(true);
            }
            else
            {
               Application.instance.currentGame.mainMenu.mailBtnHighLight(false);
            }
         }
         catch(err:Error)
         {
            trace(err.getStackTrace());
         }
      }
   }
}

