package com.boyaa.antwars.view.screen.menu
{
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.DisplayObjectContainer;
   import starling.display.MovieClip;
   
   public class TurnCircleAni
   {
      
      private var _target:DisplayObjectContainer;
      
      private var _ani:MovieClip;
      
      public function TurnCircleAni(param1:DisplayObjectContainer)
      {
         super();
         _target = param1;
         initMovieClip();
      }
      
      private function initMovieClip() : void
      {
         _ani = new MovieClip(Assets.sAsset.getTextures("start200"));
         _ani.touchable = false;
         _ani.visible = false;
      }
      
      public function show(param1:Number = 1.3, param2:Point = null) : void
      {
         _ani.scaleY = _ani.scaleX = param1;
         _ani.visible = true;
         if(param2)
         {
            _ani.x = param2.x;
            _ani.y = param2.y;
         }
         else
         {
            _ani.x = 0;
            _ani.y = 0;
         }
         Starling.juggler.add(_ani);
         _target.addChild(_ani);
      }
      
      public function hide() : void
      {
         _ani.visible = false;
         _ani.removeFromParent();
         Starling.juggler.remove(_ani);
      }
      
      public function get ani() : MovieClip
      {
         return _ani;
      }
   }
}

