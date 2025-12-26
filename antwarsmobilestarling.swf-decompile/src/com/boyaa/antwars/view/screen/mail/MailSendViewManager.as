package com.boyaa.antwars.view.screen.mail
{
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.data.GoodsList;
   import com.boyaa.antwars.data.model.GoodsData;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.net.server.GameServer;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.chatRoom.FriendData;
   import com.boyaa.antwars.view.screen.chatRoom.FriendsList;
   import feathers.controls.List;
   import feathers.controls.TextInput;
   import feathers.data.ListCollection;
   import feathers.layout.TiledRowsLayout;
   import flash.geom.Point;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   import starling.text.TextField;
   
   public class MailSendViewManager extends MailViewManager
   {
      
      private var _friendList:Sprite;
      
      private var _bagList:Sprite;
      
      private var _showFriendListBtn:Button;
      
      private var _showFileListBtn:Button;
      
      private var _sendMailBtn:Button;
      
      private var _friendViewList:List;
      
      private var _bagViewList:List;
      
      private var _currentFriend:FriendData;
      
      private var _inputTitleTextField:TextInput;
      
      private var _inputContentTextField:TextInput;
      
      private var _mailFiles:Array;
      
      private var _bgMark:DlgMark;
      
      public function MailSendViewManager(param1:Sprite, param2:Sprite, param3:Sprite)
      {
         this._friendList = param2;
         this._bagList = param3;
         super(param1);
      }
      
      override public function active() : void
      {
         super.active();
         _bagViewList.dataProvider = new ListCollection(createSelfData());
         clearDisplay();
      }
      
      private function createSelfData() : Array
      {
         var _loc1_:Array = [];
         for each(var _loc2_ in GoodsList.instance.getGoodsListUnbind())
         {
            _loc1_.push({
               "num":_loc2_.amount,
               "item":_loc2_
            });
         }
         return _loc1_;
      }
      
      private function clearDisplay() : void
      {
         (this._targetView.getChildByName("friendName_tf") as TextField).text = "";
         (this._targetView.getChildByName("title_tf") as TextField).text = "";
         (this._targetView.getChildByName("content_tf") as TextField).text = "";
         this._inputContentTextField.text = "";
         this._inputTitleTextField.text = "";
         _mailFiles = [];
         clearFileList();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this._bagList.visible = false;
         this._friendList.visible = false;
      }
      
      override protected function initView() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.initView();
         _showFriendListBtn = this._targetView.getChildByName("btnS_friendList") as Button;
         _showFriendListBtn.addEventListener("triggered",showFriendList);
         _showFileListBtn = this._targetView.getChildByName("btnS_file") as Button;
         _showFileListBtn.addEventListener("triggered",showFileList);
         _sendMailBtn = this._targetView.getChildByName("btnS_sendMail") as Button;
         _sendMailBtn.addEventListener("triggered",sendMailHandel);
         _friendViewList = new List();
         _friendViewList.setSize(650,380);
         _friendViewList.x = 38;
         _friendViewList.y = 70;
         _friendList.addChild(_friendViewList);
         _friendViewList.addEventListener("change",friendSelectHandel);
         var _loc1_:Array = ["mid","nickName","level","marryState"];
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            TextField(_friendList.getChildByName("title" + _loc3_)).text = LangManager.t(_loc1_[_loc3_]);
            _loc3_++;
         }
         _bagViewList = new List();
         _bagViewList.setSize(700,350);
         _bagViewList.x = 32;
         _bagViewList.y = 52;
         _bagList.addChild(_bagViewList);
         _bagViewList.addEventListener("change",bagItemSelectHandel);
         var _loc2_:TiledRowsLayout = new TiledRowsLayout();
         _loc2_.useSquareTiles = false;
         _loc2_.gap = 5;
         _loc2_.paddingTop = 5;
         _bagViewList.layout = _loc2_;
         _bagViewList.itemRendererType = BagListItemRender;
         _inputTitleTextField = createInputTextByTextField(this._targetView.getChildByName("title_tf") as TextField);
         this._targetView.addChild(_inputTitleTextField);
         _inputContentTextField = createInputTextByTextField(this._targetView.getChildByName("content_tf") as TextField);
         this._targetView.addChild(_inputContentTextField);
         if(FriendsList.instance.needLoad)
         {
            Remoting.instance.getFirends(1,receiveData);
         }
         else
         {
            _friendViewList.dataProvider = new ListCollection(FriendsList.instance.getFriendListData());
         }
         _friendViewList.itemRendererType = FriendListItemRender;
         _loc4_ = 1;
         while(_loc4_ < 5)
         {
            (this._targetView.getChildByName("file_" + _loc4_) as Image).touchable = true;
            (this._targetView.getChildByName("file_" + _loc4_) as Image).addEventListener("touch",itemPanelClick);
            _loc4_++;
         }
         this._targetView.getChildByName("sendMailViewTitle").touchable = false;
      }
      
      private function itemPanelClick(param1:TouchEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         var _loc5_:Touch = param1.getTouch(this._targetView);
         if(_loc5_ && _loc5_.phase == "began")
         {
            _loc3_ = (param1.currentTarget as Image).name;
            _loc2_ = _loc3_.split("_")[1] - 1;
            if(_goodsBoxs[_loc2_])
            {
               _goodsBoxs[_loc2_].removeFromParent();
               _goodsBoxs[_loc2_] = null;
            }
            for each(var _loc4_ in _mailFiles)
            {
               if(_loc4_.id == _loc2_)
               {
                  _bagViewList.selectedItem = -1;
                  MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_FILE_LIST_ITEM_CLICK,_loc4_.data));
                  _mailFiles.splice(_mailFiles.indexOf(_loc4_),1);
                  return;
               }
            }
            return;
         }
      }
      
      private function bagItemSelectHandel(param1:Event) : void
      {
         var _loc3_:int = 0;
         if(_bagViewList.selectedIndex == -1)
         {
            return;
         }
         if(_bagViewList.selectedItem.num <= 0)
         {
            return;
         }
         var _loc2_:GoodsData = _bagViewList.selectedItem.item as GoodsData;
         _bagViewList.selectedItem = -1;
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(!_goodsBoxs[_loc3_])
            {
               if(!_mailFiles)
               {
                  _mailFiles = [];
               }
               _mailFiles.push({
                  "id":_loc3_,
                  "data":_loc2_
               });
               showFileImage(_loc3_,_loc2_);
               MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_FILE_ITEM_SELECT_DONE,_loc2_));
               return;
            }
            _loc3_++;
         }
      }
      
      private function createInputTextByTextField(param1:TextField) : TextInput
      {
         var _loc2_:TextInput = new TextInput();
         _loc2_.textEditorProperties.fontFamily = param1.fontName;
         _loc2_.textEditorProperties.color = param1.color;
         _loc2_.textEditorProperties.fontSize = param1.fontSize;
         _loc2_.width = param1.width;
         _loc2_.height = param1.height;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         return _loc2_;
      }
      
      private function friendSelectHandel(param1:Event) : void
      {
         if(_friendViewList.selectedIndex == -1)
         {
            return;
         }
         _currentFriend = _friendViewList.selectedItem as FriendData;
         _friendViewList.selectedIndex = -1;
         this._friendList.visible = false;
         _inputContentTextField.touchable = !this._friendList.visible;
         _inputTitleTextField.touchable = !this._friendList.visible;
         (this._targetView.getChildByName("friendName_tf") as TextField).text = _currentFriend.nickName;
      }
      
      private function sendMailHandel(param1:Event) : void
      {
         var _loc4_:GoodsData = null;
         if((this._targetView.getChildByName("friendName_tf") as TextField).text == "" || this._inputTitleTextField.text == "" || this._inputContentTextField.text == "")
         {
            TextTip.instance.showByLang("sendMailTipError_1");
            return;
         }
         if(AccountData.instance.gameGold < 200)
         {
            TextTip.instance.showByLang("sendMailTipError_3");
            return;
         }
         var _loc2_:Array = [];
         for each(var _loc3_ in _mailFiles)
         {
            _loc4_ = _loc3_.data as GoodsData;
            _loc2_.push(_loc4_.onlyID);
            GoodsList.instance.removeGoodsByOnlyID(_loc4_.onlyID);
         }
         GameServer.instance.send.sendMail(this._currentFriend.antId,_inputTitleTextField.text,_inputContentTextField.text,_loc2_);
         clearDisplay();
      }
      
      public function receiveData(param1:Object) : void
      {
         Application.instance.log("好友列表",JSON.stringify(param1));
         FriendsList.instance.addData(param1 as Array);
         _friendViewList.dataProvider = new ListCollection(FriendsList.instance.getFriendListData());
         FriendsList.instance.needLoad = false;
      }
      
      private function showFileList(param1:Event = null) : void
      {
         var _loc2_:Point = null;
         this._bagList.visible = !this._bagList.visible;
         _inputContentTextField.touchable = !this._bagList.visible;
         _inputTitleTextField.touchable = !this._bagList.visible;
         if(_bgMark)
         {
            _bgMark.dispose();
            _bgMark.removeChildren();
            _bgMark = null;
         }
         if(this._bagList.visible)
         {
            _bgMark = new DlgMark();
            this._bagList.addChildAt(_bgMark,0);
            _loc2_ = this._bagList.globalToLocal(new Point(0,0));
            this._bgMark.x = _loc2_.x;
            this._bgMark.y = _loc2_.y;
            _bgMark.setTouchHandle(showFileList);
         }
      }
      
      private function showFriendList(param1:Event = null) : void
      {
         var _loc2_:Point = null;
         this._friendList.visible = !this._friendList.visible;
         _inputContentTextField.touchable = !this._friendList.visible;
         _inputTitleTextField.touchable = !this._friendList.visible;
         if(_bgMark)
         {
            _bgMark.dispose();
            _bgMark.removeChildren();
            _bgMark = null;
         }
         if(this._friendViewList.visible)
         {
            _bgMark = new DlgMark();
            this._friendViewList.addChildAt(_bgMark,0);
            _bgMark.setTouchHandle(showFriendList);
            _loc2_ = this._friendViewList.globalToLocal(new Point(0,0));
            this._bgMark.x = _loc2_.x;
            this._bgMark.y = _loc2_.y;
         }
      }
      
      public function get friendList() : Sprite
      {
         return _friendList;
      }
      
      public function set friendList(param1:Sprite) : void
      {
         _friendList = param1;
      }
      
      public function get bagList() : Sprite
      {
         return _bagList;
      }
      
      public function set bagList(param1:Sprite) : void
      {
         _bagList = param1;
      }
      
      override public function dispose() : void
      {
         var _loc1_:int = 0;
         _showFriendListBtn.dispose();
         _showFriendListBtn.removeEventListener("triggered",showFriendList);
         _showFileListBtn.dispose();
         _showFileListBtn.removeEventListener("triggered",showFileList);
         _sendMailBtn.dispose();
         _sendMailBtn.removeEventListener("triggered",sendMailHandel);
         _friendViewList.dispose();
         _bagViewList.dispose();
         _loc1_ = 1;
         while(_loc1_ < 5)
         {
            (this._targetView.getChildByName("file_" + _loc1_) as Image).removeEventListener("touch",itemPanelClick);
            _loc1_++;
         }
         super.dispose();
      }
   }
}

