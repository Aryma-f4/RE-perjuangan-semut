package feathers.controls.supportClasses
{
   import feathers.controls.GroupedList;
   import feathers.controls.Scroller;
   import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
   import feathers.controls.renderers.IGroupedListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.PropertyProxy;
   import feathers.data.HierarchicalCollection;
   import feathers.layout.ILayout;
   import feathers.layout.IVariableVirtualLayout;
   import feathers.layout.IVirtualLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.ViewPortBounds;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class GroupedListDataViewPort extends FeathersControl implements IViewPort
   {
      
      private static const INVALIDATION_FLAG_ITEM_RENDERER_FACTORY:String = "itemRendererFactory";
      
      private static const HELPER_POINT:Point = new Point();
      
      private static const HELPER_VECTOR:Vector.<int> = new Vector.<int>(0);
      
      private var touchPointID:int = -1;
      
      private var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      private var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      private var _minVisibleWidth:Number = 0;
      
      private var _maxVisibleWidth:Number = Infinity;
      
      private var actualVisibleWidth:Number = NaN;
      
      private var explicitVisibleWidth:Number = NaN;
      
      private var _minVisibleHeight:Number = 0;
      
      private var _maxVisibleHeight:Number = Infinity;
      
      private var actualVisibleHeight:Number;
      
      private var explicitVisibleHeight:Number = NaN;
      
      protected var _contentX:Number = 0;
      
      protected var _contentY:Number = 0;
      
      private var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      private var _typicalItemIsInDataProvider:Boolean = false;
      
      private var _typicalItemRenderer:IGroupedListItemRenderer;
      
      private var _unrenderedItems:Vector.<int> = new Vector.<int>(0);
      
      private var _inactiveItemRenderers:Vector.<IGroupedListItemRenderer> = new Vector.<IGroupedListItemRenderer>(0);
      
      private var _activeItemRenderers:Vector.<IGroupedListItemRenderer> = new Vector.<IGroupedListItemRenderer>(0);
      
      private var _itemRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedFirstItems:Vector.<int>;
      
      private var _inactiveFirstItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _activeFirstItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _firstItemRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedLastItems:Vector.<int>;
      
      private var _inactiveLastItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _activeLastItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _lastItemRendererMap:Dictionary;
      
      private var _unrenderedSingleItems:Vector.<int>;
      
      private var _inactiveSingleItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _activeSingleItemRenderers:Vector.<IGroupedListItemRenderer>;
      
      private var _singleItemRendererMap:Dictionary;
      
      private var _unrenderedHeaders:Vector.<int> = new Vector.<int>(0);
      
      private var _inactiveHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new Vector.<IGroupedListHeaderOrFooterRenderer>(0);
      
      private var _activeHeaderRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new Vector.<IGroupedListHeaderOrFooterRenderer>(0);
      
      private var _headerRendererMap:Dictionary = new Dictionary(true);
      
      private var _unrenderedFooters:Vector.<int> = new Vector.<int>(0);
      
      private var _inactiveFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new Vector.<IGroupedListHeaderOrFooterRenderer>(0);
      
      private var _activeFooterRenderers:Vector.<IGroupedListHeaderOrFooterRenderer> = new Vector.<IGroupedListHeaderOrFooterRenderer>(0);
      
      private var _footerRendererMap:Dictionary = new Dictionary(true);
      
      private var _headerIndices:Vector.<int> = new Vector.<int>(0);
      
      private var _footerIndices:Vector.<int> = new Vector.<int>(0);
      
      private var _isScrolling:Boolean = false;
      
      private var _owner:GroupedList;
      
      private var _updateForDataReset:Boolean = false;
      
      private var _dataProvider:HierarchicalCollection;
      
      private var _isSelectable:Boolean = true;
      
      private var _selectedGroupIndex:int = -1;
      
      private var _selectedItemIndex:int = -1;
      
      private var _itemRendererType:Class;
      
      private var _itemRendererFactory:Function;
      
      private var _itemRendererName:String;
      
      private var _typicalItem:Object = null;
      
      private var _itemRendererProperties:PropertyProxy;
      
      private var _firstItemRendererType:Class;
      
      private var _firstItemRendererFactory:Function;
      
      private var _firstItemRendererName:String;
      
      private var _lastItemRendererType:Class;
      
      private var _lastItemRendererFactory:Function;
      
      private var _lastItemRendererName:String;
      
      private var _singleItemRendererType:Class;
      
      private var _singleItemRendererFactory:Function;
      
      private var _singleItemRendererName:String;
      
      private var _headerRendererType:Class;
      
      private var _headerRendererFactory:Function;
      
      private var _headerRendererName:String;
      
      private var _headerRendererProperties:PropertyProxy;
      
      private var _footerRendererType:Class;
      
      private var _footerRendererFactory:Function;
      
      private var _footerRendererName:String;
      
      private var _footerRendererProperties:PropertyProxy;
      
      private var _ignoreLayoutChanges:Boolean = false;
      
      private var _ignoreRendererResizing:Boolean = false;
      
      private var _layout:ILayout;
      
      private var _horizontalScrollPosition:Number = 0;
      
      private var _verticalScrollPosition:Number = 0;
      
      private var _minimumItemCount:int;
      
      private var _minimumHeaderCount:int;
      
      private var _minimumFooterCount:int;
      
      private var _minimumFirstAndLastItemCount:int;
      
      private var _minimumSingleItemCount:int;
      
      private var _ignoreSelectionChanges:Boolean = false;
      
      public function GroupedListDataViewPort()
      {
         super();
         this.addEventListener("touch",touchHandler);
         this.addEventListener("removedFromStage",removedFromStageHandler);
      }
      
      public function get minVisibleWidth() : Number
      {
         return this._minVisibleWidth;
      }
      
      public function set minVisibleWidth(param1:Number) : void
      {
         if(this._minVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleWidth cannot be NaN");
         }
         this._minVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get maxVisibleWidth() : Number
      {
         return this._maxVisibleWidth;
      }
      
      public function set maxVisibleWidth(param1:Number) : void
      {
         if(this._maxVisibleWidth == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleWidth cannot be NaN");
         }
         this._maxVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get visibleWidth() : Number
      {
         return this.actualVisibleWidth;
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         if(this.explicitVisibleWidth == param1 || param1 !== param1 && this.explicitVisibleWidth !== this.explicitVisibleWidth)
         {
            return;
         }
         this.explicitVisibleWidth = param1;
         this.invalidate("size");
      }
      
      public function get minVisibleHeight() : Number
      {
         return this._minVisibleHeight;
      }
      
      public function set minVisibleHeight(param1:Number) : void
      {
         if(this._minVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("minVisibleHeight cannot be NaN");
         }
         this._minVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get maxVisibleHeight() : Number
      {
         return this._maxVisibleHeight;
      }
      
      public function set maxVisibleHeight(param1:Number) : void
      {
         if(this._maxVisibleHeight == param1)
         {
            return;
         }
         if(param1 !== param1)
         {
            throw new ArgumentError("maxVisibleHeight cannot be NaN");
         }
         this._maxVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get visibleHeight() : Number
      {
         return this.actualVisibleHeight;
      }
      
      public function set visibleHeight(param1:Number) : void
      {
         if(this.explicitVisibleHeight == param1 || param1 !== param1 && this.explicitVisibleHeight !== this.explicitVisibleHeight)
         {
            return;
         }
         this.explicitVisibleHeight = param1;
         this.invalidate("size");
      }
      
      public function get contentX() : Number
      {
         return this._contentX;
      }
      
      public function get contentY() : Number
      {
         return this._contentY;
      }
      
      public function get horizontalScrollStep() : Number
      {
         var _loc1_:Vector.<IGroupedListItemRenderer> = this._activeItemRenderers;
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeFirstItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeLastItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeSingleItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            return 0;
         }
         var _loc2_:IGroupedListItemRenderer = _loc1_[0];
         var _loc3_:Number = Number(_loc2_.width);
         var _loc4_:Number = Number(_loc2_.height);
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get verticalScrollStep() : Number
      {
         var _loc1_:Vector.<IGroupedListItemRenderer> = this._activeItemRenderers;
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeFirstItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeLastItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            _loc1_ = this._activeSingleItemRenderers;
         }
         if(!_loc1_ || _loc1_.length == 0)
         {
            return 0;
         }
         var _loc2_:IGroupedListItemRenderer = _loc1_[0];
         var _loc3_:Number = Number(_loc2_.width);
         var _loc4_:Number = Number(_loc2_.height);
         if(_loc3_ < _loc4_)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      public function get owner() : GroupedList
      {
         return this._owner;
      }
      
      public function set owner(param1:GroupedList) : void
      {
         if(this._owner == param1)
         {
            return;
         }
         if(this._owner)
         {
            this._owner.removeEventListener("scrollStart",owner_scrollStartHandler);
         }
         this._owner = param1;
         if(this._owner)
         {
            this._owner.addEventListener("scrollStart",owner_scrollStartHandler);
         }
      }
      
      public function get dataProvider() : HierarchicalCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:HierarchicalCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
            this._dataProvider.removeEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.removeEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.removeEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.removeEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.removeEventListener("updateItem",dataProvider_updateItemHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
            this._dataProvider.addEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.addEventListener("addItem",dataProvider_addItemHandler);
            this._dataProvider.addEventListener("removeItem",dataProvider_removeItemHandler);
            this._dataProvider.addEventListener("replaceItem",dataProvider_replaceItemHandler);
            this._dataProvider.addEventListener("updateItem",dataProvider_updateItemHandler);
         }
         if(this._layout is IVariableVirtualLayout)
         {
            IVariableVirtualLayout(this._layout).resetVariableVirtualCache();
         }
         this._updateForDataReset = true;
         this.invalidate("data");
      }
      
      public function get isSelectable() : Boolean
      {
         return this._isSelectable;
      }
      
      public function set isSelectable(param1:Boolean) : void
      {
         if(this._isSelectable == param1)
         {
            return;
         }
         this._isSelectable = param1;
         if(!this._isSelectable)
         {
            this.setSelectedLocation(-1,-1);
         }
         this.invalidate("selected");
      }
      
      public function get selectedGroupIndex() : int
      {
         return this._selectedGroupIndex;
      }
      
      public function get selectedItemIndex() : int
      {
         return this._selectedItemIndex;
      }
      
      public function get itemRendererType() : Class
      {
         return this._itemRendererType;
      }
      
      public function set itemRendererType(param1:Class) : void
      {
         if(this._itemRendererType == param1)
         {
            return;
         }
         this._itemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get itemRendererFactory() : Function
      {
         return this._itemRendererFactory;
      }
      
      public function set itemRendererFactory(param1:Function) : void
      {
         if(this._itemRendererFactory === param1)
         {
            return;
         }
         this._itemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get itemRendererName() : String
      {
         return this._itemRendererName;
      }
      
      public function set itemRendererName(param1:String) : void
      {
         if(this._itemRendererName == param1)
         {
            return;
         }
         this._itemRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(param1:Object) : void
      {
         if(this._typicalItem == param1)
         {
            return;
         }
         this._typicalItem = param1;
         this.invalidate("data");
      }
      
      public function get itemRendererProperties() : PropertyProxy
      {
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:PropertyProxy) : void
      {
         if(this._itemRendererProperties == param1)
         {
            return;
         }
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._itemRendererProperties = PropertyProxy(param1);
         if(this._itemRendererProperties)
         {
            this._itemRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get firstItemRendererType() : Class
      {
         return this._firstItemRendererType;
      }
      
      public function set firstItemRendererType(param1:Class) : void
      {
         if(this._firstItemRendererType == param1)
         {
            return;
         }
         this._firstItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get firstItemRendererFactory() : Function
      {
         return this._firstItemRendererFactory;
      }
      
      public function set firstItemRendererFactory(param1:Function) : void
      {
         if(this._firstItemRendererFactory === param1)
         {
            return;
         }
         this._firstItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get firstItemRendererName() : String
      {
         return this._firstItemRendererName;
      }
      
      public function set firstItemRendererName(param1:String) : void
      {
         if(this._firstItemRendererName == param1)
         {
            return;
         }
         this._firstItemRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get lastItemRendererType() : Class
      {
         return this._lastItemRendererType;
      }
      
      public function set lastItemRendererType(param1:Class) : void
      {
         if(this._lastItemRendererType == param1)
         {
            return;
         }
         this._lastItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get lastItemRendererFactory() : Function
      {
         return this._lastItemRendererFactory;
      }
      
      public function set lastItemRendererFactory(param1:Function) : void
      {
         if(this._lastItemRendererFactory === param1)
         {
            return;
         }
         this._lastItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get lastItemRendererName() : String
      {
         return this._lastItemRendererName;
      }
      
      public function set lastItemRendererName(param1:String) : void
      {
         if(this._lastItemRendererName == param1)
         {
            return;
         }
         this._lastItemRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get singleItemRendererType() : Class
      {
         return this._singleItemRendererType;
      }
      
      public function set singleItemRendererType(param1:Class) : void
      {
         if(this._singleItemRendererType == param1)
         {
            return;
         }
         this._singleItemRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get singleItemRendererFactory() : Function
      {
         return this._singleItemRendererFactory;
      }
      
      public function set singleItemRendererFactory(param1:Function) : void
      {
         if(this._singleItemRendererFactory === param1)
         {
            return;
         }
         this._singleItemRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get singleItemRendererName() : String
      {
         return this._singleItemRendererName;
      }
      
      public function set singleItemRendererName(param1:String) : void
      {
         if(this._singleItemRendererName == param1)
         {
            return;
         }
         this._singleItemRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererType() : Class
      {
         return this._headerRendererType;
      }
      
      public function set headerRendererType(param1:Class) : void
      {
         if(this._headerRendererType == param1)
         {
            return;
         }
         this._headerRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererFactory() : Function
      {
         return this._headerRendererFactory;
      }
      
      public function set headerRendererFactory(param1:Function) : void
      {
         if(this._headerRendererFactory === param1)
         {
            return;
         }
         this._headerRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererName() : String
      {
         return this._headerRendererName;
      }
      
      public function set headerRendererName(param1:String) : void
      {
         if(this._headerRendererName == param1)
         {
            return;
         }
         this._headerRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get headerRendererProperties() : PropertyProxy
      {
         return this._headerRendererProperties;
      }
      
      public function set headerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._headerRendererProperties == param1)
         {
            return;
         }
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._headerRendererProperties = PropertyProxy(param1);
         if(this._headerRendererProperties)
         {
            this._headerRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get footerRendererType() : Class
      {
         return this._footerRendererType;
      }
      
      public function set footerRendererType(param1:Class) : void
      {
         if(this._footerRendererType == param1)
         {
            return;
         }
         this._footerRendererType = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererFactory() : Function
      {
         return this._footerRendererFactory;
      }
      
      public function set footerRendererFactory(param1:Function) : void
      {
         if(this._footerRendererFactory === param1)
         {
            return;
         }
         this._footerRendererFactory = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererName() : String
      {
         return this._footerRendererName;
      }
      
      public function set footerRendererName(param1:String) : void
      {
         if(this._footerRendererName == param1)
         {
            return;
         }
         this._footerRendererName = param1;
         this.invalidate("itemRendererFactory");
      }
      
      public function get footerRendererProperties() : PropertyProxy
      {
         return this._footerRendererProperties;
      }
      
      public function set footerRendererProperties(param1:PropertyProxy) : void
      {
         if(this._footerRendererProperties == param1)
         {
            return;
         }
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._footerRendererProperties = PropertyProxy(param1);
         if(this._footerRendererProperties)
         {
            this._footerRendererProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         var _loc2_:IVariableVirtualLayout = null;
         if(this._layout == param1)
         {
            return;
         }
         if(this._layout)
         {
            this._layout.removeEventListener("change",layout_changeHandler);
         }
         this._layout = param1;
         if(this._layout)
         {
            if(this._layout is IVariableVirtualLayout)
            {
               _loc2_ = IVariableVirtualLayout(this._layout);
               _loc2_.hasVariableItemDimensions = true;
               _loc2_.resetVariableVirtualCache();
            }
            this._layout.addEventListener("change",layout_changeHandler);
         }
         this.invalidate("layout");
      }
      
      public function get horizontalScrollPosition() : Number
      {
         return this._horizontalScrollPosition;
      }
      
      public function set horizontalScrollPosition(param1:Number) : void
      {
         if(this._horizontalScrollPosition == param1)
         {
            return;
         }
         this._horizontalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function get verticalScrollPosition() : Number
      {
         return this._verticalScrollPosition;
      }
      
      public function set verticalScrollPosition(param1:Number) : void
      {
         if(this._verticalScrollPosition == param1)
         {
            return;
         }
         this._verticalScrollPosition = param1;
         this.invalidate("scroll");
      }
      
      public function setSelectedLocation(param1:int, param2:int) : void
      {
         if(this._selectedGroupIndex == param1 && this._selectedItemIndex == param2)
         {
            return;
         }
         if(param1 < 0 && param2 >= 0 || param1 >= 0 && param2 < 0)
         {
            throw new ArgumentError("To deselect items, group index and item index must both be < 0.");
         }
         this._selectedGroupIndex = param1;
         this._selectedItemIndex = param2;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function getScrollPositionForIndex(param1:int, param2:int, param3:Point = null) : Point
      {
         if(!param3)
         {
            param3 = new Point();
         }
         var _loc4_:int = this.locationToDisplayIndex(param1,param2);
         return this._layout.getScrollPositionForIndex(_loc4_,this._layoutItems,0,0,this.actualVisibleWidth,this.actualVisibleHeight,param3);
      }
      
      override public function dispose() : void
      {
         this.owner = null;
         this.dataProvider = null;
         this.layout = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc11_:Boolean = false;
         var _loc6_:Boolean = this.isInvalid("data");
         var _loc3_:Boolean = this.isInvalid("scroll");
         var _loc4_:Boolean = this.isInvalid("size");
         var _loc2_:Boolean = this.isInvalid("selected");
         var _loc5_:Boolean = this.isInvalid("itemRendererFactory");
         var _loc9_:Boolean = this.isInvalid("styles");
         var _loc8_:Boolean = this.isInvalid("state");
         var _loc12_:Boolean = this.isInvalid("layout");
         if(!_loc12_ && _loc3_ && this._layout && this._layout.requiresLayoutOnScroll)
         {
            _loc12_ = true;
         }
         var _loc10_:Boolean = _loc4_ || _loc6_ || _loc12_ || _loc5_;
         var _loc7_:Boolean = this._ignoreRendererResizing;
         this._ignoreRendererResizing = true;
         var _loc1_:Boolean = this._ignoreLayoutChanges;
         this._ignoreLayoutChanges = true;
         if(_loc3_ || _loc4_)
         {
            this.refreshViewPortBounds();
         }
         if(_loc10_)
         {
            this.refreshInactiveRenderers(_loc5_);
         }
         if(_loc6_ || _loc12_ || _loc5_)
         {
            this.refreshLayoutTypicalItem();
         }
         if(_loc10_)
         {
            this.refreshRenderers();
         }
         if(_loc9_ || _loc10_)
         {
            this.refreshHeaderRendererStyles();
            this.refreshFooterRendererStyles();
            this.refreshItemRendererStyles();
         }
         if(_loc2_ || _loc10_)
         {
            _loc11_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.refreshSelection();
            this._ignoreSelectionChanges = _loc11_;
         }
         if(_loc8_ || _loc10_)
         {
            this.refreshEnabled();
         }
         this._ignoreLayoutChanges = _loc1_;
         this._layout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         this._ignoreRendererResizing = _loc7_;
         this._contentX = this._layoutResult.contentX;
         this._contentY = this._layoutResult.contentY;
         this.setSizeInternal(this._layoutResult.contentWidth,this._layoutResult.contentHeight,false);
         this.actualVisibleWidth = this._layoutResult.viewPortWidth;
         this.actualVisibleHeight = this._layoutResult.viewPortHeight;
         this.validateRenderers();
      }
      
      private function validateRenderers() : void
      {
         var _loc4_:int = 0;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc2_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc1_:int = int(this._activeFirstItemRenderers ? this._activeFirstItemRenderers.length : 0);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._activeFirstItemRenderers[_loc4_];
            _loc3_.validate();
            _loc4_++;
         }
         _loc1_ = int(this._activeLastItemRenderers ? this._activeLastItemRenderers.length : 0);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._activeLastItemRenderers[_loc4_];
            _loc3_.validate();
            _loc4_++;
         }
         _loc1_ = int(this._activeSingleItemRenderers ? this._activeSingleItemRenderers.length : 0);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._activeSingleItemRenderers[_loc4_];
            _loc3_.validate();
            _loc4_++;
         }
         _loc1_ = int(this._activeItemRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc3_ = this._activeItemRenderers[_loc4_];
            _loc3_.validate();
            _loc4_++;
         }
         _loc1_ = int(this._activeHeaderRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = this._activeHeaderRenderers[_loc4_];
            _loc2_.validate();
            _loc4_++;
         }
         _loc1_ = int(this._activeFooterRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc1_)
         {
            _loc2_ = this._activeFooterRenderers[_loc4_];
            _loc2_.validate();
            _loc4_++;
         }
      }
      
      private function refreshEnabled() : void
      {
         var _loc3_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc1_:int = int(this._activeItemRenderers.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = DisplayObject(this._activeItemRenderers[_loc3_]);
            if(_loc2_ is IFeathersControl)
            {
               IFeathersControl(_loc2_).isEnabled = this._isEnabled;
            }
            _loc3_++;
         }
         if(this._activeFirstItemRenderers)
         {
            _loc1_ = int(this._activeFirstItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = DisplayObject(this._activeFirstItemRenderers[_loc3_]);
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).isEnabled = this._isEnabled;
               }
               _loc3_++;
            }
         }
         if(this._activeLastItemRenderers)
         {
            _loc1_ = int(this._activeLastItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = DisplayObject(this._activeLastItemRenderers[_loc3_]);
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).isEnabled = this._isEnabled;
               }
               _loc3_++;
            }
         }
         if(this._activeSingleItemRenderers)
         {
            _loc1_ = int(this._activeSingleItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = DisplayObject(this._activeSingleItemRenderers[_loc3_]);
               if(_loc2_ is IFeathersControl)
               {
                  IFeathersControl(_loc2_).isEnabled = this._isEnabled;
               }
               _loc3_++;
            }
         }
         _loc1_ = int(this._activeHeaderRenderers.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = DisplayObject(this._activeHeaderRenderers[_loc3_]);
            if(_loc2_ is IFeathersControl)
            {
               IFeathersControl(_loc2_).isEnabled = this._isEnabled;
            }
            _loc3_++;
         }
         _loc1_ = int(this._activeFooterRenderers.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = DisplayObject(this._activeFooterRenderers[_loc3_]);
            if(_loc2_ is IFeathersControl)
            {
               IFeathersControl(_loc2_).isEnabled = this._isEnabled;
            }
            _loc3_++;
         }
      }
      
      private function invalidateParent(param1:String = "all") : void
      {
         Scroller(this.parent).invalidate(param1);
      }
      
      private function refreshLayoutTypicalItem() : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc9_:IGroupedListItemRenderer = null;
         var _loc12_:* = undefined;
         var _loc11_:* = undefined;
         var _loc6_:Class = null;
         var _loc14_:Function = null;
         var _loc10_:String = null;
         var _loc17_:IVirtualLayout = this._layout as IVirtualLayout;
         if(!_loc17_ || !_loc17_.useVirtualLayout)
         {
            if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
            {
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
            }
            return;
         }
         var _loc3_:Boolean = this._firstItemRendererType || this._firstItemRendererFactory != null || this._firstItemRendererName;
         var _loc7_:Boolean = this._singleItemRendererType || this._singleItemRendererFactory != null || this._singleItemRendererName;
         var _loc16_:Boolean = false;
         var _loc15_:Object = this._typicalItem;
         var _loc8_:int = 0;
         var _loc13_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._dataProvider)
         {
            if(!_loc15_)
            {
               _loc8_ = this._dataProvider.getLength();
               if(_loc8_ > 0)
               {
                  _loc13_ = this._dataProvider.getLength(0);
                  if(_loc13_ > 0)
                  {
                     _loc16_ = true;
                     _loc15_ = this._dataProvider.getItemAt(0,0);
                  }
               }
            }
            else if(_loc15_)
            {
               this._dataProvider.getItemLocation(_loc15_,HELPER_VECTOR);
               if(HELPER_VECTOR.length > 1)
               {
                  _loc16_ = true;
                  _loc1_ = HELPER_VECTOR[0];
                  _loc2_ = HELPER_VECTOR[1];
               }
            }
         }
         if(_loc15_)
         {
            _loc4_ = false;
            _loc5_ = false;
            if(_loc7_ && _loc13_ == 1)
            {
               if(this._singleItemRendererMap)
               {
                  _loc9_ = IGroupedListItemRenderer(this._singleItemRendererMap[_loc15_]);
               }
               _loc5_ = true;
            }
            else if(_loc3_ && _loc13_ > 1)
            {
               if(this._firstItemRendererMap)
               {
                  _loc9_ = IGroupedListItemRenderer(this._firstItemRendererMap[_loc15_]);
               }
               _loc4_ = true;
            }
            else
            {
               _loc9_ = IGroupedListItemRenderer(this._itemRendererMap[_loc15_]);
            }
            if(!_loc9_ && !_loc16_ && this._typicalItemRenderer)
            {
               _loc9_ = this._typicalItemRenderer;
               _loc9_.data = _loc15_;
               _loc9_.groupIndex = _loc1_;
               _loc9_.itemIndex = _loc2_;
            }
            if(!_loc9_)
            {
               if(_loc4_)
               {
                  _loc12_ = this._activeFirstItemRenderers;
                  _loc11_ = this._inactiveFirstItemRenderers;
                  _loc6_ = this._firstItemRendererType ? this._firstItemRendererType : this._itemRendererType;
                  _loc14_ = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
                  _loc10_ = this._firstItemRendererName ? this._firstItemRendererName : this._itemRendererName;
                  _loc9_ = this.createItemRenderer(_loc11_,_loc12_,this._firstItemRendererMap,_loc6_,_loc14_,_loc10_,_loc15_,0,0,0,false,!_loc16_);
               }
               else if(_loc5_)
               {
                  _loc12_ = this._activeSingleItemRenderers;
                  _loc11_ = this._inactiveSingleItemRenderers;
                  _loc6_ = this._singleItemRendererType ? this._singleItemRendererType : this._itemRendererType;
                  _loc14_ = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
                  _loc10_ = this._singleItemRendererName ? this._singleItemRendererName : this._itemRendererName;
                  _loc9_ = this.createItemRenderer(_loc11_,_loc12_,this._singleItemRendererMap,_loc6_,_loc14_,_loc10_,_loc15_,0,0,0,false,!_loc16_);
               }
               else
               {
                  _loc12_ = this._activeItemRenderers;
                  _loc11_ = this._inactiveItemRenderers;
                  _loc9_ = this.createItemRenderer(_loc11_,_loc12_,this._itemRendererMap,this._itemRendererType,this._itemRendererFactory,this._itemRendererName,_loc15_,0,0,0,false,!_loc16_);
               }
               if(!this._typicalItemIsInDataProvider && this._typicalItemRenderer)
               {
                  this.destroyItemRenderer(this._typicalItemRenderer);
                  this._typicalItemRenderer = null;
               }
            }
         }
         _loc17_.typicalItem = DisplayObject(_loc9_);
         this._typicalItemRenderer = _loc9_;
         this._typicalItemIsInDataProvider = _loc16_;
      }
      
      private function refreshItemRendererStyles() : void
      {
         for each(var _loc1_ in this._activeItemRenderers)
         {
            this.refreshOneItemRendererStyles(_loc1_);
         }
         for each(_loc1_ in this._activeFirstItemRenderers)
         {
            this.refreshOneItemRendererStyles(_loc1_);
         }
         for each(_loc1_ in this._activeLastItemRenderers)
         {
            this.refreshOneItemRendererStyles(_loc1_);
         }
         for each(_loc1_ in this._activeSingleItemRenderers)
         {
            this.refreshOneItemRendererStyles(_loc1_);
         }
      }
      
      private function refreshHeaderRendererStyles() : void
      {
         for each(var _loc1_ in this._activeHeaderRenderers)
         {
            this.refreshOneHeaderRendererStyles(_loc1_);
         }
      }
      
      private function refreshFooterRendererStyles() : void
      {
         for each(var _loc1_ in this._activeFooterRenderers)
         {
            this.refreshOneFooterRendererStyles(_loc1_);
         }
      }
      
      private function refreshOneItemRendererStyles(param1:IGroupedListItemRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc3_:DisplayObject = DisplayObject(param1);
         for(var _loc2_ in this._itemRendererProperties)
         {
            _loc4_ = this._itemRendererProperties[_loc2_];
            _loc3_[_loc2_] = _loc4_;
         }
      }
      
      private function refreshOneHeaderRendererStyles(param1:IGroupedListHeaderOrFooterRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc3_:DisplayObject = DisplayObject(param1);
         for(var _loc2_ in this._headerRendererProperties)
         {
            _loc4_ = this._headerRendererProperties[_loc2_];
            _loc3_[_loc2_] = _loc4_;
         }
      }
      
      private function refreshOneFooterRendererStyles(param1:IGroupedListHeaderOrFooterRenderer) : void
      {
         var _loc4_:Object = null;
         var _loc3_:DisplayObject = DisplayObject(param1);
         for(var _loc2_ in this._footerRendererProperties)
         {
            _loc4_ = this._footerRendererProperties[_loc2_];
            _loc3_[_loc2_] = _loc4_;
         }
      }
      
      private function refreshSelection() : void
      {
         var _loc3_:int = 0;
         var _loc2_:IGroupedListItemRenderer = null;
         var _loc1_:int = int(this._activeItemRenderers.length);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._activeItemRenderers[_loc3_];
            _loc2_.isSelected = _loc2_.groupIndex == this._selectedGroupIndex && _loc2_.itemIndex == this._selectedItemIndex;
            _loc3_++;
         }
         if(this._activeFirstItemRenderers)
         {
            _loc1_ = int(this._activeFirstItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this._activeFirstItemRenderers[_loc3_];
               _loc2_.isSelected = _loc2_.groupIndex == this._selectedGroupIndex && _loc2_.itemIndex == this._selectedItemIndex;
               _loc3_++;
            }
         }
         if(this._activeLastItemRenderers)
         {
            _loc1_ = int(this._activeLastItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this._activeLastItemRenderers[_loc3_];
               _loc2_.isSelected = _loc2_.groupIndex == this._selectedGroupIndex && _loc2_.itemIndex == this._selectedItemIndex;
               _loc3_++;
            }
         }
         if(this._activeSingleItemRenderers)
         {
            _loc1_ = int(this._activeSingleItemRenderers.length);
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               _loc2_ = this._activeSingleItemRenderers[_loc3_];
               _loc2_.isSelected = _loc2_.groupIndex == this._selectedGroupIndex && _loc2_.itemIndex == this._selectedItemIndex;
               _loc3_++;
            }
         }
      }
      
      private function refreshViewPortBounds() : void
      {
         this._viewPortBounds.x = this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = this._horizontalScrollPosition;
         this._viewPortBounds.scrollY = this._verticalScrollPosition;
         this._viewPortBounds.explicitWidth = this.explicitVisibleWidth;
         this._viewPortBounds.explicitHeight = this.explicitVisibleHeight;
         this._viewPortBounds.minWidth = this._minVisibleWidth;
         this._viewPortBounds.minHeight = this._minVisibleHeight;
         this._viewPortBounds.maxWidth = this._maxVisibleWidth;
         this._viewPortBounds.maxHeight = this._maxVisibleHeight;
      }
      
      private function refreshInactiveRenderers(param1:Boolean) : void
      {
         var _loc4_:Vector.<IGroupedListItemRenderer> = this._inactiveItemRenderers;
         this._inactiveItemRenderers = this._activeItemRenderers;
         this._activeItemRenderers = _loc4_;
         if(this._activeItemRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active item renderers should be empty.");
         }
         if(this._inactiveFirstItemRenderers)
         {
            _loc4_ = this._inactiveFirstItemRenderers;
            this._inactiveFirstItemRenderers = this._activeFirstItemRenderers;
            this._activeFirstItemRenderers = _loc4_;
            if(this._activeFirstItemRenderers.length > 0)
            {
               throw new IllegalOperationError("GroupedListDataViewPort: active first renderers should be empty.");
            }
         }
         if(this._inactiveLastItemRenderers)
         {
            _loc4_ = this._inactiveLastItemRenderers;
            this._inactiveLastItemRenderers = this._activeLastItemRenderers;
            this._activeLastItemRenderers = _loc4_;
            if(this._activeLastItemRenderers.length > 0)
            {
               throw new IllegalOperationError("GroupedListDataViewPort: active last renderers should be empty.");
            }
         }
         if(this._inactiveSingleItemRenderers)
         {
            _loc4_ = this._inactiveSingleItemRenderers;
            this._inactiveSingleItemRenderers = this._activeSingleItemRenderers;
            this._activeSingleItemRenderers = _loc4_;
            if(this._activeSingleItemRenderers.length > 0)
            {
               throw new IllegalOperationError("GroupedListDataViewPort: active single renderers should be empty.");
            }
         }
         var _loc2_:Vector.<IGroupedListHeaderOrFooterRenderer> = this._inactiveHeaderRenderers;
         this._inactiveHeaderRenderers = this._activeHeaderRenderers;
         this._activeHeaderRenderers = _loc2_;
         if(this._activeHeaderRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active header renderers should be empty.");
         }
         _loc2_ = this._inactiveFooterRenderers;
         this._inactiveFooterRenderers = this._activeFooterRenderers;
         this._activeFooterRenderers = _loc2_;
         if(this._activeFooterRenderers.length > 0)
         {
            throw new IllegalOperationError("GroupedListDataViewPort: active footer renderers should be empty.");
         }
         if(param1)
         {
            this.recoverInactiveRenderers();
            this.freeInactiveRenderers();
            if(this._typicalItemRenderer)
            {
               if(this._typicalItemIsInDataProvider)
               {
                  delete this._itemRendererMap[this._typicalItemRenderer.data];
                  if(this._firstItemRendererMap)
                  {
                     delete this._firstItemRendererMap[this._typicalItemRenderer.data];
                  }
                  if(this._singleItemRendererMap)
                  {
                     delete this._singleItemRendererMap[this._typicalItemRenderer.data];
                  }
               }
               this.destroyItemRenderer(this._typicalItemRenderer);
               this._typicalItemRenderer = null;
               this._typicalItemIsInDataProvider = false;
            }
         }
         this._headerIndices.length = 0;
         this._footerIndices.length = 0;
         var _loc5_:Boolean = this._firstItemRendererType || this._firstItemRendererFactory != null || this._firstItemRendererName;
         if(_loc5_)
         {
            if(!this._firstItemRendererMap)
            {
               this._firstItemRendererMap = new Dictionary(true);
            }
            if(!this._inactiveFirstItemRenderers)
            {
               this._inactiveFirstItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._activeFirstItemRenderers)
            {
               this._activeFirstItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._unrenderedFirstItems)
            {
               this._unrenderedFirstItems = new Vector.<int>(0);
            }
         }
         else
         {
            this._firstItemRendererMap = null;
            this._inactiveFirstItemRenderers = null;
            this._activeFirstItemRenderers = null;
            this._unrenderedFirstItems = null;
         }
         var _loc3_:Boolean = this._lastItemRendererType || this._lastItemRendererFactory != null || this._lastItemRendererName;
         if(_loc3_)
         {
            if(!this._lastItemRendererMap)
            {
               this._lastItemRendererMap = new Dictionary(true);
            }
            if(!this._inactiveLastItemRenderers)
            {
               this._inactiveLastItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._activeLastItemRenderers)
            {
               this._activeLastItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._unrenderedLastItems)
            {
               this._unrenderedLastItems = new Vector.<int>(0);
            }
         }
         else
         {
            this._lastItemRendererMap = null;
            this._inactiveLastItemRenderers = null;
            this._activeLastItemRenderers = null;
            this._unrenderedLastItems = null;
         }
         var _loc6_:Boolean = this._singleItemRendererType || this._singleItemRendererFactory != null || this._singleItemRendererName;
         if(_loc6_)
         {
            if(!this._singleItemRendererMap)
            {
               this._singleItemRendererMap = new Dictionary(true);
            }
            if(!this._inactiveSingleItemRenderers)
            {
               this._inactiveSingleItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._activeSingleItemRenderers)
            {
               this._activeSingleItemRenderers = new Vector.<IGroupedListItemRenderer>(0);
            }
            if(!this._unrenderedSingleItems)
            {
               this._unrenderedSingleItems = new Vector.<int>(0);
            }
         }
         else
         {
            this._singleItemRendererMap = null;
            this._inactiveSingleItemRenderers = null;
            this._activeSingleItemRenderers = null;
            this._unrenderedSingleItems = null;
         }
      }
      
      private function refreshRenderers() : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         if(this._typicalItemRenderer)
         {
            if(this._typicalItemIsInDataProvider)
            {
               _loc3_ = this._typicalItemRenderer.data;
               if(IGroupedListItemRenderer(this._itemRendererMap[_loc3_]) == this._typicalItemRenderer)
               {
                  _loc2_ = int(this._inactiveItemRenderers.indexOf(this._typicalItemRenderer));
                  if(_loc2_ >= 0)
                  {
                     this._inactiveItemRenderers.splice(_loc2_,1);
                  }
                  _loc1_ = int(this._activeItemRenderers.length);
                  if(_loc1_ == 0)
                  {
                     this._activeItemRenderers[_loc1_] = this._typicalItemRenderer;
                  }
               }
               else if(this._firstItemRendererMap && IGroupedListItemRenderer(this._firstItemRendererMap[_loc3_]) == this._typicalItemRenderer)
               {
                  _loc2_ = int(this._inactiveFirstItemRenderers.indexOf(this._typicalItemRenderer));
                  if(_loc2_ >= 0)
                  {
                     this._inactiveFirstItemRenderers.splice(_loc2_,1);
                  }
                  _loc1_ = int(this._activeFirstItemRenderers.length);
                  if(_loc1_ == 0)
                  {
                     this._activeFirstItemRenderers[_loc1_] = this._typicalItemRenderer;
                  }
               }
               else if(this._singleItemRendererMap && IGroupedListItemRenderer(this._singleItemRendererMap[_loc3_]) == this._typicalItemRenderer)
               {
                  _loc2_ = int(this._inactiveSingleItemRenderers.indexOf(this._typicalItemRenderer));
                  if(_loc2_ >= 0)
                  {
                     this._inactiveSingleItemRenderers.splice(_loc2_,1);
                  }
                  _loc1_ = int(this._activeSingleItemRenderers.length);
                  if(_loc1_ == 0)
                  {
                     this._activeSingleItemRenderers[_loc1_] = this._typicalItemRenderer;
                  }
               }
            }
            this.refreshOneItemRendererStyles(this._typicalItemRenderer);
         }
         this.findUnrenderedData();
         this.recoverInactiveRenderers();
         this.renderUnrenderedData();
         this.freeInactiveRenderers();
         this._updateForDataReset = false;
      }
      
      private function findUnrenderedData() : void
      {
         var _loc20_:int = 0;
         var _loc26_:Object = null;
         var _loc12_:int = 0;
         var _loc24_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc23_:* = NaN;
         var _loc19_:Object = null;
         var _loc5_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc22_:Object = null;
         var _loc21_:Object = null;
         var _loc9_:int = 0;
         var _loc3_:int = int(this._dataProvider ? this._dataProvider.getLength() : 0);
         var _loc2_:int = 0;
         var _loc17_:int = 0;
         var _loc27_:int = 0;
         var _loc25_:int = 0;
         var _loc11_:int = 0;
         _loc20_ = 0;
         while(_loc20_ < _loc3_)
         {
            _loc26_ = this._dataProvider.getItemAt(_loc20_);
            if(this._owner.groupToHeaderData(_loc26_) !== null)
            {
               this._headerIndices.push(_loc2_);
               _loc2_++;
               _loc17_++;
            }
            _loc12_ = this._dataProvider.getLength(_loc20_);
            _loc2_ += _loc12_;
            _loc11_ += _loc12_;
            if(_loc12_ == 0)
            {
               _loc25_++;
            }
            if(this._owner.groupToFooterData(_loc26_) !== null)
            {
               this._footerIndices.push(_loc2_);
               _loc2_++;
               _loc27_++;
            }
            _loc20_++;
         }
         this._layoutItems.length = _loc2_;
         var _loc28_:IVirtualLayout = this._layout as IVirtualLayout;
         var _loc6_:Boolean = _loc28_ && _loc28_.useVirtualLayout;
         if(_loc6_)
         {
            _loc28_.measureViewPort(_loc2_,this._viewPortBounds,HELPER_POINT);
            _loc24_ = HELPER_POINT.x;
            _loc13_ = HELPER_POINT.y;
            _loc28_.getVisibleIndicesAtScrollPosition(this._horizontalScrollPosition,this._verticalScrollPosition,_loc24_,_loc13_,_loc2_,HELPER_VECTOR);
            _loc11_ /= _loc3_;
            if(this._typicalItemRenderer)
            {
               _loc10_ = Number(this._typicalItemRenderer.height);
               if(this._typicalItemRenderer.width < _loc10_)
               {
                  _loc10_ = Number(this._typicalItemRenderer.width);
               }
               _loc23_ = _loc24_;
               if(_loc13_ > _loc24_)
               {
                  _loc23_ = _loc13_;
               }
               this._minimumFirstAndLastItemCount = this._minimumSingleItemCount = this._minimumHeaderCount = this._minimumFooterCount = Math.ceil(_loc23_ / (_loc10_ * _loc11_));
               this._minimumHeaderCount = Math.min(this._minimumHeaderCount,_loc17_);
               this._minimumFooterCount = Math.min(this._minimumFooterCount,_loc27_);
               this._minimumSingleItemCount = Math.min(this._minimumSingleItemCount,_loc25_);
               this._minimumItemCount = Math.ceil(_loc23_ / _loc10_) + 1;
            }
            else
            {
               this._minimumFirstAndLastItemCount = 1;
               this._minimumHeaderCount = 1;
               this._minimumFooterCount = 1;
               this._minimumSingleItemCount = 1;
               this._minimumItemCount = 1;
            }
         }
         var _loc14_:Boolean = this._firstItemRendererType || this._firstItemRendererFactory != null || this._firstItemRendererName;
         var _loc4_:Boolean = this._lastItemRendererType || this._lastItemRendererFactory != null || this._lastItemRendererName;
         var _loc18_:Boolean = this._singleItemRendererType || this._singleItemRendererFactory != null || this._singleItemRendererName;
         var _loc8_:int = 0;
         var _loc7_:int = int(this._unrenderedHeaders.length);
         var _loc1_:int = int(this._unrenderedFooters.length);
         _loc20_ = 0;
         while(_loc20_ < _loc3_)
         {
            _loc26_ = this._dataProvider.getItemAt(_loc20_);
            _loc19_ = this._owner.groupToHeaderData(_loc26_);
            if(_loc19_ !== null)
            {
               if(_loc6_ && HELPER_VECTOR.indexOf(_loc8_) < 0)
               {
                  this._layoutItems[_loc8_] = null;
               }
               else
               {
                  _loc5_ = IGroupedListHeaderOrFooterRenderer(this._headerRendererMap[_loc19_]);
                  if(_loc5_)
                  {
                     _loc5_.layoutIndex = _loc8_;
                     _loc5_.groupIndex = _loc20_;
                     if(this._updateForDataReset)
                     {
                        _loc5_.data = null;
                        _loc5_.data = _loc19_;
                     }
                     this._activeHeaderRenderers.push(_loc5_);
                     this._inactiveHeaderRenderers.splice(this._inactiveHeaderRenderers.indexOf(_loc5_),1);
                     _loc5_.visible = true;
                     this._layoutItems[_loc8_] = DisplayObject(_loc5_);
                  }
                  else
                  {
                     this._unrenderedHeaders[_loc7_] = _loc20_;
                     _loc7_++;
                     this._unrenderedHeaders[_loc7_] = _loc8_;
                     _loc7_++;
                  }
               }
               _loc8_++;
            }
            _loc12_ = this._dataProvider.getLength(_loc20_);
            _loc15_ = _loc12_ - 1;
            _loc16_ = 0;
            while(_loc16_ < _loc12_)
            {
               if(_loc6_ && HELPER_VECTOR.indexOf(_loc8_) < 0)
               {
                  this._layoutItems[_loc8_] = null;
               }
               else
               {
                  _loc22_ = this._dataProvider.getItemAt(_loc20_,_loc16_);
                  if(_loc18_ && _loc16_ == 0 && _loc16_ == _loc15_)
                  {
                     this.findRendererForItem(_loc22_,_loc20_,_loc16_,_loc8_,this._singleItemRendererMap,this._inactiveSingleItemRenderers,this._activeSingleItemRenderers,this._unrenderedSingleItems);
                  }
                  else if(_loc14_ && _loc16_ == 0)
                  {
                     this.findRendererForItem(_loc22_,_loc20_,_loc16_,_loc8_,this._firstItemRendererMap,this._inactiveFirstItemRenderers,this._activeFirstItemRenderers,this._unrenderedFirstItems);
                  }
                  else if(_loc4_ && _loc16_ == _loc15_)
                  {
                     this.findRendererForItem(_loc22_,_loc20_,_loc16_,_loc8_,this._lastItemRendererMap,this._inactiveLastItemRenderers,this._activeLastItemRenderers,this._unrenderedLastItems);
                  }
                  else
                  {
                     this.findRendererForItem(_loc22_,_loc20_,_loc16_,_loc8_,this._itemRendererMap,this._inactiveItemRenderers,this._activeItemRenderers,this._unrenderedItems);
                  }
               }
               _loc8_++;
               _loc16_++;
            }
            _loc21_ = this._owner.groupToFooterData(_loc26_);
            if(_loc21_ !== null)
            {
               if(_loc6_ && HELPER_VECTOR.indexOf(_loc8_) < 0)
               {
                  this._layoutItems[_loc8_] = null;
               }
               else
               {
                  _loc5_ = IGroupedListHeaderOrFooterRenderer(this._footerRendererMap[_loc21_]);
                  if(_loc5_)
                  {
                     _loc5_.groupIndex = _loc20_;
                     _loc5_.layoutIndex = _loc8_;
                     if(this._updateForDataReset)
                     {
                        _loc5_.data = null;
                        _loc5_.data = _loc21_;
                     }
                     this._activeFooterRenderers.push(_loc5_);
                     this._inactiveFooterRenderers.splice(this._inactiveFooterRenderers.indexOf(_loc5_),1);
                     _loc5_.visible = true;
                     this._layoutItems[_loc8_] = DisplayObject(_loc5_);
                  }
                  else
                  {
                     this._unrenderedFooters[_loc1_] = _loc20_;
                     _loc1_++;
                     this._unrenderedFooters[_loc1_] = _loc8_;
                     _loc1_++;
                  }
               }
               _loc8_++;
            }
            _loc20_++;
         }
         if(this._typicalItemRenderer)
         {
            if(_loc6_ && this._typicalItemIsInDataProvider)
            {
               _loc9_ = int(HELPER_VECTOR.indexOf(this._typicalItemRenderer.layoutIndex));
               if(_loc9_ >= 0)
               {
                  this._typicalItemRenderer.visible = true;
               }
               else
               {
                  this._typicalItemRenderer.visible = false;
               }
            }
            else
            {
               this._typicalItemRenderer.visible = this._typicalItemIsInDataProvider;
            }
         }
         HELPER_VECTOR.length = 0;
      }
      
      private function findRendererForItem(param1:Object, param2:int, param3:int, param4:int, param5:Dictionary, param6:Vector.<IGroupedListItemRenderer>, param7:Vector.<IGroupedListItemRenderer>, param8:Vector.<int>) : void
      {
         var _loc9_:int = 0;
         var _loc10_:IGroupedListItemRenderer = IGroupedListItemRenderer(param5[param1]);
         if(_loc10_)
         {
            _loc10_.groupIndex = param2;
            _loc10_.itemIndex = param3;
            _loc10_.layoutIndex = param4;
            if(this._updateForDataReset)
            {
               _loc10_.data = null;
               _loc10_.data = param1;
            }
            if(this._typicalItemRenderer != _loc10_)
            {
               param7.push(_loc10_);
               _loc9_ = int(param6.indexOf(_loc10_));
               if(_loc9_ < 0)
               {
                  throw new IllegalOperationError("GroupedListDataViewPort: renderer map contains bad data.");
               }
               param6.splice(_loc9_,1);
            }
            _loc10_.visible = true;
            this._layoutItems[param4] = DisplayObject(_loc10_);
         }
         else
         {
            param8.push(param2);
            param8.push(param3);
            param8.push(param4);
         }
      }
      
      private function renderUnrenderedData() : void
      {
         var _loc11_:int = 0;
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         var _loc9_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:IGroupedListItemRenderer = null;
         var _loc10_:Class = null;
         var _loc7_:Function = null;
         var _loc4_:String = null;
         var _loc8_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc6_:int = int(this._unrenderedItems.length);
         _loc11_ = 0;
         while(_loc11_ < _loc6_)
         {
            _loc2_ = int(this._unrenderedItems.shift());
            _loc1_ = int(this._unrenderedItems.shift());
            _loc9_ = int(this._unrenderedItems.shift());
            _loc5_ = this._dataProvider.getItemAt(_loc2_,_loc1_);
            _loc3_ = this.createItemRenderer(this._inactiveItemRenderers,this._activeItemRenderers,this._itemRendererMap,this._itemRendererType,this._itemRendererFactory,this._itemRendererName,_loc5_,_loc2_,_loc1_,_loc9_,true,false);
            this._layoutItems[_loc9_] = DisplayObject(_loc3_);
            _loc11_ += 3;
         }
         if(this._unrenderedFirstItems)
         {
            _loc6_ = int(this._unrenderedFirstItems.length);
            _loc11_ = 0;
            while(_loc11_ < _loc6_)
            {
               _loc2_ = int(this._unrenderedFirstItems.shift());
               _loc1_ = int(this._unrenderedFirstItems.shift());
               _loc9_ = int(this._unrenderedFirstItems.shift());
               _loc5_ = this._dataProvider.getItemAt(_loc2_,_loc1_);
               _loc10_ = this._firstItemRendererType ? this._firstItemRendererType : this._itemRendererType;
               _loc7_ = this._firstItemRendererFactory != null ? this._firstItemRendererFactory : this._itemRendererFactory;
               _loc4_ = this._firstItemRendererName ? this._firstItemRendererName : this._itemRendererName;
               _loc3_ = this.createItemRenderer(this._inactiveFirstItemRenderers,this._activeFirstItemRenderers,this._firstItemRendererMap,_loc10_,_loc7_,_loc4_,_loc5_,_loc2_,_loc1_,_loc9_,true,false);
               this._layoutItems[_loc9_] = DisplayObject(_loc3_);
               _loc11_ += 3;
            }
         }
         if(this._unrenderedLastItems)
         {
            _loc6_ = int(this._unrenderedLastItems.length);
            _loc11_ = 0;
            while(_loc11_ < _loc6_)
            {
               _loc2_ = int(this._unrenderedLastItems.shift());
               _loc1_ = int(this._unrenderedLastItems.shift());
               _loc9_ = int(this._unrenderedLastItems.shift());
               _loc5_ = this._dataProvider.getItemAt(_loc2_,_loc1_);
               _loc10_ = this._lastItemRendererType ? this._lastItemRendererType : this._itemRendererType;
               _loc7_ = this._lastItemRendererFactory != null ? this._lastItemRendererFactory : this._itemRendererFactory;
               _loc4_ = this._lastItemRendererName ? this._lastItemRendererName : this._itemRendererName;
               _loc3_ = this.createItemRenderer(this._inactiveLastItemRenderers,this._activeLastItemRenderers,this._lastItemRendererMap,_loc10_,_loc7_,_loc4_,_loc5_,_loc2_,_loc1_,_loc9_,true,false);
               this._layoutItems[_loc9_] = DisplayObject(_loc3_);
               _loc11_ += 3;
            }
         }
         if(this._unrenderedSingleItems)
         {
            _loc6_ = int(this._unrenderedSingleItems.length);
            _loc11_ = 0;
            while(_loc11_ < _loc6_)
            {
               _loc2_ = int(this._unrenderedSingleItems.shift());
               _loc1_ = int(this._unrenderedSingleItems.shift());
               _loc9_ = int(this._unrenderedSingleItems.shift());
               _loc5_ = this._dataProvider.getItemAt(_loc2_,_loc1_);
               _loc10_ = this._singleItemRendererType ? this._singleItemRendererType : this._itemRendererType;
               _loc7_ = this._singleItemRendererFactory != null ? this._singleItemRendererFactory : this._itemRendererFactory;
               _loc4_ = this._singleItemRendererName ? this._singleItemRendererName : this._itemRendererName;
               _loc3_ = this.createItemRenderer(this._inactiveSingleItemRenderers,this._activeSingleItemRenderers,this._singleItemRendererMap,_loc10_,_loc7_,_loc4_,_loc5_,_loc2_,_loc1_,_loc9_,true,false);
               this._layoutItems[_loc9_] = DisplayObject(_loc3_);
               _loc11_ += 3;
            }
         }
         _loc6_ = int(this._unrenderedHeaders.length);
         _loc11_ = 0;
         while(_loc11_ < _loc6_)
         {
            _loc2_ = int(this._unrenderedHeaders.shift());
            _loc9_ = int(this._unrenderedHeaders.shift());
            _loc5_ = this._dataProvider.getItemAt(_loc2_);
            _loc5_ = this._owner.groupToHeaderData(_loc5_);
            _loc8_ = this.createHeaderRenderer(_loc5_,_loc2_,_loc9_,false);
            this._layoutItems[_loc9_] = DisplayObject(_loc8_);
            _loc11_ += 2;
         }
         _loc6_ = int(this._unrenderedFooters.length);
         _loc11_ = 0;
         while(_loc11_ < _loc6_)
         {
            _loc2_ = int(this._unrenderedFooters.shift());
            _loc9_ = int(this._unrenderedFooters.shift());
            _loc5_ = this._dataProvider.getItemAt(_loc2_);
            _loc5_ = this._owner.groupToFooterData(_loc5_);
            _loc8_ = this.createFooterRenderer(_loc5_,_loc2_,_loc9_,false);
            this._layoutItems[_loc9_] = DisplayObject(_loc8_);
            _loc11_ += 2;
         }
      }
      
      private function recoverInactiveRenderers() : void
      {
         var _loc4_:int = 0;
         var _loc1_:IGroupedListItemRenderer = null;
         var _loc3_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc2_:int = int(this._inactiveItemRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc1_ = this._inactiveItemRenderers[_loc4_];
            if(!(!_loc1_ || _loc1_.groupIndex < 0))
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc1_);
               delete this._itemRendererMap[_loc1_.data];
            }
            _loc4_++;
         }
         if(this._inactiveFirstItemRenderers)
         {
            _loc2_ = int(this._inactiveFirstItemRenderers.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = this._inactiveFirstItemRenderers[_loc4_];
               if(_loc1_)
               {
                  this._owner.dispatchEventWith("rendererRemove",false,_loc1_);
                  delete this._firstItemRendererMap[_loc1_.data];
               }
               _loc4_++;
            }
         }
         if(this._inactiveLastItemRenderers)
         {
            _loc2_ = int(this._inactiveLastItemRenderers.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = this._inactiveLastItemRenderers[_loc4_];
               if(_loc1_)
               {
                  this._owner.dispatchEventWith("rendererRemove",false,_loc1_);
                  delete this._lastItemRendererMap[_loc1_.data];
               }
               _loc4_++;
            }
         }
         if(this._inactiveSingleItemRenderers)
         {
            _loc2_ = int(this._inactiveSingleItemRenderers.length);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc1_ = this._inactiveSingleItemRenderers[_loc4_];
               if(_loc1_)
               {
                  this._owner.dispatchEventWith("rendererRemove",false,_loc1_);
                  delete this._singleItemRendererMap[_loc1_.data];
               }
               _loc4_++;
            }
         }
         _loc2_ = int(this._inactiveHeaderRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._inactiveHeaderRenderers[_loc4_];
            if(_loc3_)
            {
               this._owner.dispatchEventWith("rendererRemove",false,_loc3_);
               delete this._headerRendererMap[_loc3_.data];
            }
            _loc4_++;
         }
         _loc2_ = int(this._inactiveFooterRenderers.length);
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = this._inactiveFooterRenderers[_loc4_];
            this._owner.dispatchEventWith("rendererRemove",false,_loc3_);
            delete this._footerRendererMap[_loc3_.data];
            _loc4_++;
         }
      }
      
      private function freeInactiveRenderers() : void
      {
         var _loc5_:int = 0;
         var _loc1_:IGroupedListItemRenderer = null;
         var _loc4_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc3_:int = Math.min(this._minimumItemCount - this._activeItemRenderers.length,this._inactiveItemRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc1_ = this._inactiveItemRenderers.shift();
            _loc1_.data = null;
            _loc1_.groupIndex = -1;
            _loc1_.itemIndex = -1;
            _loc1_.layoutIndex = -1;
            _loc1_.visible = false;
            this._activeItemRenderers.push(_loc1_);
            _loc5_++;
         }
         var _loc2_:int = int(this._inactiveItemRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc1_ = this._inactiveItemRenderers.shift();
            if(_loc1_)
            {
               this.destroyItemRenderer(_loc1_);
            }
            _loc5_++;
         }
         if(this._activeFirstItemRenderers)
         {
            _loc3_ = Math.min(this._minimumFirstAndLastItemCount - this._activeFirstItemRenderers.length,this._inactiveFirstItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc1_ = this._inactiveFirstItemRenderers.shift();
               _loc1_.data = null;
               _loc1_.groupIndex = -1;
               _loc1_.itemIndex = -1;
               _loc1_.layoutIndex = -1;
               _loc1_.visible = false;
               this._activeFirstItemRenderers.push(_loc1_);
               _loc5_++;
            }
            _loc2_ = int(this._inactiveFirstItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc1_ = this._inactiveFirstItemRenderers.shift();
               if(_loc1_)
               {
                  this.destroyItemRenderer(_loc1_);
               }
               _loc5_++;
            }
         }
         if(this._activeLastItemRenderers)
         {
            _loc3_ = Math.min(this._minimumFirstAndLastItemCount - this._activeLastItemRenderers.length,this._inactiveLastItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc1_ = this._inactiveLastItemRenderers.shift();
               _loc1_.data = null;
               _loc1_.groupIndex = -1;
               _loc1_.itemIndex = -1;
               _loc1_.layoutIndex = -1;
               _loc1_.visible = false;
               this._activeLastItemRenderers.push(_loc1_);
               _loc5_++;
            }
            _loc2_ = int(this._inactiveLastItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc1_ = this._inactiveLastItemRenderers.shift();
               if(_loc1_)
               {
                  this.destroyItemRenderer(_loc1_);
               }
               _loc5_++;
            }
         }
         if(this._activeSingleItemRenderers)
         {
            _loc3_ = Math.min(this._minimumSingleItemCount - this._activeSingleItemRenderers.length,this._inactiveSingleItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc1_ = this._inactiveSingleItemRenderers.shift();
               _loc1_.data = null;
               _loc1_.groupIndex = -1;
               _loc1_.itemIndex = -1;
               _loc1_.layoutIndex = -1;
               _loc1_.visible = false;
               this._activeSingleItemRenderers.push(_loc1_);
               _loc5_++;
            }
            _loc2_ = int(this._inactiveSingleItemRenderers.length);
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               _loc1_ = this._inactiveSingleItemRenderers.shift();
               if(_loc1_)
               {
                  this.destroyItemRenderer(_loc1_);
               }
               _loc5_++;
            }
         }
         _loc3_ = Math.min(this._minimumHeaderCount - this._activeHeaderRenderers.length,this._inactiveHeaderRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._inactiveHeaderRenderers.shift();
            _loc4_.visible = false;
            _loc4_.data = null;
            _loc4_.groupIndex = -1;
            _loc4_.layoutIndex = -1;
            this._activeHeaderRenderers.push(_loc4_);
            _loc5_++;
         }
         _loc2_ = int(this._inactiveHeaderRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc4_ = this._inactiveHeaderRenderers.shift();
            if(_loc4_)
            {
               this.destroyHeaderRenderer(_loc4_);
            }
            _loc5_++;
         }
         _loc3_ = Math.min(this._minimumFooterCount - this._activeFooterRenderers.length,this._inactiveFooterRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._inactiveFooterRenderers.shift();
            _loc4_.visible = false;
            _loc4_.data = null;
            _loc4_.groupIndex = -1;
            _loc4_.layoutIndex = -1;
            this._activeFooterRenderers.push(_loc4_);
            _loc5_++;
         }
         _loc2_ = int(this._inactiveFooterRenderers.length);
         _loc5_ = 0;
         while(_loc5_ < _loc2_)
         {
            _loc4_ = this._inactiveFooterRenderers.shift();
            if(_loc4_)
            {
               this.destroyFooterRenderer(_loc4_);
            }
            _loc5_++;
         }
      }
      
      private function createItemRenderer(param1:Vector.<IGroupedListItemRenderer>, param2:Vector.<IGroupedListItemRenderer>, param3:Dictionary, param4:Class, param5:Function, param6:String, param7:Object, param8:int, param9:int, param10:int, param11:Boolean, param12:Boolean) : IGroupedListItemRenderer
      {
         var _loc13_:IGroupedListItemRenderer = null;
         var _loc14_:IFeathersControl = null;
         if(!param11 || param12 || param1.length == 0)
         {
            if(param5 != null)
            {
               _loc13_ = IGroupedListItemRenderer(param5());
            }
            else
            {
               _loc13_ = new param4();
            }
            _loc14_ = IFeathersControl(_loc13_);
            if(param6 && param6.length > 0)
            {
               _loc14_.styleNameList.add(param6);
            }
            this.addChild(DisplayObject(_loc13_));
         }
         else
         {
            _loc13_ = param1.shift();
         }
         _loc13_.data = param7;
         _loc13_.groupIndex = param8;
         _loc13_.itemIndex = param9;
         _loc13_.layoutIndex = param10;
         _loc13_.owner = this._owner;
         _loc13_.visible = true;
         if(!param12)
         {
            param3[param7] = _loc13_;
            param2.push(_loc13_);
            _loc13_.addEventListener("change",renderer_changeHandler);
            _loc13_.addEventListener("resize",itemRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc13_);
         }
         return _loc13_;
      }
      
      private function createHeaderRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListHeaderOrFooterRenderer
      {
         var _loc5_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc6_:IFeathersControl = null;
         if(param4 || this._inactiveHeaderRenderers.length == 0)
         {
            if(this._headerRendererFactory != null)
            {
               _loc5_ = IGroupedListHeaderOrFooterRenderer(this._headerRendererFactory());
            }
            else
            {
               _loc5_ = new this._headerRendererType();
            }
            _loc6_ = IFeathersControl(_loc5_);
            if(this._headerRendererName && this._headerRendererName.length > 0)
            {
               _loc6_.styleNameList.add(this._headerRendererName);
            }
            this.addChild(DisplayObject(_loc5_));
         }
         else
         {
            _loc5_ = this._inactiveHeaderRenderers.shift();
         }
         _loc5_.data = param1;
         _loc5_.groupIndex = param2;
         _loc5_.layoutIndex = param3;
         _loc5_.owner = this._owner;
         _loc5_.visible = true;
         if(!param4)
         {
            this._headerRendererMap[param1] = _loc5_;
            this._activeHeaderRenderers.push(_loc5_);
            _loc5_.addEventListener("resize",headerOrFooterRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc5_);
         }
         return _loc5_;
      }
      
      private function createFooterRenderer(param1:Object, param2:int, param3:int, param4:Boolean = false) : IGroupedListHeaderOrFooterRenderer
      {
         var _loc5_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc6_:IFeathersControl = null;
         if(param4 || this._inactiveFooterRenderers.length == 0)
         {
            if(this._footerRendererFactory != null)
            {
               _loc5_ = IGroupedListHeaderOrFooterRenderer(this._footerRendererFactory());
            }
            else
            {
               _loc5_ = new this._footerRendererType();
            }
            _loc6_ = IFeathersControl(_loc5_);
            if(this._footerRendererName && this._footerRendererName.length > 0)
            {
               _loc6_.styleNameList.add(this._footerRendererName);
            }
            this.addChild(DisplayObject(_loc5_));
         }
         else
         {
            _loc5_ = this._inactiveFooterRenderers.shift();
         }
         _loc5_.data = param1;
         _loc5_.groupIndex = param2;
         _loc5_.layoutIndex = param3;
         _loc5_.owner = this._owner;
         _loc5_.visible = true;
         if(!param4)
         {
            this._footerRendererMap[param1] = _loc5_;
            this._activeFooterRenderers.push(_loc5_);
            _loc5_.addEventListener("resize",headerOrFooterRenderer_resizeHandler);
            this._owner.dispatchEventWith("rendererAdd",false,_loc5_);
         }
         return _loc5_;
      }
      
      private function destroyItemRenderer(param1:IGroupedListItemRenderer) : void
      {
         param1.removeEventListener("change",renderer_changeHandler);
         param1.removeEventListener("resize",itemRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyHeaderRenderer(param1:IGroupedListHeaderOrFooterRenderer) : void
      {
         param1.removeEventListener("resize",headerOrFooterRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function destroyFooterRenderer(param1:IGroupedListHeaderOrFooterRenderer) : void
      {
         param1.removeEventListener("resize",headerOrFooterRenderer_resizeHandler);
         param1.owner = null;
         param1.data = null;
         this.removeChild(DisplayObject(param1),true);
      }
      
      private function groupToHeaderDisplayIndex(param1:int) : int
      {
         var _loc9_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Object = null;
         var _loc6_:Object = this._dataProvider.getItemAt(param1);
         var _loc8_:Object = this._owner.groupToHeaderData(_loc6_);
         if(!_loc8_)
         {
            return -1;
         }
         var _loc7_:int = 0;
         var _loc3_:int = this._dataProvider.getLength();
         _loc9_ = 0;
         while(_loc9_ < _loc3_)
         {
            _loc6_ = this._dataProvider.getItemAt(_loc9_);
            _loc8_ = this._owner.groupToHeaderData(_loc6_);
            if(_loc8_)
            {
               if(param1 == _loc9_)
               {
                  return _loc7_;
               }
               _loc7_++;
            }
            _loc4_ = this._dataProvider.getLength(_loc9_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc7_++;
               _loc5_++;
            }
            _loc2_ = this._owner.groupToFooterData(_loc6_);
            if(_loc2_)
            {
               _loc7_++;
            }
            _loc9_++;
         }
         return -1;
      }
      
      private function groupToFooterDisplayIndex(param1:int) : int
      {
         var _loc9_:int = 0;
         var _loc7_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = this._dataProvider.getItemAt(param1);
         var _loc2_:Object = this._owner.groupToFooterData(_loc6_);
         if(!_loc2_)
         {
            return -1;
         }
         var _loc8_:int = 0;
         var _loc3_:int = this._dataProvider.getLength();
         _loc9_ = 0;
         while(_loc9_ < _loc3_)
         {
            _loc6_ = this._dataProvider.getItemAt(_loc9_);
            _loc7_ = this._owner.groupToHeaderData(_loc6_);
            if(_loc7_)
            {
               _loc8_++;
            }
            _loc4_ = this._dataProvider.getLength(_loc9_);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc8_++;
               _loc5_++;
            }
            _loc2_ = this._owner.groupToFooterData(_loc6_);
            if(_loc2_)
            {
               if(param1 == _loc9_)
               {
                  return _loc8_;
               }
               _loc8_++;
            }
            _loc9_++;
         }
         return -1;
      }
      
      private function locationToDisplayIndex(param1:int, param2:int) : int
      {
         var _loc10_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Object = null;
         var _loc9_:int = 0;
         var _loc4_:int = this._dataProvider.getLength();
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc7_ = this._dataProvider.getItemAt(_loc10_);
            _loc8_ = this._owner.groupToHeaderData(_loc7_);
            if(_loc8_)
            {
               _loc9_++;
            }
            _loc5_ = this._dataProvider.getLength(_loc10_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               if(param1 == _loc10_ && param2 == _loc6_)
               {
                  return _loc9_;
               }
               _loc9_++;
               _loc6_++;
            }
            _loc3_ = this._owner.groupToFooterData(_loc7_);
            if(_loc3_)
            {
               _loc9_++;
            }
            _loc10_++;
         }
         return -1;
      }
      
      private function getMappedItemRenderer(param1:Object) : IGroupedListItemRenderer
      {
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(this._itemRendererMap[param1]);
         if(_loc2_)
         {
            return _loc2_;
         }
         if(this._firstItemRendererMap)
         {
            _loc2_ = IGroupedListItemRenderer(this._firstItemRendererMap[param1]);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         if(this._singleItemRendererMap)
         {
            _loc2_ = IGroupedListItemRenderer(this._singleItemRendererMap[param1]);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         if(this._lastItemRendererMap)
         {
            _loc2_ = IGroupedListItemRenderer(this._lastItemRendererMap[param1]);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      private function owner_scrollStartHandler(param1:Event) : void
      {
         this._isScrolling = true;
      }
      
      private function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      private function dataProvider_addItemHandler(param1:Event, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = 0;
         var _loc10_:* = 0;
         var _loc11_:* = 0;
         var _loc9_:int = 0;
         var _loc8_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc8_ || !_loc8_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc3_ = param2[1] as int;
            _loc7_ = this.locationToDisplayIndex(_loc4_,_loc3_);
            _loc8_.addToVariableVirtualCacheAtIndex(_loc7_);
         }
         else
         {
            _loc6_ = this.groupToHeaderDisplayIndex(_loc4_);
            if(_loc6_ >= 0)
            {
               _loc8_.addToVariableVirtualCacheAtIndex(_loc6_);
            }
            _loc5_ = this._dataProvider.getLength(_loc4_);
            if(_loc5_ > 0)
            {
               _loc10_ = _loc6_;
               if(_loc10_ < 0)
               {
                  _loc10_ = this.locationToDisplayIndex(_loc4_,0);
               }
               _loc5_ += _loc10_;
               _loc11_ = _loc10_;
               while(_loc11_ < _loc5_)
               {
                  _loc8_.addToVariableVirtualCacheAtIndex(_loc10_);
                  _loc11_++;
               }
            }
            _loc9_ = this.groupToFooterDisplayIndex(_loc4_);
            if(_loc9_ >= 0)
            {
               _loc8_.addToVariableVirtualCacheAtIndex(_loc9_);
            }
         }
      }
      
      private function dataProvider_removeItemHandler(param1:Event, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc5_ || !_loc5_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc3_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc4_,_loc3_);
            _loc5_.removeFromVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc5_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_replaceItemHandler(param1:Event, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc5_ || !_loc5_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc3_ = param2[1] as int;
            _loc6_ = this.locationToDisplayIndex(_loc4_,_loc3_);
            _loc5_.resetVariableVirtualCacheAtIndex(_loc6_);
         }
         else
         {
            _loc5_.resetVariableVirtualCache();
         }
      }
      
      private function dataProvider_resetHandler(param1:Event) : void
      {
         this._updateForDataReset = true;
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         _loc2_.resetVariableVirtualCache();
      }
      
      private function dataProvider_updateItemHandler(param1:Event, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc8_:Object = null;
         var _loc6_:IGroupedListItemRenderer = null;
         var _loc5_:int = 0;
         var _loc11_:int = 0;
         var _loc10_:Object = null;
         var _loc9_:IGroupedListHeaderOrFooterRenderer = null;
         var _loc7_:IVariableVirtualLayout = null;
         var _loc4_:int = param2[0] as int;
         if(param2.length > 1)
         {
            _loc3_ = param2[1] as int;
            _loc8_ = this._dataProvider.getItemAt(_loc4_,_loc3_);
            _loc6_ = this.getMappedItemRenderer(_loc8_);
            if(_loc6_)
            {
               _loc6_.data = null;
               _loc6_.data = _loc8_;
            }
         }
         else
         {
            _loc5_ = this._dataProvider.getLength(_loc4_);
            _loc11_ = 0;
            while(_loc11_ < _loc5_)
            {
               _loc8_ = this._dataProvider.getItemAt(_loc4_,_loc11_);
               if(_loc8_)
               {
                  _loc6_ = this.getMappedItemRenderer(_loc8_);
                  if(_loc6_)
                  {
                     _loc6_.data = null;
                     _loc6_.data = _loc8_;
                  }
               }
               _loc11_++;
            }
            _loc10_ = this._dataProvider.getItemAt(_loc4_);
            _loc8_ = this._owner.groupToHeaderData(_loc10_);
            if(_loc8_)
            {
               _loc9_ = IGroupedListHeaderOrFooterRenderer(this._headerRendererMap[_loc8_]);
               if(_loc9_)
               {
                  _loc9_.data = null;
                  _loc9_.data = _loc8_;
               }
            }
            _loc8_ = this._owner.groupToFooterData(_loc10_);
            if(_loc8_)
            {
               _loc9_ = IGroupedListHeaderOrFooterRenderer(this._footerRendererMap[_loc8_]);
               if(_loc9_)
               {
                  _loc9_.data = null;
                  _loc9_.data = _loc8_;
               }
            }
            this.invalidate("data");
            _loc7_ = this._layout as IVariableVirtualLayout;
            if(!_loc7_ || !_loc7_.hasVariableItemDimensions)
            {
               return;
            }
            _loc7_.resetVariableVirtualCache();
         }
      }
      
      private function layout_changeHandler(param1:Event) : void
      {
         if(this._ignoreLayoutChanges)
         {
            return;
         }
         this.invalidate("layout");
         this.invalidateParent("layout");
      }
      
      private function itemRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc3_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(_loc3_.layoutIndex < 0)
         {
            return;
         }
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
         this.invalidate("layout");
         this.invalidateParent("layout");
      }
      
      private function headerOrFooterRenderer_resizeHandler(param1:Event) : void
      {
         if(this._ignoreRendererResizing)
         {
            return;
         }
         var _loc2_:IVariableVirtualLayout = this._layout as IVariableVirtualLayout;
         if(!_loc2_ || !_loc2_.hasVariableItemDimensions)
         {
            return;
         }
         var _loc3_:IGroupedListHeaderOrFooterRenderer = IGroupedListHeaderOrFooterRenderer(param1.currentTarget);
         if(_loc3_.layoutIndex < 0)
         {
            return;
         }
         _loc2_.resetVariableVirtualCacheAtIndex(_loc3_.layoutIndex,DisplayObject(_loc3_));
         this.invalidate("layout");
         this.invalidateParent("layout");
      }
      
      private function renderer_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         var _loc2_:IGroupedListItemRenderer = IGroupedListItemRenderer(param1.currentTarget);
         if(!this._isSelectable || this._isScrolling)
         {
            _loc2_.isSelected = false;
            return;
         }
         if(_loc2_.isSelected)
         {
            this.setSelectedLocation(_loc2_.groupIndex,_loc2_.itemIndex);
         }
         else
         {
            this.setSelectedLocation(-1,-1);
         }
      }
      
      private function removedFromStageHandler(param1:Event) : void
      {
         this.touchPointID = -1;
      }
      
      private function touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(!this._isEnabled)
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
         }
         else
         {
            _loc2_ = param1.getTouch(this,"began");
            if(!_loc2_)
            {
               return;
            }
            this.touchPointID = _loc2_.id;
            this._isScrolling = false;
         }
      }
   }
}

