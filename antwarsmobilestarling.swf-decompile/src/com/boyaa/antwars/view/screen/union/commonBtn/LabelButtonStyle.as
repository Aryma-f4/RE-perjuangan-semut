package com.boyaa.antwars.view.screen.union.commonBtn
{
   public class LabelButtonStyle
   {
      
      public static var YELLOW:String = "yellow";
      
      public static var GREEN:String = "green";
      
      public static var YELLOW_STYLE:LabelButtonStyle = new LabelButtonStyle("s9_YellowBtn","s9_YellowOverBtn");
      
      public static var GREEN_STYLE:LabelButtonStyle = new LabelButtonStyle("s9_GreenBtn","s9_GreenOverBtn");
      
      private var _commonImg:String;
      
      private var _overImg:String;
      
      private var _fontSize:int;
      
      private var _fontColor:uint;
      
      private var _fontFamily:String;
      
      public function LabelButtonStyle(param1:String, param2:String, param3:int = 30, param4:uint = 16777215, param5:String = "Verdana")
      {
         super();
         _commonImg = param1;
         _overImg = param2;
         _fontSize = param3;
         _fontColor = param4;
         _fontFamily = param5;
      }
      
      public function get commonImg() : String
      {
         return _commonImg;
      }
      
      public function get overImg() : String
      {
         return _overImg;
      }
      
      public function get fontColor() : uint
      {
         return _fontColor;
      }
      
      public function get fontFamily() : String
      {
         return _fontFamily;
      }
      
      public function get fontSize() : int
      {
         return _fontSize;
      }
      
      public function set fontSize(param1:int) : void
      {
         _fontSize = param1;
      }
   }
}

