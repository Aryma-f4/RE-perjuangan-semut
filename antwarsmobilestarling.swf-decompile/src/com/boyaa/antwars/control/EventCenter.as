package com.boyaa.antwars.control
{
   import flash.events.EventDispatcher;
   
   public class EventCenter
   {
      
      public static const SocketEvent:EventDispatcher = new EventDispatcher();
      
      public static const PHPEvent:EventDispatcher = new EventDispatcher();
      
      public static const GameEvent:EventDispatcher = new EventDispatcher();
      
      public static const menuDispatcher:EventDispatcher = new EventDispatcher();
      
      public static const HomeEvent:EventDispatcher = new EventDispatcher();
      
      public static const DuplicateEvent:EventDispatcher = new EventDispatcher();
      
      public static const AuctionEvent:EventDispatcher = new EventDispatcher();
      
      public function EventCenter()
      {
         super();
      }
   }
}

