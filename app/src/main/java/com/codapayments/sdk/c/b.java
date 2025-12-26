package com.codapayments.sdk.c;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import java.math.BigInteger;

/* loaded from: classes.dex */
public final class b {
    private Context a;
    private TelephonyManager b;

    /* JADX WARN: Multi-variable type inference failed */
    public b(Context context) {
        ((com.codapayments.sdk.a.a.a) this).b = context;
        ((com.codapayments.sdk.a.a.a) this).c = (TelephonyManager) context.getSystemService("phone");
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

    /* JADX WARN: Multi-variable type inference failed */
    public final boolean a() {
        if (((com.codapayments.sdk.a.a.a) this).c.isNetworkRoaming()) {
            f.t = true;
            Log.i(f.I, "Network Roaming : ON");
        } else {
            f.t = false;
            Log.i(f.I, "Network Roaming : OFF");
        }
        return f.t;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String b() {
        f.s = ((com.codapayments.sdk.a.a.a) this).c.getSubscriberId();
        Log.i(f.I, "Subscriber ID : " + f.s);
        return f.s;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final int c() {
        f.j = ((com.codapayments.sdk.a.a.a) this).c.getPhoneType();
        Log.i(f.I, "Phone Type : " + f.j);
        return f.j;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final int d() {
        f.h = ((com.codapayments.sdk.a.a.a) this).c.getNetworkType();
        Log.i(f.I, "Network Type : " + f.h);
        return f.h;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String e() {
        f.k = ((com.codapayments.sdk.a.a.a) this).c.getSimCountryIso();
        Log.i(f.I, "Country ISO : " + f.k);
        return f.k;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String f() {
        f.l = ((com.codapayments.sdk.a.a.a) this).c.getSimOperator();
        Log.i(f.I, "SIM Operator : " + f.l);
        return f.l;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String g() {
        f.m = ((com.codapayments.sdk.a.a.a) this).c.getSimOperatorName();
        Log.i(f.I, "SIM Operator Name : " + f.m);
        return f.m;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final int h() {
        f.i = ((com.codapayments.sdk.a.a.a) this).c.getSimState();
        Log.i(f.I, "SIM State : " + f.i);
        return f.i;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String i() {
        f.n = ((com.codapayments.sdk.a.a.a) this).c.getDeviceId();
        Log.i(f.I, "Device ID : " + f.n);
        return f.n;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String k() {
        f.q = ((com.codapayments.sdk.a.a.a) this).c.getSimSerialNumber();
        Log.i(f.I, "Serial Number : " + f.q);
        return f.q;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String l() {
        f.r = ((com.codapayments.sdk.a.a.a) this).c.getNetworkOperator();
        Log.i(f.I, "Operator ID : " + f.r);
        return f.r;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String m() {
        f.p = ((com.codapayments.sdk.a.a.a) this).c.getNetworkOperatorName();
        Log.i(f.I, "Operator Name : " + f.p);
        return f.p;
    }

    /* JADX WARN: Multi-variable type inference failed */
    @SuppressLint({"NewApi"})
    public final com.codapayments.sdk.model.h o() {
        com.codapayments.sdk.model.h hVar = new com.codapayments.sdk.model.h();
        if (com.codapayments.sdk.a.a.a.j() >= 13) {
            Display defaultDisplay = ((WindowManager) ((com.codapayments.sdk.a.a.a) this).b.getSystemService("window")).getDefaultDisplay();
            Point point = new Point();
            defaultDisplay.getSize(point);
            f.e = point.x;
            f.f = point.y;
        } else {
            Display defaultDisplay2 = ((WindowManager) ((com.codapayments.sdk.a.a.a) this).b.getSystemService("window")).getDefaultDisplay();
            f.e = defaultDisplay2.getWidth();
            f.f = defaultDisplay2.getHeight();
        }
        hVar.b(f.e);
        hVar.a(f.f);
        Log.i(f.I, "Screen width : " + String.valueOf(f.e));
        Log.i(f.I, "Screen height : " + String.valueOf(f.f));
        return hVar;
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final BigInteger p() {
        return new BigInteger(q());
    }

    /* JADX WARN: Multi-variable type inference failed */
    public final String q() {
        String str;
        Exception exc;
        String line1Number;
        try {
            line1Number = ((TelephonyManager) ((com.codapayments.sdk.a.a.a) this).b.getSystemService("phone")).getLine1Number();
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

    /* JADX WARN: Multi-variable type inference failed */
    public final com.codapayments.sdk.model.a r() {
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
        aVar.b(String.valueOf(com.codapayments.sdk.a.a.a.j()));
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
