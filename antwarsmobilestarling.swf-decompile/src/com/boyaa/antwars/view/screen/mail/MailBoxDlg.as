package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   
   public class MailBoxDlg extends BaseDlg
   {
      
      private var _asset:ResAssetManager;
      
      private var _receiveViewBtn:Button;
      
      private var _buttonTextureArr:Array = [];
      
      private var _closeBtn:Button;
      
      private var _mailListManager:MailListViewManager;
      
      private var _mailSendManager:MailSendViewManager;
      
      private var _mailReadManager:MailReadViewManager;
      
      private var _layout:LayoutUitl;
      
      private var _sendViewBtn:Button;
      
      public function MailBoxDlg()
      {
         super();
         _asset = Assets.sAsset;
         initView();
      }
      
      private function initView() : void
      {
         init(1);
      }
      
      private function init(param1:Number) : void
      {
         if(param1 == 1)
         {
            this.alpha = 0;
            _displayObj = new Sprite();
            addChild(_displayObj);
            _displayObj.x = 185;
            _displayObj.y = 0;
            _layout = new LayoutUitl(_asset.getOther("mailBox"),_asset);
            _layout.buildLayout("mailLayout",_displayObj);
            _mailListManager = new MailListViewManager(_displayObj.getChildByName("mailListView") as Sprite,_layout);
            _mailSendManager = new MailSendViewManager(_displayObj.getChildByName("sendMailView") as Sprite,_displayObj.getChildByName("friendListView") as Sprite,_displayObj.getChildByName("bagPannel") as Sprite);
            _mailReadManager = new MailReadViewManager(_displayObj.getChildByName("messgeReadView") as Sprite);
            _closeBtn = _displayObj.getChildByName("btnS_close") as Button;
            _closeBtn.addEventListener("triggered",closeHandel);
            _receiveViewBtn = _displayObj.getChildByName("btnS_receive") as Button;
            _sendViewBtn = _displayObj.getChildByName("btnS_send") as Button;
            _receiveViewBtn.addEventListener("triggered",onReceiveSelect);
            _sendViewBtn.addEventListener("triggered",onSendSelect);
            _buttonTextureArr.push([_receiveViewBtn.upState,_receiveViewBtn.downState,_receiveViewBtn]);
            _buttonTextureArr.push([_sendViewBtn.upState,_sendViewBtn.downState,_sendViewBtn]);
            _receiveViewBtn.upState = _receiveViewBtn.downState;
            this._mailListManager.active();
            this._mailSendManager.deactive();
            this._mailReadManager.deactive();
            this._mailListManager.addEventListener(MailBoxEvent.MAIL_SELECT_EVENT,selectMailHandel);
            this._mailReadManager.addEventListener(MailBoxEvent.MAIL_GOBACK_LIST_EVENT,gotoBackList);
            this.active();
         }
      }
      
      private function gotoBackList(param1:MailBoxEvent) : void
      {
         onBackFunc();
      }
      
      private function selectMailHandel(param1:MailBoxEvent) : void
      {
         readMail(param1.data);
      }
      
      private function readMail(param1:Object) : void
      {
         this._mailListManager.deactive();
         this._mailSendManager.deactive();
         this._mailReadManager.active();
         this._receiveViewBtn.visible = false;
         this._sendViewBtn.visible = false;
         this._mailReadManager.currentMail = param1;
      }
      
      private function closeHandel(param1:Event) : void
      {
         this.deactive();
      }
      
      private function onSendSelect(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _buttonTextureArr.length)
         {
            Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
         Button(param1.target).upState = Button(param1.target).downState;
         this._mailSendManager.active();
         this._mailListManager.deactive();
      }
      
      private function onReceiveSelect(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(Button(param1.target).upState == Button(param1.target).downState)
         {
            trace("已经是按下状态，不能操作");
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < _buttonTextureArr.length)
         {
            Button(_buttonTextureArr[_loc2_][2]).upState = _buttonTextureArr[_loc2_][0];
            Button(_buttonTextureArr[_loc2_][2]).downState = _buttonTextureArr[_loc2_][1];
            _loc2_++;
         }
         Button(param1.target).upState = Button(param1.target).downState;
         this._mailListManager.active();
         this._mailSendManager.deactive();
      }
      
      private function onBackFunc() : void
      {
         this._mailReadManager.deactive();
         this._mailSendManager.deactive();
         this._mailListManager.active();
         this._receiveViewBtn.visible = true;
         this._sendViewBtn.visible = true;
      }
      
      override public function dispose() : void
      {
         removeEvent();
         this.removeFromParent();
         MailTipsControl.instance.setMailHighLight(false);
         this._mailListManager.dispose();
         this._mailReadManager.dispose();
         this._mailSendManager.dispose();
         super.dispose();
      }
      
      private function removeEvent() : void
      {
      }
   }
}

