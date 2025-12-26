package com.boyaa.antwars.view.screen.union.office
{
   import com.boyaa.antwars.control.EventCenter;
   import com.boyaa.antwars.control.UnionManager;
   import com.boyaa.antwars.data.AccountData;
   import com.boyaa.antwars.events.PHPEvent;
   import com.boyaa.antwars.lang.LangManager;
   import com.boyaa.antwars.net.Remoting;
   import com.boyaa.antwars.view.TextTip;
   import com.boyaa.antwars.view.screen.union.UnionEvent;
   import com.boyaa.antwars.view.screen.union.commonBtn.UnionCheckBoxEvent;
   import com.boyaa.antwars.view.screen.union.commonBtn.UnionManagerCheckBox;
   import com.boyaa.tool.DisplayUtil;
   import com.boyaa.tool.LoadData;
   import feathers.controls.TextInput;
   import starling.display.Button;
   import starling.events.Event;
   import starling.text.TextField;
   
   public class UnionManagerDonateDlg extends UnionManagerLittleBaseDlg
   {
      
      private var _exchange:UnionManagerCheckBox;
      
      private var _donateBtn:UnionManagerCheckBox;
      
      private var _checkBtns:Array;
      
      private var _unionManagerAllBtn:Button;
      
      private var _inputNumTF:TextInput;
      
      private var _submitBtn:Button;
      
      private var _contributeTxt1:TextField;
      
      private var _contributeTxt2:TextField;
      
      private var _endowType:int;
      
      private const BOYAA_TO_SELF:int = 0;
      
      private const SELF_TO_UNION:int = 2;
      
      public function UnionManagerDonateDlg()
      {
         super("unionManagerDonateLayout");
         _exchange = new UnionManagerCheckBox();
         this._displayObj.addChild(_exchange);
         _exchange.addEventListener(UnionCheckBoxEvent.SELECT,itemSelect);
         _exchange.x = 165;
         _exchange.y = 119;
         _donateBtn = new UnionManagerCheckBox();
         _displayObj.addChild(_donateBtn);
         _donateBtn.addEventListener(UnionCheckBoxEvent.SELECT,itemSelect);
         _donateBtn.x = 435;
         _donateBtn.y = 119;
         _unionManagerAllBtn = _displayObj.getChildByName("btnS_unionManagerAllBtn") as Button;
         _unionManagerAllBtn.addEventListener("triggered",unionManagerAllHandel);
         _submitBtn = _displayObj.getChildByName("btnS_unionManagerSubmitBtn") as Button;
         _submitBtn.addEventListener("triggered",unionManagerSubmitHandel);
         _inputNumTF = DisplayUtil.createInputTextByTextField(getTextFieldByName("numTF"));
         _displayObj.addChild(_inputNumTF);
         _inputNumTF.restrict = "0-9";
         _contributeTxt1 = getTextFieldByName("personTF");
         _contributeTxt2 = getTextFieldByName("unionTF");
         _inputNumTF.text = "";
         _contributeTxt1.text = UnionManager.getInstance().myUnionModel.mdevote + "";
         _contributeTxt2.text = UnionManager.getInstance().myUnionModel.cdevote + "";
         _inputNumTF.addEventListener("focusOut",onInputEnterHandle);
         _exchange.select = true;
         _endowType = 0;
         getTextFieldByName("nameTxt0").text = LangManager.t("unionDonateTip2") + ": ";
         getTextFieldByName("nameTxt1").text = LangManager.t("unionDonateTip0") + ": ";
         _contributeTxt1.text = "0";
         _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.mdevote;
      }
      
      private function onInputEnterHandle(param1:Event) : void
      {
         Application.instance.log("input","输入完成");
         switch(_endowType)
         {
            case 0:
               if(int(_inputNumTF.text) >= AccountData.instance.boyaaCoin || _inputNumTF.text.length >= 9)
               {
                  _inputNumTF.text = AccountData.instance.boyaaCoin.toString();
               }
               _contributeTxt1.text = getContributeInBoyaa(int(_inputNumTF.text)).toString();
               _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.mdevote + "+" + getContributeInBoyaa(int(_inputNumTF.text));
               break;
            case 2:
               if(int(_inputNumTF.text) >= UnionManager.getInstance().myUnionModel.mdevote || _inputNumTF.text.length >= 9)
               {
                  _inputNumTF.text = UnionManager.getInstance().myUnionModel.mdevote.toString();
               }
               _contributeTxt1.text = String(UnionManager.getInstance().myUnionModel.mdevote - int(_inputNumTF.text));
               _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.cdevote + "+" + _inputNumTF.text;
         }
      }
      
      private function endowUnionHandler(param1:PHPEvent) : void
      {
         LoadData.hide();
         param1.currentTarget.removeEventListener(param1.type,arguments.callee);
         var _loc3_:Object = JSON.parse(param1.param as String);
         if(_loc3_.ret == 0)
         {
            switch(_endowType)
            {
               case 0:
                  if(_loc3_.cinfo.cdevote > UnionManager.getInstance().myUnionModel.cdevote || _loc3_.minfo.mdevote > UnionManager.getInstance().myUnionModel.mdevote)
                  {
                     TextTip.instance.show(LangManager.getLang.getLangByStr("endowOK"));
                  }
                  _contributeTxt1.text = "0";
                  _contributeTxt2.text = _loc3_.minfo.mdevote;
                  break;
               case 2:
                  TextTip.instance.show(LangManager.getLang.getLangByStr("endowOK"));
                  _contributeTxt1.text = _loc3_.minfo.mdevote;
                  _contributeTxt2.text = _loc3_.cinfo.cdevote;
            }
            _inputNumTF.text = "0";
            UnionManager.getInstance().myUnionModel.cdevote = _loc3_.cinfo.cdevote;
            UnionManager.getInstance().myUnionModel.mdevote = _loc3_.minfo.mdevote;
         }
         else
         {
            TextTip.instance.showByLang("yourContributorLess");
         }
         UnionManager.getInstance().dispatchEvent(new UnionEvent(UnionEvent.UNION_DATA_REFRESH));
      }
      
      private function unionManagerSubmitHandel(param1:Event) : void
      {
         LoadData.show(this);
         var _loc2_:Array = [int(_inputNumTF.text),_endowType];
         EventCenter.PHPEvent.addEventListener("endowUnion",endowUnionHandler);
         Remoting.instance.gameTable.endowUnion(_loc2_);
      }
      
      private function getContributeInBoyaa(param1:int) : int
      {
         return param1 * 1;
      }
      
      private function unionManagerAllHandel(param1:Event) : void
      {
         switch(_endowType)
         {
            case 0:
               _inputNumTF.text = "" + AccountData.instance.boyaaCoin;
               _contributeTxt1.text = "" + getContributeInBoyaa(AccountData.instance.boyaaCoin);
               _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.mdevote + "+" + getContributeInBoyaa(AccountData.instance.boyaaCoin);
               break;
            case 2:
               _inputNumTF.text = "" + UnionManager.getInstance().myUnionModel.mdevote;
               _contributeTxt1.text = "0";
               _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.cdevote + "+" + UnionManager.getInstance().myUnionModel.mdevote;
         }
      }
      
      private function itemSelect(param1:UnionCheckBoxEvent) : void
      {
         cleanSelect();
         (param1.target as UnionManagerCheckBox).select = true;
         if(param1.target as UnionManagerCheckBox == this._donateBtn)
         {
            _endowType = 2;
            getTextFieldByName("nameTxt0").text = LangManager.t("unionDonateTip0") + ": ";
            getTextFieldByName("nameTxt1").text = LangManager.t("unionDonateTip1") + ": ";
            _contributeTxt1.text = "" + UnionManager.getInstance().myUnionModel.mdevote;
            _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.cdevote;
         }
         else
         {
            _endowType = 0;
            getTextFieldByName("nameTxt0").text = LangManager.t("unionDonateTip2") + ": ";
            getTextFieldByName("nameTxt1").text = LangManager.t("unionDonateTip0") + ": ";
            _contributeTxt1.text = "0";
            _contributeTxt2.text = "" + UnionManager.getInstance().myUnionModel.mdevote;
         }
      }
      
      private function cleanSelect() : void
      {
         _exchange.select = false;
         _donateBtn.select = false;
         _inputNumTF.text = "";
         _contributeTxt1.text = "";
         _contributeTxt2.text = "";
      }
   }
}

