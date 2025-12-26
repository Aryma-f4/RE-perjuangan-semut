package feathers.layout
{
   import feathers.core.IFeathersControl;
   import feathers.core.IValidating;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   import starling.events.EventDispatcher;
   
   public class HorizontalLayout extends EventDispatcher implements IVariableVirtualLayout, ITrimmedVirtualLayout
   {
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      protected var _widthCache:Array = [];
      
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
      
      protected var _distributeWidths:Boolean = false;
      
      protected var _manageVisibility:Boolean = false;
      
      protected var _beforeVirtualizedItemCount:int = 0;
      
      protected var _afterVirtualizedItemCount:int = 0;
      
      protected var _typicalItem:DisplayObject;
      
      protected var _resetTypicalItemDimensionsOnMeasure:Boolean = false;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _scrollPositionHorizontalAlign:String = "center";
      
      public function HorizontalLayout()
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
      
      public function get distributeWidths() : Boolean
      {
         return this._distributeWidths;
      }
      
      public function set distributeWidths(param1:Boolean) : void
      {
         if(this._distributeWidths == param1)
         {
            return;
         }
         this._distributeWidths = param1;
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
      
      public function get scrollPositionHorizontalAlign() : String
      {
         return this._scrollPositionHorizontalAlign;
      }
      
      public function set scrollPositionHorizontalAlign(param1:String) : void
      {
         this._scrollPositionHorizontalAlign = param1;
      }
      
      public function get requiresLayoutOnScroll() : Boolean
      {
         return this._manageVisibility || this._useVirtualLayout;
      }
      
      public function layout(param1:Vector.<DisplayObject>, param2:ViewPortBounds = null, param3:LayoutBoundsResult = null) : LayoutBoundsResult
      {
         var _loc42_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc32_:int = 0;
         var _loc37_:DisplayObject = null;
         var _loc28_:int = 0;
         var _loc44_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc7_:* = NaN;
         var _loc31_:* = NaN;
         var _loc17_:Number = NaN;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc13_:HorizontalLayoutData = null;
         var _loc35_:Number = NaN;
         var _loc30_:IFeathersControl = null;
         var _loc12_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = param2 ? param2.scrollX : 0;
         var _loc8_:Number = param2 ? param2.scrollY : 0;
         var _loc39_:Number = param2 ? param2.x : 0;
         var _loc45_:Number = param2 ? param2.y : 0;
         var _loc5_:Number = param2 ? param2.minWidth : 0;
         var _loc34_:Number = param2 ? param2.minHeight : 0;
         var _loc22_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc38_:Number = param2 ? param2.maxHeight : Infinity;
         var _loc10_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc26_:Number = param2 ? param2.explicitHeight : NaN;
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(_loc26_ - this._paddingTop - this._paddingBottom);
            _loc42_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc20_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         if(!this._useVirtualLayout || this._hasVariableItemDimensions || this._distributeWidths || this._verticalAlign != "justify" || _loc26_ !== _loc26_)
         {
            this.validateItems(param1,_loc26_ - this._paddingTop - this._paddingBottom,_loc10_);
         }
         if(!this._useVirtualLayout)
         {
            this.applyPercentWidths(param1,_loc10_,_loc5_,_loc22_);
         }
         if(this._distributeWidths)
         {
            _loc29_ = this.calculateDistributedWidth(param1,_loc10_,_loc5_,_loc22_);
         }
         var _loc43_:* = _loc29_ === _loc29_;
         this._discoveredItemsCache.length = 0;
         var _loc24_:* = this._firstGap === this._firstGap;
         var _loc4_:* = this._lastGap === this._lastGap;
         var _loc25_:* = this._useVirtualLayout ? _loc20_ : 0;
         var _loc19_:Number = _loc39_ + this._paddingLeft;
         var _loc41_:int;
         var _loc23_:* = _loc41_ = int(param1.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc23_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            _loc19_ += this._beforeVirtualizedItemCount * (_loc42_ + this._gap);
            if(_loc24_ && this._beforeVirtualizedItemCount > 0)
            {
               _loc19_ = _loc19_ - this._gap + this._firstGap;
            }
         }
         var _loc33_:int = _loc23_ - 2;
         var _loc40_:int = 0;
         _loc32_ = 0;
         while(_loc32_ < _loc41_)
         {
            _loc37_ = param1[_loc32_];
            _loc28_ = _loc32_ + this._beforeVirtualizedItemCount;
            _loc44_ = this._gap;
            if(_loc24_ && _loc28_ == 0)
            {
               _loc44_ = this._firstGap;
            }
            else if(_loc4_ && _loc28_ > 0 && _loc28_ == _loc33_)
            {
               _loc44_ = this._lastGap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc27_ = Number(this._widthCache[_loc28_]);
            }
            if(this._useVirtualLayout && !_loc37_)
            {
               if(!this._hasVariableItemDimensions || _loc27_ !== _loc27_)
               {
                  _loc19_ += _loc42_ + _loc44_;
               }
               else
               {
                  _loc19_ += _loc27_ + _loc44_;
               }
            }
            else if(!(_loc37_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc37_).includeInLayout))
            {
               _loc37_.x = _loc37_.pivotX + _loc19_;
               if(_loc43_)
               {
                  _loc37_.width = _loc7_ = _loc29_;
               }
               else
               {
                  _loc7_ = _loc37_.width;
               }
               _loc31_ = _loc37_.height;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc7_ != _loc27_)
                     {
                        this._widthCache[_loc28_] = _loc7_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc42_ >= 0)
                  {
                     _loc37_.width = _loc7_ = _loc42_;
                  }
               }
               _loc19_ += _loc7_ + _loc44_;
               if(_loc31_ > _loc25_)
               {
                  _loc25_ = _loc31_;
               }
               if(this._useVirtualLayout)
               {
                  this._discoveredItemsCache[_loc40_] = _loc37_;
                  _loc40_++;
               }
            }
            _loc32_++;
         }
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc19_ += this._afterVirtualizedItemCount * (_loc42_ + this._gap);
            if(_loc4_ && this._afterVirtualizedItemCount > 0)
            {
               _loc19_ = _loc19_ - this._gap + this._lastGap;
            }
         }
         var _loc18_:Vector.<DisplayObject> = this._useVirtualLayout ? this._discoveredItemsCache : param1;
         var _loc15_:int = int(_loc18_.length);
         var _loc14_:Number = _loc25_ + this._paddingTop + this._paddingBottom;
         var _loc21_:* = _loc26_;
         if(_loc21_ !== _loc21_)
         {
            _loc21_ = _loc14_;
            if(_loc21_ < _loc34_)
            {
               _loc21_ = _loc34_;
            }
            else if(_loc21_ > _loc38_)
            {
               _loc21_ = _loc38_;
            }
         }
         var _loc16_:Number = _loc19_ - this._gap + this._paddingRight - _loc39_;
         var _loc36_:* = _loc10_;
         if(_loc36_ !== _loc36_)
         {
            _loc36_ = _loc16_;
            if(_loc36_ < _loc5_)
            {
               _loc36_ = _loc5_;
            }
            else if(_loc36_ > _loc22_)
            {
               _loc36_ = _loc22_;
            }
         }
         if(_loc16_ < _loc36_)
         {
            _loc17_ = 0;
            if(this._horizontalAlign == "right")
            {
               _loc17_ = _loc36_ - _loc16_;
            }
            else if(this._horizontalAlign == "center")
            {
               _loc17_ = Math.round((_loc36_ - _loc16_) / 2);
            }
            if(_loc17_ != 0)
            {
               _loc32_ = 0;
               while(_loc32_ < _loc15_)
               {
                  _loc37_ = _loc18_[_loc32_];
                  if(!(_loc37_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc37_).includeInLayout))
                  {
                     _loc37_.x += _loc17_;
                  }
                  _loc32_++;
               }
            }
         }
         _loc32_ = 0;
         while(_loc32_ < _loc15_)
         {
            _loc37_ = _loc18_[_loc32_];
            _loc6_ = _loc37_ as ILayoutDisplayObject;
            if(!(_loc6_ && !_loc6_.includeInLayout))
            {
               if(this._verticalAlign == "justify")
               {
                  _loc37_.y = _loc37_.pivotY + _loc45_ + this._paddingTop;
                  _loc37_.height = _loc21_ - this._paddingTop - this._paddingBottom;
               }
               else
               {
                  if(_loc6_)
                  {
                     _loc13_ = _loc6_.layoutData as HorizontalLayoutData;
                     if(_loc13_)
                     {
                        _loc35_ = _loc13_.percentHeight;
                        if(_loc35_ === _loc35_)
                        {
                           if(_loc35_ < 0)
                           {
                              _loc35_ = 0;
                           }
                           if(_loc35_ > 100)
                           {
                              _loc35_ = 100;
                           }
                           _loc31_ = _loc35_ * (_loc21_ - this._paddingTop - this._paddingBottom) / 100;
                           if(_loc37_ is IFeathersControl)
                           {
                              _loc30_ = IFeathersControl(_loc37_);
                              _loc12_ = _loc30_.minHeight;
                              if(_loc31_ < _loc12_)
                              {
                                 _loc31_ = _loc12_;
                              }
                              else
                              {
                                 _loc9_ = _loc30_.maxHeight;
                                 if(_loc31_ > _loc9_)
                                 {
                                    _loc31_ = _loc9_;
                                 }
                              }
                           }
                           _loc37_.height = _loc31_;
                        }
                     }
                  }
                  switch(this._verticalAlign)
                  {
                     case "bottom":
                        _loc37_.y = _loc37_.pivotY + _loc45_ + _loc21_ - this._paddingBottom - _loc37_.height;
                        break;
                     case "middle":
                        _loc37_.y = _loc37_.pivotY + _loc45_ + this._paddingTop + Math.round((_loc21_ - this._paddingTop - this._paddingBottom - _loc37_.height) / 2);
                        break;
                     default:
                        _loc37_.y = _loc37_.pivotY + _loc45_ + this._paddingTop;
                  }
               }
               if(this.manageVisibility)
               {
                  _loc37_.visible = _loc37_.x - _loc37_.pivotX + _loc37_.width >= _loc39_ + _loc11_ && _loc37_.x - _loc37_.pivotX < _loc11_ + _loc36_;
               }
            }
            _loc32_++;
         }
         this._discoveredItemsCache.length = 0;
         if(!param3)
         {
            param3 = new LayoutBoundsResult();
         }
         param3.contentWidth = _loc16_;
         param3.contentHeight = this._verticalAlign == "justify" ? _loc21_ : _loc14_;
         param3.viewPortWidth = _loc36_;
         param3.viewPortHeight = _loc21_;
         return param3;
      }
      
      public function measureViewPort(param1:int, param2:ViewPortBounds = null, param3:Point = null) : Point
      {
         var _loc13_:Number = NaN;
         var _loc21_:* = NaN;
         var _loc10_:int = 0;
         var _loc6_:Number = NaN;
         var _loc8_:* = NaN;
         var _loc20_:* = NaN;
         if(!param3)
         {
            param3 = new Point();
         }
         if(!this._useVirtualLayout)
         {
            throw new IllegalOperationError("measureViewPort() may be called only if useVirtualLayout is true.");
         }
         var _loc9_:Number = param2 ? param2.explicitWidth : NaN;
         var _loc4_:Number = param2 ? param2.explicitHeight : NaN;
         var _loc11_:* = _loc9_ !== _loc9_;
         var _loc18_:* = _loc4_ !== _loc4_;
         if(!_loc11_ && !_loc18_)
         {
            param3.x = _loc9_;
            param3.y = _loc4_;
            return param3;
         }
         var _loc7_:Number = param2 ? param2.minWidth : 0;
         var _loc12_:Number = param2 ? param2.minHeight : 0;
         var _loc15_:Number = param2 ? param2.maxWidth : Infinity;
         var _loc16_:Number = param2 ? param2.maxHeight : Infinity;
         this.prepareTypicalItem(_loc4_ - this._paddingTop - this._paddingBottom);
         var _loc19_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc14_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc17_:* = this._firstGap === this._firstGap;
         var _loc5_:* = this._lastGap === this._lastGap;
         if(this._distributeWidths)
         {
            _loc13_ = (_loc19_ + this._gap) * param1;
         }
         else
         {
            _loc13_ = 0;
            _loc21_ = _loc14_;
            if(!this._hasVariableItemDimensions)
            {
               _loc13_ += (_loc19_ + this._gap) * param1;
            }
            else
            {
               _loc10_ = 0;
               while(_loc10_ < param1)
               {
                  _loc6_ = Number(this._widthCache[_loc10_]);
                  if(_loc6_ !== _loc6_)
                  {
                     _loc13_ += _loc19_ + this._gap;
                  }
                  else
                  {
                     _loc13_ += _loc6_ + this._gap;
                  }
                  _loc10_++;
               }
            }
         }
         _loc13_ -= this._gap;
         if(_loc17_ && param1 > 1)
         {
            _loc13_ = _loc13_ - this._gap + this._firstGap;
         }
         if(_loc5_ && param1 > 2)
         {
            _loc13_ = _loc13_ - this._gap + this._lastGap;
         }
         if(_loc11_)
         {
            _loc8_ = _loc13_ + this._paddingLeft + this._paddingRight;
            if(_loc8_ < _loc7_)
            {
               _loc8_ = _loc7_;
            }
            else if(_loc8_ > _loc15_)
            {
               _loc8_ = _loc15_;
            }
            param3.x = _loc8_;
         }
         else
         {
            param3.x = _loc9_;
         }
         if(_loc18_)
         {
            _loc20_ = _loc21_ + this._paddingTop + this._paddingBottom;
            if(_loc20_ < _loc12_)
            {
               _loc20_ = _loc12_;
            }
            else if(_loc20_ > _loc16_)
            {
               _loc20_ = _loc16_;
            }
            param3.y = _loc20_;
         }
         else
         {
            param3.y = _loc4_;
         }
         return param3;
      }
      
      public function resetVariableVirtualCache() : void
      {
         this._widthCache.length = 0;
      }
      
      public function resetVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         delete this._widthCache[param1];
         if(param2)
         {
            this._widthCache[param1] = param2.width;
            this.dispatchEventWith("change");
         }
      }
      
      public function addToVariableVirtualCacheAtIndex(param1:int, param2:DisplayObject = null) : void
      {
         var _loc3_:* = param2 ? param2.width : undefined;
         this._widthCache.splice(param1,0,_loc3_);
      }
      
      public function removeFromVariableVirtualCacheAtIndex(param1:int) : void
      {
         this._widthCache.splice(param1,1);
      }
      
      public function getVisibleIndicesAtScrollPosition(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Vector.<int> = null) : Vector.<int>
      {
         var _loc22_:Number = NaN;
         var _loc27_:int = 0;
         var _loc9_:int = 0;
         var _loc28_:int = 0;
         var _loc23_:* = 0;
         var _loc30_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc10_:* = NaN;
         var _loc17_:* = NaN;
         var _loc21_:int = 0;
         var _loc26_:int = 0;
         var _loc20_:int = 0;
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
         this.prepareTypicalItem(param4 - this._paddingTop - this._paddingBottom);
         var _loc29_:Number = this._typicalItem ? this._typicalItem.width : 0;
         var _loc14_:Number = this._typicalItem ? this._typicalItem.height : 0;
         var _loc16_:* = this._firstGap === this._firstGap;
         var _loc7_:* = this._lastGap === this._lastGap;
         var _loc18_:* = 0;
         var _loc8_:int = Math.ceil(param3 / (_loc29_ + this._gap));
         if(!this._hasVariableItemDimensions)
         {
            _loc22_ = param5 * (_loc29_ + this._gap) - this._gap;
            if(_loc16_ && param5 > 1)
            {
               _loc22_ = _loc22_ - this._gap + this._firstGap;
            }
            if(_loc7_ && param5 > 2)
            {
               _loc22_ = _loc22_ - this._gap + this._lastGap;
            }
            _loc27_ = 0;
            if(_loc22_ < param3)
            {
               if(this._horizontalAlign == "right")
               {
                  _loc27_ = Math.ceil((param3 - _loc22_) / (_loc29_ + this._gap));
               }
               else if(this._horizontalAlign == "center")
               {
                  _loc27_ = Math.ceil((param3 - _loc22_) / (_loc29_ + this._gap) / 2);
               }
            }
            _loc9_ = (param1 - this._paddingLeft) / (_loc29_ + this._gap);
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc9_ -= _loc27_;
            _loc28_ = _loc9_ + _loc8_;
            if(_loc28_ >= param5)
            {
               _loc28_ = param5 - 1;
            }
            _loc9_ = _loc28_ - _loc8_;
            if(_loc9_ < 0)
            {
               _loc9_ = 0;
            }
            _loc23_ = _loc9_;
            while(_loc23_ <= _loc28_)
            {
               param6[_loc18_] = _loc23_;
               _loc18_++;
               _loc23_++;
            }
            return param6;
         }
         var _loc25_:int = param5 - 2;
         var _loc15_:Number = param1 + param3;
         var _loc13_:Number = this._paddingLeft;
         _loc23_ = 0;
         while(_loc23_ < param5)
         {
            _loc30_ = this._gap;
            if(_loc16_ && _loc23_ == 0)
            {
               _loc30_ = this._firstGap;
            }
            else if(_loc7_ && _loc23_ > 0 && _loc23_ == _loc25_)
            {
               _loc30_ = this._lastGap;
            }
            _loc19_ = Number(this._widthCache[_loc23_]);
            if(_loc19_ !== _loc19_)
            {
               _loc10_ = _loc29_;
            }
            else
            {
               _loc10_ = _loc19_;
            }
            _loc17_ = _loc13_;
            _loc13_ += _loc10_ + _loc30_;
            if(_loc13_ > param1 && _loc17_ < _loc15_)
            {
               param6[_loc18_] = _loc23_;
               _loc18_++;
            }
            if(_loc13_ >= _loc15_)
            {
               break;
            }
            _loc23_++;
         }
         var _loc12_:int = int(param6.length);
         var _loc24_:int = _loc8_ - _loc12_;
         if(_loc24_ > 0 && _loc12_ > 0)
         {
            _loc21_ = param6[0];
            _loc26_ = _loc21_ - _loc24_;
            if(_loc26_ < 0)
            {
               _loc26_ = 0;
            }
            _loc23_ = _loc21_ - 1;
            while(_loc23_ >= _loc26_)
            {
               param6.unshift(_loc23_);
               _loc23_--;
            }
         }
         _loc18_ = _loc12_ = int(param6.length);
         _loc24_ = _loc8_ - _loc12_;
         if(_loc24_ > 0)
         {
            _loc20_ = int(_loc12_ > 0 ? param6[_loc12_ - 1] + 1 : 0);
            _loc11_ = _loc20_ + _loc24_;
            if(_loc11_ > param5)
            {
               _loc11_ = param5;
            }
            _loc23_ = _loc20_;
            while(_loc23_ < _loc11_)
            {
               param6[_loc18_] = _loc23_;
               _loc18_++;
               _loc23_++;
            }
         }
         return param6;
      }
      
      public function getScrollPositionForIndex(param1:int, param2:Vector.<DisplayObject>, param3:Number, param4:Number, param5:Number, param6:Number, param7:Point = null) : Point
      {
         var _loc23_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc13_:int = 0;
         var _loc17_:DisplayObject = null;
         var _loc10_:int = 0;
         var _loc9_:Number = NaN;
         var _loc12_:* = NaN;
         if(!param7)
         {
            param7 = new Point();
         }
         if(this._useVirtualLayout)
         {
            this.prepareTypicalItem(param6 - this._paddingTop - this._paddingBottom);
            _loc23_ = this._typicalItem ? this._typicalItem.width : 0;
            _loc18_ = this._typicalItem ? this._typicalItem.height : 0;
         }
         var _loc20_:* = this._firstGap === this._firstGap;
         var _loc8_:* = this._lastGap === this._lastGap;
         var _loc16_:Number = param3 + this._paddingLeft;
         var _loc21_:* = 0;
         var _loc24_:Number = this._gap;
         var _loc11_:int = 0;
         var _loc15_:Number = 0;
         var _loc22_:int;
         var _loc19_:* = _loc22_ = int(param2.length);
         if(this._useVirtualLayout && !this._hasVariableItemDimensions)
         {
            _loc19_ += this._beforeVirtualizedItemCount + this._afterVirtualizedItemCount;
            if(param1 < this._beforeVirtualizedItemCount)
            {
               _loc11_ = param1 + 1;
               _loc21_ = _loc23_;
               _loc24_ = this._gap;
            }
            else
            {
               _loc11_ = this._beforeVirtualizedItemCount;
               _loc15_ = param1 - param2.length - this._beforeVirtualizedItemCount + 1;
               if(_loc15_ < 0)
               {
                  _loc15_ = 0;
               }
               _loc16_ += _loc15_ * (_loc23_ + this._gap);
            }
            _loc16_ += _loc11_ * (_loc23_ + this._gap);
         }
         param1 -= _loc11_ + _loc15_;
         var _loc14_:int = _loc19_ - 2;
         _loc13_ = 0;
         while(_loc13_ <= param1)
         {
            _loc17_ = param2[_loc13_];
            _loc10_ = _loc13_ + _loc11_;
            if(_loc20_ && _loc10_ == 0)
            {
               _loc24_ = this._firstGap;
            }
            else if(_loc8_ && _loc10_ > 0 && _loc10_ == _loc14_)
            {
               _loc24_ = this._lastGap;
            }
            else
            {
               _loc24_ = this._gap;
            }
            if(this._useVirtualLayout && this._hasVariableItemDimensions)
            {
               _loc9_ = Number(this._widthCache[_loc10_]);
            }
            if(this._useVirtualLayout && !_loc17_)
            {
               if(!this._hasVariableItemDimensions || _loc9_ !== _loc9_)
               {
                  _loc21_ = _loc23_;
               }
               else
               {
                  _loc21_ = _loc9_;
               }
            }
            else
            {
               _loc12_ = _loc17_.width;
               if(this._useVirtualLayout)
               {
                  if(this._hasVariableItemDimensions)
                  {
                     if(_loc12_ != _loc9_)
                     {
                        this._widthCache[_loc10_] = _loc12_;
                        this.dispatchEventWith("change");
                     }
                  }
                  else if(_loc23_ >= 0)
                  {
                     _loc17_.width = _loc12_ = _loc23_;
                  }
               }
               _loc21_ = _loc12_;
            }
            _loc16_ += _loc21_ + _loc24_;
            _loc13_++;
         }
         _loc16_ -= _loc21_ + _loc24_;
         if(this._scrollPositionHorizontalAlign == "center")
         {
            _loc16_ -= Math.round((param5 - _loc21_) / 2);
         }
         else if(this._scrollPositionHorizontalAlign == "right")
         {
            _loc16_ -= param5 - _loc21_;
         }
         param7.x = _loc16_;
         param7.y = 0;
         return param7;
      }
      
      protected function validateItems(param1:Vector.<DisplayObject>, param2:Number, param3:Number) : void
      {
         var _loc7_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Boolean = this._verticalAlign == "justify" && param2 === param2;
         var _loc6_:int = int(param1.length);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_ = param1[_loc7_];
            if(!(!_loc4_ || _loc4_ is ILayoutDisplayObject && !ILayoutDisplayObject(_loc4_).includeInLayout))
            {
               if(this._distributeWidths)
               {
                  _loc4_.width = param3;
               }
               if(_loc5_)
               {
                  _loc4_.height = param2;
               }
               if(_loc4_ is IValidating)
               {
                  IValidating(_loc4_).validate();
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
         if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.width = this._typicalItemWidth;
         }
         if(this._verticalAlign == "justify" && param1 === param1)
         {
            this._typicalItem.height = param1;
         }
         else if(this._resetTypicalItemDimensionsOnMeasure)
         {
            this._typicalItem.height = this._typicalItemHeight;
         }
         if(this._typicalItem is IValidating)
         {
            IValidating(this._typicalItem).validate();
         }
      }
      
      protected function calculateDistributedWidth(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : Number
      {
         var _loc6_:* = NaN;
         var _loc11_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:Number = NaN;
         var _loc9_:Boolean = false;
         var _loc10_:int = int(param1.length);
         if(param2 !== param2)
         {
            _loc6_ = 0;
            _loc11_ = 0;
            while(_loc11_ < _loc10_)
            {
               _loc7_ = param1[_loc11_];
               _loc8_ = _loc7_.width;
               if(_loc8_ > _loc6_)
               {
                  _loc6_ = _loc8_;
               }
               _loc11_++;
            }
            param2 = _loc6_ * _loc10_ + this._paddingLeft + this._paddingRight + this._gap * (_loc10_ - 1);
            _loc9_ = false;
            if(param2 > param4)
            {
               param2 = param4;
               _loc9_ = true;
            }
            else if(param2 < param3)
            {
               param2 = param3;
               _loc9_ = true;
            }
            if(!_loc9_)
            {
               return _loc6_;
            }
         }
         var _loc5_:Number = param2 - this._paddingLeft - this._paddingRight - this._gap * (_loc10_ - 1);
         if(_loc10_ > 1 && this._firstGap === this._firstGap)
         {
            _loc5_ += this._gap - this._firstGap;
         }
         if(_loc10_ > 2 && this._lastGap === this._lastGap)
         {
            _loc5_ += this._gap - this._lastGap;
         }
         return _loc5_ / _loc10_;
      }
      
      protected function applyPercentWidths(param1:Vector.<DisplayObject>, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc15_:int = 0;
         var _loc17_:DisplayObject = null;
         var _loc6_:ILayoutDisplayObject = null;
         var _loc14_:HorizontalLayoutData = null;
         var _loc20_:Number = NaN;
         var _loc10_:IFeathersControl = null;
         var _loc19_:Boolean = false;
         var _loc11_:Number = NaN;
         var _loc9_:* = NaN;
         var _loc18_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc5_:* = param2;
         this._discoveredItemsCache.length = 0;
         var _loc12_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc21_:int = int(param1.length);
         var _loc16_:int = 0;
         _loc15_ = 0;
         for(; _loc15_ < _loc21_; _loc15_++)
         {
            _loc17_ = param1[_loc15_];
            if(_loc17_ is ILayoutDisplayObject)
            {
               _loc6_ = ILayoutDisplayObject(_loc17_);
               if(!_loc6_.includeInLayout)
               {
                  continue;
               }
               _loc14_ = _loc6_.layoutData as HorizontalLayoutData;
               if(_loc14_)
               {
                  _loc20_ = _loc14_.percentWidth;
                  if(_loc20_ === _loc20_)
                  {
                     if(_loc6_ is IFeathersControl)
                     {
                        _loc10_ = IFeathersControl(_loc6_);
                        _loc7_ += _loc10_.minWidth;
                     }
                     _loc8_ += _loc20_;
                     this._discoveredItemsCache[_loc16_] = _loc17_;
                     _loc16_++;
                     continue;
                  }
               }
            }
            _loc12_ += _loc17_.width;
         }
         _loc12_ += this._gap * (_loc21_ - 1);
         if(this._firstGap === this._firstGap && _loc21_ > 1)
         {
            _loc12_ += this._firstGap - this._gap;
         }
         else if(this._lastGap === this._lastGap && _loc21_ > 2)
         {
            _loc12_ += this._lastGap - this._gap;
         }
         _loc12_ += this._paddingLeft + this._paddingRight;
         if(_loc8_ < 100)
         {
            _loc8_ = 100;
         }
         if(_loc5_ !== _loc5_)
         {
            _loc5_ = _loc12_ + _loc7_;
            if(_loc5_ < param3)
            {
               _loc5_ = param3;
            }
            else if(_loc5_ > param4)
            {
               _loc5_ = param4;
            }
         }
         _loc5_ -= _loc12_;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         do
         {
            _loc19_ = false;
            _loc11_ = _loc5_ / _loc8_;
            _loc15_ = 0;
            while(_loc15_ < _loc16_)
            {
               _loc6_ = ILayoutDisplayObject(this._discoveredItemsCache[_loc15_]);
               if(_loc6_)
               {
                  _loc14_ = HorizontalLayoutData(_loc6_.layoutData);
                  _loc20_ = _loc14_.percentWidth;
                  _loc9_ = _loc11_ * _loc20_;
                  if(_loc6_ is IFeathersControl)
                  {
                     _loc10_ = IFeathersControl(_loc6_);
                     _loc18_ = _loc10_.minWidth;
                     if(_loc9_ < _loc18_)
                     {
                        _loc9_ = _loc18_;
                        _loc5_ -= _loc9_;
                        _loc8_ -= _loc20_;
                        this._discoveredItemsCache[_loc15_] = null;
                        _loc19_ = true;
                     }
                     else
                     {
                        _loc13_ = _loc10_.maxWidth;
                        if(_loc9_ > _loc13_)
                        {
                           _loc9_ = _loc13_;
                           _loc5_ -= _loc9_;
                           _loc8_ -= _loc20_;
                           this._discoveredItemsCache[_loc15_] = null;
                           _loc19_ = true;
                        }
                     }
                  }
                  _loc6_.width = _loc9_;
               }
               _loc15_++;
            }
         }
         while(_loc19_);
         
         this._discoveredItemsCache.length = 0;
      }
   }
}

