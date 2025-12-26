package com.google.android.gms.common.data;

import java.util.Iterator;

/* loaded from: classes.dex */
public abstract class DataBuffer<T> implements Iterable<T> {
    protected final d S;

    protected DataBuffer(d dataHolder) {
        this.S = dataHolder;
    }

    public void close() {
        this.S.close();
    }

    public int describeContents() {
        return 0;
    }

    public abstract T get(int i);

    public int getCount() {
        return this.S.getCount();
    }

    public boolean isClosed() {
        return this.S.isClosed();
    }

    @Override // java.lang.Iterable
    public Iterator<T> iterator() {
        return new a(this);
    }
}
