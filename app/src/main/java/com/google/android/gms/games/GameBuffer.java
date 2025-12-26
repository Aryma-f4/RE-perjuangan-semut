package com.google.android.gms.games;

import com.google.android.gms.common.data.DataBuffer;

/* loaded from: classes.dex */
public final class GameBuffer extends DataBuffer<Game> {
    public GameBuffer(com.google.android.gms.common.data.d dataHolder) {
        super(dataHolder);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public Game get(int position) {
        return new b(this.S, position);
    }
}
