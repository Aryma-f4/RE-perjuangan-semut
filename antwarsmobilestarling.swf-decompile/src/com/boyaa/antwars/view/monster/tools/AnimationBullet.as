package com.boyaa.antwars.view.monster.tools
{
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.game.ICharacter;
   import org.osflash.signals.Signal;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class AnimationBullet extends Sprite
   {
      
      protected var _iCharacter:ICharacter;
      
      protected var _movie:MovieClip;
      
      protected var _completeSignal:Signal;
      
      protected var _aniAltals:String = "地刺效果";
      
      protected var _soundStr:String = "sound 54";
      
      public function AnimationBullet(param1:ICharacter)
      {
         super();
         this._iCharacter = param1;
         _completeSignal = new Signal();
         initBullet();
         init();
      }
      
      protected function init() : void
      {
         _movie = new MovieClip(Assets.sAsset.getTextures(_aniAltals));
         _movie.pivotX = _movie.width >> 1;
         _movie.pivotY = _movie.height >> 1;
         _movie.x = _iCharacter.x;
         _movie.y = _iCharacter.y - _movie.height / 3;
         _movie.addEventListener("complete",onComplete);
         this.addChild(_movie);
      }
      
      public function start() : void
      {
         Starling.juggler.add(_movie);
         SoundManager.playSound(_soundStr);
         Starling.juggler.delayCall(function():void
         {
            _iCharacter.icharacterCtrl.playCry();
            _completeSignal.dispatch();
         },0.3);
      }
      
      private function onComplete(param1:Event) : void
      {
         if(Starling.juggler.contains(_movie))
         {
            Starling.juggler.remove(_movie);
         }
         _movie.removeFromParent(true);
      }
      
      public function get completeSignal() : Signal
      {
         return _completeSignal;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _movie.removeEventListener("complete",onComplete);
         completeSignal.removeAll();
      }
      
      protected function initBullet() : void
      {
      }
   }
}

