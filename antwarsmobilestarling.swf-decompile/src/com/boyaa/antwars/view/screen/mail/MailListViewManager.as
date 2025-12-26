package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class MailListViewManager extends MailViewManager
   {
      
      private var _selectAllBtn:Sprite;
      
      private var _deleteBtn:Button;
      
      private var _mailViewList:List;
      
      private var _mailDataList:Array;
      
      private var _layout:LayoutUitl;
      
      private var _onKeyReceiveBtn:Button;
      
      public function MailListViewManager(param1:Sprite, param2:LayoutUitl)
      {
         _layout = param2;
         super(param1);
      }
      
      override protected function initView() : void
      {
         super.initView();
         _selectAllBtn = this._targetView.getChildByName("btnSelectAll") as Sprite;
         _selectAllBtn.addEventListener("touch",selectAllClickHandel);
         _deleteBtn = this._targetView.getChildByName("btnS_delete") as Button;
         _deleteBtn.addEventListener("triggered",deleteMailHandel);
         _onKeyReceiveBtn = this._targetView.getChildByName("btnS_oneKeyReceive") as Button;
         _onKeyReceiveBtn.addEventListener("triggered",oneKeyReceiveMailHandel);
         _mailViewList = new List();
         _mailViewList.setSize(856,400);
         _mailViewList.x = 8;
         _mailViewList.y = 50;
         _targetView.addChild(_mailViewList);
         _mailViewList.addEventListener("change",itemSelectHandel);
         MailEventManager.instance.addEventListener(MailBoxEvent.MAIL_LIST_ITEM_SELECT_ICON_CLICK,itemIconSelectHandel);
      }
      
      private function oneKeyReceiveMailHandel(param1:Event) : void
      {
         var _loc3_:Array = [];
         for each(var _loc2_ in _mailDataList)
         {
            if(_loc2_.select && _loc2_.file)
            {
               _loc3_.push(_loc2_.mail_id);
            }
         }
         if(_loc3_.length > 0)
         {
            GameServer.instance.send.getMailFile(_loc3_);
            MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_LIST_FILE_ONE_KEY,_loc3_));
         }
      }
      
      private function itemIconSelectHandel(param1:MailBoxEvent) : void
      {
         if(!param1.data.show)
         {
            _selectAllBtn.getChildByName("selectIcon").visible = false;
         }
      }
      
      private function itemSelectHandel(param1:Event) : void
      {
         if(_mailViewList.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:Object = _mailViewList.selectedItem as Object;
         _mailViewList.selectedIndex = -1;
         dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_SELECT_EVENT,_loc2_));
      }
      
      override public function active() : void
      {
         super.active();
         GameServer.instance.getMailList(getMailListDone);
         _selectAllBtn.getChildByName("selectIcon").visible = false;
      }
      
      private function getMailListDone(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = null;
         _mailDataList = param1;
         _loc3_ = 0;
         while(_loc3_ < _mailDataList.length)
         {
            _loc2_ = _mailDataList[_loc3_];
            _loc2_.select = false;
            _loc2_.render = _layout.createSprite("messageView");
            if(_loc2_.from_mid == 0)
            {
               _loc2_.from_name = LangManager.t("sendMailTip_manager");
            }
            _loc3_++;
         }
         _mailDataList.sortOn("send_timestamp");
         _mailDataList.reverse();
         _mailViewList.dataProvider = new ListCollection(_mailDataList);
         _mailViewList.itemRendererType = MessageListItemRender;
      }
      
      private function selectAllClickHandel(param1:TouchEvent) : void
      {
         var _loc3_:Touch = param1.getTouch(this._targetView);
         if(_loc3_ && _loc3_.phase == "began")
         {
            _selectAllBtn.getChildByName("selectIcon").visible = !_selectAllBtn.getChildByName("selectIcon").visible;
            for each(var _loc2_ in _mailDataList)
            {
               _loc2_.select = _selectAllBtn.getChildByName("selectIcon").visible;
            }
            MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_LIST_ALL_SELECT,_selectAllBtn.getChildByName("selectIcon").visible));
            return;
         }
      }
      
      private function deleteMailHandel(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:Array = [];
         _loc4_ = 0;
         while(_loc4_ < _mailDataList.length)
         {
            _loc2_ = _mailDataList[_loc4_];
            if(_loc2_.select)
            {
               _loc3_.push(_loc2_.mail_id);
               _mailDataList.splice(_loc4_,1);
               _loc4_--;
            }
            _loc4_++;
         }
         if(_loc3_.length > 0)
         {
            GameServer.instance.send.delMail(_loc3_);
         }
         _mailViewList.dataProvider = new ListCollection(_mailDataList);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._mailViewList.dispose();
         MailEventManager.instance.removeEventListener(MailBoxEvent.MAIL_LIST_ITEM_SELECT_ICON_CLICK,itemIconSelectHandel);
      }
   }
}

