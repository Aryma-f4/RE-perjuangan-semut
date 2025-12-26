package com.boyaa.antwars.view.screen.chatRoom
{
   import com.boyaa.antwars.helper.Timepiece;
   import com.boyaa.antwars.view.character.Character;
   import flash.geom.Rectangle;
   import starling.display.Quad;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class BtChatBox extends Sprite
   {
      
      private var _boxBg:Quad;
      
      private var _txt:TextField;
      
      private var MAX_WIDTH:int = 300;
      
      private var MAX_HEIGHT:int = 400;
      
      private var _bgColor:uint;
      
      private var _txtColor:uint;
      
      private var _playerSite:int;
      
      private var _character:Character;
      
      private var _position:Rectangle;
      
      private var _str:String;
      
      public function BtChatBox(param1:int, param2:Character, param3:Rectangle)
      {
         super();
         _playerSite = param1;
         _character = param2;
         _position = param3;
         init();
      }
      
      private function init() : void
      {
         _boxBg = new Quad(200,200,0,true);
         _boxBg.alpha = 0.7;
         _txt = new TextField(400,400,"","Verdana",24);
         _txt.autoScale = true;
         _txt.alignPivot("left","top");
         _txt.color = 16777215;
      }
      
      public function setText(param1:String) : void
      {
         removeText();
         addEvent();
         _txt.width = 400;
         _txt.height = 400;
         _txt.text = param1;
         if(_txt.textBounds.width >= MAX_WIDTH)
         {
            _boxBg.width = MAX_WIDTH;
            _txt.width = MAX_WIDTH;
         }
         else
         {
            _boxBg.width = _txt.textBounds.width;
            _txt.width = _txt.textBounds.width;
         }
         if(_txt.textBounds.height >= MAX_HEIGHT)
         {
            _boxBg.height = MAX_HEIGHT;
            _txt.height = MAX_HEIGHT;
         }
         else
         {
            _boxBg.height = _txt.textBounds.height + 5;
            _txt.height = _txt.textBounds.height;
         }
         _txt.x = _boxBg.x;
         _txt.y = _boxBg.y;
         addChild(_boxBg);
         addChild(_txt);
         _txt.alignPivot("left","top");
         _str = param1;
         var _loc2_:int = 1;
         var _loc3_:int = _position.x + 80;
         if(_position.x > 1365 / 2)
         {
            _loc3_ = _position.x;
            _loc2_ = 0;
         }
         this.x = _loc3_ - _txt.width * _loc2_;
         this.y = 120;
      }
      
      private function addEvent() : void
      {
         Timepiece.instance.addTimerFun(removeText,5000);
      }
      
      private function removeText() : void
      {
         _txt.removeFromParent(true);
         _boxBg.removeFromParent(true);
         Timepiece.instance.removeFun(removeText,1);
      }
      
      public function get playerSite() : int
      {
         return _playerSite;
      }
      
      public function get character() : Character
      {
         return _character;
      }
   }
}

