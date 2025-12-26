package com.boyaa.antwars.view.monster
{
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.view.display.DlgMark;
   import com.boyaa.antwars.view.screen.copygame.boss.member.BossMonster;
   import flash.geom.Rectangle;
   import starling.display.Button;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class MonsterInfoDlg extends Sprite
   {
      
      private var txt0:TextField;
      
      private var txt1:TextField;
      
      private var txt2:TextField;
      
      private var txt3:TextField;
      
      private var txt4:TextField;
      
      private var txt5:TextField;
      
      private var txt6:TextField;
      
      private var txt7:TextField;
      
      private var markBg:DlgMark;
      
      private var txtSprite:Sprite;
      
      private var rect:Rectangle;
      
      private var monster:Monster;
      
      private var _dic:Object = {};
      
      private var _bossMonster:BossMonster;
      
      public function MonsterInfoDlg()
      {
         super();
         addEventListener("addedToStage",addedToStage);
         init();
         setDicAboutMonster();
      }
      
      private function setDicAboutMonster() : void
      {
         _dic["Zhizhusheshou"] = {
            "skill":LangManager.ta("monsterSkillDesc")[0],
            "hurt":LangManager.t("normal")
         };
         _dic["Zhizhushouwei"] = {
            "skill":LangManager.ta("monsterSkillDesc")[1],
            "hurt":LangManager.t("normal")
         };
         _dic["Zhizhucike"] = {
            "skill":LangManager.ta("monsterSkillDesc")[2],
            "hurt":LangManager.t("normal")
         };
         _dic["Zhizhujiangjun"] = {
            "skill":LangManager.ta("monsterSkillDesc")[3],
            "hurt":LangManager.t("unbelievable")
         };
         _dic["Xiaomaomaochong"] = {
            "skill":LangManager.ta("monsterSkillDesc")[4],
            "hurt":LangManager.t("normal")
         };
         _dic["Zhongmaomaochong"] = {
            "skill":LangManager.ta("monsterSkillDesc")[5],
            "hurt":LangManager.t("normal")
         };
         _dic["Damaomaochong"] = {
            "skill":LangManager.ta("monsterSkillDesc")[6],
            "hurt":LangManager.t("normal")
         };
         _dic["Zhunhuang"] = {
            "skill":LangManager.ta("monsterSkillDesc")[7],
            "hurt":"Boss"
         };
         _dic["Leien"] = {
            "skill":LangManager.ta("monsterSkillDesc")[9],
            "hurt":"Boss"
         };
         _dic["Pomie"] = {
            "skill":LangManager.ta("monsterSkillDesc")[8],
            "hurt":LangManager.t("normal")
         };
         _dic["Tianmoyan"] = {
            "skill":LangManager.ta("monsterSkillDesc")[8],
            "hurt":LangManager.t("normal")
         };
         _dic["Dishayan"] = {
            "skill":LangManager.ta("monsterSkillDesc")[8],
            "hurt":LangManager.t("normal")
         };
      }
      
      private function init() : void
      {
         markBg = new DlgMark();
         var _loc1_:Image = new Image(Assets.sAsset.getTexture("wgtp"));
         _loc1_.touchable = false;
         Assets.positionDisplay(_loc1_,"monsterInfoDlg","bg");
         addChild(_loc1_);
         var _loc2_:Button = new Button(Assets.sAsset.getTexture("close"),"",Assets.sAsset.getTexture("close1"));
         _loc2_.addEventListener("triggered",onClose);
         Assets.positionDisplay(_loc2_,"monsterInfoDlg","btnClose");
         addChild(_loc2_);
         txtSprite = new Sprite();
         rect = Assets.getPosition("monsterInfoDlg","headImg");
         txt0 = new TextField(100,29,LangManager.t("biShaJi"),"Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt0,"monsterInfoDlg","txt0");
         txtSprite.addChild(txt0);
         txt1 = new TextField(130,60,LangManager.t("biShaJiName"),"Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt1,"monsterInfoDlg","txt1");
         txtSprite.addChild(txt1);
         txt1.autoScale = true;
         txt2 = new TextField(100,29,LangManager.t("reduceBlood") + ": ","Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt2,"monsterInfoDlg","txt2");
         txtSprite.addChild(txt2);
         txt3 = new TextField(130,29,LangManager.t("normal"),"Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt3,"monsterInfoDlg","txt3");
         txtSprite.addChild(txt3);
         txt4 = new TextField(100,29,LangManager.t("fight") + ": ","Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt4,"monsterInfoDlg","txt4");
         txtSprite.addChild(txt4);
         txt5 = new TextField(130,29,LangManager.t("unknow"),"Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt5,"monsterInfoDlg","txt5");
         txtSprite.addChild(txt5);
         txt6 = new TextField(220,200,"描述: ","Verdana",25,16777215);
         Assets.sAsset.positionDisplay(txt6,"monsterInfoDlg","txt6");
         txtSprite.addChild(txt6);
         txt7 = new TextField(250,34,LangManager.t("monster"),"Verdana",30,4660230);
         Assets.sAsset.positionDisplay(txt7,"monsterInfoDlg","txt7");
         txtSprite.addChild(txt7);
         txt0.hAlign = txt1.hAlign = txt2.hAlign = txt3.hAlign = txt4.hAlign = txt5.hAlign = txt6.hAlign = "left";
         txtSprite.touchable = false;
         addChild(txtSprite);
      }
      
      private function addedToStage(param1:Event) : void
      {
         parent.addChild(markBg);
         parent.swapChildren(markBg,this);
      }
      
      public function showMonsterInfo(param1:String, param2:String, param3:String, param4:MonsterData) : void
      {
         txt6.text = LangManager.t("describe") + param2;
         txt7.text = param1;
         txt1.text = _dic[param3].skill;
         txt3.text = _dic[param3].hurt;
         monster = MonsterFactory.instance.create(param3,param4);
         monster.setStatus("stand");
         monster.width = rect.width;
         monster.height = rect.height;
         if(param3 == "Tianmoyan" || param3 == "Dishayan" || param3 == "Pomie")
         {
            monster.x = rect.x;
            monster.y = rect.y;
         }
         else
         {
            monster.x = rect.x + monster.width / 5;
            monster.y = rect.y + monster.height / 3;
         }
         addChild(monster);
      }
      
      public function showBossInfo(param1:String, param2:String, param3:String, param4:MonsterData) : void
      {
         txt6.text = LangManager.t("describe") + param2;
         txt7.text = param1;
         txt1.text = _dic[param3].skill;
         txt3.text = _dic[param3].hurt;
         _bossMonster = BossMonster(MonsterFactory.instance.createBoss(param3,param4));
         if(param3 == "zhunhuang")
         {
            _bossMonster.setStatus("hangstand");
         }
         _bossMonster.touchable = false;
         _bossMonster.x = rect.x + _bossMonster.width / 4;
         _bossMonster.y = rect.y + _bossMonster.height / 2;
         addChild(_bossMonster);
      }
      
      private function onClose(param1:Event) : void
      {
         markBg.removeFromParent();
         monster && monster.removeFromParent();
         _bossMonster && _bossMonster.removeFromParent();
         removeFromParent();
      }
   }
}

