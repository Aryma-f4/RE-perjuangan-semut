package com.boyaa.tool
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Tiptext
   {
      
      private var display:TextField = null;
      
      public function Tiptext(param1:String, param2:Number = 1.5, param3:int = 0, param4:int = 0)
      {
         var view:Sprite;
         var str:String = param1;
         var time:Number = param2;
         var _x:int = param3;
         var _y:int = param4;
         super();
         view = createTip(str);
         Application.instance.currentMain.stage.addChild(view);
         TweenLite.to(view,1,{
            "alpha":0,
            "delay":time,
            "onComplete":function():void
            {
               display.text = "";
               view.parent && view.parent.removeChild(view);
               ContainerClear.removeAllChild(view);
            }
         });
      }
      
      private function createTip(param1:String) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         _loc3_.graphics.beginFill(0,0.5);
         _loc3_.graphics.drawRect(0,0,Application.instance.viewPort.width,Application.instance.viewPort.height * 0.1);
         _loc3_.graphics.endFill();
         _loc3_.x = Application.instance.viewPort.x;
         _loc3_.y = (Application.instance.viewPort.height - Application.instance.viewPort.height * 0.1) / 2;
         display = new TextField();
         display.textColor = 16777215;
         display.autoSize = "center";
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.size = 25;
         display.defaultTextFormat = _loc2_;
         display.text = param1;
         display.x = Application.instance.viewPort.width - display.textWidth >> 1;
         display.y = (display.textHeight >> 1) + 5;
         _loc3_.addChild(display);
         return _loc3_;
      }
   }
}

