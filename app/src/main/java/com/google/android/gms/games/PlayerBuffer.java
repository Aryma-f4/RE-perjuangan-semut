package com.google.android.gms.games;

import com.google.android.gms.common.data.DataBuffer;

/* loaded from: classes.dex */
public final class PlayerBuffer extends DataBuffer<Player> {
    public PlayerBuffer(com.google.android.gms.common.data.d dataHolder) {
        super(dataHolder);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public Player get(int position) {
        return new d(this.S, position);
    }
}
