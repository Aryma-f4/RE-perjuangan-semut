package com.freshplanet.ane.AirFacebook.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;

/* loaded from: classes.dex */
public class RequestWithGraphPathFunction extends BaseFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        AirFacebookExtension.context.launchRequestThread(getStringFromFREObject(fREObjectArr[0]), getBundleOfStringFromFREArrays((FREArray) fREObjectArr[1], (FREArray) fREObjectArr[2]), getStringFromFREObject(fREObjectArr[3]), getStringFromFREObject(fREObjectArr[4]));
        return null;
    }
}
