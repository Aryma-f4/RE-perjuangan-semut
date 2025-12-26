package com.boyaa.antwars.view.screen.union.commonBtn
{
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import starling.display.Sprite;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class UnionManagerCheckBox extends Sprite
   {
      
      public static var SELECT_CHANGE:String = "SELECT_CHANGE";
      
      private var _layout:LayoutUitl;
      
      private var _asset:ResAssetManager;
      
      private var _select:Boolean;
      
      public function UnionManagerCheckBox()
      {
         super();
         _select = false;
         _asset = Assets.sAsset;
         _layout = new LayoutUitl(_asset.getOther("UnionOffice"),_asset);
         _layout.buildLayout("unionManagerCheckBoxSelectAll",this);
         this.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = false;
         this.addEventListener("touch",selectCheckBoxHandel);
      }
      
      private function selectCheckBoxHandel(param1:TouchEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         var _loc2_:Touch = param1.getTouch(this);
         if(_loc2_ && _loc2_.phase == "began")
         {
            this.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = !this.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible;
            dispatchEvent(new UnionCheckBoxEvent(UnionCheckBoxEvent.SELECT));
            return;
         }
      }
      
      public function get select() : Boolean
      {
         return _select;
      }
      
      public function set select(param1:Boolean) : void
      {
         _select = param1;
         this.getChildByName("unionManagerCheckBoxSelectAllselectIcon").visible = param1;
      }
   }
}

