package
{
   import starling.extensions.PDParticleSystem;
   import starling.textures.Texture;
   
   public class ParticleAssets
   {
      
      private static var _bulletParticles:Vector.<PDParticleSystem>;
      
      public static var ParticleQXML:Class = particle_3_pex$c8f406e1ee23779680874bf838fc56531357756650;
      
      public static var ParticleTexture:Class = texture_png$c2248b8727d7992bc03204b980c279631641300840;
      
      public function ParticleAssets()
      {
         super();
      }
      
      private static function build() : void
      {
         var _loc2_:XML = null;
         var _loc1_:Texture = null;
         if(!_bulletParticles)
         {
            _loc2_ = XML(new ParticleQXML());
            _loc1_ = Texture.fromBitmap(new ParticleTexture());
            _bulletParticles = new <PDParticleSystem>[new PDParticleSystem(_loc2_,_loc1_),new PDParticleSystem(_loc2_,_loc1_),new PDParticleSystem(_loc2_,_loc1_),new PDParticleSystem(_loc2_,_loc1_)];
         }
      }
      
      public static function checkOut() : PDParticleSystem
      {
         build();
         return _bulletParticles.pop();
      }
      
      public static function checkIn(param1:PDParticleSystem) : void
      {
         _bulletParticles.push(param1);
         trace("_bulletParticles:",_bulletParticles.length);
      }
   }
}

