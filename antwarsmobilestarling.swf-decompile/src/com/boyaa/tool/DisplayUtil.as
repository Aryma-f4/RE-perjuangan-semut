package com.boyaa.tool
{
   import feathers.controls.TextInput;
   import starling.display.Sprite;
   import starling.text.TextField;
   
   public class DisplayUtil
   {
      
      public function DisplayUtil()
      {
         super();
      }
      
      public static function replace(param1:Sprite, param2:Sprite, param3:Boolean = false) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
         param2.parent.addChild(param1);
         if(param3)
         {
            param2.removeFromParent();
         }
         else
         {
            param2.visible = false;
         }
      }
      
      public static function createInputTextByTextField(param1:TextField) : TextInput
      {
         var _loc2_:TextInput = new TextInput();
         _loc2_.textEditorProperties.fontFamily = param1.fontName;
         _loc2_.textEditorProperties.color = param1.color;
         _loc2_.textEditorProperties.fontSize = param1.fontSize;
         _loc2_.width = param1.width;
         _loc2_.height = param1.height;
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         return _loc2_;
      }
   }
}

