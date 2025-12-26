package com.boyaa.antwars.view.screen.friends
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendListItemRender;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import org.osflash.signals.Signal;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class SelectFriendView extends Sprite
   {
      
      private var _bg:Scale9Image;
      
      private var _friendList:List;
      
      private const SCREEN_NAME:String = "SelectFriendView";
      
      private var _textVec:Vector.<TextField>;
      
      private var _dlgMark:DlgMark;
      
      private var _signal:Signal;
      
      public function SelectFriendView()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         var _loc3_:int = 0;
         var _loc1_:TextField = null;
         _signal = new Signal(Object);
         _dlgMark = new DlgMark();
         _dlgMark.setTouchHandle(hide);
         _textVec = new Vector.<TextField>();
         _bg = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(20,20,32,32)),Assets.sAsset.scaleFactor);
         Assets.sAsset.positionDisplay(_bg,"SelectFriendView","bg");
         this.addChild(_bg);
         var _loc2_:Array = ["mid","nickName","level","marryState"];
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc1_ = new TextField(100,20,LangManager.t(_loc2_[_loc3_]),"Verdana",30,16777215);
            Assets.sAsset.positionDisplay(_loc1_,"SelectFriendView","title" + _loc3_);
            this.addChild(_loc1_);
            _textVec.push(_loc1_);
            _loc3_++;
         }
         _friendList = new List();
         _friendList.itemRendererType = FriendListItemRender;
         Assets.sAsset.positionDisplay(_friendList,"SelectFriendView","list");
         this.addChild(_friendList);
         _friendList.addEventListener("change",onSelectFriend);
      }
      
      private function onSelectFriend(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         _signal.dispatch(FriendData(_loc2_.selectedItem));
         hide();
      }
      
      public function show(param1:int = 0) : void
      {
         var type:int = param1;
         FriendsList.instance.resetMyFriendsList((function():*
         {
            var call:Function;
            return call = function():void
            {
               switch(type)
               {
                  case 0:
                     _friendList.dataProvider = new ListCollection(FriendsList.instance.getFriendListData());
                     break;
                  case 1:
                     _friendList.dataProvider = new ListCollection(FriendsList.instance.getNoMarryFriendListData());
               }
            };
         })());
         Application.instance.currentGame.addChild(_dlgMark);
         Application.instance.currentGame.addChild(this);
      }
      
      private function receiveData(param1:Object) : void
      {
         Application.instance.log("好友列表",JSON.stringify(param1));
         FriendsList.instance.addData(param1 as Array);
         _friendList.dataProvider = new ListCollection(FriendsList.instance.getFriendListData());
         FriendsList.instance.needLoad = false;
      }
      
      public function hide() : void
      {
         _dlgMark.removeFromParent();
         this.removeFromParent();
         _friendList.selectedIndex = -1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         _dlgMark.removeFromParent(true);
      }
      
      public function get signal() : Signal
      {
         return _signal;
      }
   }
}

