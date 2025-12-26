package dragonBones.factorys
{
   import dragonBones.Armature;
   import dragonBones.Slot;
   import dragonBones.core.dragonBones_internal;
   import dragonBones.display.StarlingDisplayBridge;
   import dragonBones.textures.ITextureAtlas;
   import dragonBones.textures.StarlingTextureAtlas;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   use namespace dragonBones_internal;
   
   public class StarlingFactory extends BaseFactory
   {
      
      public var generateMipMaps:Boolean;
      
      public var optimizeForRenderToTexture:Boolean;
      
      public var scaleForTexture:Number;
      
      public function StarlingFactory()
      {
         super(this);
         scaleForTexture = 1;
      }
      
      override protected function generateTextureAtlas(param1:Object, param2:Object) : ITextureAtlas
      {
         var _loc6_:Texture = null;
         var _loc4_:BitmapData = null;
         var _loc7_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:MovieClip = null;
         if(param1 is BitmapData)
         {
            _loc4_ = param1 as BitmapData;
            _loc6_ = Texture.fromBitmapData(_loc4_,generateMipMaps,optimizeForRenderToTexture);
         }
         else
         {
            if(!(param1 is MovieClip))
            {
               throw new Error();
            }
            _loc7_ = getNearest2N(param1.width) * scaleForTexture;
            _loc3_ = getNearest2N(param1.height) * scaleForTexture;
            _helpMatirx.a = 1;
            _helpMatirx.b = 0;
            _helpMatirx.c = 0;
            _helpMatirx.d = 1;
            _helpMatirx.scale(scaleForTexture,scaleForTexture);
            _helpMatirx.tx = 0;
            _helpMatirx.ty = 0;
            _loc8_ = param1 as MovieClip;
            _loc8_.gotoAndStop(1);
            _loc4_ = new BitmapData(_loc7_,_loc3_,true,16711935);
            _loc4_.draw(_loc8_,_helpMatirx);
            _loc8_.gotoAndStop(_loc8_.totalFrames);
            _loc6_ = Texture.fromBitmapData(_loc4_,generateMipMaps,optimizeForRenderToTexture,scaleForTexture);
         }
         var _loc5_:StarlingTextureAtlas = new StarlingTextureAtlas(_loc6_,param2,false);
         if(Starling.handleLostContext)
         {
            _loc5_.dragonBones_internal::_bitmapData = _loc4_;
         }
         else
         {
            _loc4_.dispose();
         }
         return _loc5_;
      }
      
      override protected function generateArmature() : Armature
      {
         return new Armature(new Sprite());
      }
      
      override protected function generateSlot() : Slot
      {
         return new Slot(new StarlingDisplayBridge());
      }
      
      override protected function generateDisplay(param1:Object, param2:String, param3:Number, param4:Number) : Object
      {
         var _loc5_:Image = null;
         var _loc6_:SubTexture = (param1 as TextureAtlas).getTexture(param2) as SubTexture;
         if(_loc6_)
         {
            _loc5_ = new Image(_loc6_);
            _loc5_.pivotX = param3;
            _loc5_.pivotY = param4;
            return _loc5_;
         }
         return null;
      }
      
      private function getNearest2N(param1:uint) : uint
      {
         return param1 & param1 - 1 ? 1 << param1.toString(2).length : param1;
      }
   }
}

