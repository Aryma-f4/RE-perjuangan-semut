package com.boyaa.antwars.view.screen.fresh.guideControl
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.mission.SubMissionData;
   
   public class JumpSceneInGuide
   {
      
      private var _copyMissionArr:Array = ["SKYCITY","SPIDERCITY","SPRITECITY"];
      
      public function JumpSceneInGuide()
      {
         super();
      }
      
      public function jump() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = MissionGuideValue.instance.getMissionFlag();
         var _loc4_:SubMissionData = MissionGuideValue.instance.getUnCompleteSubMissions();
         var _loc3_:String = Application.instance.currentGame.navigator.activeScreenID;
         if(_loc3_ == "HALL")
         {
            return;
         }
         switch(_loc2_)
         {
            case "copyMission":
               _loc1_ = _loc4_.pframe / 10;
               if(_loc3_ != _copyMissionArr[_loc1_ / 2])
               {
                  showScreen("COPYGAME");
               }
               if(_loc1_ % 2 == 0)
               {
                  if("normal" != Application.instance.currentGame._copyModeOptionsData.mode)
                  {
                     showScreen("COPYGAME");
                  }
                  break;
               }
               if("hero" != Application.instance.currentGame._copyModeOptionsData.mode)
               {
                  showScreen("COPYGAME");
               }
               break;
            case "fight1v1Mission":
               if(_loc3_ == "BTROOM")
               {
                  if(!PlayerDataList.instance.pk_type == 0)
                  {
                     showScreen("HALL");
                  }
                  break;
               }
               showScreen("HALL");
               break;
            case "fight2v2Mission":
               if(_loc3_ == "BTROOM")
               {
                  if(!PlayerDataList.instance.pk_type == 1)
                  {
                     showScreen("HALL");
                  }
                  break;
               }
               showScreen("HALL");
               break;
            default:
               showScreen("HALL");
         }
      }
      
      private function showScreen(param1:String) : void
      {
         Application.instance.currentGame.navigator.showScreen(param1);
      }
   }
}

