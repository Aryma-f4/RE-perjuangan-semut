package com.freshplanet.alert.functions;

import android.annotation.TargetApi;
import android.app.AlertDialog;
import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.alert.Extension;

@TargetApi(14)
/* loaded from: classes.dex */
public class AirAlertShowAlert implements FREFunction {
    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        try {
            String asString = fREObjectArr[0].getAsString();
            String asString2 = fREObjectArr[1].getAsString();
            String asString3 = fREObjectArr[2].getAsString();
            String asString4 = fREObjectArr.length > 3 ? fREObjectArr[3].getAsString() : null;
            AlertDialog.Builder builder = Build.VERSION.SDK_INT >= 14 ? new AlertDialog.Builder(fREContext.getActivity(), 4) : Build.VERSION.SDK_INT >= 11 ? new AlertDialog.Builder(fREContext.getActivity(), 2) : new AlertDialog.Builder(fREContext.getActivity());
            builder.setTitle(asString).setMessage(asString2).setNeutralButton(asString3, Extension.context);
            if (asString4 != null) {
                builder.setPositiveButton(asString4, Extension.context);
            }
            builder.show();
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
