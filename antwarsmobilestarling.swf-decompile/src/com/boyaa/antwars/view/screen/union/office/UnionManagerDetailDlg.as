package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.tool.LoadData;
   import feathers.controls.List;
   import feathers.data.ListCollection;
   
   public class UnionManagerDetailDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _detailList:List;
      
      public function UnionManagerDetailDlg()
      {
         super("unionManagerDetailLayout");
         _detailList = new List();
         _detailList.width = 700;
         _detailList.height = 240;
         _detailList.x = 33;
         _detailList.y = 132;
         _displayObj.addChild(_detailList);
         _detailList.itemRendererType = UnionManagerDetailItemRender;
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("unionThingsNote",seeSelfDevoteDetailHandler);
         Remoting.instance.gameTable.unionThingsNote();
      }
      
      private function seeSelfDevoteDetailHandler(param1:PHPEvent) : void
      {
         var _loc6_:Object = null;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         Application.instance.log("公会明细",param1.param as String);
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         Application.instance.log("unionThinsNote",param1.param as String);
         var _loc5_:Object = JSON.parse(param1.param as String);
         var _loc4_:Array = [];
         if(_loc5_.ret == 0)
         {
            if(_loc5_.list.length == 0)
            {
               TextTip.instance.showByLang("noSeeContributeDetail");
            }
            for each(var _loc3_ in _loc5_.list)
            {
               _loc4_.push(_loc3_);
            }
            _loc8_ = 0;
            while(_loc8_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc8_];
               _loc7_ = _loc8_ + 1;
               while(_loc7_ < _loc4_.length)
               {
                  if(_loc4_[_loc8_].etime < _loc4_[_loc7_].etime)
                  {
                     _loc6_ = _loc4_[_loc8_];
                     _loc4_[_loc8_] = _loc4_[_loc7_];
                     _loc4_[_loc7_] = _loc6_;
                  }
                  _loc7_++;
               }
               _loc8_++;
            }
            _detailList.dataProvider = new ListCollection(_loc4_);
         }
         else if(_loc5_.ret == 100)
         {
            TextTip.instance.showByLang("contributeDetailTips");
         }
      }
   }
}

import com.boyaa.antwars.helper.AnalysisPHPTimeData;
import com.boyaa.antwars.view.ui.ListItemRenderer;
import com.boyaa.antwars.view.ui.layout.LayoutUitl;
import starling.display.Image;
import starling.text.TextField;

class UnionManagerDetailItemRender extends ListItemRenderer
{
   
   private var _layout:LayoutUitl;
   
   private var _asset:ResAssetManager;
   
   public function UnionManagerDetailItemRender()
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
      _layout.buildLayout("unionManagerDetailItemLayout",this);
   }
   
   override protected function commitData() : void
   {
      super.commitData();
      if(!this._data)
      {
         return;
      }
      (this.getChildByName("titleTF") as TextField).text = this._data.econtent;
      (this.getChildByName("dateTF") as TextField).text = AnalysisPHPTimeData.getDataString("-",this._data.etime);
   }
}
