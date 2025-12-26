package com.boyaa.antwars.view.screen.battlefield.element.weapon
{
   import com.boyaa.antwars.data.model.ShopData;
   import flash.utils.Dictionary;
   
   public class WeaponAngleRange
   {
      
      private static var _weaponAngleDic:Dictionary;
      
      public function WeaponAngleRange()
      {
         super();
      }
      
      private static function initWeaponAngleRange() : void
      {
         _weaponAngleDic = new Dictionary();
         _weaponAngleDic[109] = [1,89];
         _weaponAngleDic[102] = [55,70];
         _weaponAngleDic[106] = [55,70];
         _weaponAngleDic[104] = [20,50];
         _weaponAngleDic[108] = [20,50];
         _weaponAngleDic[103] = [45,70];
         _weaponAngleDic[107] = [45,70];
         _weaponAngleDic[101] = [20,50];
         _weaponAngleDic[105] = [20,50];
         _weaponAngleDic[110] = [30,65];
         _weaponAngleDic[111] = [30,65];
      }
      
      public static function getWeaponRange(param1:ShopData) : Array
      {
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         if(!_weaponAngleDic)
         {
            initWeaponAngleRange();
         }
         if(param1 == null)
         {
            return [0,1];
         }
         try
         {
            _loc3_ = param1.frameID / 10;
            _loc5_ = _weaponAngleDic[_loc3_];
            _loc2_ = int(_loc5_[0]);
            _loc4_ = int(_loc5_[1]);
         }
         catch(err:Error)
         {
            throw new Error("找不到对应的武器角度，请检查武器传入是否正确");
         }
         return _loc5_;
      }
   }
}

