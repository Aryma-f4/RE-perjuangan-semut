package com.boyaa.antwarsId;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/* loaded from: classes.dex */
public class AntExtension implements FREExtension {
    public static final String GOOGLE_RESULT = "GOOGLE_RESULT";
    public static final String MIMOPAY_RESULT = "MIMOPAY_RESULT";
    private static String TAG = "[ANTWARS_MOBILE_ID]";
    private static Boolean PRINT_LOG = true;
    public static FREContext context = null;
    private static int myver = 7;

    @Override // com.adobe.fre.FREExtension
    public FREContext createContext(String arg0) {
        log("Extension.createContext, myVersionId:" + myver);
        context = new AntContext();
        return context;
    }

    @Override // com.adobe.fre.FREExtension
    public void dispose() {
    }

    @Override // com.adobe.fre.FREExtension
    public void initialize() {
    }

    public static void log(String message) {
        if (PRINT_LOG.booleanValue()) {
            Log.d(TAG, message);
        }
        if (context == null || message == null) {
            return;
        }
        context.dispatchStatusEventAsync("LOGGING", message);
    }

    public static void logFlashMsg(String msg) {
        if (PRINT_LOG.booleanValue()) {
            Log.d("FLASH_MSG", msg);
        }
    }

    public static void logCodaPayMsg(String msg) {
        if (PRINT_LOG.booleanValue()) {
            Log.d("CODAPAY_MSG", msg);
        }
    }

    public static Context getAndroidContext() {
        if (context != null) {
            return context.getActivity().getBaseContext();
        }
        return null;
    }

    public static void showToastMessage(String msg) {
        Toast.makeText(getAndroidContext(), msg, 1).show();
    }
}
