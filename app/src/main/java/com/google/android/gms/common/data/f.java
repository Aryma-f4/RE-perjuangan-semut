package com.google.android.gms.common.data;

import java.util.ArrayList;

/* loaded from: classes.dex */
public abstract class f<T> extends DataBuffer<T> {
    private boolean ao;
    private ArrayList<Integer> ap;

    protected f(d dVar) {
        super(dVar);
        this.ao = false;
    }

    private int h(int i) {
        if (i < 0 || i >= this.ap.size()) {
            throw new IllegalArgumentException("Position " + i + " is out of bounds for this buffer");
        }
        return this.ap.get(i).intValue();
    }

    private int i(int i) {
        if (i < 0 || i == this.ap.size()) {
            return 0;
        }
        return i == this.ap.size() - 1 ? this.S.getCount() - this.ap.get(i).intValue() : this.ap.get(i + 1).intValue() - this.ap.get(i).intValue();
    }

    private void m() {
        synchronized (this) {
            if (!this.ao) {
                int count = this.S.getCount();
                this.ap = new ArrayList<>();
                if (count > 0) {
                    this.ap.add(0);
                    String primaryDataMarkerColumn = getPrimaryDataMarkerColumn();
                    String strC = this.S.c(primaryDataMarkerColumn, 0, this.S.e(0));
                    for (int i = 1; i < count; i++) {
                        String strC2 = this.S.c(primaryDataMarkerColumn, i, this.S.e(i));
                        if (!strC2.equals(strC)) {
                            this.ap.add(Integer.valueOf(i));
                            strC = strC2;
                        }
                    }
                }
                this.ao = true;
            }
        }
    }

    protected abstract T a(int i, int i2);

    @Override // com.google.android.gms.common.data.DataBuffer
    public final T get(int position) {
        m();
        return a(h(position), i(position));
    }

    @Override // com.google.android.gms.common.data.DataBuffer
    public int getCount() {
        m();
        return this.ap.size();
    }

    protected abstract String getPrimaryDataMarkerColumn();
}
