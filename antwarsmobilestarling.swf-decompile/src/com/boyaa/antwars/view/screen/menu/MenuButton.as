package com.boyaa.antwars.view.screen.menu
{
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import starling.display.Button;
   import starling.filters.ColorMatrixFilter;
   
   public class MenuButton extends FashionStarlingButton
   {
      
      private var _tipAni:TurnCircleAni;
      
      public function MenuButton(param1:Button)
      {
         super(param1);
         initTipAni();
      }
      
      private function initTipAni() : void
      {
         _tipAni = new TurnCircleAni(starlingBtn);
      }
      
      public function showTipAni(param1:Boolean) : void
      {
         if(param1)
         {
            _tipAni.show();
            _tipAni.ani.x = -11;
            _tipAni.ani.y = -16;
         }
         else
         {
            _tipAni.hide();
         }
      }
      
      public function showLight(param1:Boolean) : void
      {
         var _loc2_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc2_.adjustSaturation(0.3);
         _loc2_.adjustBrightness(0.3);
         if(param1)
         {
            this.starlingBtn.filter = _loc2_;
         }
         else
         {
            this.starlingBtn.filter = null;
         }
      }
   }
}

