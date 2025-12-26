package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.IValidating;
   import feathers.skins.IStyleProvider;
   import flash.errors.IllegalOperationError;
   import flash.geom.Rectangle;
   import flash.utils.getDefinitionByName;
   import starling.display.DisplayObject;
   import starling.events.Event;
   import starling.events.ResizeEvent;
   
   public class ScreenNavigator extends FeathersControl
   {
      
      protected static var SIGNAL_TYPE:Class;
      
      public static const AUTO_SIZE_MODE_STAGE:String = "stage";
      
      public static const AUTO_SIZE_MODE_CONTENT:String = "content";
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var _activeScreenID:String;
      
      protected var _activeScreen:DisplayObject;
      
      protected var _clipContent:Boolean = false;
      
      public var transition:Function = defaultTransition;
      
      protected var _screens:Object = {};
      
      protected var _screenEvents:Object = {};
      
      protected var _transitionIsActive:Boolean = false;
      
      protected var _previousScreenInTransitionID:String;
      
      protected var _previousScreenInTransition:DisplayObject;
      
      protected var _nextScreenID:String = null;
      
      protected var _clearAfterTransition:Boolean = false;
      
      protected var _autoSizeMode:String = "stage";
      
      public function ScreenNavigator()
      {
         super();
         if(!SIGNAL_TYPE)
         {
            try
            {
               SIGNAL_TYPE = Class(getDefinitionByName("org.osflash.signals.ISignal"));
            }
            catch(error:Error)
            {
            }
         }
         this.addEventListener("addedToStage",screenNavigator_addedToStageHandler);
         this.addEventListener("removedFromStage",screenNavigator_removedFromStageHandler);
      }
      
      protected static function defaultTransition(param1:DisplayObject, param2:DisplayObject, param3:Function) : void
      {
         param3();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return ScreenNavigator.globalStyleProvider;
      }
      
      public function get activeScreenID() : String
      {
         return this._activeScreenID;
      }
      
      public function get activeScreen() : DisplayObject
      {
         return this._activeScreen;
      }
      
      public function get clipContent() : Boolean
      {
         return this._clipContent;
      }
      
      public function set clipContent(param1:Boolean) : void
      {
         if(this._clipContent == param1)
         {
            return;
         }
         this._clipContent = param1;
         this.invalidate("styles");
      }
      
      public function get autoSizeMode() : String
      {
         return this._autoSizeMode;
      }
      
      public function set autoSizeMode(param1:String) : void
      {
         if(this._autoSizeMode == param1)
         {
            return;
         }
         this._autoSizeMode = param1;
         if(this._activeScreen)
         {
            if(this._autoSizeMode == "content")
            {
               this._activeScreen.addEventListener("resize",activeScreen_resizeHandler);
            }
            else
            {
               this._activeScreen.removeEventListener("resize",activeScreen_resizeHandler);
            }
         }
         this.invalidate("size");
      }
      
      public function showScreen(param1:String) : DisplayObject
      {
         var _loc2_:IScreen = null;
         var _loc7_:Object = null;
         var _loc9_:Object = null;
         var _loc4_:Function = null;
         if(!this._screens.hasOwnProperty(param1))
         {
            throw new IllegalOperationError("Screen with id \'" + param1 + "\' cannot be shown because it has not been defined.");
         }
         if(this._transitionIsActive)
         {
            this._nextScreenID = param1;
            this._clearAfterTransition = false;
            return null;
         }
         if(this._activeScreenID == param1)
         {
            return this._activeScreen;
         }
         this._previousScreenInTransition = this._activeScreen;
         this._previousScreenInTransitionID = this._activeScreenID;
         if(this._activeScreen)
         {
            this.clearScreenInternal(false);
         }
         this._transitionIsActive = true;
         var _loc6_:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[param1]);
         this._activeScreen = _loc6_.getScreen();
         if(this._activeScreen is IScreen)
         {
            _loc2_ = IScreen(this._activeScreen);
            _loc2_.screenID = param1;
            _loc2_.owner = this;
         }
         this._activeScreenID = param1;
         var _loc5_:Object = _loc6_.events;
         var _loc3_:Object = {};
         for(var _loc8_ in _loc5_)
         {
            _loc7_ = this._activeScreen.hasOwnProperty(_loc8_) ? this._activeScreen[_loc8_] as SIGNAL_TYPE : null;
            _loc9_ = _loc5_[_loc8_];
            if(_loc9_ is Function)
            {
               if(_loc7_)
               {
                  _loc7_.add(_loc9_ as Function);
               }
               else
               {
                  this._activeScreen.addEventListener(_loc8_,_loc9_ as Function);
               }
            }
            else
            {
               if(!(_loc9_ is String))
               {
                  throw new TypeError("Unknown event action defined for screen:",_loc9_.toString());
               }
               if(_loc7_)
               {
                  _loc4_ = this.createScreenSignalListener(_loc9_ as String,_loc7_);
                  _loc7_.add(_loc4_);
               }
               else
               {
                  _loc4_ = this.createScreenEventListener(_loc9_ as String);
                  this._activeScreen.addEventListener(_loc8_,_loc4_);
               }
               _loc3_[_loc8_] = _loc4_;
            }
         }
         this._screenEvents[param1] = _loc3_;
         if(this._autoSizeMode == "content" || !this.stage)
         {
            this._activeScreen.addEventListener("resize",activeScreen_resizeHandler);
         }
         this.addChild(this._activeScreen);
         this.invalidate("selected");
         if(this._validationQueue && !this._validationQueue.isValidating)
         {
            this._validationQueue.advanceTime(0);
         }
         this.dispatchEventWith("transitionStart");
         this.transition(this._previousScreenInTransition,this._activeScreen,transitionComplete);
         this.dispatchEventWith("change");
         return this._activeScreen;
      }
      
      public function clearScreen() : void
      {
         if(this._transitionIsActive)
         {
            this._nextScreenID = null;
            this._clearAfterTransition = true;
            return;
         }
         this.clearScreenInternal(true);
         this.dispatchEventWith("clear");
      }
      
      protected function clearScreenInternal(param1:Boolean) : void
      {
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc3_:Function = null;
         if(!this._activeScreen)
         {
            return;
         }
         var _loc5_:ScreenNavigatorItem = ScreenNavigatorItem(this._screens[this._activeScreenID]);
         var _loc4_:Object = _loc5_.events;
         var _loc2_:Object = this._screenEvents[this._activeScreenID];
         for(var _loc7_ in _loc4_)
         {
            _loc6_ = this._activeScreen.hasOwnProperty(_loc7_) ? this._activeScreen[_loc7_] as SIGNAL_TYPE : null;
            _loc8_ = _loc4_[_loc7_];
            if(_loc8_ is Function)
            {
               if(_loc6_)
               {
                  _loc6_.remove(_loc8_ as Function);
               }
               else
               {
                  this._activeScreen.removeEventListener(_loc7_,_loc8_ as Function);
               }
            }
            else if(_loc8_ is String)
            {
               _loc3_ = _loc2_[_loc7_] as Function;
               if(_loc6_)
               {
                  _loc6_.remove(_loc3_);
               }
               else
               {
                  this._activeScreen.removeEventListener(_loc7_,_loc3_);
               }
            }
         }
         if(param1)
         {
            this._transitionIsActive = true;
            this._previousScreenInTransition = this._activeScreen;
            this._previousScreenInTransitionID = this._activeScreenID;
         }
         this._screenEvents[this._activeScreenID] = null;
         this._activeScreen = null;
         this._activeScreenID = null;
         if(param1)
         {
            this.transition(this._previousScreenInTransition,null,transitionComplete);
         }
         this.invalidate("selected");
      }
      
      public function addScreen(param1:String, param2:ScreenNavigatorItem) : void
      {
         if(this._screens.hasOwnProperty(param1))
         {
            throw new IllegalOperationError("Screen with id \'" + param1 + "\' already defined. Cannot add two screens with the same id.");
         }
         this._screens[param1] = param2;
      }
      
      public function removeScreen(param1:String) : void
      {
         if(!this._screens.hasOwnProperty(param1))
         {
            throw new IllegalOperationError("Screen \'" + param1 + "\' cannot be removed because it has not been added.");
         }
         if(this._activeScreenID == param1)
         {
            this.clearScreen();
         }
         delete this._screens[param1];
      }
      
      public function removeAllScreens() : void
      {
         this.clearScreen();
         for(var _loc1_ in this._screens)
         {
            delete this._screens[_loc1_];
         }
      }
      
      public function hasScreen(param1:String) : Boolean
      {
         return this._screens.hasOwnProperty(param1);
      }
      
      public function getScreen(param1:String) : ScreenNavigatorItem
      {
         if(this._screens.hasOwnProperty(param1))
         {
            return ScreenNavigatorItem(this._screens[param1]);
         }
         return null;
      }
      
      public function getScreenIDs(param1:Vector.<String> = null) : Vector.<String>
      {
         if(!param1)
         {
            param1 = new Vector.<String>(0);
         }
         for(var _loc2_ in this._screens)
         {
            param1.push(_loc2_);
         }
         return param1;
      }
      
      override public function dispose() : void
      {
         this.clearScreenInternal(false);
         super.dispose();
      }
      
      override protected function draw() : void
      {
         var _loc3_:Rectangle = null;
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc1_:Boolean = this.isInvalid("selected");
         var _loc4_:Boolean = this.isInvalid("styles");
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         if(_loc2_ || _loc1_)
         {
            if(this._activeScreen)
            {
               if(this._activeScreen.width != this.actualWidth)
               {
                  this._activeScreen.width = this.actualWidth;
               }
               if(this._activeScreen.height != this.actualHeight)
               {
                  this._activeScreen.height = this.actualHeight;
               }
            }
         }
         if(_loc4_ || _loc2_)
         {
            if(this._clipContent)
            {
               _loc3_ = this.clipRect;
               if(!_loc3_)
               {
                  _loc3_ = new Rectangle();
               }
               _loc3_.width = this.actualWidth;
               _loc3_.height = this.actualHeight;
               this.clipRect = _loc3_;
            }
            else
            {
               this.clipRect = null;
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
         if((this._autoSizeMode == "content" || !this.stage) && this._activeScreen is IValidating)
         {
            IValidating(this._activeScreen).validate();
         }
         var _loc3_:Number = this.explicitWidth;
         if(_loc2_)
         {
            if(this._autoSizeMode == "content" || !this.stage)
            {
               _loc3_ = this._activeScreen ? this._activeScreen.width : 0;
            }
            else
            {
               _loc3_ = this.stage.stageWidth;
            }
         }
         var _loc1_:Number = this.explicitHeight;
         if(_loc4_)
         {
            if(this._autoSizeMode == "content" || !this.stage)
            {
               _loc1_ = this._activeScreen ? this._activeScreen.height : 0;
            }
            else
            {
               _loc1_ = this.stage.stageHeight;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function transitionComplete() : void
      {
         var _loc2_:ScreenNavigatorItem = null;
         var _loc3_:* = false;
         var _loc1_:IScreen = null;
         this._transitionIsActive = false;
         this.dispatchEventWith("transitionComplete");
         if(this._previousScreenInTransition)
         {
            _loc2_ = this._screens[this._previousScreenInTransitionID];
            _loc3_ = !(_loc2_.screen is DisplayObject);
            if(this._previousScreenInTransition is IScreen)
            {
               _loc1_ = IScreen(this._previousScreenInTransition);
               _loc1_.screenID = null;
               _loc1_.owner = null;
            }
            this._previousScreenInTransition.removeEventListener("resize",activeScreen_resizeHandler);
            this.removeChild(this._previousScreenInTransition,_loc3_);
            this._previousScreenInTransition = null;
            this._previousScreenInTransitionID = null;
         }
         this.dispatchEventWith("myClear");
         if(this._clearAfterTransition)
         {
            this.clearScreen();
         }
         else if(this._nextScreenID)
         {
            this.showScreen(this._nextScreenID);
         }
         this._nextScreenID = null;
         this._clearAfterTransition = false;
      }
      
      protected function createScreenEventListener(param1:String) : Function
      {
         var screenID:String = param1;
         var self:ScreenNavigator = this;
         var eventListener:Function = function(param1:Event):void
         {
            self.showScreen(screenID);
         };
         return eventListener;
      }
      
      protected function createScreenSignalListener(param1:String, param2:Object) : Function
      {
         var signalListener:Function;
         var screenID:String = param1;
         var signal:Object = param2;
         var self:ScreenNavigator = this;
         if(signal.valueClasses.length == 1)
         {
            signalListener = function(param1:Object):void
            {
               self.showScreen(screenID);
            };
         }
         else
         {
            signalListener = function(... rest):void
            {
               self.showScreen(screenID);
            };
         }
         return signalListener;
      }
      
      protected function screenNavigator_addedToStageHandler(param1:Event) : void
      {
         this.stage.addEventListener("resize",stage_resizeHandler);
      }
      
      protected function screenNavigator_removedFromStageHandler(param1:Event) : void
      {
         this.stage.removeEventListener("resize",stage_resizeHandler);
      }
      
      protected function activeScreen_resizeHandler(param1:Event) : void
      {
         if(this._isValidating || this._autoSizeMode != "content")
         {
            return;
         }
         this.invalidate("size");
      }
      
      protected function stage_resizeHandler(param1:ResizeEvent) : void
      {
         this.invalidate("size");
      }
   }
}

