package dragonBones.display
{
   import dragonBones.objects.DBTransform;
   import flash.geom.Matrix;
   import starling.display.Image;
   import starling.display.Quad;
   import starling.textures.Texture;
   
   public class StarlingDisplayBridge implements IDisplayBridge
   {
      
      private var _imageBackup:Image;
      
      private var _textureBackup:Texture;
      
      private var _pivotXBackup:Number;
      
      private var _pivotYBackup:Number;
      
      private var _display:Object;
      
      public function StarlingDisplayBridge()
      {
         super();
      }
      
      public function get display() : Object
      {
         return _display;
      }
      
      public function set display(param1:Object) : void
      {
         var _loc5_:Image = null;
         var _loc2_:Image = null;
         var _loc4_:* = undefined;
         var _loc3_:int = 0;
         if(_display is Image && param1 is Image)
         {
            _loc5_ = _display as Image;
            _loc2_ = param1 as Image;
            if(_loc5_.texture == _loc2_.texture)
            {
               if(_loc5_ == _imageBackup)
               {
                  _loc5_.texture = _textureBackup;
                  _loc5_.pivotX = _pivotXBackup;
                  _loc5_.pivotY = _pivotYBackup;
                  _loc5_.readjustSize();
               }
               return;
            }
            _loc5_.texture = _loc2_.texture;
            _loc5_.pivotX = _loc2_.pivotX;
            _loc5_.pivotY = _loc2_.pivotY;
            _loc5_.readjustSize();
            return;
         }
         if(_display == param1)
         {
            return;
         }
         if(_display)
         {
            _loc4_ = _display.parent;
            if(_loc4_)
            {
               _loc3_ = int(_display.parent.getChildIndex(_display));
            }
            removeDisplay();
         }
         else if(param1 is Image && !_imageBackup)
         {
            _imageBackup = param1 as Image;
            _textureBackup = _imageBackup.texture;
            _pivotXBackup = _imageBackup.pivotX;
            _pivotYBackup = _imageBackup.pivotY;
         }
         _display = param1;
         addDisplay(_loc4_,_loc3_);
      }
      
      public function get visible() : Boolean
      {
         return _display ? _display.visible : false;
      }
      
      public function set visible(param1:Boolean) : void
      {
         if(_display)
         {
            _display.visible = param1;
         }
      }
      
      public function dispose() : void
      {
         _display = null;
         _imageBackup = null;
         _textureBackup = null;
      }
      
      public function updateTransform(param1:Matrix, param2:DBTransform) : void
      {
         var _loc3_:Number = Number(_display.pivotX);
         var _loc4_:Number = Number(_display.pivotY);
         param1.tx -= param1.a * _loc3_ + param1.c * _loc4_;
         param1.ty -= param1.b * _loc3_ + param1.d * _loc4_;
         _display.transformationMatrix.copyFrom(param1);
      }
      
      public function updateColor(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         _display.alpha = param5;
         if(_display is Quad)
         {
            (_display as Quad).color = (uint(param6 * 255) << 16) + (uint(param7 * 255) << 8) + uint(param8 * 255);
         }
      }
      
      public function addDisplay(param1:Object, param2:int = -1) : void
      {
         if(param1 && _display)
         {
            if(param2 < 0)
            {
               param1.addChild(_display);
            }
            else
            {
               param1.addChildAt(_display,Math.min(param2,param1.numChildren));
            }
         }
      }
      
      public function removeDisplay() : void
      {
         if(_display && _display.parent)
         {
            _display.parent.removeChild(_display);
         }
      }
   }
}

