package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.events.SocketEvent;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.union.UnionEvent;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class UnionManagerInviteDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _inviteList:List;
      
      private var _unionManagerInviteBtn:Button;
      
      private var _selectMids:Array;
      
      private var _selectCheckBox:Sprite;
      
      private var _dataItems:Array;
      
      public function UnionManagerInviteDlg()
      {
         super("unionManagerInviteLayout");
         _inviteList = new List();
         _inviteList.width = 700;
         _inviteList.height = 240;
         _inviteList.x = 27;
         _inviteList.y = 130;
         _displayObj.addChild(_inviteList);
         _inviteList.itemRendererType = UnionManagerInviteItemRender;
         _displayObj.getChildByName("unionManagerInviteBg").touchable = false;
         _unionManagerInviteBtn = _displayObj.getChildByName("btnS_unionManagerInviteLayoutInviteBtn") as Button;
         _unionManagerInviteBtn.addEventListener("triggered",unionManagerInviteHandel);
         _selectMids = [];
         _selectCheckBox = _displayObj.getChildByName("unionManagerCheckBoxSelectAll") as Sprite;
         _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = false;
         _selectCheckBox.addEventListener("touch",selectCheckBoxHandel);
         UnionManager.getInstance().addEventListener("unionManagerInviteItemSelect",itemSelectChange);
         LoadData.show(this);
         EventCenter.SocketEvent.addEventListener("OnlineFriendList",getInviteDataListHandler);
         GameServer.instance.send.inviteNoUnionPlayers();
      }
      
      protected function getInviteDataListHandler(param1:SocketEvent) : void
      {
         Application.instance.log("邀请无公会玩家列表",JSON.stringify(param1.param));
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Array = param1.param as Array;
         _inviteList.dataProvider = new ListCollection(_loc3_);
      }
      
      private function itemSelectChange(param1:UnionEvent) : void
      {
         var _loc2_:Array = param1.eventData as Array;
         var _loc3_:int = int(_loc2_[1][0]);
         if(_loc2_[0])
         {
            if(_selectMids.indexOf(_loc3_) == -1)
            {
               _selectMids.push(_loc3_);
            }
         }
         else
         {
            if(_selectMids.indexOf(_loc3_) != -1)
            {
               _selectMids.splice(_selectMids.indexOf(_loc3_),1);
            }
            _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = false;
         }
      }
      
      private function selectCheckBoxHandel(param1:TouchEvent) : void
      {
         var _loc3_:Touch = param1.getTouch(this);
         if(_loc3_ && _loc3_.phase == "began")
         {
            _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = !_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible;
            UnionManager.getInstance().dispatchEvent(new UnionEvent("unionManagerInviteTopSelect",_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible));
            if(_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible)
            {
               for each(var _loc2_ in _dataItems)
               {
                  _selectMids.push(_loc2_.uid);
               }
            }
            else
            {
               _selectMids = [];
            }
            return;
         }
      }
      
      private function unionManagerInviteHandel(param1:Event) : void
      {
         if(_selectMids.length == 0)
         {
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("invitePlayerToUnion",inivteToUnionHandler);
         Remoting.instance.gameTable.invitePlayerToUnion(_selectMids);
      }
      
      private function inivteToUnionHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         if(param1.param == "")
         {
            return;
         }
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            TextTip.instance.showByLang("sendInviteUnion");
         }
         else
         {
            switch(_loc3_.ret)
            {
               case 102:
                  TextTip.instance.showByLang("canntInvite");
                  break;
               case 103:
                  TextTip.instance.showByLang("isInAnotherUnion");
                  break;
               case 104:
                  TextTip.instance.showByLang("overTenInvite");
                  break;
               case 105:
                  TextTip.instance.showByLang("hadInviteFriend");
                  break;
               case 106:
                  TextTip.instance.showByLang("overRecruitPeople");
            }
         }
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.view.screen.union.UnionEvent;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;

class UnionManagerInviteItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _selectCheckBox:Sprite;
   
   public function UnionManagerInviteItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("unionManagerDetailItemBgNulll");
      this.bgNormalTexture = _asset.getTexture("unionManagerDetailItemBgNulll");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("UnionOffice"),_asset);
      _layout.buildLayout("unionManagerApplyListItemLayout",this);
      _selectCheckBox = this.getChildByName("unionManagerCheckBoxSelectAll") as Sprite;
      _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = false;
      _selectCheckBox.addEventListener("touch",selectCheckBoxHandel);
      UnionManager.getInstance().addEventListener("unionManagerInviteTopSelect",topSelectChange);
   }
   
   private function topSelectChange(param1:UnionEvent) : void
   {
      _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = param1.eventData as Boolean;
   }
   
   private function selectCheckBoxHandel(param1:TouchEvent) : void
   {
      param1.stopImmediatePropagation();
      param1.stopPropagation();
      var _loc2_:Touch = param1.getTouch(this);
      if(_loc2_ && _loc2_.phase == "began")
      {
         _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = !_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible;
         UnionManager.getInstance().dispatchEvent(new UnionEvent("unionManagerInviteItemSelect",[_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible,this._data]));
         return;
      }
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc1_:Array = this._data as Array;
      (this.getChildByName("nameTF") as TextField).text = _loc1_[1];
      (this.getChildByName("levelTF") as TextField).text = _loc1_[2] + "";
      (this.getChildByName("fightTF") as TextField).text = _loc1_[3];
   }
   
   override public function dispose() : void
   {
   }
}
