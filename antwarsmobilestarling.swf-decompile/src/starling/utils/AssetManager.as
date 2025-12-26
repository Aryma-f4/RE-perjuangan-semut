package starling.utils
{
   import dragonBones.textures.StarlingTextureAtlas;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import starling.core.Starling;
   import starling.events.EventDispatcher;
   import starling.text.BitmapFont;
   import starling.text.TextField;
   import starling.textures.AtfData;
   import starling.textures.Texture;
   import starling.textures.TextureAtlas;
   import starling.textures.TextureOptions;
   
   public class AssetManager extends EventDispatcher
   {
      
      private static const HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
      
      private static var sNames:Vector.<String> = new Vector.<String>(0);
      
      private static const NAME_REGEX:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
      
      private var mStarling:Starling;
      
      private var mNumLostTextures:int;
      
      private var mNumRestoredTextures:int;
      
      private var mNumLoadingQueues:int;
      
      private var mDefaultTextureOptions:TextureOptions;
      
      private var mCheckPolicyFile:Boolean;
      
      private var mKeepAtlasXmls:Boolean;
      
      private var mKeepFontXmls:Boolean;
      
      private var mNumConnections:int;
      
      private var mVerbose:Boolean;
      
      private var mQueue:Array;
      
      private var mTextures:Dictionary;
      
      private var mAtlases:Dictionary;
      
      private var mSounds:Dictionary;
      
      private var mXmls:Dictionary;
      
      private var mObjects:Dictionary;
      
      private var mByteArrays:Dictionary;
      
      public function AssetManager(param1:Number = 1, param2:Boolean = false)
      {
         super();
         mDefaultTextureOptions = new TextureOptions(param1,param2);
         mTextures = new Dictionary();
         mAtlases = new Dictionary();
         mSounds = new Dictionary();
         mXmls = new Dictionary();
         mObjects = new Dictionary();
         mByteArrays = new Dictionary();
         mNumConnections = 3;
         mVerbose = true;
         mQueue = [];
      }
      
      public function dispose() : void
      {
         for each(var _loc1_ in mTextures)
         {
            _loc1_.dispose();
         }
         for each(var _loc4_ in mAtlases)
         {
            _loc4_.dispose();
         }
         for each(var _loc3_ in mXmls)
         {
            System.disposeXML(_loc3_);
         }
         for each(var _loc2_ in mByteArrays)
         {
            _loc2_.clear();
         }
      }
      
      public function getTexture(param1:String) : Texture
      {
         var _loc2_:Texture = null;
         if(param1 in mTextures)
         {
            return mTextures[param1];
         }
         for each(var _loc3_ in mAtlases)
         {
            _loc2_ = _loc3_.getTexture(param1);
            if(_loc2_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getTextures(param1:String = "", param2:Vector.<Texture> = null) : Vector.<Texture>
      {
         if(param2 == null)
         {
            param2 = new Vector.<Texture>(0);
         }
         for each(var _loc3_ in getTextureNames(param1,sNames))
         {
            param2[param2.length] = getTexture(_loc3_);
         }
         sNames.length = 0;
         return param2;
      }
      
      public function getTextureNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         param2 = getDictionaryKeys(mTextures,param1,param2);
         for each(var _loc3_ in mAtlases)
         {
            _loc3_.getNames(param1,param2);
         }
         param2.sort(1);
         return param2;
      }
      
      public function getTextureAtlas(param1:String) : TextureAtlas
      {
         return mAtlases[param1] as TextureAtlas;
      }
      
      public function getSound(param1:String) : Sound
      {
         return mSounds[param1];
      }
      
      public function getSoundNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mSounds,param1,param2);
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
      {
         if(param1 in mSounds)
         {
            return getSound(param1).play(param2,param3,param4);
         }
         return null;
      }
      
      public function getXml(param1:String) : XML
      {
         return mXmls[param1];
      }
      
      public function getXmlNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mXmls,param1,param2);
      }
      
      public function getObject(param1:String) : Object
      {
         return mObjects[param1];
      }
      
      public function getObjectNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mObjects,param1,param2);
      }
      
      public function getByteArray(param1:String) : ByteArray
      {
         return mByteArrays[param1];
      }
      
      public function getByteArrayNames(param1:String = "", param2:Vector.<String> = null) : Vector.<String>
      {
         return getDictionaryKeys(mByteArrays,param1,param2);
      }
      
      public function addTexture(param1:String, param2:Texture) : void
      {
         log("Adding texture \'" + param1 + "\'");
         if(param1 in mTextures)
         {
            log("Warning: name was already in use; the previous texture will be replaced.");
            mTextures[param1].dispose();
         }
         mTextures[param1] = param2;
      }
      
      public function addTextureAtlas(param1:String, param2:TextureAtlas) : void
      {
         log("Adding texture atlas \'" + param1 + "\'");
         if(param1 in mAtlases)
         {
            log("Warning: name was already in use; the previous atlas will be replaced.");
            mAtlases[param1].dispose();
         }
         mAtlases[param1] = param2;
      }
      
      public function addSound(param1:String, param2:Sound) : void
      {
         log("Adding sound \'" + param1 + "\'");
         if(param1 in mSounds)
         {
            log("Warning: name was already in use; the previous sound will be replaced.");
         }
         mSounds[param1] = param2;
      }
      
      public function addXml(param1:String, param2:XML) : void
      {
         log("Adding XML \'" + param1 + "\'");
         if(param1 in mXmls)
         {
            log("Warning: name was already in use; the previous XML will be replaced.");
            System.disposeXML(mXmls[param1]);
         }
         mXmls[param1] = param2;
      }
      
      public function addObject(param1:String, param2:Object) : void
      {
         log("Adding object \'" + param1 + "\'");
         if(param1 in mObjects)
         {
            log("Warning: name was already in use; the previous object will be replaced.");
         }
         mObjects[param1] = param2;
      }
      
      public function addByteArray(param1:String, param2:ByteArray) : void
      {
         log("Adding byte array \'" + param1 + "\'");
         if(param1 in mByteArrays)
         {
            log("Warning: name was already in use; the previous byte array will be replaced.");
            mByteArrays[param1].clear();
         }
         mByteArrays[param1] = param2;
      }
      
      public function removeTexture(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture \'" + param1 + "\'");
         if(param2 && param1 in mTextures)
         {
            mTextures[param1].dispose();
         }
         delete mTextures[param1];
      }
      
      public function removeTextureAtlas(param1:String, param2:Boolean = true) : void
      {
         log("Removing texture atlas \'" + param1 + "\'");
         if(param2 && param1 in mAtlases)
         {
            mAtlases[param1].dispose();
         }
         delete mAtlases[param1];
      }
      
      public function removeSound(param1:String) : void
      {
         log("Removing sound \'" + param1 + "\'");
         delete mSounds[param1];
      }
      
      public function removeXml(param1:String, param2:Boolean = true) : void
      {
         log("Removing xml \'" + param1 + "\'");
         if(param2 && param1 in mXmls)
         {
            System.disposeXML(mXmls[param1]);
         }
         delete mXmls[param1];
      }
      
      public function removeObject(param1:String) : void
      {
         log("Removing object \'" + param1 + "\'");
         delete mObjects[param1];
      }
      
      public function removeByteArray(param1:String, param2:Boolean = true) : void
      {
         log("Removing byte array \'" + param1 + "\'");
         if(param2 && param1 in mByteArrays)
         {
            mByteArrays[param1].clear();
         }
         delete mByteArrays[param1];
      }
      
      public function purgeQueue() : void
      {
         mQueue.length = 0;
         dispatchEventWith("cancel");
      }
      
      public function purge() : void
      {
         log("Purging all assets, emptying queue");
         purgeQueue();
         dispose();
         mTextures = new Dictionary();
         mAtlases = new Dictionary();
         mSounds = new Dictionary();
         mXmls = new Dictionary();
         mObjects = new Dictionary();
         mByteArrays = new Dictionary();
      }
      
      public function enqueue(... rest) : void
      {
         var _loc4_:XML = null;
         var _loc2_:* = null;
         for each(var _loc3_ in rest)
         {
            if(_loc3_ is Array)
            {
               enqueue.apply(this,_loc3_);
            }
            else if(_loc3_ is Class)
            {
               _loc4_ = describeType(_loc3_);
               if(mVerbose)
               {
                  log("Looking for static embedded assets in \'" + _loc4_.@name.split("::").pop() + "\'");
               }
               for each(_loc2_ in _loc4_.constant.(@type == "Class"))
               {
                  enqueueWithName(_loc3_[_loc2_.@name],_loc2_.@name);
               }
               for each(_loc2_ in _loc4_.variable.(@type == "Class"))
               {
                  enqueueWithName(_loc3_[_loc2_.@name],_loc2_.@name);
               }
            }
            else if(getQualifiedClassName(_loc3_) == "flash.filesystem::File")
            {
               if(!_loc3_["exists"])
               {
                  log("File or directory not found: \'" + _loc3_["url"] + "\'");
               }
               else if(!_loc3_["isHidden"])
               {
                  if(_loc3_["isDirectory"])
                  {
                     enqueue.apply(this,_loc3_["getDirectoryListing"]());
                  }
                  else
                  {
                     enqueueWithName(_loc3_);
                  }
               }
            }
            else if(_loc3_ is String)
            {
               enqueueWithName(_loc3_);
            }
            else
            {
               log("Ignoring unsupported asset type: " + getQualifiedClassName(_loc3_));
            }
         }
      }
      
      public function enqueueWithName(param1:Object, param2:String = null, param3:TextureOptions = null) : String
      {
         if(getQualifiedClassName(param1) == "flash.filesystem::File")
         {
            param1 = unescape(param1["url"]);
         }
         if(param2 == null)
         {
            param2 = getName(param1);
         }
         if(param3 == null)
         {
            param3 = mDefaultTextureOptions.clone();
         }
         else
         {
            param3 = param3.clone();
         }
         log("Enqueuing \'" + param2 + "\'");
         mQueue.push({
            "name":param2,
            "asset":param1,
            "options":param3
         });
         return param2;
      }
      
      public function loadQueue(param1:Function) : void
      {
         var PROGRESS_PART_ASSETS:Number;
         var PROGRESS_PART_XMLS:Number;
         var i:int;
         var canceled:Boolean;
         var xmls:Vector.<XML>;
         var assetInfos:Array;
         var assetCount:int;
         var assetProgress:Array;
         var assetIndex:int;
         var onProgress:Function = param1;
         var loadNextQueueElement:* = function():void
         {
            var _loc1_:int = 0;
            if(assetIndex < assetInfos.length)
            {
               _loc1_ = assetIndex++;
               loadQueueElement(_loc1_,assetInfos[_loc1_]);
            }
         };
         var loadQueueElement:* = function(param1:int, param2:Object):void
         {
            var onElementProgress:Function;
            var onElementLoaded:Function;
            var index:int = param1;
            var assetInfo:Object = param2;
            if(canceled)
            {
               return;
            }
            onElementProgress = function(param1:Number):void
            {
               updateAssetProgress(index,param1 * 0.8);
            };
            onElementLoaded = function():void
            {
               updateAssetProgress(index,1);
               assetCount = assetCount - 1;
               if(assetCount > 0)
               {
                  loadNextQueueElement();
               }
               else
               {
                  processXmls();
               }
            };
            processRawAsset(assetInfo.name,assetInfo.asset,assetInfo.options,xmls,onElementProgress,onElementLoaded);
         };
         var updateAssetProgress:* = function(param1:int, param2:Number):void
         {
            assetProgress[param1] = param2;
            var _loc3_:Number = 0;
            var _loc4_:int = int(assetProgress.length);
            i = 0;
            while(i < _loc4_)
            {
               _loc3_ += assetProgress[i];
               i = i + 1;
            }
            onProgress(_loc3_ / _loc4_ * 0.9);
            Application.instance.currentGame.showLoadingRatio(_loc3_ / _loc4_ * 0.9);
         };
         var processXmls:* = function():void
         {
            xmls.sort(function(param1:XML, param2:XML):int
            {
               return param1.localName() == "TextureAtlas" ? -1 : 1;
            });
            setTimeout(processXml,1,0);
         };
         var processXml:* = function(param1:int):void
         {
            var _loc4_:String = null;
            var _loc3_:Texture = null;
            var _loc6_:StarlingTextureAtlas = null;
            if(canceled)
            {
               return;
            }
            if(param1 == xmls.length)
            {
               finish();
               return;
            }
            var _loc5_:XML = xmls[param1];
            var _loc2_:String = _loc5_.localName();
            var _loc7_:Number = (param1 + 1) / (xmls.length + 1);
            if(_loc2_ == "TextureAtlas")
            {
               _loc4_ = _loc5_.@imagePath.toString();
               if(_loc4_ != "")
               {
                  _loc4_ = getName(_loc5_.@imagePath.toString());
                  _loc3_ = getTexture(_loc4_);
                  if(_loc3_)
                  {
                     addTextureAtlas(_loc4_,new TextureAtlas(_loc3_,_loc5_));
                     if(mKeepAtlasXmls)
                     {
                        addXml(_loc4_,_loc5_);
                     }
                     else
                     {
                        System.disposeXML(_loc5_);
                     }
                  }
                  else
                  {
                     log("Cannot create atlas: texture \'" + _loc4_ + "\' is missing.");
                  }
               }
               else
               {
                  _loc4_ = getName(_loc5_.@name.toString());
                  trace("Texture name:",_loc4_);
                  _loc3_ = getTexture(_loc4_);
                  _loc6_ = new StarlingTextureAtlas(_loc3_,_loc5_);
                  addBoneAtlases(_loc4_,_loc6_);
               }
            }
            else
            {
               if(_loc2_ != "font")
               {
                  throw new Error("XML contents not recognized: " + _loc2_);
               }
               _loc4_ = getName(_loc5_.pages.page.@file.toString());
               _loc3_ = getTexture(_loc4_);
               if(_loc3_)
               {
                  log("Adding bitmap font \'" + _loc4_ + "\'");
                  TextField.registerBitmapFont(new BitmapFont(_loc3_,_loc5_),_loc4_);
                  if(mKeepFontXmls)
                  {
                     addXml(_loc4_,_loc5_);
                  }
                  else
                  {
                     System.disposeXML(_loc5_);
                  }
               }
               else
               {
                  log("Cannot create bitmap font: texture \'" + _loc4_ + "\' is missing.");
               }
            }
            onProgress(0.9 + 0.09999999999999998 * _loc7_);
            setTimeout(processXml,1,param1 + 1);
         };
         var cancel:* = function():void
         {
            removeEventListener("cancel",cancel);
            mNumLoadingQueues = mNumLoadingQueues - 1;
            canceled = true;
         };
         var finish:* = function():void
         {
            System.pauseForGCIfCollectionImminent(0);
            System.gc();
            setTimeout(function():void
            {
               if(!canceled)
               {
                  cancel();
                  onProgress(1);
               }
            },1);
         };
         if(onProgress == null)
         {
            throw new ArgumentError("Argument \'onProgress\' must not be null");
         }
         if(mQueue.length == 0)
         {
            onProgress(1);
            return;
         }
         mStarling = Starling.current;
         if(mStarling == null || mStarling.context == null)
         {
            throw new Error("The Starling instance needs to be ready before assets can be loaded.");
         }
         canceled = false;
         xmls = new Vector.<XML>(0);
         assetInfos = mQueue.concat();
         assetCount = int(mQueue.length);
         assetProgress = [];
         assetIndex = 0;
         i = 0;
         while(i < assetCount)
         {
            assetProgress[i] = 0;
            i = i + 1;
         }
         i = 0;
         while(i < mNumConnections)
         {
            loadNextQueueElement();
            i = i + 1;
         }
         mQueue.length = 0;
         mNumLoadingQueues = mNumLoadingQueues + 1;
         addEventListener("cancel",cancel);
      }
      
      private function processRawAsset(param1:String, param2:Object, param3:TextureOptions, param4:Vector.<XML>, param5:Function, param6:Function) : void
      {
         var name:String = param1;
         var rawAsset:Object = param2;
         var options:TextureOptions = param3;
         var xmls:Vector.<XML> = param4;
         var onProgress:Function = param5;
         var onComplete:Function = param6;
         var process:* = function(param1:Object):void
         {
            var texture:Texture;
            var bytes:ByteArray;
            var asset:Object = param1;
            var object:Object = null;
            var xml:XML = null;
            mStarling.makeCurrent();
            if(!canceled)
            {
               if(asset == null)
               {
                  onComplete();
               }
               else if(asset is Sound)
               {
                  addSound(name,asset as Sound);
                  onComplete();
               }
               else if(asset is XML)
               {
                  xml = asset as XML;
                  if(xml.localName() == "TextureAtlas" || xml.localName() == "font")
                  {
                     xmls.push(xml);
                  }
                  else
                  {
                     addXml(name,xml);
                  }
                  onComplete();
               }
               else
               {
                  if(Starling.handleLostContext && mStarling.context.driverInfo == "Disposed")
                  {
                     log("Context lost while processing assets, retrying ...");
                     setTimeout(process,1,asset);
                     return;
                  }
                  if(asset is Bitmap)
                  {
                     options.scale = getScaleFactor(name,Assets.sAsset.scaleFactor);
                     texture = Texture.fromData(asset,options);
                     texture.root.onRestore = function():void
                     {
                        mNumLostTextures = mNumLostTextures + 1;
                        loadRawAsset(rawAsset,null,function(param1:Object):void
                        {
                           try
                           {
                              texture.root.uploadBitmap(param1 as Bitmap);
                           }
                           catch(e:Error)
                           {
                              log("Texture restoration failed: " + e.message);
                           }
                           param1.bitmapData.dispose();
                           mNumRestoredTextures = mNumRestoredTextures + 1;
                           if(mNumLostTextures == mNumRestoredTextures)
                           {
                              dispatchEventWith("texturesRestored");
                           }
                        });
                     };
                     disposeBitmap(name,asset as Bitmap);
                     addTexture(name,texture);
                     onComplete();
                  }
                  else if(asset is ByteArray)
                  {
                     bytes = asset as ByteArray;
                     if(AtfData.isAtfData(bytes))
                     {
                        options.onReady = prependCallback(options.onReady,onComplete);
                        texture = Texture.fromData(bytes,options);
                        texture.root.onRestore = function():void
                        {
                           mNumLostTextures = mNumLostTextures + 1;
                           loadRawAsset(rawAsset,null,function(param1:Object):void
                           {
                              try
                              {
                                 texture.root.uploadAtfData(param1 as ByteArray,0,true);
                              }
                              catch(e:Error)
                              {
                                 log("Texture restoration failed: " + e.message);
                              }
                              param1.clear();
                              mNumRestoredTextures = mNumRestoredTextures + 1;
                              if(mNumLostTextures == mNumRestoredTextures)
                              {
                                 dispatchEventWith("texturesRestored");
                              }
                           });
                        };
                        bytes.clear();
                        addTexture(name,texture);
                     }
                     else if(byteArrayStartsWith(bytes,"{") || byteArrayStartsWith(bytes,"["))
                     {
                        try
                        {
                           object = JSON.parse(bytes.readUTFBytes(bytes.length));
                        }
                        catch(e:Error)
                        {
                           log("Could not parse JSON: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        if(object)
                        {
                           addObject(name,object);
                        }
                        bytes.clear();
                        onComplete();
                     }
                     else if(byteArrayStartsWith(bytes,"<"))
                     {
                        try
                        {
                           xml = new XML(bytes);
                        }
                        catch(e:Error)
                        {
                           log("Could not parse XML: " + e.message);
                           dispatchEventWith("parseError",false,name);
                        }
                        process(xml);
                        bytes.clear();
                     }
                     else
                     {
                        addByteArray(name,bytes);
                        onComplete();
                     }
                  }
                  else
                  {
                     addObject(name,asset);
                     onComplete();
                  }
               }
            }
            asset = null;
            bytes = null;
            removeEventListener("cancel",cancel);
         };
         var progress:* = function(param1:Number):void
         {
            if(!canceled)
            {
               onProgress(param1);
            }
         };
         var cancel:* = function():void
         {
            canceled = true;
         };
         var canceled:Boolean = false;
         addEventListener("cancel",cancel);
         loadRawAsset(rawAsset,progress,process);
      }
      
      protected function loadRawAsset(param1:Object, param2:Function, param3:Function) : void
      {
         var rawAsset:Object = param1;
         var onProgress:Function = param2;
         var onComplete:Function = param3;
         var onIoError:* = function(param1:IOErrorEvent):void
         {
            log("IO error: " + param1.text);
            dispatchEventWith("ioError",false,url);
            complete(null);
         };
         var onSecurityError:* = function(param1:SecurityErrorEvent):void
         {
            log("security error: " + param1.text);
            dispatchEventWith("securityError",false,url);
            complete(null);
         };
         var onHttpResponseStatus:* = function(param1:HTTPStatusEvent):void
         {
            var _loc2_:Array = null;
            var _loc3_:String = null;
            if(extension == null)
            {
               _loc2_ = param1["responseHeaders"];
               _loc3_ = getHttpHeader(_loc2_,"Content-Type");
               if(_loc3_ && /(audio|image)\//.exec(_loc3_))
               {
                  extension = _loc3_.split("/").pop();
               }
            }
         };
         var onLoadProgress:* = function(param1:ProgressEvent):void
         {
            if(onProgress != null && param1.bytesTotal > 0)
            {
               onProgress(param1.bytesLoaded / param1.bytesTotal);
            }
         };
         var onUrlLoaderComplete:* = function(param1:Object):void
         {
            var _loc5_:Sound = null;
            var _loc4_:LoaderContext = null;
            var _loc3_:Loader = null;
            var _loc2_:ByteArray = transformData(urlLoader.data as ByteArray,url);
            if(extension)
            {
               extension = extension.toLowerCase();
            }
            switch(extension)
            {
               case "mpeg":
               case "mp3":
                  _loc5_ = new Sound();
                  _loc5_.loadCompressedDataFromByteArray(_loc2_,_loc2_.length);
                  _loc2_.clear();
                  complete(_loc5_);
                  break;
               case "jpg":
               case "jpeg":
               case "png":
               case "gif":
                  _loc4_ = new LoaderContext(mCheckPolicyFile);
                  _loc3_ = new Loader();
                  _loc4_.imageDecodingPolicy = "onLoad";
                  loaderInfo = _loc3_.contentLoaderInfo;
                  loaderInfo.addEventListener("ioError",onIoError);
                  loaderInfo.addEventListener("complete",onLoaderComplete);
                  _loc3_.loadBytes(_loc2_,_loc4_);
                  if(url.search("http://") != -1)
                  {
                     saveFileToRes(url,_loc2_);
                  }
                  break;
               default:
                  if(url.search("http://") != -1)
                  {
                     saveFileToRes(url,_loc2_);
                  }
                  onComplete(_loc2_);
            }
         };
         var onLoaderComplete:* = function(param1:Object):void
         {
            urlLoader.data.clear();
            complete(param1.target.content);
         };
         var complete:* = function(param1:Object):void
         {
            if(urlLoader)
            {
               urlLoader.removeEventListener("ioError",onIoError);
               urlLoader.removeEventListener("securityError",onSecurityError);
               urlLoader.removeEventListener("httpResponseStatus",onHttpResponseStatus);
               urlLoader.removeEventListener("progress",onLoadProgress);
               urlLoader.removeEventListener("complete",onUrlLoaderComplete);
            }
            if(loaderInfo)
            {
               loaderInfo.removeEventListener("ioError",onIoError);
               loaderInfo.removeEventListener("complete",onLoaderComplete);
            }
            if(SystemUtil.isDesktop)
            {
               onComplete(param1);
            }
            else
            {
               SystemUtil.executeWhenApplicationIsActive(onComplete,param1);
            }
         };
         var extension:String = null;
         var loaderInfo:LoaderInfo = null;
         var urlLoader:URLLoader = null;
         var url:String = null;
         if(rawAsset is Class)
         {
            setTimeout(complete,1,new rawAsset());
         }
         else if(rawAsset is String)
         {
            url = rawAsset as String;
            extension = getExtensionFromUrl(url);
            urlLoader = new URLLoader();
            urlLoader.dataFormat = "binary";
            urlLoader.addEventListener("ioError",onIoError);
            urlLoader.addEventListener("securityError",onSecurityError);
            urlLoader.addEventListener("httpResponseStatus",onHttpResponseStatus);
            urlLoader.addEventListener("progress",onLoadProgress);
            urlLoader.addEventListener("complete",onUrlLoaderComplete);
            urlLoader.load(new URLRequest(url));
         }
      }
      
      protected function getName(param1:Object) : String
      {
         var _loc3_:String = null;
         var _loc2_:Array = null;
         if(param1 is String || param1 is FileReference)
         {
            _loc3_ = param1 is String ? param1 as String : (param1 as FileReference).name;
            _loc3_ = _loc3_.replace(/%20/g," ");
            _loc3_ = getBasenameFromUrl(_loc3_);
            _loc2_ = /(.*[\\\/])?([\w\s\-]+)(\.[\w]{1,4})?/.exec(_loc3_);
            if(_loc2_ && _loc2_.length == 4)
            {
               return _loc2_[2];
            }
            throw new ArgumentError("Could not extract name from String \'" + param1 + "\'");
         }
         _loc3_ = getQualifiedClassName(param1);
         throw new ArgumentError("Cannot extract names for objects of type \'" + _loc3_ + "\'");
      }
      
      protected function transformData(param1:ByteArray, param2:String) : ByteArray
      {
         return param1;
      }
      
      protected function log(param1:String) : void
      {
         if(mVerbose)
         {
            trace("[AssetManager]",param1);
         }
      }
      
      private function byteArrayStartsWith(param1:ByteArray, param2:String) : Boolean
      {
         var _loc7_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = int(param1.length);
         var _loc6_:int = int(param2.charCodeAt(0));
         if(_loc5_ >= 4 && (param1[0] == 0 && param1[1] == 0 && param1[2] == 254 && param1[3] == 255) || param1[0] == 255 && param1[1] == 254 && param1[2] == 0 && param1[3] == 0)
         {
            _loc4_ = 4;
         }
         else if(_loc5_ >= 3 && param1[0] == 239 && param1[1] == 187 && param1[2] == 191)
         {
            _loc4_ = 3;
         }
         else if(_loc5_ >= 2 && (param1[0] == 254 && param1[1] == 255) || param1[0] == 255 && param1[1] == 254)
         {
            _loc4_ = 2;
         }
         _loc7_ = _loc4_;
         while(_loc7_ < _loc5_)
         {
            _loc3_ = int(param1[_loc7_]);
            if(!(_loc3_ == 0 || _loc3_ == 10 || _loc3_ == 13 || _loc3_ == 32))
            {
               return _loc3_ == _loc6_;
            }
            _loc7_++;
         }
         return false;
      }
      
      private function getDictionaryKeys(param1:Dictionary, param2:String = "", param3:Vector.<String> = null) : Vector.<String>
      {
         if(param3 == null)
         {
            param3 = new Vector.<String>(0);
         }
         for(var _loc4_ in param1)
         {
            if(_loc4_.indexOf(param2) == 0)
            {
               param3[param3.length] = _loc4_;
            }
         }
         param3.sort(1);
         return param3;
      }
      
      private function getHttpHeader(param1:Array, param2:String) : String
      {
         if(param1)
         {
            for each(var _loc3_ in param1)
            {
               if(_loc3_.name == param2)
               {
                  return _loc3_.value;
               }
            }
         }
         return null;
      }
      
      protected function getBasenameFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 0)
         {
            return _loc2_[1];
         }
         return null;
      }
      
      protected function getExtensionFromUrl(param1:String) : String
      {
         var _loc2_:Array = NAME_REGEX.exec(param1);
         if(_loc2_ && _loc2_.length > 1)
         {
            return _loc2_[2];
         }
         return null;
      }
      
      private function prependCallback(param1:Function, param2:Function) : Function
      {
         var oldCallback:Function = param1;
         var newCallback:Function = param2;
         if(oldCallback == null)
         {
            return newCallback;
         }
         if(newCallback == null)
         {
            return oldCallback;
         }
         return function():void
         {
            newCallback();
            oldCallback();
         };
      }
      
      protected function get queue() : Array
      {
         return mQueue;
      }
      
      public function get numQueuedAssets() : int
      {
         return mQueue.length;
      }
      
      public function get verbose() : Boolean
      {
         return mVerbose;
      }
      
      public function set verbose(param1:Boolean) : void
      {
         mVerbose = param1;
      }
      
      public function get isLoading() : Boolean
      {
         return mNumLoadingQueues > 0;
      }
      
      public function get useMipMaps() : Boolean
      {
         return mDefaultTextureOptions.mipMapping;
      }
      
      public function set useMipMaps(param1:Boolean) : void
      {
         mDefaultTextureOptions.mipMapping = param1;
      }
      
      public function get textureRepeat() : Boolean
      {
         return mDefaultTextureOptions.repeat;
      }
      
      public function set textureRepeat(param1:Boolean) : void
      {
         mDefaultTextureOptions.repeat = param1;
      }
      
      public function get scaleFactor() : Number
      {
         return mDefaultTextureOptions.scale;
      }
      
      public function set scaleFactor(param1:Number) : void
      {
         mDefaultTextureOptions.scale = param1;
      }
      
      public function get textureFormat() : String
      {
         return mDefaultTextureOptions.format;
      }
      
      public function set textureFormat(param1:String) : void
      {
         mDefaultTextureOptions.format = param1;
      }
      
      public function get checkPolicyFile() : Boolean
      {
         return mCheckPolicyFile;
      }
      
      public function set checkPolicyFile(param1:Boolean) : void
      {
         mCheckPolicyFile = param1;
      }
      
      public function get keepAtlasXmls() : Boolean
      {
         return mKeepAtlasXmls;
      }
      
      public function set keepAtlasXmls(param1:Boolean) : void
      {
         mKeepAtlasXmls = param1;
      }
      
      public function get keepFontXmls() : Boolean
      {
         return mKeepFontXmls;
      }
      
      public function set keepFontXmls(param1:Boolean) : void
      {
         mKeepFontXmls = param1;
      }
      
      public function get numConnections() : int
      {
         return mNumConnections;
      }
      
      public function set numConnections(param1:int) : void
      {
         mNumConnections = param1;
      }
      
      protected function saveMap(param1:String, param2:ByteArray) : void
      {
      }
      
      protected function saveFileToRes(param1:String, param2:ByteArray) : void
      {
      }
      
      protected function addBoneAtlases(param1:String, param2:StarlingTextureAtlas) : void
      {
         addTextureAtlas(param1,param2);
      }
      
      protected function getScaleFactor(param1:String, param2:Number) : Number
      {
         return param2;
      }
      
      protected function getUseMipMaps(param1:String, param2:Boolean) : Boolean
      {
         return param2;
      }
      
      protected function disposeBitmap(param1:String, param2:Bitmap) : void
      {
         param2.bitmapData.dispose();
      }
   }
}

