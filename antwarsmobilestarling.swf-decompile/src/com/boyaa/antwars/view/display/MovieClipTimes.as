package com.boyaa.antwars.view.display
{
   import org.osflash.signals.Signal;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.Texture;
   
   public class MovieClipTimes extends MovieClip
   {
      
      private var mTimes:int = 0;
      
      private var queue:Vector.<int>;
      
      public var playCompleteSignal:Signal;
      
      public function MovieClipTimes(param1:Vector.<Texture>, param2:Number = 12)
      {
         super(param1,param2);
         queue = new Vector.<int>();
         loop = true;
         stop();
         playCompleteSignal = new Signal(int);
         this.addEventListener("complete",onComplete);
      }
      
      public function pushPlay(param1:int) : void
      {
         queue.push(param1);
         mTimes = mTimes + 1;
         play();
      }
      
      private function onComplete(param1:Event) : void
      {
         playCompleteSignal.dispatch(queue.shift());
         mTimes = mTimes - 1;
         if(mTimes <= 0)
         {
            stop();
            removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         playCompleteSignal.removeAll();
         this.removeEventListener("complete",onComplete);
         super.dispose();
      }
   }
}

