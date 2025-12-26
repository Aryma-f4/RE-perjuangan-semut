package com.freshplanet.ane.AirFacebook.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;

/* loaded from: classes.dex */
public class IsSessionOpenFunction extends BaseFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        try {
            return FREObject.newObject(AirFacebookExtension.context.getSession().isOpened());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
