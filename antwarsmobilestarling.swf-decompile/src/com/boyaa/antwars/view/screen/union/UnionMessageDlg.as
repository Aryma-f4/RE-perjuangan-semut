package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.UnionMessageItemModel;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class UnionMessageDlg extends UnionCoreDlg
   {
      
      private var _messageList:List;
      
      private var _layout:LayoutUitl;
      
      private var _unionMessageBtn:Button;
      
      private var _sendMessageDlg:UnionMessageSendDlg;
      
      private var _readMessageDlg:UnionMessageReadDlg;
      
      private var _closeBtn:Button;
      
      public function UnionMessageDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/UnionMessage.info")),rmger.getResFile(formatString("textures/{0}x/Union/UnionMessage.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/UnionMessage.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            _layout = new LayoutUitl(_asset.getOther("UnionMessage"),_asset);
            _layout.buildLayout("unionMessageLayOut",_displayObj);
            _messageList = new List();
            _displayObj.addChild(_messageList);
            _messageList.x = 31;
            _messageList.y = 266;
            _messageList.width = 960;
            _messageList.height = 480;
            _messageList.itemRendererType = UnionMessageListItemRender;
            _messageList.dataProvider = new ListCollection(UnionManager.getInstance().messageModel.mesages);
            _messageList.addEventListener("change",messageItemSelectHandel);
            _closeBtn = _displayObj.getChildByName("btnS_close") as Button;
            _closeBtn.addEventListener("triggered",closeHandel);
            _unionMessageBtn = _displayObj.getChildByName("btnS_unionMessageBtn") as Button;
            _unionMessageBtn.addEventListener("triggered",messageBtnHandel);
            LoadData.show(this);
            Remoting.instance.gameTable.getUnionMsgLists();
            EventCenter.PHPEvent.addEventListener("getUnionMessageList",getUnionMessageDone);
            setDisplayObjectInMiddle();
         }
         super.loadAssetDone(param1);
      }
      
      private function getUnionMessageDone(param1:PHPEvent) : void
      {
         var _loc3_:Array = null;
         var _loc7_:int = 0;
         var _loc6_:UnionMessageItemModel = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc4_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         var _loc5_:int = int(_loc4_.list.length);
         if(_loc4_.ret == 0)
         {
            _loc3_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc6_ = new UnionMessageItemModel();
               _loc6_.mTitle = _loc4_.list[_loc7_].title;
               _loc6_.mDate = _loc4_.list[_loc7_].addtime;
               _loc6_.mContent = _loc4_.list[_loc7_].content;
               _loc6_.mName = _loc4_.list[_loc7_].mrolename;
               _loc3_.push(_loc6_);
               _loc7_++;
            }
            _messageList.dataProvider = new ListCollection(_loc3_);
            return;
         }
         throw new Error(_loc4_.msg);
      }
      
      private function closeHandel(param1:Event) : void
      {
         this.deactive();
      }
      
      private function messageItemSelectHandel(param1:Event) : void
      {
         if(_messageList.selectedIndex == -1)
         {
            return;
         }
         var _loc2_:UnionMessageItemModel = _messageList.selectedItem as UnionMessageItemModel;
         _readMessageDlg = new UnionMessageReadDlg(_loc2_);
         this.addChild(_readMessageDlg);
         _readMessageDlg.active();
         _messageList.selectedIndex = -1;
      }
      
      private function messageBtnHandel(param1:Event) : void
      {
         _sendMessageDlg = new UnionMessageSendDlg(refreshList);
         this.addChild(_sendMessageDlg);
         _sendMessageDlg.active();
      }
      
      private function refreshList() : void
      {
         LoadData.show(this);
         Remoting.instance.gameTable.getUnionMsgLists();
         EventCenter.PHPEvent.addEventListener("getUnionMessageList",getUnionMessageDone);
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}

import com.boyaa.antwars.data.UnionMessageItemModel;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.text.TextField;

class UnionMessageListItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   public function UnionMessageListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("unionMessageItemBg");
      this.bgNormalTexture = _asset.getTexture("unionMessageItemBg2");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("UnionMessage"),_asset);
      _layout.buildLayout("unionMessageItem",this);
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc1_:UnionMessageItemModel = this._data as UnionMessageItemModel;
      (this.getChildByName("nameTF") as TextField).text = _loc1_.mName;
      (this.getChildByName("titleTF") as TextField).text = _loc1_.mTitle;
      (this.getChildByName("timeTF") as TextField).text = _loc1_.mDate;
   }
   
   override public function dispose() : void
   {
   }
}
