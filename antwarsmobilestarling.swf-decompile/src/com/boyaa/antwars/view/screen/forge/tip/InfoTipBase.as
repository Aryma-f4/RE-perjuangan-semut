package com.boyaa.antwars.view.screen.forge.tip
{
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class InfoTipBase extends Sprite
   {
      
      private var _scale9Image:Scale9Image;
      
      private var _scale9PicName:String = "tips_scale9";
      
      protected var _view:Sprite;
      
      private var _text:TextField;
      
      private const OFFIST:int = 5;
      
      public function InfoTipBase()
      {
         super();
         initUI();
      }
      
      protected function initUI() : void
      {
         _scale9Image = new Scale9Image(new Scale9Textures(Assets.sAsset.getTexture(_scale9PicName),new Rectangle(26,26,20,20)),Assets.sAsset.scaleFactor);
         addChild(_scale9Image);
         _scale9Image.width = 80;
         _scale9Image.height = 80;
         _text = new TextField(400,100,"");
         _text.color = 16777215;
         _text.fontSize = 20;
         _text.hAlign = "left";
         _text.vAlign = "top";
         _text.x = 5;
         _text.y = 5;
         addChild(_text);
         this.touchable = false;
      }
      
      public function remove() : void
      {
         this.removeFromParent(true);
      }
      
      public function update(param1:String) : void
      {
         if(param1 == "")
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
         }
         _text.text = param1;
         _scale9Image.width = _text.textBounds.width + 5 * 3;
         _scale9Image.height = _text.textBounds.height + 5 * 3;
      }
   }
}

