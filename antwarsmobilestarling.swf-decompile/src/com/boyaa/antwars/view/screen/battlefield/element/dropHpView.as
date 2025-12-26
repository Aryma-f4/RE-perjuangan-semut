package com.boyaa.antwars.view.screen.battlefield.element
{
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class dropHpView extends Sprite
   {
      
      private var textureAtlas:ResAssetManager;
      
      private var snumber:StaticNumerView;
      
      private var _startPoint:Point;
      
      private var _hitHp:int;
      
      private var _isBomb:Boolean;
      
      public function dropHpView(param1:Point, param2:int, param3:Boolean = false)
      {
         super();
         textureAtlas = Assets.sAsset;
         _startPoint = param1;
         _hitHp = param2;
         _isBomb = param3;
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var bg:Image;
         var event:Event = param1;
         this.removeEventListener("addedToStage",onAddedToStage);
         bg = new Image(textureAtlas.getTexture("dropHpbg"));
         addChild(bg);
         snumber = new StaticNumerView("num",_hitHp,_hitHp > 0 ? "-" : "+");
         trace("snumber.width:",snumber.width);
         trace("bg.width:",bg.width);
         snumber.x = bg.width - snumber.width >> 1;
         snumber.y = bg.height - snumber.height >> 1;
         addChild(snumber);
         this.pivotX = this.width >> 1;
         this.pivotY = this.height >> 1;
         this.x = _startPoint.x;
         this.y = _startPoint.y;
         bg.visible = _isBomb;
         Starling.juggler.tween(this,2,{
            "alpha":0,
            "y":_startPoint.y - 50,
            "onComplete":function():void
            {
               removeFromParent(true);
            }
         });
      }
   }
}

