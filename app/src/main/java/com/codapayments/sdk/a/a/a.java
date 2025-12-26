package com.codapayments.sdk.a.a;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Base64;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import com.codapayments.sdk.c.f;
import com.codapayments.sdk.model.h;
import java.math.BigInteger;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

/* loaded from: classes.dex */
public class a {
    private static final String a = "AES";
    private Context b;
    private TelephonyManager c;

    public a() {
    }

    public a(Context context) {
        this.b = context;
        this.c = (TelephonyManager) context.getSystemService("phone");
    }

    @SuppressLint({"TrulyRandom"})
    public static String a(String str, String str2) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException {
        Key keyA = a(str);
        Cipher cipher = Cipher.getInstance(a);
        cipher.init(1, keyA);
        String strEncodeToString = Base64.encodeToString(cipher.doFinal(str2.getBytes("UTF-8")), 0);
        Log.i(f.y, "Encrypted string : " + strEncodeToString);
        return strEncodeToString;
    }

    private static Key a(String str) {
        return new SecretKeySpec(str.getBytes("UTF-8"), a);
    }

    public static String b(String str, String str2) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException {
        Key keyA = a(str);
        Cipher cipher = Cipher.getInstance(a);
        cipher.init(2, keyA);
        return new String(cipher.doFinal(Base64.decode(str2, 0)), "UTF-8");
    }

    public static int j() {
        f.g = Build.VERSION.SDK_INT;
        Log.i(f.I, "Software Version : " + f.g);
        return f.g;
    }

    public static String n() {
        f.o = Build.DEVICE;
        Log.i(f.I, "Device Type : " + f.o);
        return f.o;
    }

    public boolean a() {
        if (this.c.isNetworkRoaming()) {
            f.t = true;
            Log.i(f.I, "Network Roaming : ON");
        } else {
            f.t = false;
            Log.i(f.I, "Network Roaming : OFF");
        }
        return f.t;
    }

    public String b() {
        f.s = this.c.getSubscriberId();
        Log.i(f.I, "Subscriber ID : " + f.s);
        return f.s;
    }

    public int c() {
        f.j = this.c.getPhoneType();
        Log.i(f.I, "Phone Type : " + f.j);
        return f.j;
    }

    public int d() {
        f.h = this.c.getNetworkType();
        Log.i(f.I, "Network Type : " + f.h);
        return f.h;
    }

    public String e() {
        f.k = this.c.getSimCountryIso();
        Log.i(f.I, "Country ISO : " + f.k);
        return f.k;
    }

    public String f() {
        f.l = this.c.getSimOperator();
        Log.i(f.I, "SIM Operator : " + f.l);
        return f.l;
    }

    public String g() {
        f.m = this.c.getSimOperatorName();
        Log.i(f.I, "SIM Operator Name : " + f.m);
        return f.m;
    }

    public int h() {
        f.i = this.c.getSimState();
        Log.i(f.I, "SIM State : " + f.i);
        return f.i;
    }

    public String i() {
        f.n = this.c.getDeviceId();
        Log.i(f.I, "Device ID : " + f.n);
        return f.n;
    }

    public String k() {
        f.q = this.c.getSimSerialNumber();
        Log.i(f.I, "Serial Number : " + f.q);
        return f.q;
    }

    public String l() {
        f.r = this.c.getNetworkOperator();
        Log.i(f.I, "Operator ID : " + f.r);
        return f.r;
    }

    public String m() {
        f.p = this.c.getNetworkOperatorName();
        Log.i(f.I, "Operator Name : " + f.p);
        return f.p;
    }

    @SuppressLint({"NewApi"})
    public h o() {
        h hVar = new h();
        if (j() >= 13) {
            Display defaultDisplay = ((WindowManager) this.b.getSystemService("window")).getDefaultDisplay();
            Point point = new Point();
            defaultDisplay.getSize(point);
            f.e = point.x;
            f.f = point.y;
        } else {
            Display defaultDisplay2 = ((WindowManager) this.b.getSystemService("window")).getDefaultDisplay();
            f.e = defaultDisplay2.getWidth();
            f.f = defaultDisplay2.getHeight();
        }
        hVar.b(f.e);
        hVar.a(f.f);
        Log.i(f.I, "Screen width : " + String.valueOf(f.e));
        Log.i(f.I, "Screen height : " + String.valueOf(f.f));
        return hVar;
    }

    public BigInteger p() {
        return new BigInteger(q());
    }

    public String q() {
        String str;
        Exception exc;
        String line1Number;
        try {
            line1Number = ((TelephonyManager) this.b.getSystemService("phone")).getLine1Number();
        } catch (Exception e) {
            str = null;
            exc = e;
        }
        try {
            Log.i(f.I, "Phone number from Telephony : " + line1Number);
            return line1Number;
        } catch (Exception e2) {
            str = line1Number;
            exc = e2;
            exc.printStackTrace();
            return str;
        }
    }

    public com.codapayments.sdk.model.a r() {
        com.codapayments.sdk.model.a aVar = new com.codapayments.sdk.model.a();
        aVar.a(i());
        aVar.a(o());
        f.o = Build.DEVICE;
        Log.i(f.I, "Device Type : " + f.o);
        aVar.c(f.o);
        aVar.d(l());
        aVar.e(m());
        aVar.a(h());
        aVar.b(c());
        aVar.b(String.valueOf(j()));
        aVar.h(e());
        aVar.f(f());
        aVar.g(g());
        aVar.i(k());
        aVar.c(d());
        aVar.j(b());
        aVar.a(a());
        return aVar;
    }
}
