package com.boyaa.antwars.view.screen.wedding
{
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import org.osflash.signals.Signal;
   import starling.utils.formatString;
   
   public class WeddingAniManager
   {
      
      public static const WEDDING_ANI_COMPLETE:String = "weddingAniComplete";
      
      public static const WEDDING_OPEN_ANI_DONE:String = "openAniDone";
      
      private static var _instance:WeddingAniManager = null;
      
      private var _ani:WeddingAni;
      
      private var _type:int;
      
      private var _isLoadAsset:Boolean = false;
      
      private var _aniSignal:Signal;
      
      private var _dlgMark:DlgMark;
      
      public function WeddingAniManager(param1:Single)
      {
         super();
         init();
      }
      
      public static function get instance() : WeddingAniManager
      {
         if(_instance == null)
         {
            _instance = new WeddingAniManager(new Single());
         }
         return _instance;
      }
      
      private function init() : void
      {
         _aniSignal = new Signal(String);
         _aniSignal.add((function():*
         {
            var hide:Function;
            return hide = function(param1:String):void
            {
               if(param1 == "weddingAniComplete")
               {
                  _dlgMark && _dlgMark.removeFromParent(true);
               }
            };
         })());
      }
      
      private function loadAsset() : void
      {
         if(_isLoadAsset)
         {
            loadComplete(1);
            return;
         }
         var _loc1_:ResManager = Application.instance.resManager;
         Assets.sAsset.enqueue(_loc1_.getResFile(formatString("textures/{0}x/OTHER/jh1.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/jh2.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/jh3.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/weddingBegin.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/jhman1.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/jhman2.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/jhman3.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/firework.png",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/firework.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/skeleton_firework.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/weddingOpen.png"
         ,Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/weddingOpen.xml",Assets.sAsset.scaleFactor)),_loc1_.getResFile(formatString("textures/{0}x/OTHER/skeleton_weddingOpen.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue(loadComplete);
      }
      
      private function loadComplete(param1:Number) : void
      {
         if(param1 == 1)
         {
            _isLoadAsset = true;
            _ani.show(_type);
            SoundManager.stopBgSound();
         }
      }
      
      public function showWeddingByType(param1:int) : void
      {
         if(_ani)
         {
            _ani.hide();
            _ani = null;
         }
         _dlgMark = new DlgMark();
         Application.instance.currentGame.addChild(_dlgMark);
         _ani = new WeddingAni();
         _type = param1;
         loadAsset();
      }
      
      public function hideWedding() : void
      {
         _ani && _ani.hide();
         _dlgMark && _dlgMark.removeFromParent(true);
      }
      
      public function disposeAsset() : void
      {
         Assets.sAsset.removeTexture("jh1");
         Assets.sAsset.removeTexture("jh2");
         Assets.sAsset.removeTexture("jh3");
         Assets.sAsset.removeTexture("weddingBegin");
         Assets.sAsset.removeSkeletonsAndBoneAtlases("firework");
         Assets.sAsset.removeSkeletonsAndBoneAtlases("weddingOpen");
         _isLoadAsset = false;
      }
      
      public function get aniSignal() : Signal
      {
         return _aniSignal;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
