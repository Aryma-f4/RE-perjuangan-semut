package
{
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import starling.display.DisplayObject;
   import starling.textures.Texture;
   
   public class Assets
   {
      
      public static var width:int;
      
      public static var height:int;
      
      private static var _emptyTexture:Texture;
      
      public static var sAsset:ResAssetManager = null;
      
      public static var btAsset:ResAssetManager = null;
      
      private static var pointHelper:Point = new Point();
      
      public static var leftTop:Point = new Point();
      
      public static var rightTop:Point = new Point();
      
      public static var leftBottom:Point = new Point();
      
      public static var rightBottom:Point = new Point();
      
      public static var leftCenter:Point = new Point();
      
      public static var rightCenter:Point = new Point();
      
      public static var topCenter:Point = new Point();
      
      public static var bottomCenter:Point = new Point();
      
      public static const Close:Class = close_png$6211fb77530e260e14fb061a5761244e598160905;
      
      public function Assets()
      {
         super();
      }
      
      public static function getScreenPos(param1:String) : Dictionary
      {
         return sAsset.getScreenPos(param1);
      }
      
      public static function positionDisplay(param1:DisplayObject, param2:String, param3:String) : void
      {
         sAsset.positionDisplay(param1,param2,param3);
      }
      
      public static function getPosition(param1:String, param2:String) : Rectangle
      {
         return sAsset.getPosition(param1,param2);
      }
      
      public static function initScreenPoint(param1:Stage, param2:Rectangle) : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param2.x > 0)
         {
            width = 1365;
            height = 768;
            Assets.leftTop.x = 0;
            Assets.leftTop.y = 0;
            Assets.rightTop.x = width;
            Assets.rightTop.y = 0;
            Assets.leftBottom.x = 0;
            Assets.leftBottom.y = height;
            Assets.rightBottom.x = width;
            Assets.rightBottom.y = height;
            Assets.leftCenter.x = 0;
            Assets.leftCenter.y = height >> 1;
            Assets.rightCenter.x = width;
            Assets.rightCenter.y = height >> 1;
            Assets.topCenter.x = width >> 1;
            Assets.topCenter.y = 0;
            Assets.bottomCenter.x = width >> 1;
            Assets.bottomCenter.y = height;
         }
         else
         {
            _loc5_ = Number(Constants.isPC ? param1.stageWidth : param1.fullScreenWidth);
            _loc4_ = Number(Constants.isPC ? param1.stageHeight : param1.fullScreenHeight);
            _loc3_ = 768 / _loc4_;
            width = _loc5_ * _loc3_;
            height = _loc4_ * _loc3_;
            Assets.leftTop.x = (0 - param2.x) * _loc3_;
            Assets.leftTop.y = (0 - param2.y) * _loc3_;
            Assets.rightTop.x = Assets.leftTop.x + width;
            Assets.rightTop.y = Assets.leftTop.y;
            Assets.leftBottom.x = Assets.leftTop.x;
            Assets.leftBottom.y = Assets.leftTop.y + height;
            Assets.rightBottom.x = Assets.rightTop.x;
            Assets.rightBottom.y = Assets.leftBottom.y;
            Assets.leftCenter.x = Assets.leftTop.x;
            Assets.leftCenter.y = Assets.leftTop.y + (height >> 1);
            Assets.rightCenter.x = Assets.rightTop.x;
            Assets.rightCenter.y = Assets.rightTop.y + (height >> 1);
            Assets.topCenter.x = Assets.leftTop.x + (width >> 1);
            Assets.topCenter.y = Assets.leftTop.y;
            Assets.bottomCenter.x = Assets.topCenter.x;
            Assets.bottomCenter.y = Assets.leftBottom.y;
         }
      }
      
      public static function emptyTexture() : Texture
      {
         if(!_emptyTexture)
         {
            _emptyTexture = Texture.fromBitmapData(new BitmapData(1,1,true,0),false);
         }
         return _emptyTexture;
      }
   }
}

