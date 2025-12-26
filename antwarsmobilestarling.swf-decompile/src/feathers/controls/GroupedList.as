package feathers.controls
{
   import feathers.controls.renderers.DefaultGroupedListHeaderOrFooterRenderer;
   import feathers.controls.renderers.DefaultGroupedListItemRenderer;
   import feathers.controls.supportClasses.GroupedListDataViewPort;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.PropertyProxy;
   import feathers.data.HierarchicalCollection;
   import feathers.layout.ILayout;
   import feathers.layout.VerticalLayout;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import starling.events.Event;
   import starling.events.KeyboardEvent;
   
   public class GroupedList extends Scroller implements IFocusDisplayObject
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      public static const ALTERNATE_NAME_INSET_GROUPED_LIST:String = "feathers-inset-grouped-list";
      
      public static const DEFAULT_CHILD_NAME_HEADER_RENDERER:String = "feathers-grouped-list-header-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_HEADER_RENDERER:String = "feathers-grouped-list-inset-header-renderer";
      
      public static const DEFAULT_CHILD_NAME_FOOTER_RENDERER:String = "feathers-grouped-list-footer-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_FOOTER_RENDERER:String = "feathers-grouped-list-inset-footer-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_ITEM_RENDERER:String = "feathers-grouped-list-inset-item-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_FIRST_ITEM_RENDERER:String = "feathers-grouped-list-inset-first-item-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_LAST_ITEM_RENDERER:String = "feathers-grouped-list-inset-last-item-renderer";
      
      public static const ALTERNATE_CHILD_NAME_INSET_SINGLE_ITEM_RENDERER:String = "feathers-grouped-list-inset-single-item-renderer";
      
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
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var dataViewPort:GroupedListDataViewPort;
      
      protected var _layout:ILayout;
      
      protected var _dataProvider:HierarchicalCollection;
      
      protected var _isSelectable:Boolean = true;
      
      protected var _selectedGroupIndex:int = -1;
      
      protected var _selectedItemIndex:int = -1;
      
      protected var _itemRendererType:Class = DefaultGroupedListItemRenderer;
      
      protected var _itemRendererFactory:Function;
      
      protected var _typicalItem:Object = null;
      
      protected var _itemRendererName:String;
      
      protected var _itemRendererProperties:PropertyProxy;
      
      protected var _firstItemRendererType:Class;
      
      protected var _firstItemRendererFactory:Function;
      
      protected var _firstItemRendererName:String;
      
      protected var _lastItemRendererType:Class;
      
      protected var _lastItemRendererFactory:Function;
      
      protected var _lastItemRendererName:String;
      
      protected var _singleItemRendererType:Class;
      
      protected var _singleItemRendererFactory:Function;
      
      protected var _singleItemRendererName:String;
      
      protected var _headerRendererType:Class = DefaultGroupedListHeaderOrFooterRenderer;
      
      protected var _headerRendererFactory:Function;
      
      protected var _headerRendererName:String = "feathers-grouped-list-header-renderer";
      
      protected var _headerRendererProperties:PropertyProxy;
      
      protected var _footerRendererType:Class = DefaultGroupedListHeaderOrFooterRenderer;
      
      protected var _footerRendererFactory:Function;
      
      protected var _footerRendererName:String = "feathers-grouped-list-footer-renderer";
      
      protected var _footerRendererProperties:PropertyProxy;
      
      protected var _headerField:String = "header";
      
      protected var _headerFunction:Function;
      
      protected var _footerField:String = "footer";
      
      protected var _footerFunction:Function;
      
      protected var pendingGroupIndex:int = -1;
      
      protected var pendingItemIndex:int = -1;
      
      public function GroupedList()
      {
         super();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return GroupedList.globalStyleProvider;
      }
      
      override public function get isFocusEnabled() : Boolean
      {
         return this._isSelectable && this._isEnabled && this._isFocusEnabled;
      }
      
      public function get layout() : ILayout
      {
         return this._layout;
      }
      
      public function set layout(param1:ILayout) : void
      {
         if(this._layout == param1)
         {
            return;
         }
         this._layout = param1;
         this.invalidate("layout");
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
            this._dataProvider.removeEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("reset",dataProvider_resetHandler);
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
         }
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
         this.setSelectedLocation(-1,-1);
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
      
      public function get selectedItem() : Object
      {
         if(!this._dataProvider || this._selectedGroupIndex < 0 || this._selectedItemIndex < 0)
         {
            return null;
         }
         return this._dataProvider.getItemAt(this._selectedGroupIndex,this._selectedItemIndex);
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(!this._dataProvider)
         {
            this.setSelectedLocation(-1,-1);
            return;
         }
         var _loc2_:Vector.<int> = this._dataProvider.getItemLocation(param1);
         if(_loc2_.length == 2)
         {
            this.setSelectedLocation(_loc2_[0],_loc2_[1]);
         }
         else
         {
            this.setSelectedLocation(-1,-1);
         }
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get itemRendererProperties() : Object
      {
         if(!this._itemRendererProperties)
         {
            this._itemRendererProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._itemRendererProperties;
      }
      
      public function set itemRendererProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._itemRendererProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get headerRendererProperties() : Object
      {
         if(!this._headerRendererProperties)
         {
            this._headerRendererProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._headerRendererProperties;
      }
      
      public function set headerRendererProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._headerRendererProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get footerRendererProperties() : Object
      {
         if(!this._footerRendererProperties)
         {
            this._footerRendererProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._footerRendererProperties;
      }
      
      public function set footerRendererProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._footerRendererProperties == param1)
         {
            return;
         }
         if(!param1)
         {
            param1 = new PropertyProxy();
         }
         if(!(param1 is PropertyProxy))
         {
            _loc3_ = new PropertyProxy();
            for(var _loc2_ in param1)
            {
               _loc3_[_loc2_] = param1[_loc2_];
            }
            param1 = _loc3_;
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
      
      public function get headerField() : String
      {
         return this._headerField;
      }
      
      public function set headerField(param1:String) : void
      {
         if(this._headerField == param1)
         {
            return;
         }
         this._headerField = param1;
         this.invalidate("data");
      }
      
      public function get headerFunction() : Function
      {
         return this._headerFunction;
      }
      
      public function set headerFunction(param1:Function) : void
      {
         if(this._headerFunction == param1)
         {
            return;
         }
         this._headerFunction = param1;
         this.invalidate("data");
      }
      
      public function get footerField() : String
      {
         return this._footerField;
      }
      
      public function set footerField(param1:String) : void
      {
         if(this._footerField == param1)
         {
            return;
         }
         this._footerField = param1;
         this.invalidate("data");
      }
      
      public function get footerFunction() : Function
      {
         return this._footerFunction;
      }
      
      public function set footerFunction(param1:Function) : void
      {
         if(this._footerFunction == param1)
         {
            return;
         }
         this._footerFunction = param1;
         this.invalidate("data");
      }
      
      override public function dispose() : void
      {
         this._selectedGroupIndex = -1;
         this._selectedItemIndex = -1;
         this.dataProvider = null;
         super.dispose();
      }
      
      override public function scrollToPosition(param1:Number, param2:Number, param3:Number = NaN) : void
      {
         this.pendingItemIndex = -1;
         super.scrollToPosition(param1,param2,param3);
      }
      
      override public function scrollToPageIndex(param1:int, param2:int, param3:Number = NaN) : void
      {
         this.pendingGroupIndex = -1;
         this.pendingItemIndex = -1;
         super.scrollToPageIndex(param1,param2,param3);
      }
      
      public function scrollToDisplayIndex(param1:int, param2:int, param3:Number = 0) : void
      {
         this.pendingHorizontalPageIndex = -1;
         this.pendingVerticalPageIndex = -1;
         this.pendingHorizontalScrollPosition = NaN;
         this.pendingVerticalScrollPosition = NaN;
         if(this.pendingGroupIndex == param1 && this.pendingItemIndex == param2 && this.pendingScrollDuration == param3)
         {
            return;
         }
         this.pendingGroupIndex = param1;
         this.pendingItemIndex = param2;
         this.pendingScrollDuration = param3;
         this.invalidate("pendingScroll");
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
      
      public function groupToHeaderData(param1:Object) : Object
      {
         if(this._headerFunction != null)
         {
            return this._headerFunction(param1);
         }
         if(this._headerField != null && param1 && param1.hasOwnProperty(this._headerField))
         {
            return param1[this._headerField];
         }
         return null;
      }
      
      public function groupToFooterData(param1:Object) : Object
      {
         if(this._footerFunction != null)
         {
            return this._footerFunction(param1);
         }
         if(this._footerField != null && param1 && param1.hasOwnProperty(this._footerField))
         {
            return param1[this._footerField];
         }
         return null;
      }
      
      override protected function initialize() : void
      {
         var _loc1_:VerticalLayout = null;
         var _loc2_:* = this._layout != null;
         super.initialize();
         if(!this.dataViewPort)
         {
            this.viewPort = this.dataViewPort = new GroupedListDataViewPort();
            this.dataViewPort.owner = this;
            this.dataViewPort.addEventListener("change",dataViewPort_changeHandler);
            this.viewPort = this.dataViewPort;
         }
         if(!_loc2_)
         {
            if(this._hasElasticEdges && this._verticalScrollPolicy == "auto" && this._scrollBarDisplayMode != "fixed")
            {
               this.verticalScrollPolicy = "on";
            }
            _loc1_ = new VerticalLayout();
            _loc1_.useVirtualLayout = true;
            _loc1_.paddingTop = _loc1_.paddingRight = _loc1_.paddingBottom = _loc1_.paddingLeft = 0;
            _loc1_.gap = 0;
            _loc1_.horizontalAlign = "justify";
            _loc1_.verticalAlign = "top";
            this._layout = _loc1_;
         }
      }
      
      override protected function draw() : void
      {
         this.refreshDataViewPortProperties();
         super.draw();
         this.refreshFocusIndicator();
      }
      
      protected function refreshDataViewPortProperties() : void
      {
         this.dataViewPort.isSelectable = this._isSelectable;
         this.dataViewPort.setSelectedLocation(this._selectedGroupIndex,this._selectedItemIndex);
         this.dataViewPort.dataProvider = this._dataProvider;
         this.dataViewPort.typicalItem = this._typicalItem;
         this.dataViewPort.itemRendererType = this._itemRendererType;
         this.dataViewPort.itemRendererFactory = this._itemRendererFactory;
         this.dataViewPort.itemRendererProperties = this._itemRendererProperties;
         this.dataViewPort.itemRendererName = this._itemRendererName;
         this.dataViewPort.firstItemRendererType = this._firstItemRendererType;
         this.dataViewPort.firstItemRendererFactory = this._firstItemRendererFactory;
         this.dataViewPort.firstItemRendererName = this._firstItemRendererName;
         this.dataViewPort.lastItemRendererType = this._lastItemRendererType;
         this.dataViewPort.lastItemRendererFactory = this._lastItemRendererFactory;
         this.dataViewPort.lastItemRendererName = this._lastItemRendererName;
         this.dataViewPort.singleItemRendererType = this._singleItemRendererType;
         this.dataViewPort.singleItemRendererFactory = this._singleItemRendererFactory;
         this.dataViewPort.singleItemRendererName = this._singleItemRendererName;
         this.dataViewPort.headerRendererType = this._headerRendererType;
         this.dataViewPort.headerRendererFactory = this._headerRendererFactory;
         this.dataViewPort.headerRendererProperties = this._headerRendererProperties;
         this.dataViewPort.headerRendererName = this._headerRendererName;
         this.dataViewPort.footerRendererType = this._footerRendererType;
         this.dataViewPort.footerRendererFactory = this._footerRendererFactory;
         this.dataViewPort.footerRendererProperties = this._footerRendererProperties;
         this.dataViewPort.footerRendererName = this._footerRendererName;
         this.dataViewPort.layout = this._layout;
      }
      
      override protected function handlePendingScroll() : void
      {
         var _loc3_:Object = null;
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         if(this.pendingGroupIndex >= 0 && this.pendingItemIndex >= 0)
         {
            _loc3_ = this._dataProvider.getItemAt(this.pendingGroupIndex,this.pendingItemIndex);
            if(_loc3_ is Object)
            {
               this.dataViewPort.getScrollPositionForIndex(this.pendingGroupIndex,this.pendingItemIndex,HELPER_POINT);
               this.pendingGroupIndex = -1;
               this.pendingItemIndex = -1;
               _loc2_ = HELPER_POINT.x;
               if(_loc2_ < this._minHorizontalScrollPosition)
               {
                  _loc2_ = this._minHorizontalScrollPosition;
               }
               else if(_loc2_ > this._maxHorizontalScrollPosition)
               {
                  _loc2_ = this._maxHorizontalScrollPosition;
               }
               _loc1_ = HELPER_POINT.y;
               if(_loc1_ < this._minVerticalScrollPosition)
               {
                  _loc1_ = this._minVerticalScrollPosition;
               }
               else if(_loc1_ > this._maxVerticalScrollPosition)
               {
                  _loc1_ = this._maxVerticalScrollPosition;
               }
               this.throwTo(_loc2_,_loc1_,this.pendingScrollDuration);
            }
         }
         super.handlePendingScroll();
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
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         if(!this._dataProvider)
         {
            return;
         }
         if(param1.keyCode == 36)
         {
            if(this._dataProvider.getLength() > 0 && this._dataProvider.getLength(0) > 0)
            {
               this.setSelectedLocation(0,0);
            }
         }
         if(param1.keyCode == 35)
         {
            _loc3_ = this._dataProvider.getLength();
            _loc2_ = -1;
            do
            {
               if(--_loc3_ >= 0)
               {
                  _loc2_ = this._dataProvider.getLength(_loc3_) - 1;
               }
            }
            while(_loc3_ > 0 && _loc2_ < 0);
            
            if(_loc3_ >= 0 && _loc2_ >= 0)
            {
               this.setSelectedLocation(_loc3_,_loc2_);
            }
         }
         else if(param1.keyCode == 38)
         {
            _loc3_ = this._selectedGroupIndex;
            _loc2_ = this._selectedItemIndex - 1;
            if(_loc2_ < 0)
            {
               do
               {
                  if(--_loc3_ >= 0)
                  {
                     _loc2_ = this._dataProvider.getLength(_loc3_) - 1;
                  }
               }
               while(_loc3_ > 0 && _loc2_ < 0);
               
            }
            if(_loc3_ >= 0 && _loc2_ >= 0)
            {
               this.setSelectedLocation(_loc3_,_loc2_);
            }
         }
         else if(param1.keyCode == 40)
         {
            _loc3_ = this._selectedGroupIndex;
            if(_loc3_ < 0)
            {
               _loc2_ = -1;
            }
            else
            {
               _loc2_ = this._selectedItemIndex + 1;
            }
            if(_loc3_ < 0 || _loc2_ >= this._dataProvider.getLength(_loc3_))
            {
               _loc2_ = -1;
               _loc3_++;
               _loc4_ = this._dataProvider.getLength();
               while(_loc3_ < _loc4_ && _loc2_ < 0)
               {
                  if(this._dataProvider.getLength(_loc3_) > 0)
                  {
                     _loc2_ = 0;
                  }
                  else
                  {
                     _loc3_++;
                  }
               }
            }
            if(_loc3_ >= 0 && _loc2_ >= 0)
            {
               this.setSelectedLocation(_loc3_,_loc2_);
            }
         }
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      protected function dataProvider_resetHandler(param1:Event) : void
      {
         this.horizontalScrollPosition = 0;
         this.verticalScrollPosition = 0;
      }
      
      protected function dataViewPort_changeHandler(param1:Event) : void
      {
         this.setSelectedLocation(this.dataViewPort.selectedGroupIndex,this.dataViewPort.selectedItemIndex);
      }
   }
}

