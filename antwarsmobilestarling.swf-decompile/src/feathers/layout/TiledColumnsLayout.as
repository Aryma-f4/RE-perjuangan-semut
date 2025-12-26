package feathers.layout
{
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class TiledColumnsLayout extends EventDispatcher implements IVirtualLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const TILE_VERTICAL_ALIGN_TOP:String = "top";
      
      public static const TILE_VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const TILE_VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const TILE_VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const TILE_HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const TILE_HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const TILE_HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const TILE_HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const PAGING_HORIZONTAL:String = "horizontal";
      
      public static const PAGING_VERTICAL:String = "vertical";
      
      public static const PAGING_NONE:String = "none";
      
      protected var _discoveredItemsCache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _horizontalGap:Number = 0;
      
      protected var _verticalGap:Number = 0;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _requestedRowCount:int = 0;
      
      protected var _requestedColumnCount:int = 0;
      
      protected var _verticalAlign:String = "top";
      
      protected var _horizontalAlign:String = "center";
      
      protected var _tileVerticalAlign:String = "middle";
      
      protected var _tileHorizontalAlign:String = "center";
      
      protected var _paging:String = "none";
      
      protected var _useSquareTiles:Boolean = true;
      
      protected var _manageVisibility:Boolean = false;
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      public function TiledColumnsLayout()
      {
         super();
      }
      
      public function get gap() : Number
      {
         return this._verticalGap;
      }
      
      public function set gap(param1:Number) : void
      {
         this.horizontalGap = param1;
         this.verticalGap = param1;
      }
      
      public function get horizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set horizontalGap(param1:Number) : void
      {
         if(this._horizontalGap == param1)
         {
            return;
         }
         this._horizontalGap = param1;
         this.dispatchEventWith("change");
      }
      
      public function get verticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function set verticalGap(param1:Number) : void
      {
         if(this._verticalGap == param1)
         {
            return;
         }
         this._verticalGap = param1;
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
      }
      
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedRowCount requires a value >= 0");
         }
         if(this._requestedRowCount == param1)
         {
            return;
         }
         this._requestedRowCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(param1:int) : void
      {
         if(param1 < 0)
         {
            throw RangeError("requestedColumnCount requires a value >= 0");
         }
         if(this._requestedColumnCount == param1)
         {
            return;
         }
         this._requestedColumnCount = param1;
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
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
         this.dispatchEventWith("change");
      }
      
      public function get tileVerticalAlign() : String
      {
         return this._tileVerticalAlign;
      }
      
      public function set tileVerticalAlign(param1:String) : void
      {
         if(this._tileVerticalAlign == param1)
         {
            return;
         }
         this._tileVerticalAlign = param1;
         this.dispatchEventWith("change");
      }
      
      public function get tileHorizontalAlign() : String
      {
         return this._tileHorizontalAlign;
      }
      
      public function set tileHorizontalAlign(param1:String) : void
      {
         if(this._tileHorizontalAlign == param1)
         {
            return;
         }
         this._tileHorizontalAlign = param1;
         this.dispatchEventWith("change");
      }
      
      public function get paging() : String
      {
         return this._paging;
      }
      
      public function set paging(param1:String) : void
      {
         if(this._paging == param1)
         {
            return;
         }
         this._paging = param1;
         this.dispatchEventWith("change");
      }
      
      public function get useSquareTiles() : Boolean
      {
         return this._useSquareTiles;
      }
      
      public function set useSquareTiles(param1:Boolean) : void
      {
         if(this._useSquareTiles == param1)
         {
            return;
         }
         this._useSquareTiles = param1;
         this.dispatchEventWith("change");
      }
      
      public function get manageVisibility() : Boolean
      {
         return this._manageVisibility;
      }
      
      public function set manageVisibility(param1:Boolean) : void
      {
         if(this._manageVisibility == param1)
         {
            return;
         }
         this._manageVisibility = param1;
         this.dispatchEventWith("change");
      }
      
      public function get useVirtualLayout() : Boolean
      {
         return this._useVirtualLayout;
      }
      
      public function set useVirtualLayout(param1:Boolean) : void
      {
         if(this._useVirtualLayout == param1)
         {
            return;
         }
         this._useVirtualLayout = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItem() : DisplayObject
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:DisplayObject) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
      }
      
      public function get resetTypicalItemDimensionsOnMeasure() : Boolean
      {
         return this._resetTypicalItemDimensionsOnMeasure;
      }
      
      public function set resetTypicalItemDimensionsOnMeasure(param1:Boolean) : void
      {
         if(this._resetTypicalItemDimensionsOnMeasure == param1)
         {
            return;
         }
         this._resetTypicalItemDimensionsOnMeasure = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItemWidth() : Number
      {
         return this._typicalItemWidth;
      }
      
      public function set typicalItemWidth(param1:Number) : void
      {
         if(this._typicalItemWidth == param1)
         {
            return;
         }
         this._typicalItemWidth = param1;
         this.dispatchEventWith("change");
      }
      
      public function get typicalItemHeight() : Number
      {
         return this._typicalItemHeight;
      }
      
      public function set typicalItemHeight(param1:Number) : void
      {
         if(this._typicalItemHeight == param1)
         {
            return;
         }
         this._typicalItemHeight = param1;
         this.dispatchEventWith("change");
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._manageVisibility || this._useVirtualLayout;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc44_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc35_:int = 0;
         var _loc39_:DisplayObject = null;
         var _loc8_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc30_:* = 0;
         var _loc6_:int = 0;
         var _loc20_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         if(param1.length == 0)
         {
            param3.contentX = 0;
            param3.contentY = 0;
            param3.contentWidth = 0;
            param3.contentHeight = 0;
            param3.viewPortWidth = 0;
            param3.viewPortHeight = 0;
            return param3;
         }
         var _loc12_:Number = param2 ? param2.scrollX : 0;
         var _loc7_:Number = param2 ? param2.scrollY : 0;
         var _loc41_:Number = param2 ? param2.x : 0;
         var _loc45_:Number = param2 ? param2.y : 0;
         var _loc4_:Number = param2 ? param2.minWidth : 0;
         var _loc37_:Number = param2 ? param2.minHeight : 0;
         var _loc23_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc40_:Number = param2 ? param2.maxHeight : Infinity;
         var _loc11_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc28_:Number = param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc44_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc22_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         this.validateItems(param1);
         this._discoveredItemsCache.length = 0;
         var _loc43_:int = int(param1.length);
         var _loc32_:* = this._useVirtualLayout ? _loc44_ : 0;
         var _loc9_:* = this._useVirtualLayout ? _loc22_ : 0;
         if(!this._useVirtualLayout)
         {
            _loc35_ = 0;
            while(_loc35_ < _loc43_)
            {
               _loc39_ = param1[_loc35_];
               if(_loc39_)
               {
                  if(!(_loc39_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc39_).includeInLayout))
                  {
                     _loc8_ = _loc39_.width;
                     _loc33_ = _loc39_.height;
                     if(_loc8_ > _loc32_)
                     {
                        _loc32_ = _loc8_;
                     }
                     if(_loc33_ > _loc9_)
                     {
                        _loc9_ = _loc33_;
                     }
                  }
               }
               _loc35_++;
            }
         }
         if(_loc32_ < 0)
         {
            _loc32_ = 0;
         }
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc32_ > _loc9_)
            {
               _loc9_ = _loc32_;
            }
            else if(_loc9_ > _loc32_)
            {
               _loc32_ = _loc9_;
            }
         }
         var _loc38_:* = NaN;
         var _loc24_:* = NaN;
         if(_loc28_ === _loc28_)
         {
            _loc24_ = _loc28_;
            _loc30_ = (_loc28_ - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc9_ + this._verticalGap);
         }
         else if(_loc40_ === _loc40_ && _loc40_ < Infinity)
         {
            _loc24_ = _loc40_;
            _loc30_ = (_loc40_ - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc9_ + this._verticalGap);
         }
         else
         {
            _loc30_ = _loc43_;
         }
         if(_loc30_ < 1)
         {
            _loc30_ = 1;
         }
         else if(this._requestedRowCount > 0)
         {
            if(_loc24_ !== _loc24_)
            {
               _loc30_ = this._requestedRowCount;
               _loc24_ = _loc30_ * (_loc9_ + this._verticalGap) - this._verticalGap - this._paddingTop - this._paddingBottom;
            }
            else if(_loc30_ > this._requestedRowCount)
            {
               _loc30_ = this._requestedRowCount;
            }
         }
         if(_loc11_ === _loc11_)
         {
            _loc38_ = _loc11_;
            _loc6_ = (_loc11_ - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc32_ + this._horizontalGap);
         }
         else if(_loc23_ === _loc23_ && _loc23_ < Infinity)
         {
            _loc38_ = _loc23_;
            _loc6_ = (_loc23_ - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc32_ + this._horizontalGap);
         }
         else
         {
            _loc6_ = Math.ceil(_loc43_ / _loc30_);
         }
         if(_loc6_ < 1)
         {
            _loc6_ = 1;
         }
         else if(this._requestedColumnCount > 0)
         {
            if(_loc38_ !== _loc38_)
            {
               _loc6_ = this._requestedColumnCount;
               _loc38_ = _loc6_ * (_loc32_ + this._horizontalGap) - this._horizontalGap - this._paddingLeft - this._paddingRight;
            }
            else if(_loc6_ > this._requestedColumnCount)
            {
               _loc6_ = this._requestedColumnCount;
            }
         }
         var _loc25_:Number = _loc6_ * (_loc32_ + this._horizontalGap) - this._horizontalGap + this._paddingLeft + this._paddingRight;
         var _loc10_:Number = _loc30_ * (_loc9_ + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
         var _loc26_:* = _loc38_;
         if(_loc26_ !== _loc26_)
         {
            _loc26_ = _loc25_;
         }
         var _loc27_:* = _loc24_;
         if(_loc27_ !== _loc27_)
         {
            _loc27_ = _loc10_;
         }
         var _loc17_:Number = _loc41_ + this._paddingLeft;
         var _loc18_:Number = _loc45_ + this._paddingTop;
         var _loc31_:int = _loc6_ * _loc30_;
         var _loc34_:int = 0;
         var _loc42_:* = _loc31_;
         var _loc29_:* = _loc18_;
         var _loc21_:* = _loc17_;
         var _loc5_:* = _loc18_;
         var _loc36_:int = 0;
         var _loc19_:int = 0;
         _loc35_ = 0;
         while(_loc35_ < _loc43_)
         {
            _loc39_ = param1[_loc35_];
            if(!(_loc39_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc39_).includeInLayout))
            {
               if(_loc36_ != 0 && _loc35_ % _loc30_ == 0)
               {
                  _loc21_ += _loc32_ + this._horizontalGap;
                  _loc5_ = _loc29_;
               }
               if(_loc36_ == _loc42_)
               {
                  if(this._paging != "none")
                  {
                     _loc20_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
                     _loc15_ = this._useVirtualLayout ? 0 : _loc36_ - _loc31_;
                     _loc16_ = this._useVirtualLayout ? this._discoveredItemsCache.length - 1 : _loc36_ - 1;
                     this.applyHorizontalAlign(_loc20_,_loc15_,_loc16_,_loc25_,_loc26_);
                     this.applyVerticalAlign(_loc20_,_loc15_,_loc16_,_loc10_,_loc27_);
                     if(this.manageVisibility)
                     {
                        this.applyVisible(_loc20_,_loc15_,_loc16_,_loc41_ + _loc12_,_loc12_ + _loc38_,_loc45_ + _loc7_,_loc7_ + _loc24_);
                     }
                     this._discoveredItemsCache.length = 0;
                     _loc19_ = 0;
                  }
                  _loc34_++;
                  _loc42_ += _loc31_;
                  if(this._paging == "horizontal")
                  {
                     _loc21_ = _loc17_ + _loc38_ * _loc34_;
                  }
                  else if(this._paging == "vertical")
                  {
                     _loc21_ = _loc17_;
                     _loc5_ = _loc29_ = _loc18_ + _loc24_ * _loc34_;
                  }
               }
               if(_loc39_)
               {
                  switch(this._tileHorizontalAlign)
                  {
                     case "justify":
                        _loc39_.x = _loc39_.pivotX + _loc21_;
                        _loc39_.width = _loc32_;
                        break;
                     case "left":
                        _loc39_.x = _loc39_.pivotX + _loc21_;
                        break;
                     case "right":
                        _loc39_.x = _loc39_.pivotX + _loc21_ + _loc32_ - _loc39_.width;
                        break;
                     default:
                        _loc39_.x = _loc39_.pivotX + _loc21_ + Math.round((_loc32_ - _loc39_.width) / 2);
                  }
                  switch(this._tileVerticalAlign)
                  {
                     case "justify":
                        _loc39_.y = _loc39_.pivotY + _loc5_;
                        _loc39_.height = _loc9_;
                        break;
                     case "top":
                        _loc39_.y = _loc39_.pivotY + _loc5_;
                        break;
                     case "bottom":
                        _loc39_.y = _loc39_.pivotY + _loc5_ + _loc9_ - _loc39_.height;
                        break;
                     default:
                        _loc39_.y = _loc39_.pivotY + _loc5_ + Math.round((_loc9_ - _loc39_.height) / 2);
                  }
                  if(this._useVirtualLayout)
                  {
                     this._discoveredItemsCache[_loc19_] = _loc39_;
                     _loc19_++;
                  }
               }
               _loc5_ += _loc9_ + this._verticalGap;
               _loc36_++;
            }
            _loc35_++;
         }
         if(this._paging != "none")
         {
            _loc20_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
            _loc15_ = this._useVirtualLayout ? 0 : _loc42_ - _loc31_;
            _loc16_ = this._useVirtualLayout ? this._discoveredItemsCache.length - 1 : _loc35_ - 1;
            this.applyHorizontalAlign(_loc20_,_loc15_,_loc16_,_loc25_,_loc26_);
            this.applyVerticalAlign(_loc20_,_loc15_,_loc16_,_loc10_,_loc27_);
            if(this.manageVisibility)
            {
               this.applyVisible(_loc20_,_loc15_,_loc16_,_loc41_ + _loc12_,_loc12_ + _loc38_,_loc45_ + _loc7_,_loc7_ + _loc24_);
            }
         }
         var _loc14_:* = _loc21_ + _loc32_ + this._paddingRight;
         if(_loc38_ === _loc38_)
         {
            if(this._paging == "vertical")
            {
               _loc14_ = _loc38_;
            }
            else if(this._paging == "horizontal")
            {
               _loc14_ = Math.ceil(_loc43_ / _loc31_) * _loc38_;
            }
         }
         var _loc13_:* = _loc10_;
         if(_loc24_ === _loc24_ && this._paging == "vertical")
         {
            _loc13_ = Math.ceil(_loc43_ / _loc31_) * _loc24_;
         }
         if(_loc38_ !== _loc38_)
         {
            _loc38_ = _loc14_;
         }
         if(_loc24_ !== _loc24_)
         {
            _loc24_ = _loc13_;
         }
         if(_loc38_ < _loc4_)
         {
            _loc38_ = _loc4_;
         }
         if(_loc24_ < _loc37_)
         {
            _loc24_ = _loc37_;
         }
         if(this._paging == "none")
         {
            _loc20_ = this._useVirtualLayout ? this._discoveredItemsCache : param1;
            _loc16_ = _loc20_.length - 1;
            this.applyHorizontalAlign(_loc20_,0,_loc16_,_loc14_,_loc38_);
            this.applyVerticalAlign(_loc20_,0,_loc16_,_loc13_,_loc24_);
            if(this.manageVisibility)
            {
               this.applyVisible(_loc20_,_loc15_,_loc16_,_loc41_ + _loc12_,_loc12_ + _loc38_,_loc45_ + _loc7_,_loc7_ + _loc24_);
            }
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentX = 0;
         param3.contentY = 0;
         param3.contentWidth = _loc14_;
         param3.contentHeight = _loc13_;
         param3.viewPortWidth = _loc38_;
         param3.viewPortHeight = _loc24_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc18_:* = 0;
         var _loc5_:int = 0;
         var _loc21_:int = 0;
         var _loc29_:* = NaN;
         var _loc30_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc7_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc17_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc23_:* = _loc7_ !== _loc7_;
         var _loc16_:* = _loc17_ !== _loc17_;
         if(!_loc23_ && !_loc16_)
         {
            param3.x = _loc7_;
            param3.y = _loc17_;
            return param3;
         }
         var _loc26_:Number = param2 ? param2.x : 0;
         var _loc32_:Number = param2 ? param2.y : 0;
         var _loc4_:Number = param2 ? param2.minWidth : 0;
         var _loc24_:Number = param2 ? param2.minHeight : 0;
         var _loc14_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc27_:Number = param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem();
         var _loc31_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc13_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc19_:* = _loc31_;
         var _loc6_:* = _loc13_;
         if(_loc19_ < 0)
         {
            _loc19_ = 0;
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc19_ > _loc6_)
            {
               _loc6_ = _loc19_;
            }
            else if(_loc6_ > _loc19_)
            {
               _loc19_ = _loc6_;
            }
         }
         var _loc25_:* = NaN;
         var _loc15_:* = NaN;
         if(_loc17_ === _loc17_)
         {
            _loc15_ = _loc17_;
            _loc18_ = (_loc17_ - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc6_ + this._verticalGap);
         }
         else if(_loc27_ === _loc27_ && _loc27_ < Infinity)
         {
            _loc15_ = _loc27_;
            _loc18_ = (_loc27_ - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc6_ + this._verticalGap);
         }
         else
         {
            _loc18_ = param1;
         }
         if(_loc18_ < 1)
         {
            _loc18_ = 1;
         }
         else if(this._requestedRowCount > 0)
         {
            if(_loc15_ !== _loc15_)
            {
               _loc18_ = this._requestedRowCount;
               _loc15_ = _loc18_ * (_loc6_ + this._verticalGap) - this._verticalGap - this._paddingTop - this._paddingBottom;
            }
            else if(_loc18_ > this._requestedRowCount)
            {
               _loc18_ = this._requestedRowCount;
            }
         }
         if(_loc7_ === _loc7_)
         {
            _loc25_ = _loc7_;
            _loc5_ = (_loc7_ - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc19_ + this._horizontalGap);
         }
         else if(_loc14_ === _loc14_ && _loc14_ < Infinity)
         {
            _loc25_ = _loc14_;
            _loc5_ = (_loc14_ - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc19_ + this._horizontalGap);
         }
         else
         {
            _loc5_ = Math.ceil(param1 / _loc18_);
         }
         if(_loc5_ < 1)
         {
            _loc5_ = 1;
         }
         else if(this._requestedColumnCount > 0)
         {
            if(_loc25_ !== _loc25_)
            {
               _loc5_ = this._requestedColumnCount;
               _loc25_ = _loc5_ * (_loc19_ + this._horizontalGap) - this._horizontalGap - this._paddingLeft - this._paddingRight;
            }
            else if(_loc5_ > this._requestedColumnCount)
            {
               _loc5_ = this._requestedColumnCount;
            }
         }
         var _loc8_:Number = _loc18_ * (_loc6_ + this._verticalGap) - this._verticalGap + this._paddingTop + this._paddingBottom;
         var _loc11_:Number = _loc26_ + this._paddingLeft;
         var _loc20_:int = _loc5_ * _loc18_;
         var _loc22_:int = 0;
         var _loc28_:* = _loc20_;
         var _loc12_:* = _loc11_;
         _loc21_ = 0;
         while(_loc21_ < param1)
         {
            if(_loc21_ != 0 && _loc21_ % _loc18_ == 0)
            {
               _loc12_ += _loc19_ + this._horizontalGap;
            }
            if(_loc21_ == _loc28_)
            {
               _loc22_++;
               _loc28_ += _loc20_;
               if(this._paging == "horizontal")
               {
                  _loc12_ = _loc11_ + _loc25_ * _loc22_;
               }
               else if(this._paging == "vertical")
               {
                  _loc12_ = _loc11_;
               }
            }
            _loc21_++;
         }
         var _loc10_:* = _loc12_ + _loc19_ + this._paddingRight;
         if(_loc25_ === _loc25_)
         {
            if(this._paging == "vertical")
            {
               _loc10_ = _loc25_;
            }
            else if(this._paging == "horizontal")
            {
               _loc10_ = Math.ceil(param1 / _loc20_) * _loc25_;
            }
         }
         var _loc9_:* = _loc8_;
         if(_loc15_ === _loc15_ && this._paging == "vertical")
         {
            _loc9_ = Math.ceil(param1 / _loc20_) * _loc15_;
         }
         if(_loc23_)
         {
            _loc29_ = _loc10_;
            if(_loc29_ < _loc4_)
            {
               _loc29_ = _loc4_;
            }
            else if(_loc29_ > _loc14_)
            {
               _loc29_ = _loc14_;
            }
            param3.x = _loc29_;
         }
         else
         {
            param3.x = _loc7_;
         }
         if(_loc16_)
         {
            _loc30_ = _loc9_;
            if(_loc30_ < _loc24_)
            {
               _loc30_ = _loc24_;
            }
            else if(_loc30_ > _loc27_)
            {
               _loc30_ = _loc27_;
            }
            param3.y = _loc30_;
         }
         else
         {
            param3.y = _loc17_;
         }
         return param3;
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         if(param6)
         {
            param6.length = 0;
         }
         else
         {
            param6 = new Vector.<int>(0);
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("getVisibleIndicesAtScrollPosition() may be called only if useVirtualLayout is true.");
         }
         if(this._paging == "horizontal")
         {
            this.getVisibleIndicesAtScrollPositionWithHorizontalPaging(param1,param2,param3,param4,param5,param6);
         }
         else if(this._paging == "vertical")
         {
            this.getVisibleIndicesAtScrollPositionWithVerticalPaging(param1,param2,param3,param4,param5,param6);
         }
         else
         {
            this.getVisibleIndicesAtScrollPositionWithoutPaging(param1,param2,param3,param4,param5,param6);
         }
         return param6;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc20_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:DisplayObject = null;
         var _loc10_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc9_:int = 0;
         var _loc11_:Number = NaN;
         var _loc15_:int = 0;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem();
            _loc20_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc18_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc19_:int = int(param2.length);
         var _loc12_:* = this._useVirtualLayout ? _loc20_ : 0;
         var _loc13_:* = this._useVirtualLayout ? _loc18_ : 0;
         if(!this._useVirtualLayout)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc19_)
            {
               _loc17_ = param2[_loc16_];
               if(_loc17_)
               {
                  if(!(_loc17_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc17_).includeInLayout))
                  {
                     _loc10_ = _loc17_.width;
                     _loc14_ = _loc17_.height;
                     if(_loc10_ > _loc12_)
                     {
                        _loc12_ = _loc10_;
                     }
                     if(_loc14_ > _loc13_)
                     {
                        _loc13_ = _loc14_;
                     }
                  }
               }
               _loc16_++;
            }
         }
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         if(_loc13_ < 0)
         {
            _loc13_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc12_ > _loc13_)
            {
               _loc13_ = _loc12_;
            }
            else if(_loc13_ > _loc12_)
            {
               _loc12_ = _loc13_;
            }
         }
         var _loc8_:int = (param6 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc13_ + this._verticalGap);
         if(_loc8_ < 1)
         {
            _loc8_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc8_ > this._requestedRowCount)
         {
            _loc8_ = this._requestedRowCount;
         }
         if(this._paging != "none")
         {
            _loc9_ = (param5 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc12_ + this._horizontalGap);
            if(_loc9_ < 1)
            {
               _loc9_ = 1;
            }
            _loc11_ = _loc9_ * _loc8_;
            _loc15_ = param1 / _loc11_;
            if(this._paging == "horizontal")
            {
               param7.x = _loc15_ * param5;
               param7.y = 0;
            }
            else
            {
               param7.x = 0;
               param7.y = _loc15_ * param6;
            }
         }
         else
         {
            param7.x = this._paddingLeft + (_loc12_ + this._horizontalGap) * (int(param1 / _loc8_)) - Math.round((param5 - _loc12_) / 2);
            param7.y = 0;
         }
         return param7;
      }
      
      protected function applyVisible(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         var _loc11_:* = 0;
         var _loc10_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc11_ = param2;
         while(_loc11_ <= param3)
         {
            _loc10_ = param1[_loc11_];
            if(!(_loc10_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc10_).includeInLayout))
            {
               _loc9_ = _loc10_.x - _loc10_.pivotX;
               _loc8_ = _loc10_.y - _loc10_.pivotY;
               _loc10_.visible = _loc9_ + _loc10_.width >= param4 && _loc9_ < param5 && _loc8_ + _loc10_.height >= param6 && _loc8_ < param7;
            }
            _loc11_++;
         }
      }
      
      protected function applyHorizontalAlign(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Number, param5:Number) : void
      {
         var _loc8_:* = 0;
         var _loc7_:DisplayObject = null;
         if(param4 >= param5)
         {
            return;
         }
         var _loc6_:Number = 0;
         if(this._horizontalAlign == "right")
         {
            _loc6_ = param5 - param4;
         }
         else if(this._horizontalAlign != "left")
         {
            _loc6_ = Math.round((param5 - param4) / 2);
         }
         if(_loc6_ != 0)
         {
            _loc8_ = param2;
            while(_loc8_ <= param3)
            {
               _loc7_ = param1[_loc8_];
               if(!(_loc7_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc7_).includeInLayout))
               {
                  _loc7_.x += _loc6_;
               }
               _loc8_++;
            }
         }
      }
      
      protected function applyVerticalAlign(param1:Vector.<DisplayObject>, param2:int, param3:int, param4:Number, param5:Number) : void
      {
         var _loc8_:* = 0;
         var _loc7_:DisplayObject = null;
         if(param4 >= param5)
         {
            return;
         }
         var _loc6_:Number = 0;
         if(this._verticalAlign == "bottom")
         {
            _loc6_ = param5 - param4;
         }
         else if(this._verticalAlign == "middle")
         {
            _loc6_ = Math.round((param5 - param4) / 2);
         }
         if(_loc6_ != 0)
         {
            _loc8_ = param2;
            while(_loc8_ <= param3)
            {
               _loc7_ = param1[_loc8_];
               if(!(_loc7_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc7_).includeInLayout))
               {
                  _loc7_.y += _loc6_;
               }
               _loc8_++;
            }
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithHorizontalPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         var _loc23_:* = 0;
         this.prepareTypicalItem();
         var _loc25_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc15_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc20_:* = _loc25_;
         var _loc11_:* = _loc15_;
         if(_loc20_ < 0)
         {
            _loc20_ = 0;
         }
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc20_ > _loc11_)
            {
               _loc11_ = _loc20_;
            }
            else if(_loc11_ > _loc20_)
            {
               _loc20_ = _loc11_;
            }
         }
         var _loc9_:int = (param3 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc20_ + this._horizontalGap);
         if(_loc9_ < 1)
         {
            _loc9_ = 1;
         }
         var _loc18_:int = (param4 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc11_ + this._verticalGap);
         if(_loc18_ < 1)
         {
            _loc18_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc18_ > this._requestedRowCount)
         {
            _loc18_ = this._requestedRowCount;
         }
         var _loc21_:int = _loc9_ * _loc18_;
         var _loc22_:* = _loc21_ + 2 * _loc18_;
         if(_loc22_ > param5)
         {
            _loc22_ = param5;
         }
         var _loc8_:int = Math.round(param1 / param3);
         var _loc7_:int = _loc8_ * _loc21_;
         var _loc10_:Number = _loc9_ * (_loc20_ + this._horizontalGap) - this._horizontalGap;
         var _loc16_:Number = 0;
         var _loc14_:Number = 0;
         if(_loc10_ < param3)
         {
            if(this._horizontalAlign == "right")
            {
               _loc16_ = param3 - this._paddingLeft - this._paddingRight - _loc10_;
               _loc14_ = 0;
            }
            else if(this._horizontalAlign == "center")
            {
               _loc16_ = _loc14_ = Math.round((param3 - this._paddingLeft - this._paddingRight - _loc10_) / 2);
            }
            else if(this._horizontalAlign == "left")
            {
               _loc16_ = 0;
               _loc14_ = param3 - this._paddingLeft - this._paddingRight - _loc10_;
            }
         }
         var _loc12_:int = 0;
         var _loc13_:Number = _loc8_ * param3;
         var _loc17_:Number = param1 - _loc13_;
         if(_loc17_ < 0)
         {
            _loc17_ = -_loc17_ - this._paddingRight - _loc14_;
            if(_loc17_ < 0)
            {
               _loc17_ = 0;
            }
            _loc12_ = -Math.floor(_loc17_ / (_loc20_ + this._horizontalGap)) - 1;
            _loc7_ += _loc12_ * _loc18_;
         }
         else if(_loc17_ > 0)
         {
            _loc17_ = _loc17_ - this._paddingLeft - _loc16_;
            if(_loc17_ < 0)
            {
               _loc17_ = 0;
            }
            _loc12_ = Math.floor(_loc17_ / (_loc20_ + this._horizontalGap));
            _loc7_ += _loc12_ * _loc18_;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
            _loc12_ = 0;
         }
         var _loc24_:* = _loc7_ + _loc22_;
         if(_loc24_ > param5)
         {
            _loc24_ = param5;
         }
         _loc7_ = _loc24_ - _loc22_;
         var _loc19_:int = int(param6.length);
         _loc23_ = _loc7_;
         while(_loc23_ < _loc24_)
         {
            param6[_loc19_] = _loc23_;
            _loc19_++;
            _loc23_++;
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithVerticalPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         var _loc21_:int = 0;
         var _loc25_:* = 0;
         var _loc27_:int = 0;
         var _loc26_:int = 0;
         var _loc18_:int = 0;
         var _loc14_:int = 0;
         this.prepareTypicalItem();
         var _loc28_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc15_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc22_:* = _loc28_;
         var _loc10_:* = _loc15_;
         if(_loc22_ < 0)
         {
            _loc22_ = 0;
         }
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc22_ > _loc10_)
            {
               _loc10_ = _loc22_;
            }
            else if(_loc10_ > _loc22_)
            {
               _loc22_ = _loc10_;
            }
         }
         var _loc9_:int = (param3 - this._paddingLeft - this._paddingRight + this._horizontalGap) / (_loc22_ + this._horizontalGap);
         if(_loc9_ < 1)
         {
            _loc9_ = 1;
         }
         var _loc17_:int = (param4 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc10_ + this._verticalGap);
         if(_loc17_ < 1)
         {
            _loc17_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc17_ > this._requestedRowCount)
         {
            _loc17_ = this._requestedRowCount;
         }
         var _loc23_:int = _loc9_ * _loc17_;
         var _loc24_:* = _loc23_ + 2 * _loc17_;
         if(_loc24_ > param5)
         {
            _loc24_ = param5;
         }
         var _loc8_:int = Math.round(param2 / param4);
         var _loc7_:int = _loc8_ * _loc23_;
         var _loc12_:Number = _loc17_ * (_loc10_ + this._verticalGap) - this._verticalGap;
         var _loc20_:Number = 0;
         var _loc19_:Number = 0;
         if(_loc12_ < param4)
         {
            if(this._verticalAlign == "bottom")
            {
               _loc20_ = param4 - this._paddingTop - this._paddingBottom - _loc12_;
               _loc19_ = 0;
            }
            else if(this._horizontalAlign == "middle")
            {
               _loc20_ = _loc19_ = Math.round((param4 - this._paddingTop - this._paddingBottom - _loc12_) / 2);
            }
            else if(this._horizontalAlign == "top")
            {
               _loc20_ = 0;
               _loc19_ = param4 - this._paddingTop - this._paddingBottom - _loc12_;
            }
         }
         var _loc11_:int = 0;
         var _loc13_:Number = _loc8_ * param4;
         var _loc16_:Number = param2 - _loc13_;
         if(_loc16_ < 0)
         {
            _loc16_ = -_loc16_ - this._paddingBottom - _loc19_;
            if(_loc16_ < 0)
            {
               _loc16_ = 0;
            }
            _loc11_ = -Math.floor(_loc16_ / (_loc22_ + this._verticalGap)) - 1;
            _loc7_ += -_loc23_ + _loc9_ + _loc11_;
         }
         else if(_loc16_ > 0)
         {
            _loc16_ = _loc16_ - this._paddingTop - _loc20_;
            if(_loc16_ < 0)
            {
               _loc16_ = 0;
            }
            _loc11_ = Math.floor(_loc16_ / (_loc22_ + this._verticalGap));
            _loc7_ += _loc11_;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
            _loc11_ = 0;
         }
         if(_loc7_ + _loc24_ >= param5)
         {
            _loc7_ = param5 - _loc24_;
            _loc21_ = int(param6.length);
            _loc25_ = _loc7_;
            while(_loc25_ < param5)
            {
               param6[_loc21_] = _loc25_;
               _loc21_++;
               _loc25_++;
            }
         }
         else
         {
            _loc27_ = 0;
            _loc26_ = (_loc17_ + _loc11_) % _loc17_;
            _loc18_ = int(_loc7_ / _loc23_) * _loc23_;
            _loc25_ = _loc7_;
            _loc14_ = 0;
            do
            {
               if(_loc25_ < param5)
               {
                  param6[_loc14_] = _loc25_;
                  _loc14_++;
               }
               if(++_loc27_ == _loc9_)
               {
                  _loc27_ = 0;
                  if(++_loc26_ == _loc17_)
                  {
                     _loc26_ = 0;
                     _loc18_ += _loc23_;
                  }
                  _loc25_ = _loc18_ + _loc26_ - _loc17_;
               }
               _loc25_ += _loc17_;
            }
            while(_loc14_ < _loc24_ && _loc18_ < param5);
            
         }
      }
      
      protected function getVisibleIndicesAtScrollPositionWithoutPaging(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int>) : void
      {
         var _loc14_:* = 0;
         this.prepareTypicalItem();
         var _loc20_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc18_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc11_:* = _loc20_;
         var _loc12_:* = _loc18_;
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         if(_loc12_ < 0)
         {
            _loc12_ = 0;
         }
         if(this._useSquareTiles)
         {
            if(_loc11_ > _loc12_)
            {
               _loc12_ = _loc11_;
            }
            else if(_loc12_ > _loc11_)
            {
               _loc11_ = _loc12_;
            }
         }
         var _loc7_:int = (param4 - this._paddingTop - this._paddingBottom + this._verticalGap) / (_loc12_ + this._verticalGap);
         if(_loc7_ < 1)
         {
            _loc7_ = 1;
         }
         else if(this._requestedRowCount > 0 && _loc7_ > this._requestedRowCount)
         {
            _loc7_ = this._requestedRowCount;
         }
         var _loc10_:int = Math.ceil((param3 + this._horizontalGap) / (_loc11_ + this._horizontalGap)) + 1;
         var _loc13_:* = _loc7_ * _loc10_;
         if(_loc13_ > param5)
         {
            _loc13_ = param5;
         }
         var _loc15_:int = 0;
         var _loc17_:Number = Math.ceil(param5 / _loc7_) * (_loc11_ + this._horizontalGap) - this._horizontalGap;
         if(_loc17_ < param3)
         {
            if(this._verticalAlign == "bottom")
            {
               _loc15_ = Math.ceil((param3 - _loc17_) / (_loc11_ + this._horizontalGap));
            }
            else if(this._verticalAlign == "middle")
            {
               _loc15_ = Math.ceil((param3 - _loc17_) / (_loc11_ + this._horizontalGap) / 2);
            }
         }
         var _loc19_:int = -_loc15_ + Math.floor((param1 - this._paddingLeft + this._horizontalGap) / (_loc11_ + this._horizontalGap));
         var _loc8_:int = _loc19_ * _loc7_;
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         var _loc16_:* = _loc8_ + _loc13_;
         if(_loc16_ > param5)
         {
            _loc16_ = param5;
         }
         _loc8_ = _loc16_ - _loc13_;
         var _loc9_:int = int(param6.length);
         _loc14_ = _loc8_;
         while(_loc14_ < _loc16_)
         {
            param6[_loc9_] = _loc14_;
            _loc9_++;
            _loc14_++;
         }
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>) : void
      {
         var _loc4_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_];
            if(!(_loc2_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc2_).includeInLayout))
            {
               if(_loc2_ is IValidating)
               {
                  IValidating(_loc2_).validate();
               }
            }
            _loc4_++;
         }
      }
      
      protected function prepareTypicalItem() : void
      {
         if(!this._typicalItem)
         {
            return;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
   }
}

