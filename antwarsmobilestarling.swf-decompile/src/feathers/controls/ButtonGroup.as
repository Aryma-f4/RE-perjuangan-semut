package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.PropertyProxy;
   import feathers.data.ListCollection;
   import feathers.layout.HorizontalLayout;
   import feathers.layout.LayoutBoundsResult;
   import feathers.layout.VerticalLayout;
   import feathers.layout.ViewPortBounds;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   import starling.events.Event;
   
   public class ButtonGroup extends FeathersControl
   {
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected static const INVALIDATION_FLAG_BUTTON_FACTORY:String = "buttonFactory";
      
      protected static const LABEL_FIELD:String = "label";
      
      protected static const ENABLED_FIELD:String = "isEnabled";
      
      public static const DIRECTION_HORIZONTAL:String = "horizontal";
      
      public static const DIRECTION_VERTICAL:String = "vertical";
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const DEFAULT_CHILD_NAME_BUTTON:String = "feathers-button-group-button";
      
      private static const DEFAULT_BUTTON_FIELDS:Vector.<String> = new <String>["defaultIcon","upIcon","downIcon","hoverIcon","disabledIcon","defaultSelectedIcon","selectedUpIcon","selectedDownIcon","selectedHoverIcon","selectedDisabledIcon","isSelected","isToggle"];
      
      private static const DEFAULT_BUTTON_EVENTS:Vector.<String> = new <String>["triggered","change"];
      
      protected var buttonName:String = "feathers-button-group-button";
      
      protected var firstButtonName:String = "feathers-button-group-button";
      
      protected var lastButtonName:String = "feathers-button-group-button";
      
      protected var activeFirstButton:Button;
      
      protected var inactiveFirstButton:Button;
      
      protected var activeLastButton:Button;
      
      protected var inactiveLastButton:Button;
      
      protected var _layoutItems:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
      
      protected var activeButtons:Vector.<Button> = new Vector.<Button>(0);
      
      protected var inactiveButtons:Vector.<Button> = new Vector.<Button>(0);
      
      protected var _dataProvider:ListCollection;
      
      protected var verticalLayout:VerticalLayout;
      
      protected var horizontalLayout:HorizontalLayout;
      
      protected var _viewPortBounds:ViewPortBounds = new ViewPortBounds();
      
      protected var _layoutResult:LayoutBoundsResult = new LayoutBoundsResult();
      
      protected var _direction:String = "vertical";
      
      protected var _horizontalAlign:String = "justify";
      
      protected var _verticalAlign:String = "justify";
      
      protected var _distributeButtonSizes:Boolean = true;
      
      protected var _gap:Number = 0;
      
      protected var _firstGap:Number = NaN;
      
      protected var _lastGap:Number = NaN;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      protected var _buttonFactory:Function = defaultButtonFactory;
      
      protected var _firstButtonFactory:Function;
      
      protected var _lastButtonFactory:Function;
      
      protected var _buttonInitializer:Function;
      
      protected var _customButtonName:String;
      
      protected var _customFirstButtonName:String;
      
      protected var _customLastButtonName:String;
      
      protected var _buttonProperties:PropertyProxy;
      
      public function ButtonGroup()
      {
         _buttonInitializer = defaultButtonInitializer;
         super();
      }
      
      protected static function defaultButtonFactory() : Button
      {
         return new Button();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ButtonGroup.globalStyleProvider;
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
         if(this._dataProvider)
         {
            this._dataProvider.removeEventListener("change",dataProvider_changeHandler);
         }
         this._dataProvider = param1;
         if(this._dataProvider)
         {
            this._dataProvider.addEventListener("change",dataProvider_changeHandler);
         }
         this.invalidate("data");
      }
      
      public function get direction() : String
      {
         return _direction;
      }
      
      public function set direction(param1:String) : void
      {
         if(this._direction == param1)
         {
            return;
         }
         this._direction = param1;
         this.invalidate("styles");
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
         this.invalidate("styles");
      }
      
      public function get verticalAlign() : String
      {
         return _verticalAlign;
      }
      
      public function set verticalAlign(param1:String) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this.invalidate("styles");
      }
      
      public function get distributeButtonSizes() : Boolean
      {
         return this._distributeButtonSizes;
      }
      
      public function set distributeButtonSizes(param1:Boolean) : void
      {
         if(this._distributeButtonSizes == param1)
         {
            return;
         }
         this._distributeButtonSizes = param1;
         this.invalidate("styles");
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
         this.invalidate("styles");
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
         this.invalidate("styles");
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
      
      public function get firstButtonFactory() : Function
      {
         return this._firstButtonFactory;
      }
      
      public function set firstButtonFactory(param1:Function) : void
      {
         if(this._firstButtonFactory == param1)
         {
            return;
         }
         this._firstButtonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get lastButtonFactory() : Function
      {
         return this._lastButtonFactory;
      }
      
      public function set lastButtonFactory(param1:Function) : void
      {
         if(this._lastButtonFactory == param1)
         {
            return;
         }
         this._lastButtonFactory = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get buttonInitializer() : Function
      {
         return this._buttonInitializer;
      }
      
      public function set buttonInitializer(param1:Function) : void
      {
         if(this._buttonInitializer == param1)
         {
            return;
         }
         this._buttonInitializer = param1;
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
      
      public function get customFirstButtonName() : String
      {
         return this._customFirstButtonName;
      }
      
      public function set customFirstButtonName(param1:String) : void
      {
         if(this._customFirstButtonName == param1)
         {
            return;
         }
         this._customFirstButtonName = param1;
         this.invalidate("buttonFactory");
      }
      
      public function get customLastButtonName() : String
      {
         return this._customLastButtonName;
      }
      
      public function set customLastButtonName(param1:String) : void
      {
         if(this._customLastButtonName == param1)
         {
            return;
         }
         this._customLastButtonName = param1;
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
      
      override public function dispose() : void
      {
         this.dataProvider = null;
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc4_:Boolean = this.isInvalid("buttonFactory");
         var _loc1_:Boolean = this.isInvalid("size");
         if(_loc2_ || _loc3_ || _loc4_)
         {
            this.refreshButtons(_loc4_);
         }
         if(_loc2_ || _loc4_ || _loc5_)
         {
            this.refreshButtonStyles();
         }
         if(_loc2_ || _loc3_ || _loc4_)
         {
            this.commitEnabled();
         }
         if(_loc5_)
         {
            this.refreshLayoutStyles();
         }
         this.layoutButtons();
      }
      
      protected function commitEnabled() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Button = null;
         var _loc2_:int = int(this.activeButtons.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.activeButtons[_loc3_];
            _loc1_.isEnabled &&= this._isEnabled;
            _loc3_++;
         }
      }
      
      protected function refreshButtonStyles() : void
      {
         var _loc3_:Object = null;
         for(var _loc1_ in this._buttonProperties)
         {
            _loc3_ = this._buttonProperties[_loc1_];
            for each(var _loc2_ in this.activeButtons)
            {
               _loc2_[_loc1_] = _loc3_;
            }
         }
      }
      
      protected function refreshLayoutStyles() : void
      {
         if(this._direction == "vertical")
         {
            if(this.horizontalLayout)
            {
               this.horizontalLayout = null;
            }
            if(!this.verticalLayout)
            {
               this.verticalLayout = new VerticalLayout();
               this.verticalLayout.useVirtualLayout = false;
            }
            this.verticalLayout.distributeHeights = this._distributeButtonSizes;
            this.verticalLayout.horizontalAlign = this._horizontalAlign;
            this.verticalLayout.verticalAlign = this._verticalAlign == "justify" ? "top" : this._verticalAlign;
            this.verticalLayout.gap = this._gap;
            this.verticalLayout.firstGap = this._firstGap;
            this.verticalLayout.lastGap = this._lastGap;
            this.verticalLayout.paddingTop = this._paddingTop;
            this.verticalLayout.paddingRight = this._paddingRight;
            this.verticalLayout.paddingBottom = this._paddingBottom;
            this.verticalLayout.paddingLeft = this._paddingLeft;
         }
         else
         {
            if(this.verticalLayout)
            {
               this.verticalLayout = null;
            }
            if(!this.horizontalLayout)
            {
               this.horizontalLayout = new HorizontalLayout();
               this.horizontalLayout.useVirtualLayout = false;
            }
            this.horizontalLayout.distributeWidths = this._distributeButtonSizes;
            this.horizontalLayout.horizontalAlign = this._horizontalAlign == "justify" ? "left" : this._horizontalAlign;
            this.horizontalLayout.verticalAlign = this._verticalAlign;
            this.horizontalLayout.gap = this._gap;
            this.horizontalLayout.firstGap = this._firstGap;
            this.horizontalLayout.lastGap = this._lastGap;
            this.horizontalLayout.paddingTop = this._paddingTop;
            this.horizontalLayout.paddingRight = this._paddingRight;
            this.horizontalLayout.paddingBottom = this._paddingBottom;
            this.horizontalLayout.paddingLeft = this._paddingLeft;
         }
      }
      
      protected function defaultButtonInitializer(param1:Button, param2:Object) : void
      {
         var _loc5_:Boolean = false;
         var _loc4_:Function = null;
         if(param2 is Object)
         {
            if(param2.hasOwnProperty("label"))
            {
               param1.label = param2.label as String;
            }
            else
            {
               param1.label = param2.toString();
            }
            if(param2.hasOwnProperty("isEnabled"))
            {
               param1.isEnabled = param2.isEnabled as Boolean;
            }
            else
            {
               param1.isEnabled = this._isEnabled;
            }
            for each(var _loc3_ in DEFAULT_BUTTON_FIELDS)
            {
               if(param2.hasOwnProperty(_loc3_))
               {
                  param1[_loc3_] = param2[_loc3_];
               }
            }
            for each(_loc3_ in DEFAULT_BUTTON_EVENTS)
            {
               _loc5_ = true;
               if(param2.hasOwnProperty(_loc3_))
               {
                  _loc4_ = param2[_loc3_] as Function;
                  if(_loc4_ == null)
                  {
                     continue;
                  }
                  _loc5_ = false;
                  param1.addEventListener(_loc3_,defaultButtonEventsListener);
               }
               if(_loc5_)
               {
                  param1.removeEventListener(_loc3_,defaultButtonEventsListener);
               }
            }
         }
         else
         {
            param1.label = "";
         }
      }
      
      protected function refreshButtons(param1:Boolean) : void
      {
         var _loc8_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:* = null;
         var _loc6_:Vector.<Button> = this.inactiveButtons;
         this.inactiveButtons = this.activeButtons;
         this.activeButtons = _loc6_;
         this.activeButtons.length = 0;
         this._layoutItems.length = 0;
         _loc6_ = null;
         if(param1)
         {
            this.clearInactiveButtons();
         }
         else
         {
            if(this.activeFirstButton)
            {
               this.inactiveButtons.shift();
            }
            this.inactiveFirstButton = this.activeFirstButton;
            if(this.activeLastButton)
            {
               this.inactiveButtons.pop();
            }
            this.inactiveLastButton = this.activeLastButton;
         }
         this.activeFirstButton = null;
         this.activeLastButton = null;
         var _loc4_:int = 0;
         var _loc7_:int = int(this._dataProvider ? this._dataProvider.length : 0);
         var _loc2_:int = _loc7_ - 1;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc5_ = this._dataProvider.getItemAt(_loc8_);
            if(_loc8_ == 0)
            {
               _loc3_ = this.activeFirstButton = this.createFirstButton(_loc5_);
            }
            else if(_loc8_ == _loc2_)
            {
               _loc3_ = this.activeLastButton = this.createLastButton(_loc5_);
            }
            else
            {
               _loc3_ = this.createButton(_loc5_);
            }
            this.activeButtons[_loc4_] = _loc3_;
            this._layoutItems[_loc4_] = _loc3_;
            _loc4_++;
            _loc8_++;
         }
         this.clearInactiveButtons();
      }
      
      protected function clearInactiveButtons() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Button = null;
         var _loc2_:int = int(this.inactiveButtons.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = this.inactiveButtons.shift();
            this.destroyButton(_loc1_);
            _loc3_++;
         }
         if(this.inactiveFirstButton)
         {
            this.destroyButton(this.inactiveFirstButton);
            this.inactiveFirstButton = null;
         }
         if(this.inactiveLastButton)
         {
            this.destroyButton(this.inactiveLastButton);
            this.inactiveLastButton = null;
         }
      }
      
      protected function createFirstButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveFirstButton)
         {
            _loc3_ = this.inactiveFirstButton;
            this.inactiveFirstButton = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._firstButtonFactory != null ? this._firstButtonFactory : this._buttonFactory;
            _loc3_ = Button(_loc4_());
            if(this._customFirstButtonName)
            {
               _loc3_.styleNameList.add(this._customFirstButtonName);
            }
            else if(this._customButtonName)
            {
               _loc3_.styleNameList.add(this._customButtonName);
            }
            else
            {
               _loc3_.styleNameList.add(this.firstButtonName);
            }
            this.addChild(_loc3_);
         }
         this._buttonInitializer(_loc3_,param1);
         if(_loc2_)
         {
            _loc3_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function createLastButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc4_:Function = null;
         var _loc2_:Boolean = false;
         if(this.inactiveLastButton)
         {
            _loc3_ = this.inactiveLastButton;
            this.inactiveLastButton = null;
         }
         else
         {
            _loc2_ = true;
            _loc4_ = this._lastButtonFactory != null ? this._lastButtonFactory : this._buttonFactory;
            _loc3_ = Button(_loc4_());
            if(this._customLastButtonName)
            {
               _loc3_.styleNameList.add(this._customLastButtonName);
            }
            else if(this._customButtonName)
            {
               _loc3_.styleNameList.add(this._customButtonName);
            }
            else
            {
               _loc3_.styleNameList.add(this.lastButtonName);
            }
            this.addChild(_loc3_);
         }
         this._buttonInitializer(_loc3_,param1);
         if(_loc2_)
         {
            _loc3_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function createButton(param1:Object) : Button
      {
         var _loc3_:Button = null;
         var _loc2_:Boolean = false;
         if(this.inactiveButtons.length == 0)
         {
            _loc2_ = true;
            _loc3_ = this._buttonFactory();
            if(this._customButtonName)
            {
               _loc3_.styleNameList.add(this._customButtonName);
            }
            else
            {
               _loc3_.styleNameList.add(this.buttonName);
            }
            this.addChild(_loc3_);
         }
         else
         {
            _loc3_ = this.inactiveButtons.shift();
         }
         this._buttonInitializer(_loc3_,param1);
         if(_loc2_)
         {
            _loc3_.addEventListener("triggered",button_triggeredHandler);
         }
         return _loc3_;
      }
      
      protected function destroyButton(param1:Button) : void
      {
         param1.removeEventListener("triggered",button_triggeredHandler);
         this.removeChild(param1,true);
      }
      
      protected function layoutButtons() : void
      {
         this._viewPortBounds.x = 0;
         this._viewPortBounds.y = 0;
         this._viewPortBounds.scrollX = 0;
         this._viewPortBounds.scrollY = 0;
         this._viewPortBounds.explicitWidth = this.explicitWidth;
         this._viewPortBounds.explicitHeight = this.explicitHeight;
         this._viewPortBounds.minWidth = this._minWidth;
         this._viewPortBounds.minHeight = this._minHeight;
         this._viewPortBounds.maxWidth = this._maxWidth;
         this._viewPortBounds.maxHeight = this._maxHeight;
         if(this.verticalLayout)
         {
            this.verticalLayout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         else if(this.horizontalLayout)
         {
            this.horizontalLayout.layout(this._layoutItems,this._viewPortBounds,this._layoutResult);
         }
         this.setSizeInternal(this._layoutResult.contentWidth,this._layoutResult.contentHeight,false);
      }
      
      protected function childProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
      
      protected function dataProvider_changeHandler(param1:Event) : void
      {
         this.invalidate("data");
      }
      
      protected function button_triggeredHandler(param1:Event) : void
      {
         if(!this._dataProvider || !this.activeButtons)
         {
            return;
         }
         var _loc3_:Button = Button(param1.currentTarget);
         var _loc2_:int = int(this.activeButtons.indexOf(_loc3_));
         var _loc4_:Object = this._dataProvider.getItemAt(_loc2_);
         this.dispatchEventWith("triggered",false,_loc4_);
      }
      
      protected function defaultButtonEventsListener(param1:Event) : void
      {
         var _loc7_:Function = null;
         var _loc2_:int = 0;
         var _loc5_:Button = Button(param1.currentTarget);
         var _loc4_:int = int(this.activeButtons.indexOf(_loc5_));
         var _loc6_:Object = this._dataProvider.getItemAt(_loc4_);
         var _loc3_:String = param1.type;
         if(_loc6_.hasOwnProperty(_loc3_))
         {
            _loc7_ = _loc6_[_loc3_] as Function;
            if(_loc7_ == null)
            {
               return;
            }
            _loc2_ = _loc7_.length;
            if(_loc2_ == 1)
            {
               _loc7_(param1);
            }
            else if(_loc2_ == 2)
            {
               _loc7_(param1,param1.data);
            }
            else
            {
               _loc7_();
            }
         }
      }
   }
}

