package com.google.android.gms.dynamic;

import android.content.Context;
import android.os.IBinder;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.internal.s;

/* loaded from: classes.dex */
public abstract class e<T> {
    private final String dd;
    private T de;

    public static class a extends Exception {
        public a(String str) {
            super(str);
        }

        public a(String str, Throwable th) {
            super(str, th);
        }
    }

    protected e(String str) {
        this.dd = str;
    }

    protected final T h(Context context) throws a {
        if (this.de == null) {
            s.d(context);
            Context remoteContext = GooglePlayServicesUtil.getRemoteContext(context);
            if (remoteContext == null) {
                throw new a("Could not get remote context.");
            }
            try {
                this.de = k((IBinder) remoteContext.getClassLoader().loadClass(this.dd).newInstance());
            } catch (ClassNotFoundException e) {
                throw new a("Could not load creator class.");
            } catch (IllegalAccessException e2) {
                throw new a("Could not access creator.");
            } catch (InstantiationException e3) {
                throw new a("Could not instantiate creator.");
            }
        }
        return this.de;
    }

    protected abstract T k(IBinder iBinder);
}
