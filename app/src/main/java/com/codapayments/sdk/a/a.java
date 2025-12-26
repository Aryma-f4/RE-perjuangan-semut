package com.codapayments.sdk.a;

import android.content.Context;
import android.content.IntentFilter;
import android.util.Log;
import com.codapayments.sdk.CodaSDK;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.message.SMSReceiver;
import com.codapayments.sdk.model.b;
import com.codapayments.sdk.model.c;
import com.codapayments.sdk.model.d;
import com.codapayments.sdk.model.e;
import com.codapayments.sdk.model.g;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

/* loaded from: classes.dex */
public final class a {
    private static String e = "android.provider.Telephony.SMS_RECEIVED";
    private String a;
    private String b;
    private String c;
    private String d;
    private Context f;
    private CodaSDK g;
    private d h;
    private String i;
    private SMSReceiver j;
    private boolean k;

    private a(String str) {
        this.a = "http://stage.codapayments.com/airtime/m/init";
        this.b = "http://stage.codapayments.com/airtime/m/finit";
        this.c = "http://stage.codapayments.com/airtime/m/verifyotp";
        this.d = "http://stage.codapayments.com/airtime/m/inquiry";
        this.g = null;
        this.i = null;
        this.k = false;
        this.i = str;
        b(str);
    }

    private a(String str, CodaSDK codaSDK) {
        this.a = "http://stage.codapayments.com/airtime/m/init";
        this.b = "http://stage.codapayments.com/airtime/m/finit";
        this.c = "http://stage.codapayments.com/airtime/m/verifyotp";
        this.d = "http://stage.codapayments.com/airtime/m/inquiry";
        this.g = null;
        this.i = null;
        this.k = false;
        this.i = str;
        this.g = codaSDK;
        this.j = new SMSReceiver(codaSDK);
        if (codaSDK.b() != null) {
            this.f = codaSDK.b();
        }
        b(str);
    }

    public static a a(String str) {
        return new a(str);
    }

    public static a a(String str, CodaSDK codaSDK) {
        return new a(str, codaSDK);
    }

    private void a(d dVar) {
        this.h = dVar;
    }

    private b b(long j, String str) {
        try {
            String string = new StringBuffer("key=").append(str).append("&txnId=").append(j).toString();
            Log.i(f.x, "params " + string);
            String strA = com.codapayments.sdk.a.a.b.a(this.b, string);
            e();
            if (strA != null && strA.length() > 0) {
                String strB = com.codapayments.sdk.a.a.a.b(str, strA);
                Log.i(f.x, "respJson " + strB);
                return com.codapayments.sdk.message.a.b(strB);
            }
        } catch (IOException e2) {
            e2.printStackTrace();
            Log.e(f.x, "[ERROR] " + e2);
        } catch (InvalidKeyException e3) {
            e3.printStackTrace();
            Log.e(f.x, "[ERROR] " + e3);
        } catch (NoSuchAlgorithmException e4) {
            e4.printStackTrace();
            Log.e(f.x, "[ERROR] " + e4);
        } catch (BadPaddingException e5) {
            e5.printStackTrace();
            Log.e(f.x, "[ERROR] " + e5);
        } catch (IllegalBlockSizeException e6) {
            e6.printStackTrace();
            Log.e(f.x, "[ERROR] " + e6);
        } catch (NoSuchPaddingException e7) {
            e7.printStackTrace();
            Log.e(f.x, "[ERROR] " + e7);
        }
        return new b(j, null, 0.0d, null, (short) 999, "Not able to connect to CodaPay server", "Not able to connect to CodaPay server", null);
    }

    private void b(String str) {
        if ("Production".equalsIgnoreCase(str)) {
            this.a = "https://airtime.codapayments.com/airtime/m/init";
            this.b = "https://airtime.codapayments.com/airtime/m/finit";
            this.c = "https://airtime.codapayments.com/airtime/m/verifyotp";
            this.d = "https://airtime.codapayments.com/airtime/m/inquiry";
            return;
        }
        this.a = "http://stage.codapayments.com/airtime/m/init";
        this.b = "http://stage.codapayments.com/airtime/m/finit";
        this.c = "http://stage.codapayments.com/airtime/m/verifyotp";
        this.d = "http://stage.codapayments.com/airtime/m/inquiry";
    }

    private void c(String str) {
        this.i = str;
    }

    private void d() {
        this.f.registerReceiver(this.j, new IntentFilter(e));
        this.k = true;
    }

    private void e() {
        if (!this.k || this.g == null) {
            return;
        }
        this.f.unregisterReceiver(this.j);
        this.k = false;
    }

    public final b a() {
        return b(this.h.a(), this.h.e());
    }

