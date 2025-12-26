package com.adobe.serialization.json
{
   public class JSONTokenizer
   {
      
      private var obj:Object;
      
      private var jsonString:String;
      
      private var loc:int;
      
      private var ch:String;
      
      public function JSONTokenizer(param1:String)
      {
         super();
         jsonString = param1;
         loc = 0;
         nextChar();
      }
      
      public function getNextToken() : JSONToken
      {
         var _loc4_:String = null;
         var _loc3_:String = null;
         var _loc1_:String = null;
         var _loc2_:JSONToken = new JSONToken();
         skipIgnored();
         switch(ch)
         {
            case "{":
               _loc2_.type = 1;
               _loc2_.value = "{";
               nextChar();
               break;
            case "}":
               _loc2_.type = 2;
               _loc2_.value = "}";
               nextChar();
               break;
            case "[":
               _loc2_.type = 3;
               _loc2_.value = "[";
               nextChar();
               break;
            case "]":
               _loc2_.type = 4;
               _loc2_.value = "]";
               nextChar();
               break;
            case ",":
               _loc2_.type = 0;
               _loc2_.value = ",";
               nextChar();
               break;
            case ":":
               _loc2_.type = 6;
               _loc2_.value = ":";
               nextChar();
               break;
            case "t":
               _loc4_ = "t" + nextChar() + nextChar() + nextChar();
               if(_loc4_ == "true")
               {
                  _loc2_.type = 7;
                  _loc2_.value = true;
                  nextChar();
                  break;
               }
               parseError("Expecting \'true\' but found " + _loc4_);
               break;
            case "f":
               _loc3_ = "f" + nextChar() + nextChar() + nextChar() + nextChar();
               if(_loc3_ == "false")
               {
                  _loc2_.type = 8;
                  _loc2_.value = false;
                  nextChar();
                  break;
               }
               parseError("Expecting \'false\' but found " + _loc3_);
               break;
            case "n":
               _loc1_ = "n" + nextChar() + nextChar() + nextChar();
               if(_loc1_ == "null")
               {
                  _loc2_.type = 9;
                  _loc2_.value = null;
                  nextChar();
                  break;
               }
               parseError("Expecting \'null\' but found " + _loc1_);
               break;
            case "\"":
               _loc2_ = readString();
               break;
            default:
               if(isDigit(ch) || ch == "-")
               {
                  _loc2_ = readNumber();
                  break;
               }
               if(ch == "")
               {
                  return null;
               }
               parseError("Unexpected " + ch + " encountered");
         }
         return _loc2_;
      }
      
      private function readString() : JSONToken
      {
         var _loc1_:String = null;
         var _loc4_:int = 0;
         var _loc2_:JSONToken = new JSONToken();
         _loc2_.type = 10;
         var _loc3_:String = "";
         nextChar();
         while(ch != "\"" && ch != "")
         {
            if(ch == "\\")
            {
               nextChar();
               switch(ch)
               {
                  case "\"":
                     _loc3_ += "\"";
                     break;
                  case "/":
                     _loc3_ += "/";
                     break;
                  case "\\":
                     _loc3_ += "\\";
                     break;
                  case "b":
                     _loc3_ += "\b";
                     break;
                  case "f":
                     _loc3_ += "\f";
                     break;
                  case "n":
                     _loc3_ += "\n";
                     break;
                  case "r":
                     _loc3_ += "\r";
                     break;
                  case "t":
                     _loc3_ += "\t";
                     break;
                  case "u":
                     _loc1_ = "";
                     _loc4_ = 0;
                     while(_loc4_ < 4)
                     {
                        if(!isHexDigit(nextChar()))
                        {
                           parseError(" Excepted a hex digit, but found: " + ch);
                        }
                        _loc1_ += ch;
                        _loc4_++;
                     }
                     _loc3_ += String.fromCharCode(parseInt(_loc1_,16));
                     break;
                  default:
                     _loc3_ += "\\" + ch;
               }
            }
            else
            {
               _loc3_ += ch;
            }
            nextChar();
         }
         if(ch == "")
         {
            parseError("Unterminated string literal");
         }
         nextChar();
         _loc2_.value = _loc3_;
         return _loc2_;
      }
      
      private function readNumber() : JSONToken
      {
         var _loc3_:JSONToken = new JSONToken();
         _loc3_.type = 11;
         var _loc2_:String = "";
         if(ch == "-")
         {
            _loc2_ += "-";
            nextChar();
         }
         if(!isDigit(ch))
         {
            parseError("Expecting a digit");
         }
         if(ch == "0")
         {
            _loc2_ += ch;
            nextChar();
            if(isDigit(ch))
            {
               parseError("A digit cannot immediately follow 0");
            }
         }
         else
         {
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         if(ch == ".")
         {
            _loc2_ += ".";
            nextChar();
            if(!isDigit(ch))
            {
               parseError("Expecting a digit");
            }
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         if(ch == "e" || ch == "E")
         {
            _loc2_ += "e";
            nextChar();
            if(ch == "+" || ch == "-")
            {
               _loc2_ += ch;
               nextChar();
            }
            if(!isDigit(ch))
            {
               parseError("Scientific notation number needs exponent value");
            }
            while(isDigit(ch))
            {
               _loc2_ += ch;
               nextChar();
            }
         }
         var _loc1_:Number = Number(_loc2_);
         if(isFinite(_loc1_) && !isNaN(_loc1_))
         {
            _loc3_.value = _loc1_;
            return _loc3_;
         }
         parseError("Number " + _loc1_ + " is not valid!");
         return null;
      }
      
      private function nextChar() : String
      {
         return ch = jsonString.charAt(loc++);
      }
      
      private function skipIgnored() : void
      {
         skipWhite();
         skipComments();
         skipWhite();
      }
      
      private function skipComments() : void
      {
         if(ch == "/")
         {
            nextChar();
            switch(ch)
            {
               case "/":
                  do
                  {
                     nextChar();
                  }
                  while(ch != "\n" && ch != "");
                  
                  nextChar();
                  break;
               case "*":
                  nextChar();
                  while(true)
                  {
                     if(ch == "*")
                     {
                        nextChar();
                        if(ch == "/")
                        {
                           break;
                        }
                     }
                     else
                     {
                        nextChar();
                     }
                     if(ch == "")
                     {
                        parseError("Multi-line comment not closed");
                     }
                  }
                  nextChar();
                  break;
               default:
                  parseError("Unexpected " + ch + " encountered (expecting \'/\' or \'*\' )");
            }
         }
      }
      
      private function skipWhite() : void
      {
         while(isWhiteSpace(ch))
         {
            nextChar();
         }
      }
      
      private function isWhiteSpace(param1:String) : Boolean
      {
         return param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r";
      }
      
      private function isDigit(param1:String) : Boolean
      {
         return param1 >= "0" && param1 <= "9";
      }
      
      private function isHexDigit(param1:String) : Boolean
      {
         var _loc2_:String = param1.toUpperCase();
         return isDigit(param1) || _loc2_ >= "A" && _loc2_ <= "F";
      }
      
      public function parseError(param1:String) : void
      {
         throw new JSONParseError(param1,loc,jsonString);
      }
   }
}

