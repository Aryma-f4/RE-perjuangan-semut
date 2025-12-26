package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.SystemTip;
   import com.boyaa.antwars.view.screen.union.UnionEvent;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   import starling.display.Button;
   import starling.events.Event;
   
   public class UnionManagerStepDownDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _memberList:List;
      
      private var _unionManagerSubmitBtn:Button;
      
      private var _currentPlayer:PlayerData;
      
      private var _callBack:Function;
      
      public function UnionManagerStepDownDlg(param1:Array, param2:Function)
      {
         _callBack = param2;
         super("unionManagerFireLayout");
         _memberList = new List();
         _memberList.width = 700;
         _memberList.height = 240;
         _memberList.x = 27;
         _memberList.y = 130;
         _displayObj.addChild(_memberList);
         _memberList.itemRendererType = UnionManagerStepDownItemRender;
         _memberList.dataProvider = new ListCollection(param1);
         _unionManagerSubmitBtn = getButtonByName("btnS_unionManagerSubmitBtn");
         _unionManagerSubmitBtn.addEventListener("triggered",unionManagerSubmitHandel);
         UnionManager.getInstance().addEventListener(UnionEvent.STEPDOWN_ITEM_RENDER_SELECT,selectHandel);
      }
      
      private function selectHandel(param1:UnionEvent) : void
      {
         _currentPlayer = param1.eventData as PlayerData;
      }
      
      private function unionManagerSubmitHandel(param1:Event) : void
      {
         SystemTip.instance.showSystemAlert(LangManager.getLang.getreplaceLang("stepDownSure",_currentPlayer.babyName),makeSureHandler,null);
      }
      
      private function makeSureHandler() : void
      {
         if(_currentPlayer == null)
         {
            TextTip.instance.showByLang("appointVicechairman");
            return;
         }
         LoadData.show(this);
         var _loc1_:Array = [_currentPlayer.uid,4];
         EventCenter.PHPEvent.addEventListener("manageUnionMember",managerUnionMemberHandler);
         Remoting.instance.gameTable.manageUnionMember(_loc1_);
      }
      
      private function managerUnionMemberHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            this.deactive();
            TextTip.instance.showByLang("stepDownChairman");
            _callBack();
         }
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.data.model.PlayerData;
import com.boyaa.antwars.view.screen.union.UnionEvent;
import com.boyaa.antwars.view.screen.union.commonBtn.UnionCheckBoxEvent;
import com.boyaa.antwars.view.screen.union.commonBtn.UnionManagerCheckBox;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;

class UnionManagerStepDownItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _selectCheckBox:Sprite;
   
   private var _checkBox:UnionManagerCheckBox;
   
   private var _playerNameTF:TextField;
   
   public function UnionManagerStepDownItemRender()
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
      _checkBox = new UnionManagerCheckBox();
      _checkBox.x = 273;
      _checkBox.y = 12;
      _checkBox.addEventListener(UnionCheckBoxEvent.SELECT,itemSelect);
      this.addChild(_checkBox);
      _playerNameTF = new TextField(200,40,"","Verdana",32,16777215);
      _playerNameTF.x = 330;
      _playerNameTF.y = 12;
      this.addChild(_playerNameTF);
      UnionManager.getInstance().addEventListener(UnionEvent.STEPDOWN_ITEM_RENDER_CLEAR,clearSelectHandel);
   }
   
   private function itemSelect(param1:UnionCheckBoxEvent) : void
   {
      UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.STEPDOWN_ITEM_RENDER_CLEAR));
      UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.STEPDOWN_ITEM_RENDER_SELECT,this._data));
      _checkBox.select = true;
   }
   
   private function clearSelectHandel(param1:UnionEvent) : void
   {
      _checkBox.select = false;
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      _playerNameTF.text = (this._data as PlayerData).babyName;
   }
   
   override public function dispose() : void
   {
      UnionManager.getInstance().removeEventListener(UnionEvent.STEPDOWN_ITEM_RENDER_CLEAR,clearSelectHandel);
   }
}
