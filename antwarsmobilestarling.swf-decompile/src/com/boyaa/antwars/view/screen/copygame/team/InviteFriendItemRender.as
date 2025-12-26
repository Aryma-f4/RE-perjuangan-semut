package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.data.AllRoomData;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.BattleServer;
   import com.boyaa.antwars.net.server.CopyServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import starling.display.Button;
   import starling.display.Image;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class InviteFriendItemRender extends ListItemRenderer
   {
      
      private static var stateArr:Array = LangManager.getLang.getLangArray("marryStateArr");
      
      private var textNickName:TextField;
      
      private var textLevel:TextField;
      
      private var btnInvite:Button;
      
      private var imgInvited:Image;
      
      private var _antID:int = 0;
      
      public function InviteFriendItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            this.bgFocusTexture = Assets.sAsset.getTexture("fb106");
            this.bgNormalTexture = Assets.sAsset.getTexture("fb105");
            this.bg = new Image(this.bgNormalTexture);
            addChild(this.bg);
            textNickName = new TextField(280,32,"","Verdana",24,4465669);
            Assets.positionDisplay(textNickName,"InviteFriendItem","txt_name");
            addChild(textNickName);
            textLevel = new TextField(180,32,"","Verdana",24,4465669);
            Assets.positionDisplay(textLevel,"InviteFriendItem","txt_level");
            addChild(textLevel);
            btnInvite = new Button(Assets.sAsset.getTexture("fb108"),"",Assets.sAsset.getTexture("fb109"));
            Assets.positionDisplay(btnInvite,"InviteFriendItem","btn_invite");
            btnInvite.addEventListener("triggered",onInvite);
            addChild(btnInvite);
            imgInvited = new Image(Assets.sAsset.getTexture("fb104"));
            Assets.positionDisplay(imgInvited,"InviteFriendItem","img_invited");
            addChild(imgInvited);
            imgInvited.visible = false;
            textNickName.touchable = textLevel.touchable = false;
         }
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         var _loc1_:FriendData = this.data as FriendData;
         if(_loc1_)
         {
            textNickName.text = _loc1_.nickName;
            textLevel.text = _loc1_.level.toString();
            _antID = _loc1_.antId;
            imgInvited.visible = false;
            btnInvite.visible = true;
            btnInvite.enabled = _loc1_.enbale;
         }
      }
      
      private function onInvite(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         btnInvite.visible = false;
         imgInvited.visible = true;
         PlayerDataList.instance.selfData.invitedNum++;
         TextTip.instance.showByLang("invite2");
         if(BattleServer.instance.isConnect)
         {
            _loc2_ = AllRoomData.instance.getSerByRoomID(AllRoomData.instance.roomID,1).serverID;
            _loc3_ = Application.instance.currentGame._btRoomOptionsData.password;
            InviteFriendFeedManager.instance.inviteForFight(_antID,AllRoomData.instance.roomID,PlayerDataList.instance.pk_type,_loc2_,_loc3_);
            trace("对战-发送邀请好友消息, 服务器ID:",_loc2_,"房间ID：",AllRoomData.instance.roomID);
         }
         if(CopyServer.instance.isConnect)
         {
            trace("副本-发送邀请好友消息:",_antID);
         }
      }
   }
}