import com.boyaa.antwars.data.model.GoodsData;
import com.boyaa.antwars.lang.LangManager;
import com.boyaa.antwars.view.screen.chatRoom.FriendData;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import starling.display.Image;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;

class FriendListItemRender extends ListItemRenderer
{
   
   private static var stateArr:Array = LangManager.getLang.getLangArray("marryStateArr");
   
   private var _textAntId:TextField;
   
   private var _textNickName:TextField;
   
   private var _textFightPower:TextField;
   
   private var _marriage:TextField;
   
   public function FriendListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      this.bgFocusTexture = Assets.sAsset.getTexture("friendListItemViewBg1");
      this.bgNormalTexture = Assets.sAsset.getTexture("friendListItemViewBg2");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _textAntId = new TextField(115,40,"","Verdana",24,4465669);
      _textAntId.hAlign = "center";
      _textAntId.x = 13;
      _textAntId.y = 14;
      addChild(_textAntId);
      _textNickName = new TextField(250,40,"","Verdana",24,4465669);
      _textNickName.hAlign = "center";
      _textNickName.x = 128;
      _textNickName.y = 14;
      addChild(_textNickName);
      _textFightPower = new TextField(160,40,"","Verdana",24,4465669);
      _textFightPower.hAlign = "center";
      _textFightPower.x = 334;
      _textFightPower.y = 14;
      addChild(_textFightPower);
      _marriage = new TextField(173,40,"","Verdana",24,4465669);
      _marriage.hAlign = "center";
      _marriage.x = 469;
      _marriage.y = 14;
      _marriage.autoScale = true;
      addChild(_marriage);
      _textAntId.touchable = _textNickName.touchable = _textFightPower.touchable = _marriage.touchable = false;
   }
   
   private function itemSelectHandel(param1:TouchEvent) : void
   {
      var _loc2_:Touch = param1.getTouch(this);
      if(_loc2_ && _loc2_.phase == "began")
      {
         MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_FRIEND_CLICK,this._data));
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
      _textAntId.text = (this._data as FriendData).antId + "";
      _textNickName.text = (this._data as FriendData).nickName + "";
      _textFightPower.text = (this._data as FriendData).level + "";
      _marriage.text = stateArr[(this._data as FriendData).marrayState];
   }
   
   override public function dispose() : void
   {
      super.dispose();
      this.removeEventListener("touch",itemSelectHandel);
   }
}

