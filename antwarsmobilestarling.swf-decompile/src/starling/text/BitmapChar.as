package starling.text
{
   import starling.textures.Texture;
   
   public class BitmapChar
   {
      public var id:int;
      public var texture:Texture;
      public var xOffset:Number;
      public var yOffset:Number;
      public var xAdvance:Number;
      public var width:Number;
      public var height:Number;

      public function BitmapChar(id:int, texture:Texture, xOffset:Number, yOffset:Number, xAdvance:Number)
      {
         this.id = id;
         this.texture = texture;
         this.xOffset = xOffset;
         this.yOffset = yOffset;
         this.xAdvance = xAdvance;
         this.width = texture.width;
         this.height = texture.height;
      }

      public function addKerning(charID:int, amount:Number):void {}
      public function getKerning(charID:int):Number { return 0; }
      public function createImage():* { return null; }
   }
}
