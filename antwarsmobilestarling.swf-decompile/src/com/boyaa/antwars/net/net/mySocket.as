package com.boyaa.antwars.net.net
{
   import com.boyaa.debug.Logging.LevelLogger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   public class mySocket extends EventDispatcher
   {
      
      private var socket:Socket;
      
      private var packet:ByteArray;
      
      private var packetbody:ByteArray;
      
      private var readpacket:ByteArray;
      
      private var nStatus:int = 0;
      
      private var nBodyLen:uint = 0;
      
      private const REQ_REQUEST:int = 0;
      
      private const REQ_BODY:int = 2;
      
      private const REQ_DONE:int = 3;
      
      private const PACKET_HEADER_SIZE:int = 9;
      
      private const PACKET_BUFFER_SIZE:int = 16384;
      
      public function mySocket()
      {
         super();
         packet = new ByteArray();
         packetbody = new ByteArray();
         readpacket = new ByteArray();
         readpacket.endian = "littleEndian";
         packet.endian = "littleEndian";
         packetbody.endian = "littleEndian";
      }
      
      public function connect(param1:String, param2:int) : void
      {
         LevelLogger.getLogger("mySocket").info("connect host:" + param1 + " port:" + param2);
         close();
         socket = new Socket();
         socket.addEventListener("ioError",errorFun);
         socket.addEventListener("securityError",securityerrfun);
         socket.addEventListener("connect",connectFun);
         socket.endian = "littleEndian";
         socket.connect(param1,param2);
         reset();
      }
      
      public function writeBegin(param1:int, param2:int = 1, param3:int = 1) : void
      {
         packet.position = 0;
         packet.length = 0;
         packetbody.position = 0;
         packetbody.length = 0;
         packet.writeMultiByte("IC","gb2312");
         packet.writeShort(param1);
         packet.writeByte(param2);
         packet.writeByte(param3);
         LevelLogger.getLogger("mySocket").info(" sendcmd: " + param1);
      }
      
      public function writeEnd() : void
      {
         packet.writeShort(packetbody.length);
         packet.writeByte(0);
         packet.writeBytes(packetbody,0,packetbody.length);
      }
      
      public function sendcmd() : void
      {
         if(socket)
         {
            socket.writeBytes(packet,0,packet.length);
            socket.flush();
         }
      }
      
      public function writeInt(param1:int) : void
      {
         packetbody.writeInt(param1);
      }
      
      public function writeUint(param1:uint) : void
      {
         packetbody.writeUnsignedInt(param1);
      }
      
      public function writeShort(param1:int) : void
      {
         packetbody.writeShort(param1);
      }
      
      public function writeByte(param1:int) : void
      {
         packetbody.writeByte(param1);
      }
      
      public function writeString(param1:String, param2:String = "utf-8") : void
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeMultiByte(param1,param2);
         packetbody.writeUnsignedInt(_loc3_.length + 1);
         packetbody.writeBytes(_loc3_);
         packetbody.writeByte(0);
         _loc3_ = null;
      }
      
      public function writeBinary(param1:Object) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         packetbody.writeUnsignedInt(_loc2_.length);
         packetbody.writeBytes(_loc2_);
         _loc2_ = null;
      }
      
      private function reset() : void
      {
         nStatus = 0;
         nBodyLen = 0;
         readpacket.position = 0;
         readpacket.length = 0;
      }
      
      private function loopParse() : void
      {
         var _loc1_:mySocketEvent = null;
         if(socket == null)
         {
            return;
         }
         if(nStatus == 0)
         {
            if(!read_header())
            {
               reset();
               if(socket.bytesAvailable >= 9)
               {
                  loopParse();
               }
               return;
            }
            nStatus = 2;
         }
         if(nStatus == 2)
         {
            if(!parse_body())
            {
               return;
            }
            nStatus = 3;
         }
         if(nStatus == 3)
         {
            _loc1_ = new mySocketEvent("sync");
            LevelLogger.getLogger("mySocket").info("cmd: " + getcmd());
            dispatchEvent(_loc1_);
            _loc1_ = null;
            reset();
            loopParse();
         }
      }
      
      private function socketDataFun(param1:ProgressEvent) : void
      {
         LevelLogger.getLogger("mySocket").info("recv socketData");
         loopParse();
      }
      
      private function read_header() : Boolean
      {
         if(socket.bytesAvailable < 9)
         {
            return false;
         }
         socket.readBytes(readpacket,0,2);
         if(readpacket.readMultiByte(2,"gb2132") != "IC")
         {
            return false;
         }
         socket.readBytes(readpacket,readpacket.length,9 - 2);
         var _loc1_:int = getcmd();
         if(_loc1_ <= 0 || _loc1_ >= 32000)
         {
            return false;
         }
         nBodyLen = getbodylen();
         if(nBodyLen >= 0 && nBodyLen < 16384 - 9)
         {
            return true;
         }
         return false;
      }
      
      private function parse_body() : Boolean
      {
         if(socket.bytesAvailable < nBodyLen)
         {
            return false;
         }
         if(nBodyLen != 0)
         {
            socket.readBytes(readpacket,readpacket.length,nBodyLen);
         }
         return true;
      }
      
      public function getcmd() : int
      {
         readpacket.position = 2;
         return readpacket.readShort();
      }
      
      public function getver() : int
      {
         readpacket.position = 4;
         return readpacket.readByte();
      }
      
      public function getsubver() : int
      {
         readpacket.position = 5;
         return readpacket.readByte();
      }
      
      public function getbodylen() : int
      {
         readpacket.position = 6;
         return readpacket.readShort();
      }
      
      public function getcode() : int
      {
         readpacket.position = 8;
         return readpacket.readByte();
      }
      
      public function readbegin() : void
      {
         readpacket.position = 9;
      }
      
      public function readInt() : int
      {
         return readpacket.readInt();
      }
      
      public function readUint() : uint
      {
         return readpacket.readUnsignedInt();
      }
      
      public function readShort() : int
      {
         return readpacket.readShort();
      }
      
      public function readByte() : int
      {
         return readpacket.readByte();
      }
      
      public function readString() : String
      {
         var _loc1_:uint = readpacket.readUnsignedInt();
         return readpacket.readMultiByte(_loc1_,"utf-8");
      }
      
      public function readgb2132String() : String
      {
         var _loc1_:uint = readpacket.readUnsignedInt();
         return readpacket.readMultiByte(_loc1_,"gb2132");
      }
      
      public function readBinary() : Object
      {
         var _loc2_:uint = readpacket.readUnsignedInt();
         var _loc1_:ByteArray = new ByteArray();
         readpacket.readBytes(_loc1_,0,_loc2_);
         return _loc1_.readObject();
      }
      
      public function close() : void
      {
         clearEvent();
         if(socket)
         {
            LevelLogger.getLogger("mySocket").info("close");
            socket.close();
            socket = null;
         }
      }
      
      private function connectFun(param1:Event) : void
      {
         clearEvent();
         socket.addEventListener("socketData",socketDataFun);
         socket.addEventListener("close",closeFun);
         LevelLogger.getLogger("mySocket").info("dispatchEvent CONNECT Event");
         dispatchEvent(new mySocketEvent("connect"));
      }
      
      private function closeFun(param1:Event) : void
      {
         LevelLogger.getLogger("mySocket").info("dispatchEvent CLOSE Event");
         close();
         dispatchEvent(new mySocketEvent("close"));
      }
      
      private function securityerrfun(param1:SecurityErrorEvent) : void
      {
         LevelLogger.getLogger("mySocket").info("dispatchEvent SECURITYERROR Event");
         close();
         dispatchEvent(new mySocketEvent("securityerror"));
      }
      
      private function errorFun(param1:IOErrorEvent) : void
      {
         LevelLogger.getLogger("mySocket").info("dispatchEvent ERROR Event");
         close();
         dispatchEvent(new mySocketEvent("error"));
      }
      
      private function clearEvent() : void
      {
         if(socket != null)
         {
            if(socket.hasEventListener("ioError"))
            {
               socket.removeEventListener("ioError",errorFun);
            }
            if(socket.hasEventListener("connect"))
            {
               socket.removeEventListener("connect",connectFun);
            }
            if(socket.hasEventListener("socketData"))
            {
               socket.removeEventListener("socketData",socketDataFun);
            }
            if(socket.hasEventListener("close"))
            {
               socket.removeEventListener("close",closeFun);
            }
            if(socket.hasEventListener("securityError"))
            {
               socket.removeEventListener("securityError",securityerrfun);
            }
         }
      }
   }
}

