package feathers.textures
{
   import flash.geom.Rectangle;
   import starling.textures.Texture;
   
   public final class Scale9Textures
   {
      
      private static const ZERO_WIDTH_ERROR:String = "The width of the scale9Grid must be greater than zero.";
      
      private static const ZERO_HEIGHT_ERROR:String = "The height of the scale9Grid must be greater than zero.";
      
      private static const SUM_X_REGIONS_ERROR:String = "The sum of the x and width properties of the scale9Grid must be greater than the width of the texture.";
      
      private static const SUM_Y_REGIONS_ERROR:String = "The sum of the y and height properties of the scale9Grid must be greater than the height of the texture.";
      
      private static const HELPER_RECTANGLE:Rectangle = new Rectangle();
      
      private var _texture:Texture;
      
      private var _scale9Grid:Rectangle;
      
      private var _topLeft:Texture;
      
      private var _topCenter:Texture;
      
      private var _topRight:Texture;
      
      private var _middleLeft:Texture;
      
      private var _middleCenter:Texture;
      
      private var _middleRight:Texture;
      
      private var _bottomLeft:Texture;
      
      private var _bottomCenter:Texture;
      
      private var _bottomRight:Texture;
      
      public function Scale9Textures(param1:Texture, param2:Rectangle)
      {
         super();
         if(param2.width <= 0)
         {
            throw new ArgumentError("The width of the scale9Grid must be greater than zero.");
         }
         if(param2.height <= 0)
         {
            throw new ArgumentError("The height of the scale9Grid must be greater than zero.");
         }
         var _loc4_:Number = param1.scale;
         var _loc3_:Rectangle = param1.frame;
         if(!_loc3_)
         {
            _loc3_ = HELPER_RECTANGLE;
            _loc3_.setTo(0,0,param1.width,param1.height);
         }
         if(param2.x + param2.width > _loc3_.width)
         {
            throw new ArgumentError("The sum of the x and width properties of the scale9Grid must be greater than the width of the texture.");
         }
         if(param2.y + param2.height > _loc3_.height)
         {
            throw new ArgumentError("The sum of the y and height properties of the scale9Grid must be greater than the height of the texture.");
         }
         this._texture = param1;
         this._scale9Grid = param2;
         this.initialize();
      }
      
      public function get texture() : Texture
      {
         return this._texture;
      }
      
      public function get scale9Grid() : Rectangle
      {
         return this._scale9Grid;
      }
      
      public function get topLeft() : Texture
      {
         return this._topLeft;
      }
      
      public function get topCenter() : Texture
      {
         return this._topCenter;
      }
      
      public function get topRight() : Texture
      {
         return this._topRight;
      }
      
      public function get middleLeft() : Texture
      {
         return this._middleLeft;
      }
      
      public function get middleCenter() : Texture
      {
         return this._middleCenter;
      }
      
      public function get middleRight() : Texture
      {
         return this._middleRight;
      }
      
      public function get bottomLeft() : Texture
      {
         return this._bottomLeft;
      }
      
      public function get bottomCenter() : Texture
      {
         return this._bottomCenter;
      }
      
      public function get bottomRight() : Texture
      {
         return this._bottomRight;
      }
      
      private function initialize() : void
      {
         var _loc20_:Rectangle = this._texture.frame;
         if(!_loc20_)
         {
            _loc20_ = HELPER_RECTANGLE;
            _loc20_.setTo(0,0,this._texture.width,this._texture.height);
         }
         var _loc25_:Number = this._scale9Grid.x;
         var _loc16_:Number = this._scale9Grid.width;
         var _loc31_:Number = _loc20_.width - this._scale9Grid.width - this._scale9Grid.x;
         var _loc23_:Number = this._scale9Grid.y;
         var _loc28_:Number = this._scale9Grid.height;
         var _loc11_:Number = _loc20_.height - this._scale9Grid.height - this._scale9Grid.y;
         var _loc7_:Number = _loc25_ + _loc20_.x;
         var _loc18_:Number = _loc23_ + _loc20_.y;
         var _loc26_:Number = _loc31_ - (_loc20_.width - this._texture.width) - _loc20_.x;
         var _loc30_:Number = _loc11_ - (_loc20_.height - this._texture.height) - _loc20_.y;
         var _loc6_:* = _loc7_ != _loc25_;
         var _loc12_:* = _loc18_ != _loc23_;
         var _loc10_:* = _loc26_ != _loc31_;
         var _loc4_:* = _loc30_ != _loc11_;
         var _loc8_:Rectangle = new Rectangle(0,0,_loc7_,_loc18_);
         var _loc22_:Rectangle = _loc6_ || _loc12_ ? new Rectangle(_loc20_.x,_loc20_.y,_loc25_,_loc23_) : null;
         this._topLeft = Texture.fromTexture(this._texture,_loc8_,_loc22_);
         var _loc32_:Rectangle = new Rectangle(_loc7_,0,_loc16_,_loc18_);
         var _loc24_:Rectangle = _loc12_ ? new Rectangle(0,_loc20_.y,_loc16_,_loc23_) : null;
         this._topCenter = Texture.fromTexture(this._texture,_loc32_,_loc24_);
         var _loc5_:Rectangle = new Rectangle(_loc7_ + _loc16_,0,_loc26_,_loc18_);
         var _loc3_:Rectangle = _loc12_ || _loc10_ ? new Rectangle(0,_loc20_.y,_loc31_,_loc23_) : null;
         this._topRight = Texture.fromTexture(this._texture,_loc5_,_loc3_);
         var _loc2_:Rectangle = new Rectangle(0,_loc18_,_loc7_,_loc28_);
         var _loc19_:Rectangle = _loc6_ ? new Rectangle(_loc20_.x,0,_loc25_,_loc28_) : null;
         this._middleLeft = Texture.fromTexture(this._texture,_loc2_,_loc19_);
         var _loc14_:Rectangle = new Rectangle(_loc7_,_loc18_,_loc16_,_loc28_);
         this._middleCenter = Texture.fromTexture(this._texture,_loc14_);
         var _loc13_:Rectangle = new Rectangle(_loc7_ + _loc16_,_loc18_,_loc26_,_loc28_);
         var _loc17_:Rectangle = _loc10_ ? new Rectangle(0,0,_loc31_,_loc28_) : null;
         this._middleRight = Texture.fromTexture(this._texture,_loc13_,_loc17_);
         var _loc15_:Rectangle = new Rectangle(0,_loc18_ + _loc28_,_loc7_,_loc30_);
         var _loc1_:Rectangle = _loc6_ || _loc4_ ? new Rectangle(_loc20_.x,0,_loc25_,_loc11_) : null;
         this._bottomLeft = Texture.fromTexture(this._texture,_loc15_,_loc1_);
         var _loc27_:Rectangle = new Rectangle(_loc7_,_loc18_ + _loc28_,_loc16_,_loc30_);
         var _loc29_:Rectangle = _loc4_ ? new Rectangle(0,0,_loc16_,_loc11_) : null;
         this._bottomCenter = Texture.fromTexture(this._texture,_loc27_,_loc29_);
         var _loc9_:Rectangle = new Rectangle(_loc7_ + _loc16_,_loc18_ + _loc28_,_loc26_,_loc30_);
         var _loc21_:Rectangle = _loc4_ || _loc10_ ? new Rectangle(0,0,_loc31_,_loc11_) : null;
         this._bottomRight = Texture.fromTexture(this._texture,_loc9_,_loc21_);
      }
   }
}

