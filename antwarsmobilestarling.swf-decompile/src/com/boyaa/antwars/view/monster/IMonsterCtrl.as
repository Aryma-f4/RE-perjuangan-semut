package com.boyaa.antwars.view.monster
{
   import org.osflash.signals.Signal;
   
   public interface IMonsterCtrl
   {
      
      function attackAction() : void;
      
      function get actionCompleteSignal() : Signal;
   }
}