class BagListItemRender extends ListItemRenderer
{
   
   private var goodsBox:Image;
   
   private var goodsName:TextField;
   
   private var level:TextField;
   
   private var txtValidate:TextField;
   
   protected var lowerlevelTxt:TextField;
   
   protected var countTxt:TextField;
   
   private var screenItems:Dictionary;
   
   private var pos:Rectangle;
   
   public function BagListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      var _loc1_:Image = null;
      if(!this.bg)
      {
         screenItems = Assets.getScreenPos("backpackitem");
         this.bgFocusTexture = Assets.sAsset.getTexture("item1");
         this.bgNormalTexture = Assets.sAsset.getTexture("item0");
         this.bg = new Image(this.bgNormalTexture);
         this.addChild(this.bg);
         pos = Assets.getPosition("backpackitem","bg1");
         _loc1_ = new Image(Assets.sAsset.getTexture("bg_item"));
         _loc1_.x = pos.x;
         _loc1_.y = pos.y;
         addChild(_loc1_);
         pos = Assets.getPosition("backpackitem","title");
         this.goodsName = new TextField(pos.width,pos.height,"","Verdana",26,4660230,true);
         this.goodsName.autoScale = true;
         this.goodsName.hAlign = "left";
         this.goodsName.vAlign = "center";
         this.goodsName.x = pos.x;
         this.goodsName.y = pos.y;
         addChild(this.goodsName);
         this.goodsName.touchable = false;
         this.goodsName.autoScale = true;
         pos = Assets.getPosition("backpackitem","validate");
         this.txtValidate = new TextField(pos.width,pos.height,"","0x452403",24,4531203);
         this.txtValidate.hAlign = "left";
         this.txtValidate.vAlign = "center";
         this.txtValidate.x = pos.x;
         this.txtValidate.y = pos.y;
         addChild(this.txtValidate);
         this.txtValidate.touchable = false;
         this.txtValidate.autoScale = true;
         pos = Assets.getPosition("shopitem","lowerlevel");
         this.lowerlevelTxt = new TextField(pos.width,pos.height,"","Verdana",28,16776960,true);
         this.lowerlevelTxt.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         lowerlevelTxt.autoScale = true;
         this.lowerlevelTxt.hAlign = "right";
         this.lowerlevelTxt.vAlign = "center";
         this.lowerlevelTxt.x = pos.x + 10;
         this.lowerlevelTxt.y = pos.y + 10;
         addChild(this.lowerlevelTxt);
         this.lowerlevelTxt.touchable = false;
         this.lowerlevelTxt.autoScale = true;
         countTxt = new TextField(pos.width,pos.height,"","Verdana",28,16776960,true);
         countTxt.autoScale = true;
         this.countTxt.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         this.countTxt.hAlign = "right";
         this.countTxt.x = pos.x + 10;
         this.countTxt.y = pos.y + 10;
         addChild(this.countTxt);
         this.countTxt.touchable = false;
         this.countTxt.autoScale = true;
         MailEventManager.instance.addEventListener(MailBoxEvent.MAIL_FILE_LIST_ITEM_CLICK,itemClickOutHandel);
         MailEventManager.instance.addEventListener(MailBoxEvent.MAIL_FILE_ITEM_SELECT_DONE,itemClickSelectDoneHandel);
      }
   }
   
   private function itemClickSelectDoneHandel(param1:MailBoxEvent) : void
   {
      var _loc2_:GoodsData = param1.data as GoodsData;
      if(!this._data || !_loc2_)
      {
         return;
      }
      if(_loc2_.onlyID == this._data.item.onlyID)
      {
         if(this._data.num > 0)
         {
            this._data.num--;
         }
         this.countTxt.text = "x" + this._data.num;
      }
      showFilterChange();
   }
   
   private function showFilterChange() : void
   {
      var _loc1_:ColorMatrixFilter = new ColorMatrixFilter();
      if(this._data.num <= 0)
      {
         _loc1_.adjustSaturation(-1);
      }
      else
      {
         _loc1_.adjustSaturation(0);
      }
      this.filter = _loc1_;
   }
   
   private function itemClickOutHandel(param1:MailBoxEvent) : void
   {
      var _loc2_:GoodsData = param1.data as GoodsData;
      if(!this._data || !_loc2_)
      {
         return;
      }
      if(_loc2_.onlyID == this._data.item.onlyID)
      {
         this._data.num++;
         this.countTxt.text = "x" + this._data.num;
      }
      showFilterChange();
   }
   
   private function itemSelectHandel(param1:TouchEvent) : void
   {
      var _loc2_:Touch = param1.getTouch(this);
      if(_loc2_ && _loc2_.phase == "began")
      {
         if(this._data.num <= 0)
         {
            return;
         }
         MailEventManager.instance.dispatchEvent(new MailBoxEvent(MailBoxEvent.MAIL_BAG_LIST_SELECT,this._data.item));
         return;
      }
   }
   
   override protected function commitData() : void
   {
      if(!this._data)
      {
         return;
      }
      var _loc1_:GoodsData = this._data.item as GoodsData;
      if(_loc1_.name)
      {
         this.goodsName.text = _loc1_.name;
      }
      if(this.goodsBox)
      {
         this.goodsBox.removeFromParent();
      }
      this.txtValidate.text = _loc1_.expiration;
      if(_loc1_.expiration == "已过期")
      {
         this.txtValidate.color = 16711680;
      }
      else
      {
         this.txtValidate.color = 4531203;
      }
      pos = Assets.getPosition("backpackitem","box");
      this.countTxt.text = "x" + this._data.num;
      try
      {
         this.goodsBox = Assets.sAsset.getGoodsImageByRect(_loc1_.typeID,_loc1_.frameID,pos);
         addChild(this.goodsBox);
         if(this.goodsBox)
         {
            this.swapChildren(this.goodsBox,this.countTxt);
         }
      }
      catch(e:Error)
      {
         trace("显示物品图片失败:" + e.message);
      }
      showFilterChange();
   }
   
   override public function dispose() : void
   {
      this.removeEventListener("touch",itemSelectHandel);
      MailEventManager.instance.removeEventListener(MailBoxEvent.MAIL_FILE_LIST_ITEM_CLICK,itemClickOutHandel);
      MailEventManager.instance.removeEventListener(MailBoxEvent.MAIL_FILE_ITEM_SELECT_DONE,itemClickSelectDoneHandel);
      super.dispose();
   }
}
