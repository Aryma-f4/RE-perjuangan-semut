package com.boyaa.antwarsId.function;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.boyaa.antwarsId.AntExtension;

/* loaded from: classes.dex */
public class SayHello implements FREFunction {
    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext arg0, FREObject[] arg1) {
        try {
            String str = arg1[0].getAsString();
            FREObject retObject = FREObject.newObject("hello " + str);
            AntExtension.logFlashMsg(str);
            return retObject;
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
            AntExtension.log("return sayhello function's null");
            return null;
        } catch (FRETypeMismatchException e2) {
            e2.printStackTrace();
            AntExtension.log("return sayhello function's null");
            return null;
        } catch (FREWrongThreadException e3) {
            e3.printStackTrace();
            AntExtension.log("return sayhello function's null");
            return null;
        } catch (IllegalStateException e4) {
            e4.printStackTrace();
            AntExtension.log("return sayhello function's null");
            return null;
        }
    }
}
