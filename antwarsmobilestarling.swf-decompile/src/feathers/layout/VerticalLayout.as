package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class VerticalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
      
      protected var _heightCache:Array = [];
      
      protected var _discoveredItemsCache:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _verticalAlign:String = "top";
      
      protected var _horizontalAlign:String = "left";
      
      protected var _useVirtualLayout:Boolean = true;
      
      protected var _hasVariableItemDimensions:Boolean = false;
      
      protected var _distributeHeights:Boolean = false;
      
      protected var _manageVisibility:Boolean = false;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _scrollPositionVerticalAlign:String = "middle";
      
      public function VerticalLayout()
      {
         super();
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
         this.dispatchEventWith("change");
      }
      
      public function get firstGap() : Number
      {
         return this._firstGap;
      }
      
      public function set firstGap(param1:Number) : void
      {
         if(this._firstGap == param1)
         {
            return;
         }
         this._firstGap = param1;
         this.dispatchEventWith("change");
      }
      
      public function get lastGap() : Number
      {
         return this._lastGap;
      }
      
      public function set lastGap(param1:Number) : void
      {
         if(this._lastGap == param1)
         {
            return;
         }
         this._lastGap = param1;
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
      
      public function get hasVariableItemDimensions() : Boolean
      {
         return this._hasVariableItemDimensions;
      }
      
      public function set hasVariableItemDimensions(param1:Boolean) : void
      {
         if(this._hasVariableItemDimensions == param1)
         {
            return;
         }
         this._hasVariableItemDimensions = param1;
         this.dispatchEventWith("change");
      }
      
      public function get distributeHeights() : Boolean
      {
         return this._distributeHeights;
      }
      
      public function set distributeHeights(param1:Boolean) : void
      {
         if(this._distributeHeights == param1)
         {
            return;
         }
         this._distributeHeights = param1;
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
      
      public function get beforeVirtualizedItemCount() : int
      {
         return this._beforeVirtualizedItemCount;
      }
      
      public function set beforeVirtualizedItemCount(param1:int) : void
      {
         if(this._beforeVirtualizedItemCount == param1)
         {
            return;
         }
         this._beforeVirtualizedItemCount = param1;
         this.dispatchEventWith("change");
      }
      
      public function get afterVirtualizedItemCount() : int
      {
         return this._afterVirtualizedItemCount;
      }
      
      public function set afterVirtualizedItemCount(param1:int) : void
      {
         if(this._afterVirtualizedItemCount == param1)
         {
            return;
         }
         this._afterVirtualizedItemCount = param1;
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
         this.dispatchEventWith("change");
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
      
      public function get scrollPositionVerticalAlign() : String
      {
         return this._scrollPositionVerticalAlign;
      }
      
      public function set scrollPositionVerticalAlign(param1:String) : void
      {
         this._scrollPositionVerticalAlign = param1;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._manageVisibility || this._useVirtualLayout;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc44_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc31_:int = 0;
         var _loc37_:DisplayObject = null;
         var _loc28_:int = 0;
         var _loc45_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc9_:* = NaN;
         var _loc30_:* = NaN;
         var _loc36_:Number = NaN;
         var _loc7_:ILayoutDisplayObject = null;
         var _loc14_:VerticalLayoutData = null;
         var _loc41_:Number = NaN;
         var _loc29_:IFeathersControl = null;
         var _loc21_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc12_:Number = param2 ? param2.scrollX : 0;
         var _loc10_:Number = param2 ? param2.scrollY : 0;
         var _loc39_:Number = param2 ? param2.x : 0;
         var _loc46_:Number = param2 ? param2.y : 0;
         var _loc6_:Number = param2 ? param2.minWidth : 0;
         var _loc33_:Number = param2 ? param2.minHeight : 0;
         var _loc23_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc38_:Number = param2 ? param2.maxHeight : Infinity;
         var _loc11_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc27_:Number = param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc11_ - this._paddingLeft - this._paddingRight);
            _loc44_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc20_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeHeights || this._horizontalAlign != "justify" || _loc11_ !== _loc11_)
         {
            this.validateItems(param1,_loc11_ - this._paddingLeft - this._paddingRight,_loc27_);
         }
         if(!this._useVirtualLayout)
         {
            this.applyPercentHeights(param1,_loc27_,_loc33_,_loc38_);
         }
         if(this._distributeHeights)
         {
            _loc26_ = this.calculateDistributedHeight(param1,_loc27_,_loc33_,_loc38_);
         }
         var _loc18_:* = _loc26_ === _loc26_;
         this._discoveredItemsCache.length = 0;
         var _loc25_:* = this._firstGap === this._firstGap;
         var _loc4_:* = this._lastGap === this._lastGap;
         var _loc5_:* = this._useVirtualLayout ? _loc44_ : 0;
         var _loc8_:Number = _loc46_ + this._paddingTop;
         var _loc34_:int = 0;
         var _loc43_:int;
         var _loc24_:* = _loc43_ = int(param1.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc24_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc34_ = this._beforeVirtualizedItemCount;
            _loc8_ += this._beforeVirtualizedItemCount * (_loc20_ + this._gap);
            if(_loc25_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc8_ = _loc8_ - this._gap + this._firstGap;
            }
         }
         var _loc32_:int = _loc24_ - 2;
         var _loc40_:int = 0;
         _loc31_ = 0;
         while(_loc31_ < _loc43_)
         {
            _loc37_ = param1[_loc31_];
            _loc28_ = _loc31_ + _loc34_;
            _loc45_ = this._gap;
            if(_loc25_ && _loc28_ == 0)
            {
               _loc45_ = this._firstGap;
            }
            else if(_loc4_ && _loc28_ > 0 && _loc28_ == _loc32_)
            {
               _loc45_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc42_ = Number(this._heightCache[_loc28_]);
            }
            if(this._useVirtualLayout && !_loc37_)
            {
               if(!this._hasVariableItemDimensions || _loc42_ !== _loc42_)
               {
                  _loc8_ += _loc20_ + _loc45_;
               }
               else
               {
                  _loc8_ += _loc42_ + _loc45_;
               }
            }
            else if(!(_loc37_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc37_).includeInLayout))
            {
               _loc37_.y = _loc37_.pivotY + _loc8_;
               _loc9_ = _loc37_.width;
               if(_loc18_)
               {
                  _loc37_.height = _loc30_ = _loc26_;
               }
               else
               {
                  _loc30_ = _loc37_.height;
               }
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc30_ != _loc42_)
                     {
                        this._heightCache[_loc28_] = _loc30_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc20_ >= 0)
                  {
                     _loc37_.height = _loc30_ = _loc20_;
                  }
               }
               _loc8_ += _loc30_ + _loc45_;
               if(_loc9_ > _loc5_)
               {
                  _loc5_ = _loc9_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc40_] = _loc37_;
                  _loc40_++;
               }
            }
            _loc31_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc8_ += this._afterVirtualizedItemCount * (_loc20_ + this._gap);
            if(_loc4_ && this._afterVirtualizedItemCount > 0)
            {
               _loc8_ = _loc8_ - this._gap + this._lastGap;
            }
         }
         var _loc19_:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : param1;
         var _loc17_:Number = _loc5_ + this._paddingLeft + this._paddingRight;
         var _loc35_:* = _loc11_;
         if(_loc35_ !== _loc35_)
         {
            _loc35_ = _loc17_;
            if(_loc35_ < _loc6_)
            {
               _loc35_ = _loc6_;
            }
            else if(_loc35_ > _loc23_)
            {
               _loc35_ = _loc23_;
            }
         }
         var _loc16_:int = int(_loc19_.length);
         var _loc15_:Number = _loc8_ - this._gap + this._paddingBottom - _loc46_;
         var _loc22_:* = _loc27_;
         if(_loc22_ !== _loc22_)
         {
            _loc22_ = _loc15_;
            if(_loc22_ < _loc33_)
            {
               _loc22_ = _loc33_;
            }
            else if(_loc22_ > _loc38_)
            {
               _loc22_ = _loc38_;
            }
         }
         if(_loc15_ < _loc22_)
         {
            _loc36_ = 0;
            if(this._verticalAlign == "bottom")
            {
               _loc36_ = _loc22_ - _loc15_;
            }
            else if(this._verticalAlign == "middle")
            {
               _loc36_ = Math.round((_loc22_ - _loc15_) / 2);
            }
            if(_loc36_ != 0)
            {
               _loc31_ = 0;
               while(_loc31_ < _loc16_)
               {
                  _loc37_ = _loc19_[_loc31_];
                  if(!(_loc37_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc37_).includeInLayout))
                  {
                     _loc37_.y += _loc36_;
                  }
                  _loc31_++;
               }
            }
         }
         _loc31_ = 0;
         while(_loc31_ < _loc16_)
         {
            _loc37_ = _loc19_[_loc31_];
            _loc7_ = _loc37_ as ILayoutDisplayObject;
            if(!(_loc7_ && !_loc7_.includeInLayout))
            {
               if(this._horizontalAlign == "justify")
               {
                  _loc37_.x = _loc37_.pivotX + _loc39_ + this._paddingLeft;
                  _loc37_.width = _loc35_ - this._paddingLeft - this._paddingRight;
               }
               else
               {
                  if(_loc7_)
                  {
                     _loc14_ = _loc7_.layoutData as VerticalLayoutData;
                     if(_loc14_)
                     {
                        _loc41_ = _loc14_.percentWidth;
                        if(_loc41_ === _loc41_)
                        {
                           if(_loc41_ < 0)
                           {
                              _loc41_ = 0;
                           }
                           if(_loc41_ > 100)
                           {
                              _loc41_ = 100;
                           }
                           _loc9_ = _loc41_ * (_loc35_ - this._paddingLeft - this._paddingRight) / 100;
                           if(_loc37_ is IFeathersControl)
                           {
                              _loc29_ = IFeathersControl(_loc37_);
                              _loc21_ = _loc29_.minWidth;
                              if(_loc9_ < _loc21_)
                              {
                                 _loc9_ = _loc21_;
                              }
                              else
                              {
                                 _loc13_ = _loc29_.maxWidth;
                                 if(_loc9_ > _loc13_)
                                 {
                                    _loc9_ = _loc13_;
                                 }
                              }
                           }
                           _loc37_.width = _loc9_;
                        }
                     }
                  }
                  switch(this._horizontalAlign)
                  {
                     case "right":
                        _loc37_.x = _loc37_.pivotX + _loc39_ + _loc35_ - this._paddingRight - _loc37_.width;
                        break;
                     case "center":
                        _loc37_.x = _loc37_.pivotX + _loc39_ + this._paddingLeft + Math.round((_loc35_ - this._paddingLeft - this._paddingRight - _loc37_.width) / 2);
                        break;
                     default:
                        _loc37_.x = _loc37_.pivotX + _loc39_ + this._paddingLeft;
                  }
               }
               if(this.manageVisibility)
               {
                  _loc37_.visible = _loc37_.y - _loc37_.pivotY + _loc37_.height >= _loc46_ + _loc10_ && _loc37_.y - _loc37_.pivotY < _loc10_ + _loc22_;
               }
            }
            _loc31_++;
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentWidth = this._horizontalAlign == "justify" ? _loc35_ : _loc17_;
         param3.contentHeight = _loc15_;
         param3.viewPortWidth = _loc35_;
         param3.viewPortHeight = _loc22_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc8_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc11_:int = 0;
         var _loc17_:Number = NaN;
         var _loc9_:* = NaN;
         var _loc21_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc4_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc12_:* = _loc10_ !== _loc10_;
         var _loc19_:* = _loc4_ !== _loc4_;
         if(!_loc12_ && !_loc19_)
         {
            param3.x = _loc10_;
            param3.y = _loc4_;
            return param3;
         }
         var _loc7_:Number = param2 ? param2.minWidth : 0;
         var _loc13_:Number = param2 ? param2.minHeight : 0;
         var _loc15_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc16_:Number = param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem(_loc10_ - this._paddingLeft - this._paddingRight);
         var _loc20_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc14_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc18_:* = this._firstGap === this._firstGap;
         var _loc5_:* = this._lastGap === this._lastGap;
         if(this._distributeHeights)
         {
            _loc8_ = (_loc14_ + this._gap) * param1;
         }
         else
         {
            _loc8_ = 0;
            _loc6_ = _loc20_;
            if(!this._hasVariableItemDimensions)
            {
               _loc8_ += (_loc14_ + this._gap) * param1;
            }
            else
            {
               _loc11_ = 0;
               while(_loc11_ < param1)
               {
                  _loc17_ = Number(this._heightCache[_loc11_]);
                  if(_loc17_ !== _loc17_)
                  {
                     _loc8_ += _loc14_ + this._gap;
                  }
                  else
                  {
                     _loc8_ += _loc17_ + this._gap;
                  }
                  _loc11_++;
               }
            }
         }
         _loc8_ -= this._gap;
         if(_loc18_ && param1 > 1)
         {
            _loc8_ = _loc8_ - this._gap + this._firstGap;
         }
         if(_loc5_ && param1 > 2)
         {
            _loc8_ = _loc8_ - this._gap + this._lastGap;
         }
         if(_loc12_)
         {
            _loc9_ = _loc6_ + this._paddingLeft + this._paddingRight;
            if(_loc9_ < _loc7_)
            {
               _loc9_ = _loc7_;
            }
            else if(_loc9_ > _loc15_)
            {
               _loc9_ = _loc15_;
            }
            param3.x = _loc9_;
         }
         else
         {
            param3.x = _loc10_;
         }
         if(_loc19_)
         {
            _loc21_ = _loc8_ + this._paddingTop + this._paddingBottom;
            if(_loc21_ < _loc13_)
            {
               _loc21_ = _loc13_;
            }
            else if(_loc21_ > _loc16_)
            {
               _loc21_ = _loc16_;
            }
            param3.y = _loc21_;
         }
         else
         {
            param3.y = _loc4_;
         }
         return param3;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._heightCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._heightCache[param1];
         if(param2)
         {
            this._heightCache[param1] = param2.height;
            this.dispatchEventWith("change");
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = param2 ? param2.height : undefined;
         this._heightCache.splice(param1,0,_loc3_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._heightCache.splice(param1,1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc26_:int = 0;
         var _loc17_:Number = NaN;
         var _loc9_:int = 0;
         var _loc27_:int = 0;
         var _loc22_:* = 0;
         var _loc30_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc21_:* = NaN;
         var _loc16_:* = NaN;
         var _loc20_:int = 0;
         var _loc25_:int = 0;
         var _loc19_:int = 0;
         var _loc11_:* = 0;
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
         this.prepareTypicalItem(param3 - this._paddingLeft - this._paddingRight);
         var _loc29_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc14_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc15_:* = this._firstGap === this._firstGap;
         var _loc7_:* = this._lastGap === this._lastGap;
         var _loc18_:* = 0;
         var _loc8_:int = Math.ceil(param4 / (_loc14_ + this._gap));
         if(!this._hasVariableItemDimensions)
         {
            _loc26_ = 0;
            _loc17_ = param5 * (_loc14_ + this._gap) - this._gap;
            if(_loc15_ && param5 > 1)
            {
               _loc17_ = _loc17_ - this._gap + this._firstGap;
            }
            if(_loc7_ && param5 > 2)
            {
               _loc17_ = _loc17_ - this._gap + this._lastGap;
            }
            if(_loc17_ < param4)
            {
               if(this._verticalAlign == "bottom")
               {
                  _loc26_ = Math.ceil((param4 - _loc17_) / (_loc14_ + this._gap));
               }
               else if(this._verticalAlign == "middle")
               {
                  _loc26_ = Math.ceil((param4 - _loc17_) / (_loc14_ + this._gap) / 2);
               }
            }
            _loc9_ = (param2 - this._paddingTop) / (_loc14_ + this._gap);
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc9_ -= _loc26_;
            _loc27_ = _loc9_ + _loc8_;
            if(_loc27_ >= param5)
            {
               _loc27_ = param5 - 1;
            }
            _loc9_ = _loc27_ - _loc8_;
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc22_ = _loc9_;
            while(_loc22_ <= _loc27_)
            {
               param6[_loc18_] = _loc22_;
               _loc18_++;
               _loc22_++;
            }
            return param6;
         }
         var _loc24_:int = param5 - 2;
         var _loc12_:Number = param2 + param4;
         var _loc10_:Number = this._paddingTop;
         _loc22_ = 0;
         while(_loc22_ < param5)
         {
            _loc30_ = this._gap;
            if(_loc15_ && _loc22_ == 0)
            {
               _loc30_ = this._firstGap;
            }
            else if(_loc7_ && _loc22_ > 0 && _loc22_ == _loc24_)
            {
               _loc30_ = this._lastGap;
            }
            _loc28_ = Number(this._heightCache[_loc22_]);
            if(_loc28_ !== _loc28_)
            {
               _loc21_ = _loc14_;
            }
            else
            {
               _loc21_ = _loc28_;
            }
            _loc16_ = _loc10_;
            _loc10_ += _loc21_ + _loc30_;
            if(_loc10_ > param2 && _loc16_ < _loc12_)
            {
               param6[_loc18_] = _loc22_;
               _loc18_++;
            }
            if(_loc10_ >= _loc12_)
            {
               break;
            }
            _loc22_++;
         }
         var _loc13_:int = int(param6.length);
         var _loc23_:int = _loc8_ - _loc13_;
         if(_loc23_ > 0 && _loc13_ > 0)
         {
            _loc20_ = param6[0];
            _loc25_ = _loc20_ - _loc23_;
            if(_loc25_ < 0)
            {
               _loc25_ = 0;
            }
            _loc22_ = _loc20_ - 1;
            while(_loc22_ >= _loc25_)
            {
               param6.unshift(_loc22_);
               _loc22_--;
            }
         }
         _loc13_ = int(param6.length);
         _loc23_ = _loc8_ - _loc13_;
         _loc18_ = _loc13_;
         if(_loc23_ > 0)
         {
            _loc19_ = int(_loc13_ > 0 ? param6[_loc13_ - 1] + 1 : 0);
            _loc11_ = _loc19_ + _loc23_;
            if(_loc11_ > param5)
            {
               _loc11_ = param5;
            }
            _loc22_ = _loc19_;
            while(_loc22_ < _loc11_)
            {
               param6[_loc18_] = _loc22_;
               _loc18_++;
               _loc22_++;
            }
         }
         return param6;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc22_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc13_:int = 0;
         var _loc16_:DisplayObject = null;
         var _loc9_:int = 0;
         var _loc19_:Number = NaN;
         var _loc12_:* = NaN;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param5 - this._paddingLeft - this._paddingRight);
            _loc22_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc17_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc20_:* = this._firstGap === this._firstGap;
         var _loc8_:* = this._lastGap === this._lastGap;
         var _loc10_:Number = param4 + this._paddingTop;
         var _loc24_:* = 0;
         var _loc23_:Number = this._gap;
         var _loc11_:int = 0;
         var _loc15_:Number = 0;
         var _loc21_:int;
         var _loc18_:* = _loc21_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc18_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc11_ = param1 + 1;
               _loc24_ = _loc17_;
               _loc23_ = this._gap;
            }
            else
            {
               _loc11_ = this._beforeVirtualizedItemCount;
               _loc15_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1;
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               _loc10_ += _loc15_ * (_loc17_ + this._gap);
            }
            _loc10_ += _loc11_ * (_loc17_ + this._gap);
         }
         param1 -= _loc11_ + _loc15_;
         var _loc14_:int = _loc18_ - 2;
         _loc13_ = 0;
         while(_loc13_ <= param1)
         {
            _loc16_ = param2[_loc13_];
            _loc9_ = _loc13_ + _loc11_;
            if(_loc20_ && _loc9_ == 0)
            {
               _loc23_ = this._firstGap;
            }
            else if(_loc8_ && _loc9_ > 0 && _loc9_ == _loc14_)
            {
               _loc23_ = this._lastGap;
            }
            else
            {
               _loc23_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc19_ = Number(this._heightCache[_loc9_]);
            }
            if(this._useVirtualLayout && !_loc16_)
            {
               if(!this._hasVariableItemDimensions || _loc19_ !== _loc19_)
               {
                  _loc24_ = _loc17_;
               }
               else
               {
                  _loc24_ = _loc19_;
               }
            }
            else
            {
               _loc12_ = _loc16_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc12_ != _loc19_)
                     {
                        this._heightCache[_loc9_] = _loc12_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc17_ >= 0)
                  {
                     _loc16_.height = _loc12_ = _loc17_;
                  }
               }
               _loc24_ = _loc12_;
            }
            _loc10_ += _loc24_ + _loc23_;
            _loc13_++;
         }
         _loc10_ -= _loc24_ + _loc23_;
         if(this._scrollPositionVerticalAlign == "middle")
         {
            _loc10_ -= Math.round((param6 - _loc24_) / 2);
         }
         else if(this._scrollPositionVerticalAlign == "bottom")
         {
            _loc10_ -= param6 - _loc24_;
         }
         param7.x = 0;
         param7.y = _loc10_;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc4_:Boolean = this._horizontalAlign == "justify" && param2 === param2;
         var _loc6_:int = int(param1.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = param1[_loc7_];
            if(!(!_loc5_ || _loc5_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc5_).includeInLayout))
            {
               if(_loc4_)
               {
                  _loc5_.width = param2;
               }
               if(this._distributeHeights)
               {
                  _loc5_.height = param3;
               }
               if(_loc5_ is IValidating)
               {
                  IValidating(_loc5_).validate();
               }
            }
            _loc7_++;
         }
      }
      
      protected function prepareTypicalItem(param1:Number) : void
      {
         if(!this._typicalItem)
         {
            return;
         }
         if(this._horizontalAlign == "justify" && param1 === param1)
         {
            this._typicalItem.width = param1;
         }
         else if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
      
      protected function calculateDistributedHeight(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc11_:* = NaN;
         var _loc10_:int = 0;
         var _loc6_:DisplayObject = null;
         var _loc9_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:int = int(param1.length);
         if(param2 !== param2)
         {
            _loc11_ = 0;
            _loc10_ = 0;
            while(_loc10_ < _loc8_)
            {
               _loc6_ = param1[_loc10_];
               _loc9_ = _loc6_.height;
               if(_loc9_ > _loc11_)
               {
                  _loc11_ = _loc9_;
               }
               _loc10_++;
            }
            param2 = _loc11_ * _loc8_ + this._paddingTop + this._paddingBottom + this._gap * (_loc8_ - 1);
            _loc7_ = false;
            if(param2 > param4)
            {
               param2 = param4;
               _loc7_ = true;
            }
            else if(param2 < param3)
            {
               param2 = param3;
               _loc7_ = true;
            }
            if(!_loc7_)
            {
               return _loc11_;
            }
         }
         var _loc5_:Number = param2 - this._paddingTop - this._paddingBottom - this._gap * (_loc8_ - 1);
         if(_loc8_ > 1 && this._firstGap === this._firstGap)
         {
            _loc5_ += this._gap - this._firstGap;
         }
         if(_loc8_ > 2 && this._lastGap === this._lastGap)
         {
            _loc5_ += this._gap - this._lastGap;
         }
         return _loc5_ / _loc8_;
      }
      
      protected function applyPercentHeights(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc14_:int = 0;
         var _loc18_:DisplayObject = null;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc13_:VerticalLayoutData = null;
         var _loc15_:Number = NaN;
         var _loc8_:IFeathersControl = null;
         var _loc19_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc11_:* = NaN;
         var _loc12_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:* = param2;
         this._discoveredItemsCache.length = 0;
         var _loc7_:Number = 0;
         var _loc21_:Number = 0;
         var _loc16_:Number = 0;
         var _loc20_:int = int(param1.length);
         var _loc17_:int = 0;
         _loc14_ = 0;
         for(; _loc14_ < _loc20_; _loc14_++)
         {
            _loc18_ = param1[_loc14_];
            if(_loc18_ is ILayoutDisplayObject)
            {
               _loc6_ = ILayoutDisplayObject(_loc18_);
               if(!_loc6_.includeInLayout)
               {
                  continue;
               }
               _loc13_ = _loc6_.layoutData as VerticalLayoutData;
               if(_loc13_)
               {
                  _loc15_ = _loc13_.percentHeight;
                  if(_loc15_ === _loc15_)
                  {
                     if(_loc6_ is IFeathersControl)
                     {
                        _loc8_ = IFeathersControl(_loc6_);
                        _loc21_ += _loc8_.minHeight;
                     }
                     _loc16_ += _loc15_;
                     this._discoveredItemsCache[_loc17_] = _loc18_;
                     _loc17_++;
                     continue;
                  }
               }
            }
            _loc7_ += _loc18_.height;
         }
         _loc7_ += this._gap * (_loc20_ - 1);
         if(this._firstGap === this._firstGap && _loc20_ > 1)
         {
            _loc7_ += this._firstGap - this._gap;
         }
         else if(this._lastGap === this._lastGap && _loc20_ > 2)
         {
            _loc7_ += this._lastGap - this._gap;
         }
         _loc7_ += this._paddingTop + this._paddingBottom;
         if(_loc16_ < 100)
         {
            _loc16_ = 100;
         }
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = _loc7_ + _loc21_;
            if(_loc5_ < param3)
            {
               _loc5_ = param3;
            }
            else if(_loc5_ > param4)
            {
               _loc5_ = param4;
            }
         }
         _loc5_ -= _loc7_;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         do
         {
            _loc19_ = false;
            _loc10_ = _loc5_ / _loc16_;
            _loc14_ = 0;
            while(_loc14_ < _loc17_)
            {
               _loc6_ = ILayoutDisplayObject(this._discoveredItemsCache[_loc14_]);
               if(_loc6_)
               {
                  _loc13_ = VerticalLayoutData(_loc6_.layoutData);
                  _loc15_ = _loc13_.percentHeight;
                  _loc11_ = _loc10_ * _loc15_;
                  if(_loc6_ is IFeathersControl)
                  {
                     _loc8_ = IFeathersControl(_loc6_);
                     _loc12_ = _loc8_.minHeight;
                     if(_loc11_ < _loc12_)
                     {
                        _loc11_ = _loc12_;
                        _loc5_ -= _loc11_;
                        _loc16_ -= _loc15_;
                        this._discoveredItemsCache[_loc14_] = null;
                        _loc19_ = true;
                     }
                     else
                     {
                        _loc9_ = _loc8_.maxHeight;
                        if(_loc11_ > _loc9_)
                        {
                           _loc11_ = _loc9_;
                           _loc5_ -= _loc11_;
                           _loc16_ -= _loc15_;
                           this._discoveredItemsCache[_loc14_] = null;
                           _loc19_ = true;
                        }
                     }
                  }
                  _loc6_.height = _loc11_;
               }
               _loc14_++;
            }
         }
         while(_loc19_);
         
         this._discoveredItemsCache.length = 0;
      }
   }
}