import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.tool.TimeUtil;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;

class MessageListItemRender extends ListItemRenderer
{
   
   private var _initCover:Boolean;
   
   private var _selectBtn:Sprite;
   
   private var _cover:Sprite;
   
   public function MessageListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      this.bgFocusTexture = Assets.sAsset.getTexture("messageViewBg");
      this.bgNormalTexture = Assets.sAsset.getTexture("messageViewBg");
      this.bg = new Image(Assets.sAsset.getTexture("messageViewBg"));
      this.addChild(this.bg);
      _initCover = false;
      MailEventManager.instance.addEventListener(MailBoxEvent.MAIL_LIST_ALL_SELECT,allSelectHandel);
      MailEventManager.instance.addEventListener(MailBoxEvent.MAIL_LIST_FILE_ONE_KEY,oneKeyFileHandel);
   }
   
   private function oneKeyFileHandel(param1:MailBoxEvent) : void
   {
      var _loc2_:Array = param1.data as Array;
      if(!this._data)
      {
         return;
      }
      if(_loc2_.indexOf(this._data.mail_id) != -1)
      {
         this._data.file = 0;
         _cover.getChildByName("fileIcon").visible = this._data.file == 1;
      }
   }
   
   private function allSelectHandel(param1:MailBoxEvent) : void
   {
      _selectBtn.getChildByName("selectIcon").visible = param1.data as Boolean;
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!_initCover)
      {
         _initCover = true;
         _cover = this._data.render;
         this.addChild(_cover);
         _selectBtn = _cover.getChildByName("btnSelectAll") as Sprite;
         _selectBtn.addEventListener("touch",selectAllIcon);
         (_cover.getChildByName("name_tf") as TextField).text = this._data.from_name;
         (_cover.getChildByName("title_tf") as TextField).text = String(this._data.title).substr(0,30) + "...";
         (_cover.getChildByName("date_tf") as TextField).text = TimeUtil.timestampToDateString(this._data.send_timestamp);
         (_cover.getChildByName("name_tf") as TextField).touchable = false;
         (_cover.getChildByName("title_tf") as TextField).touchable = false;
         (_cover.getChildByName("date_tf") as TextField).touchable = false;
      }
      _selectBtn.getChildByName("selectIcon").visible = this._data.select;
      _cover.getChildByName("fileIcon").visible = this._data.file == 1;
   }
   
   private function selectAllIcon(param1:TouchEvent) : void
   {
      var _loc2_:Touch = param1.getTouch(this._selectBtn);
      if(_loc2_ && _loc2_.phase == "began")
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         _selectBtn.getChildByName("selectIcon").visible = !_selectBtn.getChildByName("selectIcon").visible;
         this._data.select = _selectBtn.getChildByName("selectIcon").visible;
         MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_LIST_ITEM_SELECT_ICON_CLICK,{
            "show":_selectBtn.getChildByName("selectIcon").visible,
            "data":this._data
         }));
      }
   }
   
   override public function dispose() : void
   {
      MailEventManager.instance.removeEventListener(MailBoxEvent.MAIL_LIST_ALL_SELECT,allSelectHandel);
      super.dispose();
   }
}
