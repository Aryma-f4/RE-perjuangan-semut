package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.skins.IStyleProvider;
   import feathers.utils.math.clamp;
   import starling.display.DisplayObject;
   
   public class ProgressBar extends FeathersControl
   {
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _direction:String = "horizontal";
      
      protected var _value:Number = 0;
      
      protected var _minimum:Number = 0;
      
      protected var _maximum:Number = 1;
      
      protected var _originalBackgroundWidth:Number = NaN;
      
      protected var _originalBackgroundHeight:Number = NaN;
      
      protected var currentBackground:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _originalFillWidth:Number = NaN;
      
      protected var _originalFillHeight:Number = NaN;
      
      protected var currentFill:DisplayObject;
      
      protected var _fillSkin:DisplayObject;
      
      protected var _fillDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function ProgressBar()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ProgressBar.globalStyleProvider;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate("data");
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         param1 = clamp(param1,this._minimum,this._maximum);
         if(this._value == param1)
         {
            return;
         }
         this._value = param1;
         this.invalidate("data");
      }
      
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(param1:Number) : void
      {
         if(this._minimum == param1)
         {
            return;
         }
         this._minimum = param1;
         this.invalidate("data");
      }
      
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(param1:Number) : void
      {
         if(this._maximum == param1)
         {
            return;
         }
         this._maximum = param1;
         this.invalidate("data");
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
         if(this._backgroundSkin && this._backgroundSkin != this._backgroundDisabledSkin)
         {
            this.removeChild(this._backgroundSkin);
         }
         this._backgroundSkin = param1;
         if(this._backgroundSkin && this._backgroundSkin.parent != this)
         {
            this._backgroundSkin.visible = false;
            this.addChildAt(this._backgroundSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get backgroundDisabledSkin() : DisplayObject
      {
         return this._backgroundDisabledSkin;
      }
      
      public function set backgroundDisabledSkin(param1:DisplayObject) : void
      {
         if(this._backgroundDisabledSkin == param1)
         {
            return;
         }
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin != this._backgroundSkin)
         {
            this.removeChild(this._backgroundDisabledSkin);
         }
         this._backgroundDisabledSkin = param1;
         if(this._backgroundDisabledSkin && this._backgroundDisabledSkin.parent != this)
         {
            this._backgroundDisabledSkin.visible = false;
            this.addChildAt(this._backgroundDisabledSkin,0);
         }
         this.invalidate("styles");
      }
      
      public function get fillSkin() : DisplayObject
      {
         return this._fillSkin;
      }
      
      public function set fillSkin(param1:DisplayObject) : void
      {
         if(this._fillSkin == param1)
         {
            return;
         }
         if(this._fillSkin && this._fillSkin != this._fillDisabledSkin)
         {
            this.removeChild(this._fillSkin);
         }
         this._fillSkin = param1;
         if(this._fillSkin && this._fillSkin.parent != this)
         {
            this._fillSkin.visible = false;
            this.addChild(this._fillSkin);
         }
         this.invalidate("styles");
      }
      
      public function get fillDisabledSkin() : DisplayObject
      {
         return this._fillDisabledSkin;
      }
      
      public function set fillDisabledSkin(param1:DisplayObject) : void
      {
         if(this._fillDisabledSkin == param1)
         {
            return;
         }
         if(this._fillDisabledSkin && this._fillDisabledSkin != this._fillSkin)
         {
            this.removeChild(this._fillDisabledSkin);
         }
         this._fillDisabledSkin = param1;
         if(this._fillDisabledSkin && this._fillDisabledSkin.parent != this)
         {
            this._fillDisabledSkin.visible = false;
            this.addChild(this._fillDisabledSkin);
         }
         this.invalidate("styles");
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
      
      override protected function draw() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("state");
         var _loc2_:Boolean = this.isInvalid("size");
         if(_loc5_ || _loc4_)
         {
            this.refreshBackground();
            this.refreshFill();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc2_ || _loc5_ || _loc4_)
         {
            if(this.currentBackground)
            {
               this.currentBackground.width = this.actualWidth;
               this.currentBackground.height = this.actualHeight;
            }
         }
         if(_loc3_ || _loc2_ || _loc4_ || _loc5_)
         {
            _loc1_ = (this._value - this._minimum) / (this._maximum - this._minimum);
            if(this._direction == "vertical")
            {
               this.currentFill.width = this.actualWidth - this._paddingLeft - this._paddingRight;
               this.currentFill.height = this._originalFillHeight + _loc1_ * (this.actualHeight - this._paddingTop - this._paddingBottom - this._originalFillHeight);
               this.currentFill.x = this._paddingLeft;
               this.currentFill.y = this.actualHeight - this._paddingBottom - this.currentFill.height;
            }
            else
            {
               this.currentFill.width = this._originalFillWidth + _loc1_ * (this.actualWidth - this._paddingLeft - this._paddingRight - this._originalFillWidth);
               this.currentFill.height = this.actualHeight - this._paddingTop - this._paddingBottom;
               this.currentFill.x = this._paddingLeft;
               this.currentFill.y = this._paddingTop;
            }
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc4_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         var _loc3_:Number = _loc2_ ? this._originalBackgroundWidth : this.explicitWidth;
         var _loc1_:Number = _loc4_ ? this._originalBackgroundHeight : this.explicitHeight;
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function refreshBackground() : void
      {
         this.currentBackground = this._backgroundSkin;
         if(this._backgroundDisabledSkin)
         {
            if(this._isEnabled)
            {
               this._backgroundDisabledSkin.visible = false;
            }
            else
            {
               this.currentBackground = this._backgroundDisabledSkin;
               if(this._backgroundSkin)
               {
                  this._backgroundSkin.visible = false;
               }
            }
         }
         if(this.currentBackground)
         {
            if(this._originalBackgroundWidth !== this._originalBackgroundWidth)
            {
               this._originalBackgroundWidth = this.currentBackground.width;
            }
            if(this._originalBackgroundHeight !== this._originalBackgroundHeight)
            {
               this._originalBackgroundHeight = this.currentBackground.height;
            }
            this.currentBackground.visible = true;
         }
      }
      
      protected function refreshFill() : void
      {
         this.currentFill = this._fillSkin;
         if(this._fillDisabledSkin)
         {
            if(this._isEnabled)
            {
               this._fillDisabledSkin.visible = false;
            }
            else
            {
               this.currentFill = this._fillDisabledSkin;
               if(this._backgroundSkin)
               {
                  this._fillSkin.visible = false;
               }
            }
         }
         if(this.currentFill)
         {
            if(this._originalFillWidth !== this._originalFillWidth)
            {
               this._originalFillWidth = this.currentFill.width;
            }
            if(this._originalFillHeight !== this._originalFillHeight)
            {
               this._originalFillHeight = this.currentFill.height;
            }
            this.currentFill.visible = true;
         }
      }
   }
}

