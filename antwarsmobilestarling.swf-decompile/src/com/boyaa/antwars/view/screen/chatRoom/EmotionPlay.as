package com.boyaa.antwars.view.screen.chatRoom
{
   import flash.geom.Point;
   import starling.core.Starling;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   public class EmotionPlay
   {
      
      private static var _faceMC:MovieClip;
      
      public function EmotionPlay()
      {
         super();
      }
      
      public static function playFaceById(param1:int, param2:Point) : void
      {
         var _loc4_:int = 0;
         if(_faceMC && _faceMC.parent)
         {
            _faceMC.removeEventListener("complete",onPlayComplete);
            Starling.juggler.remove(_faceMC);
            _faceMC.removeFromParent(true);
         }
         var _loc5_:TextureAtlas = Assets.sAsset.getTextureAtlas("emoticon");
         var _loc3_:Vector.<Texture> = _loc5_.getTextures(param1 + "A00");
         _faceMC = new MovieClip(_loc3_,6);
         if(_loc3_.length <= 7)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _faceMC.addFrame(_loc3_[_loc4_]);
               _loc4_++;
            }
         }
         _faceMC.width = _faceMC.height = 124;
         _faceMC.x = param2.x;
         _faceMC.y = param2.y - _faceMC.height;
         _faceMC.loop = false;
         _faceMC.touchable = false;
         Starling.current.stage.addChild(_faceMC);
         Starling.juggler.add(_faceMC);
         _faceMC.play();
         _faceMC.addEventListener("complete",onPlayComplete);
      }
      
      private static function onPlayComplete(param1:Event) : void
      {
         var _loc2_:MovieClip = param1.target as MovieClip;
         if(_loc2_.isComplete)
         {
            Starling.juggler.remove(_loc2_);
            _loc2_.removeFromParent(true);
         }
      }
   }
}

