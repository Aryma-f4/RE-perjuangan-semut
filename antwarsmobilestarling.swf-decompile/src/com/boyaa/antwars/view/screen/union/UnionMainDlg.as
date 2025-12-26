package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.StarlingUITools;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.chatRoom.ChatRoomDlg;
   import com.boyaa.antwars.view.screen.union.commonBtn.LabelButton;
   import com.boyaa.antwars.view.screen.union.office.UnionLittleBaseManager;
   import com.boyaa.antwars.view.screen.union.store.UnionStoreDlg;
   import com.boyaa.antwars.view.screen.union.warehouse.WarehouseClassifyDlg;
   import com.boyaa.antwars.view.screen.unionBossFight.UnionBossFightDlg;
   import com.boyaa.antwars.view.screen.unionBossFight.UnionBossFightWorld;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import com.boyaa.tool.Trim;
   import feathers.controls.TextInput;
   import flash.filters.GlowFilter;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   import starling.utils.formatString;
   
   public class UnionMainDlg extends UnionCoreDlg
   {
      
      private var _unionWorshipBtn:Button;
      
      private var _unionBookBtn:Button;
      
      private var _unionOfficeBtn:Button;
      
      private var _unionCopyBtn:Button;
      
      private var _unionNoticeBtn:Button;
      
      private var _bg:Image;
      
      private var _unionBackBtn:Button;
      
      private var _unionData:UnionListItemModel = UnionManager.getInstance().myUnionModel;
      
      private var _unionMainTitle:Sprite;
      
      private var _unionLevelBtn:Button;
      
      private var _uinonStorageBtn:Button;
      
      private const UP_LEVEL_PRICE:Array = [0,750,2250,3750,6000,9000,15000,24000,36000,51000];
      
      private var _unionStoreBtn:Button;
      
      private var chatroom:ChatRoomDlg;
      
      private var msgSprite:Sprite;
      
      private var MessageBtn:Button;
      
      private var messageCome:Image;
      
      private var msgNumSprite:Sprite;
      
      private var msgNumText:TextField;
      
      private var msgNumBg:Image;
      
      private var _unionNoticeTF:TextInput;
      
      private var _noticeStr:String;
      
      public function UnionMainDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/UnionMain.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionMain.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionMain.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/unionBg.xml",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/unionBg.png",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         var _loc2_:LayoutUitl = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 == 1)
         {
            _bg = new Image(_asset.getTexture("unionBg"));
            addChild(_bg);
            addChild(_displayObj);
            _loc2_ = new LayoutUitl(_asset.getOther("UnionMain"),_asset);
            _loc2_.buildLayout("unionMainLayOut",_displayObj);
            LabelButton.LAYOUT = _loc2_;
            _unionWorshipBtn = getButtonByName("btnS_unionWorship");
            _unionWorshipBtn.addEventListener("triggered",worshipBtnHandel);
            _unionBookBtn = getButtonByName("btnS_unionBook");
            _unionBookBtn.addEventListener("triggered",unionBookBtnHandel);
            _unionOfficeBtn = getButtonByName("btnS_unionOffice");
            _unionOfficeBtn.addEventListener("triggered",unionOfficeBtnHandel);
            _unionCopyBtn = getButtonByName("btnS_unionCopy");
            _unionCopyBtn.addEventListener("triggered",unionCopyBtnHandel);
            _uinonStorageBtn = getButtonByName("btnS_unionStorage");
            _uinonStorageBtn.addEventListener("triggered",onStorageBtnHandle);
            _unionStoreBtn = getButtonByName("btnS_unionStore");
            _unionStoreBtn.addEventListener("triggered",unionStoreBtnHandel);
            _unionBackBtn = getButtonByName("btnS_unionBack");
            _unionBackBtn.addEventListener("triggered",unionBackBtnHandel);
            _unionMainTitle = _displayObj.getChildByName("unionMainTitle") as Sprite;
            getTextFieldByName("unionNameTF",_unionMainTitle).text = _unionData.cname;
            getTextFieldByName("LevelTF",_unionMainTitle).text = _unionData.clevel + "";
            getTextFieldByName("unionNameTF",_unionMainTitle).y = getTextFieldByName("unionNameTF",_unionMainTitle).y - 60;
            getTextFieldByName("LevelTF",_unionMainTitle).y = getTextFieldByName("LevelTF",_unionMainTitle).y - 20;
            getTextFieldByName("unionNameTF",_unionMainTitle).nativeFilters = [new GlowFilter(3677194,1,5,5,50,3)];
            getTextFieldByName("LevelTF",_unionMainTitle).nativeFilters = [new GlowFilter(3677194,1,5,5,50,3)];
            _unionLevelBtn = getButtonByName("btnS_unionLevelBtn",_unionMainTitle);
            _unionLevelBtn.addEventListener("triggered",upUnionHandler);
            this._displayObj.x = -170.5;
            this._bg.x = -170.5;
            initMessage();
            initChatRoom();
            _displayObj.addChild(msgSprite);
            UnionManager.getInstance().addEventListener(UnionEvent.PRIVATE_CHAT,privateChatHandel);
            _loc3_ = StarlingUITools.instance.getGlowFilter();
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               getTextFieldByName("roomTxt" + _loc4_).nativeFilters = _loc3_;
               getTextFieldByName("roomTxt" + _loc4_).bold = true;
               _loc4_++;
            }
            if(UnionBossFightWorld.backToBossFight)
            {
               UnionBossFightWorld.backToBossFight = false;
            }
         }
         super.loadAssetDone(param1);
      }
      
      private function onStorageBtnHandle(param1:Event) : void
      {
         var _loc2_:WarehouseClassifyDlg = new WarehouseClassifyDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function getUnionNoticeHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         _noticeStr = _loc3_.notice;
         if(_loc3_.ret == 0)
         {
            _unionNoticeTF.text = _noticeStr;
            return;
         }
         throw new Error(_loc3_.msg);
      }
      
      private function unionNoticeHandel(param1:Event) : void
      {
         _noticeStr = Trim.trim(_unionNoticeTF.text);
         EventCenter.PHPEvent.addEventListener("editUnionNotice",editNoticeHandler);
         Remoting.instance.gameTable.editUnionNotice(_noticeStr);
      }
      
      private function editNoticeHandler(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret != 0)
         {
            throw new Error(_loc3_.msg);
         }
      }
      
      private function privateChatHandel(param1:UnionEvent) : void
      {
         chatroom.visible = true;
         Application.instance.currentGame.addChild(chatroom);
         var _loc2_:PlayerData = param1.eventData as PlayerData;
         chatroom.gotoSingle(_loc2_.babyName,_loc2_.uid);
      }
      
      private function initMessage() : void
      {
         msgSprite = new Sprite();
         MessageBtn = new Button(Assets.sAsset.getTexture("msg"));
         MessageBtn.addEventListener("triggered",onMessageBtn);
         MessageBtn.visible = false;
         messageCome = new Image(Assets.sAsset.getTexture("h2"));
         messageCome.x = MessageBtn.x - 5;
         messageCome.y = MessageBtn.y - 4;
         messageCome.touchable = false;
         messageCome.visible = false;
         msgNumSprite = new Sprite();
         msgNumBg = new Image(Assets.sAsset.getTexture("msg_num_bg"));
         msgNumBg.x = MessageBtn.x + MessageBtn.width - msgNumBg.width / 2;
         msgNumBg.y = MessageBtn.y - msgNumBg.height / 2;
         msgNumText = new TextField(60,30,"24","Verdana",24,16777215);
         msgNumText.hAlign = "center";
         msgNumText.x = msgNumBg.x - 13;
         msgNumText.y = msgNumBg.y;
         msgNumText.autoScale = true;
         msgNumSprite.addChild(msgNumBg);
         msgNumSprite.addChild(msgNumText);
         msgNumSprite.visible = false;
         msgSprite.addChild(MessageBtn);
         msgSprite.addChild(messageCome);
         msgSprite.addChild(msgNumSprite);
         msgSprite.x = Assets.leftBottom.x + MessageBtn.width / 3;
         msgSprite.y = Assets.leftBottom.y - MessageBtn.height - 10;
      }
      
      public function initChatRoom() : void
      {
         chatroom = ChatRoomDlg.getInstance();
      }
      
      public function onMessageBtn(param1:Event = null) : void
      {
         chatroom.visible = true;
         _displayObj.addChild(chatroom);
      }
      
      private function unionStoreBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionStoreDlg = new UnionStoreDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function upUnionHandler(param1:Event) : void
      {
         _unionData = UnionManager.getInstance().myUnionModel;
         if(_unionData.position == 8 || _unionData.position == 9)
         {
            TextTip.instance.showByLang("canUplevelUnion");
            return;
         }
         var _loc2_:int = _unionData.clevel;
         if(_loc2_ == UP_LEVEL_PRICE.length)
         {
            TextTip.instance.showByLang("unionUplevelHighest");
            return;
         }
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("payUplevelUnion",UP_LEVEL_PRICE[_loc2_]),okHandler,null);
      }
      
      private function okHandler() : void
      {
         var _loc1_:int = _unionData.clevel;
         if(_unionData.cdevote < UP_LEVEL_PRICE[_loc1_])
         {
            TextTip.instance.showByLang("noContributor");
            UnionLittleBaseManager.instance.showLittleDlg("DONATE_DLG");
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("upUnionLevel",upUnionLevelHandler);
         Remoting.instance.gameTable.upUnionLevel(0);
      }
      
      private function upUnionLevelHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         var _loc4_:int = _unionData.clevel;
         if(_loc3_.ret == 0)
         {
            TextTip.instance.showByLang("uplevelOK");
            _unionData.clevel = _loc3_.clevel;
            _unionData.cdevote -= UP_LEVEL_PRICE[_loc4_];
            getTextFieldByName("LevelTF",_unionMainTitle).text = _unionData.clevel + "";
            return;
         }
         throw new Error(_loc3_.msg);
      }
      
      private function unionBackBtnHandel(param1:Event) : void
      {
         UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.GOTO_HALL));
      }
      
      private function unionCopyBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionBossFightDlg = new UnionBossFightDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function unionOfficeBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionOfficeDlg = new UnionOfficeDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function unionBookBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionMessageDlg = new UnionMessageDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      private function worshipBtnHandel(param1:Event) : void
      {
         var _loc2_:UnionWorshipDlg = new UnionWorshipDlg();
         Application.instance.currentGame.addChild(_loc2_);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

