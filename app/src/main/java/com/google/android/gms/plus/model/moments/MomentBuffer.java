package com.google.android.gms.plus.model.moments;

import com.google.android.gms.common.data.DataBuffer;
import com.google.android.gms.common.data.d;
import com.google.android.gms.internal.cb;

/* loaded from: classes.dex */
public final class MomentBuffer extends DataBuffer<Moment> {
    public MomentBuffer(d dataHolder) {
        super(dataHolder);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public Moment get(int position) {
        return new cb(this.S, position);
    }
}
