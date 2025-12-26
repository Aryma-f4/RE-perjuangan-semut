package com.boyaa.antwarsId.function;

import android.content.Intent;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.boyaa.antwarsId.AntExtension;
import com.boyaa.antwarsId.GooglePlayPaymentActivity;

/* loaded from: classes.dex */
public class GoogleCheckFunction implements FREFunction {
    @Override // com.adobe.fre.FREFunction
    public FREObject call(FREContext context, FREObject[] arg1) {
        AntExtension.log("googleCheck");
        AntExtension.log("------------------------");
        String param = "";
        try {
            String productId = "productId:" + arg1[0].getAsString();
            String orderId = "orderId:" + arg1[1].getAsString();
            param = "{" + productId + "," + orderId + "}";
        } catch (FREInvalidObjectException e3) {
            e3.printStackTrace();
        } catch (FRETypeMismatchException e32) {
            e32.printStackTrace();
        } catch (FREWrongThreadException e33) {
            e33.printStackTrace();
        } catch (IllegalStateException e34) {
            e34.printStackTrace();
        }
        AntExtension.log("GoogleCheckFunction jump to GooglePlayPaymentActivity");
        Intent intent = new Intent();
        intent.setClass(context.getActivity(), GooglePlayPaymentActivity.class);
        intent.putExtra("google", param);
        try {
            context.getActivity().startActivity(intent);
        } catch (IllegalStateException e) {
            e.printStackTrace();
            AntExtension.log("startActivity error:" + e.getMessage());
        }
        AntExtension.log("GoogleCheckFunction jump Done");
        return null;
    }
}
