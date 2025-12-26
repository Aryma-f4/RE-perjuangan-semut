package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.data.UnionMessageItemModel;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UnionMessageReadDlg extends BaseDlg
   {
      
      private var _itemData:UnionMessageItemModel;
      
      private var _closeBtn:Button;
      
      public function UnionMessageReadDlg(param1:UnionMessageItemModel)
      {
         _itemData = param1;
         super(true);
         var _loc3_:ResAssetManager = Assets.sAsset;
         var _loc2_:LayoutUitl = new LayoutUitl(_loc3_.getOther("UnionMessage"),_loc3_);
         _loc2_.buildLayout("unionSendMessageLayOut",_displayObj);
         (_displayObj.getChildByName("btnS_unionSendMessageBtn") as Button).visible = false;
         (_displayObj.getChildByName("titleTF") as TextField).text = _itemData.mTitle;
         (_displayObj.getChildByName("contentTF") as TextField).text = _itemData.mContent;
         _closeBtn = _displayObj.getChildByName("btnS_close") as Button;
         _closeBtn.addEventListener("triggered",closeHandel);
         setDisplayObjectInMiddle();
      }
      
      private function closeHandel(param1:Event) : void
      {
         this.deactive();
      }
   }
}

