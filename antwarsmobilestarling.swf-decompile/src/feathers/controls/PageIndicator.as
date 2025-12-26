package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IValidating;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.ILayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.display.Quad;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class PageIndicator extends FeathersControl
   {
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const INTERACTION_MODE_PREVIOUS_NEXT:String = "previousNext";
      
      public static const INTERACTION_MODE_PRECISE:String = "precise";
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const LAYOUT_RESULT:LayoutBoundsResult = new LayoutBoundsResult();
      
      private static const SUGGESTED_BOUNDS:ViewPortBounds = new ViewPortBounds();
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var selectedSymbol:DisplayObject;
      
      protected var cache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var unselectedSymbols:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var symbols:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var touchPointID:int = -1;
      
      protected var _pageCount:int = 1;
      
      protected var _selectedIndex:int = 0;
      
      protected var _interactionMode:String = "previousNext";
      
      protected var _layout:ILayout;
      
      protected var _direction:String = "horizontal";
      
      protected var _horizontalAlign:String = "center";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _gap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _normalSymbolFactory:Function = defaultNormalSymbolFactory;
      
      protected var _selectedSymbolFactory:Function = defaultSelectedSymbolFactory;
      
      public function PageIndicator()
      {
         super();
         this.isQuickHitAreaEnabled = true;
         this.addEventListener("touch",touchHandler);
      }
      
      protected static function defaultSelectedSymbolFactory() : Quad
      {
         return new Quad(25,25,16777215);
      }
      
      protected static function defaultNormalSymbolFactory() : Quad
      {
         return new Quad(25,25,13421772);
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return PageIndicator.globalStyleProvider;
      }
      
      public function get pageCount() : int
      {
         return this._pageCount;
      }
      
      public function set pageCount(param1:int) : void
      {
         if(this._pageCount == param1)
         {
            return;
         }
         this._pageCount = param1;
         this.invalidate("data");
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         param1 = Math.max(0,Math.min(param1,this._pageCount - 1));
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get interactionMode() : String
      {
         return this._interactionMode;
      }
      
      public function set interactionMode(param1:String) : void
      {
         this._interactionMode = param1;
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
         this.invalidate("layout");
      }
      
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:String) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this.invalidate("layout");
      }
      
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate("layout");
      }
      
      public function get gap() : Number
      {
         return this._gap;
      }
      
      public function set gap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         this.invalidate("layout");
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
      
      public function get normalSymbolFactory() : Function
      {
         return this._normalSymbolFactory;
      }
      
      public function set normalSymbolFactory(param1:Function) : void
      {
         if(this._normalSymbolFactory == param1)
         {
            return;
         }
         this._normalSymbolFactory = param1;
         this.invalidate("styles");
      }
      
      public function get selectedSymbolFactory() : Function
      {
         return this._selectedSymbolFactory;
      }
      
      public function set selectedSymbolFactory(param1:Function) : void
      {
         if(this._selectedSymbolFactory == param1)
         {
            return;
         }
         this._selectedSymbolFactory = param1;
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc3_:Boolean = this.isInvalid("styles");
         var _loc4_:Boolean = this.isInvalid("layout");
         if(_loc2_ || _loc1_ || _loc3_)
         {
            this.refreshSymbols(_loc3_);
         }
         this.layoutSymbols(_loc4_);
      }
      
      protected function refreshSymbols(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:DisplayObject = null;
         this.symbols.length = 0;
         var _loc4_:Vector.<DisplayObject> = this.cache;
         if(param1)
         {
            _loc2_ = int(this.unselectedSymbols.length);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc3_ = this.unselectedSymbols.shift();
               this.removeChild(_loc3_,true);
               _loc5_++;
            }
            if(this.selectedSymbol)
            {
               this.removeChild(this.selectedSymbol,true);
               this.selectedSymbol = null;
            }
         }
         this.cache = this.unselectedSymbols;
         this.unselectedSymbols = _loc4_;
         _loc5_ = 0;
         while(_loc5_ < this._pageCount)
         {
            if(_loc5_ == this._selectedIndex)
            {
               if(!this.selectedSymbol)
               {
                  this.selectedSymbol = this._selectedSymbolFactory();
                  this.addChild(this.selectedSymbol);
               }
               this.symbols.push(this.selectedSymbol);
               if(this.selectedSymbol is IValidating)
               {
                  IValidating(this.selectedSymbol).validate();
               }
            }
            else
            {
               if(this.cache.length > 0)
               {
                  _loc3_ = this.cache.shift();
               }
               else
               {
                  _loc3_ = this._normalSymbolFactory();
                  this.addChild(_loc3_);
               }
               this.unselectedSymbols.push(_loc3_);
               this.symbols.push(_loc3_);
               if(_loc3_ is IValidating)
               {
                  IValidating(_loc3_).validate();
               }
            }
            _loc5_++;
         }
         _loc2_ = int(this.cache.length);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc3_ = this.cache.shift();
            this.removeChild(_loc3_,true);
            _loc5_++;
         }
      }
      
      protected function layoutSymbols(param1:Boolean) : void
      {
         var _loc2_:VerticalLayout = null;
         var _loc3_:HorizontalLayout = null;
         if(param1)
         {
            if(this._direction == "vertical" && !(this._layout is VerticalLayout))
            {
               this._layout = new VerticalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            else if(this._direction != "vertical" && !(this._layout is HorizontalLayout))
            {
               this._layout = new HorizontalLayout();
               IVirtualLayout(this._layout).useVirtualLayout = false;
            }
            if(this._layout is VerticalLayout)
            {
               _loc2_ = VerticalLayout(this._layout);
               _loc2_.paddingTop = this._paddingTop;
               _loc2_.paddingRight = this._paddingRight;
               _loc2_.paddingBottom = this._paddingBottom;
               _loc2_.paddingLeft = this._paddingLeft;
               _loc2_.gap = this._gap;
               _loc2_.horizontalAlign = this._horizontalAlign;
               _loc2_.verticalAlign = this._verticalAlign;
            }
            if(this._layout is HorizontalLayout)
            {
               _loc3_ = HorizontalLayout(this._layout);
               _loc3_.paddingTop = this._paddingTop;
               _loc3_.paddingRight = this._paddingRight;
               _loc3_.paddingBottom = this._paddingBottom;
               _loc3_.paddingLeft = this._paddingLeft;
               _loc3_.gap = this._gap;
               _loc3_.horizontalAlign = this._horizontalAlign;
               _loc3_.verticalAlign = this._verticalAlign;
            }
         }
         SUGGESTED_BOUNDS.x = SUGGESTED_BOUNDS.y = 0;
         SUGGESTED_BOUNDS.scrollX = SUGGESTED_BOUNDS.scrollY = 0;
         SUGGESTED_BOUNDS.explicitWidth = this.explicitWidth;
         SUGGESTED_BOUNDS.explicitHeight = this.explicitHeight;
         SUGGESTED_BOUNDS.maxWidth = this._maxWidth;
         SUGGESTED_BOUNDS.maxHeight = this._maxHeight;
         SUGGESTED_BOUNDS.minWidth = this._minWidth;
         SUGGESTED_BOUNDS.minHeight = this._minHeight;
         this._layout.layout(this.symbols,SUGGESTED_BOUNDS,LAYOUT_RESULT);
         this.setSizeInternal(LAYOUT_RESULT.contentWidth,LAYOUT_RESULT.contentHeight,false);
      }
      
      protected function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         var _loc4_:Boolean = false;
         var _loc3_:int = 0;
         var _loc7_:Number = NaN;
         var _loc6_:* = 0;
         var _loc5_:Number = NaN;
         if(!this._isEnabled || this._pageCount < 2)
         {
            this.touchPointID = -1;
            return;
         }
         if(this.touchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this,"ended",this.touchPointID);
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = -1;
            _loc2_.getLocation(this.stage,HELPER_POINT);
            _loc4_ = this.contains(this.stage.hitTest(HELPER_POINT,true));
            if(_loc4_)
            {
               _loc3_ = this._pageCount - 1;
               this.globalToLocal(HELPER_POINT,HELPER_POINT);
               if(this._direction == "vertical")
               {
                  if(this._interactionMode == "precise")
                  {
                     _loc7_ = this.selectedSymbol.height + (this.unselectedSymbols[0].height + this._gap) * _loc3_;
                     _loc6_ = Math.round(_loc3_ * (HELPER_POINT.y - this.symbols[0].y) / _loc7_);
                     if(_loc6_ < 0)
                     {
                        _loc6_ = 0;
                     }
                     else if(_loc6_ > _loc3_)
                     {
                        _loc6_ = _loc3_;
                     }
                     this.selectedIndex = _loc6_;
                  }
                  else
                  {
                     if(HELPER_POINT.y < this.selectedSymbol.y)
                     {
                        this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                     }
                     if(HELPER_POINT.y > this.selectedSymbol.y + this.selectedSymbol.height)
                     {
                        this.selectedIndex = Math.min(_loc3_,this._selectedIndex + 1);
                     }
                  }
               }
               else if(this._interactionMode == "precise")
               {
                  _loc5_ = this.selectedSymbol.width + (this.unselectedSymbols[0].width + this._gap) * _loc3_;
                  _loc6_ = Math.round(_loc3_ * (HELPER_POINT.x - this.symbols[0].x) / _loc5_);
                  if(_loc6_ < 0)
                  {
                     _loc6_ = 0;
                  }
                  else if(_loc6_ >= this._pageCount)
                  {
                     _loc6_ = _loc3_;
                  }
                  this.selectedIndex = _loc6_;
               }
               else
               {
                  if(HELPER_POINT.x < this.selectedSymbol.x)
                  {
                     this.selectedIndex = Math.max(0,this._selectedIndex - 1);
                  }
                  if(HELPER_POINT.x > this.selectedSymbol.x + this.selectedSymbol.width)
                  {
                     this.selectedIndex = Math.min(_loc3_,this._selectedIndex + 1);
                  }
               }
            }
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
         }
      }
   }
}

