package com.google.android.gms.games.achievement;

import com.google.android.gms.common.data.DataBuffer;
import com.google.android.gms.common.data.d;

/* loaded from: classes.dex */
public final class AchievementBuffer extends DataBuffer<Achievement> {
    public AchievementBuffer(d dataHolder) {
        super(dataHolder);
    }

    /* JADX WARN: Can't rename method to resolve collision */
    @Override // com.google.android.gms.common.data.DataBuffer
    public Achievement get(int position) {
        return new a(this.S, position);
    }
}
