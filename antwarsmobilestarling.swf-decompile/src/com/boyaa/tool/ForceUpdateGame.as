package com.boyaa.tool
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class ForceUpdateGame
   {
      
      private var _lanArr:Array = [[],["提示","您当前的游戏版本不是最新版本，请下载新版本进行游戏！","确定","取消"],["Tips","Phiên bản hiện tại chưa phải bản mới nhất,hãy tải bản mới nhất về chơi!","Xác nhận","Hủy"],["Tips","Versi ini bukan terbaru, silakan update yg terbaru lagi!","ok","cancel"]];
      
      public function ForceUpdateGame()
      {
         super();
      }
      
      public function show() : void
      {
         Application.instance.systemAlert(_lanArr[Constants.lanVersion][0],_lanArr[Constants.lanVersion][1],[_lanArr[Constants.lanVersion][2],_lanArr[Constants.lanVersion][3]],[okFuncHandle,cancelFuncHandle]);
      }
      
      private function okFuncHandle() : void
      {
         var _loc1_:String = "";
         switch(Constants.lanVersion - 2)
         {
            case 0:
               if(Application.instance.isAndroid())
               {
                  _loc1_ = "http://appvn.com/android/details?id=air.com.boyaa.WARSAPPOTA";
                  break;
               }
               _loc1_ = "http://appvn.com/ios/tai-game-iphone/vuong-quoc-kien/28482";
               break;
            case 1:
               _loc1_ = "https://play.google.com/store/apps/details?id=air.com.boyaa.WARSFACEBOOKID";
         }
         navigateToURL(new URLRequest(_loc1_));
         Application.instance.application.exit();
      }
      
      private function cancelFuncHandle() : void
      {
         Application.instance.application.exit();
      }
   }
}

