package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.data.UnionListModel;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.tools.TipNumCircle;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.events.Event;
   import starling.utils.formatString;
   
   public class UnionListDlg extends UnionCoreDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var _unionList:List;
      
      private var _applyUnionList:List;
      
      private var _createUnionBtn:Button;
      
      private var _createUnionDlg:UnionCreateDlg;
      
      private var _inviteUnionBtn:Button;
      
      private var _inviteUnionDlg:UnionInvitedDlg;
      
      private var _closeBtn:Button;
      
      private var _closeUnionListBtn:Button;
      
      private var _unionListData:UnionListModel = null;
      
      private var _applyUnionArr:Array = null;
      
      private var _inviteInfoArr:Array = [];
      
      private var _invitePlayerArr:Array = null;
      
      private var _memberArr:Array = null;
      
      private var _currentItem:UnionListItemModel;
      
      private var _numCircle:TipNumCircle;
      
      public function UnionListDlg()
      {
         super();
      }
      
      override protected function getRawAssets() : Array
      {
         _rawAssets = [rmger.getResFile(formatString("asset/unionApply.info")),rmger.getResFile(formatString("textures/{0}x/Union/unionApply.png",Assets.sAsset.scaleFactor)),rmger.getResFile(formatString("textures/{0}x/Union/unionApply.xml",Assets.sAsset.scaleFactor))];
         return _rawAssets;
      }
      
      override protected function loadAssetDone(param1:int) : void
      {
         if(param1 == 1)
         {
            _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
            _layout.buildLayout("applyUnionLayOut",_displayObj);
            _unionList = new List();
            _displayObj.addChild(_unionList);
            _unionList.x = 26;
            _unionList.y = 268;
            _unionList.width = 720;
            _unionList.height = 465;
            _unionList.itemRendererType = UnionListItemRender;
            _applyUnionList = new List();
            _applyUnionList.x = 785;
            _applyUnionList.y = 253;
            _applyUnionList.width = 200;
            _applyUnionList.height = 475;
            _displayObj.addChild(_applyUnionList);
            _applyUnionList.itemRendererType = UnionApplyListItemRender;
            _createUnionBtn = getButtonByName("btnS_createUnionBtn");
            _createUnionBtn.addEventListener("triggered",createUnionHandel);
            _closeUnionListBtn = getButtonByName("btnS_close");
            _closeUnionListBtn.addEventListener("triggered",closeUnionHandel);
            _inviteUnionBtn = getButtonByName("btnS_inviteInfoButton");
            _inviteUnionBtn.addEventListener("triggered",invitedUnionHandle);
            _numCircle = new TipNumCircle();
            _numCircle.setParent(_inviteUnionBtn);
            LoadData.show(this);
            Remoting.instance.gameTable.getUnionList();
            EventCenter.PHPEvent.addEventListener("getUnionList",getUnionListHandler);
            LoadData.show(this);
            Remoting.instance.gameTable.getApplyInfo();
            EventCenter.PHPEvent.addEventListener("getApplyUnionInfo",getApplyInfoHandler);
            UnionManager.getInstance().addEventListener(UnionEvent.UNION_LIST_APPLY_UNION,applyUnionHandel);
         }
         super.loadAssetDone(param1);
      }
      
      private function invitedUnionHandle(param1:Event) : void
      {
         _inviteUnionDlg = new UnionInvitedDlg();
         _inviteUnionDlg.setData(_inviteInfoArr);
         _inviteUnionDlg.setNumCircle(_numCircle);
         _inviteUnionDlg.active();
         Application.instance.currentGame.addChild(_inviteUnionDlg);
      }
      
      private function applyUnionHandel(param1:UnionEvent) : void
      {
         _currentItem = param1.eventData as UnionListItemModel;
         var _loc2_:int = _currentItem.cid;
         LoadData.show(this);
         Remoting.instance.gameTable.apply4Consortion(_loc2_);
         EventCenter.PHPEvent.addEventListener("applyToUnion",applyUnionDone);
      }
      
      private function applyUnionDone(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            _applyUnionArr.push(_currentItem);
            _applyUnionList.dataProvider = new ListCollection(_applyUnionArr);
            TextTip.instance.showByLang("applyOK");
         }
         else
         {
            switch(_loc3_.ret)
            {
               case 200:
                  TextTip.instance.showByLang("unionErrorTip0");
                  break;
               case 201:
                  TextTip.instance.showByLang("unionErrorTip1");
                  break;
               case 202:
                  TextTip.instance.showByLang("unionErrorTip2");
                  break;
               case 203:
                  TextTip.instance.showByLang("unionErrorTip3");
                  break;
               case 204:
                  TextTip.instance.showByLang("unionErrorTip4");
                  break;
               case 205:
                  TextTip.instance.showByLang("unionErrorTip5");
                  break;
               case 206:
                  TextTip.instance.showByLang("unionErrorTip6");
                  break;
               case 207:
                  TextTip.instance.showByLang("unionErrorTip7");
                  break;
               case 208:
                  TextTip.instance.showByLang("unionErrorTip8");
                  break;
               default:
                  TextTip.instance.showByLang("unionErrorTip9");
            }
         }
      }
      
      private function getUnionListHandler(param1:PHPEvent) : void
      {
         var _loc3_:Array = null;
         var _loc7_:int = 0;
         var _loc4_:UnionListItemModel = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc5_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         var _loc6_:int = int(_loc5_.list.length);
         if(_loc5_.ret == 0)
         {
            _loc3_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc4_ = new UnionListItemModel();
               _loc4_.createData(_loc5_.list[_loc7_]);
               _loc3_.push(_loc4_);
               _loc7_++;
            }
            _unionList.dataProvider = new ListCollection(_loc3_);
            return;
         }
         throw new Error(_loc5_.msg);
      }
      
      private function getApplyInfoHandler(param1:PHPEvent) : void
      {
         var _loc6_:int = 0;
         var _loc4_:UnionListItemModel = null;
         var _loc3_:Array = null;
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc5_:Object = JSON.parse(param1.param as String);
         _applyUnionArr = [];
         if(_loc5_.ret == 0)
         {
            if(_loc5_.clist.length > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_.clist.length)
               {
                  _loc4_ = new UnionListItemModel();
                  _loc4_.createData(_loc5_.clist[_loc6_]);
                  _applyUnionArr.push(_loc4_);
                  _loc6_++;
               }
               _applyUnionList.dataProvider = new ListCollection(_applyUnionArr);
            }
            if(_loc5_.mlist.length > 0)
            {
               _numCircle.setNum(_loc5_.mlist.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_.mlist.length)
               {
                  _loc3_ = [_loc5_.mlist[_loc6_][16]["cid"],_loc5_.mlist[_loc6_][16]["cname"],_loc5_.mlist[_loc6_][16]["position"],_loc5_.mlist[_loc6_][0],_loc5_.mlist[_loc6_][1]];
                  _inviteInfoArr.push(_loc3_);
                  _loc6_++;
               }
            }
         }
         else if(_loc5_.ret == 100)
         {
            TextTip.instance.showByLang("noApplyIniteNote");
         }
      }
      
      private function closeUnionHandel(param1:Event) : void
      {
         this.deactive();
         UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.GOTO_HALL));
      }
      
      private function createUnionHandel(param1:Event) : void
      {
         _createUnionDlg = new UnionCreateDlg();
         Application.instance.currentGame.addChild(_createUnionDlg);
         _createUnionDlg.active();
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.data.UnionListItemModel;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Button;
import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;

class UnionListItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _applyUnionBtn:Button;
   
   public function UnionListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("unionListItemNullBg");
      this.bgNormalTexture = _asset.getTexture("unionListItemNullBg");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
      _layout.buildLayout("unionListItem",this);
      _applyUnionBtn = this.getChildByName("btnS_applyUnionBtn") as Button;
      _applyUnionBtn.addEventListener("triggered",applyUnionHandel);
   }
   
   private function applyUnionHandel(param1:Event) : void
   {
      UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_LIST_APPLY_UNION,this._data));
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc1_:UnionListItemModel = this._data as UnionListItemModel;
      (this.getChildByName("rid") as TextField).text = _loc1_.chairmanName + "";
      (this.getChildByName("cname") as TextField).text = _loc1_.cname;
      (this.getChildByName("clevel") as TextField).text = _loc1_.clevel + "";
      (this.getChildByName("cnum") as TextField).text = _loc1_.memnum + "";
   }
   
   override public function dispose() : void
   {
      _applyUnionBtn.removeEventListener("triggered",applyUnionHandel);
   }
}

class UnionApplyListItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   public function UnionApplyListItemRender()
   {
      super();
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = _asset.getTexture("unionApplyListItemNullBg");
      this.bgNormalTexture = _asset.getTexture("unionApplyListItemNullBg");
      this.bg = new Image(this.bgNormalTexture);
      this.addChild(this.bg);
      _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
      _layout.buildLayout("unionApplyListItem",this);
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      (this.getChildByName("unionNameTF") as TextField).text = (this._data as UnionListItemModel).cname;
   }
   
   override public function dispose() : void
   {
   }
}
