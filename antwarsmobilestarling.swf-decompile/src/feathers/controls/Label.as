package feathers.controls
{
   import feathers.core.FeathersControl;
   import feathers.core.ITextBaselineControl;
   import feathers.core.ITextRenderer;
   import feathers.core.PropertyProxy;
   import feathers.skins.IStyleProvider;
   import flash.geom.Point;
   import starling.display.DisplayObject;
   
   public class Label extends FeathersControl implements ITextBaselineControl
   {
      
      public static const ALTERNATE_NAME_HEADING:String = "feathers-heading-label";
      
      public static const ALTERNATE_NAME_DETAIL:String = "feathers-detail-label";
      
      public static var globalStyleProvider:IStyleProvider;
      
      private static const HELPER_POINT:Point = new Point();
      
      protected var textRenderer:ITextRenderer;
      
      protected var _text:String = null;
      
      protected var _wordWrap:Boolean = false;
      
      protected var _textRendererFactory:Function;
      
      protected var _textRendererProperties:PropertyProxy;
      
      public function Label()
      {
         super();
         this.isQuickHitAreaEnabled = true;
      }
      
      override protected function get defaultStyleProvider() : IStyleProvider
      {
         return Label.globalStyleProvider;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set text(param1:String) : void
      {
         if(this._text == param1)
         {
            return;
         }
         this._text = param1;
         this.invalidate("data");
      }
      
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(param1:Boolean) : void
      {
         if(this._wordWrap == param1)
         {
            return;
         }
         this._wordWrap = param1;
         this.invalidate("styles");
      }
      
      public function get baseline() : Number
      {
         if(!this.textRenderer)
         {
            return 0;
         }
         return this.textRenderer.y + this.textRenderer.baseline;
      }
      
      public function get textRendererFactory() : Function
      {
         return this._textRendererFactory;
      }
      
      public function set textRendererFactory(param1:Function) : void
      {
         if(this._textRendererFactory == param1)
         {
            return;
         }
         this._textRendererFactory = param1;
         this.invalidate("textRenderer");
      }
      
      public function get textRendererProperties() : Object
      {
         if(!this._textRendererProperties)
         {
            this._textRendererProperties = new PropertyProxy(textRendererProperties_onChange);
         }
         return this._textRendererProperties;
      }
      
      public function set textRendererProperties(param1:Object) : void
      {
         if(this._textRendererProperties == param1)
         {
            return;
         }
         if(param1 && !(param1 is PropertyProxy))
         {
            param1 = PropertyProxy.fromObject(param1);
         }
         if(this._textRendererProperties)
         {
            this._textRendererProperties.removeOnChangeCallback(textRendererProperties_onChange);
         }
         this._textRendererProperties = PropertyProxy(param1);
         if(this._textRendererProperties)
         {
            this._textRendererProperties.addOnChangeCallback(textRendererProperties_onChange);
         }
         this.invalidate("styles");
      }
      
      override protected function draw() : void
      {
         var _loc3_:Boolean = this.isInvalid("data");
         var _loc5_:Boolean = this.isInvalid("styles");
         var _loc2_:Boolean = this.isInvalid("size");
         var _loc4_:Boolean = this.isInvalid("state");
         var _loc1_:Boolean = this.isInvalid("textRenderer");
         if(_loc1_)
         {
            this.createTextRenderer();
         }
         if(_loc1_ || _loc3_ || _loc4_)
         {
            this.refreshTextRendererData();
         }
         if(_loc1_ || _loc4_)
         {
            this.refreshEnabled();
         }
         if(_loc1_ || _loc5_ || _loc4_)
         {
            this.refreshTextRendererStyles();
         }
         _loc2_ = this.autoSizeIfNeeded() || _loc2_;
         this.layout();
      }
      
      protected function autoSizeIfNeeded() : Boolean
      {
         var _loc2_:* = this.explicitWidth !== this.explicitWidth;
         var _loc4_:* = this.explicitHeight !== this.explicitHeight;
         if(!_loc2_ && !_loc4_)
         {
            return false;
         }
         this.textRenderer.minWidth = this._minWidth;
         this.textRenderer.maxWidth = this._maxWidth;
         this.textRenderer.width = this.explicitWidth;
         this.textRenderer.minHeight = this._minHeight;
         this.textRenderer.maxHeight = this._maxHeight;
         this.textRenderer.height = this.explicitHeight;
         this.textRenderer.measureText(HELPER_POINT);
         var _loc3_:Number = this.explicitWidth;
         if(_loc2_)
         {
            if(this._text)
            {
               _loc3_ = HELPER_POINT.x;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         var _loc1_:Number = this.explicitHeight;
         if(_loc4_)
         {
            if(this._text)
            {
               _loc1_ = HELPER_POINT.y;
            }
            else
            {
               _loc1_ = 0;
            }
         }
         return this.setSizeInternal(_loc3_,_loc1_,false);
      }
      
      protected function createTextRenderer() : void
      {
         if(this.textRenderer)
         {
            this.removeChild(DisplayObject(this.textRenderer),true);
            this.textRenderer = null;
         }
         var _loc1_:Function = this._textRendererFactory != null ? this._textRendererFactory : FeathersControl.defaultTextRendererFactory;
         this.textRenderer = ITextRenderer(_loc1_());
         this.addChild(DisplayObject(this.textRenderer));
      }
      
      protected function refreshEnabled() : void
      {
         this.textRenderer.isEnabled = this._isEnabled;
      }
      
      protected function refreshTextRendererData() : void
      {
         this.textRenderer.text = this._text;
         this.textRenderer.visible = this._text && this._text.length > 0;
      }
      
      protected function refreshTextRendererStyles() : void
      {
         var _loc2_:Object = null;
         this.textRenderer.wordWrap = this._wordWrap;
         for(var _loc1_ in this._textRendererProperties)
         {
            _loc2_ = this._textRendererProperties[_loc1_];
            this.textRenderer[_loc1_] = _loc2_;
         }
      }
      
      protected function layout() : void
      {
         this.textRenderer.width = this.actualWidth;
         this.textRenderer.height = this.actualHeight;
         this.textRenderer.validate();
      }
      
      protected function textRendererProperties_onChange(param1:PropertyProxy, param2:String) : void
      {
         this.invalidate("styles");
      }
   }
}