    public final d a(String str, c cVar) {
        String strA = com.codapayments.sdk.message.a.a(cVar);
        Log.i(f.x, "reqJson : " + strA);
        try {
            String strA2 = com.codapayments.sdk.a.a.b.a(this.a, new StringBuffer("apiKey=").append(str).append("&initRequest=").append(URLEncoder.encode(com.codapayments.sdk.a.a.a.a(str, strA), "UTF-8")).toString());
            this.f.registerReceiver(this.j, new IntentFilter(e));
            this.k = true;
            if (strA2 != null && strA2.length() > 0) {
                String strB = com.codapayments.sdk.a.a.a.b(str, strA2);
                Log.i(f.x, "encrptdRespJson : " + strA2);
                Log.i(f.x, "respJson : " + strB);
                this.h = com.codapayments.sdk.message.a.a(strB);
                return this.h;
            }
        } catch (IOException e2) {
            e2.printStackTrace();
            Log.e(f.x, "[ERROR] " + e2);
        } catch (InvalidKeyException e3) {
            e3.printStackTrace();
            Log.e(f.x, "[ERROR] " + e3);
        } catch (NoSuchAlgorithmException e4) {
            e4.printStackTrace();
            Log.e(f.x, "[ERROR] " + e4);
        } catch (BadPaddingException e5) {
            e5.printStackTrace();
            Log.e(f.x, "[ERROR] " + e5);
        } catch (IllegalBlockSizeException e6) {
            e6.printStackTrace();
            Log.e(f.x, "[ERROR] " + e6);
        } catch (NoSuchPaddingException e7) {
            e7.printStackTrace();
            Log.e(f.x, "[ERROR] " + e7);
        }
        this.h = new d(0L, (short) 999, "Please try again in a few minutes. Contact support@codapayments.com or PulsaQ_ID on Yahoo Messenger for help.", "We were unable to complete your purchase", null);
        return this.h;
    }

    public final e a(long j, String str) {
        try {
            String string = new StringBuffer("key=").append(str).append("&txnId=").append(j).toString();
            Log.i(f.x, "params " + string);
            String strA = com.codapayments.sdk.a.a.b.a(this.d, string);
            e();
            if (strA != null && strA.length() > 0) {
                String strB = com.codapayments.sdk.a.a.a.b(str, strA);
                Log.i(f.x, "respJson " + strB);
                return com.codapayments.sdk.message.a.c(strB);
            }
        } catch (IOException e2) {
            e2.printStackTrace();
            Log.e(f.x, "[ERROR] " + e2);
        } catch (InvalidKeyException e3) {
            e3.printStackTrace();
            Log.e(f.x, "[ERROR] " + e3);
        } catch (NoSuchAlgorithmException e4) {
            e4.printStackTrace();
            Log.e(f.x, "[ERROR] " + e4);
        } catch (BadPaddingException e5) {
            e5.printStackTrace();
            Log.e(f.x, "[ERROR] " + e5);
        } catch (IllegalBlockSizeException e6) {
            e6.printStackTrace();
            Log.e(f.x, "[ERROR] " + e6);
        } catch (NoSuchPaddingException e7) {
            e7.printStackTrace();
            Log.e(f.x, "[ERROR] " + e7);
        }
        return new e(j, null, 0.0d, null, (short) 999, "Not able to connect to CodaPay server", "Not able to connect to CodaPay server", null);
    }

    public final com.codapayments.sdk.model.f a(g gVar) {
        try {
            String string = new StringBuffer("key=").append(this.h.e()).append("&txnId=").append(this.h.a()).append("&msisdn=").append(gVar.a()).append("&message=").append(URLEncoder.encode(com.codapayments.sdk.a.a.a.a(this.h.e(), gVar.b()), "UTF-8")).toString();
            Log.i(f.x, "params " + string);
            String strA = com.codapayments.sdk.a.a.b.a(this.c, string);
            if (strA != null && strA.length() > 0) {
                String strB = com.codapayments.sdk.a.a.a.b(this.h.e(), strA);
                Log.i(f.x, "respJson " + strB);
                return com.codapayments.sdk.message.a.d(strB);
            }
        } catch (IOException e2) {
            e2.printStackTrace();
            Log.e(f.x, "[ERROR] " + e2);
        } catch (InvalidKeyException e3) {
            e3.printStackTrace();
            Log.e(f.x, "[ERROR] " + e3);
        } catch (NoSuchAlgorithmException e4) {
            e4.printStackTrace();
            Log.e(f.x, "[ERROR] " + e4);
        } catch (BadPaddingException e5) {
            e5.printStackTrace();
            Log.e(f.x, "[ERROR] " + e5);
        } catch (IllegalBlockSizeException e6) {
            e6.printStackTrace();
            Log.e(f.x, "[ERROR] " + e6);
        } catch (NoSuchPaddingException e7) {
            e7.printStackTrace();
            Log.e(f.x, "[ERROR] " + e7);
        }
        return new com.codapayments.sdk.model.f(this.h.a(), (short) 999, "Not able to connect to CodaPay server", "Not able to connect to CodaPay server", null, null);
    }

    public final d b() {
        return this.h;
    }

    public final String c() {
        return this.i;
    }
}
