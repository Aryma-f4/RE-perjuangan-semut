package com.boyaa.antwars.view.screen.battlefield.element
{
   import com.boyaa.antwars.view.character.Character;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class CharBox extends Sprite
   {
      
      public static var aboutMeSignal:Signal = new Signal();
      
      public var siteID:int;
      
      private var char:Character;
      
      private var textureAtlas:ResAssetManager;
      
      private var charbox:Image;
      
      private var hpBar:HpBar;
      
      public var team:int = 1;
      
      public function CharBox(param1:int, param2:int, param3:Character, param4:int)
      {
         super();
         textureAtlas = Assets.sAsset;
         this.char = param3;
         this.siteID = param1;
         this.team = param2;
         trace("siteID:",param1,"  team:",param2);
         hpBar = new HpBar(textureAtlas.getTexture("dz59"),108487,param4,true);
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener("addedToStage",onAddedToStage);
         charbox = new Image(textureAtlas.getTexture("charbox0"));
         var _loc2_:Rectangle = Assets.getPosition("bfUILayer","charbox1");
         charbox.width = _loc2_.width;
         charbox.height = _loc2_.height;
         addChild(charbox);
         addChild(hpBar);
         hpBar.y = charbox.height;
         hpBar.x = (charbox.width - hpBar.width) / 2;
         var _loc3_:Character = char.avatar();
         _loc3_.y = 115;
         _loc3_.x = 40;
         if(team == 1)
         {
            _loc3_.scaleX *= -1;
            _loc3_.x += 5;
         }
         addChild(_loc3_);
         addEventListener("touch",onTouchHeadImg);
      }
      
      private function onTouchHeadImg(param1:TouchEvent) : void
      {
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            aboutMeSignal.dispatch(siteID);
         }
      }
      
      public function updateHp(param1:int) : void
      {
         hpBar.hp = param1;
      }
      
      public function select() : void
      {
         charbox.texture = textureAtlas.getTexture("charbox1");
      }
      
      public function unselect() : void
      {
         charbox.texture = textureAtlas.getTexture("charbox0");
      }
   }
}

