package com.freshplanet.ane.AirFacebook.functions;

import android.os.Bundle;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirFacebook.AirFacebookExtension;
import com.freshplanet.ane.AirFacebook.AirFacebookExtensionContext;
import java.util.ArrayList;
import java.util.List;

/* loaded from: classes.dex */
public class BaseFunction implements FREFunction {
    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext fREContext, FREObject[] fREObjectArr) {
        AirFacebookExtension.context = (AirFacebookExtensionContext) fREContext;
        return null;
    }

    protected Boolean getBooleanFromFREObject(FREObject fREObject) {
        try {
            return Boolean.valueOf(fREObject.getAsBool());
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    protected Bundle getBundleOfStringFromFREArrays(FREArray fREArray, FREArray fREArray2) {
        Bundle bundle = new Bundle();
        try {
            long jMin = Math.min(fREArray.getLength(), fREArray2.getLength());
            for (int i = 0; i < jMin; i++) {
                try {
                    bundle.putString(getStringFromFREObject(fREArray.getObjectAt(i)), getStringFromFREObject(fREArray2.getObjectAt(i)));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            return bundle;
        } catch (Exception e2) {
            e2.printStackTrace();
            return null;
        }
    }

    protected List<String> getListOfStringFromFREArray(FREArray fREArray) {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < fREArray.getLength(); i++) {
            try {
                try {
                    arrayList.add(getStringFromFREObject(fREArray.getObjectAt(i)));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
                return null;
            }
        }
        return arrayList;
    }

    protected String getStringFromFREObject(FREObject fREObject) {
        try {
            return fREObject.getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
