package com.boyaa.antwars.view.screen.copygame.spiderCity
{
   import com.boyaa.antwars.view.screen.copygame.CityWorldLevel;
   
   public class spiderCityLevel extends CityWorldLevel
   {
      
      public function spiderCityLevel(param1:String = "normal")
      {
         setup();
         super(param1);
      }
      
      override protected function changeHeroAndNormalPos() : void
      {
         if(currentMode == "normal")
         {
            changePos(btnNormal,5,50,17,2);
         }
         else
         {
            changePos(btnHero,5,50,17,2);
         }
         lockImg.x += 3;
         lockImg.y -= 40;
      }
      
      private function setup() : void
      {
         textureArr = ["fb10","fb11","fb110","fb111","fb47","fb48","锁头"];
      }
   }
}

