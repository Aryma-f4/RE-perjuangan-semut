package feathers.controls
{
   import feathers.controls.popups.CalloutPopUpContentManager;
   import feathers.controls.popups.IPopUpContentManager;
   import feathers.controls.popups.VerticalCenteredPopUpContentManager;
   import feathers.controls.renderers.IListItemRenderer;
   import feathers.core.FeathersControl;
   import feathers.core.IFocusDisplayObject;
   import feathers.core.IToggle;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.skins.IStyleProvider;
   import feathers.system.DeviceCapabilities;
   import starling.core.Starling;
   import starling.events.Event;
   import starling.events.EventDispatcher;
   import starling.events.KeyboardEvent;
   import starling.events.Touch;
   import starling.events.TouchEvent;
   
   public class PickerList extends FeathersControl implements IFocusDisplayObject
   {
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const INVALIDATION_FLAG_LIST_FACTORY:String = "listFactory";
      
      public static const DEFAULT_CHILD_NAME_BUTTON:String = "feathers-picker-list-button";
      
      public static const DEFAULT_CHILD_NAME_LIST:String = "feathers-picker-list-list";
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var buttonName:String = "feathers-picker-list-button";
      
      protected var listName:String = "feathers-picker-list-list";
      
      protected var button:Button;
      
      protected var list:List;
      
      protected var _dataProvider:ListCollection;
      
      protected var _ignoreSelectionChanges:Boolean = false;
      
      protected var _selectedIndex:int = -1;
      
      protected var _prompt:String;
      
      protected var _labelField:String = "label";
      
      protected var _labelFunction:Function;
      
      protected var _popUpContentManager:IPopUpContentManager;
      
      protected var _typicalItemWidth:Number = NaN;
      
      protected var _typicalItemHeight:Number = NaN;
      
      protected var _typicalItem:Object = null;
      
      protected var _buttonFactory:Function;
      
      protected var _customButtonName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      protected var _listFactory:Function;
      
      protected var _customListName:String;
      
      protected var _listProperties:PropertyProxy;
      
      protected var _toggleButtonOnOpenAndClose:Boolean = false;
      
      protected var _isOpenListPending:Boolean = false;
      
      protected var _isCloseListPending:Boolean = false;
      
      protected var _buttonHasFocus:Boolean = false;
      
      protected var _buttonTouchPointID:int = -1;
      
      protected var _listIsOpenOnTouchBegan:Boolean = false;
      
      public function PickerList()
      {
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      protected static function defaultListFactory() : List
      {
         return new List();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return PickerList.globalStyleProvider;
      }
      
      public function get dataProvider() : ListCollection
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(param1:ListCollection) : void
      {
         if(this._dataProvider == param1)
         {
            return;
         }
         var _loc3_:int = this.selectedIndex;
         var _loc2_:Object = this.selectedItem;
         this._dataProvider = param1;
         if(!this._dataProvider || this._dataProvider.length == 0)
         {
            this.selectedIndex = -1;
         }
         else
         {
            this.selectedIndex = 0;
         }
         if(this.selectedIndex == _loc3_ && this.selectedItem != _loc2_)
         {
            this.dispatchEventWith("change");
         }
         this.invalidate("data");
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
         this.invalidate("selected");
         this.dispatchEventWith("change");
      }
      
      public function get selectedItem() : Object
      {
         if(!this._dataProvider || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length)
         {
            return null;
         }
         return this._dataProvider.getItemAt(this._selectedIndex);
      }
      
      public function set selectedItem(param1:Object) : void
      {
         if(!this._dataProvider)
         {
            this.selectedIndex = -1;
            return;
         }
         this.selectedIndex = this._dataProvider.getItemIndex(param1);
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      public function set prompt(param1:String) : void
      {
         if(this._prompt == param1)
         {
            return;
         }
         this._prompt = param1;
         this.invalidate("selected");
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(param1:String) : void
      {
         if(this._labelField == param1)
         {
            return;
         }
         this._labelField = param1;
         this.invalidate("data");
      }
      
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(param1:Function) : void
      {
         this._labelFunction = param1;
         this.invalidate("data");
      }
      
      public function get popUpContentManager() : IPopUpContentManager
      {
         return this._popUpContentManager;
      }
      
      public function set popUpContentManager(param1:IPopUpContentManager) : void
      {
         var _loc2_:EventDispatcher = null;
         if(this._popUpContentManager == param1)
         {
            return;
         }
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.removeEventListener("open",popUpContentManager_openHandler);
            _loc2_.removeEventListener("close",popUpContentManager_closeHandler);
         }
         this._popUpContentManager = param1;
         if(this._popUpContentManager is EventDispatcher)
         {
            _loc2_ = EventDispatcher(this._popUpContentManager);
            _loc2_.addEventListener("open",popUpContentManager_openHandler);
            _loc2_.addEventListener("close",popUpContentManager_closeHandler);
         }
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
         this._typicalItemWidth = NaN;
         this._typicalItemHeight = NaN;
         this.invalidate("styles");
      }
      
      public function get buttonFactory() : Function
      {
         return this._buttonFactory;
      }
      
      public function set buttonFactory(param1:Function) : void
      {
         if(this._buttonFactory == param1)
         {
            return;
         }
         this._buttonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customButtonName() : String
      {
         return this._customButtonName;
      }
      
      public function set customButtonName(param1:String) : void
      {
         if(this._customButtonName == param1)
         {
            return;
         }
         this._customButtonName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonProperties() : Object
      {
         if(!this._buttonProperties)
         {
            this._buttonProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._buttonProperties;
      }
      
      public function set buttonProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._buttonProperties == param1)
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
         if(this._buttonProperties)
         {
            this._buttonProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._buttonProperties = PropertyProxy(param1);
         if(this._buttonProperties)
         {
            this._buttonProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get listFactory() : Function
      {
         return this._listFactory;
      }
      
      public function set listFactory(param1:Function) : void
      {
         if(this._listFactory == param1)
         {
            return;
         }
         this._listFactory = param1;
         this.invalidate("listFactory");
      }
      
      public function get customListName() : String
      {
         return this._customListName;
      }
      
      public function set customListName(param1:String) : void
      {
         if(this._customListName == param1)
         {
            return;
         }
         this._customListName = param1;
         this.invalidate("listFactory");
      }
      
      public function get listProperties() : Object
      {
         if(!this._listProperties)
         {
            this._listProperties = new PropertyProxy(childProperties_onChange);
         }
         return this._listProperties;
      }
      
      public function set listProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._listProperties == param1)
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
         if(this._listProperties)
         {
            this._listProperties.removeOnChangeCallback(childProperties_onChange);
         }
         this._listProperties = PropertyProxy(param1);
         if(this._listProperties)
         {
            this._listProperties.addOnChangeCallback(childProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      public function get toggleButtonOnOpenAndClose() : Boolean
      {
         return this._toggleButtonOnOpenAndClose;
      }
      
      public function set toggleButtonOnOpenAndClose(param1:Boolean) : void
      {
         if(this._toggleButtonOnOpenAndClose == param1)
         {
            return;
         }
         this._toggleButtonOnOpenAndClose = param1;
         if(this.button is IToggle)
         {
            if(this._toggleButtonOnOpenAndClose && this._popUpContentManager.isOpen)
            {
               IToggle(this.button).isSelected = true;
            }
            else
            {
               IToggle(this.button).isSelected = false;
            }
         }
      }
      
      public function itemToLabel(param1:Object) : String
      {
         var _loc2_:Object = null;
         if(this._labelFunction != null)
         {
            _loc2_ = this._labelFunction(param1);
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            return _loc2_.toString();
         }
         if(this._labelField != null && param1 && param1.hasOwnProperty(this._labelField))
         {
            _loc2_ = param1[this._labelField];
            if(_loc2_ is String)
            {
               return _loc2_ as String;
            }
            return _loc2_.toString();
         }
         if(param1 is String)
         {
            return param1 as String;
         }
         if(param1)
         {
            return param1.toString();
         }
         return "";
      }
      
      public function openList() : void
      {
         this._isCloseListPending = false;
         if(this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isOpenListPending = true;
            return;
         }
         this._isOpenListPending = false;
         this._popUpContentManager.open(this.list,this);
         this.list.scrollToDisplayIndex(this._selectedIndex);
         this.list.validate();
         if(this._focusManager)
         {
            this._focusManager.focus = this.list;
            this.stage.addEventListener("keyUp",stage_keyUpHandler);
            this.list.addEventListener("focusOut",list_focusOutHandler);
         }
      }
      
      public function closeList() : void
      {
         this._isOpenListPending = false;
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(!this._isValidating && this.isInvalid())
         {
            this._isCloseListPending = true;
            return;
         }
         this._isCloseListPending = false;
         this.list.validate();
         this._popUpContentManager.close();
      }
      
      override public function dispose() : void
      {
         if(this.list)
         {
            this.closeList();
            this.list.dispose();
            this.list = null;
         }
         if(this._popUpContentManager)
         {
            this._popUpContentManager.dispose();
            this._popUpContentManager = null;
         }
         super.dispose();
      }
      
      override public function showFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.showFocus();
      }
      
      override public function hideFocus() : void
      {
         if(!this.button)
         {
            return;
         }
         this.button.hideFocus();
      }
      
      override protected function initialize() : void
      {
         if(!this._popUpContentManager)
         {
            if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
            {
               this.popUpContentManager = new CalloutPopUpContentManager();
            }
            else
            {
               this.popUpContentManager = new VerticalCenteredPopUpContentManager();
            }
         }
      }
      
      override protected function draw() : void
      {
         var _loc8_:Boolean = false;
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc7_:Boolean = this.isInvalid("styles");
         var _loc5_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc6_:Boolean = this.isInvalid("buttonFactory");
         var _loc4_:Boolean = this.isInvalid("listFactory");
         if(_loc6_)
         {
            this.createButton();
         }
         if(_loc4_)
         {
            this.createList();
         }
         if(_loc6_ || _loc7_ || _loc1_)
         {
            if(this.explicitWidth !== this.explicitWidth)
            {
               this.button.width = NaN;
            }
            if(this.explicitHeight !== this.explicitHeight)
            {
               this.button.height = NaN;
            }
         }
         if(_loc6_ || _loc7_)
         {
            this._typicalItemWidth = NaN;
            this._typicalItemHeight = NaN;
            this.refreshButtonProperties();
         }
         if(_loc4_ || _loc7_)
         {
            this.refreshListProperties();
         }
         if(_loc4_ || _loc3_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.dataProvider = this._dataProvider;
            this._ignoreSelectionChanges = _loc8_;
         }
         if(_loc6_ || _loc4_ || _loc5_)
         {
            this.button.isEnabled = this._isEnabled;
            this.list.isEnabled = this._isEnabled;
         }
         if(_loc6_ || _loc3_ || _loc1_)
         {
            this.refreshButtonLabel();
         }
         if(_loc4_ || _loc3_ || _loc1_)
         {
            _loc8_ = this._ignoreSelectionChanges;
            this._ignoreSelectionChanges = true;
            this.list.selectedIndex = this._selectedIndex;
            this._ignoreSelectionChanges = _loc8_;
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc6_ || _loc7_ || _loc2_ || _loc1_)
         {
            this.layout();
         }
         this.handlePendingActions();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc7_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc7_)
         {
            return false;
         }
         if(this._typicalItem)
         {
            if(this._typicalItemWidth !== this._typicalItemWidth || this._typicalItemHeight !== this._typicalItemHeight)
            {
               _loc6_ = this.button.width;
               _loc8_ = this.button.height;
               this.button.width = NaN;
               this.button.height = NaN;
               if(this._typicalItem)
               {
                  this.button.label = this.itemToLabel(this._typicalItem);
               }
               this.button.validate();
               this._typicalItemWidth = this.button.width;
               this._typicalItemHeight = this.button.height;
               this.refreshButtonLabel();
               this.button.width = _loc6_;
               this.button.height = _loc8_;
            }
            _loc4_ = this._typicalItemWidth;
            _loc5_ = this._typicalItemHeight;
         }
         else
         {
            this.button.validate();
            _loc4_ = this.button.width;
            _loc5_ = this.button.height;
         }
         var _loc3_:* = this.explicitWidth;
         var _loc1_:* = this.explicitHeight;
         if(_loc2_)
         {
            if(_loc4_ === _loc4_)
            {
               _loc3_ = _loc4_;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         if(_loc7_)
         {
            if(_loc5_ === _loc5_)
            {
               _loc1_ = _loc5_;
            }
            else
            {
               _loc1_ = 0;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createButton() : void
      {
         if(this.button)
         {
            this.button.removeFromParent(true);
            this.button = null;
         }
         var _loc1_:Function = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
         var _loc2_:String = this._customButtonName != null ? this._customButtonName : this.buttonName;
         this.button = Button(_loc1_());
         if(this.button is ToggleButton)
         {
            ToggleButton(this.button).isToggle = false;
         }
         this.button.styleNameList.add(_loc2_);
         this.button.addEventListener("touch",button_touchHandler);
         this.button.addEventListener("triggered",button_triggeredHandler);
         this.addChild(this.button);
      }
      
      protected function createList() : void
      {
         if(this.list)
         {
            this.list.removeFromParent(false);
            this.list.dispose();
            this.list = null;
         }
         var _loc2_:Function = this._listFactory != null ? this._listFactory : defaultListFactory;
         var _loc1_:String = this._customListName != null ? this._customListName : this.listName;
         this.list = List(_loc2_());
         this.list.focusOwner = this;
         this.list.styleNameList.add(_loc1_);
         this.list.addEventListener("change",list_changeHandler);
         this.list.addEventListener("rendererAdd",list_rendererAddHandler);
         this.list.addEventListener("rendererRemove",list_rendererRemoveHandler);
         this.list.addEventListener("removedFromStage",list_removedFromStageHandler);
      }
      
      protected function refreshButtonLabel() : void
      {
         if(this._selectedIndex >= 0)
         {
            this.button.label = this.itemToLabel(this.selectedItem);
         }
         else
         {
            this.button.label = this._prompt;
         }
      }
      
      protected function refreshButtonProperties() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._buttonProperties)
         {
            _loc2_ = this._buttonProperties[_loc1_];
            this.button[_loc1_] = _loc2_;
         }
      }
      
      protected function refreshListProperties() : void
      {
         var _loc2_:Object = null;
         for(var _loc1_ in this._listProperties)
         {
            _loc2_ = this._listProperties[_loc1_];
            this.list[_loc1_] = _loc2_;
         }
      }
      
      protected function layout() : void
      {
         this.button.width = this.actualWidth;
         this.button.height = this.actualHeight;
         this.button.validate();
      }
      
      protected function handlePendingActions() : void
      {
         if(this._isOpenListPending)
         {
            this.openList();
         }
         if(this._isCloseListPending)
         {
            this.closeList();
         }
      }
      
      override protected function focusInHandler(param1:Event) : void
      {
         super.focusInHandler(param1);
         this._buttonHasFocus = true;
         this.button.dispatchEventWith("focusIn");
      }
      
      override protected function focusOutHandler(param1:Event) : void
      {
         if(this._buttonHasFocus)
         {
            this.button.dispatchEventWith("focusOut");
            this._buttonHasFocus = false;
         }
         super.focusOutHandler(param1);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function button_touchHandler(param1:TouchEvent) : void
      {
         var _loc2_:Touch = null;
         if(this._buttonTouchPointID >= 0)
         {
            _loc2_ = param1.getTouch(this.button,"ended",this._buttonTouchPointID);
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = -1;
            this._listIsOpenOnTouchBegan = false;
         }
         else
         {
            _loc2_ = param1.getTouch(this.button,"began");
            if(!_loc2_)
            {
               return;
            }
            this._buttonTouchPointID = _loc2_.id;
            this._listIsOpenOnTouchBegan = this._popUpContentManager.isOpen;
         }
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(this._focusManager && this._listIsOpenOnTouchBegan)
         {
            return;
         }
         if(this._popUpContentManager.isOpen)
         {
            this.closeList();
            return;
         }
         this.openList();
      }
      
      protected function list_changeHandler(param1:Event) : void
      {
         if(this._ignoreSelectionChanges)
         {
            return;
         }
         this.selectedIndex = this.list.selectedIndex;
      }
      
      protected function list_rendererAddHandler(param1:Event, param2:IListItemRenderer) : void
      {
         param2.addEventListener("triggered",renderer_triggeredHandler);
      }
      
      protected function list_rendererRemoveHandler(param1:Event, param2:IListItemRenderer) : void
      {
         param2.removeEventListener("triggered",renderer_triggeredHandler);
      }
      
      protected function popUpContentManager_openHandler(param1:Event) : void
      {
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = true;
         }
      }
      
      protected function popUpContentManager_closeHandler(param1:Event) : void
      {
         if(this._toggleButtonOnOpenAndClose && this.button is IToggle)
         {
            IToggle(this.button).isSelected = false;
         }
      }
      
      protected function list_removedFromStageHandler(param1:Event) : void
      {
         if(this._focusManager)
         {
            this.list.stage.removeEventListener("keyUp",stage_keyUpHandler);
            this.list.removeEventListener("focusOut",list_focusOutHandler);
         }
      }
      
      protected function list_focusOutHandler(param1:Event) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         this.closeList();
      }
      
      protected function renderer_triggeredHandler(param1:Event) : void
      {
         if(!this._isEnabled)
         {
            return;
         }
         this.closeList();
      }
      
      protected function stage_keyUpHandler(param1:KeyboardEvent) : void
      {
         if(!this._popUpContentManager.isOpen)
         {
            return;
         }
         if(param1.keyCode == 13)
         {
            this.closeList();
         }
      }
   }
}

