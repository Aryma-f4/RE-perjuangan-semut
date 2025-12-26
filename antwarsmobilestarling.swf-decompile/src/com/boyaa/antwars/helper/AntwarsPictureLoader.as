package com.boyaa.antwars.helper
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import starling.display.DisplayObjectContainer;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.textures.Texture;
   
   public class AntwarsPictureLoader extends Sprite
   {
      
      private var _container:DisplayObjectContainer;
      
      private var _rect:Rectangle;
      
      private var _load:URLLoader;
      
      private var _callBack:Function;
      
      public function AntwarsPictureLoader()
      {
         super();
      }
      
      public function load(param1:String, param2:Rectangle, param3:DisplayObjectContainer = null, param4:Function = null) : void
      {
         _rect = param2;
         _container = param3;
         _callBack = param4;
         _load = new URLLoader();
         _load.dataFormat = "binary";
         _load.addEventListener("complete",onLoadCompleteHandle);
         _load.addEventListener("ioError",onErrorHandle);
         _load.load(new URLRequest(param1));
      }
      
      private function onErrorHandle(param1:IOErrorEvent) : void
      {
         trace("Error:",param1.text.toString());
      }
      
      private function onLoadCompleteHandle(param1:Event) : void
      {
         var loaderContext:LoaderContext;
         var loader:Loader;
         var bytes:ByteArray;
         var e:Event = param1;
         var onIoError:* = function(param1:IOErrorEvent):void
         {
            trace(param1);
         };
         var onComplete:* = function(param1:Event):void
         {
            complete(LoaderInfo(param1.target).content);
         };
         trace(e);
         loaderContext = new LoaderContext(false);
         loaderContext.imageDecodingPolicy = "onLoad";
         loader = new Loader();
         bytes = _load.data as ByteArray;
         loader.contentLoaderInfo.addEventListener("complete",onComplete);
         loader.contentLoaderInfo.addEventListener("ioError",onIoError);
         loader.loadBytes(bytes,loaderContext);
      }
      
      private function complete(param1:Object) : void
      {
         var _loc2_:Texture = null;
         var _loc3_:Image = null;
         if(param1 is Bitmap)
         {
            _loc2_ = Texture.fromData(param1);
            _loc3_ = new Image(_loc2_);
            this.addChild(_loc3_);
            this.x = _rect.x;
            this.y = _rect.y;
            this.width = _rect.width;
            this.height = _rect.height;
            if(_container)
            {
               _container.addChild(this);
            }
            if(_callBack != null)
            {
               _callBack.call();
            }
         }
      }
   }
}

