package com.freshplanet.ane.AirFacebook.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtensionContext;

/* loaded from: classes.dex */
public class SetUsingStage3dFunction extends BaseFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        ((AirFacebookExtensionContext) fREContext).usingStage3D = getBooleanFromFREObject(fREObjectArr[0]).booleanValue();
        return null;
    }
}
