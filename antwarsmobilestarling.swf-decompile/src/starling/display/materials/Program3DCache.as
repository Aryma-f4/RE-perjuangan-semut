package starling.display.materials
{
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import flash.utils.Dictionary;
   import starling.display.shaders.IShader;
   
   internal class Program3DCache
   {
      
      private static var uid:int = 0;
      
      private static var uidByShaderTable:Dictionary = new Dictionary(true);
      
      private static var programByUIDTable:Object = {};
      
      private static var uidByProgramTable:Dictionary = new Dictionary(false);
      
      private static var numReferencesByProgramTable:Dictionary = new Dictionary();
      
      public function Program3DCache()
      {
         super();
      }
      
      public static function getProgram3D(param1:Context3D, param2:IShader, param3:IShader) : Program3D
      {
         var _loc7_:int = int(uidByShaderTable[param2]);
         if(_loc7_ == 0)
         {
            _loc7_ = uidByShaderTable[param2] = ++uid;
         }
         var _loc6_:int = int(uidByShaderTable[param3]);
         if(_loc6_ == 0)
         {
            _loc6_ = uidByShaderTable[param3] = ++uid;
         }
         var _loc5_:String = _loc7_ + "_" + _loc6_;
         var _loc4_:Program3D = programByUIDTable[_loc5_];
         if(_loc4_ == null)
         {
            _loc4_ = programByUIDTable[_loc5_] = param1.createProgram();
            uidByProgramTable[_loc4_] = _loc5_;
            _loc4_.upload(param2.opCode,param3.opCode);
            numReferencesByProgramTable[_loc4_] = 0;
         }
         numReferencesByProgramTable[_loc4_]++;
         return _loc4_;
      }
      
      public static function releaseProgram3D(param1:Program3D) : void
      {
         var _loc3_:String = null;
         if(numReferencesByProgramTable[param1] == null)
         {
            throw new Error("Program3D is not in cache");
         }
         var _loc2_:int = int(numReferencesByProgramTable[param1]);
         if(--_loc2_ == 0)
         {
            param1.dispose();
            delete numReferencesByProgramTable[param1];
            _loc3_ = uidByProgramTable[param1];
            delete programByUIDTable[_loc3_];
            delete uidByProgramTable[param1];
            return;
         }
         numReferencesByProgramTable[param1] = _loc2_;
      }
   }
}

