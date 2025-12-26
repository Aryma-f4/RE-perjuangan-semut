package com.freshplanet.ane.AirFacebook.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.facebook.widget.FacebookDialog;

/* loaded from: classes.dex */
public class CanPresentShareDialogFunction extends BaseFunction {
    @Override // com.freshplanet.ane.AirFacebook.functions.BaseFunction, com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        super.call(fREContext, fREObjectArr);
        try {
            return FREObject.newObject(FacebookDialog.canPresentShareDialog(fREContext.getActivity(), FacebookDialog.ShareDialogFeature.SHARE_DIALOG));
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
            return null;
        } catch (IllegalStateException e2) {
            e2.printStackTrace();
            return null;
        }
    }
}
