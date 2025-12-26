package feathers.skins
{
   import starling.display.Image;
   import starling.textures.Texture;
   
   public class ImageStateValueSelector extends StateWithToggleValueSelector
   {
      
      protected var _imageProperties:Object;
      
      public function ImageStateValueSelector()
      {
         super();
      }
      
      public function get imageProperties() : Object
      {
         if(!this._imageProperties)
         {
            this._imageProperties = {};
         }
         return this._imageProperties;
      }
      
      public function set imageProperties(param1:Object) : void
      {
         this._imageProperties = param1;
      }
      
      override public function setValueForState(param1:Object, param2:Object, param3:Boolean = false) : void
      {
         if(!(param1 is Texture))
         {
            throw new ArgumentError("Value for state must be a Texture instance.");
         }
         super.setValueForState(param1,param2,param3);
      }
      
      override public function updateValue(param1:Object, param2:Object, param3:Object = null) : Object
      {
         var _loc7_:Image = null;
         var _loc6_:Object = null;
         var _loc5_:Texture = super.updateValue(param1,param2) as Texture;
         if(!_loc5_)
         {
            return null;
         }
         if(param3 is Image)
         {
            _loc7_ = Image(param3);
            _loc7_.texture = _loc5_;
            _loc7_.readjustSize();
         }
         else
         {
            _loc7_ = new Image(_loc5_);
         }
         for(var _loc4_ in this._imageProperties)
         {
            _loc6_ = this._imageProperties[_loc4_];
            _loc7_[_loc4_] = _loc6_;
         }
         return _loc7_;
      }
   }
}

