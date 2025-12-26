package feathers.controls
{
   import feathers.controls.supportClasses.TextFieldViewPort;
   import feathers.core.IFocusDisplayObject;
   import feathers.skins.IStyleProvider;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class ScrollText extends Scroller implements IFocusDisplayObject
   {
      
      public static const SCROLL_POLICY_AUTO:String = "auto";
      
      public static const SCROLL_POLICY_ON:String = "on";
      
      public static const SCROLL_POLICY_OFF:String = "off";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FLOAT:String = "float";
      
      public static const SCROLL_BAR_DISPLAY_MODE_FIXED:String = "fixed";
      
      public static const SCROLL_BAR_DISPLAY_MODE_NONE:String = "none";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_RIGHT:String = "right";
      
      public static const VERTICAL_SCROLL_BAR_POSITION_LEFT:String = "left";
      
      public static const INTERACTION_MODE_TOUCH:String = "touch";
      
      public static const INTERACTION_MODE_MOUSE:String = "mouse";
      
      public static const INTERACTION_MODE_TOUCH_AND_SCROLL_BARS:String = "touchAndScrollBars";
      
      public static const DECELERATION_RATE_NORMAL:Number = 0.998;
      
      public static const DECELERATION_RATE_FAST:Number = 0.99;
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var textViewPort:TextFieldViewPort;
      
      protected var _text:String = "";
      
      protected var _isHTML:Boolean = false;
      
      protected var _textFormat:TextFormat;
      
      protected var _disabledTextFormat:TextFormat;
      
      protected var _styleSheet:StyleSheet;
      
      protected var _embedFonts:Boolean = false;
      
      private var _antiAliasType:String = "advanced";
      
      private var _background:Boolean = false;
      
      private var _backgroundColor:uint = 16777215;
      
      private var _border:Boolean = false;
      
      private var _borderColor:uint = 0;
      
      private var _condenseWhite:Boolean = false;
      
      private var _displayAsPassword:Boolean = false;
      
      private var _gridFitType:String = "pixel";
      
      private var _sharpness:Number = 0;
      
      private var _thickness:Number = 0;
      
      protected var _textPaddingTop:Number = 0;
      
      protected var _textPaddingRight:Number = 0;
      
      protected var _textPaddingBottom:Number = 0;
      
      protected var _textPaddingLeft:Number = 0;
      
      protected var _visible:Boolean = true;
      
      protected var _alpha:Number = 1;
      
      public function ScrollText()
      {
         super();
         this.textViewPort = new TextFieldViewPort();
         this.textViewPort.addEventListener("triggered",textViewPort_triggeredHandler);
         this.viewPort = this.textViewPort;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScrollText.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return this._maxVerticalScrollPosition != this._minVerticalScrollPosition && this._isEnabled && this._isFocusEnabled;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(!param1)
         {
            param1 = "";
         }
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get isHTML() : Boolean
      {
         return this._isHTML;
      }
      
      public function set isHTML(param1:Boolean) : void
      {
         if(this._isHTML == param1)
         {
            return;
         }
         this._isHTML = param1;
         this.invalidate("data");
      }
      
      public function get textFormat() : TextFormat
      {
         return this._textFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         if(this._textFormat == param1)
         {
            return;
         }
         this._textFormat = param1;
         this.invalidate("styles");
      }
      
      public function get disabledTextFormat() : TextFormat
      {
         return this._disabledTextFormat;
      }
      
      public function set disabledTextFormat(param1:TextFormat) : void
      {
         if(this._disabledTextFormat == param1)
         {
            return;
         }
         this._disabledTextFormat = param1;
         this.invalidate("styles");
      }
      
      public function get styleSheet() : StyleSheet
      {
         return this._styleSheet;
      }
      
      public function set styleSheet(param1:StyleSheet) : void
      {
         if(this._styleSheet == param1)
         {
            return;
         }
         this._styleSheet = param1;
         this.invalidate("styles");
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         if(this._embedFonts == param1)
         {
            return;
         }
         this._embedFonts = param1;
         this.invalidate("styles");
      }
      
      public function get antiAliasType() : String
      {
         return this._antiAliasType;
      }
      
      public function set antiAliasType(param1:String) : void
      {
         if(this._antiAliasType == param1)
         {
            return;
         }
         this._antiAliasType = param1;
         this.invalidate("styles");
      }
      
      public function get background() : Boolean
      {
         return this._background;
      }
      
      public function set background(param1:Boolean) : void
      {
         if(this._background == param1)
         {
            return;
         }
         this._background = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         if(this._backgroundColor == param1)
         {
            return;
         }
         this._backgroundColor = param1;
         this.invalidate("styles");
      }
      
      public function get border() : Boolean
      {
         return this._border;
      }
      
      public function set border(param1:Boolean) : void
      {
         if(this._border == param1)
         {
            return;
         }
         this._border = param1;
         this.invalidate("styles");
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         if(this._borderColor == param1)
         {
            return;
         }
         this._borderColor = param1;
         this.invalidate("styles");
      }
      
      public function get condenseWhite() : Boolean
      {
         return this._condenseWhite;
      }
      
      public function set condenseWhite(param1:Boolean) : void
      {
         if(this._condenseWhite == param1)
         {
            return;
         }
         this._condenseWhite = param1;
         this.invalidate("styles");
      }
      
      public function get displayAsPassword() : Boolean
      {
         return this._displayAsPassword;
      }
      
      public function set displayAsPassword(param1:Boolean) : void
      {
         if(this._displayAsPassword == param1)
         {
            return;
         }
         this._displayAsPassword = param1;
         this.invalidate("styles");
      }
      
      public function get gridFitType() : String
      {
         return this._gridFitType;
      }
      
      public function set gridFitType(param1:String) : void
      {
         if(this._gridFitType == param1)
         {
            return;
         }
         this._gridFitType = param1;
         this.invalidate("styles");
      }
      
      public function get sharpness() : Number
      {
         return this._sharpness;
      }
      
      public function set sharpness(param1:Number) : void
      {
         if(this._sharpness == param1)
         {
            return;
         }
         this._sharpness = param1;
         this.invalidate("data");
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1;
         this.invalidate("data");
      }
      
      override public function get padding() : Number
      {
         return this._textPaddingTop;
      }
      
      override public function get paddingTop() : Number
      {
         return this._textPaddingTop;
      }
      
      override public function set paddingTop(param1:Number) : void
      {
         if(this._textPaddingTop == param1)
         {
            return;
         }
         this._textPaddingTop = param1;
         this.invalidate("styles");
      }
      
      override public function get paddingRight() : Number
      {
         return this._textPaddingRight;
      }
      
      override public function set paddingRight(param1:Number) : void
      {
         if(this._textPaddingRight == param1)
         {
            return;
         }
         this._textPaddingRight = param1;
         this.invalidate("styles");
      }
      
      override public function get paddingBottom() : Number
      {
         return this._textPaddingBottom;
      }
      
      override public function set paddingBottom(param1:Number) : void
      {
         if(this._textPaddingBottom == param1)
         {
            return;
         }
         this._textPaddingBottom = param1;
         this.invalidate("styles");
      }
      
      override public function get paddingLeft() : Number
      {
         return this._textPaddingLeft;
      }
      
      override public function set paddingLeft(param1:Number) : void
      {
         if(this._textPaddingLeft == param1)
         {
            return;
         }
         this._textPaddingLeft = param1;
         this.invalidate("styles");
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this._visible == param1)
         {
            return;
         }
         this._visible = param1;
         this.invalidate("styles");
      }
      
      override public function get alpha() : Number
      {
         return this._alpha;
      }
      
      override public function set alpha(param1:Number) : void
      {
         if(this._alpha == param1)
         {
            return;
         }
         this._alpha = param1;
         this.invalidate("styles");
      }
      
      override public function get hasVisibleArea() : Boolean
      {
         return true;
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("scroll");
         var _loc4_:Boolean = this.isInvalid("styles");
         if(_loc3_)
         {
            this.textViewPort.text = this._text;
            this.textViewPort.isHTML = this._isHTML;
         }
         if(_loc4_)
         {
            this.textViewPort.antiAliasType = this._antiAliasType;
            this.textViewPort.background = this._background;
            this.textViewPort.backgroundColor = this._backgroundColor;
            this.textViewPort.border = this._border;
            this.textViewPort.borderColor = this._borderColor;
            this.textViewPort.condenseWhite = this._condenseWhite;
            this.textViewPort.displayAsPassword = this._displayAsPassword;
            this.textViewPort.gridFitType = this._gridFitType;
            this.textViewPort.sharpness = this._sharpness;
            this.textViewPort.thickness = this._thickness;
            this.textViewPort.textFormat = this._textFormat;
            this.textViewPort.disabledTextFormat = this._disabledTextFormat;
            this.textViewPort.styleSheet = this._styleSheet;
            this.textViewPort.embedFonts = this._embedFonts;
            this.textViewPort.paddingTop = this._textPaddingTop;
            this.textViewPort.paddingRight = this._textPaddingRight;
            this.textViewPort.paddingBottom = this._textPaddingBottom;
            this.textViewPort.paddingLeft = this._textPaddingLeft;
            this.textViewPort.visible = this._visible;
            this.textViewPort.alpha = this._alpha;
         }
         super.draw();
         this.refreshFocusIndicator();
      }
      
      protected function textViewPort_triggeredHandler(param1:Event, param2:String) : void
      {
         this.dispatchEventWith("triggered",false,param2);
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this.stage.addEventListener("keyDown",stage_keyDownHandler);
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         super.focusOutHandler(param1);
         this.stage.removeEventListener("keyDown",stage_keyDownHandler);
      }
      
      protected function stage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 36)
         {
            this.verticalScrollPosition = this._minVerticalScrollPosition;
         }
         else if(param1.keyCode == 35)
         {
            this.verticalScrollPosition = this._maxVerticalScrollPosition;
         }
         else if(param1.keyCode == 33)
         {
            this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == 34)
         {
            this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.viewPort.visibleHeight);
         }
         else if(param1.keyCode == 38)
         {
            this.verticalScrollPosition = Math.max(this._minVerticalScrollPosition,this._verticalScrollPosition - this.verticalScrollStep);
         }
         else if(param1.keyCode == 40)
         {
            this.verticalScrollPosition = Math.min(this._maxVerticalScrollPosition,this._verticalScrollPosition + this.verticalScrollStep);
         }
      }
   }
}

