package com.adobe.air;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import com.adobe.air.utils.Utils;

/* loaded from: classes.dex */
public final class AIRSharedPref {
    private static final String LOG_TAG = "AIRSharedPref";
    private static String SP_CONFIG_REQUEST_TIME = "AIRSharedPref.ConfigRequestTime";
    private static String SP_CONFIG_REQUEST_TIME_DEFAULT = null;
    private static String SP_CONFIG_DATA = "AIRSharedPref.ConfigData";
    private static String SP_CONFIG_DATA_DEFAULT = "\n";

    private static String getPreferencesKey() {
        return Utils.getRuntimePackageName() + ".AIRSharedPref";
    }

    public static String getConfigRequestTime(Context context) {
        String string = SP_CONFIG_REQUEST_TIME_DEFAULT;
        try {
            string = context.createPackageContext(Utils.getRuntimePackageName(), 4).getSharedPreferences(getPreferencesKey(), 1).getString(SP_CONFIG_REQUEST_TIME, SP_CONFIG_REQUEST_TIME_DEFAULT);
        } catch (PackageManager.NameNotFoundException e) {
        } catch (ClassCastException e2) {
        }
        if (string != SP_CONFIG_REQUEST_TIME_DEFAULT) {
        }
        return string;
    }

    public static String getConfigData(Context context) {
        String string = SP_CONFIG_DATA_DEFAULT;
        try {
            string = context.createPackageContext(Utils.getRuntimePackageName(), 4).getSharedPreferences(getPreferencesKey(), 1).getString(SP_CONFIG_DATA, SP_CONFIG_DATA_DEFAULT);
        } catch (PackageManager.NameNotFoundException e) {
        } catch (ClassCastException e2) {
        }
        if (string != SP_CONFIG_DATA_DEFAULT) {
        }
        return string;
    }

    public static boolean setConfigRequestTime(Context context, String str) {
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(getPreferencesKey(), 1).edit();
        editorEdit.putString(SP_CONFIG_REQUEST_TIME, str);
        return editorEdit.commit();
    }

    public static boolean setConfigData(Context context, String str) {
        SharedPreferences.Editor editorEdit = context.getSharedPreferences(getPreferencesKey(), 1).edit();
        editorEdit.putString(SP_CONFIG_DATA, str);
        return editorEdit.commit();
    }
}
