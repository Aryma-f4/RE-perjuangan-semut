package dragonBones.textures
{
   import dragonBones.core.dragonBones_internal;
   import dragonBones.objects.DataParser;
   import flash.display.BitmapData;
   import starling.textures.SubTexture;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   
   use namespace dragonBones_internal;
   
   public class StarlingTextureAtlas extends TextureAtlas implements ITextureAtlas
   {
      
      dragonBones_internal var _bitmapData:BitmapData;
      
      protected var _subTextureDic:Object;
      
      protected var _isDifferentXML:Boolean;
      
      protected var _scale:Number;
      
      protected var _name:String;
      
      public function StarlingTextureAtlas(param1:Texture, param2:Object, param3:Boolean = false)
      {
         super(param1,null);
         if(param1)
         {
            _scale = param1.scale;
            _isDifferentXML = param3;
         }
         _subTextureDic = {};
         parseData(param2);
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for each(var _loc1_ in _subTextureDic)
         {
            _loc1_.dispose();
         }
         _subTextureDic = null;
         if(dragonBones_internal::_bitmapData)
         {
            dragonBones_internal::_bitmapData.dispose();
         }
         dragonBones_internal::_bitmapData = null;
      }
      
      override public function getTexture(param1:String) : Texture
      {
         var _loc2_:Texture = _subTextureDic[param1];
         if(!_loc2_)
         {
            _loc2_ = super.getTexture(param1);
            if(_loc2_)
            {
               _subTextureDic[param1] = _loc2_;
            }
         }
         return _loc2_;
      }
      
      protected function parseData(param1:Object) : void
      {
         var _loc3_:Object = DataParser.parseTextureAtlas(param1,_isDifferentXML ? _scale : 1);
         _name = _loc3_.__name;
         delete _loc3_.__name;
         for(var _loc2_ in _loc3_)
         {
            this.addRegion(_loc2_,_loc3_[_loc2_],null);
         }
      }
   }
}

