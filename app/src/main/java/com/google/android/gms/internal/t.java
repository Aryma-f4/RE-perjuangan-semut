package com.google.android.gms.internal;

import android.content.Context;
import android.os.IBinder;
import android.view.View;
import com.google.android.gms.dynamic.e;
import com.google.android.gms.internal.q;

/* loaded from: classes.dex */
public final class t extends com.google.android.gms.dynamic.e<q> {
    private static final t ca = new t();

    private t() {
        super("com.google.android.gms.common.ui.SignInButtonCreatorImpl");
    }

    public static View d(Context context, int i, int i2) throws e.a {
        return ca.e(context, i, i2);
    }

    private View e(Context context, int i, int i2) throws e.a {
        try {
            return (View) com.google.android.gms.dynamic.c.a(h(context).a(com.google.android.gms.dynamic.c.f(context), i, i2));
        } catch (Exception e) {
            throw new e.a("Could not get button with size " + i + " and color " + i2, e);
        }
    }

    @Override // com.google.android.gms.dynamic.e
    /* renamed from: j, reason: merged with bridge method [inline-methods] */
    public q k(IBinder iBinder) {
        return q.a.i(iBinder);
    }
}
