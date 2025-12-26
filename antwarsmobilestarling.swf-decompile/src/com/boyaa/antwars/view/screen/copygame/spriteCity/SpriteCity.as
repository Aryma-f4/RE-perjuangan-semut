package com.boyaa.antwars.view.screen.copygame.spriteCity
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.sound.SoundManager;
   import com.boyaa.antwars.view.screen.copygame.CityWorld;
   import com.boyaa.antwars.view.screen.copygame.LessPowerDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.utils.formatString;
   
   public class SpriteCity extends CityWorld
   {
      
      private const copyName:String = "spritecity";
      
      public function SpriteCity()
      {
         super();
         _screenArr[3] = "SPRITECITY";
      }
      
      override protected function loadAssets() : void
      {
         var resManager:ResManager;
         super.loadAssets();
         Application.instance.currentGame.showLoading();
         resManager = Application.instance.resManager;
         Assets.sAsset.enqueue(resManager.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.png",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.xml",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("textures/{0}x/COPYGAME/spritebg.png",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("textures/{0}x/COPYGAME/spritebg.xml",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("textures/{0}x/BT/btdlg.png",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("textures/{0}x/BT/btdlg.xml",Assets.sAsset.scaleFactor)),resManager.getResFile(formatString("asset/spritecity.info")));
         Assets.sAsset.loadQueue((function():*
         {
            var progress:Function;
            return progress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                     SoundManager.playBgSound("Music 5");
                  },0.15);
               }
            };
         })());
      }
      
      override protected function init() : void
      {
         currentCpWorld = 3;
         layoutUitl = new LayoutUitl(Assets.sAsset.getOther("spritecity"),Assets.sAsset);
         layoutUitl.buildLayout("spritecity",this);
         super.init();
         CopyServer.instance.close();
      }
      
      override protected function createLevel(param1:String = "normal") : void
      {
         var _loc2_:SpriteCityLevel = null;
         var _loc3_:int = 0;
         _loc3_ = 1;
         while(_loc3_ < 11)
         {
            _loc2_ = new SpriteCityLevel(param1);
            if(_optionsData.mode == "hero")
            {
               _loc2_.text = "2-" + _loc3_;
            }
            else
            {
               _loc2_.text = "1-" + _loc3_;
            }
            setPos(_loc2_ as DisplayObject,levelPosArr[_loc3_ - 1] as DisplayObject);
            levelArr.push(_loc2_);
            addChild(_loc2_);
            _loc2_.touchable = false;
            _loc2_.addEventListener("triggered",onEnterGameWorld);
            _loc3_++;
         }
         super.createLevel(param1);
      }
      
      override protected function consumEnergy(param1:Object) : void
      {
         var _loc2_:int = int(param1.data.userId);
         var _loc4_:int = int(param1.data.type);
         var _loc3_:int = int(param1.data.energy);
         if(_loc4_ == -1)
         {
            LessPowerDlg.show(this);
            return;
         }
         energyBar.decreaseEnergy(_decreaseEnergy);
         PlayerDataList.instance.selfData.energy -= _decreaseEnergy;
         CopyList.instance.currentCopyData = CopyList.instance.getCopyData(currentCpWorld,_currentCopyArr[0],_currentCopyArr[1]);
         this.dispatchEventWith("gameStart");
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeTextureAtlas("copygameui");
         Assets.sAsset.removeTextureAtlas("btdlg");
         Assets.sAsset.removeTextureAtlas("spritebg");
      }
   }
}

