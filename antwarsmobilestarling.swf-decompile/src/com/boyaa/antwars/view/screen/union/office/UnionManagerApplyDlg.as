package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.model.PlayerData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.net.Remoting;
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
   
   public class UnionManagerApplyDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _applyList:List;
      
      private var _unionManagerApplyListOk:Button;
      
      private var _unionManagerApplyListDel:Button;
      
      private var _selectMids:Array;
      
      private var _dataItems:Array;
      
      private var _isAccept:Boolean = false;
      
      private var _selectCheckBox:Sprite;
      
      private var _callBack:Function;
      
      public function UnionManagerApplyDlg(param1:Function)
      {
         _callBack = param1;
         super("unionManagerApplyListLayout");
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("getNoUnionPlayers",getNoUnionPlayersHandler);
         Remoting.instance.gameTable.getNoUnionPlayers();
         _applyList = new List();
         _applyList.width = 700;
         _applyList.height = 240;
         _applyList.x = 27;
         _applyList.y = 130;
         _displayObj.addChild(_applyList);
         _applyList.itemRendererType = UnionManagerApplyItemRender;
         getDisplayObjByName("unionManagerApplyListBg").touchable = false;
         _unionManagerApplyListOk = getButtonByName("btnS_unionManagerApplyListOk");
         _unionManagerApplyListOk.addEventListener("triggered",acceptHandler);
         _unionManagerApplyListDel = getButtonByName("btnS_unionManagerApplyListDel");
         _unionManagerApplyListDel.addEventListener("triggered",refuseHandler);
         _selectMids = [];
         _selectCheckBox = getSpriteByName("unionManagerCheckBoxSelectAll");
         _selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = false;
         _selectCheckBox.addEventListener("touch",selectCheckBoxHandel);
         UnionManager.getInstance().addEventListener(UnionEvent.UNION_MANAGER_APPLY_ITEM_SELECT,itemSelectChange);
      }
      
      override protected function onclose(param1:Event) : void
      {
         super.onclose(param1);
         _callBack();
      }
      
      private function itemSelectChange(param1:UnionEvent) : void
      {
         var _loc2_:Array = param1.eventData as Array;
         var _loc3_:int = int((_loc2_[1] as PlayerData).uid);
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
            UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_MANAGER_APPLY_TOP_SELECT,_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible));
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
      
      private function acceptHandler(param1:Event) : void
      {
         if(_selectMids.length == 0)
         {
            TextTip.instance.showByLang("selectUnionMember");
            return;
         }
         _isAccept = true;
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("dealUnionApply",dealUnionApplyHandler);
         Remoting.instance.gameTable.dealUnionApply([_selectMids,0]);
      }
      
      private function dealUnionApplyHandler(param1:PHPEvent) : void
      {
         var _loc8_:int = 0;
         var _loc7_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc9_:int = 0;
         var _loc6_:PlayerData = null;
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc5_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc5_.ret == 0)
         {
            _loc7_ = [];
            _loc3_ = [];
            _loc4_ = [];
            _loc9_ = 0;
            if(_loc5_.successlist is Boolean && _loc5_.successlist == false)
            {
               _loc9_ = 0;
               while(_loc9_ < _selectMids.length)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _dataItems.length)
                  {
                     if(_dataItems[_loc8_].uid == _selectMids[_loc9_])
                     {
                        _dataItems.splice(_loc8_,1);
                     }
                     _loc8_++;
                  }
                  _loc9_++;
               }
               TextTip.instance.showByLang("unionPeopleFull");
               return;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc5_.successlist.length)
            {
               _loc6_ = new PlayerData();
               _loc6_.addData(_loc5_.successlist[_loc9_]);
               _loc7_.push(_loc6_);
               _loc4_.push(_loc6_.babyName);
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _selectMids.length)
            {
               _loc8_ = 0;
               while(_loc8_ < _dataItems.length)
               {
                  if(_dataItems[_loc8_].uid == _selectMids[_loc9_])
                  {
                     _dataItems.splice(_loc8_,1);
                  }
                  _loc8_++;
               }
               _loc9_++;
            }
            _applyList.dataProvider = new ListCollection(_dataItems);
            if(_isAccept == true)
            {
               TextTip.instance.showByLang("acceptOK");
            }
            else
            {
               TextTip.instance.showByLang("refuseOK");
            }
         }
         else if(_loc5_.ret == 1213)
         {
            TextTip.instance.showByLang("overRecruitPeople");
         }
         else
         {
            TextTip.instance.showByLang("noRights");
         }
      }
      
      private function refuseHandler(param1:Event) : void
      {
         _isAccept = false;
         if(_selectMids.length == 0)
         {
            TextTip.instance.showByLang("selectUnionMember");
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("dealUnionApply",dealUnionApplyHandler);
         Remoting.instance.gameTable.dealUnionApply([_selectMids,1]);
      }
      
      private function getNoUnionPlayersHandler(param1:PHPEvent) : void
      {
         var _loc5_:int = 0;
         var _loc4_:PlayerData = null;
         Application.instance.log("获取申请加入公会的玩家列表",param1.param as String);
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         _dataItems = [];
         if(_loc3_.ret == 0)
         {
            if(_loc3_.list != false)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.list.length)
               {
                  _loc4_ = new PlayerData();
                  _loc4_.addData(_loc3_.list[_loc5_]);
                  _dataItems.push(_loc4_);
                  _loc5_++;
               }
            }
            _applyList.dataProvider = new ListCollection(_dataItems);
         }
      }
   }
}

import com.boyaa.antwars.control.UnionManager;
import com.boyaa.antwars.data.model.PlayerData;
import com.boyaa.antwars.view.screen.union.UnionEvent;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.text.TextField;

class UnionManagerApplyItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   private var _selectCheckBox:Sprite;
   
   public function UnionManagerApplyItemRender()
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
      UnionManager.getInstance().addEventListener(UnionEvent.UNION_MANAGER_APPLY_TOP_SELECT,topSelectChange);
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
         UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_MANAGER_APPLY_ITEM_SELECT,[_selectCheckBox.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible,this._data]));
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
      (this.getChildByName("nameTF") as TextField).text = (this._data as PlayerData).babyName;
      (this.getChildByName("levelTF") as TextField).text = (this._data as PlayerData).level + "";
      (this.getChildByName("fightTF") as TextField).text = (this._data as PlayerData).totalAblility + "";
   }
   
   override public function dispose() : void
   {
   }
}
