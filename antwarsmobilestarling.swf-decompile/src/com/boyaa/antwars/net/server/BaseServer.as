package com.boyaa.antwars.net.server
{
   import com.boyaa.antwars.net.net.mySocket;
   import com.boyaa.antwars.net.net.mySocketEvent;
   import flash.utils.getQualifiedClassName;
   import org.osflash.signals.Signal;
   
   public class BaseServer
   {
      
      public static const CONNECT:String = "Connect";
      
      public static const ERROR:String = "Error";
      
      public static const SECURITYERROR:String = "SecurityError";
      
      public static const CLOSE:String = "Close";
      
      public var socketSignal:Signal = null;
      
      protected var _host:String = "";
      
      protected var _port:int = 0;
      
      protected var _isConnect:Boolean = false;
      
      protected var _mySocket:mySocket = null;
      
      protected var _recv:ProcessCmd = null;
      
      protected var _send:SendCmd = null;
      
      protected var initiativeClose:Boolean = false;
      
      public function BaseServer()
      {
         super();
         socketSignal = new Signal(String);
      }
      
      public function init(param1:String, param2:int) : void
      {
         _host = param1;
         _port = param2;
         _mySocket = new mySocket();
         _mySocket.addEventListener("connect",onConnect);
         _mySocket.addEventListener("error",onErr);
         _mySocket.addEventListener("sync",onData);
         _mySocket.addEventListener("close",onClose);
         _mySocket.addEventListener("securityerror",onSecurityerr);
         _recv = new ProcessCmd(_mySocket);
         var _loc3_:String = getQualifiedClassName(this);
         _recv.RegisterCMDFun(_loc3_.substr(_loc3_.indexOf("::") + 2));
         _send = new SendCmd(_mySocket);
      }
      
      public function disposeRecvFunAll() : void
      {
         _recv.disposeFunAll();
      }
      
      public function disposeRecvFun(param1:Function) : void
      {
         _recv.disposeFun(param1);
      }
      
      public function get recv() : ProcessCmd
      {
         return _recv;
      }
      
      public function get send() : SendCmd
      {
         return _send;
      }
      
      public function connect() : void
      {
         initiativeClose = false;
         if(_isConnect == false)
         {
            _mySocket.connect(_host,_port);
         }
      }
      
      public function close() : void
      {
         Application.instance.log("Close Server--------",_host.toString() + ":" + _port.toString() + "class type:" + getQualifiedClassName(this));
         if(_isConnect)
         {
            _isConnect = false;
            _mySocket.close();
            initiativeClose = true;
         }
      }
      
      public function setClose() : void
      {
         initiativeClose = true;
      }
      
      protected function onData(param1:mySocketEvent) : void
      {
         param1 = null;
         _recv.ProcessServerCMD(_mySocket.getcmd());
      }
      
      protected function onErr(param1:mySocketEvent) : void
      {
         socketSignal.dispatch("Error");
      }
      
      protected function onClose(param1:mySocketEvent) : void
      {
         _isConnect = false;
         socketSignal.dispatch("Close");
         trace("close----------------close");
      }
      
      protected function onSecurityerr(param1:mySocketEvent) : void
      {
         socketSignal.dispatch("SecurityError");
      }
      
      protected function onConnect(param1:mySocketEvent) : void
      {
         _isConnect = true;
         socketSignal.dispatch("Connect");
      }
      
      public function get isConnect() : Boolean
      {
         return _isConnect;
      }
   }
}

