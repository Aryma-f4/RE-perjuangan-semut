package com.google.android.gms.common.data;

import com.google.android.gms.internal.s;
import java.util.Iterator;
import java.util.NoSuchElementException;

/* loaded from: classes.dex */
public final class a<T> implements Iterator<T> {
    private final DataBuffer<T> T;
    private int U = -1;

    public a(DataBuffer<T> dataBuffer) {
        this.T = (DataBuffer) s.d(dataBuffer);
    }

    @Override // java.util.Iterator
    public boolean hasNext() {
        return this.U < this.T.getCount() - 1;
    }

    @Override // java.util.Iterator
    public T next() {
        if (!hasNext()) {
            throw new NoSuchElementException("Cannot advance the iterator beyond " + this.U);
        }
        DataBuffer<T> dataBuffer = this.T;
        int i = this.U + 1;
        this.U = i;
        return dataBuffer.get(i);
    }

    @Override // java.util.Iterator
    public void remove() {
        throw new UnsupportedOperationException("Cannot remove elements from a DataBufferIterator");
    }
}
