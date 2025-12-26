package starling.extensions.pixelmask
{
   import starling.core.RenderSupport;
   import starling.core.Starling;
   import starling.display.BlendMode;
   import starling.display.DisplayObject;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.events.Event;
   import starling.textures.RenderTexture;
   
   public class PixelMaskDisplayObject extends DisplayObjectContainer
   {
      
      private static const MASK_MODE_NORMAL:String = "mask";
      
      private static const MASK_MODE_INVERTED:String = "maskinverted";
      
      private var _mask:DisplayObject;
      
      private var _renderTexture:RenderTexture;
      
      private var _maskRenderTexture:RenderTexture;
      
      private var _image:Image;
      
      private var _maskImage:Image;
      
      private var _superRenderFlag:Boolean = false;
      
      private var _inverted:Boolean = false;
      
      private var _scaleFactor:Number;
      
      public function PixelMaskDisplayObject(param1:Number = -1)
      {
         super();
         _scaleFactor = param1;
         BlendMode.register("mask","zero","sourceAlpha");
         BlendMode.register("maskinverted","zero","oneMinusSourceAlpha");
         Starling.current.stage3D.addEventListener("context3DCreate",onContextCreated,false,0,true);
      }
      
      override public function dispose() : void
      {
         clearRenderTextures();
         Starling.current.stage3D.removeEventListener("context3DCreate",onContextCreated);
         super.dispose();
      }
      
      private function onContextCreated(param1:Object) : void
      {
         refreshRenderTextures();
      }
      
      public function get inverted() : Boolean
      {
         return _inverted;
      }
      
      public function set inverted(param1:Boolean) : void
      {
         _inverted = param1;
         refreshRenderTextures(null);
      }
      
      public function set mask(param1:DisplayObject) : void
      {
         if(_mask)
         {
            _mask = null;
         }
         if(param1)
         {
            _mask = param1;
            trace("test:",_mask.width,_mask.height);
            if(_mask.width == 0 || _mask.height == 0)
            {
               _mask = null;
               return;
            }
            refreshRenderTextures(null);
         }
         else
         {
            clearRenderTextures();
         }
      }
      
      private function clearRenderTextures() : void
      {
         if(_maskRenderTexture)
         {
            _maskRenderTexture.dispose();
         }
         if(_renderTexture)
         {
            _renderTexture.dispose();
         }
         if(_image)
         {
            _image.dispose();
         }
         if(_maskImage)
         {
            _maskImage.dispose();
         }
      }
      
      private function refreshRenderTextures(param1:Event = null) : void
      {
         if(_mask)
         {
            clearRenderTextures();
            _maskRenderTexture = new RenderTexture(_mask.width,_mask.height,false,_scaleFactor);
            _renderTexture = new RenderTexture(_mask.width,_mask.height,false,_scaleFactor);
            _image = new Image(_renderTexture);
            _maskImage = new Image(_maskRenderTexture);
            if(_inverted)
            {
               _maskImage.blendMode = "maskinverted";
            }
            else
            {
               _maskImage.blendMode = "mask";
            }
         }
      }
      
      override public function render(param1:RenderSupport, param2:Number) : void
      {
         if(_superRenderFlag || !_mask)
         {
            super.render(param1,param2);
         }
         else if(_mask)
         {
            _superRenderFlag = true;
            _maskRenderTexture.draw(_mask);
            _renderTexture.drawBundled(drawRenderTextures);
            _image.render(param1,param2);
         }
         _superRenderFlag = false;
      }
      
      private function drawRenderTextures() : void
      {
         var _loc4_:Number = scaleX;
         var _loc2_:Number = scaleY;
         var _loc3_:Number = x;
         var _loc1_:Number = y;
         x = y = 0;
         scaleX = scaleY = 1;
         _renderTexture.draw(this);
         scaleX = _loc4_;
         scaleY = _loc2_;
         x = _loc3_;
         y = _loc1_;
         _renderTexture.draw(_maskImage);
      }
   }
}

