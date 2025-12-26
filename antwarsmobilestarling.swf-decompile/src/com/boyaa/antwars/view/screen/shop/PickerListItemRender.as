package com.boyaa.antwars.view.screen.shop
{
   import com.boyaa.antwars.view.ui.layout.LayoutUitl;
   import feathers.controls.renderers.DefaultListItemRenderer;
   import flash.text.TextFormat;
   import starling.display.Image;
   import starling.text.TextField;
   
   public class PickerListItemRender extends DefaultListItemRenderer
   {
      
      private var txtName:TextField;
      
      private var _asset:ResAssetManager;
      
      private var _layout:LayoutUitl;
      
      public function PickerListItemRender()
      {
         super();
         _asset = Assets.sAsset;
         defaultSkin = new Image(_asset.getTexture("btnS_pickerListItem1"));
         defaultSelectedSkin = new Image(_asset.getTexture("btnS_pickerListItem2"));
         downSkin = new Image(_asset.getTexture("btnS_pickerListItem2"));
         defaultLabelProperties.textFormat = new TextFormat("Verdana",24,16777164);
      }
   }
}

