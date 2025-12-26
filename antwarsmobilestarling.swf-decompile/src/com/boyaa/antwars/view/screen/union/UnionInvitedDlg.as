package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.PlayerDataList;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.TipNumCircle;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.events.Event;
   
   public class UnionInvitedDlg extends BaseDlg
   {
      
      private var _layout:LayoutUitl;
      
      private var _asset:ResAssetManager;
      
      private var _list:List;
      
      private var _refuseBtn:Button;
      
      private var _acceptBtn:Button;
      
      private var _currentSelectData:Array;
      
      private var _totalArr:Array = [];
      
      private var _type:int = 0;
      
      private var _numCircle:TipNumCircle;
      
      public function UnionInvitedDlg()
      {
         super(true);
         _asset = Assets.sAsset;
         _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
         _layout.buildLayout("inviteInfoLayout",_displayObj);
         _list = new List();
         SmallCodeTools.instance.setDisplayObjectInSame(getDisplayObjByName("listPos"),_list);
         _displayObj.addChild(_list);
         _list.itemRendererType = UnionInvitedItemRender;
         _list.addEventListener("change",onListHandle);
         _refuseBtn = getButtonByName("btnS_refuseInviteBtn");
         _acceptBtn = getButtonByName("btnS_acceptInviteBtn");
         _refuseBtn.addEventListener("triggered",onRefuseHandle);
         _acceptBtn.addEventListener("triggered",onAcceptHandle);
         initCommandButton();
         setDisplayObjectInMiddle();
         EventCenter.PHPEvent.addEventListener("dealInvite",onDealWithInfoItem);
      }
      
      public function setNumCircle(param1:TipNumCircle) : void
      {
         _numCircle = param1;
      }
      
      private function onListHandle(param1:Event) : void
      {
         var _loc2_:List = List(param1.currentTarget);
         if(_loc2_.selectedIndex == -1)
         {
            return;
         }
         _currentSelectData = _loc2_.selectedItem as Array;
         UnionInvitedItemRender.selectSignal.dispatch(_loc2_.selectedIndex);
      }
      
      private function onAcceptHandle(param1:Event) : void
      {
         if(_currentSelectData == null)
         {
            TextTip.instance.showByLang("unionInvitedTip0");
            return;
         }
         _type = 0;
         Remoting.instance.gameTable.dealInvite({
            "invitemid":_currentSelectData[3],
            "confirm":_type
         });
      }
      
      private function onRefuseHandle(param1:Event) : void
      {
         if(_currentSelectData == null)
         {
            TextTip.instance.showByLang("unionInvitedTip0");
            return;
         }
         _type = 1;
         Remoting.instance.gameTable.dealInvite({
            "invitemid":_currentSelectData[3],
            "confirm":_type
         });
      }
      
      private function onDealWithInfoItem(param1:PHPEvent) : void
      {
         Application.instance.log("处理邀请信息",param1.param as String);
         var _loc2_:Object = JSON.parse(param1.param as String);
         if(_loc2_.ret == 0)
         {
            deleteItemInArr();
            setData(_totalArr);
            _list.invalidate();
            _numCircle.setNum(_totalArr.length);
            if(_type == 0)
            {
               PlayerDataList.instance.selfData.cid = _loc2_.list;
               TextTip.instance.showByLang("unionInvitedTip1");
               UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_VIEW_CHANGE));
               this.removeFromParent(true);
            }
         }
         else if(_loc2_.ret == 1111)
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("unionPeopleFull"));
         }
         else if(_loc2_.ret == 1213)
         {
            TextTip.instance.show(LangManager.getLang.getLangByStr("acceptOverRecruitPeople"));
         }
      }
      
      private function deleteItemInArr() : void
      {
         var _loc1_:int = int(_totalArr.indexOf(_currentSelectData));
         if(_loc1_ != -1)
         {
            _totalArr.splice(_loc1_,1);
         }
      }
      
      public function setData(param1:Array) : void
      {
         _list.dataProvider = new ListCollection(param1);
         _totalArr = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         EventCenter.PHPEvent.removeEventListener("dealInvite",onDealWithInfoItem);
      }
   }
}

import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import org.osflash.signals.Signal;
import starling.display.Button;
import starling.display.Image;
import starling.text.TextField;

class UnionInvitedItemRender extends ListItemRenderer
{
   
   public static var selectSignal:Signal = new Signal(int);
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _btn:Button;
   
   private var _btnTexArr:Array = [];
   
   public function UnionInvitedItemRender()
   {
      super();
      selectSignal.add(onSelectHandle);
   }
   
   private function onSelectHandle(param1:int) : void
   {
      _btn.upState = _btnTexArr[0];
      _btn.downState = _btnTexArr[1];
      if(index == param1)
      {
         _btn.upState = _btn.downState;
      }
   }
   
   override protected function initialize() : void
   {
      super.initialize();
      _asset = Assets.sAsset;
      this.bgFocusTexture = Assets.emptyTexture();
      this.bgNormalTexture = Assets.emptyTexture();
      this.bg = new Image(Assets.emptyTexture());
      this.addChild(this.bg);
      this.bg.width = 696;
      this.bg.height = 64;
      _layout = new LayoutUitl(_asset.getOther("unionApply"),_asset);
      _layout.buildLayout("invitedItemLayout",this);
      _btn = getChildByName("smallBtn") as Button;
      _btnTexArr = [_btn.upState,_btn.downState];
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      var _loc1_:Array = this._data as Array;
      (this.getChildByName("UnionName") as TextField).text = _loc1_[1] + "";
      (this.getChildByName("inviteTime") as TextField).text = _loc1_[0] + "";
   }
}
