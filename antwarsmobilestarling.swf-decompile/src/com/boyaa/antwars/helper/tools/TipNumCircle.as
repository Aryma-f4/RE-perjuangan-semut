package com.boyaa.antwars.helper.tools
{
   import com.boyaa.antwars.helper.StarlingUITools;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Shape;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class TipNumCircle extends Sprite
   {
      
      private var _num:int = 0;
      
      private var _text:TextField;
      
      private var _redCircle:Image;
      
      private var _whiteCircle:Shape;
      
      private const OFFIST:int = 3;
      
      public function TipNumCircle()
      {
         super();
         init();
      }
      
      private function init() : void
      {
         _text = StarlingUITools.instance.createTextField(_num.toString(),0,0,30,30);
         _text.color = 16777215;
         _text.bold = true;
         setNum(0);
         _redCircle = new Image(Assets.sAsset.getTexture("numCircleBg"));
         _redCircle.width = _redCircle.height = 36;
         addChild(_redCircle);
         addChild(_text);
         _text.x += 2;
         _text.y += 2;
      }
      
      private function getCircle(param1:uint, param2:Number, param3:Number = 1) : Shape
      {
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(param1,param3);
         _loc4_.graphics.drawCircle(param2,param2,param2);
         _loc4_.graphics.endFill();
         _loc4_.blendMode = "none";
         return _loc4_;
      }
      
      public function setNum(param1:int) : void
      {
         _num = param1;
         if(_num >= 99)
         {
            _num = 99;
         }
         _text.text = _num.toString();
         if(_num <= 0)
         {
            this.visible = false;
         }
         else
         {
            this.visible = true;
         }
      }
      
      public function setParent(param1:DisplayObjectContainer) : void
      {
         param1.addChild(this);
         this.x = param1.width - _text.width;
         this.y = -this.height / 2;
      }
   }
}

