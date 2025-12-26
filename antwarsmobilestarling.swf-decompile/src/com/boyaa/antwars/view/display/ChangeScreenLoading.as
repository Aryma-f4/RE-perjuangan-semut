package com.boyaa.antwars.view.display
{
   import com.boyaa.antwars.helper.MathHelper;
   import com.boyaa.antwars.lang.LangManager;
   import flash.filters.GlowFilter;
   import starling.core.Starling;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class ChangeScreenLoading extends Sprite
   {
      
      private static var _isShow:Boolean = false;
      
      private var _bgImage:Image;
      
      private var _loadingText:Image;
      
      private var _middleImage:Image;
      
      private var _vertexMovie:MovieClip;
      
      private var _tipText:TextField;
      
      private var _ratioText:TextField;
      
      public function ChangeScreenLoading()
      {
         super();
         init();
      }
      
      public static function get isShow() : Boolean
      {
         return _isShow;
      }
      
      public static function set isShow(param1:Boolean) : void
      {
         _isShow = param1;
      }
      
      private function init() : void
      {
         _bgImage = new Image(Assets.sAsset.getTexture("yfn2"));
         _bgImage.width = Assets.width;
         _bgImage.height = Assets.height;
         addChild(_bgImage);
         addLoadingText();
         addMiddlePic();
         addVextexMovie();
      }
      
      private function addVextexMovie() : void
      {
         var _loc1_:Vector.<Texture> = Assets.sAsset.getTextures("po_");
         _vertexMovie = new MovieClip(_loc1_,1);
         _vertexMovie.setFrameDuration(2,2);
         Starling.juggler.add(_vertexMovie);
         _vertexMovie.x = _loadingText.x + _loadingText.width;
         _vertexMovie.y = _loadingText.y + _loadingText.height / 2 - _vertexMovie.height / 2;
         addChild(_vertexMovie);
         _ratioText = new TextField(200,40,"0%","Verdana",24,16777215,false);
         _ratioText.autoScale = true;
         _ratioText.nativeFilters = [new GlowFilter(0,1,4,4,8)];
         _ratioText.x = _vertexMovie.x + 50;
         _ratioText.y = _vertexMovie.y - 10;
         addChild(_ratioText);
      }
      
      private function addLoadingText() : void
      {
         _loadingText = new Image(Assets.sAsset.getTexture("loading"));
         _loadingText.x = _bgImage.width * 0.4;
         _loadingText.y = _bgImage.height * 0.75;
         addChild(_loadingText);
         _tipText = new TextField(Assets.width,30,"","Verdana",24,16777215,true);
         _tipText.nativeFilters = [new GlowFilter(4660230,1,6,6,10)];
         _tipText.hAlign = "center";
         _tipText.vAlign = "center";
         _tipText.x = 0;
         _tipText.y = _loadingText.y + 50;
         var _loc2_:Array = LangManager.ta("loadingTips");
         var _loc1_:int = MathHelper.randomWithinRange(0,_loc2_.length - 1);
         _tipText.text = _loc2_[_loc1_];
         _tipText.autoScale = true;
         addChild(_tipText);
      }
      
      private function addMiddlePic() : void
      {
         var _loc2_:Vector.<Texture> = Assets.sAsset.getTextures("pic_");
         var _loc1_:int = int(_loc2_.length);
         _loc1_ = Math.floor(Math.random() * _loc1_);
         _middleImage = new Image(_loc2_[_loc1_]);
         _middleImage.pivotX = _middleImage.width >> 1;
         _middleImage.pivotY = _middleImage.height >> 1;
         _middleImage.x = _bgImage.width >> 1;
         _middleImage.y = _bgImage.height >> 1;
         addChild(_middleImage);
      }
      
      public function setRatio(param1:Number) : void
      {
         _ratioText.text = int(param1 * 100) + "%";
      }
      
      public function remove() : void
      {
         ChangeScreenLoading.isShow = false;
         if(Starling.juggler.contains(_vertexMovie))
         {
            _vertexMovie.stop();
            Starling.juggler.remove(_vertexMovie);
         }
         removeFromParent(true);
      }
   }
}

