package com.boyaa.antwars.view.character
{
   import com.boyaa.antwars.view.game.ICharacterCtrl;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   
   public class ShowBadState
   {
      
      private var _characterCtrl:ICharacterCtrl;
      
      private var _spirte:Sprite;
      
      private var _image:Image;
      
      private var count:Number = 0;
      
      public function ShowBadState(param1:ICharacterCtrl)
      {
         super();
         _characterCtrl = param1;
         init();
      }
      
      private function init() : void
      {
         _spirte = new Sprite();
      }
      
      public function showBadStateImg(param1:String) : void
      {
         var type:String = param1;
         switch(type)
         {
            case "palsy":
               _image = new Image(Assets.sAsset.getTexture("麻痹"));
               break;
            case "chain":
               _image = new Image(Assets.sAsset.getTexture("枷锁"));
               break;
            default:
               if(_image)
               {
                  dispose();
               }
         }
         if(_image)
         {
            _image.pivotX = _image.width >> 1;
            _image.pivotY = _image.height >> 1;
            _image.width = _image.height = 50;
            _characterCtrl.gameworld.ctrlInfoLayer.addChild(_image);
            Starling.juggler.tween(_image,0.5,{
               "transition":"easeIn",
               "onComplete":function():void
               {
                  _image.addEventListener("enterFrame",update);
               }
            });
         }
      }
      
      private function update() : void
      {
         if(_image)
         {
            _image.x = _characterCtrl.icharacter.x;
            _image.y = _characterCtrl.icharacter.y - _image.height * 2.5;
         }
      }
      
      public function dispose() : void
      {
         _image.visible = false;
         _image.removeFromParent(true);
         _image.removeEventListener("enterFrame",update);
         _image = null;
      }
   }
}

