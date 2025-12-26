package com.boyaa.antwars.data
{
   import com.boyaa.antwars.lang.LangManager;
   
   public class UnionListItemModel extends BaseModel
   {
      
      private var _cid:int = 0;
      
      private var _captionmid:int = 0;
      
      private var _cname:String = "";
      
      private var _unionIntro:String = "";
      
      private var _memnum:int = 0;
      
      private var _reqlevel:int = 0;
      
      private var _reqcap:int = 0;
      
      private var _cdevote:int = 0;
      
      private var _chonour:int = 0;
      
      private var _clevel:int = 0;
      
      private var _smithylevel:int = 0;
      
      private var _shoplevel:int = 0;
      
      private var _storelevel:int = 0;
      
      private var _ctime:int = 0;
      
      private var _honorName:Object = null;
      
      private var _chairmanName:String = "";
      
      private var _statue:int = 0;
      
      private var _buildValue:int = 0;
      
      private var _applynum:int = 0;
      
      private var _position:int = 0;
      
      private var _mdevote:int = 0;
      
      private var _mhonour:int = 0;
      
      public function UnionListItemModel()
      {
         super();
      }
      
      public function createData(param1:Object) : void
      {
         _honorName = {};
         if(param1.cid != undefined)
         {
            _cid = param1.cid;
         }
         if(param1.conf != undefined)
         {
            if(param1.conf["1"] != undefined)
            {
               _honorName.fir = param1.conf["1"];
            }
            else
            {
               _honorName.fir = LangManager.getLang.getLangByStr("chairman");
            }
            if(param1.conf["2"] != undefined)
            {
               _honorName.sec = param1.conf["2"];
            }
            else
            {
               _honorName.sec = LangManager.getLang.getLangByStr("vicechairman");
            }
            if(param1.conf["8"] != undefined)
            {
               _honorName.thir = param1.conf["8"];
            }
            else
            {
               _honorName.thir = LangManager.getLang.getLangByStr("goodMember");
            }
            if(param1.conf["9"] != undefined)
            {
               _honorName.four = param1.conf["9"];
            }
            else
            {
               _honorName.four = LangManager.getLang.getLangByStr("commonMember");
            }
         }
         else
         {
            _honorName.fir = LangManager.getLang.getLangByStr("chairman");
            _honorName.sec = LangManager.getLang.getLangByStr("vicechairman");
            _honorName.thir = LangManager.getLang.getLangByStr("goodMember");
            _honorName.four = LangManager.getLang.getLangByStr("commonMember");
         }
         if(param1.cdesc != undefined)
         {
            _unionIntro = param1.cdesc;
         }
         if(param1.total != undefined)
         {
            _buildValue = param1.total;
         }
         _cname = param1.cname;
         _captionmid = param1.captainmid;
         _memnum = param1.memnum;
         _reqlevel = param1.reqlevel;
         _reqcap = param1.reqcap;
         _cdevote = param1.cdevote;
         _chonour = param1.chonour;
         _clevel = param1.clevel;
         _smithylevel = param1.smithylevel;
         _shoplevel = param1.shoplevel;
         _storelevel = param1.storelevel;
         _ctime = param1.ctime;
         _statue = param1.statue;
         _chairmanName = param1.vcaptain;
         _applynum = param1.applynum;
      }
      
      public function selfInUnionData(param1:Object) : void
      {
         _position = param1.position;
         _mdevote = param1.mdevote;
         _mhonour = param1.mhonour;
      }
      
      public function get reqlevel() : int
      {
         return _reqlevel;
      }
      
      public function set reqlevel(param1:int) : void
      {
         _reqlevel = param1;
      }
      
      public function get reqcap() : int
      {
         return _reqcap;
      }
      
      public function set reqcap(param1:int) : void
      {
         _reqcap = param1;
      }
      
      public function get chonour() : int
      {
         return _chonour;
      }
      
      public function get ctime() : int
      {
         return _ctime;
      }
      
      public function get mhonour() : int
      {
         return _mhonour;
      }
      
      public function get memnum() : int
      {
         return _memnum;
      }
      
      public function get cname() : String
      {
         return _cname;
      }
      
      public function get cid() : int
      {
         return _cid;
      }
      
      public function get chairmanName() : String
      {
         return _chairmanName;
      }
      
      public function get honorName() : Object
      {
         return _honorName;
      }
      
      public function set honorName(param1:Object) : void
      {
         _honorName = param1;
      }
      
      public function get position() : int
      {
         return _position;
      }
      
      public function set position(param1:int) : void
      {
         _position = param1;
      }
      
      public function get unionIntro() : String
      {
         return _unionIntro;
      }
      
      public function set unionIntro(param1:String) : void
      {
         _unionIntro = param1;
      }
      
      public function get clevel() : int
      {
         return _clevel;
      }
      
      public function set clevel(param1:int) : void
      {
         _clevel = param1;
      }
      
      public function get smithylevel() : int
      {
         return _smithylevel;
      }
      
      public function set smithylevel(param1:int) : void
      {
         _smithylevel = param1;
      }
      
      public function get shoplevel() : int
      {
         return _shoplevel;
      }
      
      public function set shoplevel(param1:int) : void
      {
         _shoplevel = param1;
      }
      
      public function get storelevel() : int
      {
         return _storelevel;
      }
      
      public function set storelevel(param1:int) : void
      {
         _storelevel = param1;
      }
      
      public function get mdevote() : int
      {
         return _mdevote;
      }
      
      public function set mdevote(param1:int) : void
      {
         _mdevote = param1;
      }
      
      public function get captionmid() : int
      {
         return _captionmid;
      }
      
      public function set captionmid(param1:int) : void
      {
         _captionmid = param1;
      }
      
      public function get cdevote() : int
      {
         return _cdevote;
      }
      
      public function set cdevote(param1:int) : void
      {
         _cdevote = param1;
      }
      
      public function get statue() : int
      {
         return _statue;
      }
      
      public function set statue(param1:int) : void
      {
         _statue = param1;
      }
      
      public function get buildValue() : int
      {
         return _buildValue;
      }
      
      public function get applynum() : int
      {
         return _applynum;
      }
   }
}

