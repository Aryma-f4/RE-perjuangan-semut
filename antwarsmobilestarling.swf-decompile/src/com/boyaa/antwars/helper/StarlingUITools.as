package com.boyaa.antwars.helper
{
   import feathers.controls.TextInput;
   import feathers.controls.text.TextFieldTextEditor;
   import feathers.core.ITextEditor;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.filters.ColorMatrixFilter;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class StarlingUITools
   {
      
      private static var _instance:StarlingUITools = null;
      
      private var _starlingButtonArr:Array = [];
      
      public function StarlingUITools(param1:Single)
      {
         super();
      }
      
      public static function get instance() : StarlingUITools
      {
         if(_instance == null)
         {
            _instance = new StarlingUITools(new Single());
         }
         return _instance;
      }
      
      public function createInputByTextField(param1:TextField, param2:int = -1) : TextInput
      {
         var textField:TextField = param1;
         var maxChar:int = param2;
         var input:TextInput = new TextInput();
         SmallCodeTools.instance.setDisplayObjectInSame(textField,input);
         textField.parent.addChild(input);
         textField.visible = false;
         input.verticalAlign = "justify";
         input.textEditorFactory = (function():*
         {
            var textEditor:Function;
            return textEditor = function():ITextEditor
            {
               var _loc1_:TextFieldTextEditor = new TextFieldTextEditor();
               _loc1_.textFormat = new TextFormat(textField.fontName,textField.fontSize,textField.color,textField.bold);
               return _loc1_;
            };
         })();
         if(maxChar != -1)
         {
            input.maxChars = maxChar;
         }
         return input;
      }
      
      public function createTextField(param1:String, param2:Number, param3:Number, param4:int = 200, param5:int = 35) : TextField
      {
         var _loc6_:TextField = new TextField(param4,param5,param1,"Verdana",24);
         _loc6_.vAlign = "center";
         _loc6_.x = param2;
         _loc6_.y = param3;
         _loc6_.autoScale = true;
         return _loc6_;
      }
      
      public function getDropShadowFilter(param1:uint = 0, param2:int = 20, param3:Number = 0, param4:Number = 45, param5:Number = 1) : Array
      {
         var _loc6_:DropShadowFilter = new DropShadowFilter(param3,param4,param1,param5,3.2,3.2,param2);
         return [_loc6_];
      }
      
      public function getGlowFilter(param1:uint = 16777215, param2:Number = 1, param3:Number = 6, param4:Number = 6, param5:Number = 10, param6:Number = 1) : Array
      {
         var _loc7_:GlowFilter = new GlowFilter(param1,param2,param3,param4,param5,param6);
         var _loc8_:Array = [];
         _loc8_.push(_loc7_);
         return _loc8_;
      }
      
      public function getGrayFilter() : ColorMatrixFilter
      {
         var _loc1_:ColorMatrixFilter = new ColorMatrixFilter();
         _loc1_.adjustSaturation(-1);
         return _loc1_;
      }
      
      public function initStarlingButton(param1:Sprite, param2:String, param3:Function) : Button
      {
         var _loc4_:Button = param1.getChildByName(param2) as Button;
         _loc4_.addEventListener("triggered",param3);
         _starlingButtonArr.push([_loc4_,"triggered",param3]);
         return _loc4_;
      }
      
      public function removeStarlingButton(param1:Button) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Array = null;
         _loc3_ = 0;
         while(_loc3_ < _starlingButtonArr.length)
         {
            _loc2_ = _starlingButtonArr[_loc3_];
            if(_loc2_[0] == param1)
            {
               param1.removeEventListener(_loc2_[1],_loc2_[2]);
               _starlingButtonArr.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      public function removeStarlingButtonsListener(param1:Array) : void
      {
         for each(var _loc2_ in param1)
         {
            removeStarlingButton(_loc2_);
         }
      }
      
      public function drawSector(param1:Graphics, param2:Number = 0, param3:Number = 0, param4:Number = 100, param5:Number = 0, param6:Number = 0) : void
      {
         var _loc7_:int = 0;
         var _loc14_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc13_:int = 0;
         param1.moveTo(param2,param3);
         if(Math.abs(param6) > 3.141592653589793 * 2)
         {
            param1.drawCircle(param2,param3,param4);
         }
         else
         {
            _loc7_ = Math.ceil(Math.abs(param6) * 4 / 3.141592653589793);
            _loc14_ = param6 / _loc7_;
            param1.lineTo(param2 + param4 * Math.cos(param5),param3 + param4 * Math.sin(param5));
            _loc13_ = 0;
            while(_loc13_ < _loc7_)
            {
               param5 += _loc14_;
               _loc8_ = param5 - _loc14_ * 0.5;
               _loc12_ = param2 + param4 * Math.cos(_loc8_) / Math.cos(_loc14_ * 0.5);
               _loc10_ = param3 + param4 * Math.sin(_loc8_) / Math.cos(_loc14_ * 0.5);
               _loc11_ = param2 + param4 * Math.cos(param5);
               _loc9_ = param3 + param4 * Math.sin(param5);
               param1.curveTo(_loc12_,_loc10_,_loc11_,_loc9_);
               _loc13_++;
            }
            param1.lineTo(param2,param3);
         }
      }
      
      public function drawRect(param1:DisplayObject, param2:uint = 255, param3:Number = 0.7) : Image
      {
         var _loc8_:Rectangle = null;
         var _loc6_:Image = null;
         var _loc5_:Point = new Point(param1.x,param1.y);
         if(param1.parent)
         {
            _loc5_ = param1.parent.localToGlobal(new Point(param1.x,param1.y));
         }
         _loc8_ = new Rectangle(_loc5_.x,_loc5_.y,param1.width,param1.height);
         var _loc7_:Shape = new Shape();
         _loc7_.graphics.clear();
         _loc7_.graphics.beginFill(param2,param3);
         _loc7_.graphics.drawRect(_loc8_.x,_loc8_.y,_loc8_.width,_loc8_.height);
         _loc7_.graphics.endFill();
         var _loc4_:BitmapData = new BitmapData(_loc7_.width,_loc7_.height,true,0);
         _loc4_.draw(_loc7_);
         _loc6_ = new Image(Texture.fromBitmapData(_loc4_));
         _loc6_.touchable = false;
         Application.instance.currentGame.addChild(_loc6_);
         return _loc6_;
      }
   }
}

class Single
{
   
   public function Single()
   {
      super();
   }
}
