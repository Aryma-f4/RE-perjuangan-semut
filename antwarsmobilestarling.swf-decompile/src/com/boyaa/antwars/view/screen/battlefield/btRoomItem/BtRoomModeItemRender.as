package com.boyaa.antwars.view.screen.battlefield.btRoomItem
{
   import com.boyaa.antwars.helper.SmallCodeTools;
   import com.boyaa.antwars.helper.tools.FashionStarlingButton;
   import com.boyaa.antwars.view.ui.LayoutListItemRender;
   import starling.display.Button;
   import starling.display.Quad;
   import starling.text.TextField;
   
   public class BtRoomModeItemRender extends LayoutListItemRender
   {
      
      private var _text:TextField;
      
      private var _quad:Quad;
      
      private var _button:FashionStarlingButton;
      
      public function BtRoomModeItemRender()
      {
         super();
      }
      
      override protected function selectDraw() : void
      {
         super.selectDraw();
         if(isSelected)
         {
            _text.color = 0;
            _button.isSelect = true;
         }
         else
         {
            _text.color = 16777215;
            _button.isSelect = false;
         }
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         var _loc1_:Button = new Button(Assets.sAsset.getTexture("img_btHallselectBg1"),"",Assets.sAsset.getTexture("img_btHallselectBg2"));
         _button = new FashionStarlingButton(_loc1_);
         _displayObject.addChild(_loc1_);
         _text = new TextField(100,30,"");
         SmallCodeTools.instance.setDisplayObjectToCenter(_loc1_,_text);
         _text.fontSize = 20;
         _text.color = 16777215;
         _displayObject.addChild(_text);
         initOriginRenderItems();
      }
      
      override protected function commitData() : void
      {
         super.commitData();
         _text.text = this._data as String;
      }
   }
}

