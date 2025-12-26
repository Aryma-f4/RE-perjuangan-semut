package com.codapayments.sdk.c;

import android.app.Activity;
import android.util.Log;
import java.io.IOException;
import java.util.Properties;

/* loaded from: classes.dex */
public final class j {
    private Activity a;
    private Properties b;

    /* JADX WARN: Multi-variable type inference failed */
    private j(Activity activity) {
        ((com.codapayments.sdk.a.a.b) this).b = activity;
        ((com.codapayments.sdk.a.a.b) this).c = new Properties();
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String a(String str) throws IOException {
        String str2;
        String property;
        try {
            ((com.codapayments.sdk.a.a.b) this).c.load(((com.codapayments.sdk.a.a.b) this).b.getAssets().open("codapayment.properties"));
            property = "apikey";
        } catch (Exception e) {
            e = e;
            str2 = str;
        }
        try {
            if (str == "apikey") {
                property = ((com.codapayments.sdk.a.a.b) this).c.getProperty("apikey");
                Log.i(f.c, "API Key : " + property);
            } else if (str == "merchant") {
                property = ((com.codapayments.sdk.a.a.b) this).c.getProperty("merchant");
                Log.i(f.c, "Merchant : " + property);
            } else if (str == "country") {
                property = ((com.codapayments.sdk.a.a.b) this).c.getProperty("country");
                Log.i(f.c, "Country : " + property);
            } else {
                if (str != "currency") {
                    property = str;
                    return property;
                }
                property = ((com.codapayments.sdk.a.a.b) this).c.getProperty("currency");
                Log.i(f.c, "Currency : " + property);
            }
            return property;
        } catch (Exception e2) {
            str2 = property;
            e = e2;
            e.printStackTrace();
            return str2;
        }
    }
}
