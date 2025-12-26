package feathers.controls.renderers
{
   import feathers.controls.GroupedList;
   import feathers.controls.ImageLoader;
   import feathers.core.FeathersControl;
   import feathers.core.IFeathersControl;
   import feathers.core.ITextRenderer;
   import feathers.core.IValidating;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import starling.display.DisplayObject;
   
   public class DefaultGroupedListHeaderOrFooterRenderer extends FeathersControl implements IGroupedListHeaderOrFooterRenderer
   {
      
      public static const HORIZONTAL_ALIGN_LEFT:String = "left";
      
      public static const HORIZONTAL_ALIGN_CENTER:String = "center";
      
      public static const HORIZONTAL_ALIGN_RIGHT:String = "right";
      
      public static const HORIZONTAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const VERTICAL_ALIGN_TOP:String = "top";
      
      public static const VERTICAL_ALIGN_MIDDLE:String = "middle";
      
      public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
      
      public static const VERTICAL_ALIGN_JUSTIFY:String = "justify";
      
      public static const DEFAULT_CHILD_NAME_CONTENT_LABEL:String = "feathers-header-footer-renderer-content-label";
      
      public static var globalStyleProvider:IStyleProvider;
      
      protected var contentLabelName:String = "feathers-header-footer-renderer-content-label";
      
      protected var contentImage:ImageLoader;
      
      protected var contentLabel:ITextRenderer;
      
      protected var content:DisplayObject;
      
      protected var _data:Object;
      
      protected var _groupIndex:int = -1;
      
      protected var _layoutIndex:int = -1;
      
      protected var _owner:GroupedList;
      
      protected var _horizontalAlign:String = "left";
      
      protected var _verticalAlign:String = "middle";
      
      protected var _contentField:String = "content";
      
      protected var _contentFunction:Function;
      
      protected var _contentSourceField:String = "source";
      
      protected var _contentSourceFunction:Function;
      
      protected var _contentLabelField:String = "label";
      
      protected var _contentLabelFunction:Function;
      
      protected var _contentLoaderFactory:Function = defaultImageLoaderFactory;
      
      protected var _contentLabelFactory:Function;
      
      protected var _contentLabelProperties:PropertyProxy;
      
      protected var originalBackgroundWidth:Number = NaN;
      
      protected var originalBackgroundHeight:Number = NaN;
      
      protected var currentBackgroundSkin:DisplayObject;
      
      protected var _backgroundSkin:DisplayObject;
      
      protected var _backgroundDisabledSkin:DisplayObject;
      
      protected var _paddingTop:Number = 0;
      
      protected var _paddingRight:Number = 0;
      
      protected var _paddingBottom:Number = 0;
      
      protected var _paddingLeft:Number = 0;
      
      public function DefaultGroupedListHeaderOrFooterRenderer()
      {
         super();
      }
      
      protected static function defaultImageLoaderFactory() : ImageLoader
      {
         return new ImageLoader();
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return DefaultGroupedListHeaderOrFooterRenderer.globalStyleProvider;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         if(this._data == param1)
         {
            return;
         }
         this._data = param1;
         this.invalidate("data");
      }
      
      public function get groupIndex() : int
      {
         return this._groupIndex;
      }
      
      public function set groupIndex(param1:int) : void
      {
         this._groupIndex = param1;
      }
      
      public function get layoutIndex() : int
      {
         return this._layoutIndex;
      }
      
      public function set layoutIndex(param1:int) : void
      {
         this._layoutIndex = param1;
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
         this._owner = param1;
         this.invalidate("data");
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
      
      public function get contentField() : String
      {
         return this._contentField;
      }
      
      public function set contentField(param1:String) : void
      {
         if(this._contentField == param1)
         {
            return;
         }
         this._contentField = param1;
         this.invalidate("data");
      }
      
      public function get contentFunction() : Function
      {
         return this._contentFunction;
      }
      
      public function set contentFunction(param1:Function) : void
      {
         if(this._contentFunction == param1)
         {
            return;
         }
         this._contentFunction = param1;
         this.invalidate("data");
      }
      
      public function get contentSourceField() : String
      {
         return this._contentSourceField;
      }
      
      public function set contentSourceField(param1:String) : void
      {
         if(this._contentSourceField == param1)
         {
            return;
         }
         this._contentSourceField = param1;
         this.invalidate("data");
      }
      
      public function get contentSourceFunction() : Function
      {
         return this._contentSourceFunction;
      }
      
      public function set contentSourceFunction(param1:Function) : void
      {
         if(this.contentSourceFunction == param1)
         {
            return;
         }
         this._contentSourceFunction = param1;
         this.invalidate("data");
      }
      
      public function get contentLabelField() : String
      {
         return this._contentLabelField;
      }
      
      public function set contentLabelField(param1:String) : void
      {
         if(this._contentLabelField == param1)
         {
            return;
         }
         this._contentLabelField = param1;
         this.invalidate("data");
      }
      
      public function get contentLabelFunction() : Function
      {
         return this._contentLabelFunction;
      }
      
      public function set contentLabelFunction(param1:Function) : void
      {
         if(this._contentLabelFunction == param1)
         {
            return;
         }
         this._contentLabelFunction = param1;
         this.invalidate("data");
      }
      
      public function get contentLoaderFactory() : Function
      {
         return this._contentLoaderFactory;
      }
      
      public function set contentLoaderFactory(param1:Function) : void
      {
         if(this._contentLoaderFactory == param1)
         {
            return;
         }
         this._contentLoaderFactory = param1;
         this.invalidate("styles");
      }
      
      public function get contentLabelFactory() : Function
      {
         return this._contentLabelFactory;
      }
      
      public function set contentLabelFactory(param1:Function) : void
      {
         if(this._contentLabelFactory == param1)
         {
            return;
         }
         this._contentLabelFactory = param1;
         this.invalidate("styles");
      }
      
      public function get contentLabelProperties() : Object
      {
         if(!this._contentLabelProperties)
         {
            this._contentLabelProperties = new PropertyProxy(contentLabelProperties_onChange);
         }
         return this._contentLabelProperties;
      }
      
      public function set contentLabelProperties(param1:Object) : void
      {
         var _loc3_:PropertyProxy = null;
         if(this._contentLabelProperties == param1)
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
         if(this._contentLabelProperties)
         {
            this._contentLabelProperties.removeOnChangeCallback(contentLabelProperties_onChange);
         }
         this._contentLabelProperties = PropertyProxy(param1);
         if(this._contentLabelProperties)
         {
            this._contentLabelProperties.addOnChangeCallback(contentLabelProperties_onChange);
         }
         this.invalidate("styles");
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
      
      override public function dispose() : void
      {
         if(this.content)
         {
            this.content.removeFromParent();
         }
         if(this.contentImage)
         {
            this.contentImage.dispose();
            this.contentImage = null;
         }
         if(this.contentLabel)
         {
            DisplayObject(this.contentLabel).dispose();
            this.contentLabel = null;
         }
         super.dispose();
      }
      
      protected function itemToContent(param1:Object) : DisplayObject
      {
         var _loc3_:Object = null;
         var _loc2_:Object = null;
         if(this._contentSourceFunction != null)
         {
            _loc3_ = this._contentSourceFunction(param1);
            this.refreshContentSource(_loc3_);
            return this.contentImage;
         }
         if(this._contentSourceField != null && param1 && param1.hasOwnProperty(this._contentSourceField))
         {
            _loc3_ = param1[this._contentSourceField];
            this.refreshContentSource(_loc3_);
            return this.contentImage;
         }
         if(this._contentLabelFunction != null)
         {
            _loc2_ = this._contentLabelFunction(param1);
            if(_loc2_ is String)
            {
               this.refreshContentLabel(_loc2_ as String);
            }
            else
            {
               this.refreshContentLabel(_loc2_.toString());
            }
            return DisplayObject(this.contentLabel);
         }
         if(this._contentLabelField != null && param1 && param1.hasOwnProperty(this._contentLabelField))
         {
            _loc2_ = param1[this._contentLabelField];
            if(_loc2_ is String)
            {
               this.refreshContentLabel(_loc2_ as String);
            }
            else
            {
               this.refreshContentLabel(_loc2_.toString());
            }
            return DisplayObject(this.contentLabel);
         }
         if(this._contentFunction != null)
         {
            return this._contentFunction(param1) as DisplayObject;
         }
         if(this._contentField != null && param1 && param1.hasOwnProperty(this._contentField))
         {
            return param1[this._contentField] as DisplayObject;
         }
         if(param1 is String)
         {
            this.refreshContentLabel(param1 as String);
            return DisplayObject(this.contentLabel);
         }
         if(param1)
         {
            this.refreshContentLabel(param1.toString());
            return DisplayObject(this.contentLabel);
         }
         return null;
      }
      
      override protected function draw() : void
      {
         var _loc2_:Boolean = this.isInvalid("data");
         var _loc4_:Boolean = this.isInvalid("styles");
         var _loc3_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("size");
         if(_loc4_ || _loc3_)
         {
            this.refreshBackgroundSkin();
         }
         if(_loc2_)
         {
            this.commitData();
         }
         if(_loc2_ || _loc4_)
         {
            this.refreshContentLabelStyles();
         }
         if(_loc2_ || _loc3_)
         {
            this.refreshEnabled();
         }
         _loc1_ = this.autoSizeIfNeeded() || _loc1_;
         if(_loc2_ || _loc4_ || _loc1_)
         {
            this.layout();
         }
         if(_loc1_ || _loc4_ || _loc3_)
         {
            if(this.currentBackgroundSkin)
            {
               this.currentBackgroundSkin.width = this.actualWidth;
               this.currentBackgroundSkin.height = this.actualHeight;
            }
         }
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc4_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         if(!this.content)
         {
            return this.setSizeInternal(0,0,false);
         }
         if(this.contentLabel)
         {
            _loc5_ = this.explicitWidth;
            if(_loc2_)
            {
               _loc5_ = this._maxWidth;
            }
            this.contentLabel.maxWidth = _loc5_ - this._paddingLeft - this._paddingRight;
         }
         if(this._horizontalAlign == "justify")
         {
            this.content.width = this.explicitWidth - this._paddingLeft - this._paddingRight;
         }
         if(this._verticalAlign == "justify")
         {
            this.content.height = this.explicitHeight - this._paddingTop - this._paddingBottom;
         }
         if(this.content is IValidating)
         {
            IValidating(this.content).validate();
         }
         var _loc3_:Number = this.explicitWidth;
         var _loc1_:Number = this.explicitHeight;
         if(_loc2_)
         {
            _loc3_ = this.content.width + this._paddingLeft + this._paddingRight;
            if(this.originalBackgroundWidth === this.originalBackgroundWidth && this.originalBackgroundWidth > _loc3_)
            {
               _loc3_ = this.originalBackgroundWidth;
            }
         }
         if(_loc4_)
         {
            _loc1_ = this.content.height + this._paddingTop + this._paddingBottom;
            if(this.originalBackgroundHeight === this.originalBackgroundHeight && this.originalBackgroundHeight > _loc1_)
            {
               _loc1_ = this.originalBackgroundHeight;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function refreshBackgroundSkin() : void
      {
         this.currentBackgroundSkin = this._backgroundSkin;
         if(!this._isEnabled && this._backgroundDisabledSkin)
         {
            if(this._backgroundSkin)
            {
               this._backgroundSkin.visible = false;
            }
            this.currentBackgroundSkin = this._backgroundDisabledSkin;
         }
         else if(this._backgroundDisabledSkin)
         {
            this._backgroundDisabledSkin.visible = false;
         }
         if(this.currentBackgroundSkin)
         {
            if(this.originalBackgroundWidth !== this.originalBackgroundWidth)
            {
               this.originalBackgroundWidth = this.currentBackgroundSkin.width;
            }
            if(this.originalBackgroundHeight !== this.originalBackgroundHeight)
            {
               this.originalBackgroundHeight = this.currentBackgroundSkin.height;
            }
            this.currentBackgroundSkin.visible = true;
         }
      }
      
      protected function commitData() : void
      {
         var _loc1_:DisplayObject = null;
         if(this._owner)
         {
            _loc1_ = this.itemToContent(this._data);
            if(_loc1_ != this.content)
            {
               if(this.content)
               {
                  this.content.removeFromParent();
               }
               this.content = _loc1_;
               if(this.content)
               {
                  this.addChild(this.content);
               }
            }
         }
         else if(this.content)
         {
            this.content.removeFromParent();
            this.content = null;
         }
      }
      
      protected function refreshContentSource(param1:Object) : void
      {
         if(!this.contentImage)
         {
            this.contentImage = this._contentLoaderFactory();
         }
         this.contentImage.source = param1;
      }
      
      protected function refreshContentLabel(param1:String) : void
      {
         var _loc2_:Function = null;
         if(param1 !== null)
         {
            if(!this.contentLabel)
            {
               _loc2_ = this._contentLabelFactory != null ? this._contentLabelFactory : FeathersControl.defaultTextRendererFactory;
               this.contentLabel = ITextRenderer(_loc2_());
               FeathersControl(this.contentLabel).styleNameList.add(this.contentLabelName);
            }
            this.contentLabel.text = param1;
         }
         else if(this.contentLabel)
         {
            DisplayObject(this.contentLabel).removeFromParent(true);
            this.contentLabel = null;
         }
      }
      
      protected function refreshEnabled() : void
      {
         if(this.content is IFeathersControl)
         {
            IFeathersControl(this.content).isEnabled = this._isEnabled;
         }
      }
      
      protected function refreshContentLabelStyles() : void
      {
         var _loc2_:Object = null;
         if(!this.contentLabel)
         {
            return;
         }
         for(var _loc1_ in this._contentLabelProperties)
         {
            _loc2_ = this._contentLabelProperties[_loc1_];
            this.contentLabel[_loc1_] = _loc2_;
         }
      }
      
      protected function layout() : void
      {
         if(!this.content)
         {
            return;
         }
         if(this.contentLabel)
         {
            this.contentLabel.maxWidth = this.actualWidth - this._paddingLeft - this._paddingRight;
         }
         switch(this._horizontalAlign)
         {
            case "center":
               this.content.x = this._paddingLeft + (this.actualWidth - this._paddingLeft - this._paddingRight - this.content.width) / 2;
               break;
            case "right":
               this.content.x = this.actualWidth - this._paddingRight - this.content.width;
               break;
            case "justify":
               this.content.x = this._paddingLeft;
               this.content.width = this.actualWidth - this._paddingLeft - this._paddingRight;
               break;
            default:
               this.content.x = this._paddingLeft;
         }
         switch(this._verticalAlign)
         {
            case "top":
               this.content.y = this._paddingTop;
               break;
            case "bottom":
               this.content.y = this.actualHeight - this._paddingBottom - this.content.height;
               break;
            case "justify":
               this.content.y = this._paddingTop;
               this.content.height = this.actualHeight - this._paddingTop - this._paddingBottom;
               break;
            default:
               this.content.y = this._paddingTop + (this.actualHeight - this._paddingTop - this._paddingBottom - this.content.height) / 2;
         }
      }
      
      protected function contentLabelProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
   }
}

