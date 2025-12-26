package com.boyaa.antwars.view.screen.copygame
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.game.GameWorld;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.vipSystem.VipManager;
   import org.osflash.signals.Signal;
   
   public class ReliveControl
   {
      
      public static const RELIVE_BOYAA_COIN:int = 5;
      
      private static var _instance:ReliveControl = null;
      
      private var _reliveSignal:Signal;
      
      private var _gameWorld:GameWorld;
      
      public function ReliveControl(param1:Single)
      {
         super();
         _reliveSignal = new Signal(Array);
      }
      
      public static function get instance() : ReliveControl
      {
         if(_instance == null)
         {
            _instance = new ReliveControl(new Single());
         }
         return _instance;
      }
      
      public function setGameWorld(param1:GameWorld) : void
      {
         _gameWorld = param1;
      }
      
      public function showReliveDlg() : void
      {
         var money:int;
         var langStr:String;
         ReliveControl.instance.reliveSignal.dispatch(["pause"]);
         money = (_gameWorld.playerReliveCount + 1) * 5;
         langStr = LangManager.getLang.getreplaceLang("reliveTip",money);
         if(VipManager.instance.vipPowerData.copyReliveTime > 0)
         {
            langStr = LangManager.getLang.getreplaceLang("vipReliveCopyTip",VipManager.instance.vipPowerData.copyReliveTime);
         }
         SystemTip.instance.showSystemAlert(langStr,(function():*
         {
            var yes:Function;
            return yes = function():void
            {
               ReliveControl.instance.reliveSignal.dispatch(["yes",money]);
            };
         })(),(function():*
         {
            var no:Function;
            return no = function():void
            {
               ReliveControl.instance.reliveSignal.dispatch(["no"]);
            };
         })());
      }
      
      public function removeSignalFunc(param1:Function) : void
      {
         reliveSignal.remove(param1);
      }
      
      public function addSignalFunc(param1:Function, param2:Boolean = true) : void
      {
         if(param2)
         {
            reliveSignal.addOnce(param1);
         }
         else
         {
            reliveSignal.add(param1);
         }
      }
      
      public function get reliveSignal() : Signal
      {
         return _reliveSignal;
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
