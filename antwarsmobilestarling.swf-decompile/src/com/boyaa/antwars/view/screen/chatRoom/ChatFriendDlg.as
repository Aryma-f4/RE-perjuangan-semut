package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.forge.UIExportSprite;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import org.osflash.signals.Signal;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class ChatFriendDlg extends UIExportSprite
   {
      
      private var list:List;
      
      private var friendList:ListCollection;
      
      public var friendSignal:Signal;
      
      private var markBg:DlgMark;
      
      protected var _asset:ResAssetManager;
      
      protected var _rawAssets:Array = [];
      
      protected var rmger:ResManager;
      
      public function ChatFriendDlg()
      {
         super();
         friendSignal = new Signal();
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         _asset = Assets.sAsset;
         _asset.enqueue(getRawAssets());
         _asset.loadQueue(loadAssetDone);
      }
      
      protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            Application.instance.currentGame.hiddenLoading();
            showMark();
            buildLayout("chatFriends","ChatFriendDlg");
            SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
            _displayObj.x -= 350;
            _displayObj.y -= 50;
            initFace();
         }
      }
      
      override protected function showMark() : void
      {
         _mask = new DlgMark();
         this.addChildAt(_mask,0);
         _mask.x -= 150;
      }
      
      protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/chatFriends.info")),rmger.getResFile(formatString("textures/{0}x/OTHER/chatFriends.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/OTHER/chatFriends.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      private function initFace() : void
      {
         addCloseButtonEvent();
         friendList = new ListCollection();
         list = new List();
         if(FriendsList.instance.needLoad)
         {
            Remoting.instance.getFirends(1,receiveData);
         }
         else
         {
            friendList.data = FriendsList.instance.getFriendListData();
         }
         list.dataProvider = friendList;
         list.itemRendererType = ChatFriendsItem;
         list.addEventListener("change",listChangeHandler);
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjectByName("pos_list"),list);
         _displayObj.addChild(list);
      }
      
      public function receiveData(param1:Object) : void
      {
         Application.instance.log("好友列表",JSON.stringify(param1));
         FriendsList.instance.addData(param1 as Array);
         friendList.data = FriendsList.instance.getFriendListData();
         FriendsList.instance.needLoad = false;
      }
      
      private function listChangeHandler(param1:Event) : void
      {
         var _loc3_:List = List(param1.currentTarget);
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:String = (_loc3_.selectedItem as FriendData).nickName;
         var _loc4_:int = (_loc3_.selectedItem as FriendData).antId;
         friendSignal.dispatch(_loc2_,_loc4_);
         clear();
      }
      
      override protected function onCloseHandle(param1:Event) : void
      {
         clear();
      }
      
      private function clear() : void
      {
         friendSignal.removeAll();
         removeFromParent(true);
      }
   }
}

