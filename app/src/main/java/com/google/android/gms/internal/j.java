package com.google.android.gms.internal;

import com.google.android.gms.common.internal.safeparcel.SafeParcelable;

/* loaded from: classes.dex */
public abstract class j implements SafeParcelable {
    private static final Object bo = new Object();
    private static ClassLoader bp = null;
    private static Integer bq = null;
    private boolean br = false;

    private static boolean a(Class<?> cls) {
        try {
            return SafeParcelable.NULL.equals(cls.getField("NULL").get(null));
        } catch (IllegalAccessException e) {
            return false;
        } catch (NoSuchFieldException e2) {
            return false;
        }
    }

    protected static boolean h(String str) {
        ClassLoader classLoaderU = u();
        if (classLoaderU == null) {
            return true;
        }
        try {
            return a(classLoaderU.loadClass(str));
        } catch (Exception e) {
            return false;
        }
    }

    protected static ClassLoader u() {
        ClassLoader classLoader;
        synchronized (bo) {
            classLoader = bp;
        }
        return classLoader;
    }

    protected static Integer v() {
        Integer num;
        synchronized (bo) {
            num = bq;
        }
        return num;
    }

    protected boolean w() {
        return this.br;
    }
}
