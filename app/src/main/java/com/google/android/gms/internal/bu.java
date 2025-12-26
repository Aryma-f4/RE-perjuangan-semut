package com.google.android.gms.internal;

import android.content.Context;
import android.os.IBinder;
import android.view.View;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.bq;
import com.google.android.gms.plus.PlusOneDummyView;

/* loaded from: classes.dex */
public final class bu {
    private static Context gN;
    private static bq iy;

    public static class a extends Exception {
        public a(String str) {
            super(str);
        }
    }

    public static View a(Context context, int i, int i2, String str, int i3) {
        try {
            if (str == null) {
                throw new NullPointerException();
            }
            return (View) com.google.android.gms.dynamic.c.a(m(context).a(com.google.android.gms.dynamic.c.f(context), i, i2, str, i3));
        } catch (Exception e) {
            return new PlusOneDummyView(context, i);
        }
    }

    public static View a(Context context, int i, int i2, String str, String str2) {
        try {
            if (str == null) {
                throw new NullPointerException();
            }
            return (View) com.google.android.gms.dynamic.c.a(m(context).a(com.google.android.gms.dynamic.c.f(context), i, i2, str, str2));
        } catch (Exception e) {
            return new PlusOneDummyView(context, i);
        }
    }

    private static bq m(Context context) throws a {
        s.d(context);
        if (iy == null) {
            if (gN == null) {
                gN = GooglePlayServicesUtil.getRemoteContext(context);
                if (gN == null) {
                    throw new a("Could not get remote context.");
                }
            }
            try {
                iy = bq.a.Z((IBinder) gN.getClassLoader().loadClass("com.google.android.gms.plus.plusone.PlusOneButtonCreatorImpl").newInstance());
            } catch (ClassNotFoundException e) {
                throw new a("Could not load creator class.");
            } catch (IllegalAccessException e2) {
                throw new a("Could not access creator.");
            } catch (InstantiationException e3) {
                throw new a("Could not instantiate creator.");
            }
        }
        return iy;
    }
}
