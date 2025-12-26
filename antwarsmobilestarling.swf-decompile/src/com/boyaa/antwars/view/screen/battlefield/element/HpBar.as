package com.boyaa.antwars.view.screen.battlefield.element
{
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class HpBar extends Sprite
   {
      
      private var _hp:int;
      
      private var bgImage:Image;
      
      private var _bloodImage:Image;
      
      private var quad:Quad;
      
      private var allhp:int;
      
      private var color:uint;
      
      private var hpNumber:HPNumberView;
      
      private var showNumber:Boolean;
      
      private var _bloodName:String = "dz51";
      
      public function HpBar(param1:Texture, param2:uint, param3:int, param4:Boolean = false)
      {
         super();
         this.addEventListener("addedToStage",onAddedToStage);
         bgImage = new Image(param1);
         this.allhp = param3;
         this.color = param2;
         this.showNumber = param4;
         if(param2 == 16776960)
         {
            _bloodName = "dz52";
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         var _loc2_:Number = bgImage.height * 0.1;
         addChild(bgImage);
         quad = new Quad(bgImage.width - 2 * _loc2_,bgImage.height - 2 * _loc2_,15658734);
         quad.setVertexColor(2,this.color);
         quad.setVertexColor(3,this.color);
         quad.x = _loc2_;
         quad.y = _loc2_;
         quad.scaleX = 0;
         _bloodImage = new Image(Assets.sAsset.getTexture(_bloodName));
         _bloodImage.width = bgImage.width - 2 * _loc2_;
         _bloodImage.height = bgImage.height - 2 * _loc2_;
         addChild(_bloodImage);
         if(showNumber)
         {
            hpNumber = new HPNumberView(95,30);
            hpNumber.scaleX = hpNumber.scaleY = 0.8;
            hpNumber.y = quad.y + quad.height;
            hpNumber.x = bgImage.width - hpNumber.width >> 1;
            addChild(hpNumber);
         }
         this.hp = allhp;
      }
      
      public function set hp(param1:int) : void
      {
         _hp = param1;
         this.quad.scaleX = Math.max(0,Math.min(1,_hp / allhp));
         _bloodImage.scaleX = Math.max(0,Math.min(1,_hp / allhp));
         if(showNumber)
         {
            hpNumber.number = Math.ceil(this.quad.scaleX * 100);
         }
      }
      
      public function get hp() : int
      {
         return _hp;
      }
      
      public function setAllhp(param1:int) : void
      {
         allhp = param1;
      }
   }
}

