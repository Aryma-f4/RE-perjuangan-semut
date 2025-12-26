package com.boyaa.antwars.view.ui.layout
{
   import feathers.display.Scale9Image;
   import feathers.textures.Scale9Textures;
   import flash.geom.Rectangle;
   import starling.display.Button;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.MovieClip;
   import starling.display.Quad;
   import starling.display.QuadBatch;
   import starling.display.Sprite;
   import starling.text.TextField;
   import starling.textures.Texture;
   
   public class LayoutUitl
   {
      
      public static const ANGLE_TO_RADIAN:Number = 0.017453292519943295;
      
      public var imagesData:Object;
      
      public var layoutsData:Object;
      
      private var createDisplayObject:Object;
      
      public var asset:ResAssetManager;
      
      private const SPRITE:String = "sprite";
      
      private const IMAGE:String = "image";
      
      private const S9IMAGE:String = "s9image";
      
      private const BATCH:String = "batch";
      
      private const NORMALBTN:String = "btn";
      
      private const TEXT:String = "text";
      
      private const STARLINGBTN:String = "btnStarling";
      
      private const MOVIE:String = "movie";
      
      private const OVER:String = "over";
      
      private const POSITION:String = "pos";
      
      private const TIPBG:String = "tipBg";
      
      private var _errorMCArr:Array = [];
      
      public function LayoutUitl(param1:Object, param2:ResAssetManager = null)
      {
         super();
         this.imagesData = param1["images"];
         this.layoutsData = param1["layout"];
         if(param2 != null)
         {
            this.asset = param2;
         }
         else
         {
            this.asset = Assets.sAsset;
         }
         setDisplayObject();
      }
      
      private function setDisplayObject() : void
      {
         createDisplayObject = {};
         createDisplayObject["sprite"] = [createSprite,0];
         createDisplayObject["pos"] = [createPosDisplay,1];
         createDisplayObject["image"] = [createImage,0];
         createDisplayObject["s9image"] = [createS9Image,0];
         createDisplayObject["btn"] = [createButton,0];
         createDisplayObject["text"] = [createTextField,1];
         createDisplayObject["btnStarling"] = [createStarlingButton,0];
         createDisplayObject["over"] = [createOverDisplay,1];
         createDisplayObject["movie"] = [createMovieClip,0];
         createDisplayObject["batch"] = [createBatch,0];
         createDisplayObject["tipBg"] = [createTipBg,1];
      }
      
      private function buildDisplayObject(param1:Object) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         if(createDisplayObject[param1.type][1] == 0)
         {
            _loc2_ = createDisplayObject[param1.type][0](param1.cname);
         }
         else
         {
            _loc2_ = createDisplayObject[param1.type][0](param1);
         }
         return _loc2_;
      }
      
      public function buildLayout(param1:String, param2:Sprite) : void
      {
         var _loc5_:Object = null;
         var _loc6_:DisplayObject = null;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Array = layoutsData[param1];
         var _loc4_:int = int(_loc3_.length);
         _loc8_ = 0;
         for(; _loc8_ < _loc3_.length; _loc8_++)
         {
            _loc5_ = _loc3_[_loc8_];
            try
            {
               _loc6_ = buildDisplayObject(_loc5_);
               if(!_loc6_)
               {
                  throw new Error("没能生成对象");
               }
            }
            catch(err:Error)
            {
               _errorMCArr.push({
                  "data":_loc5_,
                  "layout":param1,
                  "fun":"buildLayout"
               });
               continue;
            }
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            _loc6_.width = _loc5_.w;
            _loc6_.height = _loc5_.h;
            _loc6_.skewX = _loc5_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc5_.sky * 0.017453292519943295;
            if(_loc5_.name)
            {
               _loc6_.name = _loc5_.name;
            }
            else
            {
               _loc6_.name = _loc5_.cname;
            }
            param2.addChild(_loc6_);
         }
         if(_errorMCArr.length > 0)
         {
            trace("error messages -------------------------------------------------------------------");
            _loc7_ = 0;
            while(_loc7_ < _errorMCArr.length)
            {
               _loc5_ = _errorMCArr[_loc7_];
               trace(JSON.stringify(_loc5_));
               _loc7_++;
            }
            trace("error messages end ---------------------------------------------------------------");
         }
      }
      
      private function createPosDisplay(param1:Object) : DisplayObject
      {
         var _loc2_:Rectangle = new Rectangle(param1.x,param1.y,param1.w,param1.h);
         var _loc3_:Quad = new Quad(_loc2_.width,_loc2_.height);
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y;
         _loc3_.visible = _loc3_.touchable = false;
         param1.sx = param1.sy = 1;
         return _loc3_;
      }
      
      private function createOverDisplay(param1:Object) : DisplayObject
      {
         var _loc2_:String = param1.name;
         var _loc3_:String = param1.cname;
         if(_loc2_ == null)
         {
            return createImage(param1.cname);
         }
         if(_loc2_.indexOf("btn_") == 0)
         {
            return createButton(param1.cname);
         }
         if(_loc2_.indexOf("btnS_") == 0)
         {
            return createStarlingButton(_loc3_);
         }
         if(_loc2_.indexOf("s9_") == 0)
         {
            param1.type = "s9image";
            return createS9Image(param1.cname);
         }
         return createImage(param1.cname);
      }
      
      private function createTipBg(param1:Object) : Sprite
      {
         var _loc2_:Number = Number(param1.w);
         var _loc3_:Number = Number(param1.h);
         return new TipDialogBg(_loc2_,_loc3_);
      }
      
      private function createMovieClip(param1:String) : MovieClip
      {
         var _loc4_:int = int(param1.indexOf("_"));
         param1 = param1.slice(0,_loc4_ + 1);
         var _loc3_:Vector.<Texture> = asset.getTextures(param1);
         return new MovieClip(_loc3_);
      }
      
      public function createSprite(param1:String) : Sprite
      {
         var _loc5_:Object = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:int = 0;
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Array = layoutsData[param1];
         var _loc4_:int = int(_loc3_.length);
         _loc7_ = 0;
         while(true)
         {
            if(_loc7_ >= _loc3_.length)
            {
               return _loc2_;
            }
            _loc5_ = _loc3_[_loc7_];
            try
            {
               _loc6_ = buildDisplayObject(_loc5_);
               if(!_loc6_)
               {
                  throw new Error(_loc5_);
               }
            }
            catch(err:Error)
            {
               _errorMCArr.push({
                  "data":_loc5_,
                  "layout":param1,
                  "fun":"createSprite"
               });
               var _loc9_:* = null;
               break;
            }
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            if(_loc5_.type == "s9image")
            {
               _loc6_.width = _loc5_.w;
               _loc6_.height = _loc5_.h;
            }
            else
            {
               _loc6_.scaleX = _loc5_.sx;
               _loc6_.scaleY = _loc5_.sy;
            }
            _loc6_.skewX = _loc5_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc5_.sky * 0.017453292519943295;
            if(_loc5_.name)
            {
               _loc6_.name = _loc5_.name;
            }
            else
            {
               _loc6_.name = _loc5_.cname;
            }
            _loc2_.addChild(_loc6_);
            _loc7_++;
         }
         return _loc9_;
      }
      
      public function createButton(param1:String) : ButtonNormal
      {
         var _loc2_:Sprite = new Sprite();
         buildLayout(param1,_loc2_);
         return new ButtonNormal(_loc2_);
      }
      
      public function createStarlingButton(param1:String) : Button
      {
         var _loc6_:Texture = null;
         var _loc7_:Texture = null;
         var _loc3_:RegExp = /\d+/;
         var _loc2_:Array = param1.match(_loc3_);
         _loc3_ = /[^0-9]+/;
         var _loc5_:Array = param1.match(_loc3_);
         if(_loc2_ != null)
         {
            _loc2_[1] = int(_loc2_[0]) + 1;
            _loc6_ = asset.getTexture(String(_loc5_[0]) + String(_loc2_[0]));
            _loc7_ = asset.getTexture(String(_loc5_[0]) + String(_loc2_[1]));
         }
         else
         {
            _loc6_ = asset.getTexture(String(_loc5_[0]) + "1");
            _loc7_ = asset.getTexture(String(_loc5_[0]) + "2");
         }
         return new Button(_loc6_,"",_loc7_);
      }
      
      public function createBatch(param1:String) : QuadBatch
      {
         var _loc6_:Image = null;
         var _loc4_:Object = null;
         var _loc7_:int = 0;
         var _loc5_:QuadBatch = new QuadBatch();
         var _loc2_:Array = layoutsData[param1];
         var _loc3_:int = int(_loc2_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc7_];
            _loc6_ = createImage(_loc4_.cname);
            _loc6_.x = _loc4_.x;
            _loc6_.y = _loc4_.y;
            _loc6_.scaleX = _loc4_.sx;
            _loc6_.scaleY = _loc4_.sy;
            _loc6_.skewX = _loc4_.skx * 0.017453292519943295;
            _loc6_.skewY = _loc4_.sky * 0.017453292519943295;
            _loc5_.addImage(_loc6_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      public function createImage(param1:String) : Image
      {
         var _loc2_:Object = null;
         var _loc3_:Texture = null;
         var _loc4_:Image = null;
         try
         {
            _loc2_ = imagesData[param1];
            if(_loc2_ == null)
            {
               _loc2_ = imagesData["over_" + param1];
            }
            _loc3_ = asset.getTexture(param1);
            _loc4_ = new Image(_loc3_);
            _loc4_.pivotX = -_loc2_.x;
            _loc4_.pivotY = -_loc2_.y;
            return _loc4_;
         }
         catch(error:Error)
         {
            trace(param1);
         }
         return null;
      }
      
      public function createS9Image(param1:String) : Scale9Image
      {
         var _loc2_:Object = imagesData[param1];
         if(_loc2_ == null)
         {
            _loc2_ = imagesData["over_" + param1];
         }
         var _loc3_:Texture = asset.getTexture(param1);
         var _loc5_:Scale9Textures = new Scale9Textures(_loc3_,new Rectangle(_loc2_.s9gw,_loc2_.s9gw,1,1));
         return new Scale9Image(_loc5_);
      }
      
      public function createTextField(param1:Object) : TextField
      {
         var _loc2_:TextField = new TextField(param1.w,param1.h,param1.text,param1.font,param1.size,param1.color,param1.bold);
         _loc2_.italic = param1.italic;
         _loc2_.vAlign = "center";
         _loc2_.hAlign = param1.align;
         _loc2_.touchable = false;
         _loc2_.autoScale = true;
         return _loc2_;
      }
      
      public function addLayout(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc3_:Object = param1["images"];
         var _loc2_:Object = param1["layout"];
         for(_loc4_ in _loc3_)
         {
            this.imagesData[_loc4_] = _loc3_[_loc4_];
         }
         for(_loc4_ in _loc2_)
         {
            this.layoutsData[_loc4_] = _loc2_[_loc4_];
         }
      }
   }
}

