package com.boyaa.antwars.view.screen.rankList
{
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.net.Remoting;
   import flash.utils.Dictionary;
   
   public class RankListPlayerPictures
   {
      
      private static var _instance:RankListPlayerPictures = null;
      
      private var _playerImageUrls:Dictionary = new Dictionary();
      
      private var _callBack:Function;
      
      public function RankListPlayerPictures(param1:Single)
      {
         super();
      }
      
      public static function get instance() : RankListPlayerPictures
      {
         if(_instance == null)
         {
            _instance = new RankListPlayerPictures(new Single());
         }
         return _instance;
      }
      
      public function loadPic(param1:Array, param2:Function = null) : void
      {
         param1.push(PlayerDataList.instance.selfData.uid);
         _callBack = param2;
         Remoting.instance.onFaceBookImgUrl(param1,loadComplete);
      }
      
      private function loadComplete(param1:Object) : void
      {
         trace("loadPic:",JSON.stringify(param1));
         for(var _loc2_ in param1.data)
         {
            _playerImageUrls[_loc2_] = param1.data[_loc2_];
         }
         if(_callBack != null)
         {
            _callBack.call();
         }
      }
      
      public function getPlayerFaceBookImageUrlByUID(param1:int) : String
      {
         return _playerImageUrls[param1];
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
