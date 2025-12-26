package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossCtrl;
   
   public class MonsterAttrQueue
   {
      
      private var _list:Vector.<IMonsterCtrl> = new Vector.<IMonsterCtrl>();
      
      private var _callbackstart:Boolean = false;
      
      public function MonsterAttrQueue()
      {
         super();
      }
      
      public function push(param1:IMonsterCtrl) : void
      {
         _list.push(param1);
         if(param1 is MonsterCtrl)
         {
            trace("怪物 siteID：" + MonsterCtrl(param1).siteID,"角色ID:" + MonsterCtrl(param1)._monster.data.roleid," WantAttack MonsterAttrQueue.length " + _list.length);
         }
         else
         {
            trace("BOSS siteID：" + BossCtrl(param1).siteID," WantAttack MonsterAttrQueue.length " + _list.length);
         }
      }
      
      public function start() : void
      {
         if(!_callbackstart)
         {
            if(_list.length > 0)
            {
               _callbackstart = true;
               pop();
            }
         }
      }
      
      public function pop() : void
      {
         var _loc1_:IMonsterCtrl = _list.shift();
         _loc1_.actionCompleteSignal.addOnce(attackComplete);
         _loc1_.attackAction();
         if(_loc1_ is MonsterCtrl)
         {
            trace("MonsterAtttrQueue Pop, monster site",MonsterCtrl(_loc1_).siteID,"type:",MonsterCtrl(_loc1_)._monster.data.attack_type);
         }
         else
         {
            trace("MonsterAtttrQueue Pop, monster site",BossCtrl(_loc1_).siteID,"type:",BossCtrl(_loc1_).monster.data.attack_type);
         }
      }
      
      public function clear() : void
      {
         var _loc2_:int = 0;
         var _loc1_:IMonsterCtrl = null;
         trace("MonsterAtttrQueue clear, list\'s length",_list.length);
         _loc2_ = 0;
         while(_loc2_ < _list.length)
         {
            _loc1_ = _list[_loc2_];
            _loc1_.actionCompleteSignal.remove(attackComplete);
            _loc2_++;
         }
         _list.length = 0;
         _callbackstart = false;
      }
      
      private function attackComplete() : void
      {
         trace("attackComplete list\'s length " + _list.length);
         if(_list.length > 0)
         {
            pop();
         }
         else
         {
            _callbackstart = false;
         }
      }
      
      public function get callbackstart() : Boolean
      {
         return _callbackstart;
      }
   }
}

