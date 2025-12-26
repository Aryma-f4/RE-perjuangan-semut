package com.boyaa.antwars.view.screen.copygame.team
{
   import com.boyaa.antwars.view.ui.ListItemRenderer;
   import flash.geom.Rectangle;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class TeamListItemRender extends ListItemRenderer
   {
      
      protected var pos:Rectangle;
      
      protected var roomId:TextField;
      
      protected var roomName:TextField;
      
      protected var ownerText:TextField;
      
      protected var playerNum:TextField;
      
      protected var imgState:Image;
      
      public function TeamListItemRender()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         if(!this.bg)
         {
            this.bgFocusTexture = Assets.sAsset.getTexture("fb86");
            this.bgNormalTexture = Assets.sAsset.getTexture("fb87");
            this.bg = new Image(this.bgNormalTexture);
            this.addChild(this.bg);
            pos = Assets.getPosition("teamListItem","roomId");
            this.roomId = new TextField(pos.width,pos.height,"","Verdana",24,4465669,true);
            roomId.autoScale = true;
            this.roomId.x = pos.x;
            this.roomId.y = pos.y;
            this.roomId.touchable = false;
            addChild(this.roomId);
            pos = Assets.getPosition("teamListItem","roomName");
            this.roomName = new TextField(pos.width,pos.height,"","Verdana",24,4465669,true);
            roomName.autoScale = true;
            this.roomName.x = pos.x;
            this.roomName.y = pos.y;
            this.roomName.touchable = false;
            addChild(this.roomName);
            pos = Assets.getPosition("teamListItem","owner");
            this.ownerText = new TextField(pos.width,pos.height,"","Verdana",24,39423,true);
            ownerText.autoScale = true;
            this.ownerText.x = pos.x;
            this.ownerText.y = pos.y;
            this.ownerText.touchable = false;
            addChild(this.ownerText);
            pos = Assets.getPosition("teamListItem","playerNum");
            this.playerNum = new TextField(pos.width,pos.height,"","Verdana",24,4465669,true);
            playerNum.autoScale = true;
            this.playerNum.x = pos.x;
            this.playerNum.y = pos.y;
            this.playerNum.touchable = false;
            addChild(this.playerNum);
            pos = Assets.getPosition("teamListItem","state");
            imgState = new Image(Assets.sAsset.getTexture("fb84"));
            this.imgState.x = pos.x;
            this.imgState.y = pos.y;
            this.imgState.touchable = false;
            addChild(this.imgState);
         }
      }
      
      override protected function commitData() : void
      {
         if(!this._data)
         {
            return;
         }
         var _loc1_:RoomData = this._data as RoomData;
         roomId.text = _loc1_.roomId.toString();
         roomName.text = _loc1_.roomName;
         ownerText.text = _loc1_.roomOwner.toString();
         playerNum.text = _loc1_.roomMember;
         if(_loc1_.roomState == 0)
         {
            imgState.texture = Assets.sAsset.getTexture("fb84");
         }
         else
         {
            imgState.texture = Assets.sAsset.getTexture("fb85");
         }
      }
   }
}

