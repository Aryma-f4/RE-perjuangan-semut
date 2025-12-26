package com.boyaa.antwars.view.ui
{
   import com.boyaa.antwars.view.display.ClickSprite;
   import starling.display.Image;
   import starling.events.Event;
   
   public class Radio extends ClickSprite
   {
      
      private var _data:Boolean;
      
      private var bg:Image;
      
      private var _item:Object;
      
      public function Radio(param1:Object = null)
      {
         super();
         bg = new Image(Assets.sAsset.getTexture("dx0"));
         addChild(bg);
         _item = param1;
         this.addEventListener("triggered",onClick);
      }
      
      public function set data(param1:Boolean) : void
      {
         if(_data == param1)
         {
            return;
         }
         _data = param1;
         if(_data)
         {
            bg.texture = Assets.sAsset.getTexture("dx1");
         }
         else
         {
            bg.texture = Assets.sAsset.getTexture("dx0");
         }
      }
      
      public function get item() : Object
      {
         return _item;
      }
      
      public function get data() : Boolean
      {
         return _data;
      }
      
      private function onClick(param1:Event) : void
      {
         data = data ? false : true;
      }
   }
}

