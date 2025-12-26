package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.data.CopyList;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.model.CopyDetailData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.battlefield.BtSeekRoomDlg;
   import feathers.controls.List;
   import feathers.controls.Screen;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class TeamList extends Screen
   {
      
      private var closeBtn:Button;
      
      private var btnQuickPlay:Button;
      
      private var btnCreateTeam:Button;
      
      private var btnFindRoom:Button;
      
      private var btnRefresh:Button;
      
      private var list:List;
      
      private var listData:ListCollection;
      
      private var tipSprite:Sprite;
      
      private var _sceneArr:Dictionary;
      
      public function TeamList()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         loadAssets();
         this.addEventListener("addedToStage",onAddedToStage);
      }
      
      protected function loadAssets() : void
      {
         var rmger:ResManager;
         Application.instance.currentGame.showLoading();
         rmger = Application.instance.resManager;
         Assets.sAsset.enqueue(rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/COPYGAME/copygameui.xml",Assets.sAsset.scaleFactor)));
         Assets.sAsset.loadQueue((function():*
         {
            var onProgress:Function;
            return onProgress = function(param1:Number):void
            {
               var ratio:Number = param1;
               if(ratio == 1)
               {
                  Starling.juggler.delayCall(function():void
                  {
                     init();
                     Application.instance.currentGame.hiddenLoading();
                  },0.15);
               }
            };
         })());
      }
      
      protected function init() : void
      {
         var top:Image;
         var bottom:Image;
         var title:Image;
         var frame:Scale9Image;
         var quad:Quad;
         var top1:Image;
         var rect:Rectangle;
         var txt:TextField;
         var bg:Image = new Image(Assets.sAsset.getTexture("bb_bg"));
         Assets.positionDisplay(bg,"missionDlg","bg1");
         addChild(bg);
         top = new Image(Assets.sAsset.getTexture("55"));
         Assets.positionDisplay(top,"missionDlg","topbar");
         addChild(top);
         bottom = new Image(Assets.sAsset.getTexture("bb46"));
         Assets.positionDisplay(bottom,"missionDlg","bottomBar");
         addChild(bottom);
         title = new Image(Assets.sAsset.getTexture("image_title"));
         Assets.positionDisplay(title,"teamList","title");
         addChild(title);
         closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         Assets.sAsset.positionDisplay(closeBtn,"teamList","btn_close");
         closeBtn.addEventListener("triggered",onCloseBtn);
         addChild(closeBtn);
         frame = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("talk2"),new Rectangle(26,26,37,37)));
         Assets.sAsset.positionDisplay(frame,"teamList","frame");
         quad = new Quad(frame.width - 10,frame.height - 10,4269333);
         quad.x = frame.x + 5;
         quad.y = frame.y + 5;
         addChild(quad);
         addChild(frame);
         top1 = new Image(Assets.sAsset.getTexture("image_titleBar"));
         Assets.positionDisplay(top1,"teamList","title_bar");
         addChild(top1);
         list = new List();
         listData = new ListCollection();
         list.dataProvider = listData;
         list.itemRendererType = TeamListItemRender;
         Assets.positionDisplay(list,"teamList","item");
         list.addEventListener("change",onListChangeHandler);
         addChild(list);
         tipSprite = new Sprite();
         rect = Assets.getPosition("teamList","text");
         txt = new TextField(rect.width,rect.height,LangManager.t("upLoad"),"Verdana",24,16777215);
         txt.x = rect.x;
         txt.y = rect.y;
         txt.autoScale = true;
         tipSprite.addChild(txt);
         tipSprite.visible = false;
         btnQuickPlay = new Button(Assets.sAsset.getTexture("btnS_quickPlay1"),"",Assets.sAsset.getTexture("btnS_quickPlay2"));
         Assets.sAsset.positionDisplay(btnQuickPlay,"teamList","btn_quickPlay");
         btnQuickPlay.addEventListener("triggered",onQuickPlay);
         addChild(btnQuickPlay);
         btnCreateTeam = new Button(Assets.sAsset.getTexture("btnS_creatTeam1"),"",Assets.sAsset.getTexture("btnS_creatTeam2"));
         Assets.sAsset.positionDisplay(btnCreateTeam,"teamList","btnS_creatTeam");
         btnCreateTeam.addEventListener("triggered",onCreateRomm);
         addChild(btnCreateTeam);
         btnFindRoom = new Button(Assets.sAsset.getTexture("btnS_findRoom1"),"",Assets.sAsset.getTexture("btnS_findRoom2"));
         Assets.sAsset.positionDisplay(btnFindRoom,"teamList","btnS_findRoom");
         btnFindRoom.addEventListener("triggered",onFindRoom);
         addChild(btnFindRoom);
         btnRefresh = new Button(Assets.sAsset.getTexture("refresh0"),"",Assets.sAsset.getTexture("refresh1"));
         Assets.positionDisplay(btnRefresh,"teamList","btnRefresh");
         btnRefresh.addEventListener("triggered",onRefresh);
         addChild(btnRefresh);
         this.stage.addEventListener("touch",onTouch);
         addChild(tipSprite);
         showList();
         this.x = 190;
         Remoting.instance.backBTProp([],function(param1:Object):void
         {
            if(param1.ret == 0)
            {
               GoodsList.instance.payPorpIdArr = param1.props.split("|");
            }
         });
      }
      
      private function showList() : void
      {
         tipSprite.visible = true;
         RoomListData.instance.list.length = 0;
         PlayerDataList.instance.removePlayers();
         var _loc1_:CopyDetailData = CopyList.instance.currentCopyData;
         CopyServer.instance.showRoomList(_loc1_.cpdtlid,showListCallback);
      }
      
      private function showListCallback(param1:Object) : void
      {
         listData.data = RoomListData.instance.list.concat();
         list.dataProvider = listData;
         tipSprite.visible = false;
      }
      
      private function onJoinRoom(param1:Object = null) : void
      {
         trace("点击列表进入房间回调：" + JSON.stringify(param1));
         if(param1.data.flag == 0)
         {
            TextTip.instance.showByLang("teamList2");
         }
         else
         {
            enterRoom(param1);
         }
      }
      
      private function onCreateTeamCallback(param1:Object = null) : void
      {
         trace("创建队伍回调" + JSON.stringify(param1));
         enterRoom(param1);
      }
      
      private function onQuickPlayCallback(param1:Object) : void
      {
         trace("快速游戏回调：" + JSON.stringify(param1));
         if(param1.data.flag == 0)
         {
            TextTip.instance.showByLang("teamList4");
         }
         else
         {
            Application.instance.currentGame._copyModeOptionsData.roomId = param1.data.roomId;
            Application.instance.currentGame.navigator.showScreen("TEAMROOM");
         }
      }
      
      public function enterRoom(param1:Object = null) : void
      {
         var _loc4_:String = param1.data.roomId;
         var _loc3_:String = param1.data.roomName;
         _loc3_ = getCopyName();
         var _loc2_:int = int(param1.data.diff);
         Application.instance.currentGame._copyModeOptionsData.teamRoomId = _loc4_;
         Application.instance.currentGame._copyModeOptionsData.teamRoomName = _loc3_;
         Application.instance.currentGame._copyModeOptionsData.diff = _loc2_;
         Application.instance.currentGame._copyModeOptionsData.retData = param1;
         PlayerDataList.instance.copyGameAddRoomPlayers(param1);
         dispatchEventWith("enterTeamRoom");
      }
      
      private function getCopyName() : String
      {
         var _loc2_:int = CopyList.instance.currentCopyData.cpid;
         var _loc1_:String = "fight";
         switch(_loc2_ - 2)
         {
            case 0:
               _loc1_ = LangManager.t("spidercity");
               break;
            case 1:
               _loc1_ = LangManager.t("spritecity");
         }
         return _loc1_;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         var event:Event = param1;
         list.visible = false;
         this.pivotX = 539;
         this.pivotY = 384;
         this.x = 560;
         this.y = 384;
         this.scaleX = this.scaleY = 0;
         Starling.juggler.tween(this,0.5,{
            "scaleX":1,
            "scaleY":1,
            "transition":"easeInOut",
            "onComplete":function():void
            {
               list.visible = true;
            }
         });
      }
      
      private function onListChangeHandler(param1:Event) : void
      {
         var _loc3_:List = List(param1.currentTarget);
         trace("list.selectedIndex" + _loc3_.selectedIndex);
         if(_loc3_.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:RoomData = _loc3_.selectedItem as RoomData;
         if(_loc2_.roomState == 1)
         {
            TextTip.instance.showByLang("teamList0");
         }
         else if(_loc2_.num == _loc2_.totalNum)
         {
            TextTip.instance.showByLang("teamList0");
         }
         else
         {
            Application.instance.currentGame._copyModeOptionsData.roomId = _loc2_.roomId;
            Application.instance.currentGame.navigator.showScreen("TEAMROOM");
         }
         _loc3_.selectedIndex = -1;
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:Point = null;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc4_ = param1.getTouches(list);
            if(_loc4_.length > 0 && _loc4_[0].phase == "began")
            {
               _loc3_ = list.globalToLocal(new Point(_loc4_[0].globalX,_loc4_[0].globalY));
               trace(_loc3_.y,_loc3_.x);
               if(_loc3_.x > 754)
               {
                  _loc3_.x = 754;
               }
               if(_loc3_.y > 320)
               {
                  _loc3_.x = 320;
               }
            }
         }
      }
      
      private function onQuickPlay(param1:Event) : void
      {
         CopyServer.instance.quickMatch(onQuickPlayCallback,CopyList.instance.currentCopyData.cpdtlid);
      }
      
      private function onCreateRomm(param1:Event) : void
      {
         var _loc2_:CopyDetailData = CopyList.instance.currentCopyData;
         CopyServer.instance.createRoom(_loc2_.cpdtlid,onCreateTeamCallback);
         PlayerDataList.instance.selfData.houseOwner = 1;
         Application.instance.currentGame._copyModeOptionsData.createBtn = 1;
      }
      
      private function onFindRoom(param1:Event) : void
      {
         var _loc2_:BtSeekRoomDlg = new BtSeekRoomDlg();
         addChild(_loc2_);
      }
      
      private function onRefresh(param1:Event) : void
      {
         tipSprite.visible = true;
         showList();
      }
      
      private function onCloseBtn(param1:Event) : void
      {
         _sceneArr = new Dictionary();
         _sceneArr[1] = "complete";
         _sceneArr[2] = "showSpiderCity";
         _sceneArr[3] = "showSpriteCity";
         var _loc2_:int = CopyList.instance.currentCopyData.cpid;
         Starling.juggler.tween(this,0.3,{
            "scaleX":0,
            "scaleY":0,
            "transition":"easeIn",
            "onComplete":cleanUp
         });
         RoomListData.instance.list.length = 0;
         dispatchEventWith(_sceneArr[_loc2_]);
      }
      
      private function cleanUp() : void
      {
         list.removeEventListener("change",onListChangeHandler);
         btnQuickPlay.removeEventListener("triggered",onQuickPlay);
         btnCreateTeam.removeEventListener("triggered",onCreateRomm);
         btnFindRoom.removeEventListener("triggered",onFindRoom);
         closeBtn.removeEventListener("triggered",onCloseBtn);
         if(this.stage)
         {
            this.stage.removeEventListener("touch",onTouch);
         }
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         cleanUp();
      }
   }
}

