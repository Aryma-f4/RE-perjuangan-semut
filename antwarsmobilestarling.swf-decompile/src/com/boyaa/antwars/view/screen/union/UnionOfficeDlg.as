package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.sound.HelpDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.mission.MissionManager;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import com.boyaa.antwars.view.screen.union.commonBtn.LabelButton;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerApplyDlg;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerApplyInfoDlg;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerDetailDlg;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerDonateDlg;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerInviteDlg;
   import com.boyaa.antwars.view.screen.union.office.UnionManagerStepDownDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.utils.formatString;
   
   public class UnionOfficeDlg extends UnionCoreDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var _unionManagerDetailBtn:Button;
      
      private var _unionManagerApplyBtn:Button;
      
      private var _unionManagerStepDownBtn:Button;
      
      private var _closeBtn:Button;
      
      private var _unionManagerDonateBtn:Button;
      
      private var _unionManagerDisposeBtn:Button;
      
      private var _unionManagerExitBtn:Button;
      
      private var _unionManagerInviteBtn:Button;
      
      private var _unionManagerManageBtn:Button;
      
      private var _unionData:UnionListItemModel = UnionManager.getInstance().myUnionModel;
      
      private var _memberList:List;
      
      private var frameBtns:Sprite;
      
      private var _currentPlayerData:PlayerData;
      
      private var _handleType:int;
      
      private var _unionMember:Array;
      
      public function UnionOfficeDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/UnionOffice.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionOffice.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionOffice.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      private function showBtnsByPlayerPosition() : void
      {
         var _loc1_:int = UnionManager.getInstance().myUnionModel.position;
         switch(_loc1_ - 1)
         {
            case 1:
               _unionManagerStepDownBtn.visible = false;
               _unionManagerDisposeBtn.visible = false;
               break;
            case 7:
            case 8:
               _unionManagerStepDownBtn.visible = false;
               _unionManagerDisposeBtn.visible = false;
               _unionManagerApplyBtn.visible = false;
               _unionManagerInviteBtn.visible = false;
               _unionManagerManageBtn.visible = false;
         }
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            _layout = new LayoutUitl(_asset.getOther("UnionOffice"),_asset);
            _layout.buildLayout("unionManagerLayout",_displayObj);
            _unionManagerDetailBtn = getButtonByName("btnS_unionManagerDetailBtn");
            _unionManagerDetailBtn.addEventListener("triggered",unionManagerDetailBtnHandel);
            _unionManagerApplyBtn = getButtonByName("btnS_unionManagerApplyBtn");
            _unionManagerApplyBtn.addEventListener("triggered",unionManagerApplyBtnHandel);
            _unionManagerStepDownBtn = getButtonByName("btnS_unionManagerStepDownBtn");
            _unionManagerStepDownBtn.addEventListener("triggered",unionManagerStepDownBtnHandel);
            _unionManagerDonateBtn = getButtonByName("btnS_unionManagerDonateBtn");
            _unionManagerDonateBtn.addEventListener("triggered",unionManagerDonateHandel);
            _unionManagerDisposeBtn = getButtonByName("btnS_unionManagerDisposeBtn");
            _unionManagerDisposeBtn.addEventListener("triggered",unionManagerDisposeHandel);
            _unionManagerInviteBtn = getButtonByName("btnS_unionManagerInviteBtn");
            _unionManagerInviteBtn.addEventListener("triggered",unionManagerInviteHandel);
            _unionManagerManageBtn = getButtonByName("btnS_unionManagerManageBtn");
            _unionManagerManageBtn.addEventListener("triggered",unionManagerManageHandel);
            _unionManagerExitBtn = getButtonByName("btnS_unionManagerExitBtn");
            _unionManagerExitBtn.addEventListener("triggered",unionManagerExitHandel);
            getButtonByName("btnS_close").addEventListener("triggered",onclose);
            getButtonByName("btnS_unionManagerAskBtn").addEventListener("triggered",onHelpClick);
            getTextFieldByName("unionManagerDonateTF").text = _unionData.cdevote + "";
            getTextFieldByName("unionManagerMemberNumTF").text = _unionData.memnum + "";
            getTextFieldByName("unionManagerApplyNumTF").text = _unionData.applynum + "";
            getTextFieldByName("unionManagerMyDonateTF").text = _unionData.mdevote + "";
            LoadData.show(this);
            EventCenter.PHPEvent.addEventListener("getUnionMember",getUnionMemberHandler);
            Remoting.instance.gameTable.getUnionMember();
            _memberList = new List();
            _memberList.itemRendererType = UnionOfficeMemberItemRender;
            _memberList.x = 28.5;
            _memberList.y = 250;
            _memberList.addEventListener("change",memberListSelect);
            _displayObj.addChild(_memberList);
            _memberList.height = 440;
            frameBtns = new Sprite();
            _displayObj.addChild(frameBtns);
            UnionManager.getInstance().addEventListener(UnionEvent.UNION_DATA_REFRESH,unionDataRefreshDone);
            this.stage.addEventListener("touch",onTouch);
            setDisplayObjectInMiddle();
            showBtnsByPlayerPosition();
         }
         super.loadAssetDone(param1);
      }
      
      private function onHelpClick(param1:Event) : void
      {
         HelpDlg.show(LangManager.t("unionOfficeHelp"));
      }
      
      private function onTouch(param1:TouchEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<Touch> = param1.getTouches(this.stage);
         if(_loc2_.length > 0 && _loc2_[0].phase == "began")
         {
            _loc3_ = param1.getTouches(_memberList);
            if(frameBtns && _loc3_.length > 0 && _loc3_[0].phase == "began")
            {
               frameBtns.x = 180;
               frameBtns.y = _loc3_[0].globalY;
               if(frameBtns.x > 700)
               {
                  frameBtns.x = 700;
               }
            }
            if(frameBtns && frameBtns.visible)
            {
               _loc4_ = param1.getTouches(frameBtns);
               if(_loc4_.length == 0)
               {
                  frameBtns.visible = false;
                  _memberList.selectedIndex = -1;
               }
            }
         }
      }
      
      private function createButtonFrame() : void
      {
         var _loc3_:LabelButton = null;
         var _loc6_:int = 0;
         while(frameBtns.numChildren)
         {
            frameBtns.removeChildAt(0);
         }
         var _loc2_:Array = [[{
            "title":"UnionOfficeBtnInfoPrivateChack",
            "callBack":privateChackHandel
         },{
            "title":"UnionOfficeBtnInfoAddFriend",
            "callBack":addFriendHandel
         }],[{
            "title":"UnionOfficeBtnInfoPrivateChack",
            "callBack":privateChackHandel
         },{
            "title":"UnionOfficeBtnInfoAddFriend",
            "callBack":addFriendHandel
         },{
            "title":"UnionOfficeBtnInfoUp",
            "callBack":UpHandel
         },{
            "title":"UnionOfficeBtnInfoDown",
            "callBack":DownHandel
         },{
            "title":"UnionOfficeBtnInfoOut",
            "callBack":OutHandel
         }],[{
            "title":"UnionOfficeBtnInfoPrivateChack",
            "callBack":privateChackHandel
         },{
            "title":"UnionOfficeBtnInfoAddFriend",
            "callBack":addFriendHandel
         },{
            "title":"UnionOfficeBtnInfoOut",
            "callBack":OutHandel
         }]];
         var _loc4_:Array = [];
         switch(UnionManager.getInstance().myUnionModel.position - 1)
         {
            case 0:
               _loc4_ = _loc2_[1];
               break;
            case 1:
               _loc4_ = _loc2_[2];
               break;
            case 7:
            case 8:
               _loc4_ = _loc2_[0];
         }
         var _loc1_:int = 20;
         var _loc7_:int = 10;
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc4_[_loc6_]["title"] == "UnionOfficeBtnInfoAddFriend")
            {
               if(!FriendsList.instance.isFriend(_currentPlayerData.uid))
               {
                  _loc3_ = new LabelButton(LangManager.t(_loc4_[_loc6_]["title"]),131,55);
                  frameBtns.addChild(_loc3_);
                  _loc3_.x = _loc1_;
                  _loc3_.y = 20;
                  _loc1_ = _loc1_ + _loc7_ + _loc3_.width;
                  _loc3_.addEventListener("triggered",_loc4_[_loc6_]["callBack"]);
               }
            }
            else
            {
               _loc3_ = new LabelButton(LangManager.t(_loc4_[_loc6_]["title"]),131,55);
               frameBtns.addChild(_loc3_);
               _loc3_.x = _loc1_;
               _loc3_.y = 20;
               _loc1_ = _loc1_ + _loc7_ + _loc3_.width;
               _loc3_.addEventListener("triggered",_loc4_[_loc6_]["callBack"]);
            }
            _loc6_++;
         }
         var _loc5_:Scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture("tips_scale9"),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         _loc5_.width = _loc1_ + 10;
         _loc5_.height = 96;
         frameBtns.addChildAt(_loc5_,0);
      }
      
      private function addFriendHandel(param1:Event) : void
      {
         LoadData.show(this);
         frameBtns.visible = false;
         Remoting.instance.addFriend(_currentPlayerData.uid,addFriendCallback);
      }
      
      private function addFriendCallback(param1:Object) : void
      {
         LoadData.hide();
         TextTip.instance.showByLang("teamList6");
      }
      
      private function OutHandel(param1:Event) : void
      {
         frameBtns.visible = false;
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("isOutUnionMember",_currentPlayerData.babyName),makeSureOutHandler,null);
      }
      
      private function makeSureOutHandler() : void
      {
         _handleType = 3;
         var _loc1_:Array = [_currentPlayerData.uid,_handleType];
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("manageUnionMember",managerUnionMemberHandler);
         Remoting.instance.gameTable.manageUnionMember(_loc1_);
      }
      
      private function managerUnionMemberHandler(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc3_.ret == 0)
         {
            switch(_handleType)
            {
               case 0:
                  TextTip.instance.showByLang("upPosOK");
                  break;
               case 1:
                  TextTip.instance.showByLang("downPosOK");
                  break;
               case 3:
                  TextTip.instance.showByLang("outOK");
            }
            refreshOffice();
         }
         else if(_loc3_.ret == 125)
         {
            TextTip.instance.showByLang("vicechairmanFull");
         }
         else
         {
            TextTip.instance.show(_loc3_.msg);
         }
      }
      
      private function DownHandel(param1:Event) : void
      {
         frameBtns.visible = false;
         _handleType = 1;
         var _loc2_:Array = [_currentPlayerData.uid,_handleType];
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("manageUnionMember",managerUnionMemberHandler);
         Remoting.instance.gameTable.manageUnionMember(_loc2_);
      }
      
      private function UpHandel(param1:Event) : void
      {
         frameBtns.visible = false;
         _handleType = 0;
         var _loc2_:Array = [_currentPlayerData.uid,_handleType];
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("manageUnionMember",managerUnionMemberHandler);
         Remoting.instance.gameTable.manageUnionMember(_loc2_);
      }
      
      private function privateChackHandel(param1:Event) : void
      {
         this.onclose(null);
         UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.PRIVATE_CHAT,_currentPlayerData));
      }
      
      private function memberListSelect(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         _currentPlayerData = _loc2_.selectedItem as PlayerData;
         createButtonFrame();
         frameBtns.visible = PlayerDataList.instance.selfData.uid != _currentPlayerData.uid;
         frameBtns.alpha = 0;
         Starling.juggler.tween(frameBtns,0.6,{
            "alpha":1,
            "transition":"easeOutBack"
         });
         _loc2_.selectedIndex = -1;
      }
      
      private function unionDataRefreshDone(param1:UnionEvent) : void
      {
         LoadData.hide();
         _unionData = UnionManager.getInstance().myUnionModel;
         getTextFieldByName("unionManagerDonateTF").text = _unionData.cdevote + "";
         getTextFieldByName("unionManagerMemberNumTF").text = _unionData.memnum + "";
         getTextFieldByName("unionManagerApplyNumTF").text = _unionData.applynum + "";
         getTextFieldByName("unionManagerMyDonateTF").text = _unionData.mdevote + "";
         showBtnsByPlayerPosition();
      }
      
      private function getUnionMemberHandler(param1:PHPEvent) : void
      {
         var _loc5_:int = 0;
         var _loc4_:PlayerData = null;
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            _unionMember = [];
            _loc5_ = 0;
            while(_loc5_ < _loc3_.list.length)
            {
               _loc4_ = new PlayerData();
               _loc4_.addData(_loc3_.list[_loc5_]);
               _unionMember.push(_loc4_);
               _loc5_++;
            }
            _memberList.dataProvider = new ListCollection(_unionMember);
            return;
         }
         throw new Error(_loc3_.msg);
      }
      
      private function unionManagerExitHandel(param1:Event) : void
      {
         if(_unionData.memnum == 1)
         {
            SystemTip.instance.showSystemAlert(LangManager.getLang.getLangByStr("dismissUnion"),unlayUnionHandler,null);
            return;
         }
         if(_unionData.position == 1)
         {
            TextTip.instance.showByLang("appointChairman");
         }
         else
         {
            SystemTip.instance.showSystemAlert(LangManager.getLang.getLangByStr("exitUnionInfo"),exitUnionOKHandel,null);
         }
      }
      
      private function exitUnionOKHandel() : void
      {
         var _loc1_:Array = null;
         try
         {
            LoadData.show(this);
            _handleType = 2;
            _loc1_ = [PlayerDataList.instance.selfData.uid,_handleType];
            EventCenter.PHPEvent.addEventListener("manageUnionMember",managerUnionMemberExitHandler);
            Remoting.instance.gameTable.manageUnionMember(_loc1_);
         }
         catch(err:Error)
         {
            trace(err.getStackTrace());
         }
      }
      
      private function managerUnionMemberExitHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         try
         {
            if(_loc3_.ret == 0)
            {
               onclose(null);
               PlayerDataList.instance.selfData.cid = 0;
               MissionManager.instance.getMissionState();
               UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.GOTO_HALL));
            }
         }
         catch(err:Error)
         {
            trace(err.getStackTrace());
         }
      }
      
      private function unlayUnionHandler() : void
      {
         LoadData.show(this);
         _handleType = 2;
         var _loc1_:Array = [PlayerDataList.instance.selfData.uid,_handleType];
         EventCenter.PHPEvent.addEventListener("manageUnionMember",unlayUnionHandlerDone);
         Remoting.instance.gameTable.manageUnionMember(_loc1_);
      }
      
      private function unlayUnionHandlerDone(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc3_.ret == 0)
         {
            PlayerDataList.instance.selfData.cid = 0;
            UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_VIEW_CHANGE));
            this.removeFromParent(true);
         }
         else if(_loc3_.ret == 125)
         {
            TextTip.instance.showByLang("vicechairmanFull");
         }
         else
         {
            TextTip.instance.show(_loc3_.msg);
         }
      }
      
      private function unionManagerManageHandel(param1:Event) : void
      {
         var _loc2_:UnionManagerApplyDlg = new UnionManagerApplyDlg(refreshOffice);
         _loc2_.active();
         this.addChild(_loc2_);
      }
      
      private function unionManagerInviteHandel(param1:Event) : void
      {
         var _loc2_:UnionManagerInviteDlg = new UnionManagerInviteDlg();
         _loc2_.active();
         this.addChild(_loc2_);
      }
      
      private function unionManagerDisposeHandel(param1:Event) : void
      {
         SystemTip.instance.showSystemAlert(LangManager.getLang.getLangByStr("makeSureUnlayUnionInfo"),unlayUnionHandler,null);
      }
      
      private function unionManagerDonateHandel(param1:Event) : void
      {
         var _loc2_:UnionManagerDonateDlg = new UnionManagerDonateDlg();
         _loc2_.active();
         this.addChild(_loc2_);
      }
      
      private function onclose(param1:Event) : void
      {
         this.deactive();
      }
      
      private function unionManagerStepDownBtnHandel(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc3_:UnionManagerStepDownDlg = null;
         if(_unionData.position == 1)
         {
            _loc2_ = [];
            _loc4_ = 0;
            while(_loc4_ < _unionMember.length)
            {
               if(_unionMember[_loc4_].position == 2)
               {
                  _loc2_.push(_unionMember[_loc4_]);
               }
               _loc4_++;
            }
            if(_loc2_.length == 0)
            {
               TextTip.instance.showByLang("noViceChairmanKeajim");
               return;
            }
            _loc3_ = new UnionManagerStepDownDlg(_loc2_,refreshOffice);
            _loc3_.active();
            this.addChild(_loc3_);
         }
         else
         {
            TextTip.instance.showByLang("isNotChairman");
         }
      }
      
      private function unionManagerApplyBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionManagerApplyInfoDlg = null;
         if(_unionData.position == 1 || _unionData.position == 2)
         {
            _loc2_ = new UnionManagerApplyInfoDlg();
            _loc2_.active();
            this.addChild(_loc2_);
         }
         else
         {
            TextTip.instance.showByLang("noRights");
         }
      }
      
      private function refreshOffice() : void
      {
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("getUnionMember",getUnionMemberHandler);
         Remoting.instance.gameTable.getUnionMember();
         LoadData.show(this);
         UnionManager.getInstance().isHaveUnion();
      }
      
      private function unionManagerDetailBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionManagerDetailDlg = new UnionManagerDetailDlg();
         _loc2_.active();
         this.addChild(_loc2_);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         UnionManager.getInstance().isHaveUnion();
      }
   }
}

