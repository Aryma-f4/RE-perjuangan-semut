package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.tool.DisplayUtil;
   import com.boyaa.tool.LoadData;
   import feathers.controls.TextInput;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UnionManagerApplyInfoDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _inputReqlevelTF:TextInput;
      
      private var _inputReqcapTF:TextInput;
      
      private var _unionManagerSubmitBtn:Button;
      
      private var _beforeLevel:int;
      
      private var _beforeFight:int;
      
      public function UnionManagerApplyInfoDlg()
      {
         super("unionManagerApplyInfoLayout");
         (_displayObj.getChildByName("reqlevelTF") as TextField).text = "";
         (_displayObj.getChildByName("reqcapTF") as TextField).text = "";
         _inputReqlevelTF = DisplayUtil.createInputTextByTextField(_displayObj.getChildByName("reqlevelTF") as TextField);
         this._displayObj.addChild(_inputReqlevelTF);
         _inputReqcapTF = DisplayUtil.createInputTextByTextField(_displayObj.getChildByName("reqcapTF") as TextField);
         this._displayObj.addChild(_inputReqcapTF);
         _unionData = UnionManager.getInstance().myUnionModel;
         _inputReqcapTF.text = _unionData.reqcap + "";
         _inputReqlevelTF.text = _unionData.reqlevel + "";
         _beforeLevel = _unionData.reqlevel;
         _beforeFight = _unionData.reqcap;
         _unionManagerSubmitBtn = _displayObj.getChildByName("submitBtn") as Button;
         _unionManagerSubmitBtn.addEventListener("triggered",applyInfoChangeHandel);
      }
      
      private function applyInfoChangeHandel(param1:Event) : void
      {
         if(_inputReqcapTF.text == "" && _inputReqlevelTF.text == "")
         {
            TextTip.instance.showByLang("writeApplyRestrict");
            return;
         }
         if(int(_inputReqlevelTF.text) >= 45)
         {
            TextTip.instance.showByLang("levelNotOverforty");
            return;
         }
         if(int(_inputReqcapTF.text) > 110000)
         {
            TextTip.instance.showByLang("fightNotOver");
            return;
         }
         var _loc2_:Object = {};
         _loc2_.reqlevel = _inputReqlevelTF.text;
         _loc2_.reqcap = _inputReqcapTF.text;
         _loc2_.able = 1;
         if(_beforeLevel == int(_inputReqlevelTF.text) && _beforeFight == int(_inputReqcapTF.text))
         {
            this.onclose(null);
            return;
         }
         LoadData.show(this);
         EventCenter.PHPEvent.addEventListener("editUnionLimit",editUnionLimitHandler);
         Remoting.instance.gameTable.editUnionlimit(_loc2_);
      }
      
      private function editUnionLimitHandler(param1:PHPEvent) : void
      {
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         LoadData.hide();
         if(_loc3_.ret == 0)
         {
            TextTip.instance.showByLang("editOK");
            _unionData.reqlevel = int(_inputReqlevelTF.text);
            _unionData.reqcap = int(_inputReqcapTF.text);
            onclose(null);
            return;
         }
         throw new Error(_loc3_.msg);
      }
   }
}

