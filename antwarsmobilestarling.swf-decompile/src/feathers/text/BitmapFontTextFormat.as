package feathers.text
{
   import starling.text.BitmapFont;
   import starling.text.TextField;
   
   public class BitmapFontTextFormat
   {
      
      public var font:BitmapFont;
      
      public var color:uint;
      
      public var size:Number;
      
      public var letterSpacing:Number = 0;
      
      public var align:String = "left";
      
      public var isKerningEnabled:Boolean = true;
      
      public function BitmapFontTextFormat(param1:Object, param2:Number = NaN, param3:uint = 16777215, param4:String = "left")
      {
         super();
         if(param1 is String)
         {
            param1 = TextField.getBitmapFont(param1 as String);
         }
         if(!(param1 is BitmapFont))
         {
            throw new ArgumentError("BitmapFontTextFormat font must be a BitmapFont instance or a String representing the name of a registered bitmap font.");
         }
         this.font = BitmapFont(param1);
         this.size = param2;
         this.color = param3;
         this.align = param4;
      }
      
      public function get fontName() : String
      {
         return this.font ? this.font.name : null;
      }
   }
}