import com.boyaa.antwars.data.model.PlayerData;
import com.boyaa.antwars.lang.LangManager;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import flash.utils.Dictionary;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

class UnionOfficeMemberItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _selectCheckBox:Sprite;
   
   private var _dic:Dictionary = new Dictionary();
   
   private var _normalColor:uint;
   
   private var _colorDic:Dictionary = new Dictionary();
   
   public function UnionOfficeMemberItemRender()
   {
      super();
      var _loc1_:Array = LangManager.ta("unionPositionArr");
      _dic[1] = _loc1_[0];
      _dic[2] = _loc1_[1];
      _dic[8] = _loc1_[2];
      _dic[9] = _loc1_[2];
      _colorDic[1] = 16777088;
      _colorDic[2] = 255;
      _colorDic[8] = 16777215;
      _colorDic[9] = 16777215;
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("unionManagerPlayerListItemNullBg");
      this.bgNormalTexture = _asset.getTexture("unionManagerPlayerListItemNullBg");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("UnionOffice"),_asset);
      _layout.buildLayout("unionManagerPlayerListItemLayout",this);
      _normalColor = (this.getChildByName("rankTF") as TextField).color;
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      (this.getChildByName("rankTF") as TextField).text = _dic[(this._data as PlayerData).position] + "";
      (this.getChildByName("memberTF") as TextField).text = (this._data as PlayerData).babyName;
      (this.getChildByName("levelTF") as TextField).text = (this._data as PlayerData).level + "";
      (this.getChildByName("donateTF") as TextField).text = (this._data as PlayerData).mdevote + "";
      (this.getChildByName("rankTF") as TextField).color = _colorDic[PlayerData(this._data).position];
   }
   
   override public function dispose() : void
   {
   }
}
