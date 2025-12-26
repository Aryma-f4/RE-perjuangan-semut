package com.boyaa.antwars.view.screen.union.office
{
   import starling.utils.formatString;
   
   public class UnionLittleBaseManager
   {
      
      public static const APPLY_DLG:String = "APPLY_DLG";
      
      public static const APPLY_INFO_DLG:String = "APPLY_INFO_DLG";
      
      public static const DETAIL_DLG:String = "DETAIL_DLG";
      
      public static const DONATE_DLG:String = "DONATE_DLG";
      
      public static const STEP_DOWN:String = "STEP_DOWN";
      
      private static var _instance:UnionLittleBaseManager = null;
      
      private var _rawAssets:Array = [];
      
      private var rmger:ResManager = Application.instance.resManager;
      
      private var _curDlgStr:String = "";
      
      public function UnionLittleBaseManager(param1:Single)
      {
         super();
      }
      
      public static function get instance() : UnionLittleBaseManager
      {
         if(_instance == null)
         {
            _instance = new UnionLittleBaseManager(new Single());
         }
         return _instance;
      }
      
      private function loadAsset() : void
      {
         if(Assets.sAsset.getTextureAtlas("UnionOffice") != null)
         {
            show();
         }
         else
         {
            _rawAssets = [rmger.getResFile(formatString("asset/UnionOffice.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionOffice.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionOffice.xml",Assets.sAsset.scaleFactor))];
            Application.instance.currentGame.showLoading();
            Assets.sAsset.enqueue(_rawAssets);
            Assets.sAsset.loadQueue(loading);
         }
      }
      
      private function loading(param1:Number) : void
      {
         if(param1 == 1)
         {
            show();
         }
      }
      
      private function show() : void
      {
         var _loc1_:UnionManagerLittleBaseDlg = null;
         Application.instance.currentGame.hiddenLoading();
         switch(_curDlgStr)
         {
            case "APPLY_DLG":
            case "APPLY_INFO_DLG":
            case "DETAIL_DLG":
               break;
            case "DONATE_DLG":
               _loc1_ = new UnionManagerDonateDlg();
               break;
            case "STEP_DOWN":
         }
         _loc1_.active();
         Application.instance.currentGame.addChild(_loc1_);
      }
      
      public function showLittleDlg(param1:String) : void
      {
         _curDlgStr = param1;
         loadAsset();
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
