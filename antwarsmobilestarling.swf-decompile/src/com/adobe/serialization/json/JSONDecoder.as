package com.adobe.serialization.json
{
   public class JSONDecoder
   {
      
      private var value:*;
      
      private var tokenizer:JSONTokenizer;
      
      private var token:JSONToken;
      
      public function JSONDecoder(param1:String)
      {
         super();
         tokenizer = new JSONTokenizer(param1);
         nextToken();
         value = parseValue();
      }
      
      public function getValue() : *
      {
         return value;
      }
      
      private function nextToken() : JSONToken
      {
         return token = tokenizer.getNextToken();
      }
      
      private function parseArray() : Array
      {
         var _loc1_:Array = [];
         nextToken();
         if(token.type == 4)
         {
            return _loc1_;
         }
         while(true)
         {
            _loc1_.push(parseValue());
            nextToken();
            if(token.type == 4)
            {
               break;
            }
            if(token.type == 0)
            {
               nextToken();
            }
            else
            {
               tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
         }
         return _loc1_;
      }
      
      private function parseObject() : Object
      {
         var _loc2_:String = null;
         var _loc1_:Object = {};
         nextToken();
         if(token.type == 2)
         {
            return _loc1_;
         }
         while(true)
         {
            if(token.type == 10)
            {
               _loc2_ = String(token.value);
               nextToken();
               if(token.type == 6)
               {
                  nextToken();
                  _loc1_[_loc2_] = parseValue();
                  nextToken();
                  if(token.type == 2)
                  {
                     break;
                  }
                  if(token.type == 0)
                  {
                     nextToken();
                  }
                  else
                  {
                     tokenizer.parseError("Expecting } or , but found " + token.value);
                  }
               }
               else
               {
                  tokenizer.parseError("Expecting : but found " + token.value);
               }
            }
            else
            {
               tokenizer.parseError("Expecting string but found " + token.value);
            }
         }
         return _loc1_;
      }
      
      private function parseValue() : Object
      {
         if(token == null)
         {
            tokenizer.parseError("Unexpected end of input");
         }
         switch(token.type - 1)
         {
            case 0:
               return parseObject();
            case 2:
               return parseArray();
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
               return token.value;
            default:
               tokenizer.parseError("Unexpected " + token.value);
               return null;
         }
      }
   }
}

