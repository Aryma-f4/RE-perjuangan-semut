package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.view.BaseDlg;
   
   public class UnionCoreDlg extends BaseDlg
   {
      
      protected var _asset:ResAssetManager;
      
      protected var _rawAssets:Array = [];
      
      protected var rmger:ResManager = Application.instance.resManager;
      
      public function UnionCoreDlg()
      {
         super(true);
         _asset = Assets.sAsset;
         Application.instance.currentGame.showLoading();
         var _loc1_:ResManager = Application.instance.resManager;
         _asset.enqueue(getRawAssets());
         _asset.loadQueue(loadAssetDone);
      }
      
      protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            active();
         }
      }
      
      protected function getRawAssets() : Array
      {
         throw new Error("子类实现");
      }
   }
}

