package com.boyaa.antwars.view.screen.copygame.spriteCity
{
   import com.boyaa.antwars.view.screen.copygame.CityWorldLevel;
   
   public class SpriteCityLevel extends CityWorldLevel
   {
      
      public function SpriteCityLevel(param1:String = "normal")
      {
         setup();
         super(param1);
      }
      
      override protected function changeHeroAndNormalPos() : void
      {
         if(currentMode == "normal")
         {
            changePos(btnNormal,5,13,17,2);
         }
         else
         {
            changePos(btnHero,5,13,17,2);
         }
         lockImg.x += 3;
         lockImg.y -= 40;
      }
      
      private function setup() : void
      {
         textureArr = ["fb10","fb11","fb8","fb9","fb49","fb50","锁头"];
      }
   }
}

