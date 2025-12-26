package com.boyaa.antwars.view.screen.union
{
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.view.screen.IMainMenu;
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.Screen;
   
   public class UnionScreen extends Screen implements IMainMenu
   {
      
      private var _asset:ResAssetManager;
      
      private var _layoutUitl:LayoutUitl;
      
      private var _unionListDlg:UnionListDlg;
      
      private var _unionMainDlg:UnionMainDlg;
      
      public function UnionScreen()
      {
         super();
         _asset = Assets.sAsset;
         initGameServer();
      }
      
      private function initGameServer() : void
      {
         UnionManager.getInstance().addEventListener(UnionEvent.UNION_VIEW_CHANGE,getUnionInfo);
         UnionManager.getInstance().isHaveUnion();
         UnionManager.getInstance().addEventListener(UnionEvent.UNION_DATA_REFRESH,initView);
      }
      
      private function getUnionInfo(param1:UnionEvent) : void
      {
         if(_unionListDlg)
         {
            _unionListDlg.deactive();
            _unionListDlg.removeFromParent();
            _unionListDlg = null;
         }
         if(_unionMainDlg)
         {
            _unionMainDlg.deactive();
            _unionMainDlg.removeFromParent();
            _unionMainDlg = null;
         }
         UnionManager.getInstance().isHaveUnion();
         UnionManager.getInstance().addEventListener(UnionEvent.UNION_DATA_REFRESH,initView);
      }
      
      private function initView(param1:UnionEvent = null) : void
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         }
         if(UnionManager.getInstance().isHave)
         {
            _unionMainDlg = new UnionMainDlg();
            this.addChild(_unionMainDlg);
            _unionMainDlg.x = 170.5;
            Application.instance.currentGame.mainMenu.show(this);
         }
         else
         {
            _unionListDlg = new UnionListDlg();
            this.addChild(_unionListDlg);
            _unionListDlg.x = 170.5;
         }
         UnionManager.getInstance().addEventListener(UnionEvent.GOTO_HALL,gotoHallHandel);
      }
      
      private function gotoHallHandel(param1:UnionEvent) : void
      {
         removeEvent();
         this.dispatchEventWith("complete");
      }
      
      private function removeEvent() : void
      {
         UnionManager.getInstance().removeEventListener(UnionEvent.GOTO_HALL,gotoHallHandel);
         UnionManager.getInstance().removeEventListener(UnionEvent.UNION_VIEW_CHANGE,getUnionInfo);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         Assets.sAsset.removeTextureAtlas("UnionMain");
         Assets.sAsset.removeTextureAtlas("unionBg");
         Assets.sAsset.removeTextureAtlas("UnionOffice");
         Assets.sAsset.removeTextureAtlas("unionApply");
         Assets.sAsset.removeTextureAtlas("UnionMessage");
         Assets.sAsset.removeTextureAtlas("UnionWorship");
         Assets.sAsset.removeTextureAtlas("UnionStore");
         Assets.sAsset.removeTextureAtlas("warehouse");
      }
      
      public function exit() : void
      {
      }
   }
}

