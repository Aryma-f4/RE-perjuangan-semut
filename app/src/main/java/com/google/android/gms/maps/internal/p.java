package com.google.android.gms.maps.internal;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.s;
import com.google.android.gms.maps.internal.c;
import com.google.android.gms.maps.model.RuntimeRemoteException;
import java.security.cert.CertificateException;

/* loaded from: classes.dex */
public class p {
    private static Context gN;
    private static c gO;

    private static <T> T a(ClassLoader classLoader, String str) {
        try {
            return (T) c(((ClassLoader) s.d(classLoader)).loadClass(str));
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("Unable to find dynamic class " + str);
        }
    }

    private static Class<?> bm() {
        try {
            return Class.forName("com.google.android.gms.maps.internal.CreatorImpl");
        } catch (ClassNotFoundException e) {
            return null;
        }
    }

    private static <T> T c(Class<?> cls) {
        try {
            return (T) cls.newInstance();
        } catch (IllegalAccessException e) {
            throw new IllegalStateException("Unable to call the default constructor of " + cls.getName());
        } catch (InstantiationException e2) {
            throw new IllegalStateException("Unable to instantiate the dynamic class " + cls.getName());
        }
    }

    private static Context getRemoteContext(Context context) {
        if (gN == null) {
            if (bm() != null) {
                gN = context;
            } else {
                gN = GooglePlayServicesUtil.getRemoteContext(context);
            }
        }
        return gN;
    }

    public static c i(Context context) throws GooglePlayServicesNotAvailableException, PackageManager.NameNotFoundException, CertificateException {
        s.d(context);
        k(context);
        if (gO == null) {
            l(context);
        }
        if (gO != null) {
            return gO;
        }
        gO = c.a.v((IBinder) a(getRemoteContext(context).getClassLoader(), "com.google.android.gms.maps.internal.CreatorImpl"));
        j(context);
        return gO;
    }

    private static void j(Context context) {
        try {
            gO.a(com.google.android.gms.dynamic.c.f(getRemoteContext(context).getResources()), GooglePlayServicesUtil.GOOGLE_PLAY_SERVICES_VERSION_CODE);
        } catch (RemoteException e) {
            throw new RuntimeRemoteException(e);
        }
    }

    public static void k(Context context) throws GooglePlayServicesNotAvailableException, PackageManager.NameNotFoundException, CertificateException {
        int iIsGooglePlayServicesAvailable = GooglePlayServicesUtil.isGooglePlayServicesAvailable(context);
        if (iIsGooglePlayServicesAvailable != 0) {
            throw new GooglePlayServicesNotAvailableException(iIsGooglePlayServicesAvailable);
        }
    }

    private static void l(Context context) {
        Class<?> clsBm = bm();
        if (clsBm != null) {
            Log.i(p.class.getSimpleName(), "Making Creator statically");
            gO = (c) c(clsBm);
            j(context);
        }
    }
}
