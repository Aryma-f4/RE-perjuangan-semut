package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.UnionListItemModel;
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.view.BaseDlg;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Button;
   import starling.events.Event;
   
   public class UnionManagerLittleBaseDlg extends BaseDlg
   {
      
      protected var _asset:ResAssetManager;
      
      protected var _layout:LayoutUitl;
      
      protected var _closeBtn:Button;
      
      protected var _unionData:UnionListItemModel = UnionManager.getInstance().myUnionModel;
      
      public function UnionManagerLittleBaseDlg(param1:String)
      {
         super(true);
         _asset = Assets.sAsset;
         _layout = new LayoutUitl(_asset.getOther("UnionOffice"),_asset);
         _layout.buildLayout(param1,_displayObj);
         _closeBtn = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         _closeBtn.scaleX = _closeBtn.scaleY = 0.9;
         _closeBtn.x = _displayObj.width - 80;
         _closeBtn.y = 10;
         _closeBtn.addEventListener("triggered",onclose);
         _displayObj.addChild(_closeBtn);
         SmallCodeTools.instance.setDisplayObjectInStageMiddle(_displayObj);
      }
      
      protected function onclose(param1:Event) : void
      {
         this.deactive();
      }
   }
}

