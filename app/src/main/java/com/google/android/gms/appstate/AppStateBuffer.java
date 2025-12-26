package com.google.android.gms.appstate;

import com.google.android.gms.common.data.DataBuffer;
import com.google.android.gms.common.data.d;

/* loaded from: classes.dex */
public final class AppStateBuffer extends DataBuffer<AppState> {
    public AppStateBuffer(d dataHolder) {
        super(dataHolder);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public AppState get(int position) {
        return new b(this.S, position);
    }
}
