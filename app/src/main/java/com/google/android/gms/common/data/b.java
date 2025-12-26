package com.google.android.gms.common.data;

import android.database.CharArrayBuffer;
import android.net.Uri;
import com.google.android.gms.internal.r;
import com.google.android.gms.internal.s;

/* loaded from: classes.dex */
public abstract class b {
    protected final d S;
    protected final int V;
    private final int W;

    public b(d dVar, int i) {
        this.S = (d) s.d(dVar);
        s.a(i >= 0 && i < dVar.getCount());
        this.V = i;
        this.W = dVar.e(this.V);
    }

    protected void a(String str, CharArrayBuffer charArrayBuffer) {
        this.S.a(str, this.V, this.W, charArrayBuffer);
    }

    protected Uri d(String str) {
        return this.S.f(str, this.V, this.W);
    }

    protected boolean e(String str) {
        return this.S.g(str, this.V, this.W);
    }

    public boolean equals(Object obj) {
        if (!(obj instanceof b)) {
            return false;
        }
        b bVar = (b) obj;
        return r.a(Integer.valueOf(bVar.V), Integer.valueOf(this.V)) && r.a(Integer.valueOf(bVar.W), Integer.valueOf(this.W)) && bVar.S == this.S;
    }

    protected boolean getBoolean(String column) {
        return this.S.d(column, this.V, this.W);
    }

    protected byte[] getByteArray(String column) {
        return this.S.e(column, this.V, this.W);
    }

    protected int getInteger(String column) {
        return this.S.b(column, this.V, this.W);
    }

    protected long getLong(String column) {
        return this.S.a(column, this.V, this.W);
    }

    protected String getString(String column) {
        return this.S.c(column, this.V, this.W);
    }

    public int hashCode() {
        return r.hashCode(Integer.valueOf(this.V), Integer.valueOf(this.W), this.S);
    }

    public boolean isDataValid() {
        return !this.S.isClosed();
    }
}
