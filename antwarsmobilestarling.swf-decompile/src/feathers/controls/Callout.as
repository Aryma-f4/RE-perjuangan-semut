package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import feathers.core.PopUpManager;
   import feathers.skins.IStyleProvider;
   import feathers.utils.display.getDisplayObjectDepthFromStage;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.events.EnterFrameEvent;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class Callout extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const DIRECTION_ANY:String = "any";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_UP:String = "up";
      
      public static const DIRECTION_DOWN:String = "down";
      
      public static const DIRECTION_LEFT:String = "left";
      
      public static const DIRECTION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_TOP:String = "top";
      
      public static const ARROW_POSITION_RIGHT:String = "right";
      
      public static const ARROW_POSITION_BOTTOM:String = "bottom";
      
      public static const ARROW_POSITION_LEFT:String = "left";
      
      protected static const INVALIDATION_FLAG_ORIGIN:String = "origin";
      
      protected static const FUZZY_CONTENT_DIMENSIONS_PADDING:Number = 0.000001;
      
      public static var stagePaddingTop:Number = 0;
      
      public static var stagePaddingRight:Number = 0;
      
      public static var stagePaddingBottom:Number = 0;
      
      public static var stagePaddingLeft:Number = 0;
      
      private static const HELPER_RECT:Rectangle = new Rectangle();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected static const DIRECTION_TO_FUNCTION:Object = {};
      
      public static var calloutFactory:Function = defaultCalloutFactory;
      
      public static var calloutOverlayFactory:Function = PopUpManager.defaultOverlayFactory;
      
      DIRECTION_TO_FUNCTION["any"] = positionBestSideOfOrigin;
      DIRECTION_TO_FUNCTION["up"] = positionAboveOrigin;
      DIRECTION_TO_FUNCTION["down"] = positionBelowOrigin;
      DIRECTION_TO_FUNCTION["left"] = positionToLeftOfOrigin;
      DIRECTION_TO_FUNCTION["right"] = positionToRightOfOrigin;
      DIRECTION_TO_FUNCTION["vertical"] = positionAboveOrBelowOrigin;
      DIRECTION_TO_FUNCTION["horizontal"] = positionToLeftOrRightOfOrigin;
      
      public var closeOnTouchBeganOutside:Boolean = false;
      
      public var closeOnTouchEndedOutside:Boolean = false;
      
      public var closeOnKeys:Vector.<uint>;
      
      public var disposeOnSelfClose:Boolean = true;
      
      public var disposeContent:Boolean = true;
      
      protected var _isReadyToClose:Boolean = false;
      
      protected var _content:DisplayObject;
      
      protected var _origin:DisplayObject;
      
      protected var _supportedDirections:String = "any";
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _arrowPosition:String = "top";
      
      protected var _originalBackgroundWidth:Number = NaN;
      
      protected var _originalBackgroundHeight:Number = NaN;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var currentArrowSkin:DisplayObject;
      
      protected var _bottomArrowSkin:DisplayObject;
      
      protected var _topArrowSkin:DisplayObject;
      
      protected var _leftArrowSkin:DisplayObject;
      
      protected var _rightArrowSkin:DisplayObject;
      
      protected var _topArrowGap:Number = 0;
      
      protected var _bottomArrowGap:Number = 0;
      
      protected var _rightArrowGap:Number = 0;
      
      protected var _leftArrowGap:Number = 0;
      
      protected var _arrowOffset:Number = 0;
      
      protected var _lastGlobalBoundsOfOrigin:Rectangle;
      
      protected var _ignoreContentResize:Boolean = false;
      
      public function Callout()
      {
         super();
         this.addEventListener("addedToStage",callout_addedToStageHandler);
      }
      
      public static function get stagePadding() : Number
      {
         return Callout.stagePaddingTop;
      }
      
      public static function set stagePadding(param1:Number) : void
      {
         Callout.stagePaddingTop = param1;
         Callout.stagePaddingRight = param1;
         Callout.stagePaddingBottom = param1;
         Callout.stagePaddingLeft = param1;
      }
      
      public static function show(param1:DisplayObject, param2:DisplayObject, param3:String = "any", param4:Boolean = true, param5:Function = null, param6:Function = null) : Callout
      {
         if(!param2.stage)
         {
            throw new ArgumentError("Callout origin must be added to the stage.");
         }
         var _loc8_:* = param5;
         if(_loc8_ == null)
         {
            _loc8_ = calloutFactory != null ? calloutFactory : defaultCalloutFactory;
         }
         var _loc7_:Callout = Callout(_loc8_());
         _loc7_.content = param1;
         _loc7_.supportedDirections = param3;
         _loc7_.origin = param2;
         _loc8_ = param6;
         if(_loc8_ == null)
         {
            _loc8_ = calloutOverlayFactory != null ? calloutOverlayFactory : PopUpManager.defaultOverlayFactory;
         }
         PopUpManager.addPopUp(_loc7_,param4,false,_loc8_);
         return _loc7_;
      }
      
      public static function defaultCalloutFactory() : Callout
      {
         var _loc1_:Callout = new Callout();
         _loc1_.closeOnTouchBeganOutside = true;
         _loc1_.closeOnTouchEndedOutside = true;
         _loc1_.closeOnKeys = new <uint>[16777238,27];
         return _loc1_;
      }
      
      protected static function positionWithSupportedDirections(param1:Callout, param2:Rectangle, param3:String) : void
      {
         var _loc4_:Function = null;
         if(DIRECTION_TO_FUNCTION.hasOwnProperty(param3))
         {
            _loc4_ = DIRECTION_TO_FUNCTION[param3];
            _loc4_(param1,param2);
         }
         else
         {
            positionBestSideOfOrigin(param1,param2);
         }
      }
      
      protected static function positionBestSideOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("top",HELPER_POINT);
         var _loc5_:Number = Starling.current.stage.stageHeight - HELPER_POINT.y - (param2.y + param2.height);
         if(_loc5_ >= stagePaddingBottom)
         {
            positionBelowOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition("bottom",HELPER_POINT);
         var _loc4_:Number = param2.y - HELPER_POINT.y;
         if(_loc4_ >= stagePaddingTop)
         {
            positionAboveOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition("left",HELPER_POINT);
         var _loc3_:Number = Starling.current.stage.stageWidth - HELPER_POINT.x - (param2.x + param2.width);
         if(_loc3_ >= stagePaddingRight)
         {
            positionToRightOfOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition("right",HELPER_POINT);
         var _loc6_:Number = param2.x - HELPER_POINT.x;
         if(_loc6_ >= stagePaddingLeft)
         {
            positionToLeftOfOrigin(param1,param2);
            return;
         }
         if(_loc5_ >= _loc4_ && _loc5_ >= _loc3_ && _loc5_ >= _loc6_)
         {
            positionBelowOrigin(param1,param2);
         }
         else if(_loc4_ >= _loc3_ && _loc4_ >= _loc6_)
         {
            positionAboveOrigin(param1,param2);
         }
         else if(_loc3_ >= _loc6_)
         {
            positionToRightOfOrigin(param1,param2);
         }
         else
         {
            positionToLeftOfOrigin(param1,param2);
         }
      }
      
      protected static function positionAboveOrBelowOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("top",HELPER_POINT);
         var _loc4_:Number = Starling.current.stage.stageHeight - HELPER_POINT.y - (param2.y + param2.height);
         if(_loc4_ >= stagePaddingBottom)
         {
            positionBelowOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition("bottom",HELPER_POINT);
         var _loc3_:Number = param2.y - HELPER_POINT.y;
         if(_loc3_ >= stagePaddingTop)
         {
            positionAboveOrigin(param1,param2);
            return;
         }
         if(_loc4_ >= _loc3_)
         {
            positionBelowOrigin(param1,param2);
         }
         else
         {
            positionAboveOrigin(param1,param2);
         }
      }
      
      protected static function positionToLeftOrRightOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("left",HELPER_POINT);
         var _loc3_:Number = Starling.current.stage.stageWidth - HELPER_POINT.x - (param2.x + param2.width);
         if(_loc3_ >= stagePaddingRight)
         {
            positionToRightOfOrigin(param1,param2);
            return;
         }
         param1.measureWithArrowPosition("right",HELPER_POINT);
         var _loc4_:Number = param2.x - HELPER_POINT.x;
         if(_loc4_ >= stagePaddingLeft)
         {
            positionToLeftOfOrigin(param1,param2);
            return;
         }
         if(_loc3_ >= _loc4_)
         {
            positionToRightOfOrigin(param1,param2);
         }
         else
         {
            positionToLeftOfOrigin(param1,param2);
         }
      }
      
      protected static function positionBelowOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("top",HELPER_POINT);
         var _loc3_:Number = param2.x + Math.round((param2.width - HELPER_POINT.x) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight,_loc3_));
         param1.x = _loc4_;
         param1.y = param2.y + param2.height;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = "top";
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = "top";
         }
      }
      
      protected static function positionAboveOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("bottom",HELPER_POINT);
         var _loc3_:Number = param2.x + Math.round((param2.width - HELPER_POINT.x) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageWidth - HELPER_POINT.x - stagePaddingRight,_loc3_));
         param1.x = _loc4_;
         param1.y = param2.y - HELPER_POINT.y;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = "bottom";
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = "bottom";
         }
      }
      
      protected static function positionToRightOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("left",HELPER_POINT);
         param1.x = param2.x + param2.width;
         var _loc3_:Number = param2.y + Math.round((param2.height - HELPER_POINT.y) / 2);
         var _loc4_:Number = Math.max(stagePaddingTop,Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom,_loc3_));
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = "left";
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = "left";
         }
      }
      
      protected static function positionToLeftOfOrigin(param1:Callout, param2:Rectangle) : void
      {
         param1.measureWithArrowPosition("right",HELPER_POINT);
         param1.x = param2.x - HELPER_POINT.x;
         var _loc3_:Number = param2.y + Math.round((param2.height - HELPER_POINT.y) / 2);
         var _loc4_:Number = Math.max(stagePaddingLeft,Math.min(Starling.current.stage.stageHeight - HELPER_POINT.y - stagePaddingBottom,_loc3_));
         param1.y = _loc4_;
         if(param1._isValidating)
         {
            param1._arrowOffset = _loc3_ - _loc4_;
            param1._arrowPosition = "right";
         }
         else
         {
            param1.arrowOffset = _loc3_ - _loc4_;
            param1.arrowPosition = "right";
         }
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Callout.globalStyleProvider;
      }
      
      public function get content() : DisplayObject
      {
         return this._content;
      }
      
      public function set content(param1:DisplayObject) : void
      {
         if(this._content == param1)
         {
            return;
         }
         if(this._content)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).removeEventListener("resize",content_resizeHandler);
            }
            if(this._content.parent == this)
            {
               this._content.removeFromParent(false);
            }
         }
         this._content = param1;
         if(this._content)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).addEventListener("resize",content_resizeHandler);
            }
            this.addChild(this._content);
         }
         this.invalidate("size");
         this.invalidate("data");
      }
      
      public function get origin() : DisplayObject
      {
         return this._origin;
      }
      
      public function set origin(param1:DisplayObject) : void
      {
         if(this._origin == param1)
         {
            return;
         }
         if(param1 && !param1.stage)
         {
            throw new ArgumentError("Callout origin must have access to the stage.");
         }
         if(this._origin)
         {
            this.removeEventListener("enterFrame",callout_enterFrameHandler);
            this._origin.removeEventListener("removedFromStage",origin_removedFromStageHandler);
         }
         this._origin = param1;
         this._lastGlobalBoundsOfOrigin = null;
         if(this._origin)
         {
            this._origin.addEventListener("removedFromStage",origin_removedFromStageHandler);
            this.addEventListener("enterFrame",callout_enterFrameHandler);
         }
         this.invalidate("origin");
      }
      
      public function get supportedDirections() : String
      {
         return this._supportedDirections;
      }
      
      public function set supportedDirections(param1:String) : void
      {
         this._supportedDirections = param1;
      }
      
      public function get padding() : Number
      {
         return this._paddingTop;
      }
      
      public function set padding(param1:Number) : void
      {
         this.paddingTop = param1;
         this.paddingRight = param1;
         this.paddingBottom = param1;
         this.paddingLeft = param1;
      }
      
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(param1:Number) : void
      {
         if(this._paddingTop == param1)
         {
            return;
         }
         this._paddingTop = param1;
         this.invalidate("styles");
      }
      
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(param1:Number) : void
      {
         if(this._paddingRight == param1)
         {
            return;
         }
         this._paddingRight = param1;
         this.invalidate("styles");
      }
      
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(param1:Number) : void
      {
         if(this._paddingBottom == param1)
         {
            return;
         }
         this._paddingBottom = param1;
         this.invalidate("styles");
      }
      
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(param1:Number) : void
      {
         if(this._paddingLeft == param1)
         {
            return;
         }
         this._paddingLeft = param1;
         this.invalidate("styles");
      }
      
      public function get arrowPosition() : String
      {
         return this._arrowPosition;
      }
      
      public function set arrowPosition(param1:String) : void
      {
         if(this._arrowPosition == param1)
         {
            return;
         }
         this._arrowPosition = param1;
         this.invalidate("styles");
      }
      
      public function get backgroundSkin() : DisplayObject
      {
         return this._backgroundSkin;
      }
      
      public function set backgroundSkin(param1:DisplayObject) : void
      {
         if(this._backgroundSkin == param1)
         {
            return;
         }
         if(this._backgroundSkin)
         {
            this.removeChild(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin)
         {
            this._originalBackgroundWidth = this._backgroundSkin.width;
            this._originalBackgroundHeight = this._backgroundSkin.height;
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get bottomArrowSkin() : DisplayObject
      {
         return this._bottomArrowSkin;
      }
      
      public function set bottomArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._bottomArrowSkin == param1)
         {
            return;
         }
         if(this._bottomArrowSkin)
         {
            this.removeChild(this._bottomArrowSkin);
         }
         this._bottomArrowSkin = param1;
         if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._bottomArrowSkin);
            }
            else
            {
               this.addChildAt(this._bottomArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get topArrowSkin() : DisplayObject
      {
         return this._topArrowSkin;
      }
      
      public function set topArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._topArrowSkin == param1)
         {
            return;
         }
         if(this._topArrowSkin)
         {
            this.removeChild(this._topArrowSkin);
         }
         this._topArrowSkin = param1;
         if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._topArrowSkin);
            }
            else
            {
               this.addChildAt(this._topArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get leftArrowSkin() : DisplayObject
      {
         return this._leftArrowSkin;
      }
      
      public function set leftArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._leftArrowSkin == param1)
         {
            return;
         }
         if(this._leftArrowSkin)
         {
            this.removeChild(this._leftArrowSkin);
         }
         this._leftArrowSkin = param1;
         if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._leftArrowSkin);
            }
            else
            {
               this.addChildAt(this._leftArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get rightArrowSkin() : DisplayObject
      {
         return this._rightArrowSkin;
      }
      
      public function set rightArrowSkin(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(this._rightArrowSkin == param1)
         {
            return;
         }
         if(this._rightArrowSkin)
         {
            this.removeChild(this._rightArrowSkin);
         }
         this._rightArrowSkin = param1;
         if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
            _loc2_ = this.getChildIndex(this._content);
            if(_loc2_ < 0)
            {
               this.addChild(this._rightArrowSkin);
            }
            else
            {
               this.addChildAt(this._rightArrowSkin,_loc2_);
            }
         }
         this.invalidate("styles");
      }
      
      public function get topArrowGap() : Number
      {
         return this._topArrowGap;
      }
      
      public function set topArrowGap(param1:Number) : void
      {
         if(this._topArrowGap == param1)
         {
            return;
         }
         this._topArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get bottomArrowGap() : Number
      {
         return this._bottomArrowGap;
      }
      
      public function set bottomArrowGap(param1:Number) : void
      {
         if(this._bottomArrowGap == param1)
         {
            return;
         }
         this._bottomArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get rightArrowGap() : Number
      {
         return this._rightArrowGap;
      }
      
      public function set rightArrowGap(param1:Number) : void
      {
         if(this._rightArrowGap == param1)
         {
            return;
         }
         this._rightArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get leftArrowGap() : Number
      {
         return this._leftArrowGap;
      }
      
      public function set leftArrowGap(param1:Number) : void
      {
         if(this._leftArrowGap == param1)
         {
            return;
         }
         this._leftArrowGap = param1;
         this.invalidate("styles");
      }
      
      public function get arrowOffset() : Number
      {
         return this._arrowOffset;
      }
      
      public function set arrowOffset(param1:Number) : void
      {
         if(this._arrowOffset == param1)
         {
            return;
         }
         this._arrowOffset = param1;
         this.invalidate("styles");
      }
      
      override public function dispose() : void
      {
         this.origin = null;
         var _loc1_:DisplayObject = this._content;
         this.content = null;
         if(_loc1_ && this.disposeContent)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      public function close(param1:Boolean = false) : void
      {
         if(this.parent)
         {
            this.removeFromParent(false);
            this.dispatchEventWith("close");
         }
         if(param1)
         {
            this.dispose();
         }
      }
      
      override protected function initialize() : void
      {
         this.addEventListener("removedFromStage",callout_removedFromStageHandler);
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc4_:Boolean = this.isInvalid("state");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc1_:Boolean = this.isInvalid("origin");
         if(_loc2_)
         {
            this._lastGlobalBoundsOfOrigin = null;
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this.positionToOrigin();
         }
         if(_loc5_ || _loc4_)
         {
            this.refreshArrowSkin();
         }
         if(_loc4_)
         {
            if(this._content is IFeathersControl)
            {
               IFeathersControl(this._content).isEnabled = this._isEnabled;
            }
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc2_ || _loc5_ || _loc3_ || _loc4_)
         {
            this.layoutChildren();
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         this.measureWithArrowPosition(this._arrowPosition,HELPER_POINT);
         return this.setSizeInternal(HELPER_POINT.x,HELPER_POINT.y,false);
      }
      
      protected function measureWithArrowPosition(param1:String, param2:Point = null) : Point
      {
         if(!param2)
         {
            param2 = new Point();
         }
         var _loc4_:* = this.explicitWidth !== this.explicitWidth;
         var _loc6_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc4_ && !_loc6_)
         {
            param2.x = this.explicitWidth;
            param2.y = this.explicitHeight;
            return param2;
         }
         if(this._content is IValidating)
         {
            IValidating(this._content).validate();
         }
         var _loc5_:Number = this.explicitWidth;
         var _loc3_:Number = this.explicitHeight;
         if(_loc4_)
         {
            _loc5_ = this._content.width + this._paddingLeft + this._paddingRight;
            if(this._originalBackgroundWidth === this._originalBackgroundWidth)
            {
               _loc5_ = Math.max(this._originalBackgroundWidth,_loc5_);
            }
            if(param1 == "left" && this._leftArrowSkin)
            {
               _loc5_ += this._leftArrowSkin.width + this._leftArrowGap;
            }
            if(param1 == "right" && this._rightArrowSkin)
            {
               _loc5_ += this._rightArrowSkin.width + this._rightArrowGap;
            }
            if(param1 == "top" && this._topArrowSkin)
            {
               _loc5_ = Math.max(_loc5_,this._topArrowSkin.width + this._paddingLeft + this._paddingRight);
            }
            if(param1 == "bottom" && this._bottomArrowSkin)
            {
               _loc5_ = Math.max(_loc5_,this._bottomArrowSkin.width + this._paddingLeft + this._paddingRight);
            }
            if(this.stage)
            {
               _loc5_ = Math.min(_loc5_,this.stage.stageWidth - stagePaddingLeft - stagePaddingRight);
            }
         }
         if(_loc6_)
         {
            _loc3_ = this._content.height + this._paddingTop + this._paddingBottom;
            if(this._originalBackgroundHeight === this._originalBackgroundHeight)
            {
               _loc3_ = Math.max(this._originalBackgroundHeight,_loc3_);
            }
            if(param1 == "top" && this._topArrowSkin)
            {
               _loc3_ += this._topArrowSkin.height + this._topArrowGap;
            }
            if(param1 == "bottom" && this._bottomArrowSkin)
            {
               _loc3_ += this._bottomArrowSkin.height + this._bottomArrowGap;
            }
            if(param1 == "left" && this._leftArrowSkin)
            {
               _loc3_ = Math.max(_loc3_,this._leftArrowSkin.height + this._paddingTop + this._paddingBottom);
            }
            if(param1 == "right" && this._rightArrowSkin)
            {
               _loc3_ = Math.max(_loc3_,this._rightArrowSkin.height + this._paddingTop + this._paddingBottom);
            }
            if(this.stage)
            {
               _loc3_ = Math.min(_loc3_,this.stage.stageHeight - stagePaddingTop - stagePaddingBottom);
            }
         }
         param2.x = Math.max(this._minWidth,Math.min(this._maxWidth,_loc5_));
         param2.y = Math.max(this._minHeight,Math.min(this._maxHeight,_loc3_));
         return param2;
      }
      
      protected function refreshArrowSkin() : void
      {
         this.currentArrowSkin = null;
         if(this._arrowPosition == "bottom")
         {
            this.currentArrowSkin = this._bottomArrowSkin;
         }
         else if(this._bottomArrowSkin)
         {
            this._bottomArrowSkin.visible = false;
         }
         if(this._arrowPosition == "top")
         {
            this.currentArrowSkin = this._topArrowSkin;
         }
         else if(this._topArrowSkin)
         {
            this._topArrowSkin.visible = false;
         }
         if(this._arrowPosition == "left")
         {
            this.currentArrowSkin = this._leftArrowSkin;
         }
         else if(this._leftArrowSkin)
         {
            this._leftArrowSkin.visible = false;
         }
         if(this._arrowPosition == "right")
         {
            this.currentArrowSkin = this._rightArrowSkin;
         }
         else if(this._rightArrowSkin)
         {
            this._rightArrowSkin.visible = false;
         }
         if(this.currentArrowSkin)
         {
            this.currentArrowSkin.visible = true;
         }
      }
      
      protected function layoutChildren() : void
      {
         var _loc5_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc7_:Number = this._leftArrowSkin && this._arrowPosition == "left" ? this._leftArrowSkin.width + this._leftArrowGap : 0;
         var _loc10_:Number = this._topArrowSkin && this._arrowPosition == "top" ? this._topArrowSkin.height + this._topArrowGap : 0;
         var _loc6_:Number = this._rightArrowSkin && this._arrowPosition == "right" ? this._rightArrowSkin.width + this._rightArrowGap : 0;
         var _loc2_:Number = this._bottomArrowSkin && this._arrowPosition == "bottom" ? this._bottomArrowSkin.height + this._bottomArrowGap : 0;
         var _loc3_:Number = this.actualWidth - _loc7_ - _loc6_;
         var _loc8_:Number = this.actualHeight - _loc10_ - _loc2_;
         if(this._backgroundSkin)
         {
            this._backgroundSkin.x = _loc7_;
            this._backgroundSkin.y = _loc10_;
            this._backgroundSkin.width = _loc3_;
            this._backgroundSkin.height = _loc8_;
         }
         if(this.currentArrowSkin)
         {
            if(this._arrowPosition == "left")
            {
               this._leftArrowSkin.x = _loc7_ - this._leftArrowSkin.width - this._leftArrowGap;
               this._leftArrowSkin.y = this._arrowOffset + _loc10_ + Math.round((_loc8_ - this._leftArrowSkin.height) / 2);
               this._leftArrowSkin.y = Math.min(_loc10_ + _loc8_ - this._paddingBottom - this._leftArrowSkin.height,Math.max(_loc10_ + this._paddingTop,this._leftArrowSkin.y));
            }
            else if(this._arrowPosition == "right")
            {
               this._rightArrowSkin.x = _loc7_ + _loc3_ + this._rightArrowGap;
               this._rightArrowSkin.y = this._arrowOffset + _loc10_ + Math.round((_loc8_ - this._rightArrowSkin.height) / 2);
               this._rightArrowSkin.y = Math.min(_loc10_ + _loc8_ - this._paddingBottom - this._rightArrowSkin.height,Math.max(_loc10_ + this._paddingTop,this._rightArrowSkin.y));
            }
            else if(this._arrowPosition == "bottom")
            {
               this._bottomArrowSkin.x = this._arrowOffset + _loc7_ + Math.round((_loc3_ - this._bottomArrowSkin.width) / 2);
               this._bottomArrowSkin.x = Math.min(_loc7_ + _loc3_ - this._paddingRight - this._bottomArrowSkin.width,Math.max(_loc7_ + this._paddingLeft,this._bottomArrowSkin.x));
               this._bottomArrowSkin.y = _loc10_ + _loc8_ + this._bottomArrowGap;
            }
            else
            {
               this._topArrowSkin.x = this._arrowOffset + _loc7_ + Math.round((_loc3_ - this._topArrowSkin.width) / 2);
               this._topArrowSkin.x = Math.min(_loc7_ + _loc3_ - this._paddingRight - this._topArrowSkin.width,Math.max(_loc7_ + this._paddingLeft,this._topArrowSkin.x));
               this._topArrowSkin.y = _loc10_ - this._topArrowSkin.height - this._topArrowGap;
            }
         }
         if(this._content)
         {
            this._content.x = _loc7_ + this._paddingLeft;
            this._content.y = _loc10_ + this._paddingTop;
            _loc5_ = this._ignoreContentResize;
            this._ignoreContentResize = true;
            _loc9_ = _loc3_ - this._paddingLeft - this._paddingRight;
            _loc1_ = Math.abs(this._content.width - _loc9_);
            if(_loc1_ > 0.000001)
            {
               this._content.width = _loc9_;
            }
            _loc4_ = _loc8_ - this._paddingTop - this._paddingBottom;
            _loc1_ = Math.abs(this._content.height - _loc4_);
            if(_loc1_ > 0.000001)
            {
               this._content.height = _loc4_;
            }
            this._ignoreContentResize = _loc5_;
         }
      }
      
      protected function positionToOrigin() : void
      {
         if(!this._origin)
         {
            return;
         }
         this._origin.getBounds(Starling.current.stage,HELPER_RECT);
         var _loc1_:* = this._lastGlobalBoundsOfOrigin != null;
         if(!_loc1_ || !this._lastGlobalBoundsOfOrigin.equals(HELPER_RECT))
         {
            if(!_loc1_)
            {
               this._lastGlobalBoundsOfOrigin = new Rectangle();
            }
            this._lastGlobalBoundsOfOrigin.x = HELPER_RECT.x;
            this._lastGlobalBoundsOfOrigin.y = HELPER_RECT.y;
            this._lastGlobalBoundsOfOrigin.width = HELPER_RECT.width;
            this._lastGlobalBoundsOfOrigin.height = HELPER_RECT.height;
            positionWithSupportedDirections(this,this._lastGlobalBoundsOfOrigin,this._supportedDirections);
         }
      }
      
      protected function callout_addedToStageHandler(param1:Event) : void
      {
         var _loc2_:int = -getDisplayObjectDepthFromStage(this);
         Starling.current.nativeStage.addEventListener("keyDown",callout_nativeStage_keyDownHandler,false,_loc2_,true);
         this.stage.addEventListener("touch",stage_touchHandler);
         this._isReadyToClose = false;
         this.addEventListener("enterFrame",callout_oneEnterFrameHandler);
      }
      
      protected function callout_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("touch",stage_touchHandler);
         Starling.current.nativeStage.removeEventListener("keyDown",callout_nativeStage_keyDownHandler);
      }
      
      protected function callout_oneEnterFrameHandler(param1:Event) : void
      {
         this.removeEventListener("enterFrame",callout_oneEnterFrameHandler);
         this._isReadyToClose = true;
      }
      
      protected function callout_enterFrameHandler(param1:EnterFrameEvent) : void
      {
         this.positionToOrigin();
      }
      
      protected function stage_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc3_:DisplayObject = DisplayObject(param1.target);
         if(!this._isReadyToClose || !this.closeOnTouchEndedOutside && !this.closeOnTouchBeganOutside || this.contains(_loc3_) || PopUpManager.isPopUp(this) && !PopUpManager.isTopLevelPopUp(this))
         {
            return;
         }
         if(this._origin == _loc3_ || this._origin is DisplayObjectContainer && Boolean(DisplayObjectContainer(this._origin).contains(_loc3_)))
         {
            return;
         }
         if(this.closeOnTouchBeganOutside)
         {
            _loc2_ = param1.getTouch(this.stage,"began");
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
         if(this.closeOnTouchEndedOutside)
         {
            _loc2_ = param1.getTouch(this.stage,"ended");
            if(_loc2_)
            {
               this.close(this.disposeOnSelfClose);
               return;
            }
         }
      }
      
      protected function callout_nativeStage_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.isDefaultPrevented())
         {
            return;
         }
         if(!this.closeOnKeys || this.closeOnKeys.indexOf(param1.keyCode) < 0)
         {
            return;
         }
         param1.preventDefault();
         this.close(this.disposeOnSelfClose);
      }
      
      protected function origin_removedFromStageHandler(param1:Event) : void
      {
         this.close(this.disposeOnSelfClose);
      }
      
      protected function content_resizeHandler(param1:Event) : void
      {
         if(this._ignoreContentResize)
         {
            return;
         }
         this.invalidate("size");
      }
   }
}

